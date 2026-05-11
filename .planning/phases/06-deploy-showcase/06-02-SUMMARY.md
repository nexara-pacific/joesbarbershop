---
phase: 06-deploy-showcase
plan: 02
subsystem: testing
tags: [node, fs, validate-schema, preflight, cr-03]

requires:
  - phase: 05-aeo-performance-meta
    provides: "validate-schema.mjs with ENOENT-throwing preflight identified in 05-REVIEW.md CR-03"

provides:
  - "validate-schema.mjs preflight that short-circuits on missing dist/ via existsSync before invoking statSync"

affects: [deploy-showcase, ci]

tech-stack:
  added: []
  patterns: ["existsSync short-circuit before statSync to prevent ENOENT throw on missing directory"]

key-files:
  created: []
  modified:
    - site/scripts/validate-schema.mjs

key-decisions:
  - "Prepend !existsSync(distDir) || to the existing statSync condition rather than replacing it — short-circuit semantics prevent the statSync throw without changing the isDirectory() check for existing non-directory paths"

patterns-established:
  - "Preflight filesystem checks: always guard statSync with existsSync when the path may be absent"

requirements-completed: [DPLY-01]

duration: 2min
completed: 2026-05-11
---

# Phase 06 Plan 02: validate-schema preflight CR-03 Summary

**Two-line surgical fix adds existsSync short-circuit to validate-schema.mjs preflight, making the helpful "run npm run build first" message reachable when dist/ is absent**

## Performance

- **Duration:** ~2 min
- **Started:** 2026-05-11T10:16:05Z
- **Completed:** 2026-05-11T10:18:28Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments
- Added `existsSync` to the `node:fs` destructured imports on line 10
- Rewrote the preflight condition from `!statSync(distDir).isDirectory()` to `!existsSync(distDir) || !statSync(distDir).isDirectory()` so that a missing `dist/` directory short-circuits before `statSync` is invoked
- Verified State A (dist present): `node site/scripts/validate-schema.mjs` exits 0 with `validate-schema.mjs — OK (all JSON-LD blocks validate)`
- Verified State B (dist missing): exits 1 with `FAIL: dist directory not found at ... — run npm run build first` (not a raw ENOENT stack trace)
- Full audit.sh: 36 passed, 0 failed, 0 skipped (no regression)

## Task Commits

1. **Task 1: Reorder validate-schema.mjs preflight (CR-03)** - `89d727f` (fix)

## Files Created/Modified
- `site/scripts/validate-schema.mjs` - Added `existsSync` to imports; preflight condition now uses `!existsSync(distDir) || !statSync(distDir).isDirectory()`

## Decisions Made
None - followed plan as specified. The two-line fix matches exactly the CR-03 fix block from 05-REVIEW.md.

## Deviations from Plan
None - plan executed exactly as written.

## Issues Encountered
The worktree did not have `node_modules` (only the main repo does). Ran `npm install` in the worktree's `site/` to enable build and test verification. This is a standard worktree setup requirement, not a code issue.

## User Setup Required
None - no external service configuration required.

## Next Phase Readiness
- CR-03 closed; `validate-schema.mjs` preflight is now developer-friendly when `dist/` is absent
- Remaining Phase 06 work (deploy, Vercel preview, other CRs) can proceed

---
*Phase: 06-deploy-showcase*
*Completed: 2026-05-11*
