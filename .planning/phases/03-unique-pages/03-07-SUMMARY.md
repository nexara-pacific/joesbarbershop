---
phase: 03-unique-pages
plan: 07
subsystem: ui
tags: [astro, aeo, about-page, portrait-placeholder, copywriting]

requires:
  - phase: 02-components
    provides: Visit.astro component, ClosingCTA.astro, Base.astro layout, business.json data
  - phase: 03-unique-pages
    provides: .agents/aeo-frame.md, .agents/product-marketing-context.md (plans 00, 01)

provides:
  - PAGE-04 — /about page with Joe Denesowicz + Alex bios, CSS-only portrait placeholders, Visit + ClosingCTA
  - data-pending-photo markers for post-Phase-3 photo swap pipeline
  - 4 new about.* entries in business.json._showcase_review_pending

affects: [phase-05-schema, phase-10-cleanup, photo-swap-pass]

tech-stack:
  added: []
  patterns:
    - "CSS-only portrait placeholder: dark bg + IM Fell initials + Oswald 'PORTRAIT TO COME' tag with data-pending-photo attr"
    - "Mirrored bio-grid: bio-grid (portrait L, copy R) vs bio-grid-mirrored (copy L, portrait R)"

key-files:
  created:
    - site/src/pages/about.astro
  modified:
    - site/src/data/business.json
    - .planning/phases/03-unique-pages/scripts/audit.sh

key-decisions:
  - "Alex bio conservative-minimal: 2 paragraphs, only verifiable facts (lead barber title, shop context, review count). No fabricated career history."
  - "Audit script grep -c replaced with grep -o | wc -l for data-pending-photo count — minified single-line HTML makes grep -c always return 1"
  - "Joe bio 2 paragraphs ~130 words: 2020 opening, three chairs, strip-mall context, $30 price, heritage visual identity. No hometown specifics not in brief."

requirements-completed: [PAGE-04]

duration: 18min
completed: 2026-05-08
---

# Phase 03 Plan 07: About Page Summary

**About page built with skill-drafted Joe Denesowicz + Alex bios, CSS-only portrait placeholders (JD / A initials, data-pending-photo markers), Visit and ClosingCTA reused from Phase 2**

## Performance

- **Duration:** ~18 min
- **Started:** 2026-05-08T22:28:00Z
- **Completed:** 2026-05-08T22:46:00Z
- **Tasks:** 2 (Task 1: copywriting; Task 2: file creation + JSON update)
- **Files modified:** 3

## Accomplishments

