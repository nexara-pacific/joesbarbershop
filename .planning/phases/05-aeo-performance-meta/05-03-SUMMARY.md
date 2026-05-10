---
phase: 05-aeo-performance-meta
plan: 03
subsystem: schema
tags: [astro, json-ld, schema-org, components, schema-dts, aeo, hairsalon, faqpage, service, person, article, review]

requires:
  - phase: 05-aeo-performance-meta
    provides: business.ts helpers (toE164, toOpeningHoursSpecification, aggregateRating, canonicalUrl) + extended BusinessRecord (geo + priceRange) from Plan 02
  - phase: 05-aeo-performance-meta
    provides: schema-dts npm dep listed in package.json from Plan 01 (Plan 03 installed the missing node_modules entry)
provides:
  - "site/src/components/schema/HairSalon.astro: LocalBusiness identity component, auto-injected by Base.astro in Plan 04 (D-06)"
  - "site/src/components/schema/AggregateRating.astro: combined Google+Yelp rating (homepage only — Plan 05) referencing business via @id"
  - "site/src/components/schema/FAQPage.astro: per-page FAQ schema accepting faqs[] + pageUrl props"
  - "site/src/components/schema/Service.astro: Service schema for the 6 service pages accepting entry: CollectionEntry<'services'>"
  - "site/src/components/schema/Person.astro: Joe Denesowicz Person schema (one Person — Alex no longer cutting per D-09)"
  - "site/src/components/schema/Article.astro: schema-dts WithContext<Article> typed component for niche-landing + cost guide"
  - "site/src/components/schema/Review.astro: emits one <script> block per review via .map() for /reviews page"
affects: [05-04, 05-05, 05-06, 05-07]

tech-stack:
  added: ["schema-dts@^2.0.0 (installed into node_modules — was listed in package.json from Plan 01 but missing in this worktree's node_modules, same situation Plan 02 had with @astrojs/check)"]
  patterns:
    - "JSON-LD emission via `<script type=\"application/ld+json\" set:html={JSON.stringify(schema)} />` (RESEARCH Pattern 1) — every schema component uses this identical shape"
    - "Stable cross-page @id values via `${canonicalUrl}/#business`, `${canonicalUrl}/#${slug}`, `${pageUrl}#faq`, `${pageUrl}#service` — enables Google entity dedup (D-07)"
    - "Reference-by-@id between schema types: AggregateRating.itemReviewed, Service.provider, Person.worksFor, Article.publisher, Review.itemReviewed all point at the HairSalon's #business @id"
    - "Pure-emitter components: zero CSS, zero DOM, zero JS — Astro renders the script tag and that's it"
    - "schema-dts WithContext<Article> typing for the strictest Google Rich Results category (Article) — compile-time guard against missing required fields"
    - "Multi-script emission for arrays (Review.astro): `{schemas.map((s) => <script .../>)}` — one block per review, normal JSON-LD pattern"

key-files:
  created:
    - "site/src/components/schema/HairSalon.astro"
    - "site/src/components/schema/AggregateRating.astro"
    - "site/src/components/schema/FAQPage.astro"
    - "site/src/components/schema/Service.astro"
    - "site/src/components/schema/Person.astro"
    - "site/src/components/schema/Article.astro"
    - "site/src/components/schema/Review.astro"
  modified: []

key-decisions:
  - "Used the plan's templates verbatim (no `is:inline` added to <script> tags). Astro emits an informational HINT for each json-ld script suggesting `is:inline`, but the plan's success-criteria are 0 errors / 0 warnings — both satisfied. The PATTERNS reference (which is the canonical pattern source) does NOT use `is:inline`. Adding it would deviate from the documented pattern; leaving it produces benign hints with identical runtime behavior."
  - "Installed missing schema-dts node_modules entry (Rule 3 - blocking, parallel to Plan 02's @astrojs/check fix). Package was already in package.json + package-lock.json from Plan 01 but not materialized in this worktree's node_modules. `npm install schema-dts` populated it without touching package.json or package-lock.json (since the package and version were already locked)."
  - "Kept the schema-dts `WithContext<Article>` type annotation on Article.astro (the plan offered a fallback to drop it if strict — strictness was not encountered). The Organization publisher's `@id` field was accepted by schema-dts@2.0.0 without complaint, so the type check provides compile-time guard against missing Article required fields (headline, datePublished, etc.)."
  - "Service.astro's `offers` field is emitted unconditionally. `site/src/content.config.ts` shows `price: z.number()` (non-nullable) on the services collection, so the plan's conditional-offers fallback was not needed."

