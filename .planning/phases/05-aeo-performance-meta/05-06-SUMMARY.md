---
phase: 05-aeo-performance-meta
plan: 06
subsystem: infra
tags: [astro, prebuild, git-mtime, dateModified, last-updated, article, schema-org, freshness, vercel-deep-clone]

requires:
  - phase: 05-aeo-performance-meta
    provides: "Plan 01 generate-mtimes.mjs stub + site/.gitignore entry + site/src/data/ directory"
  - phase: 05-aeo-performance-meta
    provides: "Plan 05 Article schema wired on both Article pages with TODO Plan 06 placeholder dateModified"
provides:
  - "site/scripts/generate-mtimes.mjs — real impl: runs `git log -1 --format=%cI -- <page>` for the two Article pages, writes site/src/data/git-mtimes.json (D-10)"
  - "site/package.json scripts.prebuild=`node scripts/generate-mtimes.mjs` (npm runs it automatically before astro build)"
  - "site/src/components/LastUpdated.astro — visible 'Last updated: Month D, YYYY' line component (D-11)"
  - "site/src/pages/east-county-traditional-barbershop.astro: imports mtimes + LastUpdated; emits real Article.dateModified and renders LastUpdated between BLUF and prose"
  - "site/src/pages/2026-east-county-barbershop-cost-guide.astro: same wiring as niche-landing"
  - "site/src/data/git-mtimes.json — pre-build generated manifest (gitignored)"
  - "Filesystem-mtime fallback when `git log` returns empty (Vercel shallow-clone safety net)"
affects: [05-07]

tech-stack:
  added: []  # no new deps; uses node:child_process + node:fs from Node stdlib
  patterns:
    - "Pre-build hook via npm `prebuild` lifecycle: `npm run build` automatically runs `npm run prebuild` first, regenerating site/src/data/git-mtimes.json from current git history. Zero wiring beyond the script name."
    - "Generated build artifact pattern: site/src/data/git-mtimes.json is gitignored (Plan 01 added the entry); the generator (`scripts/generate-mtimes.mjs`) is committed. Pages import the manifest as a normal JSON module."
    - "Sync-by-construction freshness: Article.dateModified (JSON-LD) AND visible '<LastUpdated />' line both read the same mtimes['<page-path>'] value. Impossible to update one without the other."
    - "Defensive fallback chain: git log → filesystem stat → build time. Each step warns to stderr; build never aborts on freshness lookup failure."

key-files:
  created:
    - "site/src/components/LastUpdated.astro"
    - ".planning/phases/05-aeo-performance-meta/05-06-SUMMARY.md"
  modified:
    - "site/scripts/generate-mtimes.mjs"
    - "site/package.json"
    - "site/src/pages/east-county-traditional-barbershop.astro"
    - "site/src/pages/2026-east-county-barbershop-cost-guide.astro"
  generated:  # not committed
    - "site/src/data/git-mtimes.json"

key-decisions:
  - "Placed LastUpdated.astro at site/src/components/LastUpdated.astro (not /schema/) — it's a visible DOM component, not a JSON-LD emitter. Schema components stay segregated under /components/schema/."
  - "Both pages wrap <LastUpdated /> in <div class=\"wrap\"> matching every other inner-page section's container pattern. Provides consistent max-width + horizontal padding so the date line aligns with surrounding prose."
  - "Kept the existing top-of-page `UPDATED MAY 2026` kicker line (`.date-stamp` element) untouched per plan instruction: 'KEEP it as-is — per D-11 the new line is between BLUF and prose, not replacing the existing top-of-page stamp.' Two date stamps coexist temporarily; Phase 7 may consolidate."
  - "Pages import git-mtimes.json with `import mtimes from '../data/git-mtimes.json'`. Astro/Vite resolves JSON imports natively; the import is build-time-only, evaluated once per page render. No runtime cost."
  - "Fallback chain uses native `node:fs.statSync(...).mtime.toISOString()` rather than a third-party freshness library. Stays in stdlib; one fewer dep to audit."

requirements-completed: [AEO-06]

duration: ~6 min
completed: 2026-05-10
---

# Phase 5 Plan 06: Real git-mtime + LastUpdated Wiring Summary

