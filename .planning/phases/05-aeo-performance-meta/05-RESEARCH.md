# Phase 5: AEO + Performance + Meta — Research

**Researched:** 2026-05-10
**Domain:** AEO schema injection, Lighthouse perf hardening, meta tag emission, Astro 6 build integrations
**Confidence:** HIGH (every Phase-5 question answered by either official docs or live registry data; one assumption flagged on Google's FAQPage policy change)

## Summary

Phase 5 sits in unusually well-trodden territory: Astro 6 has first-party patterns for every Phase-5 concern (JSON-LD via `set:html`, sitemap, Vercel adapter, Image `priority` prop, env-gated inline scripts) and the npm ecosystem ships Astro-native components for Vercel Analytics/Speed Insights and TypeScript types for Schema.org. The Phase-5 plan is therefore mostly **glue work + verification**, not invention.

Three live findings shaped the prescriptive guidance below:

1. **`@astrojs/sitemap` emits `sitemap-index.xml` + `sitemap-0.xml`** (not `sitemap.xml`). D-18's robots.txt already references `sitemap-index.xml` — correct. Audit script must look for `sitemap-0.xml` (the entry list) when verifying 17 URLs.
2. **Astro 6 ships a `priority` prop** on Image/Picture that sets `fetchpriority="high"` + `loading="eager"` + `decoding="sync"` together. Cleaner than setting attributes individually per D-20.
3. **Google deprecated FAQPage rich results on 2026-05-07** (3 days before this research). FAQPage JSON-LD **remains the highest-value emission for AI citation surfaces** (ChatGPT, Perplexity, Gemini, Google AI Mode all parse it) — playbook's #1 priority ordering still holds. The deprecation is Google-Search-rich-snippet-only, not AI-citation-relevant. **Phase 5 ships FAQPage as planned.**

**Primary recommendation:** Use Astro's first-party patterns (`set:html` + `JSON.stringify` for JSON-LD; `priority` prop for hero; `@vercel/analytics/astro` `<Analytics />` + `@vercel/speed-insights/astro` `<SpeedInsights />` components for telemetry; `remarkModifiedTime` plugin from Astro's official recipe for git mtime). `schema-dts` for type-safe JSON-LD authoring. Validator script uses `cheerio` + hand-rolled required-field checks (schema-dts is types-only, not a validator). Lighthouse CLI invoked as median-of-3 with thresholds enforced via `jq` on JSON output.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| JSON-LD schema emission | Frontend (Astro SSG render) | — | Schema is static HTML; injected at build time via Base.astro and per-page schema components reading from `business` + collection data |
| Meta tag emission (`<title>`, `<meta description>`, OG, Twitter, canonical) | Frontend (Astro SSG render) | — | Pure Base.astro frontmatter → `<head>` work; no runtime |
| Sitemap generation | Build (`@astrojs/sitemap` integration) | — | Astro plugin emits XML at `astro build` time from discovered routes |
| robots.txt | Static (`public/robots.txt`) | — | Hand-written static asset served by Vercel verbatim |
| Vercel Web Analytics + Speed Insights | Browser (script injection via Astro component) | CDN (Vercel auto-detect) | Astro `<Analytics />` + `<SpeedInsights />` components inject `<script>` tags; Vercel deploy pipeline gates dev/prod |
| Microsoft Clarity | Browser (inline script) | — | Synchronous-loaded async tag in `<head>`; gated by `import.meta.env.PROD` at build |
| `dateModified` from git | Build (Astro remark plugin or pre-build node script) | — | Reads `git log` at `astro build`, exposes as frontmatter or virtual module |
| Lighthouse perf measurement | Local CI (`lighthouse` CLI against `astro preview` or Vercel preview) | — | Audit-script-time only; not runtime |
| Hero image `fetchpriority` | Browser (HTML attribute) | CDN (Vercel Image Optimization) | Astro Image `priority` prop sets attributes; CDN serves optimized AVIF/WebP |
| Schema validation | Build/CI (audit script — node + cheerio + hand-rolled checks) | Manual (Google Rich Results paste — D-25) | Post-build static-HTML inspection; deterministic |

## Standard Stack

### Core

| Library | Version (verified) | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `astro` | `^6.3.0` (already installed; latest `6.3.1`) | Build framework | Already locked Phase 1 |
| `@astrojs/sitemap` | `^3.7.2` (already installed) | Sitemap XML generation | Already wired Phase 1 |
| `@astrojs/vercel` | `^10.0.6` (already installed) | Vercel adapter | Already wired Phase 1 |
| `@vercel/analytics` | `2.0.1` (published 2026-04-17) | Vercel Web Analytics | First-party; ships Astro component |
| `@vercel/speed-insights` | `2.0.0` (published 2026-04-17) | Vercel Speed Insights | First-party; ships Astro component |
| `schema-dts` | `2.0.0` (published 2026-03-23) | TypeScript types for Schema.org JSON-LD | Maintained by Google; covers every type Phase 5 needs |

### Supporting (devDependencies)

| Library | Version (verified) | Purpose | When to Use |
|---------|---------|---------|-------------|
| `lighthouse` | `13.3.0` (published 2026-05-07) | Lighthouse CLI | `scripts/audit.sh` perf check (D-23.6) |
| `cheerio` | `1.x` (jQuery-style HTML parser for Node) | Server-side HTML parsing | `scripts/validate-schema.mjs` extracting `<script type="application/ld+json">` blocks from `dist/*.html` |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `lighthouse` (raw CLI) | `@lhci/cli` (Lighthouse CI wrapper, v0.15.1) | LHCI adds config-driven thresholds + run aggregation; **but** introduces a `.lighthouserc.json` config file and a heavier dependency. Recommend `lighthouse` raw + `jq` for Phase 5 — fewer moving parts, audit script already in bash. |
| `cheerio` for HTML parse | `node-html-parser` or regex | cheerio is the dominant choice (200M+ weekly downloads); regex on HTML is brittle. cheerio worth the dep. |
| `schema-dts` for validation | Custom JSON-schema validator (`ajv` + handcrafted JSON schemas) | schema-dts is **types only** — not a runtime validator. Validation is a separate, hand-rolled required-field check in `validate-schema.mjs`. ajv + JSON-schemas is overkill for the 8-type surface; D-23.1 explicitly calls for hand-rolled required-field lists. |
| Vite plugin for git mtime | Astro `remarkModifiedTime` remark plugin (per Astro official recipe) | Astro's official recipe (`https://docs.astro.build/en/recipes/modified-time/`) uses `execSync('git log -1 --pretty="format:%cI" <file>')` inside a remark plugin. **Limitation:** the recipe wires through Markdown frontmatter only — works for content collections but not raw `.astro` pages. For pages that need it (`/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`), a pre-build node script writing a JSON manifest (`src/data/git-mtimes.json`) imported by the page is more universal. **Recommendation:** pre-build node script. See "Recommendation: git mtime mechanism" below. |
| Inline Clarity `<script is:inline>` | NPM `@microsoft/clarity` package | NPM package adds a JS dependency for what is a 10-line snippet. Inline `<script is:inline>` is the official Clarity-supported install method and matches the "zero-JS-by-default" project ethos. |

**Installation:**

```bash
npm install --workspace=site @vercel/analytics @vercel/speed-insights
npm install --workspace=site --save-dev schema-dts lighthouse cheerio
```

**Version verification (2026-05-10):**
- `@vercel/analytics`: registry shows `2.0.1`, published 2026-04-17 [VERIFIED: `npm view @vercel/analytics version`]
- `@vercel/speed-insights`: registry shows `2.0.0`, published 2026-04-17 [VERIFIED: `npm view @vercel/speed-insights version`]
- `schema-dts`: registry shows `2.0.0`, published 2026-03-23 [VERIFIED: `npm view schema-dts version`]
- `lighthouse`: registry shows `13.3.0`, published 2026-05-07 (three days ago — fresh) [VERIFIED: `npm view lighthouse version`]

## Architecture Patterns

### System Architecture Diagram

