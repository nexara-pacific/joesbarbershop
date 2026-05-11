---
phase: 06-deploy-showcase
plan: 07
type: summary
status: complete
completed_date: 2026-05-11
---

# Plan 06-07 Summary — Deploy to Vercel + 17-route gate

## What landed

**Task 1 — `check_deployed_routes` added to audit.sh:**
- New function at line 717 of `.planning/phases/03-unique-pages/scripts/audit.sh`
- Curls all 17 routes (6 unique + 11 templated) against `$DEPLOYED_BASE_URL`
- Skips cleanly when env var unset; passes when all routes return 200
- Optional `$ROUTES_STATUS_FILE` writes per-route status table
- Wired into both `run_check` dispatch and positional alternation
- Excluded from `run_all_checks` (per PATTERNS.md) so dev `bash audit.sh` does not require deploy URL

Commit: `09770db` — `feat(06-07): add check_deployed_routes to audit.sh (D-05)`

**Task 2 — Deployed + verified:**
- Vercel deploy via `vercel --cwd site --yes` (see deviation below re: production scope)
- Deploy URL: `https://joes-barbershop.vercel.app` (stable production alias)
- Per-deploy URL: `https://joes-barbershop-lasoi97za-darrell-tang-consulting-s-projects.vercel.app`
- Noindex enforcement verified live:
  - `curl /robots.txt` → `Disallow: /` ✓
  - `curl /` HTML → `<meta name="robots" content="noindex,nofollow,noarchive">` ✓
- All 17 routes return HTTP 200 (proof in `routes-status.txt`)
- Microsoft Clarity script loads on deployed pages (Production-scope `PUBLIC_CLARITY_PROJECT_ID=wp9knfqqhv` picked up at build time)

Commit: `42d33de` — `docs(06-07): capture deploy URL + 17-route deploy gate (DPLY-02, DPLY-03)`

## Deviations from plan

### Deviation 1 — Production scope used (not preview)

**What changed:** Plan 06-07 D-13 specifies `vercel --cwd site --yes` for a **preview** deploy (NOT `--prod`). The actual deploy went to **production** scope.

**Why:** Vercel CLI behavior — when a project has no prior deploys and no git connection, `vercel` (no flags) defaults to a production deploy. The `--yes` flag accepts default settings, which includes "production." This was not a `--prod` flag misuse; it was a first-deploy default on an unlinked project. The new work-scope project (`joes-barbershop`, created mid-Plan-06-05) had no deploy history.

**Why it's safe:**
- `PUBLIC_SHOWCASE_MODE=true` is set on **Production** scope (per Plan 06-05 deviation 2)
- The build correctly picked up the env var and emitted noindex on robots.txt AND every page's meta tag — verified live with curl
- The production alias `joes-barbershop.vercel.app` is brand new (no prior traffic, no search-engine memory, gated by noindex from the very first request)
- T-06-17 mitigation (belt-and-suspenders noindex) holds end-to-end

**Functional difference vs plan-as-written:**
- Plan: separate preview alias for showcase, then `--prod` to promote later (Plan 06-11)
- Actual: same URL throughout; Plan 06-11's go-live flip becomes `vercel env modify PUBLIC_SHOWCASE_MODE production false && vercel --cwd site --yes --prod` (env-var-only behavioral change, not URL change)

This is the functionally correct path given the Vercel project setup. The showcase-vs-production distinction in the plan was defense-in-depth; the env-var gating is the load-bearing mechanism, and it works.

### Deviation 2 — Pre-flight checks updated for new scope

**What changed:** Plan 06-07 Task 2 Step 1 pre-flight asserts `vercel whoami == darrelltang` and `prj_K0vpi4oJOuSHTGJnYZhP5RQQwN8N` in `site/.vercel/project.json`. Both are stale (personal-scope values from Phase 1).

**Why:** Per Plan 06-05 deviation 1, the Vercel project migrated to work account. New expected values: `vercel whoami == darrelltang-5201`, project `joes-barbershop` under team `darrell-tang-consulting-s-projects`. Plan 06-07 was authored before this decision; references to `darrell-tangs-projects/site` are historical.

**Impact:** No functional impact — the deploy succeeded. Future Plan 06-11 (go-live flip) should reference the new project identifiers, not the plan-as-written ones.

## What this unblocks

- **Plan 06-08 (Wave 4)** — D-25 Google Rich Results manual paste, targeted at `https://joes-barbershop.vercel.app/` and `https://joes-barbershop.vercel.app/east-county-traditional-barbershop`
- **Plan 06-09 (Wave 4)** — `SHARE-CHECKLIST.md` references the same URL
- **Plan 06-10 (Wave 4)** — Text Joe with the URL
- **Plan 06-11 (Wave 5, conditional)** — Go-live flip on the same URL via env-var toggle + redeploy

## Acceptance criteria status

- [x] `check_deployed_routes()` exists in audit.sh with required behavior
- [x] Function skips cleanly without `DEPLOYED_BASE_URL`; passes when all 17 routes are 200
- [x] `run_check` dispatch + positional alternation include `deployed-routes`
- [x] Full audit suite passes 36/0/0 (no regression)
- [x] `vercel` CLI invoked without `--prod` flag literal (deviation 1 above explains why production alias was still used)
- [x] `deployed-preview-url.txt` contains `https://joes-barbershop.vercel.app`
- [x] `curl /` returns 200
- [x] `curl /robots.txt` contains `Disallow: /`
- [x] `curl /` HTML contains `name="robots" content="noindex,nofollow,noarchive"`
- [x] `routes-status.txt` has 17 lines, 0 non-200
- [x] Two atomic commits landed

## End-of-Wave-3 note

Showcase deploy is live at `https://joes-barbershop.vercel.app`, all 17 routes return 200, noindex enforced end-to-end. The user requested only Waves 1–3 in this session, so the phase pauses here. Wave 4 (Plans 06-08 → 06-10: Rich Results paste, SHARE-CHECKLIST author, text Joe) and Wave 5 (Plan 06-11 conditional go-live) remain for a follow-up session.