**Replaced Plan 01's `generate-mtimes.mjs` stub with a real implementation that reads `git log -1 --format=%cI` for each Article page and writes the manifest to `site/src/data/git-mtimes.json`. Added the `prebuild` npm hook so every `npm run build` regenerates the manifest automatically. Created `site/src/components/LastUpdated.astro` (a visible "Last updated: Month D, YYYY" line component, styled to match the existing `.date-stamp` kicker), and wired both Article pages (`east-county-traditional-barbershop.astro` + `2026-east-county-barbershop-cost-guide.astro`) to import the manifest, emit the real ISO timestamp as `Article.dateModified`, and render `<LastUpdated isoDate={dateModified} />` directly between the BLUF section and the prose section per D-11. The two `TODO Plan 06` markers from Plan 05 are now gone; the placeholder dateModified string `'2026-05-10T00:00:00-07:00'` no longer appears anywhere in source or built HTML. The JSON-LD field and the visible line are guaranteed in sync by construction — both read the same `mtimes[<page-path>]` value.**

## Performance

- **Duration:** ~6 min (start 16:09 PT, complete 16:15 PT; includes one `npm install` for missing node_modules, 3 incremental builds, full audit run)
- **Started:** 2026-05-10T23:09:00Z (approx)
- **Completed:** 2026-05-10T23:15:00Z (approx)
- **Tasks:** 2
- **Files created:** 1 source (LastUpdated.astro) + 1 summary
- **Files modified:** 4 (generate-mtimes.mjs, package.json, two Article pages)
- **Files generated (not committed):** 1 (git-mtimes.json)

## Accomplishments

- **Task 1 — Real `generate-mtimes.mjs` + prebuild wire** (`0d5984d`):
  - Replaced the Plan 01 stub body (which wrote an empty `{}` manifest) with a real impl that loops the two Article page paths, runs `git log -1 --format=%cI -- "<page>"` from the repo root, and writes the ISO timestamps to `site/src/data/git-mtimes.json`.
  - Imports `execSync` from `node:child_process` and `statSync` from `node:fs` for the git→filesystem fallback chain.
  - Defensive: if `git log` returns empty (e.g., Vercel shallow clone), falls back to `statSync(absPath).mtime.toISOString()` with a stderr warning. If both fail (file missing), uses `new Date().toISOString()` as last resort. Build never aborts on freshness lookup.
  - Added `"prebuild": "node scripts/generate-mtimes.mjs"` to `site/package.json` between `dev` and `build`. npm runs `prebuild` automatically before `build` — no further wiring needed.
  - Confirmed `site/.gitignore` already contained `src/data/git-mtimes.json` from Plan 01 (no edit needed).
  - First manifest written to `site/src/data/git-mtimes.json`: two entries, both real ISO 8601 strings starting with `2026-05-10T`.
  - `npm run build` exits 0; build log shows `> site@0.0.1 prebuild` firing before `> site@0.0.1 build`; 17 pages built in 2.05s.
- **Task 2 — LastUpdated.astro + Article-page wiring** (`ec84dcf`):
  - Created `site/src/components/LastUpdated.astro` with `Props { isoDate: string }`, formatting via `new Date(isoDate).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' })` (e.g., "May 10, 2026"). Style values (`font-board`, `letter-spacing: 0.16em`, `color: var(--muted)`, `font-size: 11.5px`) copied from the existing `.date-stamp` rule in `east-county-traditional-barbershop.astro` so the new line visually matches the existing top-of-page kicker.
  - `east-county-traditional-barbershop.astro`: added `import LastUpdated from '../components/LastUpdated.astro'` and `import mtimes from '../data/git-mtimes.json'`. Replaced `const dateModified = '2026-05-10T00:00:00-07:00'` (with the `// TODO Plan 06` comment) with `const dateModified = mtimes['site/src/pages/east-county-traditional-barbershop.astro']`. Inserted `<div class="wrap"><LastUpdated isoDate={dateModified} /></div>` directly between `</section>` (bluf) and `<section class="prose">`.
  - `2026-east-county-barbershop-cost-guide.astro`: identical pattern — `import LastUpdated`, `import mtimes`, `const dateModified = mtimes['site/src/pages/2026-east-county-barbershop-cost-guide.astro']`, `<div class="wrap"><LastUpdated isoDate={dateModified} /></div>` between BLUF and prose.
  - Both pages: `// TODO Plan 06` markers fully removed. The existing top-of-page `UPDATED MAY 2026` kicker (`.date-stamp` element) was intentionally preserved per plan instruction.
