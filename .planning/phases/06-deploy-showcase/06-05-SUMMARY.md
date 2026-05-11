---
phase: 06-deploy-showcase
plan: 05
type: summary
status: complete
completed_date: 2026-05-11
---

# Plan 06-05 Summary — Pre-deploy setup gate (env vars + .env.example doc)

## What landed

**Task 1 — site/.env.example documented (auto):**
Extended `site/.env.example` from 5 lines to 23 lines. Preserved the existing `PUBLIC_CLARITY_PROJECT_ID` block. Appended:
- `PUBLIC_SHOWCASE_MODE=true` with comment block explaining the noindex semantics, default-to-true behavior, and the Vercel-flip path to go-live
- `VERCEL_DEEP_CLONE=1` documented as a **Vercel-platform-only** env var (NOT consumed by `import.meta.env`), with rationale for why it's required (full git history → real `dateModified` values in Article schema)

Commit: `a861e84` — `docs(06-05): document PUBLIC_SHOWCASE_MODE + VERCEL_DEEP_CLONE in env.example (D-04)`

**Task 2 — Vercel env-var setup (human action with deviations):**

Three env vars set on production scope, captured to `vercel-env-snapshot.txt`:
- `VERCEL_DEEP_CLONE=1` (Production)
- `PUBLIC_CLARITY_PROJECT_ID=wp9knfqqhv` (Production)
- `PUBLIC_SHOWCASE_MODE=true` (Production)

Microsoft Clarity project `Joe's Barbershop` provisioned (project ID `wp9knfqqhv`).

Commit: `594071b` — `docs(06-05): capture vercel-env-snapshot after manual env-var setup (D-04)`

## Deviations from plan

### Deviation 1 — Vercel scope migration (work account)

**What changed:** Vercel project scope moved from personal (`darrell-tangs-projects/site`, `prj_K0vpi4oJOuSHTGJnYZhP5RQQwN8N`) to work Hobby account (`darrell-tang-consulting-s-projects/joes-barbershop`, signed in as `darrelltang-5201` via `darrell.tang@nexarapacific.com`).

**Why:** Mid-plan user decision to keep work-context deploys separated from personal Vercel scope. Even though Joe's Barbershop is a learning sandbox today, the AEO-Hub Site productization seed warrants clean account boundaries before any indexable go-live. Decision documented in `~/.claude/projects/-Users-darrelltang-dtconsulting-joesbarbershop/memory/project_vercel_scope.md`.

**Impact on downstream phases:**
- Plan 06-07 deploy targets the new `joes-barbershop` project (not the old `site` project)
- Phase 1's `01-04-SUMMARY.md` references to the personal-scope project are historical — do not consult them for deploy ops
- The `site-psi-liard.vercel.app` stable alias from the personal project will not be the preview URL; Wave 3 will generate a new one

### Deviation 2 — Production-scope env vars only (no Preview scope)

**What changed:** Plan 06-05 acceptance criteria require `VERCEL_DEEP_CLONE` and `PUBLIC_SHOWCASE_MODE` on both Preview AND Production scopes. Only Production was set.

**Why:** The new `joes-barbershop` project has no GitHub repo connected. `vercel env add <NAME> preview` requires git-branch context. Without a connected repo, the Vercel API rejects preview-scope writes with `git_branch_required`. CLI deploys via `vercel deploy` (Plan 06-07) operate without git context and inherit **Production-scope** env vars at build time, so the showcase preview deploy works correctly with Production-only setup. No functional impact for v1.

**Future migration:** When the project later gets a GitHub repo (`gh repo create joes-barbershop --private` under `darrelldoesdevops` or another work org → push → `vercel git connect`), backfill Preview scope by re-adding the same three vars with `--value` flag specifying the production values. ~5 minutes.

## What this unblocks

- **Plan 06-06 (already complete, Wave 2)** — noindex flag wired via `PUBLIC_SHOWCASE_MODE`; build-time gating ready
- **Plan 06-07 (Wave 3)** — `vercel deploy` from `site/` will use the work-account project, pick up Production env vars, generate Article `dateModified` from real git history, and emit noindex on every page

## Acceptance criteria status

- [x] `gh auth status` — verified DarrellTang (personal GH still active for repo ops; Vercel uses work-email account independently)
- [x] `vercel whoami` returns work-account handle (`darrelltang-5201`, not `darrelltang`)
- [x] Microsoft Clarity project `Joe's Barbershop` exists at clarity.microsoft.com with ID `wp9knfqqhv`
- [x] `.planning/phases/06-deploy-showcase/vercel-env-snapshot.txt` exists and contains all 3 var names
- [x] `VERCEL_DEEP_CLONE` listed under Production
- [x] `PUBLIC_CLARITY_PROJECT_ID` listed under Production
- [x] `PUBLIC_SHOWCASE_MODE` listed under Production
- [x] Two atomic commits landed (Task 1 + Task 2)
- [~] `VERCEL_DEEP_CLONE` Preview scope — DEFERRED (deviation 2)
- [~] `PUBLIC_SHOWCASE_MODE` Preview scope — DEFERRED (deviation 2)