patterns-established:
  - "site/src/components/schema/ is the schema contract layer. Plans 04 + 05 wire these components into Base.astro and the 17 pages; no business data flows from any other source into JSON-LD."
  - "Schema components are unreferenced after Plan 03 — they exist as a contract and pass astro check + npm run build without breaking anything. Plans 04 + 05 are the consumers."
  - "All schema components import from `'../../data/business'` (relative path from `src/components/schema/` up to `src/data/`). The data layer is the single source of truth — schema components never hard-code NAP / hours / ratings / sameAs."

requirements-completed: [AEO-01, AEO-02, AEO-03, AEO-04, AEO-05, AEO-09]

duration: ~3 min
completed: 2026-05-10
---

# Phase 5 Plan 03: Schema Components Summary

**Created the seven JSON-LD schema components under `site/src/components/schema/` — HairSalon, AggregateRating, FAQPage, Service, Person, Article, Review. Each is a pure script-tag emitter reading business identity from the Plan-02 data layer (`business.ts`) and per-page data via props. Components are unreferenced until Plan 04 wires HairSalon into Base.astro and Plan 05 threads the other six through the 17 pages.**

## Performance

- **Duration:** ~3 min (Task 1 + Task 2 commits straddle 22:45:07Z – 22:47:34Z; includes schema-dts node_modules install and two `npx astro check` + one `npm run build` cycle)
- **Started:** 2026-05-10T22:45:07Z
- **Completed:** 2026-05-10T22:47:34Z
- **Tasks:** 2
- **Files modified:** 0
- **Files created:** 7

## Accomplishments

- **7 schema components created** at `site/src/components/schema/`:
  - `HairSalon.astro` — auto-inject identity (D-06): name, telephone (E.164), priceRange, image, full PostalAddress, GeoCoordinates, OpeningHoursSpecification[], areaServed[], sameAs[]
  - `AggregateRating.astro` — homepage-only (D-08): 4.98 across 147 reviews via the weighted-average helper, references business by @id
  - `FAQPage.astro` — accepts `{faqs: FAQ[], pageUrl: string}` props, maps to Question/Answer mainEntity[]
  - `Service.astro` — accepts `{entry: CollectionEntry<'services'>, pageUrl: string}` props, emits Service with provider.@id → #business and Offer
  - `Person.astro` — accepts `{name, jobTitle, description, slug}` props, references business via worksFor.@id (Joe only — Alex no longer cutting per D-09)
  - `Article.astro` — schema-dts `WithContext<Article>` typed; includes `image` field to clear Google Rich Results "Article needs image" warning (D-25 gate); publisher.@id → #business
  - `Review.astro` — accepts `{reviews: ReviewItem[]}`, emits one `<script>` block per review with itemReviewed.@id → #business
- **Every component uses the canonical `<script type="application/ld+json" set:html={JSON.stringify(schema)} />` pattern** — verified by grep on all 7 files.
- **Zero CSS, zero DOM, zero JS in any schema component** — verified by `<style` grep returning no matches across all 7 files.
- **`npx astro check`** from `site/` exits with 0 errors, 0 warnings, 8 hints (7 of the hints are informational `is:inline` suggestions on the schema components themselves; 1 is the pre-existing `[service].astro` unused-import hint inherited from Plan 02 baseline).
- **`npm run build`** from `site/` exits 0; 17 pages built in 1.93s — no regressions, schema components compile clean even though no page consumes them yet.

## Task Commits

Each task was committed atomically:

1. **Task 1: Create the 4 reference-typed schema components (HairSalon, AggregateRating, FAQPage, Service)** — `92f2eaa` (feat)
2. **Task 2: Create the 3 remaining schema components (Person, Article, Review)** — `750973e` (feat)

## Files Created/Modified

