---
phase: 06-deploy-showcase
plan: "03"
subsystem: schema
tags: [schema-org, article, json-ld, rich-results, astro]

requires:
  - phase: 05-aeo-performance-meta
    provides: Article.astro schema component with publisher block; CR-04 defect documented in 05-REVIEW.md

provides:
  - Article schema with fully-specified publisher.logo ImageObject (url + width + height)
  - publisher.url field added to Article publisher block
  - Both Article-bearing pages (niche-landing + cost guide) emit the new publisher block in built JSON-LD

affects: [06-deploy-showcase wave 3 D-25 Rich Results paste, any plan that builds Article-typed pages]

tech-stack:
  added: []
  patterns:
    - "publisher.logo as ImageObject with explicit width/height per Google Article rich-result spec"
    - "Use sips -g pixelWidth -g pixelHeight to verify actual image dimensions before hardcoding in schema"

key-files:
  created: []
  modified:
    - site/src/components/schema/Article.astro

key-decisions:
  - "Logo dimensions hardcoded as 1600x1600 (verified with sips against 01-logo.jpg actual file) — not guessed"
  - "Kept 01-logo.jpg hardcoded per 06-PATTERNS.md recommendation: quick fix for Phase 6, WR-08 cleanup filed separately"

patterns-established:
  - "Article publisher.logo must be ImageObject with url + width + height — required for Google Article rich-result eligibility"

requirements-completed: [DPLY-01]

duration: 8min
completed: 2026-05-11
---

# Phase 06 Plan 03: Article Schema Publisher Logo (CR-04) Summary

**Article.astro publisher block extended with `url` and `logo` ImageObject (1600x1600) so both Article-bearing pages pass Google's "Publisher logo is required" rich-result check**

## Performance

- **Duration:** ~8 min
- **Started:** 2026-05-11T17:11:00Z
- **Completed:** 2026-05-11T17:19:14Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- Added `publisher.url` and `publisher.logo` (ImageObject with real 1600x1600 pixel dimensions) to `Article.astro`
- Both Article-bearing pages (`east-county-traditional-barbershop` + `2026-east-county-barbershop-cost-guide`) emit the full publisher block in built JSON-LD
- Build exits 0; audit gate holds at 36 passed / 0 failed / 0 skipped
- Wave 3 D-25 Rich Results paste will no longer be blocked by "Publisher logo is required" error

## Task Commits

1. **Task 1: Add publisher.url + publisher.logo to Article schema (CR-04)** - `c11bdd2` (fix)

## Files Created/Modified

- `site/src/components/schema/Article.astro` - Added `url: canonicalUrl`, `logo: { '@type': 'ImageObject', url: ..., width: 1600, height: 1600 }` to publisher block

## Decisions Made

- Logo dimensions verified with `sips -g pixelWidth -g pixelHeight` before commit; actual file is 1600x1600 — not guessed
- Used hardcoded `01-logo.jpg` filename per 06-PATTERNS.md "quick fix" recommendation; WR-08 data-driven cleanup deferred to a future phase

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- Worktree did not have `node_modules` installed (only the main repo did). Ran `npm install` in the worktree's `site/` directory before building. Build succeeded normally after install. No impact on output.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- CR-04 is resolved; Article-bearing pages emit a fully-compliant publisher block
- Wave 3 (D-25 Rich Results paste) can proceed without "Publisher logo is required" blocker
- Wave 1 of Phase 6 has this plan's fix as a prerequisite dependency; it is now satisfied

## Self-Check: PASSED

- `site/src/components/schema/Article.astro` — FOUND
- `.planning/phases/06-deploy-showcase/06-03-SUMMARY.md` — FOUND
- commit `c11bdd2` — FOUND in git log

---
*Phase: 06-deploy-showcase*
*Completed: 2026-05-11*