```
                              [Build Time]
                                    |
                        ┌───────────┴──────────┐
                        │                      │
                  remarkModifiedTime      git-mtimes.json
                  (Markdown collections)  (pre-build script)
                        │                      │
                        └─────────┬────────────┘
                                  │
                                  ▼
       ┌──────────────────────────────────────────────────────┐
       │                  astro build                          │
       │                                                       │
       │   For each route:                                     │
       │     Base.astro renders shell:                         │
       │       <head>                                          │
       │         <title>{title}                                │
       │         <meta description={description}>              │
       │         <meta og:*> <meta twitter:*>                  │
       │         <link rel=canonical>                          │
       │         <Analytics /> <SpeedInsights />               │
       │         [Clarity inline script if PROD]               │
       │         <HairSalon /> (auto)  ← reads business        │
       │         <slot name="head" />  ← per-page overlays     │
       │       </head>                                         │
       │       <body><main>{page content}</main></body>        │
       │                                                       │
       │   @astrojs/sitemap emits dist/sitemap-index.xml +     │
       │     dist/sitemap-0.xml                                │
       │                                                       │
       │   public/robots.txt copies verbatim to dist/          │
       └──────────────────────┬───────────────────────────────┘
                              │
                              ▼
                       dist/<slug>/index.html
                              │
                              ▼
       ┌──────────────────────────────────────────────────────┐
       │              scripts/audit.sh (CI gate)               │
       │                                                       │
       │   Phase 3+4 existing checks (FAQ counts, slugs, ...)  │
       │   ─────────────── NEW (Phase 5) ───────────────       │
       │   D-23.1: validate-schema.mjs → required-field check  │
       │   D-23.2: sitemap-0.xml parse → 17 URLs assertion     │
       │   D-23.3: robots.txt presence + Sitemap: line check   │
       │   D-23.4: text-as-image heuristic grep                │
       │   D-23.5: BLUF spot-check (5 pages, first 100 words)  │
       │   D-23.6: lighthouse CLI median-of-3 → score floors   │
       └──────────────────────┬───────────────────────────────┘
                              │
                              ▼
       ┌──────────────────────────────────────────────────────┐
       │     D-25 manual gate (one-time):                      │
       │     Google Rich Results Test paste                    │
       │     → screenshots saved to                             │
       │       .planning/phases/05-aeo-performance-meta/        │
       │         rich-results/                                  │
       └───────────────────────────────────────────────────────┘
```

### Recommended Project Structure

Builds on existing Phase 1-4 layout:

```
site/
├── src/
│   ├── components/
│   │   └── schema/                  # NEW (Phase 5, D-09)
│   │       ├── HairSalon.astro      # auto-emitted by Base.astro
│   │       ├── AggregateRating.astro # homepage only (D-08)
│   │       ├── FAQPage.astro
│   │       ├── Service.astro
│   │       ├── Person.astro
│   │       ├── Article.astro
│   │       └── Review.astro         # /reviews page
│   ├── data/
│   │   ├── business.json            # EXTENDED (D-04: geo, priceRange, helpers)
│   │   ├── business.ts              # EXTENDED (helpers exported)
│   │   └── git-mtimes.json          # NEW — generated pre-build (D-10)
│   ├── layouts/
│   │   └── Base.astro               # EXTENDED — auto HairSalon, meta, telemetry
│   └── styles/                      # unchanged
├── public/
│   └── robots.txt                   # NEW (D-18)
├── scripts/                         # NEW dir at site root (or reuse .planning/phases/03/)
│   ├── generate-mtimes.mjs          # pre-build hook for D-10
│   └── validate-schema.mjs          # called by audit.sh D-23.1
└── .env.example                     # NEW — documents PUBLIC_CLARITY_PROJECT_ID

.planning/phases/05-aeo-performance-meta/
├── scripts/
│   └── audit.sh                     # EXTENDED from Phase 3/4 with D-23.1-6 checks
└── rich-results/                    # NEW — D-25 screenshot drop
```

### Pattern 1: JSON-LD via `set:html` + `JSON.stringify`

**What:** Astro's official-pattern JSON-LD injection. `set:html` bypasses Astro's default HTML escaping; `JSON.stringify` produces well-formed JSON that needs no further escaping.

**When to use:** Every schema component file under `src/components/schema/`.

**Example:**
```astro
---
// src/components/schema/HairSalon.astro [CITED: docs.astro.build/en/reference/directives-reference/]
import { business } from '../../data/business';

const siteUrl = 'https://joesbarbershop.vercel.app'; // matches astro.config.mjs `site`

const schema = {
  '@context': 'https://schema.org',
  '@type': 'HairSalon',
  '@id': `${siteUrl}/#business`,
  name: business.name,
  url: siteUrl,
  telephone: toE164(business.phone),                // helper from business.ts
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

**Critical safety note:** `JSON.stringify` does NOT escape the sequence `</script>` inside string values. If a future business-data field (e.g., a description string) contained `</script>`, the page would break. Mitigation in `validate-schema.mjs`: assert no rendered JSON-LD block contains the literal `</script>` substring outside of the closing tag itself. Current `business.json` values are short proper nouns + URLs + numbers — risk is zero today, but the audit check costs nothing.

### Pattern 2: Type-safe JSON-LD authoring with `schema-dts`

```typescript
// src/components/schema/Article.astro frontmatter [CITED: github.com/google/schema-dts]
import type { Article, WithContext } from 'schema-dts';

interface Props {
  headline: string;
  description: string;
  url: string;
  dateModified: string;  // ISO 8601 from git-mtimes.json
  authorName: string;
}

const { headline, description, url, dateModified, authorName } = Astro.props;

const schema: WithContext<Article> = {
  '@context': 'https://schema.org',
  '@type': 'Article',
  headline,
  description,
  url,
  datePublished: '2026-05-01',  // hand-set per page
  dateModified,
  author: { '@type': 'Person', name: authorName },
  publisher: { '@id': 'https://joesbarbershop.vercel.app/#business' },
};
```

**Note:** `WithContext<T>` is the type wrapper that adds `@context: 'https://schema.org'`. schema-dts is "types only" — there's no runtime validator. Runtime validation is the audit script's job.

### Pattern 3: Vercel Analytics + Speed Insights in Base.astro

```astro
---
// src/layouts/Base.astro frontmatter [CITED: vercel.com/docs/analytics/package + vercel.com/docs/speed-insights/package]
import Analytics from '@vercel/analytics/astro';
import SpeedInsights from '@vercel/speed-insights/astro';
---
<!doctype html>
<html lang="en">
  <head>
    <!-- ... existing head ... -->
    <Analytics />
    <SpeedInsights />
  </head>
  <body>
    <!-- ... -->
  </body>
</html>
```

