---
phase: 05-aeo-performance-meta
plan: 05
subsystem: pages
tags: [astro, json-ld, schema-org, fragment-slot, head-slot, aeo, faqpage, service, person, article, review, aggregaterating, fetchpriority, lcp, hero, og-article, ogtype]

requires:
  - phase: 05-aeo-performance-meta
    provides: 7 schema components under site/src/components/schema/ from Plan 03 (HairSalon, AggregateRating, FAQPage, Service, Person, Article, Review)
  - phase: 05-aeo-performance-meta
    provides: Base.astro auto-injects HairSalon on every page and exposes named slot="head" for per-page overlays from Plan 04
  - phase: 05-aeo-performance-meta
    provides: Base.astro Props.ogType (consumed here on the two Article-archetype pages)
  - phase: 03-unique-pages
    provides: scripts/audit.sh full suite (32 checks) — re-verified for no regression on every modified page
provides:
  - "site/src/pages/index.astro: homepage emits HairSalon (auto) + AggregateRating + FAQPage via <Fragment slot=\"head\">"
  - "site/src/pages/about.astro: /about emits HairSalon (auto) + Person for Joe Denesowicz"
  - "site/src/pages/reviews.astro: /reviews emits HairSalon (auto) + Review[] (one <script> per review) from reviews.json"
  - "site/src/pages/faq.astro: /faq emits HairSalon (auto) + FAQPage flattened across 5 category groups (14 Q&As)"
  - "site/src/pages/east-county-traditional-barbershop.astro: niche-landing emits HairSalon (auto) + Article + FAQPage with ogType=article and placeholder dateModified (Plan 06 wires real value)"
  - "site/src/pages/2026-east-county-barbershop-cost-guide.astro: cost guide emits HairSalon (auto) + Article + FAQPage with ogType=article and placeholder dateModified (Plan 06 wires real value)"
  - "site/src/pages/[service].astro: 6 service routes each emit HairSalon (auto) + Service + FAQPage; hero <Image> now uses loading=eager + fetchpriority=high per D-20"
  - "site/src/pages/[neighborhood]-barber.astro: 5 neighborhood routes each emit HairSalon (auto) + FAQPage; hero storefront <Image> now uses loading=eager + fetchpriority=high per D-20"
  - "PERF-03 baseline: every modified page has exactly one fetchpriority=high image (homepage hero, service hero, neighborhood storefront)"
affects: [05-06, 05-07]

tech-stack:
  added: []  # no new deps; all components were created in Plan 03, Base.astro slot wired in Plan 04
  patterns:
    - "<Fragment slot=\"head\"> pattern (Astro named-slot consumption): per-page overlays land inside Base.astro's <slot name=\"head\" />. First-consumption of the slot reserved in Phase 2 D-26; Plan 04 emitted the slot tag, Plan 05 is the first page-level use."
    - "Parallel DOM ↔ schema-array pattern (faq.astro + niche-landing + cost guide): inline FAQ DOM rendering preserved verbatim; a constant array of {q, a} added to frontmatter mirrors the DOM and feeds the FAQPage component. Tagged with TODO Phase 7 to consolidate once a shared FAQList component lands."
    - "Per-archetype ogType: Article-archetype pages pass ogType=\"article\" to Base; all others use the default \"website\". Single-prop override, no per-page boilerplate."
    - "Single fetchpriority-high image per page (PERF-03): explicit loading=\"eager\" + fetchpriority=\"high\" + decoding=\"sync\" attribute trio on the LCP hero. Matches Hero.astro's existing pattern; no Astro 6 'priority' shorthand used because the component does not expose one — explicit attributes are the canonical Astro 6 pattern (verified node_modules/astro/components/Image.astro)."
    - "TODO Plan 06 marker for dateModified placeholder: both Article-emitting pages carry a string constant + the marker comment so Plan 06 can grep-and-replace deterministically."

