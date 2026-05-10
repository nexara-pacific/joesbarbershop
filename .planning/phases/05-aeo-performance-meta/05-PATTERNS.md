# Phase 5: AEO + Performance + Meta - Pattern Map

**Mapped:** 2026-05-10
**Files analyzed:** 21 (12 NEW, 9 MODIFY)
**Analogs found:** 21 / 21 (every file has a strong analog in-tree; schema components are a new directory but inherit the existing "data-import + props" idiom from existing components)

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `site/src/components/schema/HairSalon.astro` (NEW) | schema component | static transform (`business` → JSON-LD) | `site/src/components/Hero.astro` (frontmatter imports `business`, emits a single semantic block) | role-match — no schema-emitter analog exists yet; closest sibling is any `business`-consuming component |
| `site/src/components/schema/AggregateRating.astro` (NEW) | schema component | static transform | same as HairSalon | role-match |
| `site/src/components/schema/FAQPage.astro` (NEW) | schema component | static transform (props: `faqs[]` → JSON-LD) | `site/src/components/FAQ.astro` (the DOM analog that this JSON-LD mirrors) | role-match (JSON-LD twin of an existing DOM component) |
| `site/src/components/schema/Service.astro` (NEW) | schema component | static transform (props: service entry → JSON-LD) | none; closest data-shape consumer is `site/src/pages/[service].astro` lines 30-47 | role-match |
| `site/src/components/schema/Person.astro` (NEW) | schema component | static transform | none; closest data-shape consumer is `site/src/pages/about.astro` lines 33-48 | role-match |
| `site/src/components/schema/Article.astro` (NEW) | schema component | static transform | none; closest is the `<header class="article-head">` block in `site/src/pages/east-county-traditional-barbershop.astro` lines 21-27 | role-match |
| `site/src/components/schema/Review.astro` (NEW, scoped per CONTEXT "Deferred" line 279) | schema component | static transform (props: reviews[] → JSON-LD) | `site/src/pages/reviews.astro` lines 22-24, 50-66 (DOM rendering of same data) | role-match |
| `site/src/components/LastUpdated.astro` (NEW, OR inline) | display component | static (props: ISO date → human string) | inline `lastUpdated` constant + `<p class="date-stamp">` pattern in `east-county-traditional-barbershop.astro` lines 7, 25 (now becomes data-driven) | role-match |
| `site/public/robots.txt` (NEW) | static asset | static-serve | none in `public/` yet; static-asset-served-as-is convention is implicit (`@astrojs/sitemap` writes `dist/sitemap-*.xml` the same way) | no-direct-analog (trivial 4-line text file) |
| `scripts/validate-schema.mjs` (NEW) | build/CI script | file-I/O (read `dist/**/*.html` → parse JSON-LD → required-field check) | `.planning/phases/03-unique-pages/scripts/audit.sh` `check_homepage_faq` lines 39-49 (file-existence + grep pattern) | role-match — node-script-not-bash, but same "open dist file, extract pattern, assert" idiom |
| `scripts/generate-mtimes.mjs` (NEW) | pre-build hook | file-I/O (read git log → write `src/data/git-mtimes.json`) | `site/src/data/business.json` + `business.ts` import-pair (RESEARCH § Pattern 9 picks this over remark plugin per D-10 Claude discretion) | partial — no pre-build-script analog; output JSON shape mirrors `business.json` |
| `site/.env.example` (NEW) | config doc | static | none in repo; gitignore already excludes `.env`/`.env.production` per `site/.gitignore` line 14-15 | no-direct-analog |
| `site/src/layouts/Base.astro` (MODIFY) | layout | request-response (every page renders through it) | itself (lines 1-35 — extend, don't rewrite) | exact (self-extension) |
| `site/src/data/business.json` (MODIFY) | data source | static config | itself (lines 1-59 — add `geo`, `priceRange` keys) | exact (self-extension) |
| `site/src/data/business.ts` (MODIFY) | typed data export | static (interface + helpers) | itself (lines 5-37 — extend `BusinessRecord` interface, add exported helpers) | exact (self-extension) |
| `site/src/pages/index.astro` (MODIFY) | unique page | request-response | itself + `east-county-traditional-barbershop.astro` (slot=head usage pattern, RESEARCH § Pattern 1) | exact |
| `site/src/pages/about.astro` (MODIFY) | unique page | request-response | itself (lines 1-52) + RESEARCH § Pattern 1 | exact |
| `site/src/pages/reviews.astro` (MODIFY) | unique page | request-response | itself (lines 1-68) | exact |
| `site/src/pages/faq.astro` (MODIFY) | unique page | request-response | itself (lines 1-181) | exact |
| `site/src/pages/east-county-traditional-barbershop.astro` (MODIFY) | unique page (Article archetype) | request-response | itself (lines 1-122) | exact |
| `site/src/pages/2026-east-county-barbershop-cost-guide.astro` (MODIFY) | unique page (Article archetype) | request-response | itself + niche-landing | exact |
| `site/src/pages/[service].astro` (MODIFY) | dynamic-route page | request-response (SSG via `getStaticPaths`) | itself (lines 1-156) | exact |
| `site/src/pages/[neighborhood]-barber.astro` (MODIFY) | dynamic-route page | request-response (SSG) | itself (lines 1-138) | exact |
| `.planning/phases/03-unique-pages/scripts/audit.sh` (MODIFY) | bash test/validation | file-I/O over `dist/` | itself — `check_*` functions lines 39-383 | exact (extend with 6 new `check_*` functions in same idiom) |

---

## Pattern Assignments

### `site/src/components/schema/HairSalon.astro` (NEW — schema component, auto-injected by Base.astro)

**Analog:** `site/src/components/Hero.astro` (closest existing `business`-consuming component) — for the import-from-data pattern. RESEARCH § Pattern 1 supplies the canonical JSON-LD-via-`set:html` shape.

**Imports pattern** (mirror `Hero.astro` lines 1-5, but no Picture/photo — JSON-LD only):

```astro
---
import { business, toE164, toOpeningHoursSpecification, canonicalUrl } from '../../data/business';

const schema = {
  '@context': 'https://schema.org',
  '@type': 'HairSalon',
  '@id': `${canonicalUrl}/#business`,
  name: business.name,
  url: canonicalUrl,
  telephone: toE164(business.phone),
  priceRange: business.priceRange,
  address: {
    '@type': 'PostalAddress',
    streetAddress: `${business.address.street} ${business.address.suite}`.trim(),
    addressLocality: business.address.city,
    addressRegion: business.address.state,
    postalCode: business.address.zip,
    addressCountry: 'US',
  },
  geo: {
    '@type': 'GeoCoordinates',
    latitude: business.geo.latitude,
    longitude: business.geo.longitude,
  },
  openingHoursSpecification: toOpeningHoursSpecification(business.hours),
  sameAs: Object.values(business.sameAs).filter(Boolean),
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Why `set:html` + `JSON.stringify`:** RESEARCH § Pattern 1 explicit Astro recommendation. `set:html` bypasses Astro's default HTML escaping (which would mangle the JSON quotes). `JSON.stringify` produces well-formed JSON.

**Critical safety check** (per RESEARCH § Pattern 1 caveat): `validate-schema.mjs` must assert no rendered JSON-LD block contains the literal `</script>` substring outside the closing tag. Today every `business` field is short proper nouns / URLs / numbers — risk zero — but the audit costs nothing.

**No `<style>` block.** Schema components emit zero DOM and zero CSS — pure script-tag. (Project convention: scoped CSS per Phase 2 D-11; here there's nothing to scope.)

---

### `site/src/components/schema/AggregateRating.astro` (NEW — homepage-only per D-08)

**Analog:** same data-import pattern as HairSalon.astro. Reads `business.ratings` (already populated lines 28-31 of `business.json`).

**Imports pattern:**

```astro
---
import { business, aggregateRating, canonicalUrl } from '../../data/business';

const rating = aggregateRating(business.ratings);  // helper returns { ratingValue, reviewCount } per D-04

const schema = {
  '@context': 'https://schema.org',
  '@type': 'AggregateRating',
  itemReviewed: { '@id': `${canonicalUrl}/#business` },  // entity dedup per D-07
  ratingValue: rating.ratingValue,
  reviewCount: rating.reviewCount,
  bestRating: 5,
  worstRating: 1,
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Embedding choice:** D-08 says homepage only. Per spec, `AggregateRating` can be embedded inside the HairSalon block as a nested property OR emitted as a sibling block with `itemReviewed: { '@id': ... }` pointing at the business. Planner's discretion in CONTEXT — both work. Sibling-with-`@id` is cleaner for component composition (HairSalon stays untouched on the 16 other pages).

---

### `site/src/components/schema/FAQPage.astro` (NEW — emitted by FAQ-bearing pages)

**Analog:** `site/src/components/FAQ.astro` lines 13-47 (the DOM source-of-truth this JSON-LD mirrors). Also see `[service].astro` lines 141-149 and `[neighborhood]-barber.astro` lines 124-132 for the `entry.data.faqs` shape this component receives.

**Props shape — copy from existing `faqs` consumer at `[service].astro` lines 141-149:**

```astro
---
interface Props {
  faqs: Array<{ q: string; a: string }>;
  pageUrl: string;
}

const { faqs, pageUrl } = Astro.props;

const schema = {
  '@context': 'https://schema.org',
  '@type': 'FAQPage',
  '@id': `${pageUrl}#faq`,
  mainEntity: faqs.map(({ q, a }) => ({
    '@type': 'Question',
    name: q,
    acceptedAnswer: {
      '@type': 'Answer',
      text: a,
    },
  })),
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Note re Google's 2026-05-07 FAQPage deprecation:** Per RESEARCH § Summary point 3, **emit it anyway** — ChatGPT/Perplexity/Gemini/Google AI Mode all still parse it. The deprecation is rich-snippet-only.

**Usage at the call site** (copy the receiving page's existing FAQ-data wiring):

- `index.astro` — has 5 inline FAQ items in `FAQ.astro` (currently hard-coded); planner picks: hand-author a `faqs` array constant in `index.astro` mirroring those 5 items, OR refactor `FAQ.astro` to accept items as props. Either gates a single `<FAQPage faqs={...} />` injection.
- `east-county-traditional-barbershop.astro` — 6 inline FAQ items in lines 74-115; planner refactors into a `faqs` array constant (same pattern as `[service].astro`) and feeds both DOM + schema.
- `2026-east-county-barbershop-cost-guide.astro` — 4 inline FAQ items in lines 100-127; same refactor.
- `faq.astro` — 14 FAQ items in 5 category groups (lines 33-146); planner extracts into an array (preserving the 5 `<h2>` category headings in DOM but flattening for JSON-LD).
- `[service].astro` — already reads `entry.data.faqs`; one-line add: `<FAQPage faqs={entry.data.faqs} pageUrl={Astro.url.href} slot="head" />`.
- `[neighborhood]-barber.astro` — same pattern.

---

### `site/src/components/schema/Service.astro` (NEW — emitted by `[service].astro`)

**Analog:** `site/src/pages/[service].astro` lines 30-47 (the data this component consumes — `entry.data.title`, `entry.data.price`, `entry.data.duration`, `entry.data.bluf`).

**Props shape:**

```astro
---
import { business, canonicalUrl } from '../../data/business';
import type { CollectionEntry } from 'astro:content';

interface Props {
  entry: CollectionEntry<'services'>;
  pageUrl: string;
}

const { entry, pageUrl } = Astro.props;

const schema = {
  '@context': 'https://schema.org',
  '@type': 'Service',
  '@id': `${pageUrl}#service`,
  name: entry.data.title,
  description: entry.data.bluf,
  provider: { '@id': `${canonicalUrl}/#business` },  // D-07 entity dedup
  areaServed: business.areaServed.map((name) => ({ '@type': 'Place', name })),
  offers: {
    '@type': 'Offer',
    price: entry.data.price,
    priceCurrency: 'USD',
    availability: 'https://schema.org/InStock',
  },
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Deferred per CONTEXT line 282:** Full `PriceSpecification` with `priceType` + `eligibleQuantity` is overkill; basic `Offer` is enough.

---

### `site/src/components/schema/Person.astro` (NEW — emitted by `/about` only per D-09)

**Analog:** `site/src/pages/about.astro` lines 26-48 (the DOM source of truth — Joe's name, role, founding date, ratings).

**Props shape:**

```astro
---
import { canonicalUrl } from '../../data/business';

interface Props {
  name: string;          // "Joe Denesowicz"
  jobTitle: string;      // "Owner & Barber"
  description: string;   // Joe's bio summary
  slug: string;          // "joe-denesowicz" — used in @id
}

const { name, jobTitle, description, slug } = Astro.props;

const schema = {
  '@context': 'https://schema.org',
  '@type': 'Person',
  '@id': `${canonicalUrl}/#${slug}`,    // D-07 stable @id per person
  name,
  jobTitle,
  description,
  worksFor: { '@id': `${canonicalUrl}/#business` },  // dedup link to HairSalon
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Alex no longer cutting** (per CONTEXT D-09): single-Person emission, not two.

---

### `site/src/components/schema/Article.astro` (NEW — emitted by niche-landing + cost guide per D-09)

**Analog:** `site/src/pages/east-county-traditional-barbershop.astro` lines 21-27 (the visible header this JSON-LD mirrors) + RESEARCH § Pattern 2 (schema-dts typing).

**Props shape with schema-dts typing (RESEARCH § Pattern 2):**

```astro
---
import type { Article, WithContext } from 'schema-dts';
import { canonicalUrl } from '../../data/business';

interface Props {
  headline: string;
  description: string;
  url: string;
  datePublished: string;  // hand-set per page (e.g., '2026-05-01')
  dateModified: string;   // ISO 8601 from git-mtimes.json (D-10)
  authorName: string;     // "Joe Denesowicz" or "Darrell Tang"
}

const { headline, description, url, datePublished, dateModified, authorName } = Astro.props;

const schema: WithContext<Article> = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline,
  description,
  url,
  datePublished,
  dateModified,
  author: { '@type': 'Person', name: authorName },
  publisher: { '@id': `${canonicalUrl}/#business` },
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Why schema-dts here but not in other schema components:** Article + AggregateRating are the most schema-required-field-sensitive types. Type-safety pays off most where Google's Rich Results Test is strictest (D-25 manual gate). Other components can adopt the same pattern incrementally; planner discretion.

**Note re Google's "Article needs `image`" gotcha** (per CONTEXT § specifics + D-25): Google flags Articles without `image`. **OG image is deferred to v1.5 (D-15).** Planner may add `image` field with a placeholder/storefront URL string OR accept the D-25 manual-gate warning. Recommend: emit `image: [siteUrl + '/photos/02-storefront.jpg']` as a defensive default; the storefront image is the most universally appropriate of the 6 available photos until Joe sends new photos.

---

### `site/src/components/schema/Review.astro` (NEW — emitted by `/reviews` per CONTEXT line 279)

**Analog:** `site/src/pages/reviews.astro` lines 22-24, 50-66 (sortedReviews iteration + the DOM the JSON-LD mirrors).

**Props shape (consumes the already-sorted array):**

```astro
---
import { canonicalUrl } from '../../data/business';

interface ReviewItem {
  name: string;
  rating: number;
  quote: string;
  source: string;
  date: string;
}

interface Props {
  reviews: ReviewItem[];
}

const { reviews } = Astro.props;

const schema = reviews.map((r) => ({
  '@context': 'https://schema.org',
  '@type': 'Review',
  itemReviewed: { '@id': `${canonicalUrl}/#business` },  // D-07 dedup
  author: { '@type': 'Person', name: r.name },
  reviewRating: {
    '@type': 'Rating',
    ratingValue: r.rating,
    bestRating: 5,
    worstRating: 1,
  },
  reviewBody: r.quote,
  publisher: { '@type': 'Organization', name: r.source },  // "Google" or "Yelp"
  datePublished: r.date,  // "Sep 2021" form — Schema.org accepts year-month
}));
---
{schema.map((s) => (
  <script type="application/ld+json" set:html={JSON.stringify(s)} />
))}
```

**Emit-one-block-per-review** vs. wrap-in-array: emitting one `<script>` per review keeps each Review entity discoverable individually by parsers that don't walk array-typed JSON-LD. Multi-block emission is normal; AEO parsers accumulate.

---

### `site/src/components/LastUpdated.astro` (NEW — visible "Last updated: ..." line per D-11)

**Analog:** `east-county-traditional-barbershop.astro` line 7 (`const lastUpdated = 'May 2026';`) + line 25 (`<p class="date-stamp">UPDATED {lastUpdated.toUpperCase()}</p>`). Phase 5 swaps the hand-set string for the git-mtime-derived value.

**Pattern:**

```astro
---
interface Props {
  isoDate: string;  // '2026-05-10T14:23:00-07:00' from git-mtimes.json
}

const { isoDate } = Astro.props;

const date = new Date(isoDate);
const human = date.toLocaleDateString('en-US', {
  year: 'numeric',
  month: 'long',
  day: 'numeric',
});  // → "May 10, 2026"
---
<p class="last-updated">Last updated: {human}</p>

<style>
  /* Per CONTEXT D-11: small line near the top, between BLUF and prose. */
  .last-updated {
    font-family: var(--font-board);
    text-transform: uppercase;
    letter-spacing: 0.16em;
    font-size: 11.5px;
    font-weight: 600;
    color: var(--muted);
    margin: 0;
    padding-block: 16px;
  }
</style>
```

**Style values copied verbatim from** `east-county-traditional-barbershop.astro` lines 140-147 (`.date-stamp` rule) — same font-board uppercase + letter-spacing as the existing UPDATED MAY 2026 line, so the new visible date-line matches existing visual treatment.

**Decision per D-11:** rendered only on cost guide + niche-landing. Other pages keep the existing hand-set `UPDATED MAY 2026` kicker until measurement decides whether to widen (Phase 7).

**Inline alternative:** If the planner prefers, skip the component file and inline this logic into the two consumer pages (4 lines each). Both defensible — CONTEXT § Claude's Discretion line 116 calls this a planner choice.

---

### `site/public/robots.txt` (NEW per D-18)

**Analog:** none in `public/`. `@astrojs/sitemap` writes `dist/sitemap-index.xml` + `dist/sitemap-0.xml` (RESEARCH § Pattern 8) — robots.txt joins as a sibling static asset.

**Content (verbatim per D-18):**

```
User-agent: *
Allow: /

Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml
```

**Why `sitemap-index.xml` not `sitemap.xml`:** RESEARCH § Pattern 8 + § Summary point 1 — `@astrojs/sitemap@3.7.2` emits `sitemap-index.xml` as the index (which points at `sitemap-0.xml` for the actual URL list). Already correct in D-18.

**Domain swap deferred to v1.5 / Phase 7** when custom domain lands.

---

### `scripts/validate-schema.mjs` (NEW — called by audit.sh D-23.1)

**Analog:** `.planning/phases/03-unique-pages/scripts/audit.sh` `check_homepage_faq` lines 39-49 (file-existence + extraction + count assertion idiom). New script is node, not bash, but same shape.

**Pattern (per RESEARCH § Standard Stack + D-23.1):**

```javascript
#!/usr/bin/env node
import { readFileSync, readdirSync } from 'node:fs';
import { join } from 'node:path';
import { load } from 'cheerio';

const DIST = join(process.cwd(), 'site', 'dist');

// Required-field manifest — hand-rolled per D-23.1 ("schema-dts is types-only").
const REQUIRED = {
  HairSalon:        ['name', 'address', 'telephone', 'openingHoursSpecification'],
  FAQPage:          ['mainEntity'],
  Service:          ['name', 'provider', 'offers'],
  Person:           ['name'],
  Article:          ['headline', 'datePublished', 'dateModified', 'author'],
  AggregateRating:  ['ratingValue', 'reviewCount'],
  Review:           ['author', 'reviewRating', 'reviewBody'],
};

let failed = 0;

function checkHtml(filepath) {
  const html = readFileSync(filepath, 'utf8');
  const $ = load(html);

  // RESEARCH § Pattern 1 safety: assert no </script> inside JSON-LD body
  $('script[type="application/ld+json"]').each((_, el) => {
    const text = $(el).html() ?? '';
    if (text.includes('</script>')) {
      console.error(`FAIL: ${filepath} — JSON-LD contains literal '</script>'`);
      failed++;
      return;
    }
    let parsed;
    try {
      parsed = JSON.parse(text);
    } catch (err) {
      console.error(`FAIL: ${filepath} — unparseable JSON-LD: ${err.message}`);
      failed++;
      return;
    }
    const blocks = Array.isArray(parsed) ? parsed : [parsed];
    for (const block of blocks) {
      const type = block['@type'];
      const required = REQUIRED[type] ?? [];
      const missing = required.filter((f) => !(f in block));
      if (missing.length > 0) {
        console.error(`FAIL: ${filepath} — ${type} missing required: ${missing.join(', ')}`);
        failed++;
      }
    }
  });
}

function walk(dir) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) walk(full);
    else if (entry.name.endsWith('.html')) checkHtml(full);
  }
}