Both components are wrapper Astro components for `<script>` injection. **They self-disable in development** (`astro dev`) by detecting `import.meta.env.PROD` internally — no manual gating needed. Place them inside `<head>` (Vercel's quickstart uses head; speed-insights repo example also head).

### Pattern 4: Microsoft Clarity inline script with PROD gating

```astro
---
// src/layouts/Base.astro frontmatter
const clarityId = import.meta.env.PUBLIC_CLARITY_PROJECT_ID;
const enableClarity = import.meta.env.PROD && clarityId;
---
{enableClarity && (
  <script is:inline define:vars={{ clarityId }}>
    (function(c,l,a,r,i,t,y){
      c[a]=c[a]||function(){(c[a].q=c[a].q||[]).push(arguments)};
      t=l.createElement(r);t.async=1;t.src="https://www.clarity.ms/tag/"+i;
      y=l.getElementsByTagName(r)[0];y.parentNode.insertBefore(t,y);
    })(window, document, "clarity", "script", clarityId);
  </script>
)}
```

**Key points** [CITED: learn.microsoft.com/en-us/clarity/setup-and-installation/clarity-setup]:
- `is:inline` keeps the script raw (Astro otherwise bundles it as an ES module).
- `define:vars` injects `clarityId` into the script as a build-time-resolved constant.
- The `{enableClarity && ...}` template guard ensures the script tag is never emitted in dev — better than emitting a no-op script.
- Place inside `<head>` per Microsoft's official recommendation. Async by design (`t.async=1` set inside the IIFE).
- `import.meta.env.PROD` is statically replaced at build time by Vite/Astro [CITED: docs.astro.build/en/guides/environment-variables/].

### Pattern 5: Astro Image `priority` prop (hero image)

```astro
---
import { Image } from 'astro:assets';
import hero from '../assets/photos/03-interior-hero.jpg';
---
<Image src={hero} alt="Joe's Barbershop interior" priority width={1200} height={800} />
```

The `priority` prop sets `loading="eager"`, `decoding="sync"`, and `fetchpriority="high"` in one shorthand. Alternative is to set them individually as separate attrs — but `priority` is the maintained shorthand in Astro 6 [CITED: docs.astro.build/en/guides/images/]. Document the choice in the implementing component file's comment.

### Pattern 6: Meta tags emitted from Base.astro

```astro
---
// src/layouts/Base.astro — extended Props interface
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
---
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{title}</title>
  {description && <meta name="description" content={description} />}
  <link rel="canonical" href={canonicalUrl} />
  <meta property="og:type" content={ogType} />
  <meta property="og:title" content={title} />
  {description && <meta property="og:description" content={description} />}
  <meta property="og:url" content={canonicalUrl} />
  <meta property="og:site_name" content={siteName} />
  <meta name="twitter:card" content={twitterCard} />
  <meta name="twitter:title" content={title} />
  {description && <meta name="twitter:description" content={description} />}
  <!-- ... existing font preconnects, slot=head, etc. ... -->
</head>
```

`Astro.url` gives the current page URL; `Astro.site` is the global `site:` from `astro.config.mjs`. `new URL(pathname, site)` produces an absolute canonical link. Per D-15, `twitter:site` (Twitter handle) is omitted — Joe doesn't have a Twitter/X account.

### Pattern 7: BLUF description auto-derivation (D-14)

```typescript
// utility colocated in src/lib/meta.ts or inline in template
function blufToMetaDescription(bluf: string, maxLen = 160): string {
  // Strip markdown emphasis, take first sentence, hard-cap at maxLen
  const stripped = bluf.replace(/\*\*/g, '').replace(/\s+/g, ' ').trim();
  const firstSentence = stripped.match(/^[^.!?]+[.!?]/)?.[0] ?? stripped;
  return firstSentence.length <= maxLen
    ? firstSentence
    : firstSentence.slice(0, maxLen - 1).replace(/\s\S*$/, '') + '…';
}
```

Used in `[service].astro` and `[neighborhood]-barber.astro` to set `<Base description={blufToMetaDescription(entry.data.bluf)}>`.

### Pattern 8: Sitemap defaults

`@astrojs/sitemap@3.7.2` emits two files by default to `dist/` [CITED: docs.astro.build/en/guides/integrations-guide/sitemap/]:
- `sitemap-index.xml` — the index that linkers/robots should reference
- `sitemap-0.xml` — the actual URL list (one numbered file per ~45k URLs; 17 URLs fit in `-0`)

D-18's robots.txt referencing `https://joesbarbershop.vercel.app/sitemap-index.xml` is correct. The audit script (D-23.2) must parse `sitemap-0.xml` for the URL list — NOT `sitemap-index.xml` (which only contains a link to `-0`).

### Pattern 9: Git mtime via remark plugin (content collections) + pre-build manifest (raw pages)

**Astro's official recipe** [CITED: docs.astro.build/en/recipes/modified-time/]:

```javascript
// site/scripts/remark-modified-time.mjs
import { execSync } from 'child_process';
export function remarkModifiedTime() {
  return function (tree, file) {
    const filepath = file.history[0];
    const result = execSync(`git log -1 --pretty="format:%cI" "${filepath}"`);
    file.data.astro.frontmatter.lastModified = result.toString();
  };
}
```

```javascript
// astro.config.mjs
import { remarkModifiedTime } from './scripts/remark-modified-time.mjs';
export default defineConfig({
  // ...
  markdown: { remarkPlugins: [remarkModifiedTime] },
});
```

Accessed in pages via:
- Content collection entries: `const { remarkPluginFrontmatter } = await render(entry); const dateModified = remarkPluginFrontmatter.lastModified;`
- Markdown layouts: `Astro.props.frontmatter.lastModified`

**Limitation:** remark plugins only fire on `.md`/`.mdx` files. Phase 5 needs `dateModified` on **two raw `.astro` pages**: `/east-county-traditional-barbershop` and `/2026-east-county-barbershop-cost-guide`. These are not in a content collection.

**Recommendation: pre-build node script** writing a JSON manifest:

```javascript
// site/scripts/generate-mtimes.mjs — run via `prebuild` npm script
import { execSync } from 'child_process';
import { writeFileSync } from 'fs';

const TRACKED_FILES = [
  'src/pages/east-county-traditional-barbershop.astro',
  'src/pages/2026-east-county-barbershop-cost-guide.astro',
];

const mtimes = Object.fromEntries(
  TRACKED_FILES.map(f => {
    const iso = execSync(`git log -1 --pretty=format:%cI "${f}"`, { cwd: 'site' })
      .toString().trim();
    // Fallback: if git returns empty (uncommitted file), use current time
    return [f, iso || new Date().toISOString()];
  })
);

writeFileSync('site/src/data/git-mtimes.json', JSON.stringify(mtimes, null, 2));
```

```json
// site/package.json
{
  "scripts": {
    "prebuild": "node scripts/generate-mtimes.mjs",
    "build": "astro build"
  }
}
```

Pages import:
```typescript
import mtimes from '../data/git-mtimes.json';
const dateModified = mtimes['src/pages/east-county-traditional-barbershop.astro'];
const visibleDate = new Date(dateModified).toLocaleDateString('en-US',
  { year: 'numeric', month: 'long', day: 'numeric' });  // "May 10, 2026"
```

**Caveat:** Vercel performs shallow clones by default. The official recipe explicitly warns about this. Vercel's recommended fix is to set `VERCEL_DEEP_CLONE=1` in project env (or use Vercel's git settings). **Add to Vercel project settings during Phase 5 execution** — flag for operator note.

### Anti-Patterns to Avoid

- **Hand-rolling JSON-LD escape logic.** Use `JSON.stringify` — it handles every JS-side escape correctly. Only the `</script>` substring inside a string literal is a latent issue, and current data has none.
- **Setting `fetchpriority`/`loading`/`decoding` individually** when `priority` prop expresses the same intent in one attribute (Astro 6).
- **Putting Clarity in the body footer.** Microsoft explicitly says: load early (head) so initial-pageview events fire.
- **Per-bot `robots.txt` rules in v1.** Allow-all (`User-agent: *` + `Allow: /`) is the AEO play — GPTBot, ClaudeBot, PerplexityBot, Bingbot all need access. Tightening comes only if HEAD-storm rate issues appear in audit (CONTEXT D-discretion).
- **Stringifying schema with template literals** (`` `{...}` ``). Always `JSON.stringify(obj)` so escape behavior is deterministic.
- **Emitting `aggregateRating` on every page.** D-08 locks it to homepage only — rating drift between scrapes is otherwise multiplied across 17 pages.
- **Setting `priority` on multiple images per page.** Astro docs explicitly say "ideally only one image per page" — LCP-target only.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Sitemap XML emission | Hand-rolled XML | `@astrojs/sitemap` (already wired) | Handles `<urlset>`, `<lastmod>`, escaping, index file structure |
| Schema.org TypeScript types | `type HairSalonSchema = { ... }` | `schema-dts` | Google-maintained, covers entire vocab, version-tracked with Schema.org releases |
| Vercel Web Analytics tracking script | Inline script reading window events | `@vercel/analytics/astro` `<Analytics />` | Route-aware, route-change tracking on SPA-like transitions, self-disables in dev |
| Vercel Core Web Vitals reporting | `web-vitals` package + custom POST | `@vercel/speed-insights/astro` `<SpeedInsights />` | Same — Vercel-native, dashboards work without config |
| Git mtime computation | Calling `git log` inline in each `.astro` page | Astro remark plugin (content collections) + pre-build manifest script (raw pages) | Centralized, fails loudly if git history missing |
| JSON-LD validation runtime | `ajv` + JSON schemas for every Schema.org type | Hand-rolled required-field check per type | The 8 schema types Phase 5 emits have short, well-known required-field lists (see "Schema.org required-field cheatsheet"). ajv is overkill. |
| HTML parsing in audit script | `grep -oP '<script type="application/ld\+json">(.*?)</script>'` | `cheerio` (Node, npm) inside `validate-schema.mjs` | Multi-line JSON-LD blocks, nested HTML; grep is brittle |
| Lighthouse score aggregation | Run once, fail on flake | Lighthouse median-of-3 invocations with `jq` parsing | Single-run variance on `performance` score is ±10 points; median stabilizes |
| Open Graph image generation | Custom OG image rendering pipeline | **Defer entirely (D-15: OG image is v1.5)** | Joe's photo set is the bottleneck; emit text-only OG now, upgrade with photos |
| `dateModified` "Last updated" date formatting | Custom locale formatter | `Intl.DateTimeFormat('en-US', { year, month: 'long', day })` (built-in) | Built-in node API, no dep |

**Key insight:** AEO/perf/meta domain is "use the boring tools." Every novel idea is a worse choice than the standard tool for the same problem.

## Runtime State Inventory