key-files:
  created:
    - ".planning/phases/05-aeo-performance-meta/05-05-SUMMARY.md"
  modified:
    - "site/src/pages/index.astro"
    - "site/src/pages/about.astro"
    - "site/src/pages/reviews.astro"
    - "site/src/pages/faq.astro"
    - "site/src/pages/east-county-traditional-barbershop.astro"
    - "site/src/pages/2026-east-county-barbershop-cost-guide.astro"
    - "site/src/pages/[service].astro"
    - "site/src/pages/[neighborhood]-barber.astro"

key-decisions:
  - "Used parallel DOM ↔ schema-array pattern (Option B from PATTERNS line 906) for faq.astro, niche-landing, and cost guide rather than refactoring the inline FAQ JSX into faqGroups.map() rendering. Reason: zero CSS / DOM risk, smaller diff, FAQ.astro hard-codes the homepage's 5 Q&As inline anyway — consolidation is a Phase 7 concern. Each duplication is marked with `// TODO Phase 7: consolidate DOM ↔ schema array duplication`."
  - "Hero priority via explicit attributes (loading=\"eager\" fetchpriority=\"high\" decoding=\"sync\") rather than a hypothetical Astro 6 `priority` shorthand. Verified node_modules/astro/components/Image.astro does NOT expose a `priority` prop in this Astro version; the canonical pattern is the three explicit attributes, matching Hero.astro line 33."
  - "service-hero and neighborhood-photo Image tags switched from loading=\"lazy\" to loading=\"eager\" fetchpriority=\"high\" decoding=\"sync\". Each templated page now has exactly one fetchpriority-high image: the hero (verified by grep -c → 1 on sampled fades, bostonia-barber, index)."
  - "Used `<Fragment slot=\"head\">` literally rather than a single-element slot — even on pages with only one schema overlay (about, neighborhood). Reason: consistent pattern across all 8 modified pages; Astro handles both forms identically; reads better as a contract."
  - "Did NOT remove the pre-existing unused `business` import in [service].astro. The plan said `preserve all existing imports`. Hint is benign carryover from Plan 02 baseline; Plan 07's astro-check pass will either resolve it or document acceptance."
  - "Author of cost guide Article = `Darrell Tang` (playbook listicle author, per plan); author of niche-landing Article = `Joe Denesowicz` (Joe's voice). Both are defensible E-E-A-T attributions and match the plan's prescribed defaults."
  - "Page descriptions for Article pages are hand-authored (≤160 chars each, distinct from BLUF) so the meta description, og:description, and twitter:description tags are consumer-facing rather than truncated BLUF. Description prop for [service].astro + [neighborhood]-barber.astro still passes entry.data.bluf directly per D-14 (full BLUF flows; search engines truncate at render time)."

requirements-completed: [AEO-02, AEO-03, AEO-04, AEO-05, AEO-06, AEO-07, AEO-08, PERF-03]

duration: ~10 min
completed: 2026-05-10
---

# Phase 5 Plan 05: Page Schema Overlays Summary

**Threaded the six page-specific JSON-LD schema components into 8 page files via Astro's `<Fragment slot="head">` pattern — first consumption of the slot reserved by Phase 2 D-26 and emitted by Plan 04's Base.astro. Every one of the 17 built routes now carries both the auto-injected HairSalon identity (Plan 04) AND its archetype-appropriate overlay: AggregateRating + FAQPage on the homepage; Person on /about; Review[] on /reviews; FAQPage on /faq; Article + FAQPage on the niche-landing and cost guide (with placeholder dateModified marked `TODO Plan 06`); Service + FAQPage on each of the 6 service routes; FAQPage on each of the 5 neighborhood routes. Hero `fetchpriority="high"` verified on the homepage and added to service and neighborhood templates per PERF-03 / D-20 (exactly one priority image per page). `npm run build` exits 0 (17 pages, 1.83–2.0s build time); `bash audit.sh` exits 0 (32 passed / 0 failed).**

## Performance

- **Duration:** ~10 min (3 commits straddling 23:00Z–23:10Z; includes one `npm install` for missing node_modules, 4 incremental builds, audit suite, AEO-07 manual check)
- **Started:** 2026-05-10T23:00:00Z (approx)
- **Completed:** 2026-05-10T23:10:00Z (approx)
- **Tasks:** 3
- **Files modified:** 8 source pages
- **Files created:** 1 (this SUMMARY)

