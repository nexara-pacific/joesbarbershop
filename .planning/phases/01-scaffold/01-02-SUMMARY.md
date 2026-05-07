---
phase: 01-scaffold
plan: 02
subsystem: infra
tags: [astro, vercel, sitemap, image-optimization, sharp]

requires:
  - phase: 01-scaffold/01-01
    provides: "Astro 6.3.0 project scaffold in site/ with TypeScript strict mode and working npm run build"

provides:
  - "@astrojs/vercel 10.0.6 installed and configured as adapter in astro.config.mjs (unified import, no-op for static)"
  - "@astrojs/sitemap 3.7.2 installed and registered; emits dist/sitemap-index.xml at build time"
  - "site: 'https://joesbarbershop.vercel.app' set in astro.config.mjs (required by sitemap, placeholder for Phase 6)"
  - "image.layout: 'constrained' and responsiveStyles: true set; enables auto-srcset + sizes for Astro Image"
  - "Build still exits 0 and now emits dist/sitemap-index.xml with valid <sitemapindex> XML"

affects: [01-03, 01-04, 05]

tech-stack:
  added:
    - "@astrojs/vercel@10.0.6 (Vercel adapter, static no-op, unlocks Phase 5 Web Analytics + Image Optimization)"
    - "@astrojs/sitemap@3.7.2 (build-time sitemap generation)"
  patterns:
    - "Vercel adapter uses unified import 'from @astrojs/vercel' (NOT /static or /serverless — those were removed in v8+)"
    - "Sitemap always emits sitemap-index.xml, never sitemap.xml — verification and robots.txt must use sitemap-index.xml"
    - "image.layout: 'constrained' set globally in config — all <Image /> components get auto-srcset without per-component config"
    - "No output: field in astro.config.mjs — static is default; setting output: 'server' would flip everything to SSR (Pitfall 6)"

key-files:
  created: []
  modified:
    - site/astro.config.mjs
    - site/package.json
    - site/package-lock.json

key-decisions:
  - "@astrojs/vercel installed as no-op for Phase 1 static build — satisfies SCAF-04 literal requirement and unblocks Phase 5 (Web Analytics, Vercel-edge image optimization) with zero Phase 1 cost"
  - "site: URL set to https://joesbarbershop.vercel.app as placeholder — Phase 6 updates to actual preview URL before showcase"
  - "No output: field added — static is Astro 6 default; adding it would be redundant; output: 'server' would break AEO static contract"
  - "responsiveStyles: true added alongside layout: 'constrained' — matches research Pattern 3 exactly"

patterns-established:
  - "Vercel adapter: import vercel from '@astrojs/vercel' (unified path) — all future plan references use this pattern"
  - "Sitemap verification: check dist/sitemap-index.xml, not dist/sitemap.xml (that file never exists)"

requirements-completed: [SCAF-02, SCAF-03, SCAF-04]

duration: 8min
completed: 2026-05-07
---

# Phase 1 Plan 02: Vercel Adapter, Sitemap, and Image Config Summary

**@astrojs/vercel 10.0.6 and @astrojs/sitemap 3.7.2 wired in astro.config.mjs; image.layout: 'constrained' enables auto-srcset; build exits 0 and emits sitemap-index.xml**

## Performance

- **Duration:** ~8 min
- **Started:** 2026-05-07T15:20:00Z
- **Completed:** 2026-05-07T15:28:00Z
- **Tasks:** 1
- **Files modified:** 3

## Accomplishments

- `@astrojs/vercel@10.0.6` and `@astrojs/sitemap@3.7.2` installed and wired via `astro add vercel sitemap --yes`
- `astro.config.mjs` updated to match research Pattern 3 exactly: `site:` URL, `integrations: [sitemap()]`, `adapter: vercel()`, `image: { layout: 'constrained', responsiveStyles: true }`
- `npm run build` exits 0 in ~429ms; `dist/sitemap-index.xml` emitted with valid `<sitemapindex>` XML referencing `https://joesbarbershop.vercel.app/sitemap-0.xml`
- Build output confirms static mode: adapter copies to `.vercel/output/static`, no `.vercel/output/functions/` directory (SSR not activated)