> Phase 5 is greenfield additive — no rename, no migration, no data backfill. Section included with explicit "nothing found" entries to confirm no runtime state is at risk.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | **None.** Phase 5 adds schema components, env vars, and meta tags. No data is migrated; no field names change. `business.json` is extended (additive: new keys `geo`, `priceRange`) but no existing keys rename. | None |
| Live service config | Microsoft Clarity project to be created at clarity.microsoft.com (one-time, operator-managed); Vercel project env var `PUBLIC_CLARITY_PROJECT_ID` to be set in Vercel dashboard (one-time, operator-managed); Vercel project env var `VERCEL_DEEP_CLONE=1` may be needed for git mtime (operator-managed) | Operator notes in Phase 5 plan — clearly separate "operator does in Vercel dashboard" from "code changes" |
| OS-registered state | **None** — no cron jobs, daemons, or scheduled tasks introduced. Pre-build script runs at `npm run build` only. | None |
| Secrets and env vars | `PUBLIC_CLARITY_PROJECT_ID` — read at build time by `Base.astro`. Documented in `.env.example` (committed); actual `.env.local` git-ignored (already in `.gitignore` per Phase 1). Clarity IDs are not sensitive (they're public in rendered HTML), so missing var = telemetry off, not security risk. | Add `.env.example` line; add `PUBLIC_CLARITY_PROJECT_ID` to Vercel project settings before Phase 6 deploy |
| Build artifacts / installed packages | `site/dist/` is regenerated each build. `git-mtimes.json` is committed (so CI builds without git history available can still read it) — but regenerated on every pre-build. New devDeps in `package-lock.json` (lighthouse, schema-dts, cheerio) — committed. | None — no manual reinstall path |

## Common Pitfalls

### Pitfall 1: `JSON.stringify` does not escape `</script>` in string values
**What goes wrong:** A business-data field containing the literal substring `</script>` (case-insensitive in some parsers) would prematurely close the JSON-LD `<script>` tag, breaking the page and enabling potential XSS.
**Why it happens:** `JSON.stringify` is correct for JSON-in-JS contexts but doesn't know about the HTML script-tag boundary [CITED: pragmaticwebsecurity.com/articles/spasecurity/json-stringify-xss].
**How to avoid:** Audit script (D-23.1, extended) greps each emitted JSON-LD block for the substring `</script>` outside the closing tag — fail if found. Alternative: replace `</` with `<\/` inside the stringified output before `set:html`. Current business data has zero risk; the audit check is the cheap insurance.
**Warning signs:** Schema validator complains about malformed JSON, or page rendering breaks suddenly when a data field is added.

### Pitfall 2: `@astrojs/sitemap` does not generate `sitemap.xml`
**What goes wrong:** Plan or robots.txt references `/sitemap.xml`; Google fetches 404.
**Why it happens:** Default output is `sitemap-index.xml` + `sitemap-0.xml` [CITED: docs.astro.build/en/guides/integrations-guide/sitemap/]. CONTEXT D-18 already references `sitemap-index.xml` (correct). The trap is the audit script — parse `-0.xml` (URL list), assert robots.txt points at `-index.xml` (entry).
**How to avoid:** Audit check D-23.2 fetches `dist/sitemap-0.xml` (NOT `sitemap.xml`) and parses the `<urlset>` for the 17 URLs.
**Warning signs:** "sitemap not found" in Search Console after Phase 7 verification; or audit script returning 0 URLs because it was looking for `sitemap.xml`.

### Pitfall 3: Vercel shallow-clone breaks git mtime
**What goes wrong:** `git log -1 --pretty=format:%cI <file>` returns empty on Vercel's default shallow clone (depth=10 by default). Empty result → schema emits `dateModified: ""` → Article schema invalid.
**Why it happens:** Vercel optimizes git fetch for build speed [CITED: docs.astro.build/en/recipes/modified-time/ caveat].
**How to avoid:** Set `VERCEL_DEEP_CLONE=1` in Vercel project environment variables. Or have the pre-build script fall back to current time if `git log` returns empty. Recommend BOTH — env var for correctness, fallback for safety.
**Warning signs:** Article dateModified empty in built HTML; Google Rich Results warns about missing `dateModified`.

### Pitfall 4: Astro Image `priority` set on more than one image per page
**What goes wrong:** Browser prioritizes multiple "high-priority" fetches; LCP candidate gets de-prioritized.
**Why it happens:** Copy-paste from another template that already had `priority`.
**How to avoid:** Lighthouse `priority-hints` audit. Also: code review — only the LCP candidate per page gets `priority`.
**Warning signs:** Lighthouse "Avoid setting fetchPriority on multiple images" warning.

### Pitfall 5: FAQPage emitted on every page → Google Search Console "duplicate FAQ" warnings
**What goes wrong:** Master `/faq` and per-page FAQ both emit FAQPage with overlapping questions → Search Console flags.
**Why it happens:** Convenience copy-paste.
**How to avoid:** Per-page FAQPage emits ONLY that page's specific Q&As (3-6 per service/neighborhood, 6 niche-landing, 10+ on master). No duplicate `Question.name` across page-level FAQPage emissions. Master `/faq` is the topic-grouped union — its own FAQPage block. The same physical question text appearing on `/faq` and on `/fades` is acceptable (different parents); but the same FAQPage block shouldn't be re-rendered.
**Warning signs:** Rich Results Test flagging duplicate Question.name within a single page (would be a bug); or Search Console duplicate-schema warning post-Phase-7.

### Pitfall 6: `@id` URL mismatch after custom-domain swap
**What goes wrong:** Phase 5 hard-codes `@id: https://joesbarbershop.vercel.app/#business`; v1.5 swaps to a custom domain; old `@id` lingers and AI parsers see two entities.
**Why it happens:** `@id` is a stable cross-page reference — it should match `business.url`.
**How to avoid:** Add `business.canonicalUrl` field in `business.json` (defaults to Vercel preview). All schema components read `business.canonicalUrl`. Custom-domain swap = one JSON edit (per CONTEXT specifics).
**Warning signs:** v1.5 audit finds the literal `joesbarbershop.vercel.app` in the schema after the custom domain landed.

### Pitfall 7: Clarity script emitted in dev → dev sessions pollute prod dashboard
**What goes wrong:** Without PROD gating, every `astro dev` page-view fires data to Clarity.
**Why it happens:** Skipping the `{enableClarity && ...}` template guard.
**How to avoid:** D-02 mandates the gate. Verification: build with `NODE_ENV=development astro dev` and assert no `clarity.ms/tag` substring in the rendered HTML.
**Warning signs:** Clarity dashboard showing localhost or `vercel.app` preview sessions when only prod should fire.

### Pitfall 8: Google FAQPage rich-snippet deprecation (May 2026) confused with AEO play obsolescence
**What goes wrong:** Reader sees "Google killed FAQ rich results" and concludes FAQPage schema is obsolete; cuts it from Phase 5.
**Why it happens:** [VERIFIED: developers.google.com/search/blog/2023/08/howto-faq-changes + 2026-05-07 Google announcement] Google deprecated FAQ rich snippets as of 2026-05-07.
**How to avoid:** FAQPage schema **remains the highest-AI-citation-rate schema type** per AEO playbook + multiple 2026 citation studies. ChatGPT, Perplexity, Gemini, and Google AI Mode all parse it. Phase 5 ships it as planned. Google's explicit guidance: do NOT proactively remove existing FAQPage markup.
**Warning signs:** A reviewer suggests deleting FAQPage components. Push back with the citation studies + AEO playbook.

## Code Examples

### HairSalon schema component (full, with all D-04 additions)
```astro
---
// site/src/components/schema/HairSalon.astro
// Source pattern: https://docs.astro.build/en/reference/directives-reference/ + schema-dts
import type { HairSalon, WithContext } from 'schema-dts';
import { business, toE164, toOpeningHoursSpecification } from '../../data/business';

const SITE_URL = business.canonicalUrl;  // https://joesbarbershop.vercel.app

const schema: WithContext<HairSalon> = {
  '@context': 'https://schema.org',
  '@type': 'HairSalon',
  '@id': `${SITE_URL}/#business`,
  name: business.name,
  url: SITE_URL,
  telephone: toE164(business.phone),         // "+16198912775"
  priceRange: business.priceRange,           // "$$"
  image: `${SITE_URL}/photos/03-interior-hero.jpg`,
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
  areaServed: business.areaServed.map((name) => ({ '@type': 'City', name })),
  sameAs: Object.values(business.sameAs).filter(Boolean),
};
---
<script type="application/ld+json" set:html={JSON.stringify(schema)} />
```

### `business.ts` helper additions
```typescript
// site/src/data/business.ts — additions per D-04
export function toE164(displayPhone: string): string {
  // "(619) 891-2775" -> "+16198912775"
  const digits = displayPhone.replace(/\D/g, '');
  return `+1${digits}`;
}

export function toOpeningHoursSpecification(
  hours: BusinessRecord['hours']
): Array<{
  '@type': 'OpeningHoursSpecification';
  dayOfWeek: string;
  opens: string;
  closes: string;
}> {
  const dayMap: Record<string, string> = {
    monday: 'Monday', tuesday: 'Tuesday', wednesday: 'Wednesday',
    thursday: 'Thursday', friday: 'Friday', saturday: 'Saturday', sunday: 'Sunday',
  };
  return Object.entries(hours)
    .filter(([, h]) => h !== null)
    .map(([day, h]) => ({
      '@type': 'OpeningHoursSpecification' as const,
      dayOfWeek: dayMap[day],
      opens: h!.open,
      closes: h!.close,
    }));
}

export function combinedAggregateRating(ratings: BusinessRecord['ratings']) {
  // Weighted by review count
  const platforms = Object.values(ratings);
  const totalCount = platforms.reduce((sum, r) => sum + r.count, 0);
  const weightedSum = platforms.reduce((sum, r) => sum + r.value * r.count, 0);
  return {
    '@type': 'AggregateRating' as const,
    ratingValue: Number((weightedSum / totalCount).toFixed(2)),
    reviewCount: totalCount,
    bestRating: 5,
    worstRating: 1,
  };
}
```

### Schema validator (audit D-23.1)
```javascript
// site/scripts/validate-schema.mjs
import { readFileSync, readdirSync, statSync } from 'fs';
import { join } from 'path';
import { load } from 'cheerio';