## Accomplishments

- **Task 1 — 4 unique pages wired with archetype schemas** (`d7e1e69`):
  - `index.astro`: AggregateRating + FAQPage via `<Fragment slot="head">`. `homepageFaqs` constant added in frontmatter mirroring the 5 inline Q&As in `FAQ.astro` lines 13-47 verbatim (TODO Phase 7 marker for consolidation).
  - `about.astro`: Person schema for Joe Denesowicz (`name="Joe Denesowicz"`, `jobTitle="Owner / Barber"`, `slug="joe-denesowicz"`). Single Person emission per D-09 (Alex no longer cutting).
  - `reviews.astro`: Review[] schema — passed `sortedReviews` directly (field names `name`, `rating`, `quote`, `source`, `date` matched `ReviewItem` interface exactly; no remapping needed).
  - `faq.astro`: FAQPage schema — `allFaqs` flat constant added (14 Q&As across 5 category groups) parallel to the existing inline DOM rendering. Body refactor avoided (Option B from PATTERNS line 906) — zero CSS / DOM risk, smaller diff.
- **Task 2 — Article + FAQPage on the two long-form pages** (`ed497db`):
  - `east-county-traditional-barbershop.astro`: Article + FAQPage in slot; `ogType="article"`; `datePublished="2026-05-08"` + `dateModified='2026-05-10T00:00:00-07:00'` (TODO Plan 06 marker for git-mtimes substitution); `authorName="Joe Denesowicz"`. Six FAQs added as parallel `faqs` array.
  - `2026-east-county-barbershop-cost-guide.astro`: Article + FAQPage in slot; `ogType="article"`; same placeholder dateModified pattern; `authorName="Darrell Tang"` (playbook listicle author). Four FAQs added as parallel `faqs` array.
  - Both pages: every existing `<style>` block, prose, BLUF, area-served / neighborhoods list, and inline FAQ DOM preserved verbatim. Diff is purely additive (frontmatter imports + dateModified/datePublished/faqs constants + slot Fragment).
- **Task 3 — Templated pages wired + hero priority verified** (`8ce7130`):
  - `[service].astro` (6 routes): Service + FAQPage in slot. Hero `<Image>` switched from `loading="lazy"` to `loading="eager" fetchpriority="high" decoding="sync"` per D-20.
  - `[neighborhood]-barber.astro` (5 routes): FAQPage in slot (no Service overlay — relies on auto-injected HairSalon for identity per PATTERNS line 1050). Storefront `<Image>` switched to same priority attributes per D-20.
- **Build success** after each task:
  - `npm run build` exits 0; 17 pages built in 1.83–2.0s; no regressions.
  - Final dist verification grep: all 17 routes carry `"@type":"HairSalon"`; archetypes additionally carry AggregateRating + FAQPage (homepage), Person (about), Review (reviews), FAQPage (faq), Article + FAQPage (Article pages), Service + FAQPage (services), FAQPage (neighborhoods).
  - `og:type="article"` confirmed in dist HTML on the two Article-archetype pages.
- **`bash audit.sh` 32 passed / 0 failed** after all three tasks — no Phase 3/4 regression.
- **AEO-07 baseline holds:** manual grep of `<img alt="..."` in all 11 templated dist HTML files found zero alt-text containing a `$` price marker. (Stub check in audit.sh always passes; this is the real verification.)
- **PERF-03 hero priority:** exactly one `fetchpriority="high"` image per modified page — verified on `dist/index.html`, `dist/fades/index.html`, `dist/bostonia-barber/index.html` (all return `grep -c → 1`).

## Task Commits

Each task was committed atomically:

1. **Task 1: Wire schema overlays into 4 unique pages (index, about, reviews, faq)** — `d7e1e69` (feat)
2. **Task 2: Wire Article + FAQPage into niche-landing and cost guide with placeholder dateModified** — `ed497db` (feat)
3. **Task 3: Wire Service + FAQPage into templated pages with hero priority** — `8ce7130` (feat)

## Files Created/Modified

**Modified (8):**