**Created (7):**
- `site/src/components/schema/HairSalon.astro` (33 lines) — HairSalon LocalBusiness identity; reads business + toE164 + toOpeningHoursSpecification + canonicalUrl; stable @id `${canonicalUrl}/#business`.
- `site/src/components/schema/AggregateRating.astro` (17 lines) — homepage rating; uses aggregateRating() helper (4.98 / 147 reviews); references business via itemReviewed.@id.
- `site/src/components/schema/FAQPage.astro` (31 lines) — generic FAQ schema; Props: `faqs: FAQ[], pageUrl: string`; maps q/a → Question/Answer.
- `site/src/components/schema/Service.astro` (31 lines) — Service schema; Props: `entry: CollectionEntry<'services'>, pageUrl: string`; references business via provider.@id; emits unconditional `offers` (price is z.number() non-nullable per content.config.ts).
- `site/src/components/schema/Person.astro` (25 lines) — Person schema; Props: `name, jobTitle, description, slug`; references business via worksFor.@id; single-Person emission (no Alex per D-09).
- `site/src/components/schema/Article.astro` (37 lines) — Article schema with schema-dts WithContext<Article> typing; Props: `headline, description, url, datePublished, dateModified, authorName`; includes `image` (storefront photo) to mitigate Google Rich Results "Article needs image" warning at D-25 gate.
- `site/src/components/schema/Review.astro` (37 lines) — Review schema; Props: `reviews: ReviewItem[]`; emits one `<script>` block per review via `.map()`; references business via itemReviewed.@id.

**Modified (0):** No source files outside the new schema directory were touched.

## Decisions Made

- **Did NOT add `is:inline` directives.** Astro emits a hint suggesting `is:inline` for each `<script type="application/ld+json">` (because the script has an attribute and won't be processed by Astro's TS pipeline — which is exactly what we want for raw JSON-LD). PATTERNS reference (`05-PATTERNS.md` lines 75, 108, 144, 194, 230, 271, 321) documents the canonical pattern WITHOUT `is:inline`. Plan acceptance criteria require 0 errors / 0 warnings — both achieved. Hints are informational and runtime behavior is identical. Keeping the code as the plan dictates preserves the documented contract for Plans 04 + 05.
- **Used `WithContext<Article>` type annotation in Article.astro.** The plan offered a fallback to drop the type if schema-dts complained about Organization.@id strictness. schema-dts@2.0.0 accepted the typed object without complaint, so the type guard stays. Plan 06 (which wires in `dateModified` from git-mtimes.json) gets compile-time type-check coverage.
- **Service.astro emits `offers` unconditionally.** `site/src/content.config.ts` shows `price: z.number()` (non-nullable) on the services collection schema — so the plan's conditional-offers fallback for nullable prices was not needed.
- **HairSalon image hardcoded as `${canonicalUrl}/photos/03-interior-hero.jpg`.** Plan template value, kept as-is. The `business.photos` record in business.json contains the available photo filenames; later plans can swap this for `business.photos.interior` if the playbook decides a runtime data-driven photo selection is preferred — for now the plan's literal-template was used.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Installed missing schema-dts node_modules entry**
- **Found during:** Pre-Task-1 dependency check (`test -d site/node_modules/schema-dts` returned negative).
- **Issue:** Plan 01 had added `schema-dts@^2.0.0` to `site/package.json` dependencies and locked it in `package-lock.json`, but this worktree's `node_modules/schema-dts/` directory did not exist. Task 2's `import type { Article, WithContext } from 'schema-dts'` would have failed at `astro check` time. Same situation Plan 02 encountered with `@astrojs/check` + `typescript` (also pre-merge worktree state divergence).
- **Fix:** Ran `cd site && npm install --no-fund --no-audit schema-dts` non-interactively. The install was a no-op for package.json + package-lock.json (the version was already locked) — it only materialized the existing locked tree into `node_modules/` (571 packages re-verified, schema-dts + schema-dts-lib written).
- **Files modified:** None tracked in git. Only `site/node_modules/` (gitignored).
- **Verification:** `test -d site/node_modules/schema-dts` returned positive; subsequent `npx astro check` resolved the `from 'schema-dts'` import without error.
- **Committed in:** Not committed — no tracked files changed. The install is reproducible by any consumer running `npm install` in the worktree.

---

**Total deviations:** 1 auto-fixed (1 blocking).
**Impact on plan:** Zero scope creep. The fix is functionally identical to Plan 02's `@astrojs/check` install — a worktree-state-recovery step that doesn't alter the locked dependency manifest. No code differs from the plan's templates.

## Issues Encountered

