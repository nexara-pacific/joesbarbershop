---
phase: 05-aeo-performance-meta
reviewed: 2026-05-10T22:00:00Z
depth: standard
files_reviewed: 24
files_reviewed_list:
  - site/.env.example
  - site/.gitignore
  - site/package.json
  - site/public/robots.txt
  - site/scripts/generate-mtimes.mjs
  - site/scripts/validate-schema.mjs
  - site/src/components/LastUpdated.astro
  - site/src/components/schema/AggregateRating.astro
  - site/src/components/schema/Article.astro
  - site/src/components/schema/FAQPage.astro
  - site/src/components/schema/HairSalon.astro
  - site/src/components/schema/Person.astro
  - site/src/components/schema/Review.astro
  - site/src/components/schema/Service.astro
  - site/src/data/business.json
  - site/src/data/business.ts
  - site/src/layouts/Base.astro
  - site/src/pages/[neighborhood]-barber.astro
  - site/src/pages/[service].astro
  - site/src/pages/2026-east-county-barbershop-cost-guide.astro
  - site/src/pages/about.astro
  - site/src/pages/east-county-traditional-barbershop.astro
  - site/src/pages/faq.astro
  - site/src/pages/index.astro
  - site/src/pages/reviews.astro
findings:
  critical: 4
  warning: 9
  info: 6
  total: 19
status: issues_found
---

# Phase 5: Code Review Report

**Reviewed:** 2026-05-10T22:00:00Z
**Depth:** standard
**Files Reviewed:** 24 (1 file listed twice in config — `site/.env.example` and others — but reviewed unique set)
**Status:** issues_found

## Summary

Phase 5 ships AEO/schema/meta plumbing — HairSalon JSON-LD on every page, per-page schema overlays (Article, FAQPage, Service, Person, Review, AggregateRating), git-mtime-driven dateModified, and a build-time schema validator. The structural design is sound: stable `@id` cross-references hold up, FAQPage emits page-scoped questions only, the validator catches the `</script>` substring pitfall.

That said, the implementation has four BLOCKER-class defects that emit invalid or misleading schema to AI parsers and Google: a placeholder GBP URL leaks into the live `sameAs` array as a "real" reference, `aggregateRating()` produces NaN on empty input and would explode JSON-LD silently, the schema validator's preflight `statSync` throws before its own error handler runs, and Article schema lacks the `publisher.url` + `publisher.logo` Google requires for rich-result eligibility. Nine warnings cover dateModified fallback semantics, hard-coded phone duplication, type-assertion bypasses, and schema/DOM duplication drift risk.

## Critical Issues

### CR-01: Placeholder GBP URL emitted as real sameAs reference on every page

**File:** `site/src/data/business.json:38` (consumed by `site/src/components/schema/HairSalon.astro:32`)
**Issue:** `business.sameAs.gbp` is set to `"https://maps.google.com/?cid=PLACEHOLDER-confirm-with-Joe"`. The `HairSalon.astro` filter `Object.values(business.sameAs).filter((u) => Boolean(u))` only drops empty strings — it does NOT drop placeholder URLs. The schema validator at `site/scripts/validate-schema.mjs` does not check URL well-formedness either. Result: every page's HairSalon JSON-LD ships a `sameAs` entry pointing to a literal "PLACEHOLDER-confirm-with-Joe" URL. Google's entity resolver, Perplexity, and ChatGPT will treat this as a broken/spammy canonical reference and may down-rank the entity or flag the schema as low-quality.

This is a BLOCKER because (a) it ships to production preview the moment Phase 7 deploys, (b) it actively poisons the AEO signal Phase 5 exists to build, and (c) the `_showcase_review_pending` note in business.json acknowledges this URL is unconfirmed but the runtime code treats it as confirmed.

**Fix:**
```json
// business.json — set to empty string until Joe's actual GBP URL is confirmed
"sameAs": {
  "gbp":       "",
  "yelp":      "https://www.yelp.com/biz/joe-s-barbershop-el-cajon",
  ...
}
```
Or, harden the filter in HairSalon.astro to drop placeholder-looking URLs:
```ts
sameAs: Object.values(business.sameAs)
  .filter((u) => Boolean(u) && !u.includes('PLACEHOLDER')),
```

