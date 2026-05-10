---
phase: 05-aeo-performance-meta
plan: 01
subsystem: infra
tags: [astro, vercel, npm, schema-dts, lighthouse, cheerio, robots-txt, scaffolding]

requires:
  - phase: 01-foundation
    provides: site/ Astro scaffold + package.json + .gitignore + audit.sh extension point from Phase 3
provides:
  - "Phase 5 npm dependencies installed (@vercel/analytics, @vercel/speed-insights, schema-dts, lighthouse, cheerio)"
  - "site/.env.example documenting PUBLIC_CLARITY_PROJECT_ID (D-03)"
  - "site/public/robots.txt with allow-all + sitemap-index.xml pointer (D-18, META-04)"
  - "site/scripts/validate-schema.mjs runnable stub (Plan 07 fills real validator)"
  - "site/scripts/generate-mtimes.mjs runnable stub (Plan 06 fills real git mtime walk)"
  - ".planning/phases/05-aeo-performance-meta/rich-results/ directory placeholder (D-25)"
  - "audit.sh extended with 9 Phase 5 check_* stub functions wired into dispatch + run_all_checks"
affects: [05-02, 05-03, 05-04, 05-05, 05-06, 05-07]

tech-stack:
  added: ["@vercel/analytics@^2.0.1", "@vercel/speed-insights@^2.0.0", "schema-dts@^2.0.0", "lighthouse@^13.3.0", "cheerio@^1.2.0"]
  patterns:
    - "Runnable stub scripts: header comment + STUB marker + console.log + process.exit(0) so downstream waves can drop in real bodies without changing call sites"
    - "audit.sh stub check_* functions call pass() unconditionally; downstream plan replaces body without touching dispatch/registry wiring"
    - "Positional CLI entry points (bash audit.sh jsonld) added alongside existing --check flag so Plan 5 verify commands are ergonomic"

key-files:
  created:
    - "site/.env.example"
    - "site/public/robots.txt"
    - "site/scripts/validate-schema.mjs"
    - "site/scripts/generate-mtimes.mjs"
    - ".planning/phases/05-aeo-performance-meta/rich-results/.gitkeep"
  modified:
    - "site/package.json"
    - "site/package-lock.json"
    - "site/.gitignore"
    - ".planning/phases/03-unique-pages/scripts/audit.sh"

key-decisions:
  - "Stub bodies always call pass() — Plan 07 replaces them. Avoids breaking the suite while we land downstream waves."
  - "Added positional CLI cases (e.g., `bash audit.sh jsonld`) so the plan's verify commands work without `--check`. The existing `--check <name>` form still works."
  - "Gitignored site/src/data/git-mtimes.json as a build artifact regenerated every prebuild (Plan 06 owns regeneration)."

patterns-established:
  - "Stub-first scaffolding for Phase 5: each later plan owns a specific stub body, the wiring is done now so dependencies are satisfied upfront"
  - "audit.sh extension: append new check_* functions, register in run_check, append to run_all_checks, optionally add positional entry-point case"

requirements-completed: [META-03, META-04]

duration: ~6 min
completed: 2026-05-10
---

# Phase 5 Plan 01: Wave 0 Scaffolding Summary

**Phase 5 dependency installs (5 npm packages), 2 runnable script stubs, robots.txt + .env.example, and 9 audit.sh check_* stubs wired into the dispatch — all downstream Phase 5 plans can now reference these files by name without bootstrapping.**

## Performance

- **Duration:** ~6 min (start 22:33 UTC, complete 22:36 UTC, includes 2 npm install rounds + 2 builds)
- **Started:** 2026-05-10T22:33:00Z
- **Completed:** 2026-05-10T22:36:12Z
- **Tasks:** 3
- **Files created:** 5
- **Files modified:** 4

## Accomplishments

- All five Phase 5 npm dependencies installed and locked (`@vercel/analytics`, `@vercel/speed-insights` as deps; `schema-dts`, `lighthouse`, `cheerio` as devDeps).
- `site/.env.example` documents `PUBLIC_CLARITY_PROJECT_ID` per D-03 — committed, not gitignored.
- `site/public/robots.txt` ships with allow-all + `Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml` per D-18 + META-04.
- `site/scripts/validate-schema.mjs` + `site/scripts/generate-mtimes.mjs` exist as executable stubs that exit 0 and document where the real implementations land.
- `.planning/phases/05-aeo-performance-meta/rich-results/` directory exists for D-25 manual screenshot paste artifacts.
- `audit.sh` extended with 9 new stub `check_*` functions (`check_jsonld`, `check_sitemap_links`, `check_robots`, `check_text_as_image`, `check_bluf`, `check_lighthouse`, `check_meta_unique_titles`, `check_meta_og_twitter`, `check_responsive_breakpoints`) wired into `run_check` dispatch + `run_all_checks` + positional CLI.
- `npm run build` still exits 0 (17 pages built).
- `bash audit.sh` (full suite) exits 0 with 32 passed / 0 failed / 0 skipped.

## Task Commits

Each task was committed atomically:

1. **Task 1: Install Phase 5 deps + robots.txt + .env.example + rich-results dir** — `140b4ec` (feat)
2. **Task 2: Scaffold validate-schema + generate-mtimes stubs** — `c37e26f` (feat)
3. **Task 3: Extend audit.sh with 9 Phase 5 check_* stubs** — `f79a494` (feat)

## Files Created/Modified