walk(DIST);
process.exit(failed > 0 ? 1 : 0);
```

**Why cheerio over regex:** RESEARCH § Alternatives Considered — cheerio is the dominant choice (200M+ weekly downloads); regex on HTML is brittle. JSON parsing handles `</script>` escaping correctly only after extraction.

---

### `scripts/generate-mtimes.mjs` (NEW — pre-build hook per D-10)

**Analog:** `site/src/data/business.json` (output shape — JSON dictionary the build imports). RESEARCH § Pattern 9 recommends a pre-build node script over the remark plugin for raw `.astro` pages.

**Pattern:**

```javascript
#!/usr/bin/env node
import { execSync } from 'node:child_process';
import { writeFileSync } from 'node:fs';
import { join } from 'node:path';

// Pages whose dateModified is consumed by Article schema or LastUpdated component.
const PAGES = [
  'site/src/pages/east-county-traditional-barbershop.astro',
  'site/src/pages/2026-east-county-barbershop-cost-guide.astro',
];

const mtimes = {};

for (const page of PAGES) {
  try {
    const iso = execSync(`git log -1 --format=%cI -- ${page}`, { encoding: 'utf8' }).trim();
    if (!iso) throw new Error('no git history');
    mtimes[page] = iso;
  } catch (err) {
    // Fallback for unstaged changes — use filesystem mtime
    console.warn(`WARN: ${page} — git mtime unavailable (${err.message}); falling back to fs mtime`);
    const { statSync } = await import('node:fs');
    mtimes[page] = statSync(page).mtime.toISOString();
  }
}