- `site/src/pages/index.astro` (27 → 56 lines): +2 imports (AggregateRating, FAQPage), +`homepageFaqs` constant (5 entries from FAQ.astro), `<Fragment slot="head">` block with AggregateRating + FAQPage. Body unchanged.
- `site/src/pages/about.astro` (172 → 184 lines): +1 import (Person), +`joeDescription` constant, `<Fragment slot="head">` block with one Person. Body + style block unchanged.
- `site/src/pages/reviews.astro` (183 → 187 lines): +1 import (Review), `<Fragment slot="head">` with `<Review reviews={sortedReviews} />`. Body + style block unchanged.
- `site/src/pages/faq.astro` (181 → 252 lines): +1 import (FAQPage), +`allFaqs` flat 14-entry constant mirroring the inline DOM, `<Fragment slot="head">` with FAQPage. Body + style block unchanged.
- `site/src/pages/east-county-traditional-barbershop.astro` (283 → 326 lines): +2 imports (Article, FAQPage), +`dateModified` + `datePublished` constants (with TODO Plan 06 marker), +6-entry `faqs` array mirroring inline DOM, `ogType="article"` added to Base props, `<Fragment slot="head">` with Article + FAQPage. Body + style block unchanged.
- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` (411 → 456 lines): +2 imports, +date constants + 4-entry `faqs` array, `ogType="article"` added, `<Fragment slot="head">` with Article + FAQPage. Body + style block unchanged.
- `site/src/pages/[service].astro` (413 lines, +6 lines net): +2 imports (Service, FAQPage), `<Fragment slot="head">` with both, hero `<Image>` switched from `loading="lazy"` to `loading="eager" fetchpriority="high" decoding="sync"`. Body + style block unchanged.
- `site/src/pages/[neighborhood]-barber.astro` (397 lines, +6 lines net): +1 import (FAQPage), `<Fragment slot="head">` with FAQPage, storefront `<Image>` switched to same priority attributes. Body + style block unchanged.

**Created (1):**
- `.planning/phases/05-aeo-performance-meta/05-05-SUMMARY.md` (this file).

## Decisions Made

- **Parallel DOM ↔ schema-array pattern (Option B from PATTERNS line 906)** for `faq.astro`, niche-landing, and cost guide. Inline FAQ JSX preserved verbatim; an `allFaqs` / `faqs` constant added to frontmatter mirrors the DOM and feeds the FAQPage component. Each duplication carries a `// TODO Phase 7: consolidate DOM ↔ schema array duplication` comment. Reason: zero CSS / DOM risk for v1; FAQ.astro already hard-codes the homepage's 5 Q&As; consolidation is Phase 7 work once a shared `<FAQList items={...}>` component lands.
- **Hero priority via explicit attribute trio** (`loading="eager" fetchpriority="high" decoding="sync"`) rather than a hypothetical Astro 6 `priority` shorthand. Verified by reading `node_modules/astro/components/Image.astro` — no `priority` prop exists in this version of Astro 6. The explicit-attributes form is the canonical pattern and matches Hero.astro line 33 exactly. PERF-03 baseline met without any plumbing changes.
- **`ogType="article"` only on Article-archetype pages** (niche-landing + cost guide). Every other page inherits Base's default `ogType="website"`. Single-prop override, zero per-page boilerplate.
- **Author byline: niche-landing = `Joe Denesowicz`** (Joe's voice — what "traditional barbershop" means in East County reads like Joe's perspective); **cost guide = `Darrell Tang`** (playbook listicle author per plan task 2 default). Both defensible E-E-A-T attributions.
- **Hand-authored Article descriptions ≤160 chars** for the two Article pages (distinct from BLUF) so the meta description, og:description, and twitter:description tags are consumer-facing rather than truncated BLUF. Other pages keep `entry.data.bluf` as the description prop per D-14 (full BLUF flows; search engines truncate at render time).
- **Did NOT refactor `[service].astro`'s `business` import.** Pre-existing unused-import hint from Plan 02 baseline is benign and out of scope for Plan 05. The plan said "preserve all existing imports."

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Re-materialized worktree's missing `site/node_modules/` tree**
- **Found during:** Pre-Task-1 dependency check (`test -d site/node_modules` returned negative; the entire directory was missing in this worktree, same situation Plans 02, 03, 04 each documented).
- **Issue:** `npm run build` would fail with module-resolution errors on Astro core packages without `node_modules`. Same root cause as prior plans: worktree branches the merge of prior plans, and `node_modules/` is gitignored.
- **Fix:** Ran `cd site && npm install --no-fund --no-audit` non-interactively. 571 packages materialized from the locked tree. No changes to `package.json` or `package-lock.json`.
- **Files modified:** None tracked in git. Only `site/node_modules/` (gitignored).
- **Verification:** `npm run build` exited 0 on the baseline build (pre-Task-1).
- **Committed in:** Not committed — no tracked files changed.

