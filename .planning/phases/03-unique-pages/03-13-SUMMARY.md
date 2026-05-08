---
phase: 03-unique-pages
plan: "13"
subsystem: pages
tags:
  - cost-guide
  - aeo
  - copywriting
  - gap-closure
  - price-economics

# Dependency graph
requires:
  - phase: 03
    provides: 03-06 (cost guide page build), 03-10 (audit suite green), 03-VERIFICATION.md (owned-vs-referenced fact map)
provides:
  - Cost guide BLUF and prose refreshed with price-economics framing
  - FAQ Q1–Q3 reframed from operational policy to overhead/cost-model economics
  - Heritage/craft duplication eliminated from cost guide copy
  - All 11 See-Also slugs and 4 entry cards untouched
affects: [03-10-checkpoint, phase-04]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Owned-vs-referenced fact map applied: cost guide owns price spectrum and overhead economics; heritage narrative stays on /east-county-traditional-barbershop; operational hours/walk-in policy stays on /faq

key-files:
  created: []
  modified:
    - site/src/pages/2026-east-county-barbershop-cost-guide.astro

key-decisions:
  - "Cost guide's editorial angle is overhead-model economics (WHY prices differ), not heritage identity (WHAT traditional means) — those are separate pages"
  - "FAQ Q2 reframed from 'do barbershops take cards?' (operational policy) to 'why do cash-only shops cost less?' (cost economics) — differentiates from /faq Q07"
  - "FAQ Q3 reframed from 'does walk-in cost more?' (price equality) to 'do appointment-only shops charge more?' (booking-overhead economics) — differentiates from /faq Q04"

patterns-established:
  - "Gap-closure copywriting pass: read comparison pages first, identify where angles bleed into each other, reframe from the owned angle — not a rewrite, an angle pivot"

requirements-completed: [PAGE-03]

# Metrics
duration: 12min
completed: 2026-05-08
---

# Phase 03 Plan 13: Cost Guide Copy — Price-Economics Refresh Summary

**Cost guide BLUF and FAQ reframed around overhead-model economics (WHY $30, WHY cash-only costs less, WHY appointment shops trend higher), eliminating heritage/craft duplication with /east-county-traditional-barbershop and operational-policy duplication with /faq**

## Performance

- **Duration:** ~12 min
- **Started:** 2026-05-08T15:42:00Z
- **Completed:** 2026-05-08T15:54:00Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- BLUF now leads with full $15–$75 price spectrum (three shop-type bands) and immediately explains the strip-mall overhead + cash-only economics behind the $30 anchor — not heritage identity framing
- Prose H2 section pivots from "traditional shops vs everybody else" (heritage angle) to overhead-model analysis: why different shop types carry different cost structures
- FAQ Q1: reframed from "what makes $30 traditional" to "three-factor overhead formula (rent + volume + cash-only = $30)"
- FAQ Q2: reframed from operational policy (cash-only = ATM on site) to cost economics (card processing fees baked in vs not — why cash-only shops post true board prices)
- FAQ Q3: reframed from "walk-in vs appointment price parity" to "appointment-only shops carry higher per-cut overhead — booking software, lower throughput, fixed schedule costs"
- FAQ Q4: unchanged (already price-range focused with correct cross-links)
- Entry cards and See-Also block untouched (0 diff lines on those sections)
- All 11 Phase 4 slugs confirmed in See-Also block
- All 4 competitor entry cards confirmed in output
- audit.sh 18/18 PASS, astro check 0 errors/0 warnings, build exits 0

## Task Commits

1. **Task 1: Cost guide copy — price-economics framing** - `a9a55a7` (feat)

## Files Created/Modified

- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` — BLUF, prose H2, FAQ Q1–Q3 revised; entry cards and See-Also block untouched

## Decisions Made

- Kept all `business.{field}` interpolations in place (threat mitigation T-03-13-01: prices come from business.json at build time, not skill-authored literals)
- No hallucinated price values introduced — all price claims either use interpolations or restate facts already in the original copy ($30, $20, $15, $50, $35–$45 spectrum)
- FAQ Q4 left unchanged — it was already correctly framed around price-range comparison with proper cross-links to /kids-cuts and /hot-towel-shave

## Deviations from Plan

None — plan executed exactly as written.

The node_modules symlink was needed to run the build (worktree does not have its own node_modules), created as `site/node_modules -> /Users/darrelltang/dtconsulting/joesbarbershop/site/node_modules`. Not committed (symlink is not a tracked file change).

## Issues Encountered

- `npm run build` failed in worktree: no `node_modules` directory. Resolved by creating a symlink to the main repo's `site/node_modules`. Build then succeeded on first attempt. This is the standard worktree build pattern for this project.

## Known Stubs

None — all price values in revised copy are either `{business.prices.*}` interpolations (compile-time accurate) or restate the known price spectrum from the original file.

## Next Phase Readiness

- Cost guide copy differentiation complete. Ready for 03-10 final checkpoint re-run after all 6 gap-closure plans (03-11..03-16) land.
- No blockers.

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