- /about page delivers PAGE-04 with Joe Denesowicz + Alex named in plain DOM text (ROADMAP success criterion #4)
- Two CSS-only portrait placeholders with `data-pending-photo="joe"` and `data-pending-photo="alex"` — IM Fell initials on dark bg, Oswald "PORTRAIT TO COME" tag
- BLUF answers primary query "who owns Joe's Barbershop in El Cajon" in first 100 words with first sentence in `<strong>`
- Visit component reused from Phase 2 unchanged; ClosingCTA reused unchanged
- 4 new `about.*` entries appended to `business.json._showcase_review_pending`
- All audit checks pass: about-staff-names, about-pending-photos, no-anti-patterns, no-accordions, no-client-directives, bluf-position
- Build exits 0; `site/dist/about/index.html` generated

## Skill Output Sources Cited

- `.agents/aeo-frame.md` — BLUF 100-word rule, entity-first declarative tone, primary query "who owns Joe's Barbershop in El Cajon"
- `.agents/product-marketing-context.md` — heritage voice, banned registers (no Brooklyn-grooming-bro, no luxury-spa, no SaaS), brand context
- `site/src/data/business.json` — ratings.google.value/count, ratings.yelp.count, prices.haircut, address data
- `inputs/00-brief.md` / vault baseline — year 2020, Joe Denesowicz, Alex as lead barber, three chairs, Bradley Ave, $30

## BLUF First Sentence (strong-wrapped)

> "Joe's Barbershop is owned by Joe Denesowicz, who opened the shop in 2020 in Bostonia, El Cajon, CA."

## Word Counts

- **BLUF capsule:** ~93 words
- **Joe bio:** ~127 words (2 paragraphs)
- **Alex bio:** ~60 words (2 paragraphs — conservative/minimal per D-06)

## Hallucination Spot-Check Log

Every factual claim in both bios traced to source artifacts:

| Claim | Source |
|-------|--------|
| Joe Denesowicz (last name) | product-marketing-context.md "Barbers: Joe Denesowicz (owner)" |
| Opened 2020 | product-marketing-context.md "ESTD. 2020, Bostonia strip-mall" |
| Bostonia, El Cajon | product-marketing-context.md one-liner |
| Strip-mall on Bradley Avenue | business.json address.street "723 E Bradley Ave" |
| Three chairs | product-marketing-context.md "3+ confirmed stations" |
| Walk-ins always welcome | product-marketing-context.md differentiation + business.json |
| Cash-only, ATM on site | product-marketing-context.md differentiation |
| $30 haircut | business.json prices.haircut = 30 |
| 4.9★ / 91 Google + 33 Yelp | business.json ratings.google + ratings.yelp |
| 120 combined reviews | 91 + 33 = 124; rounded to "more than 120" — conservative |
| Alex is lead barber | product-marketing-context.md "Alex (lead barber)" |
| Western/Victorian heritage, checkerboard floors, ornate serif logo, letter-board | product-marketing-context.md § Differentiation + Brand Voice |
| Tuesday through Saturday | business.json hours (no null for tue-sat) |

No fabricated biographical specifics: no schools, no prior shops, no hometown, no family details, no training credentials.

## 4 New business.json._showcase_review_pending Entries

1. `about.bios.joe — skill-drafted bio committed; specifics minimal until Joe confirms biographical details at showcase`
2. `about.bios.alex — skill-drafted minimal bio committed; specifics deferred to Joe's confirmation at showcase`
3. `about.portraits.joe — placeholder rendered as JD initials card; replace with real headshot post-Phase-3`
4. `about.portraits.alex — placeholder rendered as A initial card; replace with real headshot post-Phase-3`

## Visit Component

Visit renders unchanged below the Alex section. Confirmed in built HTML: `<section class="visit" id="visit"...>` appears after both bio sections. No modification to Visit.astro.

## Known Stubs

| Stub | File | Notes |
|------|------|-------|
| Portrait placeholders (JD / A initials + "PORTRAIT TO COME") | site/src/pages/about.astro | Intentional — per D-07. Replace with real headshots post-Phase-3 using `data-pending-photo` markers. Tracked in business.json._showcase_review_pending. |
| Alex bio minimal | site/src/pages/about.astro | Intentional — per D-06. Conservative/minimal until Joe confirms specifics at showcase. Tracked in business.json._showcase_review_pending. |

## Task Commits

1. **Task 1+2: Build about.astro + update business.json** — `a2226e1` (feat)

## Files Created/Modified

- `site/src/pages/about.astro` — About page: article-head, BLUF, Joe bio section, Alex bio section, Visit, ClosingCTA. CSS-only portrait placeholders.
- `site/src/data/business.json` — 4 new about.* entries appended to _showcase_review_pending array
- `.planning/phases/03-unique-pages/scripts/audit.sh` — Fixed about-pending-photos check: grep -c replaced with grep -o | wc -l (minified HTML is single line)

## Decisions Made

- Alex bio held to 2 short paragraphs (~60 words): only verifiable facts (lead barber title, three chairs, shop location, review count, hours). No fabricated career history, training, or personal detail per D-06.
- Joe bio 2 paragraphs (~127 words): 2020 opening, East County families framing, three chairs, cash-only walk-in policy, $30 price, Western/Victorian heritage identity. No hometown specifics not traceable to brief.
- Portrait placeholders use `var(--fg)` solid dark background (per UI-SPEC) — not gradient, not checkerboard pattern.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed audit.sh about-pending-photos false failure on minified HTML**
- **Found during:** Task 2 verification
- **Issue:** `check_about_pending_photos()` used `grep -c 'data-pending-photo'` which counts lines containing the pattern, not occurrences. Astro builds produce a single-line minified HTML file, so both markers on the same line returned count=1 instead of 2.
- **Fix:** Changed to `grep -o 'data-pending-photo' | wc -l` to count occurrences, not lines.
- **Files modified:** `.planning/phases/03-unique-pages/scripts/audit.sh`
- **Verification:** `bash audit.sh --check about-pending-photos` now passes
- **Committed in:** a2226e1 (part of task commit)

---

**Total deviations:** 1 auto-fixed (Rule 1 — bug in audit script)
**Impact on plan:** Necessary correctness fix. No scope creep; the page itself was correct, only the verification check was wrong.

## Issues Encountered

None beyond the audit script grep counting bug (documented in deviations above).

## Threat Flag Scan

No new network endpoints, auth paths, file access patterns, or schema changes introduced. Page is static HTML. No threat flags.

## For Plan 10 (Cleanup + Verification)

The 4 `about.*` pending markers in `business.json._showcase_review_pending` track the Phase 3 swap surface:
- `about.portraits.joe` + `about.portraits.alex` → swap `<div class="portrait-placeholder">` with `<Image>` when headshots arrive
- `about.bios.joe` + `about.bios.alex` → update bio prose after Joe confirms details at showcase

## Next Phase Readiness

- PAGE-04 delivered: `/about` names Joe Denesowicz and Alex in plain DOM text
- Portrait placeholder swap pipeline established via `data-pending-photo` markers
- Visit component confirmed reusable across pages (homepage + about now both use it)
- No blockers for remaining Phase 3 plans

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