**Created:**
- `site/.env.example` — `PUBLIC_CLARITY_PROJECT_ID` documentation (committed for visibility; safe per T-05-02 — variable name only)
- `site/public/robots.txt` — allow-all + sitemap-index pointer
- `site/scripts/validate-schema.mjs` — runnable stub exiting 0 (Plan 07 fills body)
- `site/scripts/generate-mtimes.mjs` — runnable stub writing empty `{}` manifest (Plan 06 fills body)
- `.planning/phases/05-aeo-performance-meta/rich-results/.gitkeep` — directory placeholder

**Modified:**
- `site/package.json` — 5 new deps in `dependencies` + `devDependencies`
- `site/package-lock.json` — locked transitive tree (380 + 191 packages added across two installs)
- `site/.gitignore` — added `src/data/git-mtimes.json` (build artifact)
- `.planning/phases/03-unique-pages/scripts/audit.sh` — 9 stub `check_*` functions + 9 dispatch cases + 9 `run_all_checks` invocations + positional CLI case

## Decisions Made

- **Stubs call `pass()` unconditionally.** Real assertions land in Plan 07. Keeps the suite green across waves and lets every Phase 5 plan call check functions by name without owning the body. Trade-off: stubs don't yet catch regressions for their check; mitigated by Plan 07 wiring real bodies before phase completion.
- **Added positional CLI args to `audit.sh`.** Plan 05-01 verify commands use `bash audit.sh jsonld` form. Could have rewritten the verify to `bash audit.sh --check jsonld` but extending the entry point is forward-compatible with all downstream plans and zero risk of breaking existing `--check` callers.
- **Gitignored `site/src/data/git-mtimes.json`.** It's regenerated every prebuild by `generate-mtimes.mjs` (Plan 06). Committing it would create merge conflicts on every commit. Pattern: build-time generated data files are gitignored; their generators are committed.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Extended `audit.sh` entry point to accept positional check names**
- **Found during:** Task 3 (audit.sh extension)
- **Issue:** The plan's verify commands invoke `bash audit.sh jsonld`, `bash audit.sh sitemap-links`, etc. (positional form). Existing entry point only accepted `--check <name>` or empty (full suite). Without this fix, the plan's verify command would fail with "Usage: ..." error.
- **Fix:** Added a `jsonld|sitemap-links|robots|text-as-image|bluf|lighthouse|meta-unique-titles|meta-og-twitter|responsive-breakpoints)` case to the main `case "${1:-}"` block that routes to `run_check "$1"`. Preserves backward compat — existing `--check <name>` path and full-suite invocation untouched.
- **Files modified:** `.planning/phases/03-unique-pages/scripts/audit.sh`
- **Verification:** All 9 verify commands exit 0; full suite `bash audit.sh` still exits 0 with 32 passed.
- **Committed in:** `f79a494` (Task 3 commit)

---

**Total deviations:** 1 auto-fixed (1 blocking).
**Impact on plan:** No scope creep. Fix is forward-compatible and required for the plan's own verify commands to pass.

## Issues Encountered

- `npm install` reported 8 vulnerabilities (5 moderate, 3 high) — pre-existing transitive dependency issue from `lighthouse` toolchain (well-known; lighthouse pulls in older deps). Not a Phase 5 regression. Deferred to a later cleanup pass; lighthouse is dev-only and runs in CI, not in production. Documented in threat model as accepted risk under T-05-01.

## Known Stubs

The following files are intentional stubs per the plan — Plan 07 (Wave 6) and Plan 06 (Wave 5) fill the real bodies:

| File | Reason | Resolves in |
|------|--------|-------------|
| `site/scripts/validate-schema.mjs` | Real validator wraps cheerio + REQUIRED-fields map | Plan 05-07 |
| `site/scripts/generate-mtimes.mjs` | Real `git log` walk + filesystem-mtime fallback | Plan 05-06 |
| `audit.sh::check_jsonld` (and 8 sibling check_* fns) | All bodies call `pass()` until real assertions land | Plan 05-07 |

These stubs are not gaps — they are the documented Wave 0 contract from the plan's `<objective>`.

## User Setup Required

None — all changes are local repo files; npm install handled dependencies.

## Next Phase Readiness

- Wave 1+ plans (05-02 onward) can now reference:
  - `@vercel/analytics` + `@vercel/speed-insights` imports for layout wiring (Plan 02)
  - `schema-dts` types for schema components (Plan 03)
  - `lighthouse` + `cheerio` for validation scripts (Plan 07)
  - `validate-schema.mjs` / `generate-mtimes.mjs` script paths
  - `audit.sh` check_* function names for verify commands
- `npm run build` baseline still 17 pages, no regressions.
- `bash audit.sh` baseline: 32 passed, 0 failed, 0 skipped (includes the 9 new stubs as passes).

## Self-Check: PASSED

Verified all claimed artifacts exist and all claimed commits land:

- `site/.env.example` — FOUND
- `site/public/robots.txt` — FOUND
- `site/scripts/validate-schema.mjs` — FOUND (executable)
- `site/scripts/generate-mtimes.mjs` — FOUND (executable)
- `.planning/phases/05-aeo-performance-meta/rich-results/.gitkeep` — FOUND
- `.planning/phases/03-unique-pages/scripts/audit.sh` — modified, 9 new functions present
- Commit `140b4ec` — FOUND
- Commit `c37e26f` — FOUND
- Commit `f79a494` — FOUND
- `npm run build` — exits 0 (17 pages)
- `bash audit.sh` full suite — exits 0 (32/0/0)

---
*Phase: 05-aeo-performance-meta*
*Completed: 2026-05-10*