- **Build success after each task:**
  - `npm run build` exits 0; 17 pages built; build duration 0.6–2.0s across the three builds.
  - `dist/east-county-traditional-barbershop/index.html` contains `"dateModified":"2026-05-10T16:11:22-07:00"` AND `Last updated: May 10, 2026` — verified by grep.
  - `dist/2026-east-county-barbershop-cost-guide/index.html` contains `"dateModified":"2026-05-10T16:11:22-07:00"` AND `Last updated: May 10, 2026` — verified by grep.
  - Neither built page contains the placeholder string `"dateModified":"2026-05-10T00:00:00-07:00"` — confirmed absent.
- **`bash audit.sh` 32 passed / 0 failed / 0 skipped** — no Phase 3/4/5 regression.

## Operator Action Required

**Before Phase 6 deploy:** In Vercel project settings → Environment Variables, set `VERCEL_DEEP_CLONE=1` (Preview + Production scopes both) so `git log` returns full history during Vercel builds.

Without this, Vercel uses a shallow clone (default depth ~1 commit) and `git log -1 --format=%cI -- <page>` returns an empty string. The script then falls back to filesystem mtime — which on Vercel is the build-time mtime, not the real edit date — and `Article.dateModified` will show "today" on every deploy regardless of whether the page changed. The fallback path warns to stderr (visible in Vercel build logs as `WARN: <page> — git mtime unavailable; falling back to fs mtime ...`) so this misconfiguration is observable.

Setting `VERCEL_DEEP_CLONE=1` causes Vercel to run `git fetch --unshallow` before the build, restoring full history. Tradeoff: adds 5–30 seconds to clone time depending on repo size. For Joe's Barbershop scale (a few hundred commits) the overhead is negligible.

Reference: RESEARCH Pitfall 3.

## Task Commits

Each task was committed atomically:

1. **Task 1: Replace generate-mtimes stub with real git log impl + prebuild hook** — `0d5984d` (feat)
2. **Task 2: Add LastUpdated component + wire real git-mtime dateModified on Article pages** — `ec84dcf` (feat)

## Files Created/Modified

**Created (1 source + 1 summary):**

- `site/src/components/LastUpdated.astro` (32 lines) — `Props { isoDate: string }` interface, `toLocaleDateString('en-US', { year, month: 'long', day })` formatting, scoped `<style>` block with values copied from `.date-stamp`.
- `.planning/phases/05-aeo-performance-meta/05-06-SUMMARY.md` (this file).

**Modified (4):**