## Task Commits

1. **Task 1: Install and wire @astrojs/vercel and @astrojs/sitemap** - `0a37c14` (feat)

**Plan metadata:** _(docs commit follows)_

## Files Created/Modified

- `site/astro.config.mjs` - Vercel adapter, Sitemap integration, site: URL, image.layout config
- `site/package.json` - Added @astrojs/vercel@^10.0.6 and @astrojs/sitemap@^3.7.2 dependencies
- `site/package-lock.json` - Locked dependency tree with vercel and sitemap packages

## Package Versions Installed

```
site@0.0.1
├── @astrojs/sitemap@3.7.2
└── @astrojs/vercel@10.0.6
```

Both match research expectations exactly (research verified 10.0.6 and 3.7.2 against npm registry 2026-05-06).

## astro add Modifications Requiring Revert

`astro add` generated the config with:
- `adapter: vercel()` before `integrations: [sitemap()]`
- No `site:` URL (required by sitemap — Pitfall 2 in research)
- No `image:` block

These were corrected by writing the full config from research Pattern 3. No other parts of the file were changed by `astro add` that needed reverting (it cleanly replaced the empty `defineConfig({})` with the integration imports and calls).

## Build Log Excerpt (last 5 lines)

```
08:23:57   ├─ /index.html (+4ms)
08:23:57 ✓ Completed in 10ms.
08:23:57 [build] ✓ Completed in 331ms.
08:23:57 [@astrojs/sitemap] `sitemap-index.xml` created at `dist`
08:23:57 [@astrojs/vercel] Copying static files to .vercel/output/static
08:23:57 [build] 1 page(s) built in 429ms
08:23:57 [build] Complete!
```

The vercel adapter copied to `static`, not `functions` — confirms static-only build mode (Pitfall 6 averted).

## output: Field Confirmation

`output:` is NOT present in `site/astro.config.mjs`. Static is Astro 6 default. Verified: no `output: 'static'` (redundant), no `output: 'server'` (would break AEO static contract).

## Decisions Made

- `@astrojs/vercel` installed even though Vercel auto-detects static Astro with zero config — satisfies SCAF-04 literal text and unblocks Phase 5 features (Web Analytics, Vercel-edge image optimization) at no Phase 1 cost
- `site:` set to `https://joesbarbershop.vercel.app` as best-guess placeholder — Vercel typically slugs the project name; Phase 6 will update to actual preview URL after first deploy
- `responsiveStyles: true` added alongside `layout: 'constrained'` — matches research Pattern 3 verbatim

## Deviations from Plan

None — plan executed exactly as written. `astro add` output required minor correction (adding `site:` and `image:` block as expected per plan's `<action>` step 2), but this was explicitly anticipated and scripted in the plan.

## Issues Encountered

**`node_modules` not present in worktree** — The worktree was created from a commit that predates `npm install`, so `node_modules/` didn't exist. Resolved by running `npm install` before `node_modules/.bin/astro add`. This is expected worktree behavior (node_modules is gitignored and never committed). No impact on output.

**`npx astro add` version conflict** — `npx astro add` pulled a cached astro from npm's npx cache (different version) instead of the locally installed `astro@6.3.0`, causing a "Cannot find module 'astro/config'" error. Resolved by running `node_modules/.bin/astro add` after `npm install`. Standard worktree setup pattern.

## User Setup Required

None — no external service configuration required for this plan.

## Next Phase Readiness

- `site/astro.config.mjs` is fully configured for Phase 1 static build
- Plan 03 (base layout) can immediately `import { Image } from 'astro:assets'` and use `<Image />` with auto-srcset behavior
- Plan 04 (Vercel deploy) can run `vercel --cwd site` — the adapter is already wired and will handle static file output
- No blockers

## Known Stubs

None — this plan only modifies config files. No UI stubs introduced.

---
*Phase: 01-scaffold*
*Completed: 2026-05-07*
