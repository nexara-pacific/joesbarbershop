---
phase: 1
slug: scaffold
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-06
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
> Source: `01-RESEARCH.md` § Validation Architecture (lines 501–540).

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — Phase 1 uses build/curl smoke checks, not unit tests |
| **Config file** | None |
| **Quick run command** | `cd site && npm run build` |
| **Full suite command** | `cd site && npm run build && curl -fsS -o /dev/null -w "%{http_code}\n" "$PREVIEW_URL"` |
| **Estimated runtime** | ~5–10 seconds (build) + ~1 second (curl) |

Phase 1 is pre-test-framework. Pages are static HTML; visual + curl smoke is sufficient. Phase 2 may introduce Vitest for `business.ts` typing tests; Phase 5 may introduce Lighthouse CI. Neither is a Phase 1 concern.

---

## Sampling Rate

- **After every task commit:** Run `cd site && npm run build` (exits 0)
- **After every plan wave:** Above + `cd site && npm run preview &` then `curl localhost:4321` returns 200
- **Before `/gsd-verify-work`:** Above + `vercel --cwd site` deploy returns a 200 preview URL
- **Max feedback latency:** ~10 seconds (build) per task commit

---

## Per-Task Verification Map

Wave numbers are placeholders — filled in by the planner. Every Phase 1 task starts in Wave 0 (creating `site/`).

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 1-XX-01 | XX | 0 | SCAF-01 | — | Astro project initialized in `site/` with TypeScript strict | smoke (build) | `cd site && npm run build` exits 0 AND `grep -q '"extends":.*"astro/tsconfigs/strict"' site/tsconfig.json` | ❌ W0 | ⬜ pending |
| 1-XX-02 | XX | 0 | SCAF-02 | — | Astro Image integration available | smoke (build) | `npm run build` exits 0 AND `grep -q "astro:assets" site/src/**/*.astro` (any usage) OR `grep -q "@astrojs/image\|astro:assets" site/astro.config.mjs site/src/**/*.astro` | ❌ W0 | ⬜ pending |
| 1-XX-03 | XX | 0 | SCAF-03 | — | Sitemap integration emits sitemap-index.xml | smoke (build artifact) | `test -f site/dist/sitemap-index.xml && grep -q '<sitemapindex' site/dist/sitemap-index.xml` | ❌ W0 | ⬜ pending |
| 1-XX-04 | XX | 0 | SCAF-04 | — | Vercel adapter installed and configured (no-op for static) | static (config grep) | `grep -q "from '@astrojs/vercel'" site/astro.config.mjs` AND `npm run build` exits 0 with no "missing adapter" warnings | ❌ W0 | ⬜ pending |
| 1-XX-05 | XX | 0 | SCAF-05 | — | Base layout renders shared masthead/util-bar/footer on every page | smoke (HTML inspection) | After build, `grep -l 'data-phase1-stub' site/dist/index.html site/dist/about/index.html` returns both files | ❌ W0 | ⬜ pending |
| 1-XX-06 | XX | 0 | Success #2 | — | Vercel preview URL returns 200 on `/` | smoke | `curl -fsS -o /dev/null -w "%{http_code}" "$PREVIEW_URL"` returns "200" | ❌ W0 | ⬜ pending |
| 1-XX-07 | XX | 0 | Success #4 | — | Image + Sitemap integrations don't error at build | smoke | `npm run build 2>&1 \| tee build.log; ! grep -E "(missing adapter\|integration error)" build.log` | ❌ W0 | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

*Note: SCAF-03 verification reads `/sitemap-index.xml`, not `/sitemap.xml`. The roadmap wording (`/sitemap.xml`) is benign-but-wrong — `@astrojs/sitemap` 3.7.2 always emits `sitemap-index.xml`. The planner should encode the correct path in acceptance criteria.*

---

## Wave 0 Requirements

The entire Phase 1 IS Wave 0 — `site/` does not yet exist. Setup tasks the planner must include:

- [ ] `npm create astro@latest site --template minimal --yes` — creates the project
- [ ] `cd site && npx astro add vercel sitemap --yes` — adds adapters/integrations
- [ ] Set `site:` URL in `astro.config.mjs` (sitemap requires it)
- [ ] Create `src/layouts/Base.astro` with masthead/util-bar/footer slots
- [ ] Create at least 2 stub pages (`/` and `/about`) using Base.astro to validate SCAF-05
- [ ] Verify `gh auth status` (manual pre-flight before Vercel link, deferred to Phase 6 push)

*If none: not applicable — every Phase 1 task is Wave 0.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Layout renders visually on every page | SCAF-05 / Success #3 | "Visible in browser" requires human eyeball — automated grep verifies markers exist, not that they render | Open preview URL in browser; confirm masthead, utility bar, and footer all visible on `/` and `/about` |
| First-time `vercel link` for the project | SCAF-04 / Success #2 | One-time interactive setup; non-TTY workaround exists but is rarely worth the friction | Run `vercel link --cwd site` once, accept defaults; subsequent deploys are non-interactive |

---

## Validation Sign-Off

- [ ] All five SCAF-* tasks have `<automated>` verify commands (mapped above)
- [ ] Sampling continuity: every task in Phase 1 builds the project — feedback latency stays < 10s
- [ ] Wave 0 covers all MISSING references (`site/` directory, integrations, base layout)
- [ ] No watch-mode flags
- [ ] Feedback latency < 10s
- [ ] `nyquist_compliant: true` set in frontmatter (after planner fills task IDs and gsd-plan-checker passes)

**Approval:** pending