---

### CR-02: `aggregateRating()` produces NaN when ratings object is empty, breaking JSON-LD

**File:** `site/src/data/business.ts:96-104`
**Issue:** The helper divides `weightedSum / totalCount`. If `ratings` is `{}` (e.g., a future config change clears ratings, or a JSON typo orphans the keys), `totalCount === 0` → `0/0 === NaN` → `Number(NaN.toFixed(2)) === NaN`. `JSON.stringify({ ratingValue: NaN })` emits `"ratingValue": null`. The validator at `validate-schema.mjs:44` would then see `val === null` for the required `ratingValue` field and fail the build — but only after writing a broken JSON-LD block. Worse, if the validator misses this edge (e.g., AggregateRating only emitted on homepage but ratings are populated, then a partial dataset slips through), live pages ship an invalid `ratingValue: null` to Google Rich Results.

**Fix:**
```ts
export function aggregateRating(
  ratings: BusinessRecord['ratings']
): { ratingValue: number; reviewCount: number } {
  const sources = Object.values(ratings);
  const totalCount = sources.reduce((sum, r) => sum + r.count, 0);
  if (totalCount === 0) {
    throw new Error('aggregateRating: no rating sources with count > 0');
  }
  const weightedSum = sources.reduce((sum, r) => sum + r.value * r.count, 0);
  const ratingValue = Number((weightedSum / totalCount).toFixed(2));
  return { ratingValue, reviewCount: totalCount };
}
```
Fail loud at build time, not silently at runtime.

---

### CR-03: `validate-schema.mjs` preflight crashes before its own error message can print

**File:** `site/scripts/validate-schema.mjs:99-102`
**Issue:**
```js
if (!statSync(distDir).isDirectory()) {
  console.error(`FAIL: dist directory not found at ${distDir} — run \`npm run build\` first`);
  process.exit(1);
}
```
`statSync()` throws `ENOENT` if `distDir` does not exist — that throw happens **before** the `!` operator can evaluate, so the `console.error` line is unreachable. A developer running the validator before `npm run build` sees a raw Node.js stack trace, not the helpful guidance message that was supposed to be the whole point of this check.

**Fix:**
```js
import { existsSync } from 'node:fs';

if (!existsSync(distDir) || !statSync(distDir).isDirectory()) {
  console.error(`FAIL: dist directory not found at ${distDir} — run \`npm run build\` first`);
  process.exit(1);
}
```

---

### CR-04: Article schema missing `publisher.url` + `publisher.logo` required by Google Rich Results

**File:** `site/src/components/schema/Article.astro:30-34`
**Issue:**
```ts
publisher: {
  '@type': 'Organization',
  '@id': `${canonicalUrl}/#business`,
  name: "Joe's Barbershop",
},
```
Google's Article structured data guidelines (https://developers.google.com/search/docs/appearance/structured-data/article) state Publisher MUST include `logo` as `ImageObject` for the Article to be eligible for rich results (top stories, news carousels, AI summaries). The `@id` reference to `#business` does pull in HairSalon data via entity graph linking, but Google's rich-result validator processes Article in isolation and emits "Publisher logo is required" warnings. With Phase 5's whole purpose being AEO/rich-result eligibility on the two Article-typed pages (niche-landing + cost guide), shipping without publisher.logo defeats the phase goal.