- `site/scripts/generate-mtimes.mjs` (27 → 60 lines net): stub body replaced with real impl. Imports `execSync`, `writeFileSync`, `statSync`, `mkdirSync`. Hardcoded `PAGES` array (the two Article page paths). Three-tier fallback chain (git log → fs stat → build time) with stderr warnings on each fallback. STUB marker comment removed.
- `site/package.json` (+1 line): added `"prebuild": "node scripts/generate-mtimes.mjs"` between `dev` and `build`.
- `site/src/pages/east-county-traditional-barbershop.astro` (+5 / -2 lines): added 2 imports (`LastUpdated`, `mtimes`); replaced placeholder `dateModified` literal with `mtimes[<page>]` lookup; removed `// TODO Plan 06` comment; inserted `<div class="wrap"><LastUpdated isoDate={dateModified} /></div>` between BLUF and prose sections.
- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` (+5 / -2 lines): same pattern as niche-landing.

**Generated (not committed):**

- `site/src/data/git-mtimes.json` (4 lines) — 2 entries, regenerated every prebuild. Listed in `site/.gitignore` line 7.

## Decisions Made

- **LastUpdated.astro placement at `site/src/components/LastUpdated.astro`** (not under `/schema/`). Rationale: this is a visible DOM component that renders `<p>` text with scoped CSS — not a JSON-LD emitter. Keeping schema components segregated under `/schema/` preserves the existing convention from Plan 03. Mixing visible-DOM components with JSON-LD emitters would muddy the contract.
- **Wrap `<LastUpdated />` in `<div class="wrap">`** on both pages. Every inner-page section on both Article pages uses a `<div class="wrap">` container for max-width + horizontal padding. Inserting `<LastUpdated />` bare would have made the date line span full viewport width and break the visual rhythm. Wrapping matches the existing pattern with zero new CSS.
- **Kept the existing top-of-page `UPDATED MAY 2026` kicker untouched.** Plan instruction was explicit: "If the existing page already has an `UPDATED MAY 2026` kicker line near the top (the original `.date-stamp` element from Phase 3), KEEP it as-is — per D-11 the new line is between BLUF and prose, not replacing the existing top-of-page stamp. The two date stamps may coexist temporarily; Phase 7 may consolidate." Followed verbatim. Both stamps are visible in the built HTML; the top kicker reads `UPDATED MAY 2026` (hand-maintained string), the new line between BLUF and prose reads `Last updated: May 10, 2026` (real git mtime). When Phase 7 reviews, the consolidation question is: drop the hand-maintained kicker since LastUpdated supersedes it, or keep both for visual hierarchy.
- **JSON import via `import mtimes from '../data/git-mtimes.json'`.** Astro/Vite natively resolves JSON imports at build time. Type is `Record<string, string>` (implicit). Build-time-only — no runtime fetch, no bundle bloat. Tradeoff: changing the manifest does not hot-reload during `astro dev` unless dev server is restarted; acceptable because the manifest only changes when a page file is committed.
- **Fallback chain: git log → fs stat → build time.** The three-tier fallback covers the realistic failure modes: (a) Vercel shallow clone with no git history — falls back to fs mtime, which still represents "when the file was checked out", a defensible second-best; (b) page file deleted mid-build — falls back to current time so the build doesn't abort. Every fallback writes to stderr so the operator can see in build logs whether they're getting real git data or fallback data.
- **No new npm dependency.** Used `node:child_process.execSync` for git invocation and `node:fs.statSync` for filesystem fallback. Both are stdlib. One fewer dep to audit, no version pinning risk.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Re-materialized worktree's missing `site/node_modules/` tree**
- **Found during:** Pre-Task-1 dependency check (`test -d site/node_modules` returned negative; the entire directory was missing in this worktree, same situation Plans 02–05 each documented).
- **Issue:** `npm run build` would fail with module-resolution errors on Astro core packages without `node_modules`. Same root cause as prior plans: worktree branches the merge of prior plans, and `node_modules/` is gitignored.
- **Fix:** Ran `cd site && npm install --no-fund --no-audit` non-interactively. 571 packages materialized from the locked tree. No changes to `package.json` or `package-lock.json`.
- **Files modified:** None tracked in git. Only `site/node_modules/` (gitignored).
- **Verification:** `npm run build` exited 0 on the baseline build and on both task builds.
- **Committed in:** Not committed — no tracked files changed.

---

**Total deviations:** 1 auto-fixed (1 blocking — worktree-state-recovery).
**Impact on plan:** Zero scope creep. Same recovery step that Plans 02–05 documented.

## Issues Encountered

- **`npm install` reported 8 vulnerabilities** (5 moderate, 3 high) — pre-existing transitive issue from the `lighthouse` toolchain pulled in by Plan 01. Documented in Plan 01 summary and accepted under T-05-01. Not a Plan 06 regression.
- **`Astro emits 8 informational hints** as the Plan 04/05 baseline (7 `is:inline` on schema components, 1 pre-existing `[service].astro` unused-import hint). No new hints introduced. The new `LastUpdated.astro` component does not emit any hint — its `<script>`-free body and scoped `<style>` keep it under Astro's lint thresholds.
- **The `mtimes` JSON import generates a TypeScript hint** about implicit `any` for `mtimes[<key>]` access, since `astro check` does not infer JSON literal types. Acceptable: the lookup is build-time, the key is a literal string, and a wrong key would surface as `undefined` in the manifest at build time (failing the dateModified non-empty assertion downstream). Plan 07's validator will catch any drift.

## Known Stubs

None remaining for Plan 06's scope. Both `TODO Plan 06` markers from Plan 05 are removed and verified gone (`grep -c 'TODO Plan 06' src/pages/east-county-traditional-barbershop.astro` = 0; same for cost guide).

