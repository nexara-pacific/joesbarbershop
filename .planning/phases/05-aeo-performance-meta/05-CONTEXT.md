# Phase 5: AEO + Performance + Meta - Context

**Gathered:** 2026-05-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 5 makes the 17 already-shipped pages parseable by AI crawlers, fast on mobile, and complete in meta. Concretely:

1. **JSON-LD schema** on every page — `HairSalon` baseline auto-injected via Base.astro on every route with a stable `@id` URL for cross-page entity dedup, plus per-page overlays (`FAQPage`, `Service`, `Person`, `Article`, `AggregateRating`) where appropriate.
2. **business.ts expanded to playbook-grade** — adds geo lat/long, E.164 phone, priceRange, openingHoursSpecification array helper, aggregateRating helper. Becomes the single source of truth for schema field values per Phase 2's data-layer commitment.
3. **Meta tags + Open Graph (text-only)** — every page emits a unique `<title>` ("Topic | Joe's Barbershop" pattern; homepage exempt), `<meta name="description">` (auto-derived from collection BLUF for templated pages, hand-authored for unique pages), and Open Graph text tags (`og:title`/`og:description`/`og:url`/`og:type`/`og:site_name`) plus Twitter `summary` card. OG image is **deferred to v1.5** pending Joe's new photos.
4. **Freshness signals** — Article-schema pages (cost guide, niche-landing) carry `dateModified` from git mtime at build, with a matching visible "Last updated: YYYY-MM-DD" line.
5. **Sitemap + robots.txt** — `sitemap.xml` already wired via `@astrojs/sitemap`; Phase 5 verifies all 17 routes are listed and adds `robots.txt` referencing the sitemap.
6. **On-site telemetry (absorbed from Phase 7)** — Microsoft Clarity + Vercel Web Analytics + Vercel Speed Insights wired in Base.astro. Telemetry fires from Day-0 of the Phase 6 showcase, not Day-N when Phase 7 lands. Phase 7 still owns the harder/paid measurement work (Search Console + Bing Webmaster verification on real domain, CallRail, LocalFalcon, manual prompt panel, Day-0 baseline capture, hire-trigger documentation).
7. **Lighthouse perf hardening** — hit ≥90 Performance / ≥95 Accessibility / ≥95 SEO on mobile; LCP < 2.5s; CLS < 0.1. Hero `fetchpriority="high"`, below-fold `loading="lazy"`, explicit image dimensions, font preconnect retained from Phase 1.
8. **Verification** — `scripts/audit.sh` (existing from Phase 3) extended with a JSON-LD validator pass, sitemap 17-URL link check, robots.txt presence, text-as-image heuristic, and Lighthouse CLI thresholds enforced as exit codes.

This phase deliberately defers:

- Wikidata Q-number + `sameAs` (`AEO-09` already defers to v2 — biggest under-used SMB lever per vault playbook; needs LLC filing + verifiable refs)
- Booksy listing creation (v2; off-site)
- Foursquare + Bing Places claims (v2; off-site — >70% of ChatGPT's local data signal per `aeo-playbook-smb.md`)
- Search Console + Bing Webmaster verification meta tags (Phase 7 — needs production domain, preview URL won't satisfy)
- CallRail dynamic number insertion / LocalFalcon / manual AI prompt panel / hire-trigger doc (Phase 7)
- Per-page-type OG images and Twitter `summary_large_image` (v1.5 — pending Joe's new photos)
- Custom domain registration (v1.5 deferred per `PROJECT.md`)
- `llms.txt` (default skip — two large studies show **zero correlation** with citations per playbook; install once if convenient, expect nothing)

</domain>

<decisions>
## Implementation Decisions

### Telemetry Timing (scope shift from ROADMAP)

- **D-01:** Phase 5 absorbs the three 1-line on-site telemetry tools that ROADMAP originally placed in Phase 7 (`MEAS-01`, `MEAS-02`): **Microsoft Clarity**, **Vercel Web Analytics**, **Vercel Speed Insights**. All three wire in `Base.astro` while we're already touching it for schema + meta. **Rationale:** Phase 7 starts after Joe approves the preview (Phase 6 gate). Wiring telemetry in Phase 5 means the preview Joe first sees is already firing session data + Core Web Vitals — Day-0, not Day-N. Phase 7 retains all measurement work that needs the production domain or paid services (Search Console + Bing Webmaster verification, CallRail dynamic number insertion, LocalFalcon grid tracker, manual AI prompt panel, hire-trigger doc, Day-0 baseline capture).
- **D-02:** Clarity script gated by `import.meta.env.PROD` so dev runs don't emit data into the dashboard. Vercel Analytics + Speed Insights ship as the Astro-native `@vercel/analytics/astro` and `@vercel/speed-insights/astro` components — they self-disable in dev by default.
- **D-03:** Clarity project ID is supplied via `PUBLIC_CLARITY_PROJECT_ID` env var. Set in Vercel project settings (one-time, before Phase 6 deploys). Repo carries an `.env.example` documenting the var (committed) and the actual `.env.local` is git-ignored. Clarity IDs aren't sensitive (they show up in rendered HTML), but env-var management keeps Joe's specific dashboard ID out of git history and makes it trivial to swap if a client uses a shared Clarity workspace later. **Operator note:** create the Clarity project at `clarity.microsoft.com` during Phase 5 execution and set `PUBLIC_CLARITY_PROJECT_ID` in Vercel before Phase 6 deploy.

### Schema Body — business.ts Expansion

- **D-04:** Expand `site/src/data/business.ts` (and its underlying `business.json`) to playbook-grade. Adds:
  - `geo: { latitude: number, longitude: number }` — lat/long for 723 E Bradley Ave #C, El Cajon CA 92021. Resolved via geocoding (planner researches; OpenStreetMap Nominatim or Google Maps API one-shot lookup, hand-verified against Google Maps).
  - `priceRange: "$$"` — derived from $30 average ticket per `joes-barbershop-sandbox.md` (Schema.org convention: `$` < $10, `$$` = $10-$50, `$$$` = $50-$100, `$$$$` = $100+).
  - **E.164 phone helper** — exported function or constant converting the existing display string `(619) 891-2775` to `+16198912775` for schema use. The human-readable display form stays as-is for UI; schema uses E.164.
  - **`openingHoursSpecification` helper** — exported function that maps the existing `business.hours` object (`{ tuesday: { open: "10:00", close: "19:30" }, ... }`) to the Schema.org `OpeningHoursSpecification[]` array structure (`[{ "@type": "OpeningHoursSpecification", "dayOfWeek": "Tuesday", "opens": "10:00", "closes": "19:30" }, ...]`). Skips days where hours are `null` (Sunday, Monday). Time format: `HH:MM` 24-hour per Schema.org spec.
  - **`aggregateRating` helper** — combines Google (5.0/114, asOf 2026-05-08) + Yelp (4.9/33, asOf 2026-05-08) into a single weighted `{ "@type": "AggregateRating", "ratingValue": ..., "reviewCount": ... }`. Weighted-average formula or pick-the-higher policy is planner's discretion — both produce defensible numbers; document the choice in the schema component file. Used on homepage only (see D-08).
- **D-05:** All additions slot into `business.json` as the source of truth and re-export through `business.ts`. **No new data files.** Phase 2's "single source of truth via business.ts" commitment holds.

### Schema Architecture + Injection

- **D-06:** **Auto-inject baseline + per-page overlays.** Base.astro is extended to emit the `HairSalon` JSON-LD block on every page automatically (reading from `business`), eliminating the risk that any page forgets the identity block. Pages then add page-specific schemas (`FAQPage`, `Service`, `Person`, `Article`, `AggregateRating`) via the existing `<slot name="head" />` reservation from Phase 2 D-26. **Rationale:** centralization for the load-bearing identity block; flexibility for per-page-type schemas where collection data is the source.
- **D-07:** **Cross-page entity dedup via `@id`.** Every emission of the business entity uses `"@id": "https://joesbarbershop.vercel.app/#business"` (or the production URL when known — for now matches `astro.config.mjs` site:). AI parsers and Google use `@id` to recognize that the LocalBusiness referenced from `/`, `/about`, `/fades`, `/bostonia-barber`, etc. are all the **same** business entity, not 17 different shops. Service pages reference the business as `"provider": { "@id": "https://joesbarbershop.vercel.app/#business" }` rather than re-emitting full address/phone. Same `@id` strategy for Person entities (Joe gets `#joe-denesowicz`).
- **D-08:** **`aggregateRating` on homepage only.** The combined Google+Yelp rating block is included **only** in the homepage's HairSalon JSON-LD. **Rationale:** playbook lists `Review`/`AggregateRating` as #7 priority (lower than FAQPage/HairSalon/Service/Person); putting it on every page is repetitive and rating values drift between scrapes. Single-source = fewer surfaces to keep current. The `/reviews` page emits its own `Review` array from the curated quotes (per `reviews.json`). Phase 7's ratings-refresh policy will refresh both surfaces from the same source.
- **D-09:** **Schema component layout** — new directory `site/src/components/schema/` with one file per schema type:
  - `HairSalon.astro` — emitted by Base.astro automatically
  - `AggregateRating.astro` — emitted by `index.astro` only
  - `FAQPage.astro` — emitted by pages with FAQ content (FAQ master, niche-landing, all 6 services, all 5 neighborhoods)
  - `Service.astro` — emitted by `[service].astro` template
  - `Person.astro` — emitted by `/about` (Joe only — Alex no longer cutting per Phase 3 cleanup)
  - `Article.astro` — emitted by `/east-county-traditional-barbershop` and `/2026-east-county-barbershop-cost-guide`
  Each component is a thin Astro file that emits one `<script type="application/ld+json">` block per the page-specific data it receives via props. Components do NOT contain business data; they read from `business` (auto-import) and accept page-specific data via props.

### Freshness Signals

- **D-10:** **`dateModified` from git mtime at build time.** An Astro integration or pre-build hook runs `git log -1 --format=%cI <file>` for each page being built and exposes the ISO timestamp as a virtual import (e.g., `import { getDateModified } from 'astro:content'` or a custom helper). Schema components read this value for `Article.dateModified`. **Rationale:** zero manual upkeep; survives content edits naturally; impossible to forget when bumping copy. Planner picks the exact Astro integration mechanism (Vite plugin, build hook, or a small node script that pre-computes a JSON manifest before `astro build`).
- **D-11:** **Visible "Last updated: YYYY-MM-DD" line** on cost guide (`/2026-east-county-barbershop-cost-guide`) and niche-landing (`/east-county-traditional-barbershop`) only. Renders from the same git mtime value used in the schema — keeps human display and schema field in sync by construction. Position: small line near the top of the page (between BLUF and prose) per playbook's "Date stamps on every page (dateModified)" rule, applied selectively to the two Article-schema pages where freshness most matters. Format: `Last updated: May 10, 2026` (human-readable; the ISO form lives in JSON-LD).
- **D-12:** **`dateModified` NOT applied site-wide in Phase 5.** Service and neighborhood pages do NOT carry `dateModified` in their schema (`Service` doesn't have it as a top-level field anyway; `LocalBusiness` could but adds noise). Homepage does NOT carry a visible "Last updated" stamp — would clash with the timeless heritage framing. Phase 5 scope intentionally narrow on freshness; Phase 7 measurement decides whether to widen.

### Meta Tags + Open Graph

- **D-13:** **Title pattern: `"Topic | Joe's Barbershop"`.** Standardized across all pages except homepage. Examples: `Fades | Joe's Barbershop`, `Barber in Bostonia | Joe's Barbershop`, `2026 East County Barbershop Cost Guide | Joe's Barbershop`. Homepage keeps a unique format: `Joe's Barbershop — Traditional Barbershop in Bostonia, El Cajon`. Pipe separator is the SEO-conventional title-tail format; brand suffix anchors entity association in search snippets and AI surfaces.
- **D-14:** **Description authoring policy — hybrid.** Service + neighborhood pages auto-derive `<meta name="description">` from the first sentence of their collection entry's `bluf` field (truncated to a clean sentence boundary, max ~160 chars). The 6 unique pages (`/`, `/about`, `/reviews`, `/faq`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`) carry hand-authored descriptions tuned for search-snippet click-through, set as `description` prop on the page's `<Base>` element. **Rationale:** auto-derivation keeps templated pages in sync with their BLUF (one edit, both update); hand-authoring the 6 strategic pages gets crafted descriptions where AI citation impact is highest.
- **D-15:** **Open Graph: text-only for v1; image deferred to v1.5.** Phase 5 emits `og:title`, `og:description`, `og:url`, `og:type` (= `website` for unique pages, `article` for cost guide + niche-landing), and `og:site_name = "Joe's Barbershop"`. Twitter Card emits `summary` type (not `summary_large_image`) with `twitter:title`, `twitter:description`, `twitter:site` (if a Twitter handle exists for Joe — likely absent; skip when null). **og:image is deferred** until Joe provides more photos (Joe mentioned at last in-shop conversation that he'd send more, including haircut work for social proof). When that happens (v1.5), wire per-page-type OG images (services → 05-mid-cut.jpg, neighborhoods → 02-storefront.jpg, unique pages → page hero) and upgrade Twitter card to `summary_large_image`.
- **D-16:** **All meta tags emitted from Base.astro frontmatter.** Extend the existing `<Base>` props interface from `{ title, description, variant }` to additionally accept `{ ogType?, twitterCard? }` (with sensible defaults). Each page passes what it cares to override; everything else flows from `business` + page-derived defaults. Single edit point for the entire site's meta strategy.

### Sitemap + robots.txt

- **D-17:** **Sitemap relies on `@astrojs/sitemap` defaults.** Already wired in `astro.config.mjs` (`integrations: [sitemap()]`). Phase 5 verifies all 17 routes appear in the generated `sitemap.xml` (cost guide, niche-landing, /, /about, /reviews, /faq, /fades, /classic-cut, /kids-cuts, /beard-trim, /hot-towel-shave, /line-up, /bostonia-barber, /el-cajon-barber, /santee-barber, /lakeside-barber, /la-mesa-barber). No `priority` or `changefreq` customization in v1 — those fields are largely ignored by Google per current consensus.
- **D-18:** **`robots.txt` written by hand** as `site/public/robots.txt`. Content:
  ```
  User-agent: *
  Allow: /

  Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml
  ```
  Sitemap URL updates when production domain lands (Phase 7 or v1.5). Allows all crawlers including AI bots (GPTBot, ClaudeBot, PerplexityBot) — the entire point of this build.

### Lighthouse Perf Hardening

- **D-19:** **Existing assets carry most of the perf budget.** Phase 1 wired `@astrojs/vercel` adapter + Astro Image with `layout: 'constrained'` and `responsiveStyles: true` — that handles srcset/sizes/AVIF/WebP automatically. Phase 5's perf work is mostly verification + targeted hardening, not a rewrite. Specific targets per `REQUIREMENTS.md`:
  - **PERF-02:** Lighthouse mobile Performance ≥ 90, Accessibility ≥ 95, SEO ≥ 95.
  - **PERF-03:** Hero image uses `fetchpriority="high"`; below-fold images use `loading="lazy"`.
  - **PERF-04:** LCP < 2.5s, CLS < 0.1 on homepage (mobile).
- **D-20:** **Hero image priority.** Each page identifies its single LCP candidate image and sets `fetchpriority="high"` + `loading="eager"`. Homepage = `03-interior-hero.jpg`. Service pages = `heroPhoto` per collection (fallback `03-interior-hero.jpg`). Neighborhood pages = `02-storefront.jpg`. Cost guide + niche-landing = no image hero (article-shaped) — LCP is the H1 text. All below-fold images = `loading="lazy"` per Astro Image default + explicit verification.
- **D-21:** **Font loading** — current Base.astro uses Google Fonts CDN with `preconnect` (Phase 1 default). Planner evaluates whether to additionally `preload` the critical font (likely `IM Fell English` for hero typography) to reduce LCP. Self-hosting is out of scope for v1 (added build complexity vs. measurable LCP improvement is unclear at this scale). **Default path: keep Google Fonts CDN + preconnect; add preload only if Lighthouse audit shows font-driven LCP delay.**
- **D-22:** **CLS prevention.** Verify all `<Image>` usages emit explicit width + height attributes (Astro Image default with `constrained` layout). Verify font-loading doesn't shift layout — current pattern relies on `display=swap` in the Google Fonts URL which can cause FOIT-to-FOUT shift on slow connections. If audit shows CLS > 0.1, fallback is `font-display: optional` (more aggressive: text invisible until font loads, no shift). Planner decides based on measured CLS.

### Verification — `scripts/audit.sh` Extension

- **D-23:** **Fully scripted verification.** Extend the existing Phase 3 `scripts/audit.sh` (already updated in Phase 4 with 11 templated-page slug checks) with new check functions:
  1. **JSON-LD validator** — for each built page in `site/dist/`, extract all `<script type="application/ld+json">` blocks, parse them, and validate against schema-type-specific required-field lists (e.g., HairSalon requires `name`, `address`, `telephone`, `openingHoursSpecification`; FAQPage requires `mainEntity` with `Question` items). Implementation: a small node script (`scripts/validate-schema.mjs`) using either `schema-dts` types + a thin validator, or `jsonld` package + hand-rolled checks. Fails the audit if any required field is missing or any block is unparseable.
  2. **Sitemap link check** — fetch `dist/sitemap-0.xml` (sitemap-0 is the default sitemap file emitted by `@astrojs/sitemap`; `sitemap-index.xml` is the index pointing at it), parse the URLs, assert all 17 canonical slugs from `canonical-slugs.txt` appear. Then HTTP HEAD each URL against the local preview (`astro preview` background) or against the staged Vercel preview build — fail if any returns non-200.
  3. **robots.txt presence + sitemap reference check** — assert `dist/robots.txt` exists, contains the `Sitemap:` line, and points at a URL that resolves.
  4. **Text-as-image heuristic** — `grep -rn "alt=\"[^\"]*\\$[0-9]\\|alt=\"[^\"]*\\(haircut\\|fade\\|shave\\)\"" site/src/pages/ site/src/components/` to catch any `<img alt>` that names prices, services, or hours — those should be DOM text, not image text. Heuristic; false positives possible but cheap to triage.
  5. **BLUF spot-check** — for each of the 5 spot-check pages (sampled per ROADMAP success criterion #5: `/`, `/fades`, `/bostonia-barber`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`), extract the first 100 words of body text and assert each contains the business name, a location term ("El Cajon", "Bostonia", or "East County"), and at least one service term (`barber`, `barbershop`, `haircut`, `fade`, `shave`). Crude but catches regression where a page accidentally opens with marketing fluff.
  6. **Lighthouse CLI enforcement** — `npx lighthouse <url> --preset=mobile --output=json --quiet --chrome-flags="--headless --no-sandbox"` against the deployed Vercel preview (or local `astro preview` server). Extract `categories.performance.score`, `accessibility.score`, `seo.score` from the JSON output and assert each meets its threshold (90/95/95). LCP and CLS pulled from `audits['largest-contentful-paint'].numericValue` and `audits['cumulative-layout-shift'].numericValue`. Run median-of-3 invocations per URL to smooth single-run variance.
- **D-24:** **Audit runs in CI before merging Phase 5.** Locally via `bash scripts/audit.sh phase-5`; in CI via the same. Each check function exits non-zero on failure with a clear "WHY this failed + WHAT TO FIX" message. Pre-Phase-6 gate: `audit.sh` exits 0.
- **D-25:** **Manual Rich Results Test paste as final eyeball gate.** Even with scripted JSON-LD validation, before declaring Phase 5 complete, paste the homepage's rendered HTML into `https://search.google.com/test/rich-results` and the niche-landing into the same, capture screenshots, store in `.planning/phases/05-aeo-performance-meta/rich-results/`. This catches Google-specific validation issues that a generic JSON-LD parser misses (e.g., Google flags an Article without `image` even though JSON-LD itself doesn't require it). **Not a CI gate — a one-time human eyeball before Phase 6 deploys.**

### Claude's Discretion

- **Exact Astro integration mechanism for git mtime → dateModified.** Vite plugin, build hook, or pre-build node script writing a JSON manifest are all defensible. Planner picks based on Astro ecosystem fit.
- **Schema component file shape (props API).** `<HairSalon />` taking zero props vs. `<HairSalon business={business} />` — both are fine; pick what reads cleanest in Base.astro.
- **JSON-LD validator implementation.** `schema-dts` + hand-rolled validator vs. `jsonld` library vs. a tiny standalone checker. The required-field lists for each Schema.org type are short and well-known; no need to install a heavyweight dep.
- **Lighthouse CLI runtime strategy.** Local `astro preview` vs. against the deployed Vercel preview URL. Vercel preview is more realistic but adds deploy dependency to CI; local preview is faster but doesn't measure Vercel CDN latency. Pick whichever is reproducible.
- **Median-of-N for Lighthouse score stability.** 3 runs is the floor; 5 is more stable but slower. Planner picks.
- **`robots.txt` per-bot policy.** Default = `User-agent: *` allow-all. If a specific AI bot is causing audit-script HEAD-storm rate issues, add per-bot rules later — out of scope for v1.
- **Font preload decision.** Default keep Google Fonts CDN preconnect; only add `<link rel="preload">` for `IM Fell English` if measured LCP > 2.5s and font is the culprit.
- **CLS fallback.** Default `display=swap` (current); switch to `font-display: optional` only if measured CLS > 0.1.
- **`llms.txt` — skip by default.** Playbook's two-study evidence (SE Ranking 300k domains, ALLMO 1,548 brands) shows zero correlation with citations. Install once if convenient; no Phase 5 requirement.
- **Twitter handle in `twitter:site`.** Joe doesn't have a known Twitter/X account. Omit the tag entirely rather than emit an empty value.
- **Geocoding source for lat/long.** OpenStreetMap Nominatim, Google Maps API one-shot lookup, or hand-pasted from Google Maps URL fragment — pick whichever the planner trusts. Hand-verify against Google Maps for accuracy before committing.
- **Exact `priceRange` symbol count.** `"$$"` ($10-$50 range) per Schema.org convention for $30 average ticket. If service mix shifts upward (unlikely v1), revisit.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 5 Inputs

- `inputs/02-aeo-constraints.md` — load-bearing AEO rules. BLUF, no accordions, FAQ flat text, schema priority order, declarative tone, anti-patterns. **MUST read** before designing schema components.
- `inputs/01-page-list.md` — 17-19 page architecture; specifies per-page schema combo (HairSalon + LocalBusiness on `/`; Service + FAQPage per service page; LocalBusiness with `areaServed` + FAQPage per neighborhood; Article + FAQPage on cost guide + niche-landing; Person × 2 on `/about` → now Person × 1 since Alex no longer cutting; FAQPage on `/faq`; Review aggregate + LocalBusiness on `/reviews`).
- `inputs/00-brief.md` — voice/tone source; consulted only if schema-related copy (alt text, descriptions) needs voice anchoring.
- `inputs/03-photo-notes.md` — photo usage map; informs hero image selection per page for `fetchpriority="high"`.

### Vault Knowledge Base (load-bearing for Phase 5; DO NOT duplicate into repo)

- `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` — **THE load-bearing reference for Phase 5.** NotebookLM-verified 2026-05-04 against a 25-source corpus. Specifically:
  - **§ 3** ("On-site mechanics for SMBs") — schema priority order (FAQPage > HairSalon > LocalBusiness > Service > Person > Article), the reference JSON-LD example for HairSalon (basis of D-04), content rules (BLUF, answer capsules, declarative entity statements, freshness/dateModified, no accordions).
  - **§ 7** ("Measurement for SMBs without enterprise trackers") — the recommended starter stack that informed D-01 (Clarity + Vercel Web Analytics + Vercel Speed Insights as the Phase 5-grade trio; CallRail + LocalFalcon + manual prompt panel stay Phase 7).
  - **§ 10** ("Application to Joe's E9") — concrete spec for Joe's 17-19 pages and schema-per-page table.
  - **Verification block** — refutes `llms.txt` (D-25 discretion: skip).
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — Joe-specific audit baseline + E9 spec; the AEO win at "traditional barbershop East County San Diego" is what Phase 5's `<Article + FAQPage>` schema on the niche-landing protects. **§ Measurement plan** confirms which tools belong in Phase 7 (the harder ones) vs Phase 5 (the trivial 1-line ones absorbed per D-01).
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-visual-direction.md` — referenced for visual-direction continuity; not directly load-bearing for schema/perf/meta.
- `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` — consult IF schema-related copy (descriptions, alt text) needs voice tuning. Mostly a Phase 3/4 concern.

### Prior Phase Carry-Forward (REQUIRED before planning)

- `.planning/phases/04-templated-pages/04-CONTEXT.md` — Phase 4 decisions, especially:
  - **D-04, D-09** (service + neighborhood page skeletons) — Phase 5 schema overlays attach to these structures.
  - **D-15** (collection markdown is the source for BLUF + FAQ content) — Phase 5 description auto-derivation (D-14) and FAQPage schema (D-09) read from these same files via `getCollection()`.
- `.planning/phases/03-unique-pages/03-CONTEXT.md` — Phase 3 decisions, especially:
  - **D-17** (component reuse rules) — Phase 5 schema components are NEW additions; don't import from Hero/PriceBoard/Heritage etc.
  - **D-19** (inline FAQ markup pattern) — Phase 5's FAQPage JSON-LD reads the same DOM structure.
  - **D-21** (niche-landing skeleton) — Phase 5 attaches `Article + FAQPage` schema to this page.
- `.planning/phases/02-data-design-system/02-CONTEXT.md`:
  - **D-22, D-23, D-24** — content collection schemas (Phase 5's FAQPage + Service schema components read frontmatter via `getCollection()`).
  - **D-26** — `<slot name="head" />` reserved in `Base.astro` for schema injection. **Phase 5 finally consumes this slot per D-06.**
- `.planning/phases/03-unique-pages/scripts/audit.sh` — validation infrastructure Phase 5 extends per D-23.
- `.planning/phases/03-unique-pages/scripts/canonical-slugs.txt` — canonical 17-URL list Phase 5's sitemap audit verifies.

### Project-Level Decisions

- `.planning/PROJECT.md` § Constraints — Astro / no-Tailwind / 6-photo limit / AEO structural rules / no-live-deployment-before-Joe-approves. **Constrains D-15** (OG image deferred to v1.5; tied to the photo-set constraint).
- `.planning/PROJECT.md` § Key Decisions — schema-from-business.ts (D-04 expands this), showcase-first.
- `.planning/REQUIREMENTS.md` § AEO Schema + Structure (AEO-01..09), § Performance + Responsive (PERF-01..04), § Meta + Sitemap (META-01..04) — **acceptance gates for Phase 5.** Note `AEO-09` already defers Wikidata + Booksy.
- `.planning/ROADMAP.md` § Phase 5 — goal, depends-on (Phase 4), 5 success criteria. **D-01's scope shift means Phase 7's `MEAS-01` + `MEAS-02` are partially-satisfied by Phase 5 deliverables (Clarity script wired, Vercel Analytics + Speed Insights wired); Phase 7 still needs the "receiving sessions from production domain" verification + Search Console + CallRail + LocalFalcon + baseline capture.** Worth noting at next `/gsd-transition` for traceability.

### Live Repo State (Phase 1-4 outputs Phase 5 consumes)

- `site/src/layouts/Base.astro` — Phase 5 extends this to: (a) auto-inject `<HairSalon />` schema, (b) wire Clarity/Vercel Analytics/Speed Insights, (c) expand props interface for ogType/twitterCard, (d) emit OG + Twitter Card meta tags, (e) emit canonical `<link rel="canonical">` per page. The `<slot name="head" />` from Phase 2 D-26 is finally consumed.
- `site/src/data/business.json` + `site/src/data/business.ts` — Phase 5 extends with geo, priceRange, E.164-phone helper, openingHoursSpecification helper, aggregateRating helper per D-04.
- `site/astro.config.mjs` — already wires `@astrojs/sitemap` (Phase 1). Phase 5 verifies output covers all 17 routes; no config change unless a missing route is detected (e.g., niche-landing or cost guide excluded by default — unlikely).
- `site/src/content.config.ts` — content collections used by FAQPage + Service schema components (Phase 5 read-only on this file).
- `site/src/content/services/*.md` (6 files) + `site/src/content/neighborhoods/*.md` (5 files) — frontmatter `bluf` field is auto-derived to `<meta description>` per D-14; `faqs` array drives FAQPage JSON-LD.
- `site/src/pages/index.astro` + 5 unique pages + 2 dynamic-route templates — Phase 5 adds schema component imports and slot fills, plus per-page meta tweaks where description hand-authoring is wanted (D-14).
- `site/src/assets/photos/` — `03-interior-hero.jpg` is homepage LCP candidate per D-20; identified for `fetchpriority="high"`.
- `site/src/styles/{tokens.css,utilities.css}` — no Phase 5 changes expected.
- `.planning/phases/03-unique-pages/scripts/audit.sh` — Phase 5 extends per D-23.

### External Tools (executor invokes)

- **`@astrojs/sitemap`** (already installed) — sitemap.xml generation. Phase 5 verifies output.
- **`@vercel/analytics/astro`** (new) — Vercel Web Analytics. NPM install + 1-line import in Base.astro.
- **`@vercel/speed-insights/astro`** (new) — Vercel Speed Insights. Same pattern.
- **`lighthouse`** (new, devDep) — Lighthouse CLI for D-23 perf check. Or `@lhci/cli` if planner prefers the LHCI wrapper.
- **`schema-dts`** (new, devDep) — TypeScript types for Schema.org JSON-LD. Used for type-safety in schema components AND for the validator script per D-23.
- **Microsoft Clarity** (external SaaS) — Joe-specific project created at clarity.microsoft.com during Phase 5 execution; ID env-var-wired per D-03.
- **Google Rich Results Test** (external web tool) — manual paste gate per D-25.

### Astro / Tooling Docs

- Astro Open Graph integration patterns (no official integration; manual `<meta>` emission via Base.astro frontmatter — researcher confirms).
- Astro `<Image>` `fetchpriority` prop support (added in Astro 5+; current repo is Astro 6).
- Astro `astro:content` `getCollection()` (already in use; no new docs needed).
- Vercel Analytics + Speed Insights Astro integration docs — researcher reads to confirm dev-disable behavior and PROD-only firing.
- Schema.org: `HairSalon`, `FAQPage`, `Service`, `Person`, `Article`, `AggregateRating`, `OpeningHoursSpecification`, `GeoCoordinates`, `PostalAddress`, `Offer`/`PriceSpecification` (Service's `offers` prop). Researcher reads spec pages as needed for required-field lists in D-23 validator.
- Google Rich Results developer docs — for the manual paste gate's expected output.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- **`<slot name="head" />` in Base.astro** (Phase 2 D-26): the entire reason schema injection is straightforward. Pages already pass `<Fragment slot="head">...</Fragment>` patterns implicitly. Phase 5 starts using this slot for the first time across the codebase — no other phase consumes it.
- **`business` data export** (Phase 2 D-24): typed import `import { business } from '../data/business';` already returns NAP, hours, prices, ratings, sameAs, photos, areaServed. Phase 5's `business.ts` extension (D-04) preserves this import shape; schema components read from this single import.
- **`getCollection('services')` + `getCollection('neighborhoods')`** (Phase 2 D-24, used heavily in Phase 4): the same pattern Phase 5's FAQPage + Service schema components consume to pull per-page FAQ + service data.
- **`scripts/audit.sh`** (Phase 3, extended Phase 4): the existing audit infra. Phase 5 extends with 6 new check functions per D-23.
- **`scripts/canonical-slugs.txt`** (Phase 3 D-16): authoritative 17-slug list Phase 5's sitemap audit consumes.
- **`@astrojs/sitemap` already wired in `astro.config.mjs`** (Phase 1): no Phase 5 config change needed; just verify the output.
- **`@astrojs/vercel` adapter + Astro Image with `layout: 'constrained'`** (Phase 1): handles srcset/sizes/AVIF/WebP automatically. Phase 5's perf hardening is mostly verification, not rebuild.
- **Existing `<title>` + `<meta description>` flow** through `Base.astro` props: Phase 5 extends, doesn't rewrite.

### Established Patterns

- **`business.ts` is the single source of truth for NAP/hours/prices/ratings/sameAs/areaServed** (Phase 2 D-23). Phase 5 expansion (geo, priceRange, E.164 helper, openingHoursSpecification helper, aggregateRating helper) preserves this — every new field is additive, no data moves.
- **Per-component scoped CSS** (Phase 2 D-11): schema components are JSON-LD-only with no CSS. They're pure script-tag emitters.
- **No `client:*` directives anywhere** (Phase 3/4): Phase 5's Clarity + Vercel scripts run as inline `<script>` tags in `<head>` (Clarity) or via the Astro-native components from `@vercel/analytics/astro` and `@vercel/speed-insights/astro` (which are also static-rendered, not hydrated React islands). Zero-JS DOM baseline holds.
- **Phase 4's hybrid skill chain for templated-page copy** (Phase 4 D-14): means service + neighborhood collections have polished BLUFs by the time Phase 5 reads them for description derivation. No content re-authoring in Phase 5.
- **`reviews.json` curated quotes** (Phase 3): source for `/reviews` page's `Review[]` schema array.
- **Schema-type-specific component files** is a NEW pattern introduced in Phase 5 (D-09). Each Schema.org type gets its own `.astro` file under `src/components/schema/`. No prior phase has this directory.

### Integration Points

- **Base.astro → HairSalon schema**: import + auto-inject. Reads `business` directly. Outputs one `<script type="application/ld+json">` block in `<head>` before the existing `<slot name="head" />`.
- **Page → page-specific schema**: pages add their own schema components inside `<Fragment slot="head">` passed to `<Base>`. Example: `<FAQPage items={entry.data.faqs} pageUrl={Astro.url.href} />`.
- **Schema component → business data**: schema components import `{ business }` from `'../../data/business'` (or wherever the schema components live relative to data). All NAP/hours/prices/ratings/areaServed reads flow through this one import.
- **Schema component → page-specific data**: passed in via props (FAQ items, service offer details, person bio, article dateModified).
- **Build-time dateModified hook → schema component**: planner picks the mechanism — likely a virtual module (`virtual:date-modified`) exposing a map from file paths to git mtimes, consumed by both the Article schema component and the visible "Last updated" line component.
- **Clarity script → Base.astro**: gated `<script>` tag in `<head>` (or `<body>`-end per Clarity's recommendation — researcher confirms). Reads `import.meta.env.PUBLIC_CLARITY_PROJECT_ID` and only emits in `import.meta.env.PROD`.
- **Vercel Analytics + Speed Insights → Base.astro**: `<Analytics />` + `<SpeedInsights />` from `@vercel/analytics/astro` / `@vercel/speed-insights/astro` rendered at the end of `<body>`. Self-disable in dev.
- **audit.sh → Astro build output**: audit reads `site/dist/` after `npm run build`. The JSON-LD validator parses static HTML files looking for `<script type="application/ld+json">` blocks. Lighthouse CLI runs against a local preview server or the staged Vercel preview.
- **sitemap.xml → canonical-slugs.txt**: audit cross-references the two — every canonical slug must appear in the generated sitemap, and the sitemap must contain only canonical slugs (no phantom routes from build mistakes).
- **robots.txt → sitemap.xml**: robots.txt references `https://<domain>/sitemap-index.xml` (the default `@astrojs/sitemap` output); audit verifies this resolves.

</code_context>

<specifics>
## Specific Ideas

- **HairSalon is the most specific Schema.org type that covers a barbershop.** Schema.org has no `BarberShop` type; `HairSalon` is a subtype of `HealthAndBeautyBusiness` which is a subtype of `LocalBusiness`. Using the most specific type gives AI parsers + Google Rich Results a sharper entity classification. The visible/human-facing copy still says "barbershop" everywhere — the Schema.org type is invisible JSON-LD that only crawlers read.
- **Wikidata Q-number is the biggest single uncaptured AEO lever for Joe's**, but correctly stays out of Phase 5 (AEO-09 defers to v2). Playbook cites +300% entity recognition accuracy and +36% AI citation rate from `sameAs` Wikidata linking, and an LLC + Yelp + GBP listing is sufficient verifiability (no Wikipedia notability bar). When v2 lands, the Wikidata Q-number drops into `business.json.sameAs.wikidata` and propagates through schema automatically — Phase 5's data-driven schema design makes this a one-field edit.
- **The niche-landing page (`/east-county-traditional-barbershop`) carries the AEO win Joe already accidentally has.** Currently cited by ChatGPT as the only specifically-named shop for "traditional barbershop East County San Diego" — sourced from Joe's Facebook page (no website). Phase 5's Article + FAQPage + LocalBusiness schema on this page is the structural defense move: when AI parsers re-crawl, they find a real first-party citation surface, not a Facebook page snippet. **This is the highest-stakes single schema emission in the build.**
- **The cost guide (`/2026-east-county-barbershop-cost-guide`) is the playbook's 32.5%-citation-format payoff page.** Comparative listicles are the highest-converting AI content format per the vault research. Phase 5 wraps it with Article + FAQPage + dateModified for freshness signaling. Mirror to Medium is deferred to v2 per PROJECT.md but the on-site emission is Phase 5's job.
- **OG image deferral is correct.** Joe verbally committed to providing more photos including haircut work. Shipping with a placeholder OG image (one of the 6 we have) would entrench `02-storefront.jpg` or `03-interior-hero.jpg` as the universal share preview; better to ship text-only OG now and upgrade once Joe sends the real photo set (gives him social-proof leverage too). The text-only OG still gives clean link previews in iMessage/Slack/etc. — just without a thumbnail.
- **Clarity in Phase 5 is the lever for the Phase 6 showcase quality.** When Darrell hands Joe the preview URL, Joe (and Joe's customers if he shares it) interact with it. Without Clarity firing, those first interactions are lost. With Clarity firing, Phase 7 starts with real session data rather than instrumenting from scratch.
- **The audit script's "text-as-image heuristic"** is intentionally crude. AEO-07 says no service names/prices/FAQ questions inside `<img>`. The grep heuristic catches the obvious cases (e.g., someone accidentally adds `<img alt="Haircut $30">`); a comprehensive check would require OCR on every image, which is overkill. The heuristic gates regression — the 6 photos Joe has don't currently have text-in-image issues (the price board is shown as a photo of a physical letter board, with the **same prices duplicated in DOM text** in the PriceBoard component, satisfying AEO-07).
- **Lighthouse 90/95/95 is aggressive on mobile.** The current Phase 1-4 baseline ships with Google Fonts, multiple heritage typefaces, and a large hero photo. Hitting 90 Performance is achievable with `fetchpriority="high"` + lazy-load + Astro's static-site speed advantage, but font loading is the single biggest risk. **If audit fails Performance:** the planner's first move should be to measure font-driven LCP delay before refactoring anything else.
- **`@id` URLs use `https://joesbarbershop.vercel.app` as the canonical for now.** Production domain swap is deferred to v1.5/Phase 7 — when it happens, the `@id` URLs need a bulk update (find/replace across all schema components reading from `business.url` constant). Add a `business.canonicalUrl` field in business.ts that defaults to the Vercel preview and gets updated when a custom domain lands.

</specifics>

<deferred>
## Deferred Ideas

- **Wikidata Q-number registration + `sameAs` integration** — v2 (PROJECT.md / AEO-09). Biggest single uncaptured citation lever. Adds one field to `business.json.sameAs.wikidata` once registered.
- **Booksy listing creation** — v2 (PROJECT.md / AEO-09). Off-site work.
- **Foursquare + Bing Places claims** — v2 (PROJECT.md). Off-site; >70% of ChatGPT's local data signal per playbook.
- **Search Console + Bing Webmaster verification meta tags** — Phase 7 (`MEAS-03`). Needs production domain; preview URL won't satisfy.
- **CallRail dynamic number insertion** — Phase 7 (`MEAS-04`). Paid + needs real phone number routing.
- **LocalFalcon grid rank tracker** — Phase 7 (`BASE-01`). External SaaS.
- **Manual AI prompt panel (10-15 prompts × 4 engines × monthly)** — Phase 7 (`BASE-01`). External Sheets log.
- **Counter-card QR + `/welcome?src=qr` route** — Phase 7 (`BASE-02`). Walk-in attribution.
- **Hire-trigger event documentation** — Phase 7 (`BASE-03`). Joe-conversation artifact.
- **OG image strategy (per-page-type or per-page custom) + Twitter `summary_large_image` upgrade** — v1.5. Blocked on Joe sending better photos.
- **Custom domain registration + `@id` URL update** — v1.5 (PROJECT.md). Preview URL is sufficient until Joe approves; domain swap is a one-config-edit when it lands.
- **Per-bot `robots.txt` rules** — v2 if audit-script HEAD-storm rate issues arise. Default allow-all covers the AEO play.
- **`llms.txt` file** — default SKIP per playbook (two large studies show zero correlation; removing it from a citation-prediction model improved accuracy). Optional install with no Phase 5 requirement. Revisit only if industry consensus shifts.
- **Site-wide `dateModified` (not just Article-schema pages)** — Phase 5 keeps freshness narrow (cost guide + niche-landing only). Phase 7 measurement decides whether to widen based on which queries cite which pages.
- **FAQ-rotation freshness cadence** (playbook recommends rotating at least one FAQ answer per month) — Phase 7 + operational, not Phase 5 build work.
- **`Review` schema array on `/reviews` from `reviews.json`** — IN scope for Phase 5 (the page exists, the data exists, the curated quotes get wrapped in Review JSON-LD). NOT deferred; called out here because the implementation specifics (which fields per review, whether to include the `Review.itemReviewed = HairSalon@id`) are planner discretion.
- **Self-hosting Google Fonts** — optional perf tuning if measured LCP > 2.5s and font is the culprit. Default keep CDN + preconnect.
- **`font-display: optional` over `swap`** — CLS fallback if measured CLS > 0.1. Default keep swap.
- **`PriceSpecification` complexity on Service schemas** — Phase 5 emits basic `Offer { priceCurrency: USD, price: 30 }`. Full `PriceSpecification` with `priceType` + `eligibleQuantity` + tax codes is overkill for Joe's pricing.
- **Mid-page customer-quote schema (Review embedded within service pages, not just /reviews)** — could move citation needle per playbook. Defer to v2 or Phase 7 based on measurement.
- **REQUIREMENTS.md note: Phase 5 absorbs `MEAS-01` (Clarity) + `MEAS-02` (Vercel Analytics + Speed Insights) on-site portions** — Phase 7's success criteria for these become "verify dashboards receiving sessions from production domain" rather than "install script". Worth a `/gsd-transition` note after Phase 5 ships to update REQUIREMENTS.md traceability.

</deferred>

---

*Phase: 5-AEO + Performance + Meta*
*Context gathered: 2026-05-10*