**Fix:**
```ts
publisher: {
  '@type': 'Organization',
  '@id': `${canonicalUrl}/#business`,
  name: "Joe's Barbershop",
  url: canonicalUrl,
  logo: {
    '@type': 'ImageObject',
    url: `${canonicalUrl}/photos/01-logo.jpg`,
  },
},
```

## Warnings

### WR-01: `generate-mtimes.mjs` fallback to FS mtime silently ships build-time as dateModified on Vercel

**File:** `site/scripts/generate-mtimes.mjs:40-50`
**Issue:** Comment at line 8-10 notes Vercel's default shallow clone returns empty git log, then the script falls back to `statSync(absPath).mtime`. On Vercel, `mtime` is the time the file was checked out (essentially "now"), not the actual commit time. So on Vercel without `VERCEL_DEEP_CLONE=1`, every build sets `dateModified` to the build timestamp — which means the Article schema's "this page was updated" signal becomes "this page was updated this morning" on every redeploy, regardless of whether content actually changed. AI parsers that weight freshness will see noisy/meaningless dateModified, which is worse than a stable older date.

Additionally, line 47-48 falls back to `new Date().toISOString()` if even `statSync` fails — which then silently passes through to the build. There's no exit code or build-fail signal.

**Fix:** Make the script fail loud on Vercel when git log returns empty, instead of silently falling back to fs mtime:
```js
const isVercel = process.env.VERCEL === '1';
if (!iso) {
  if (isVercel) {
    console.error(`FAIL: git log returned empty for ${page} on Vercel. Set VERCEL_DEEP_CLONE=1 in project env vars.`);
    process.exit(1);
  }
  // Local dev fallback only
  iso = statSync(absPath).mtime.toISOString();
}
```

---

### WR-02: Phone number hard-coded across pages instead of using `business.phone`

**File:** `site/src/pages/faq.astro:14,22,27,31,35,40,62,140,200,229` and `site/src/pages/index.astro:35` and `site/src/pages/reviews.astro` (none — uses data) and `site/src/pages/east-county-traditional-barbershop.astro:138` (uses data correctly)
**Issue:** The `(619) 891-2775` phone number is hard-coded 10+ times in `faq.astro` (both DOM and parallel schema array), and on `index.astro`'s homepage FAQ array at line 35. If Joe's phone changes, those strings drift from `business.phone`. Worse, `business.phone` IS being read into HairSalon schema via `toE164()` — meaning a phone update would update the schema but leave the visible DOM and FAQ schema arrays stale, creating exactly the schema-mismatches-DOM AEO pitfall the phase warns against (RESEARCH Pitfall 5).

**Fix:** Import `business` and interpolate `{business.phone}` everywhere. Also update the schema FAQ array to use template literals reading from `business.phone`.

---

### WR-03: TypeScript type assertion `as BusinessRecord` bypasses runtime validation

**File:** `site/src/data/business.ts:41`
**Issue:**
```ts
export const business = businessData as BusinessRecord;
```
If `business.json` drifts from the TS interface (e.g., someone renames `priceRange` to `price_range`, or removes the `geo` block), TypeScript reports no error at build — only a runtime crash when a downstream component dereferences the missing field, often in the middle of JSON-LD emission. Astro's build then fails with an opaque "Cannot read properties of undefined" deep in a render pipeline, not "business.json is missing field X".

**Fix:** Use Astro's Content Collections (or a Zod schema) to validate `business.json` at build time:
```ts
import { z } from 'astro/zod';
const BusinessSchema = z.object({ /* ... mirror BusinessRecord ... */ });
export const business = BusinessSchema.parse(businessData);
```

---

### WR-04: `reviewTimestamp()` silently defaults unknown months to January, corrupting sort order

**File:** `site/src/pages/reviews.astro:15-21`
**Issue:**
```ts
const m = MONTHS[mon as keyof typeof MONTHS] ?? 0;
```
If `reviews.json` ever contains "Sept 2024" or "September 2024" (instead of the expected three-letter code "Sep"), the lookup returns `undefined`, defaults to `0` (January), and that review sorts to mid-January of the parsed year. Output order is silently wrong; no warning, no validation failure. Reviews currently use the right format, but the codepath is a landmine for whoever edits the JSON next.

**Fix:**
```ts
function reviewTimestamp(date: string): number {
  if (!date) return 0;
  const [mon, year] = date.split(' ');
  if (!(mon in MONTHS)) {
    throw new Error(`reviewTimestamp: unknown month "${mon}" in date "${date}". Expected three-letter code (Jan, Feb, ...).`);
  }
  const m = MONTHS[mon];
  const y = parseInt(year, 10);
  if (isNaN(y)) throw new Error(`reviewTimestamp: unparseable year in "${date}"`);
  return new Date(y, m).getTime();
}
```

---

### WR-05: Self-published Review schema may violate Google's review snippet policy

**File:** `site/src/components/schema/Review.astro:21-35` (used by `site/src/pages/reviews.astro`)
**Issue:** Per Google's structured data policy (https://developers.google.com/search/docs/appearance/structured-data/review-snippet), a business cannot mark up its own reviews if the reviews live on the business's own site. Google specifically penalizes self-serving review markup. The reviews at `site/src/data/reviews.json` are republished customer quotes from Google + Yelp (per the `_showcase_review_pending` note in business.json) — that republication is the trigger. Google's reviewer guidelines say first-party review markup must come with reviewer-controlled UGC (a real review submission form). This site has no such form.

The schema validator at `validate-schema.mjs` only checks Schema.org required fields, not Google policy compliance. So the build passes, but the live preview risks a Google Search Console manual action for "spammy structured data."

**Fix (one of):**
1. Drop the `Review` schema emission and keep the reviews as plain text only (still AEO-visible to AI parsers).
2. If keeping, add an `itemReviewed` qualifier that makes clear these are aggregated third-party reviews, and verify against Google's current policy at deploy time.

This is a WARNING not BLOCKER because (a) the AggregateRating already references the same data and (b) policy interpretation has changed over the years — verify the current state before shipping.

---

### WR-06: DOM ↔ schema FAQ duplication risks drift; `TODO Phase 7` acknowledges but doesn't mitigate

**File:** `site/src/pages/2026-east-county-barbershop-cost-guide.astro:17-35` (schema) vs `145-172` (DOM); `site/src/pages/east-county-traditional-barbershop.astro:17-42` (schema) vs `127-168` (DOM); `site/src/pages/faq.astro:10-72` (schema) vs `100-217` (DOM); `site/src/pages/index.astro:16-37` (schema) vs `FAQ.astro` component (DOM)
**Issue:** Four files maintain parallel hand-typed FAQ arrays — one for FAQPage JSON-LD, one for visible DOM. The comment `// TODO Phase 7: consolidate DOM ↔ schema array duplication` appears in all four. The cost-guide page already drifts in subtle ways: schema line 33 references "kids cuts and hot-towel shave" as plain text, while DOM line 170 has the same sentence with `<a href>` wrappers — which JSON-LD strips, but a future edit could change wording on one side and not the other.