writeFileSync(
  join(process.cwd(), 'site', 'src', 'data', 'git-mtimes.json'),
  JSON.stringify(mtimes, null, 2) + '\n',
);
```

**Wiring:** Update `site/package.json` `scripts.build` from `astro build` to `node ../scripts/generate-mtimes.mjs && astro build` (or equivalent prebuild hook). Add `git-mtimes.json` to `site/.gitignore` (generated file).

**Consumer side — niche-landing + cost guide page frontmatter:**

```astro
---
import mtimes from '../data/git-mtimes.json';
const dateModified = mtimes['site/src/pages/east-county-traditional-barbershop.astro'];
---
```

---

### `site/.env.example` (NEW per D-03)

**Analog:** none — first env file in the repo.

**Content:**

```
# Microsoft Clarity project ID (public; safe to commit this example file).
# Get a project ID at https://clarity.microsoft.com — create one named "Joe's Barbershop".
# Set in Vercel project settings → Environment Variables for Preview + Production.
# Local dev does NOT need this — Clarity is gated by import.meta.env.PROD.
PUBLIC_CLARITY_PROJECT_ID=
```

**Gitignore confirmation:** `site/.gitignore` line 14-15 already excludes `.env` + `.env.production`. `.env.example` is intentionally committed as documentation.

---

### `site/src/layouts/Base.astro` (MODIFY — schema auto-inject + meta + telemetry)

**Analog:** itself, lines 1-35. Extend; don't rewrite.

**Existing imports + props** (lines 1-14):

```astro
---
import UtilBar from '../components/UtilBar.astro';
import Masthead from '../components/Masthead.astro';
import Footer from '../components/Footer.astro';
import '../styles/tokens.css';
import '../styles/utilities.css';