const REQUIRED_FIELDS = {
  HairSalon:               ['name', 'address', 'telephone', 'openingHoursSpecification'],
  LocalBusiness:           ['name', 'address', 'telephone'],
  Service:                 ['name', 'provider'],
  FAQPage:                 ['mainEntity'],
  Question:                ['name', 'acceptedAnswer'],
  Answer:                  ['text'],
  Person:                  ['name'],
  Article:                 ['headline', 'datePublished', 'author'],
  AggregateRating:         ['ratingValue', 'reviewCount'],
  Review:                  ['author', 'reviewRating'],
  PostalAddress:           ['streetAddress', 'addressLocality', 'addressRegion', 'postalCode'],
  GeoCoordinates:          ['latitude', 'longitude'],
  OpeningHoursSpecification: ['dayOfWeek', 'opens', 'closes'],
  Offer:                   ['price', 'priceCurrency'],
};

function findHtmlFiles(dir) { /* recursive walk for *.html */ }

function checkBlock(schema, file) {
  const errs = [];
  const required = REQUIRED_FIELDS[schema['@type']];
  if (!required) return errs;  // type we don't validate
  for (const field of required) {
    if (schema[field] === undefined || schema[field] === '' || schema[field] === null) {
      errs.push(`${file}: ${schema['@type']} missing required field '${field}'`);
    }
  }
  // Recurse into nested objects
  for (const v of Object.values(schema)) {
    if (v && typeof v === 'object' && !Array.isArray(v) && v['@type']) {
      errs.push(...checkBlock(v, file));
    } else if (Array.isArray(v)) {
      for (const item of v) {
        if (item && typeof item === 'object' && item['@type']) {
          errs.push(...checkBlock(item, file));
        }
      }
    }
  }
  return errs;
}

const files = findHtmlFiles('site/dist');
const allErrors = [];
for (const file of files) {
  const html = readFileSync(file, 'utf8');
  const $ = load(html);
  $('script[type="application/ld+json"]').each((_, el) => {
    const raw = $(el).text();
    // </script> guard (Pitfall 1)
    if (raw.includes('</script>')) {
      allErrors.push(`${file}: JSON-LD block contains literal '</script>'`);
      return;
    }
    let parsed;
    try { parsed = JSON.parse(raw); }
    catch (e) {
      allErrors.push(`${file}: unparseable JSON-LD: ${e.message}`);
      return;
    }
    allErrors.push(...checkBlock(parsed, file));
  });
}
if (allErrors.length) {
  console.error(allErrors.join('\n'));
  process.exit(1);
}
console.log(`Schema OK — ${files.length} HTML files inspected.`);
```

### Lighthouse audit (D-23.6)
```bash
# Inside scripts/audit.sh, new check function
check_lighthouse_homepage() {
  local url="http://localhost:4321/"   # local astro preview
  local out_dir="${SCRIPT_DIR}/.lh-tmp"
  mkdir -p "$out_dir"
  local scores=()
  local lcps=()
  local cls_vals=()
  for run in 1 2 3; do
    npx --yes lighthouse "$url" \
      --preset=mobile \
      --output=json \
      --output-path="${out_dir}/run-${run}.json" \
      --quiet \
      --chrome-flags="--headless --no-sandbox" \
      >/dev/null 2>&1 || { fail "lighthouse-homepage" "lighthouse run $run failed"; return; }
    scores+=("$(jq '.categories.performance.score * 100' "${out_dir}/run-${run}.json")")
    lcps+=("$(jq '.audits["largest-contentful-paint"].numericValue' "${out_dir}/run-${run}.json")")
    cls_vals+=("$(jq '.audits["cumulative-layout-shift"].numericValue' "${out_dir}/run-${run}.json")")
  done
  # Median of 3 (bash + jq)
  local perf_median=$(printf '%s\n' "${scores[@]}" | sort -n | sed -n '2p')
  local lcp_median=$(printf '%s\n' "${lcps[@]}" | sort -n | sed -n '2p')
  local cls_median=$(printf '%s\n' "${cls_vals[@]}" | sort -n | sed -n '2p')

  # PERF-02: >= 90 mobile performance
  if (( $(echo "$perf_median >= 90" | bc -l) )); then pass
  else fail "lighthouse-performance" "median performance ${perf_median} < 90"; fi
  # PERF-04: LCP < 2500ms
  if (( $(echo "$lcp_median < 2500" | bc -l) )); then pass
  else fail "lighthouse-lcp" "median LCP ${lcp_median}ms >= 2500ms"; fi
  # PERF-04: CLS < 0.1
  if (( $(echo "$cls_median < 0.1" | bc -l) )); then pass
  else fail "lighthouse-cls" "median CLS ${cls_median} >= 0.1"; fi
}
```

Notes:
- Run against `astro preview` (background) — fastest, fewest moving parts.
- Median-of-3 is the recommendation; 5 if flake observed.
- `--preset=mobile` is Lighthouse's standard mobile config (slow 4G, 4× CPU throttle).
- A/SEO categories: add `accessibility.score` / `seo.score` checks the same way (PERF-02 thresholds 95/95).

## Schema.org required-field cheatsheet

For `validate-schema.mjs` and as a planner reference. Required as per **Google's structured-data requirements** [CITED: developers.google.com/search/docs/appearance/structured-data/local-business] (Schema.org itself rarely declares fields formally "required"; Google's requirements are the operational floor).

| Type | Required fields | Source |
|------|-----------------|--------|
| `HairSalon` (inherits LocalBusiness) | `name`, `address`, `telephone`, `openingHoursSpecification` | Google LocalBusiness rich results |
| `LocalBusiness` | `name`, `address`, `telephone` | Google LocalBusiness rich results |
| `PostalAddress` | `streetAddress`, `addressLocality`, `addressRegion`, `postalCode`, `addressCountry` | Google LocalBusiness |
| `GeoCoordinates` | `latitude`, `longitude` | Google (geo recommended for LocalBusiness) |
| `OpeningHoursSpecification` | `dayOfWeek`, `opens`, `closes` | Schema.org operational |
| `Service` | `name`, `provider` (Google adds `areaServed`, `offers` as strongly recommended) | Schema.org / Google |
| `Offer` | `price`, `priceCurrency` | Google product rich results |
| `FAQPage` | `mainEntity` (array of Question) | Google FAQPage |
| `Question` | `name`, `acceptedAnswer` | Google FAQPage |
| `Answer` | `text` | Google FAQPage |
| `Person` | `name` (recommended: `image`, `jobTitle`) | Schema.org |
| `Article` | `headline`, `datePublished`, `author`, `image` (Google recommends but warns if absent) | Google Article |
| `AggregateRating` | `ratingValue`, `reviewCount` (or `ratingCount`) | Google review rich results |
| `Review` | `author`, `reviewRating` (with `ratingValue`) | Google review rich results |

**Note on FAQPage:** Google deprecated rich-result *display* on 2026-05-07 — but the schema validates and parses identically; AI engines (ChatGPT/Perplexity/Gemini/Google AI Mode) continue to consume it. [VERIFIED: developers.google.com/search/blog/2023/08/howto-faq-changes + 2026-05 multiple sources]

## State of the Art

| Old approach | Current approach (2026) | When changed | Impact |
|--------------|-------------------------|--------------|--------|
| Hand-written `<script>` tags emitting JSON-LD with string template literals | `set:html={JSON.stringify(obj)}` + `schema-dts` types | Astro 2+ (`set:html` is stable since 1.x; schema-dts is a separate ecosystem choice) | Type-safe + escape-safe |
| `@vercel/analytics` `inject()` from `<script>` block | `<Analytics />` component from `@vercel/analytics/astro` | `@vercel/analytics@1.4.0` (2024) | Idiomatic Astro; route-aware |
| Astro `<Image fetchpriority="high" loading="eager" decoding="sync" />` (three attributes) | Astro `<Image priority />` shorthand | Astro 6 (2026) | Cleaner; one source of truth for LCP image |
| `@astrojs/sitemap` < 3.x emitting `sitemap.xml` | `sitemap-index.xml` + `sitemap-0.xml` (current default) | `@astrojs/sitemap@3.x` | Audit/robots.txt MUST reference index file |
| FAQPage targeting Google rich snippets | FAQPage targeting AI engines (ChatGPT/Perplexity/Gemini/Google AI Mode) | 2026-05-07 (Google rich result drop) | Strategy unchanged — playbook's #1 priority schema stays #1 for *AI* citations |
| Site-wide `robots.txt` opting out AI bots | Site-wide allow-all incl. GPTBot/ClaudeBot/PerplexityBot | 2024-2026 AEO consensus | D-18 stays allow-all |

**Deprecated/outdated:**
- **Google FAQ rich snippet** — display removed 2026-05-07 [VERIFIED]. **Schema retained for AI surfaces.**
- **HowTo schema rich snippet** — removed 2023 (Google's same announcement). Not relevant to Phase 5.
- **Astro legacy `src/content/config.ts` nested path** — Astro 6 requires flat `src/content.config.ts` (already in place per Phase 2 D-24).
- **`@vercel/analytics` `inject()` script-tag pattern** — superseded by `<Analytics />` component since v1.4 (we install v2.0.1, already correct).

## Assumptions Log

Claims tagged `[ASSUMED]` are based on training knowledge or general ecosystem patterns and not verified for THIS phase via tool calls. The planner and discuss-phase should confirm these before locking decisions.

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Schema-dts version 2.0.0 includes types for `HairSalon`, `OpeningHoursSpecification`, `GeoCoordinates`, `Offer`, `AggregateRating`, `Review`. README example listed `Article`/`Person`/`FAQPage`/`Product`/`Offer` explicitly; other types confirmed by package's stated "complete sets of discriminated type unions for Schema.org vocabulary" but not individually grep'd. | Standard Stack | Low — if a type is missing, fallback to plain `Record<string, unknown>` cast for that one component |
| A2 | Vercel honors `VERCEL_DEEP_CLONE=1` env var to disable shallow clone | Pitfall 3 | Medium — if wrong, git mtime returns empty on Vercel builds; pre-build fallback (current time) covers, but `dateModified` becomes "build time" not "edit time". Verify against Vercel docs during Phase 5 execution. |
| A3 | Microsoft Clarity tracking script source URL is `https://www.clarity.ms/tag/<id>` (per the IIFE snippet found in search). Official Microsoft doc page does not paste the snippet inline; it instead embeds via screenshot. | Pattern 4 | Low — every implementation guide cited shows this exact URL; Clarity hasn't changed install snippets in years |
| A4 | Lighthouse `--preset=mobile` is the canonical preset name in v13.x (legacy was `--preset=desktop`/etc.) | Code example | Low — verify with `lighthouse --help` during execution if unsure; alternative `--form-factor=mobile` works |
| A5 | The `priority` prop on Astro `<Image>` is stable in Astro 6 (not behind `experimental.*`). Search result said "Astro 6 introduces a new `priority` option" but did not link directly to a stable-release changelog. | Pattern 5 | Low — `fetchpriority="high"` attribute fallback always works |
| A6 | `@vercel/analytics/astro` and `@vercel/speed-insights/astro` subpath imports both work in v2.0.x. Confirmed at Medium-confidence level via multiple search results. | Standard Stack | Low — if subpath fails, the docs show alternative `inject()` pattern as fallback |

