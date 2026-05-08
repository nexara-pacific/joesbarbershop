---
phase: 03-unique-pages
plan: 12
subsystem: ui
tags: [astro, aeo, copywriting, niche-landing, marketing-skills]

requires:
  - phase: 03-unique-pages
    provides: east-county-traditional-barbershop.astro page built with inline FAQ and areaServed sections
  - phase: 03-unique-pages
    provides: 03-VERIFICATION.md with owned-vs-referenced fact map driving gap-closure scope
  - phase: 03-unique-pages
    provides: 03-05-SUMMARY.md niche-landing page structural baseline
provides:
  - Heritage/craft-differentiated copy for /east-county-traditional-barbershop
  - BLUF that leads with AI citation angle and "what traditional means", not operational fact recitation
  - FAQ Q01/Q03/Q04/Q05/Q06 reframed with craft/heritage angle instead of verbatim operational answers
affects: [03-10 final checkpoint re-run, phase-05 schema, case-study documentation]

tech-stack:
  added: []
  patterns:
    - "Niche-landing owns craft/heritage differentiation angle; /faq owns operational detail verbatim"
    - "Walk-in availability framed as traditional-model feature, not operational convenience"
    - "Transparent pricing framed as traditional-shop value, not just a price list"

key-files:
  created: []
  modified:
    - site/src/pages/east-county-traditional-barbershop.astro

key-decisions:
  - "BLUF pivoted from full-hours/prices/walk-in recitation to AI citation angle + craft framing — hours/prices appear as brief supporting evidence only"
  - "Prose section sharpens chains-vs-neighborhood-anchor contrast rather than repeating operational overview"
  - "FAQ Q03 reframed: walk-in availability is a traditional barbershop model feature, not just 'no appointment needed'"
  - "FAQ Q04 reframed: transparent pricing is a traditional-shop value, price list is supporting evidence"
  - "node_modules not present in worktree — npm install run as Rule 3 blocking fix before build"

patterns-established:
  - "Copy differentiation pattern: niche-landing answers WHY (craft identity), /faq answers HOW (operational steps)"

requirements-completed: [PAGE-02]

duration: 18min
completed: 2026-05-08
---

# Phase 03 Plan 12: East County Traditional Barbershop Copy Refresh Summary

**Heritage/craft-angle copy refresh for /east-county-traditional-barbershop — BLUF pivots from operational-fact recitation to AI citation + craft differentiation, FAQ Q01/Q03/Q04 reframed with traditional-barbershop-identity angle**

## Performance

- **Duration:** ~18 min
- **Started:** 2026-05-08T22:40:00Z
- **Completed:** 2026-05-08T22:58:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- BLUF no longer recites "Tuesday through Saturday, 10am to 7:30pm" as its primary claim — now leads with the AI citation fact and the craft/heritage definition of "traditional"
- Prose section sharpens the chains-vs-neighborhood-anchor contrast (what traditional craft means vs. chain upsell structure) rather than being an operational overview
- FAQ Q01 reframes "traditional" as a three-part craft commitment (barber skill, fixed visible price, open-door walk-in), contrasting with the chain experience
- FAQ Q03 explicitly frames walk-in availability as the traditional barbershop model, not just an operational convenience
- FAQ Q04 leads with "transparent pricing is a traditional-shop value" before listing the board prices
- All 6 FAQ Q&As preserved, areaServed section unchanged, all structural elements intact
- audit.sh 18/18 PASS, Astro check 0 errors / 0 warnings, npm build exits 0

## Task Commits

1. **Task 1: Invoke copywriting skill for niche-landing and apply differentiated copy** - `009115d` (feat)

## Files Created/Modified

- `site/src/pages/east-county-traditional-barbershop.astro` - Heritage/craft-angle copy refresh: BLUF, prose paragraphs, and FAQ Q01/Q02/Q03/Q04/Q05/Q06 inline text

## Decisions Made

- BLUF pivoted to open with the AI citation fact ("the only specifically-cited shop") then define what "traditional" means structurally — hours/prices appear as "Open Tue–Sat, $30 base" in sentence 4, not as the lead claim
- Prose paragraph 1 focuses on craft identity (fixed price, same barber, heritage physical markers, no upsell) rather than operational summary
- Prose paragraph 2 uses competitor contrast (chains cycle stylists + upsell, grooming lounges charge premium-coded rates) to define Joe's position
- Walk-in stance framed via heritage model in Q03: "that is not a convenience feature at Joe's, it is the traditional barbershop model"
- Price list in Q04 retained but subordinated to "Transparent pricing is a traditional-shop value, not a feature"

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Installed node_modules in worktree before build**
- **Found during:** Task 1 (Step 6 build + audit)
- **Issue:** Worktree lacked node_modules; `npm run build` and `astro check` could not run
- **Fix:** Ran `npm install` in the worktree site directory (package-lock.json was present, installing from lockfile)
- **Files modified:** site/node_modules/ (not tracked in git)
- **Verification:** Build succeeded, audit passed, astro check passed after install
- **Committed in:** N/A (node_modules not committed)

---

**Total deviations:** 1 auto-fixed (1 blocking — missing node_modules in worktree)
**Impact on plan:** Blocking fix required for verification. No scope creep. No code changes beyond what the plan specified.

## Issues Encountered

None beyond the node_modules install.

## User Setup Required

None - no external service configuration required.

## Threat Mitigations Applied

Per plan threat model:
- T-03-12-01 (Tampering): Banned phrase grep executed, exits 1 (no matches). Structural diff confirms only inline text changed, no class names/element types/sections modified.
- T-03-12-03 (Repudiation - hallucinated facts): All factual claims verified against business.json and prior source materials. No hallucinated facts introduced. All `business.{field}` interpolations preserved for runtime accuracy.

## Known Stubs

None. All data-driven fields (`business.ratings`, `business.prices`, `business.address`, `business.phone`) remain wired to business.json via TypeScript import.

## Next Phase Readiness

- /east-county-traditional-barbershop.astro now has heritage/craft-differentiated copy that answers "traditional barbershop East County" via the AI citation angle and craft identity — not via operational fact recitation
- Ready for Plan 03-10 final checkpoint re-run (editorial gap closure wave complete)
- Phase 5 schema implementation (Article + FAQPage JSON-LD) can proceed against this copy baseline

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