Per RESEARCH Pitfall 5 cited in `FAQPage.astro`, schema FAQ text must match visible DOM. Drift here = AEO penalty.

**Fix:** Define one FAQ array, render it twice (schema + DOM). The current `[neighborhood]-barber.astro` and `[service].astro` pages already do this correctly via content collections (`entry.data.faqs`). Apply the same pattern to the four hand-rolled pages.

---

### WR-07: Astro DOM expression `${business.prices.haircutBeard}` is NOT a template literal — confusing to maintainers

**File:** `site/src/pages/east-county-traditional-barbershop.astro:152`, `site/src/pages/2026-east-county-barbershop-cost-guide.astro:170`
**Issue:** In Astro templates (outside frontmatter), the syntax `${business.prices.haircut}` renders as `$` (literal) + `{business.prices.haircut}` (JSX expression). This happens to produce the correct output `$30`, but the syntax looks like a JavaScript template literal — which it isn't. Any maintainer who reads `${business.prices.haircut}` will assume it's a JS template literal, get confused when no backticks surround it, and possibly "fix" it to `{business.prices.haircut}` (removing the dollar sign in the process).

The same expression in frontmatter template literals (e.g., line 32 of east-county) IS a template literal and requires `$$` to produce `$30`. The two contexts are visually indistinguishable but semantically different.

**Fix:** For clarity, write `$<span>{business.prices.haircut}</span>` or move the `$` into the data so the price always self-formats: `business.prices.haircut === "$30"`. Or add a comment explaining the dual context.