interface Props {
  title: string;
  description?: string;
  variant?: 'page' | 'article';
}

const { title, description, variant = 'page' } = Astro.props;
---
```

**Extended (RESEARCH § Pattern 6 + Patterns 3-4):**

```astro
---
import UtilBar from '../components/UtilBar.astro';
import Masthead from '../components/Masthead.astro';
import Footer from '../components/Footer.astro';
import HairSalon from '../components/schema/HairSalon.astro';
import Analytics from '@vercel/analytics/astro';
import SpeedInsights from '@vercel/speed-insights/astro';
import '../styles/tokens.css';
import '../styles/utilities.css';

interface Props {
  title: string;
  description?: string;
  variant?: 'page' | 'article';
  ogType?: 'website' | 'article';
  twitterCard?: 'summary' | 'summary_large_image';
}

const {
  title,
  description,
  variant = 'page',
  ogType = 'website',
  twitterCard = 'summary',
} = Astro.props;

const canonicalUrl = new URL(Astro.url.pathname, Astro.site).href;
const siteName = "Joe's Barbershop";

const clarityId = import.meta.env.PUBLIC_CLARITY_PROJECT_ID;
const enableClarity = import.meta.env.PROD && clarityId;
---
```

**Extended `<head>`** (insertion after existing line 22 `<meta description>` block — preserve every existing line; add OG/Twitter + canonical + telemetry + auto HairSalon):

```astro
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title}</title>
    {description && <meta name="description" content={description} />}
    <link rel="canonical" href={canonicalUrl} />

    <!-- Open Graph (D-15: text-only for v1; image deferred to v1.5) -->
    <meta property="og:type" content={ogType} />
    <meta property="og:title" content={title} />
    {description && <meta property="og:description" content={description} />}
    <meta property="og:url" content={canonicalUrl} />
    <meta property="og:site_name" content={siteName} />

    <!-- Twitter Card (D-15: summary; no twitter:site — Joe has no handle) -->
    <meta name="twitter:card" content={twitterCard} />
    <meta name="twitter:title" content={title} />
    {description && <meta name="twitter:description" content={description} />}

    <!-- Existing font preconnects (lines 23-25) — unchanged -->
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IM+Fell+English:ital@0;1&family=Playfair+Display:wght@600;800;900&family=DM+Serif+Display:ital@0;1&family=Newsreader:opsz,wght@6..72,400;6..72,500;6..72,600&family=Oswald:wght@500;600;700&family=JetBrains+Mono:wght@500&display=swap" />

    <!-- Auto-injected HairSalon JSON-LD per D-06 -->
    <HairSalon />

    <!-- Per-page schema overlays consumed here per Phase 2 D-26 -->
    <slot name="head" />

    <!-- Vercel telemetry (self-disables in dev) -->
    <Analytics />
    <SpeedInsights />

    <!-- Microsoft Clarity (D-02: PROD-gated) -->
    {enableClarity && (
      <script is:inline define:vars={{ clarityId }}>
        (function(c,l,a,r,i,t,y){
          c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
          t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
          y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
        })(window, document, "clarity", "script", clarityId);
      </script>
    )}
  </head>
  <body>
    <UtilBar />
    <Masthead />
    <main class={variant === 'article' ? 'article-page' : undefined}><slot /></main>
    <Footer />
  </body>