**Recommendation to discuss-phase / planner:** A1-A2 are the only assumptions worth flagging to the user. A3-A6 are well-trodden patterns where any failure is loud and the fallback obvious.

## Open Questions

1. **Geocoding source for `geo.latitude/longitude` of 723 E Bradley Ave #C, El Cajon CA 92021** (CONTEXT D-04 + Claude's discretion)
   - What we know: Address is canonical from Phase 2 D-21; vault `joes-barbershop-sandbox.md` audit baseline confirms.
   - What's unclear: Whether to use Nominatim (OpenStreetMap API, free, no key), Google Maps Geocoding API (requires a key + billing setup), or hand-paste from Google Maps URL.
   - Recommendation: **Hand-paste from Google Maps URL** (`https://maps.google.com/?q=723+E+Bradley+Ave+%23C,+El+Cajon,+CA+92021`). The URL fragment after manual click on the marker gives `@32.8XX,-116.9XX` lat/long. One-shot lookup, no API, deterministic. Cross-check against Nominatim if paranoid. Hand-paste a single time into `business.json.geo`.

2. **`Service` schema `offers` shape — `Offer` vs `PriceSpecification`** (CONTEXT deferred specifics)
   - What we know: CONTEXT says Phase 5 emits basic `Offer { priceCurrency: USD, price: 30 }`. Full `PriceSpecification` deferred.
   - What's unclear: Does `Offer.priceCurrency: "USD"` + `Offer.price: 30` validate cleanly in Google Rich Results, or does it want `priceSpecification: { '@type': 'UnitPriceSpecification', priceCurrency: 'USD', price: 30 }`?
   - Recommendation: Start with simple `Offer { price, priceCurrency }` — it's the documented minimum. Validate via D-25 Rich Results paste; widen to `PriceSpecification` only if Rich Results flags the simpler form.

3. **`aggregateRating` formula on homepage — weighted average vs higher-of** (CONTEXT D-04 Claude discretion)
   - What we know: Two ratings (Google 5.0/114, Yelp 4.9/33). Sum: 147 reviews. Weighted average: (5.0×114 + 4.9×33)/147 = 4.978 ≈ 4.98.
   - What's unclear: Some AEO sources recommend picking the higher rating to avoid "ratings inflation" appearance; others prefer weighted average.
   - Recommendation: **Weighted average rounded to 2 decimals: 4.98 / 147 reviews.** Most defensible mathematically; documented in the `combinedAggregateRating()` helper. If a future review platform shifts numbers significantly, the math holds.

4. **Sitemap `priority`/`changefreq` — emit or omit?** (CONTEXT D-17)
   - What we know: D-17 says skip — modern Google ignores these largely.
   - What's unclear: Does `@astrojs/sitemap` v3.7.2 emit them by default with placeholder values, or only when configured? Searching docs: it does not emit by default in 3.x.
   - Recommendation: Leave `astro.config.mjs` `sitemap()` call argument-less (already is). Default behavior emits `<loc>` + `<lastmod>` only (the latter from page mtime, which Vercel may make stale but Google still uses).

5. **`Person` schema for Joe — what fields beyond `name`?** (D-09)
   - What we know: About page emits Person × 1 (Alex dropped per Phase 3 cleanup).
   - What's unclear: Whether to include `image` (we don't have a Joe headshot yet — placeholder is JD initials per `_showcase_review_pending`), `jobTitle: "Barber"`, `worksFor: { @id: '#business' }`.
   - Recommendation: Emit `{ name, jobTitle, worksFor }`. Skip `image` until Joe sends a real headshot (v1.5). Avoids the Rich Results Test "missing image" warning by simply omitting the field rather than pointing at the placeholder card.

6. **Robots.txt — `Disallow: /api/`?** (CONTEXT D-18 default allow-all)
   - What we know: D-18 specifies allow-all.
   - What's unclear: The site has no `/api/` route currently. Pre-emptive disallow is over-engineering.
   - Recommendation: Stick with bare `User-agent: * / Allow: / / Sitemap: ...`. Three lines.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Node.js | Astro build, audit scripts | ✓ | v25.9.0 (installed) | — |
| npm | Package management | ✓ | 11.12.1 | — |
| Git | dateModified via git log + audit | ✓ | 2.50.1 (Apple Git-155) | Use `statSync(mtime)` fallback in pre-build script for safety |
| `lighthouse` | Audit D-23.6 | ✗ (not installed) | needs `13.3.0` | `npx --yes lighthouse@13` (zero-install via npx — recommended for audit script; avoids forcing global install) |
| `cheerio` | Audit D-23.1 schema validator | ✗ (not installed) | install latest 1.x as devDep | `npm install --save-dev cheerio` during Phase 5 plan |
| `schema-dts` | Type-safe schema components | ✗ (not installed) | needs `2.0.0` | — |
| `@vercel/analytics` | Telemetry | ✗ (not installed) | needs `2.0.1` | — |
| `@vercel/speed-insights` | Telemetry | ✗ (not installed) | needs `2.0.0` | — |
| `jq` | Audit script JSON parsing (Lighthouse output) | unknown — verify on macOS | — | `node -e "console.log(require('./run-1.json').categories.performance.score)"` as fallback; jq is preferable for one-liners in bash |
| `bc` | Audit script float comparison | almost always present on macOS | — | `awk` arithmetic as fallback |
| Vercel project env var `PUBLIC_CLARITY_PROJECT_ID` | Clarity script gating | requires operator action | — | If unset, build skips Clarity emission (already handled by `enableClarity && ...` guard) |
| Vercel project env var `VERCEL_DEEP_CLONE=1` | git mtime on Vercel | requires operator action | — | Pre-build script falls back to current time if `git log` returns empty |
| Microsoft Clarity project | Telemetry recipient | requires operator action (clarity.microsoft.com sign-up) | — | If unset, no telemetry to dashboard but build still succeeds |
| Google Rich Results Test | Manual gate D-25 | ✓ (public web tool) | — | — |

**Missing dependencies with no fallback:** None.

**Missing dependencies with fallback:**
- All new npm dependencies — install during Phase 5 Wave 0 (audit-script setup).
- Vercel env vars — operator-managed; planner adds an explicit "operator action" task in the plan.
- Clarity project — operator-managed; planner adds it as a pre-Phase-6 gate.

## Validation Architecture