---

### WR-08: HairSalon `image` hard-codes filename instead of reading `business.photos.hero`

**File:** `site/src/components/schema/HairSalon.astro:16`
**Issue:**
```ts
image: `${canonicalUrl}/photos/03-interior-hero.jpg`,
```
`business.json` line 47 defines `photos.hero: "03-interior-hero.jpg"` precisely so the filename is owned by data, not scattered through components. The same disconnect exists in `Article.astro:28` (hard-codes `02-storefront.jpg`). When photos rotate at Phase 7, schema components will silently reference a deleted file unless every component is hand-edited.

**Fix:**
```ts
image: `${canonicalUrl}/photos/${business.photos.hero}`,
```

---

### WR-09: `availability: 'https://schema.org/InStock'` misapplied to Service Offer

**File:** `site/src/components/schema/Service.astro:28`
**Issue:** `availability: 'https://schema.org/InStock'` is intended for Product inventory states. For a Service Offer, the correct property is typically omitted (services don't have inventory) or set to a Schema.org BusinessFunction. Google's structured-data validator does not flag this as invalid, but the value is semantically wrong and yields zero AEO benefit. Worse, downstream AI parsers that respect Schema.org type discipline may treat the Service Offer as a product offer and ask follow-up questions about stock levels.

**Fix:** Remove the `availability` line. The Offer is valid with just `price` + `priceCurrency`.

## Info

### IN-01: `faq.astro` and `index.astro` repeat the same homepage 5 Q&As across two files

**File:** `site/src/pages/faq.astro:10-72` vs `site/src/pages/index.astro:16-37`
**Issue:** The 5 FAQs on the homepage are a near-exact subset of the 14 on the master FAQ page (hours, walk-ins, payment, kids, location). Phase 7 consolidation already flagged. No action required at v1, but a comment cross-referencing the two arrays would help future editors.

---

### IN-02: `_showcase_review_pending` field bleeds into typed BusinessRecord as optional

**File:** `site/src/data/business.ts:38`
**Issue:** `_showcase_review_pending?: string[]` is typed as optional and could leak into JSON-LD if anyone naively spreads `...business` into a schema object. Unlikely in current code, but the typing pattern suggests data hygiene rather than reviewer notes — consider splitting reviewer notes into a separate JSON file.

---

### IN-03: `robots.txt` allows all crawlers but doesn't include AI-bot directives

**File:** `site/public/robots.txt`
**Issue:** Phase 5 is the AEO phase. The robots.txt is the natural place to explicitly welcome GPTBot, PerplexityBot, Claude-Web, etc. — even though the site is `Allow: /` by default, AI bot owners look for explicit acknowledgment. No correctness issue; opportunity comment.

**Fix (optional, low-effort):**
```
User-agent: GPTBot
Allow: /

User-agent: PerplexityBot
Allow: /

User-agent: ClaudeBot
Allow: /

User-agent: *
Allow: /

Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml
```

---

### IN-04: `.gitignore` lists `.vercel/` twice (lines 24 and 31)

**File:** `site/.gitignore:24,31`
**Issue:** Lines 24 (`.vercel/`) and 31 (`.vercel`) are functionally identical. Harmless, but cleanup is one-line.

---

### IN-05: `package.json` engines pin `>=22.12.0` but no `.nvmrc` or `volta` field

**File:** `site/package.json:5-7`
**Issue:** Developers on local machines without the right Node version get a runtime error rather than auto-switching. Adding `.nvmrc` or `volta.node` lets `nvm use` / Volta handle this. Optional.

---

### IN-06: `Astro.url.href` ends with a trailing `/` on directory routes — `#faq` fragment becomes ugly

**File:** `site/src/components/schema/FAQPage.astro:22`, `site/src/components/schema/Service.astro:18`
**Issue:** `${pageUrl}#faq` produces `https://joesbarbershop.vercel.app/faq/#faq`. Valid URL fragment, but aesthetic. Not a bug.

---

_Reviewed: 2026-05-10T22:00:00Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