</html>
```

**Critical preservation:** lines 23-25 font links + lines 28-33 body structure must remain exactly as they are. Phase 5 only adds; it does not rearrange.

---

### `site/src/data/business.json` (MODIFY — add geo + priceRange per D-04)

**Analog:** itself, lines 1-59. Additive only.

**Added fields** (insert near top, after `address` block):

```json
{
  "name": "Joe's Barbershop",
  "address": { ... },
  "geo": {
    "latitude": 32.8211,
    "longitude": -116.9303
  },
  "priceRange": "$$",
  "phone": "(619) 891-2775",
  ...
}
```

**Geocoding source:** CONTEXT D-04 + § Claude's Discretion (line 125): planner picks. Recommended: Google Maps URL fragment hand-pasted, hand-verified — the address geocodes consistently. Values above are placeholder estimates; planner re-verifies.

**`priceRange`:** D-04 fixes `"$$"` per Schema.org convention for $30 average ticket.

**No removals.** The `_showcase_review_pending` array (lines 47-58) stays — it's the showcase open-questions list.

---

### `site/src/data/business.ts` (MODIFY — extend interface + add helpers per D-04)

**Analog:** itself, lines 1-37. Extend `BusinessRecord` interface; add three new exported helpers + a `canonicalUrl` constant.

**Extended interface:**

```typescript
interface BusinessRecord {
  name: string;
  address: {
    street: string;
    suite: string;
    city: string;
    state: string;
    zip: string;
  };
  geo: {                    // NEW (D-04)
    latitude: number;
    longitude: number;
  };
  priceRange: string;       // NEW (D-04)
  phone: string;
  hours: Record<string, HoursEntry | null>;
  prices: { ... };
  ratings: Record<string, { value: number; count: number; asOf: string }>;
  sameAs: Record<string, string>;
  photos: Record<string, string>;
  areaServed: string[];
  _showcase_review_pending?: string[];
}
```

**New helpers** (appended after the existing `export const business`):

```typescript
// E.164 phone helper per D-04 — schema requires +CC format.
export function toE164(displayPhone: string): string {
  const digits = displayPhone.replace(/\D/g, '');
  return digits.startsWith('1') ? `+${digits}` : `+1${digits}`;
}

// Schema.org dayOfWeek values — note title-case, not Astro/JS Date weekday strings.
const DOW_TITLE: Record<string, string> = {
  monday: 'Monday', tuesday: 'Tuesday', wednesday: 'Wednesday',
  thursday: 'Thursday', friday: 'Friday', saturday: 'Saturday', sunday: 'Sunday',
};

// openingHoursSpecification helper per D-04 — maps business.hours to schema array.
// Skips days where hours are null (Sun, Mon per business.json line 17-18).
export function toOpeningHoursSpecification(hours: BusinessRecord['hours']) {
  return Object.entries(hours)
    .filter(([_, h]) => h !== null)
    .map(([day, h]) => ({
      '@type': 'OpeningHoursSpecification',
      dayOfWeek: DOW_TITLE[day],
      opens: h!.open,    // "HH:MM" 24-hour — already correct in business.json
      closes: h!.close,
    }));
}

// aggregateRating helper per D-04 — combines Google + Yelp via weighted average.
// Returns { ratingValue, reviewCount } for the AggregateRating schema component.
export function aggregateRating(ratings: BusinessRecord['ratings']) {
  const sources = Object.values(ratings);
  const totalCount = sources.reduce((sum, r) => sum + r.count, 0);
  const weightedSum = sources.reduce((sum, r) => sum + r.value * r.count, 0);
  const ratingValue = Number((weightedSum / totalCount).toFixed(2));
  return { ratingValue, reviewCount: totalCount };
  // Yields: (5.0*114 + 4.9*33) / (114+33) = 4.98 across 147 reviews (D-04).
  // Planner may swap for "pick the higher source" — both defensible per D-04.
}

// Canonical URL per CONTEXT § specifics line 258 — single source.
// When custom domain lands (v1.5 / Phase 7), update this one constant.
export const canonicalUrl = 'https://joesbarbershop.vercel.app';
```

**Why exported as named functions vs inline:** RESEARCH § Pattern 1 reads `business.priceRange` + `toE164(business.phone)` + `toOpeningHoursSpecification(business.hours)` directly. Functions colocate the transform with the source data.

---

### `site/src/pages/index.astro` (MODIFY — HairSalon already auto-injected via Base; add AggregateRating overlay; hero fetchpriority)

**Analog:** itself, lines 1-27. Hero already uses `fetchpriority="high"` (verified: `Hero.astro` line 33). Phase 5 work: add AggregateRating slot, possibly add `<FAQPage>` slot if Phase 5 chooses to wire homepage FAQ schema (5-6 FAQs hard-coded in `FAQ.astro`).

**Pattern — slot=head usage** (first consumption in the codebase; per Phase 2 D-26 reservation):

```astro
---
import Base from '../layouts/Base.astro';
import AggregateRating from '../components/schema/AggregateRating.astro';
import FAQPage from '../components/schema/FAQPage.astro';
import CheckDivider from '../components/CheckDivider.astro';
import Hero from '../components/Hero.astro';
import FactStrip from '../components/FactStrip.astro';
import PriceBoard from '../components/PriceBoard.astro';
import Heritage from '../components/Heritage.astro';
import Visit from '../components/Visit.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';

// Mirror the 5 FAQs that FAQ.astro currently hard-codes — planner picks: refactor FAQ.astro
// to accept faqs[] as props, OR mirror inline here. Per CONTEXT § Discretion either works.
const homepageFaqs = [
  { q: 'Do I need an appointment?', a: 'No appointment needed. Walk-ins are always welcome Tuesday through Saturday...' },
  // ... 4 more, copy from FAQ.astro lines 13-47
];
---
<Base
  title="Joe's Barbershop — Bostonia, El Cajon"
  description="Traditional barbershop in Bostonia, East County San Diego. Walk-ins welcome, cash only. Tue–Sat 10am–7:30pm."
>
  <Fragment slot="head">
    <AggregateRating />
    <FAQPage faqs={homepageFaqs} pageUrl={Astro.url.href} />
  </Fragment>
  <CheckDivider />
  <Hero />
  <!-- ... existing body unchanged ... -->
</Base>
```

**`<Fragment slot="head">` mechanism:** Astro pattern for passing multiple slot fragments. Lands inside Base.astro's `<slot name="head" />` (now consumed for the first time).

**Hero `fetchpriority="high"`** is already set (see Hero.astro line 33). Phase 5 verifies; no edit needed.

---

### `site/src/pages/about.astro` (MODIFY — add Person schema)

**Analog:** itself, lines 1-52.

**Edit:** import + slot fill.

```astro
---
import Base from '../layouts/Base.astro';
import Person from '../components/schema/Person.astro';
import Visit from '../components/Visit.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';

const lastUpdated = 'May 2026';

const joeDescription = "Joe Denesowicz opened Joe's Barbershop in 2020 in Bostonia, El Cajon. Owner and barber for the shop's only barber chair as of 2026.";
---

<Base
  title="About Joe Denesowicz · Joe's Barbershop"
  description="Joe Denesowicz opened Joe's Barbershop in 2020 in Bostonia, El Cajon. Traditional barbering, walk-ins welcome."
  variant="article"
>
  <Fragment slot="head">
    <Person name="Joe Denesowicz" jobTitle="Owner & Barber" description={joeDescription} slug="joe-denesowicz" />
  </Fragment>
  <!-- existing body (lines 15-52) unchanged -->