---

**Total deviations:** 1 auto-fixed (1 blocking — worktree-state-recovery).
**Impact on plan:** Zero scope creep. Same recovery step that Plans 02–04 documented.

## Issues Encountered

- **Astro emits the same 8 informational hints** as Plans 03–04 baseline: 7 `is:inline` suggestions on the schema components themselves, 1 pre-existing `[service].astro` unused-import hint (`business` import — preserved per plan instruction "preserve all existing imports"). No new hints introduced by Plan 05; all 8 are documented carryover.
- **`<Fragment slot="head">` consumption pattern works as Phase 2 D-26 designed.** No edge cases. Astro renders the fragment contents inside Base.astro's named `<slot name="head" />` exactly where the slot tag is placed, after HairSalon and before Vercel telemetry, with proper escaping and zero runtime cost.
- **Service.astro emits `Place` schemas for areaServed** — visible in service-page schema audit. This is correct per Plan 03's Service.astro implementation (`areaServed: business.areaServed.map((name) => ({ '@type': 'Place', name }))`). Not new content; just visible in the schema audit grep.

## Known Stubs

- **`dateModified` placeholder on both Article pages** (`'2026-05-10T00:00:00-07:00'`). Plan 06 will replace this with the real git-mtime value from `git-mtimes.json`. Both occurrences are marked with `// TODO Plan 06: replace with mtimes['<page-file>']` so a grep is deterministic. This is intentional per Plan 05's `must_haves.truths` line 24-25 ("placeholder dateModified — Plan 06 wires real value") and is documented in `key_links.via` ("TODO Plan 06 placeholder dateModified"). NOT a "the goal can't be achieved" stub — Plan 05's goal is schema emission; Plan 06's is data freshness.
- **Parallel FAQ arrays in `faq.astro`, niche-landing, and cost guide.** Each page has a constant array of `{q, a}` in frontmatter mirroring the inline DOM Q&As. Marked with `// TODO Phase 7: consolidate DOM ↔ schema array duplication`. NOT a "goal can't be achieved" stub — FAQPage schema emits correctly; this is a code-organization concern for a future refactor when a shared `<FAQList items={...}>` component lands.

## Threat Flags

None new. Plan's threat model fully addressed:

- **T-05-14 (Tampering — collection markdown FAQ text → FAQPage JSON-LD):** Schema content flows from repo-tracked sources (collection MDX frontmatter or frontmatter constants in page files). No user input, no runtime data. Plan 07's `validate-schema.mjs` will grep all emitted JSON-LD for `</script>` substring; current FAQ content is short answer prose with no risk.
- **T-05-15 (Information Disclosure — reviews quote text emitted to JSON-LD):** Accepted per plan. All reviews data is from public GBP/Yelp scrapes; quotes are intentional discovery surface.
- **T-05-16 (Tampering — Astro.url manipulation):** Accepted. Astro.url is build-time-computed from `getStaticPaths` output, not user input. Static site means no runtime manipulation vector.

## User Setup Required

None — Plan 05 is pure source-file edits. No new env vars, no new package, no Vercel dashboard touches.

## Next Phase Readiness

Wave 6+ plans can now:

- **Plan 06** — emit `site/src/data/git-mtimes.json` from a build-time script, import it in the two Article pages, and replace the placeholder `dateModified` string + remove the `// TODO Plan 06` comments. Both pages are already structured to consume `mtimes['site/src/pages/<file>.astro']` via a single-line edit.
- **Plan 07** — `validate-schema.mjs` walks `dist/**/*.html`, extracts every `<script type="application/ld+json">` block, parses the JSON, and asserts: (a) no `</script>` substring in any field (T-05-14 mitigation), (b) every page has at least one `"@type":"HairSalon"`, (c) every Article-emitting page has both Article + FAQPage, (d) every Service page has both Service + FAQPage, (e) every neighborhood page has FAQPage, (f) `@id` URLs are consistent across cross-references. The schema surface is now stable for the validator to target.
- **Future Phase 7 cleanup** — extract `<FAQList items={...}>` shared component, replace the parallel-array TODO markers in faq.astro / niche-landing / cost guide, drop the `homepageFaqs` constant in index.astro by passing faqs through `<FAQ faqs={...} />`.

Baseline maintained: `npm run build` exits 0, 17 pages built; `audit.sh` 32/32 passed.

## Self-Check: PASSED

Verified all claimed artifacts and commits:

- `site/src/pages/index.astro` — FOUND, modified (frontmatter has `import AggregateRating`, `import FAQPage`, `const homepageFaqs`; body has `<Fragment slot="head">`)
- `site/src/pages/about.astro` — FOUND, modified (`import Person`, Fragment slot with `<Person name="Joe Denesowicz" slug="joe-denesowicz" />`)
- `site/src/pages/reviews.astro` — FOUND, modified (`import Review`, Fragment slot with `<Review reviews={sortedReviews} />`)
- `site/src/pages/faq.astro` — FOUND, modified (`import FAQPage`, `const allFaqs = [...]` 14 entries, Fragment slot with FAQPage)
- `site/src/pages/east-county-traditional-barbershop.astro` — FOUND, modified (`import Article`, `import FAQPage`, `// TODO Plan 06` marker, `ogType="article"`, Fragment slot with Article + FAQPage)
- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` — FOUND, modified (same Article+FAQPage pattern, `// TODO Plan 06`, `ogType="article"`)
- `site/src/pages/[service].astro` — FOUND, modified (`import Service`, `import FAQPage`, Fragment slot with both, `fetchpriority="high"` on hero Image)
- `site/src/pages/[neighborhood]-barber.astro` — FOUND, modified (`import FAQPage`, Fragment slot with FAQPage, `fetchpriority="high"` on storefront Image)
- Commit `d7e1e69` (Task 1) — FOUND in `git log --oneline`
- Commit `ed497db` (Task 2) — FOUND in `git log --oneline`
- Commit `8ce7130` (Task 3) — FOUND in `git log --oneline`
- `dist/index.html` contains `"@type":"AggregateRating"` AND `"@type":"FAQPage"` AND `"@type":"HairSalon"` — verified
- `dist/about/index.html` contains `"@type":"Person"` — verified
- `dist/reviews/index.html` contains `"@type":"Review"` — verified
- `dist/faq/index.html` contains `"@type":"FAQPage"` — verified
- `dist/east-county-traditional-barbershop/index.html` contains `"@type":"Article"` AND `"@type":"FAQPage"` AND `og:type" content="article"` — verified
- `dist/2026-east-county-barbershop-cost-guide/index.html` contains `"@type":"Article"` AND `"@type":"FAQPage"` AND `og:type" content="article"` — verified
- All 6 service pages contain `"@type":"Service"` AND `"@type":"FAQPage"` AND `"@type":"HairSalon"` — verified by loop
- All 5 neighborhood pages contain `"@type":"FAQPage"` AND `"@type":"HairSalon"` — verified by loop
- `grep -c 'fetchpriority="high"' dist/index.html` → 1
- `grep -c 'fetchpriority="high"' dist/fades/index.html` → 1
- `grep -c 'fetchpriority="high"' dist/bostonia-barber/index.html` → 1
- `npm run build` exits 0; 17 pages built; build duration 1.83–2.0s
- `bash audit.sh` exits 0: 32 passed / 0 failed / 0 skipped
- AEO-07 manual check: zero `<img alt="...">` containing `$<price>` substring across all 11 templated dist HTML files

---
*Phase: 05-aeo-performance-meta*
*Plan: 05*
*Completed: 2026-05-10*