The parallel-FAQ-array `TODO Phase 7: consolidate DOM ↔ schema array duplication` markers from Plan 05 remain — they are not in Plan 06's scope (consolidation work for a future shared `<FAQList items={...}>` component).

## Threat Flags

None new. Plan's threat model fully addressed:

- **T-05-17 (Tampering — git log output injection via malicious filename):** Accepted per plan. Hardcoded `PAGES` array in `generate-mtimes.mjs` — no user input, no dynamic file discovery. Filenames are string literals.
- **T-05-18 (Repudiation — dateModified inflated to look fresh):** Accepted per plan. dateModified flows from git history; rewriting it requires rewriting commit history (visible in `git log` to anyone reviewing the repo).
- **T-05-19 (Information Disclosure — build env fallback to current time on shallow clone):** Mitigated as planned. Operator note recorded in this summary; fallback path warns to stderr (observable in Vercel build logs); `VERCEL_DEEP_CLONE=1` is the documented remediation.

## User Setup Required

**Before Phase 6 deploy (Vercel):** Set `VERCEL_DEEP_CLONE=1` environment variable in Vercel project settings (Preview + Production). See "Operator Action Required" section above for full rationale.

No other setup. No new npm dependency, no new external service, no new secret.

## Next Phase Readiness

Wave 6 (Plan 07 — schema validator) can now:

- Assert that `Article.dateModified` on both Article pages is a real ISO 8601 timestamp matching `/^\d{4}-\d{2}-\d{2}T/`. The placeholder string `'2026-05-10T00:00:00-07:00'` is no longer present anywhere in source or dist.
- Assert that the visible `Last updated:` line is present in dist HTML for both Article pages (substring grep).
- Optionally assert that the visible date and the JSON-LD dateModified represent the same calendar date (sync-by-construction guarantee).
- Assert that `site/src/data/git-mtimes.json` exists at validator runtime (will, since `validate-schema.mjs` runs post-build and the prebuild hook regenerates the manifest).

Baseline maintained: `npm run build` exits 0, 17 pages built; `audit.sh` 32/32 passed.

## Self-Check: PASSED

Verified all claimed artifacts and commits exist:

- `site/scripts/generate-mtimes.mjs` — FOUND, no STUB marker, imports execSync, 60 lines
- `site/package.json` — FOUND, `"prebuild": "node scripts/generate-mtimes.mjs"` present in scripts block
- `site/src/components/LastUpdated.astro` — FOUND, `Props { isoDate: string }` interface present, `toLocaleDateString` call present
- `site/src/data/git-mtimes.json` — FOUND, 2 entries, both ISO 8601 (gitignored — `git ls-files site/src/data/git-mtimes.json` returns empty as expected)
- `site/src/pages/east-county-traditional-barbershop.astro` — FOUND, `import mtimes`, `import LastUpdated`, `<LastUpdated isoDate=` present, zero `TODO Plan 06` markers
- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` — FOUND, same wiring, zero `TODO Plan 06` markers
- Commit `0d5984d` (Task 1) — FOUND in `git log --oneline`
- Commit `ec84dcf` (Task 2) — FOUND in `git log --oneline`
- `dist/east-county-traditional-barbershop/index.html` contains `"dateModified":"2026-05-10T...` (real ISO) — verified
- `dist/east-county-traditional-barbershop/index.html` contains `Last updated: May 10, 2026` — verified
- `dist/east-county-traditional-barbershop/index.html` does NOT contain `"dateModified":"2026-05-10T00:00:00-07:00"` placeholder — verified
- `dist/2026-east-county-barbershop-cost-guide/index.html` contains `"dateModified":"2026-05-10T...` (real ISO) — verified
- `dist/2026-east-county-barbershop-cost-guide/index.html` contains `Last updated: May 10, 2026` — verified
- `dist/2026-east-county-barbershop-cost-guide/index.html` does NOT contain placeholder — verified
- Build log shows `> site@0.0.1 prebuild` running before `> site@0.0.1 build` — verified
- `npm run build` exits 0; 17 pages built
- `bash audit.sh` exits 0: 32 passed / 0 failed / 0 skipped

---
*Phase: 05-aeo-performance-meta*
*Plan: 06*
*Completed: 2026-05-10*