</Base>
```

**Alex no longer cutting per CONTEXT D-09:** single Person emission only.

---

### `site/src/pages/reviews.astro` (MODIFY — add Review array schema)

**Analog:** itself, lines 1-68.

**Edit:** import Review schema component, fill head slot with the already-sorted array.

```astro
---
import Base from '../layouts/Base.astro';
import Review from '../components/schema/Review.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';
import reviews from '../data/reviews.json';

// ... existing reviewTimestamp + sortedReviews logic (lines 9-24) unchanged ...
---

<Base
  title="Reviews · Joe's Barbershop · 5.0★ Google · 4.9★ Yelp"
  description="..."
  variant="article"
>
  <Fragment slot="head">
    <Review reviews={sortedReviews} />
  </Fragment>
  <!-- existing body (lines 32-67) unchanged -->
</Base>
```

---

### `site/src/pages/faq.astro` (MODIFY — add FAQPage schema)

**Analog:** itself, lines 1-181.

**Edit:** refactor the 14 inline FAQ items (lines 33-146) into a flat `faqs` array consumed by both the DOM rendering and the FAQPage schema component. Per RESEARCH § Pattern 7 + CONTEXT D-09, FAQPage schema flattens across the 5 category groups.

```astro
---
import Base from '../layouts/Base.astro';
import FAQPage from '../components/schema/FAQPage.astro';
import ClosingCTA from '../components/ClosingCTA.astro';

const lastUpdated = 'May 2026';

const faqGroups = [
  {
    category: 'Hours & Days',
    items: [
      { q: "What are Joe's Barbershop's hours?", a: "Joe's Barbershop is open Tuesday through Saturday, 10am to 7:30pm..." },
      // ... 2 more, copy from current lines 33-53
    ],
  },
  // ... 4 more groups, copy from current lines 56-146
];

// Flat array for FAQPage JSON-LD per D-09 — schema doesn't care about category groupings.
const allFaqs = faqGroups.flatMap((g) => g.items);
---

<Base ...>
  <Fragment slot="head">
    <FAQPage faqs={allFaqs} pageUrl={Astro.url.href} />
  </Fragment>
  <!-- ... body unchanged in structure; render via faqGroups.map() so category <h2>s stay -->
</Base>
```

---

### `site/src/pages/east-county-traditional-barbershop.astro` (MODIFY — Article + FAQPage + LastUpdated)

**Analog:** itself, lines 1-122.

**Edit:**
1. Replace hard-coded `const lastUpdated = 'May 2026';` (line 7) with git-mtime import.
2. Refactor 6 inline FAQs (lines 74-115) into a `faqs` array.
3. Fill head slot with Article + FAQPage.
4. Add visible `<LastUpdated />` between BLUF and prose sections per D-11.

```astro
---
import Base from '../layouts/Base.astro';
import Article from '../components/schema/Article.astro';
import FAQPage from '../components/schema/FAQPage.astro';
import LastUpdated from '../components/LastUpdated.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';
import mtimes from '../data/git-mtimes.json';

const pageFile = 'site/src/pages/east-county-traditional-barbershop.astro';
const dateModified = mtimes[pageFile];

const faqs = [
  { q: "What makes Joe's Barbershop a traditional barbershop?", a: "The traditional model has three non-negotiables..." },
  // ... 5 more, copy from lines 74-115
];

const neighborhoods = [ ... ];  // existing lines 7-13 unchanged
---

<Base
  title="Traditional barbershop · East County · Joe's Barbershop"
  description="..."
  variant="article"
  ogType="article"
>
  <Fragment slot="head">
    <Article
      headline="What 'traditional barbershop' means in East County."
      description="..."
      url={Astro.url.href}
      datePublished="2026-05-01"
      dateModified={dateModified}
      authorName="Joe Denesowicz"
    />
    <FAQPage faqs={faqs} pageUrl={Astro.url.href} />
  </Fragment>

  <header class="article-head">...</header>

  <section class="bluf" aria-label="Answer capsule">...</section>

  <!-- D-11: visible Last updated line between BLUF and prose -->
  <div class="wrap"><LastUpdated isoDate={dateModified} /></div>

  <section class="prose">...</section>
  <!-- ... rest unchanged; FAQ section now renders via {faqs.map(...)} not inline -->
</Base>
```

**Preserve `<style>` block lines 124-282 verbatim.**

---

### `site/src/pages/2026-east-county-barbershop-cost-guide.astro` (MODIFY — Article + FAQPage + LastUpdated)

**Analog:** itself, lines 1-411 + the niche-landing pattern above (mirror exactly).

**Edit:** same as niche-landing — 4 inline FAQs (lines 100-127) → `faqs` array; head slot Article + FAQPage; visible LastUpdated between BLUF and prose; `ogType="article"`.

---

### `site/src/pages/[service].astro` (MODIFY — Service + FAQPage overlay)

**Analog:** itself, lines 1-156.

**Edit:** add slot fill — `entry.data.faqs` already in scope.

```astro
---
import Base from '../layouts/Base.astro';
import Service from '../components/schema/Service.astro';
import FAQPage from '../components/schema/FAQPage.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { Image } from 'astro:assets';
import { getCollection, render } from 'astro:content';
import { business } from '../data/business';

// ... existing imports (lines 7-21) + getStaticPaths (lines 22-28) + destructure (lines 30-47) unchanged ...
---

<Base
  title={`${entry.data.title} · Joe's Barbershop`}
  description={entry.data.bluf}
  variant="article"
>
  <Fragment slot="head">
    <Service entry={entry} pageUrl={Astro.url.href} />
    <FAQPage faqs={entry.data.faqs} pageUrl={Astro.url.href} />
  </Fragment>
  <!-- existing body lines 63-154 unchanged -->
</Base>
```

**Description hand-authoring vs auto-derivation per D-14:** Currently `description={entry.data.bluf}` passes the full BLUF (may exceed 160 chars). Planner picks: keep as-is OR add a `blufToMetaDescription()` helper per RESEARCH § Pattern 7 + truncate.

---

### `site/src/pages/[neighborhood]-barber.astro` (MODIFY — LocalBusiness-with-areaServed + FAQPage)

**Analog:** itself, lines 1-138.

**Edit:** add slot fill. Decision: the auto-injected HairSalon in Base.astro already carries the business identity. A per-neighborhood overlay would add `areaServed: { '@type': 'Place', name: '<neighborhood>' }` — but that duplicates the homepage's `areaServed` array.

**Simpler approach (recommended):** emit FAQPage only on neighborhood pages; rely on Base.astro's HairSalon for identity. The neighborhood-specific schema value isn't worth the duplication.

```astro
<Base ...>
  <Fragment slot="head">
    <FAQPage faqs={entry.data.faqs} pageUrl={Astro.url.href} />
  </Fragment>
  <!-- existing body lines 40-138 unchanged -->