> `workflow.nyquist_validation: true` in `.planning/config.json` — section included.

### Test Framework

Joe's Barbershop site does NOT use a test framework (Jest/Vitest/Playwright). Validation is **shell + node script audit** built on the Phase 3 `scripts/audit.sh` skeleton. Phase 5 extends with 6 new check functions per D-23.

| Property | Value |
|----------|-------|
| Framework | bash `audit.sh` + node `validate-schema.mjs` (no test runner) |
| Config file | `.planning/phases/03-unique-pages/scripts/audit.sh` (existing, extended) |
| Quick run command | `bash .planning/phases/03-unique-pages/scripts/audit.sh --check <name>` |
| Full suite command | `bash .planning/phases/03-unique-pages/scripts/audit.sh` |
| Phase gate command | `cd site && npm run build && bash ../.planning/phases/03-unique-pages/scripts/audit.sh` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test type | Automated command | File exists? |
|--------|----------|-----------|-------------------|-------------|
| AEO-01 | HairSalon JSON-LD on every page | structural | `bash audit.sh --check schema-hairsalon-everywhere` | ❌ Wave 0 — new check |
| AEO-02 | FAQPage JSON-LD wherever FAQs appear | structural | `bash audit.sh --check schema-faqpage-presence` | ❌ Wave 0 |
| AEO-03 | Service JSON-LD on each service page | structural | `bash audit.sh --check schema-service-per-page` | ❌ Wave 0 |
| AEO-04 | Person JSON-LD on /about | structural | `bash audit.sh --check schema-person-about` | ❌ Wave 0 |
| AEO-05 | BLUF first-100-words declarative | content | `bash audit.sh --check bluf-spot-check` | ❌ Wave 0 (extend Phase 3's `bluf-position`) |
| AEO-06 | Zero accordions / tabs | grep | `bash audit.sh --check no-accordions` | ✅ exists (Phase 3) |
| AEO-07 | No text-as-image | grep heuristic | `bash audit.sh --check text-as-image` | ❌ Wave 0 |
| AEO-08 | H2/H3 self-contained answer capsules | manual sampled | `bash audit.sh --check bluf-spot-check` (proxy) + visual review | partial |
| AEO-09 | sameAs links to GBP/Yelp/IG/FB | structural | implicit in HairSalon schema; `bash audit.sh --check schema-hairsalon-everywhere` validates `sameAs` non-empty | ❌ Wave 0 |
| PERF-01 | Mobile responsive parity | visual / manual | manual eyeball + Lighthouse `viewport` audit | manual |
| PERF-02 | Lighthouse mobile P90/A95/S95 | metric | `bash audit.sh --check lighthouse-homepage` median-of-3 | ❌ Wave 0 |
| PERF-03 | Hero `fetchpriority="high"` + lazy below-fold | structural | `bash audit.sh --check hero-fetchpriority` greps `dist/*.html` for `fetchpriority="high"` on exactly one image per page | ❌ Wave 0 |
| PERF-04 | LCP < 2.5s, CLS < 0.1 on homepage | metric | `bash audit.sh --check lighthouse-homepage` median LCP/CLS | ❌ Wave 0 |
| META-01 | Sitemap covers 17 URLs | structural | `bash audit.sh --check sitemap-17-urls` | ❌ Wave 0 |
| META-02 | Unique title + description per page | structural | `bash audit.sh --check meta-unique-titles` parses every dist/*.html for unique `<title>` + `<meta description>` | ❌ Wave 0 |
| META-03 | OG + Twitter Card on every page | structural | `bash audit.sh --check meta-og-twitter` greps for `og:title`/`og:url`/`twitter:card` on every page | ❌ Wave 0 |
| META-04 | robots.txt references sitemap | structural | `bash audit.sh --check robots-txt-sitemap` | ❌ Wave 0 |

### Concrete Thresholds (exit-code enforced)

| Check | Pass threshold | Source |
|-------|----------------|--------|
| `schema-hairsalon-everywhere` | Every page in `dist/*.html` contains exactly ONE `HairSalon` JSON-LD block with `name`/`address`/`telephone`/`openingHoursSpecification` present | D-06, D-07 |
| `schema-faqpage-presence` | Pages with FAQ DOM elements (`<article class="faq-q">` count > 0) also contain a `FAQPage` JSON-LD block; `mainEntity` count ≥ DOM FAQ count | AEO-02, D-09 |
| `schema-service-per-page` | Each `/fades`, `/classic-cut`, `/kids-cuts`, `/beard-trim`, `/hot-towel-shave`, `/line-up` contains exactly one `Service` block with `name`, `provider.@id`, `offers.price` | AEO-03 |
| `schema-person-about` | `dist/about/index.html` contains a `Person` JSON-LD with `name: "Joe Denesowicz"` | AEO-04, D-09 |
| `bluf-spot-check` | For each of 5 sample pages (`/`, `/fades`, `/bostonia-barber`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`): first 100 words of `<main>` text contain `Joe's Barbershop` AND (`El Cajon`\|`Bostonia`\|`East County`) AND (`barber`\|`barbershop`\|`haircut`\|`fade`\|`shave`) | D-23.5, ROADMAP success criterion #5 |
| `text-as-image` | `grep -rnE "alt=\"[^\"]*\\\$[0-9]\|alt=\"[^\"]*(haircut\|fade\|shave\|hours)\"" site/src/pages site/src/components` returns 0 matches | D-23.4 |
| `lighthouse-performance` | Median-of-3 Performance ≥ 90 | PERF-02 |
| `lighthouse-accessibility` | Median-of-3 Accessibility ≥ 95 | PERF-02 |
| `lighthouse-seo` | Median-of-3 SEO ≥ 95 | PERF-02 |
| `lighthouse-lcp` | Median-of-3 LCP < 2500 ms | PERF-04 |
| `lighthouse-cls` | Median-of-3 CLS < 0.1 | PERF-04 |
| `hero-fetchpriority` | Each page in `dist/*.html` has exactly ONE `<img>` with `fetchpriority="high"` (or zero on text-only article pages like cost guide / niche-landing) | PERF-03 |
| `lazy-below-fold` | Pages with multiple images: all but the priority image carry `loading="lazy"` | PERF-03 |
| `sitemap-17-urls` | `dist/sitemap-0.xml` parsed; URL count == 17; URL set is exactly the contents of `canonical-slugs.txt` (set equality) | META-01 |
| `meta-unique-titles` | Across all `dist/**/index.html`: every `<title>` is unique; every `<meta name="description">` is unique; every page has both | META-02 |
| `meta-og-twitter` | Every page has `og:title`, `og:url`, `og:type`, `og:site_name`, `twitter:card`, `twitter:title` | META-03 |
| `robots-txt-sitemap` | `dist/robots.txt` exists; contains line `Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml`; HEAD that URL via curl returns 200 (or local preview equivalent) | META-04, D-18 |
| `jsonld-no-script-close` | No emitted JSON-LD block contains the substring `</script>` (only the closing tag itself) | Pitfall 1 |

### Sampling Rate

- **Per task commit (Wave N tasks):** `bash audit.sh --check <specific-check>` — run only the check covering the task's output.
- **Per wave merge:** `bash audit.sh` — full suite (skips pages not yet built).
- **Phase gate (before /gsd-verify-work):** `cd site && npm run build && bash audit.sh` — full suite, zero failures, zero skips.
- **Manual gate (one-time, D-25):** Paste homepage HTML + niche-landing HTML into `https://search.google.com/test/rich-results`; screenshot each result; save to `.planning/phases/05-aeo-performance-meta/rich-results/`.

### Wave 0 Gaps

- [ ] `site/scripts/validate-schema.mjs` — node script implementing required-field checks (covers AEO-01..04, AEO-09)
- [ ] `site/scripts/generate-mtimes.mjs` — pre-build node script for dateModified (covers D-10)
- [ ] `site/.env.example` — documents `PUBLIC_CLARITY_PROJECT_ID` (covers D-03)
- [ ] `.planning/phases/03-unique-pages/scripts/audit.sh` — extended with check functions for the 19 thresholds above (covers D-23.1-6, all AEO-/PERF-/META- requirements)
- [ ] `cheerio`, `schema-dts`, `lighthouse` installed as devDeps (covers all schema/audit/perf checks)
- [ ] `@vercel/analytics`, `@vercel/speed-insights` installed as deps (covers D-01)
- [ ] `site/public/robots.txt` (covers META-04, D-18)
- [ ] `.planning/phases/05-aeo-performance-meta/rich-results/` directory (covers D-25)

## Security Domain

> `security_enforcement` not explicitly set in config — default to enabled.

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | No authentication surface — public static site |
| V3 Session Management | no | No sessions |
| V4 Access Control | no | All routes public |
| V5 Input Validation | partial | No user input to validate at runtime (static site); but **build-time inputs** (business.json, collection markdown) flow into JSON-LD via `set:html` — escape behavior covered by Pitfall 1 |
| V6 Cryptography | no | No secrets in code; Clarity ID is public; sameAs URLs are public |
| V7 Error Handling | n/a | Static site; build failures surface in CI |
| V8 Data Protection | partial | Microsoft Clarity records session replays — covered by Clarity's built-in PII masking defaults; not a code concern |
| V9 Communications | no | Vercel terminates TLS; no app-level TLS code |
| V10 Malicious Code | no | All deps from public npm registry; `package-lock.json` committed |
| V11 Business Logic | no | No transactional flows |
| V12 File Resources | no | No file upload |
| V13 API and Web Services | no | No API |
| V14 Configuration | partial | Vercel project env var `PUBLIC_CLARITY_PROJECT_ID` — `.env.local` git-ignored already; `.env.example` documents the variable |

### Known Threat Patterns for static-site-on-Vercel + JSON-LD

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| JSON-LD `</script>` injection via data field | Tampering | Audit-script guard (Pitfall 1) — fails build if any emitted JSON-LD contains `</script>` substring |
| Open Graph URL spoofing (someone setting `og:url` to a malicious URL via collection data) | Tampering | `og:url` is computed from `Astro.url` (the actual rendered URL), not user-supplied — no injection vector |
| Clarity recording sensitive fields (e.g., a tip jar amount or future booking form) | Information Disclosure | Clarity's default masking covers `<input type="password">` and similar; no sensitive forms exist on this site today (no booking form on the showcase build). Revisit if booking is added. |
| Vercel preview URL exposure (Joe's preview accessible to anyone with URL) | Information Disclosure | By design — D-25 / Phase 6 puts the preview in front of Joe. No customer PII; just public business info. |
| Schema content that misrepresents the business (e.g., fake AggregateRating) | Repudiation | All schema sourced from `business.json` which sources from real GBP/Yelp public data — defensible. The asOf timestamp on ratings is the audit trail. |
| Telemetry tracking script CSP bypass | Tampering | No CSP currently configured (acceptable for a static showcase site). Phase 7 may add a `vercel.json` `headers` block with CSP if Joe's brand demands it; for v1, scope-limited. |

## Project Constraints (from CLAUDE.md)

The repo's `./CLAUDE.md` enforces these constraints. Phase 5 plans MUST honor:

| Constraint | How Phase 5 Honors |
|------------|--------------------|
| Astro stack — no Tailwind, zero-JS-by-default | Schema components emit only `<script type="application/ld+json">` (declarative data, not behavior); Clarity/Analytics/SpeedInsights are exemptions for telemetry; no hydration directives anywhere |
| OD-5 design fidelity, no Tailwind | Schema components have NO CSS; visible "Last updated:" line styled in the consuming page's scoped `<style>` block using existing tokens |
| 6-photo limit | OG image deferred to v1.5 (D-15); no new image generation needed |
| AEO structural rules (BLUF first 100 words, no hidden content, FAQ flat text, schema on every page) | Already locked in CONTEXT; audit script enforces |
| No live deployment before Joe approves | Phase 5 ends at audit-green build; Phase 6 deploys |
| No edits to Joe's external surfaces (GBP, Yelp, Booksy) | Out of scope — `sameAs` URLs already in `business.json` from Phase 2 |
| No duplication of vault content in repo | Schema and meta only reference business data, not vault narratives |
| Git commits: short single-line, no body, no Claude attribution | Phase 5 plan tasks must follow |
| GSD workflow: no Edit/Write outside a GSD command | Phase 5 execution flows through `/gsd-execute-phase` |

## Sources

### Primary (HIGH confidence)

- [Astro Template Directives Reference (`set:html`)](https://docs.astro.build/en/reference/directives-reference/) — verified `set:html` does not auto-escape; user must trust the value or escape manually
- [Astro Recipe: Add Last Modified Time](https://docs.astro.build/en/recipes/modified-time/) — canonical `remarkModifiedTime` plugin + `execSync('git log -1 --pretty="format:%cI" ...')`; explicit Vercel shallow-clone caveat
- [Astro Images guide](https://docs.astro.build/en/guides/images/) — `priority` prop semantics
- [Astro Environment Variables](https://docs.astro.build/en/guides/environment-variables/) — `import.meta.env.PROD` build-time replacement
- [Astro Vercel adapter docs](https://docs.astro.build/en/guides/integrations-guide/vercel/) — adapter config
- [@astrojs/sitemap docs](https://docs.astro.build/en/guides/integrations-guide/sitemap/) — default filenames are `sitemap-index.xml` + `sitemap-0.xml`
- [Vercel Astro guide](https://vercel.com/docs/frameworks/frontend/astro) — Vercel-specific Astro integration
- [Vercel Analytics package docs](https://vercel.com/docs/analytics/package) — `<Analytics />` component pattern
- [Vercel Speed Insights package docs](https://vercel.com/docs/speed-insights/package) — `<SpeedInsights />` component
- [Microsoft Clarity setup guide](https://learn.microsoft.com/en-us/clarity/setup-and-installation/clarity-setup) — manual install, `<head>` placement, async behavior
- [schema-dts GitHub README](https://github.com/google/schema-dts) — `WithContext<T>` pattern + type coverage claim
- [Schema.org HairSalon spec](https://schema.org/HairSalon) — type hierarchy + inherited properties
- [Google: Mark Up FAQs with Structured Data](https://developers.google.com/search/docs/appearance/structured-data/faqpage) — FAQPage required fields
- [Google: Local Business structured data](https://developers.google.com/search/docs/appearance/structured-data/local-business) — LocalBusiness/HairSalon required fields
- [Google blog: Changes to HowTo and FAQ rich results](https://developers.google.com/search/blog/2023/08/howto-faq-changes) — original deprecation notice
- [Lighthouse documentation: Understanding Results](https://github.com/GoogleChrome/lighthouse/blob/main/docs/understanding-results.md) — JSON output structure
- npm registry: `npm view @vercel/analytics version` → 2.0.1 (2026-04-17), `@vercel/speed-insights` → 2.0.0 (2026-04-17), `schema-dts` → 2.0.0 (2026-03-23), `lighthouse` → 13.3.0 (2026-05-07), `astro` → 6.3.1

### Secondary (MEDIUM confidence)

- [Pragmatic Web Security: Are you causing XSS vulnerabilities with JSON.stringify()?](https://pragmaticwebsecurity.com/articles/spasecurity/json-stringify-xss) — `</script>` escape gotcha
- [Tim Eaton: Structured Data (JSON-LD) for AI and Search Engines in Astro](https://timeaton.dev/posts/adding-structured-data-astro/) — confirms `JSON.stringify` + `set:html` pattern
- [Vercel Speed Insights GitHub](https://github.com/vercel/speed-insights) — Astro example directory exists; dev auto-disable
- [Google FAQ Schema Deprecation in 2026 (FAQ JSON-LD)](https://faqjsonld.com/blog/google-faq-deprecation-2026) — confirms 2026-05-07 deprecation date for rich result display
- [Cem Kiray: How to Add JSON-LD Schema for Better SEO in Astro](https://www.cemkiray.com/posts/how-to-add-json-ld-schema-in-astro/) — pattern confirmation
- [Yuri Kan: Lighthouse Performance Testing](https://yrkan.com/blog/lighthouse-performance-testing/) — CLI usage + threshold pattern

### Tertiary (LOW confidence — flagged in Assumptions Log)

- Various AEO/SEO blog posts confirming FAQPage value for AI citations — directional, not authoritative

## Metadata

**Confidence breakdown:**
- Standard stack (Vercel components, schema-dts, Lighthouse): **HIGH** — every package version verified against npm registry on 2026-05-10; integration patterns documented in official Vercel/Astro docs
- Architecture patterns (JSON-LD via `set:html`, git mtime, Image `priority`): **HIGH** — official Astro docs + recipes
- Schema.org required-field cheatsheet: **HIGH** — Google's structured-data developer docs
- FAQPage AI-citation value persisting after Google deprecation: **MEDIUM** — multiple corroborating sources but no single authoritative study cited in this session
- Vercel deep-clone behavior for git mtime: **MEDIUM** — Astro recipe warns but doesn't document the exact env var name; fallback in pre-build script provides safety
- Microsoft Clarity exact snippet URL `clarity.ms/tag/<id>`: **MEDIUM** — Microsoft docs show screenshots not text; multiple implementation guides agree
- Lighthouse output JSON field paths (`categories.performance.score`, `audits.largest-contentful-paint.numericValue`): **HIGH** — GoogleChrome/lighthouse official docs

**Research date:** 2026-05-10
**Valid until:** 2026-06-10 (Astro 6.x, Vercel Analytics/Speed Insights 2.x, schema-dts 2.x are all stable lines; FAQPage rich-snippet deprecation note may evolve in June 2026 when Google removes Rich Results Test FAQ display per their stated timeline — re-verify before Phase 5 plan freeze if any week passes between research and plan)
