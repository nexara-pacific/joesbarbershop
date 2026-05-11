---
phase: 06-deploy-showcase
plan: "01"
subsystem: data
tags: [typescript, schema, json-ld, astro]

requires:
  - phase: 05-aeo-performance-meta
    provides: "aggregateRating() helper in business.ts + CR-02 defect identified in code review"

provides:
  - "Guarded aggregateRating() — throws explicit Error on totalCount===0 instead of emitting NaN into JSON-LD"

affects: [AggregateRating.astro, any future caller of aggregateRating()]

tech-stack:
  added: []
  patterns:
    - "Fail-loud at build time: throw Error in helpers rather than returning NaN/null that silently propagates into JSON-LD"

key-files:
  created: []
  modified:
    - "site/src/data/business.ts"

key-decisions:
  - "Throw Error (not return null) so Astro build aborts loudly before broken JSON-LD ships — matches existing fail-loud idiom in validate-schema.mjs and generate-mtimes.mjs"

patterns-established:
  - "Guard divide-by-zero paths in build-time TS helpers with explicit throws, not silent NaN propagation"

requirements-completed: [DPLY-01]

duration: 10min
completed: "2026-05-11"
---

# Phase 06 Plan 01: Guard aggregateRating() against empty input (CR-02) Summary

**aggregateRating() now throws an explicit Error when totalCount===0, preventing silent NaN emission into HairSalon JSON-LD AggregateRating schema**

## Performance

- **Duration:** ~10 min
- **Started:** 2026-05-11T17:08:00Z
- **Completed:** 2026-05-11T17:18:12Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- Added `if (totalCount === 0) throw new Error(...)` guard before the divide in `aggregateRating()` — builds with populated ratings still pass (147 reviews across GBP + Yelp), empty-input path now aborts the build with a clear error message rather than emitting `"ratingValue": null` into JSON-LD
- Appended JSDoc sentence documenting the empty-input throw behavior
- npm run build exits 0; audit.sh gate green at 36 passed / 0 failed / 0 skipped; homepage `"@type":"AggregateRating"` still present in dist/index.html

## Task Commits

1. **Task 1: Guard aggregateRating() against empty input (CR-02)** - `2902c14` (fix)

**Plan metadata:** see final commit below

## Files Created/Modified

- `site/src/data/business.ts` - Added totalCount===0 guard + JSDoc sentence in aggregateRating()

## Decisions Made

- Throw Error (not return null or sentinel) — matches existing fail-loud idiom used by validate-schema.mjs (process.exit) and generate-mtimes.mjs (stderr warnings). A throw in a build-time helper aborts the Astro build before broken JSON-LD can ship to Vercel.

## Deviations from Plan

None — plan executed exactly as written.

## Issues Encountered

- node_modules not present in worktree — installed via `npm install` before running `npm run build`. Not a deviation; standard worktree setup step.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- CR-02 carryforward item from Phase 5 review is resolved
- Wave 1 cleanup continues with CR-03 (validate-schema.mjs preflight fix), CR-04 (Article publisher.logo), and D-01 geo correction in subsequent plans

## Self-Check: PASSED

- `site/src/data/business.ts` — FOUND
- `.planning/phases/06-deploy-showcase/06-01-SUMMARY.md` — FOUND
- Commit `2902c14` — FOUND
- Guard `totalCount === 0` present exactly once — PASS
- Throw message `aggregateRating: no rating sources` present exactly once — PASS