</Base>
```

**Alternative per CONTEXT D-06 ("LocalBusiness with areaServed + FAQPage per neighborhood"):** if the planner wants per-neighborhood `areaServed`, that's a small overlay component — but it duplicates content already in the homepage HairSalon. Recommendation: skip; only emit FAQPage. Planner may overrule.

---

### `.planning/phases/03-unique-pages/scripts/audit.sh` (MODIFY — add 6 new check_* functions per D-23)

**Analog:** itself — `check_homepage_faq` lines 39-49 (file-existence + grep + count idiom), `check_niche_areaserved` lines 63-77 (awk-section-extract pattern), `check_cost_guide_slugs` lines 79-98 (slug-list-loop idiom), `check_bluf_position` lines 224-264 (multi-page loop idiom).

**Pattern A — file presence + content grep** (copy idiom from `check_homepage_faq` lines 39-49):

```bash
check_robots_txt() {
  local file="${DIST_DIR}/robots.txt"
  if [ ! -f "$file" ]; then
    fail "robots-txt" "missing dist/robots.txt"
    return
  fi
  if ! grep -qE '^Sitemap: https?://' "$file" 2>/dev/null; then
    fail "robots-txt" "robots.txt missing 'Sitemap:' line"
    return
  fi
  pass
}
```

**Pattern B — call out to node script** (new pattern; trivial — bash invokes mjs):

```bash
check_json_ld_validity() {
  local script="${REPO_ROOT}/scripts/validate-schema.mjs"
  if [ ! -f "$script" ]; then
    fail "json-ld-validity" "missing scripts/validate-schema.mjs"
    return
  fi
  if node "$script"; then
    pass
  else
    fail "json-ld-validity" "validate-schema.mjs reported failures (see output above)"
  fi
}
```

**Pattern C — sitemap link check** (copy idiom from `check_cost_guide_slugs` lines 79-98 — same slug-list iteration):

```bash
check_sitemap_urls() {
  local sitemap="${DIST_DIR}/sitemap-0.xml"
  if [ ! -f "$sitemap" ]; then
    fail "sitemap-urls" "missing dist/sitemap-0.xml"
    return
  fi
  # canonical-slugs.txt has 11 templated slugs; add the 6 unique pages here.
  local unique_pages=("" "about" "reviews" "faq" "east-county-traditional-barbershop" "2026-east-county-barbershop-cost-guide")
  local missing=()
  while IFS= read -r slug || [ -n "$slug" ]; do
    [ -z "$slug" ] && continue
    if ! grep -q ">https://[^<]*/${slug}/?<" "$sitemap" 2>/dev/null; then
      missing+=("$slug")
    fi
  done < "$SLUGS_FILE"
  for page in "${unique_pages[@]}"; do
    if [ -z "$page" ]; then
      grep -q ">https://[^<]*/<" "$sitemap" 2>/dev/null || missing+=("/")
    else
      grep -q ">https://[^<]*/${page}/?<" "$sitemap" 2>/dev/null || missing+=("$page")
    fi
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "sitemap-urls" "missing in sitemap-0.xml: ${missing[*]}"
  fi
}
```

**Pattern D — text-as-image heuristic grep** (copy idiom from `check_no_anti_patterns` lines 188-204 — grep + line-count + report):

```bash
check_text_as_image() {
  if [ ! -d "$SRC_PAGES" ]; then
    fail "text-as-image" "src/pages/ not found"
    return
  fi
  local matches
  # Grep for alt attrs containing price markers or service words.
  matches=$(grep -rEn 'alt="[^"]*\$[0-9]|alt="[^"]*(haircut|fade|shave)"' "$SRC_PAGES" "${SITE_DIR}/src/components" 2>/dev/null || true)
  local n
  n=$(echo "$matches" | grep -c '.' 2>/dev/null || echo 0)
  if [ -z "$matches" ] || [ "$n" -eq 0 ]; then
    pass
  else
    echo "  Matching lines:"
    echo "$matches" | head -20 | sed 's/^/    /'
    fail "text-as-image" "found ${n} alt-text(s) with price/service words (AEO-07: text should be DOM, not image)"
  fi
}
```

**Pattern E — BLUF spot-check on 5 pages** (copy idiom from `check_bluf_position` lines 224-264 — multi-page loop):

```bash
check_bluf_keywords() {
  local pages=(
    "index"
    "fades"
    "bostonia-barber"
    "east-county-traditional-barbershop"
    "2026-east-county-barbershop-cost-guide"
  )
  local any_fail=0
  for page_slug in "${pages[@]}"; do
    local file
    if [ "$page_slug" = "index" ]; then
      file="${DIST_DIR}/index.html"
    else
      file="${DIST_DIR}/${page_slug}/index.html"
    fi
    if [ ! -f "$file" ]; then skip "bluf-keywords:${page_slug}" "page not built"; continue; fi
    # Extract first ~100 words of BLUF lead text
    local bluf
    bluf=$(awk '/<p class="bluf-lead"/,/<\/p>/' "$file" 2>/dev/null | tr '\n' ' ' | sed 's/<[^>]*>//g')
    if ! echo "$bluf" | grep -qi "Joe's Barbershop"; then
      fail "bluf-keywords" "${page_slug} BLUF missing business name"; any_fail=1; continue
    fi
    if ! echo "$bluf" | grep -qiE "(El Cajon|Bostonia|East County)"; then
      fail "bluf-keywords" "${page_slug} BLUF missing location term"; any_fail=1; continue
    fi
    if ! echo "$bluf" | grep -qiE "(barber|barbershop|haircut|fade|shave)"; then
      fail "bluf-keywords" "${page_slug} BLUF missing service term"; any_fail=1; continue
    fi
    pass
  done
}
```

**Pattern F — Lighthouse CLI median-of-3** (new pattern; loosely modeled on the bash-invoking-tool style of `check_no_anti_patterns` but calls `npx lighthouse` + `jq`):

```bash
check_lighthouse() {
  if ! command -v jq >/dev/null 2>&1; then skip "lighthouse" "jq not installed"; return; fi
  if ! command -v npx >/dev/null 2>&1; then skip "lighthouse" "npx not installed"; return; fi
  local url="${LIGHTHOUSE_URL:-http://localhost:4321}"
  # Median-of-3 per CONTEXT § Discretion line 119
  local perf_scores=() a11y_scores=() seo_scores=()
  for i in 1 2 3; do
    local tmp
    tmp=$(mktemp)
    npx lighthouse "$url" --preset=desktop --output=json --quiet \
      --chrome-flags="--headless --no-sandbox" > "$tmp" 2>/dev/null || true
    perf_scores+=($(jq '.categories.performance.score' "$tmp"))
    a11y_scores+=($(jq '.categories.accessibility.score' "$tmp"))
    seo_scores+=($(jq '.categories.seo.score' "$tmp"))
    rm -f "$tmp"
  done
  # Sort + pick median (index 1 of 3)
  local perf a11y seo
  perf=$(printf '%s\n' "${perf_scores[@]}" | sort -n | sed -n '2p')
  a11y=$(printf '%s\n' "${a11y_scores[@]}" | sort -n | sed -n '2p')
  seo=$(printf '%s\n' "${seo_scores[@]}" | sort -n | sed -n '2p')
  # Thresholds per D-19 / PERF-02
  awk -v p="$perf"  'BEGIN { exit (p  >= 0.90) ? 0 : 1 }' || { fail "lighthouse" "performance ${perf} < 0.90"; return; }
  awk -v a="$a11y"  'BEGIN { exit (a  >= 0.95) ? 0 : 1 }' || { fail "lighthouse" "a11y ${a11y} < 0.95"; return; }
  awk -v s="$seo"   'BEGIN { exit (s  >= 0.95) ? 0 : 1 }' || { fail "lighthouse" "seo ${seo} < 0.95"; return; }
  pass
}
```

**Registry update — extend `run_check` switch (lines 436-461) and `run_all_checks` (lines 464-484) with the 6 new names.**

---

## Shared Patterns

### Pattern S-1: schema component file shape

**Source:** RESEARCH § Pattern 1 (`set:html` + `JSON.stringify`).
**Apply to:** All 7 schema components under `site/src/components/schema/`.

```astro
---
import { /* helpers + canonicalUrl */ } from '../../data/business';
// ... props interface ...
const schema = { '@context': 'https://schema.org', '@type': 'X', ... };
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