- **Astro `is:inline` informational hints (7 total, one per schema component).** Each `<script type="application/ld+json" set:html={...} />` triggers astro hint #4000 suggesting an explicit `is:inline` directive. The hint is documented behavior: scripts with attributes are treated AS IF `is:inline` is set; the directive only silences the hint without changing runtime. PATTERNS reference documents the pattern without `is:inline`, plan acceptance criteria are 0 errors / 0 warnings (achieved), so the hints were accepted as benign. If Plan 04 / 05 prefer to silence them, adding `is:inline` to each schema component is a single-line change with zero behavioral impact.
- **Pre-existing `[service].astro` unused-import hint** (`'business' is declared but its value is never read`) carries over from Plan 02 baseline. Plan 04 or 05 will either use the import (when wiring Service.astro into [service].astro) or remove it. Out of scope for Plan 03.

## Known Stubs

None — every schema component is a complete emitter with real schema content. No placeholder JSON, no TODO markers, no `pass()` bodies. The components are "unreferenced," not "stubbed" — they're a contract waiting for consumers.

## Threat Flags

None. The plan's threat model (T-05-07 tampering via `</script>` injection, T-05-08 sameAs disclosure, T-05-09 misrepresentation) is fully addressed by the data flow: every JSON-LD field flows from `business.json` (audited NAP/hours/ratings with asOf timestamps) or page props (collection markdown FAQs, /reviews data — all repo-tracked and reviewable). T-05-07's mitigation is owned by Plan 07's `validate-schema.mjs` greps; Plan 03 doesn't introduce new surface beyond what the register anticipated.

## User Setup Required

None — all changes are local repo files. `npm install` in `site/` materializes schema-dts for any consumer (deployment, CI, fresh clone).

## Next Phase Readiness

Wave 4+ plans can now:
- **Plan 04** — import `HairSalon` from `'../components/schema/HairSalon.astro'` into `Base.astro` and render inside `<head>` for global identity injection.
- **Plan 05** — thread the other six components into the 17 pages via `<Fragment slot="head">`:
  - `<FAQPage faqs={...} pageUrl={...} />` on homepage, niche-landing, cost guide, /faq, 6 services, 5 neighborhoods.
  - `<Service entry={entry} pageUrl={...} />` inside `[service].astro`'s `getStaticPaths` page.
  - `<Person name="Joe Denesowicz" ... slug="joe-denesowicz" />` on `/about`.
  - `<Article headline={...} datePublished={...} dateModified={...} ... />` on niche-landing + cost guide.
  - `<Review reviews={reviewsData} />` on `/reviews`.
  - `<AggregateRating />` (no props) on homepage only.
- **Plan 06** — wire git-mtimes.json into Article's `dateModified` prop.
- **Plan 07** — validate-schema.mjs greps emitted JSON-LD for `</script>` strings and Schema.org type completeness.

Baseline still: `npm run build` exits 0, 17 pages built; `npx astro check` exits 0 errors / 0 warnings.

## Self-Check: PASSED

Verified all claimed artifacts and commits:

- `site/src/components/schema/HairSalon.astro` — FOUND
- `site/src/components/schema/AggregateRating.astro` — FOUND
- `site/src/components/schema/FAQPage.astro` — FOUND
- `site/src/components/schema/Service.astro` — FOUND
- `site/src/components/schema/Person.astro` — FOUND
- `site/src/components/schema/Article.astro` — FOUND
- `site/src/components/schema/Review.astro` — FOUND
- Commit `92f2eaa` (Task 1 — 4 reference-typed schema components) — FOUND in `git log`
- Commit `750973e` (Task 2 — Person, Article, Review schema components) — FOUND in `git log`
- All 7 `.astro` files contain exactly one (or in Review's case, a `.map()` over one-per-item) `<script type="application/ld+json" set:html={JSON.stringify(...)} />`
- All 7 files contain no `<style>` block (verified by grep)
- `node_modules/schema-dts/` exists at `site/node_modules/schema-dts/` (Article.astro's `import type ... from 'schema-dts'` resolves)
- `npx astro check` from `site/` exits 0 errors, 0 warnings (8 hints — 7 informational `is:inline` suggestions + 1 pre-existing `[service].astro` carryover)
- `npm run build` from `site/` exits 0; 17 pages built

---
*Phase: 05-aeo-performance-meta*
*Plan: 03*
*Completed: 2026-05-10*