**Convention:** zero CSS in schema components; pure script-tag emitters. Per CONTEXT § Established Patterns ("Per-component scoped CSS").

---

### Pattern S-2: `@id` URL constant for cross-page entity dedup

**Source:** CONTEXT D-07 + § specifics line 258.
**Apply to:** All schema components emitting an entity that references the business or a person.

- Business `@id`: `${canonicalUrl}/#business`
- Person `@id`: `${canonicalUrl}/#joe-denesowicz`
- FAQPage `@id`: `${pageUrl}#faq`
- Service `@id`: `${pageUrl}#service`
- Article `@id`: implicit via `url` field

**Single source:** `canonicalUrl` exported from `business.ts`. When custom domain lands (v1.5 / Phase 7), edit one constant.

---

### Pattern S-3: `<Fragment slot="head">` for per-page schema overlays

**Source:** Phase 2 D-26 (`<slot name="head" />` reserved in Base.astro line 26) — **first consumption is Phase 5**.
**Apply to:** All 9 modified page files. Per-page-specific schema components ride inside this slot fragment.

```astro
<Base ...>
  <Fragment slot="head">
    <SchemaComponentA ... />
    <SchemaComponentB ... />
  </Fragment>
  <!-- page body -->
</Base>
```

---

### Pattern S-4: ogType per page archetype

**Source:** RESEARCH § Pattern 6 + CONTEXT D-15.
**Apply to:** All 9 modified page files.

- Default (`ogType="website"`): `/`, `/about`, `/reviews`, `/faq`, all 6 service pages, all 5 neighborhood pages.
- `ogType="article"`: `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`.

---

### Pattern S-5: title pattern per D-13

**Source:** CONTEXT D-13.
**Apply to:** All pages.

- Homepage: `Joe's Barbershop — Bostonia, El Cajon` (unique, no pipe; current is `Joe's Barbershop — Bostonia, El Cajon` — already correct).
- All other pages: `Topic | Joe's Barbershop`.

**Existing pages currently use `·` (middle dot) separator** (e.g., `Traditional barbershop · East County · Joe's Barbershop`). Phase 5 should normalize to `|` per D-13 — that's one edit per page. Planner discretion: hold the current `·` if the visual treatment is preferred and document the divergence. Per D-13 the pipe is the explicit pick.

---

### Pattern S-6: BLUF auto-derivation helper

**Source:** RESEARCH § Pattern 7.
**Apply to:** `[service].astro` line 60 + `[neighborhood]-barber.astro` line 38 (where `description={entry.data.bluf}` currently passes through full BLUF).

```typescript
function blufToMetaDescription(bluf: string, maxLen = 160): string {
  const stripped = bluf.replace(/\*\*/g, '').replace(/\s+/g, ' ').trim();
  const firstSentence = stripped.match(/^[^.!?]+[.!?]/)?.[0] ?? stripped;
  return firstSentence.length <= maxLen
    ? firstSentence
    : firstSentence.slice(0, maxLen - 1).replace(/\s\S*$/, '') + '…';
}
```

Colocate in `site/src/lib/meta.ts` (new file) or inline at the consumer. Either works; CONTEXT § Discretion permits.

---

### Pattern S-7: Hero image `fetchpriority`

**Source:** RESEARCH § Pattern 5 + CONTEXT D-20.
**Apply to:** Hero images on every page where there is one.

- `site/src/components/Hero.astro` line 33 — `loading="eager" fetchpriority="high"` **already correct**.
- `site/src/pages/[service].astro` line 81 — `<Image ... loading="lazy" />` — verify whether the service-hero image is above-the-fold (it's the second viewport block after BLUF). Planner picks: change to `priority` prop per RESEARCH § Pattern 5, or keep `loading="lazy"` if measured LCP allows.
- `site/src/pages/[neighborhood]-barber.astro` line 57 — same question.

**Astro 6 `priority` prop** sets `loading="eager" + decoding="sync" + fetchpriority="high"` in one shorthand. Cleaner than three separate attrs.

---

### Pattern S-8: Astro env var consumption

**Source:** RESEARCH § Pattern 4.
**Apply to:** Base.astro Clarity gating only.

- `import.meta.env.PUBLIC_CLARITY_PROJECT_ID` — public-prefixed (`PUBLIC_*` exposed to client per Astro convention).
- `import.meta.env.PROD` — Astro/Vite-provided boolean, statically replaced at build time.

---

## No Analog Found

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `site/public/robots.txt` | static asset | static-serve | Trivial 4-line text file; no analog needed. RESEARCH § Pattern 8 supplies content. |
| `site/.env.example` | config doc | static | First env file in repo. RESEARCH § Pattern 4 supplies content. |
| `scripts/generate-mtimes.mjs` | pre-build hook | file-I/O | No pre-build script analog in repo. RESEARCH § Pattern 9 supplies the canonical Astro recipe. |

---

## Metadata

**Analog search scope:**
- `site/src/layouts/` — 1 file (Base.astro)
- `site/src/components/` — 13 files (Hero, FAQ, Visit, Heritage, FactStrip, PriceBoard, etc.)
- `site/src/pages/` — 8 files (4 unique + 2 dynamic-route + cost guide + niche-landing)
- `site/src/data/` — 4 files (business.json, business.ts, reviews.json, competitors.json)
- `.planning/phases/03-unique-pages/scripts/` — audit.sh + canonical-slugs.txt
- `.planning/phases/04-templated-pages/04-PATTERNS.md` — stylistic alignment reference

**Files scanned:** 31

**Pattern extraction date:** 2026-05-10

**Strongest analog idioms identified:**
1. `business.ts` typed-data-import pattern (used by every existing component that consumes NAP/hours/prices) — schema components inherit directly.
2. `entry.data.faqs.map(...)` from `[service].astro` lines 141-149 — exact data shape FAQPage schema consumes.
3. `check_homepage_faq` lines 39-49 — bash audit "file exists + grep + count" idiom; audit.sh's 6 new checks all extend this shape.
4. `<header class="article-head">` + `.date-stamp` block lines 21-27 — visible "Last updated" line inherits font/letter-spacing verbatim.
5. RESEARCH § Pattern 1 (`set:html` + `JSON.stringify`) — canonical Astro JSON-LD emission; every schema component uses it identically.
