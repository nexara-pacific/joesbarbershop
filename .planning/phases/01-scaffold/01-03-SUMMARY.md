---
phase: 01-scaffold
plan: 03
subsystem: ui-shell
tags: [astro, layout, components, aeo, scaf-05]

requires:
  - phase: 01-scaffold/01-01
    provides: "Astro 6.3.0 project scaffold in site/"
  - phase: 01-scaffold/01-02
    provides: "@astrojs/vercel and @astrojs/sitemap wired in astro.config.mjs"

provides:
  - "site/src/layouts/Base.astro: shared HTML shell with UtilBar/Masthead/main-slot/Footer ordering"
  - "site/src/components/UtilBar.astro: stub with data-phase1-stub='util-bar'"
  - "site/src/components/Masthead.astro: stub with data-phase1-stub='masthead'"
  - "site/src/components/Footer.astro: stub with data-phase1-stub='footer'"
  - "site/src/pages/index.astro: home page using Base.astro layout"
  - "site/src/pages/about.astro: second page proving layout reuse"
  - "Both dist/index.html and dist/about/index.html contain data-phase1-stub (SCAF-05 grep gate satisfied)"

affects: [01-04, 02]

tech-stack:
  added: []
  patterns:
    - "Base.astro layout pattern: pages import Base and wrap content in <Base title='...'>"
    - "Stub components use data-phase1-stub attribute for phase-boundary grep verification"
    - "Section ordering in Base.astro body: UtilBar → Masthead → main → Footer (load-bearing for Phase 2 port)"
    - "Zero client: directives — all content in DOM without JS execution (AEO constraint)"

key-files:
  created:
    - site/src/layouts/Base.astro
    - site/src/components/UtilBar.astro
    - site/src/components/Masthead.astro
    - site/src/components/Footer.astro
    - site/src/pages/about.astro
  modified:
    - site/src/pages/index.astro

key-decisions:
  - "Section ordering UtilBar → Masthead → main → Footer locked in Base.astro body — Phase 2 swaps component bodies without structural rewrite"
  - "data-phase1-stub attributes on outer element of each component — Phase 2 removes these when replacing stub bodies"
  - "No CSS or style blocks in any of the six files — Phase 2 (DESN-01..04) owns all design tokens and stylesheets"
  - "site/src/assets/photos/ confirmed as correct Astro Image target (not site/public/photos/) per Pitfall 5 in 01-RESEARCH.md"

requirements-completed: [SCAF-05]

duration: 5min
completed: 2026-05-07
---

# Phase 1 Plan 03: Base Layout + Stub Components Summary

**Base.astro layout with UtilBar/Masthead/Footer stub components (data-phase1-stub markers) and two pages (/  and /about); both built HTML files pass the SCAF-05 grep gate**

## Performance

- **Duration:** ~5 min
- **Started:** 2026-05-07
- **Completed:** 2026-05-07
- **Tasks:** 1
- **Files modified:** 6 (5 created, 1 overwritten)

## Accomplishments

- `site/src/layouts/Base.astro` created with correct section ordering and named `<slot name="head" />` for per-page head injection
- Three stub components created with `data-phase1-stub` markers on their outer elements
- `site/src/pages/index.astro` overwritten (replaces Astro default minimal-template page)
- `site/src/pages/about.astro` created — second page proves layout reuse
- `npm run build` exits 0 in ~421ms; emits 2 pages + sitemap-index.xml
- `grep -l 'data-phase1-stub' dist/index.html dist/about/index.html` lists both files — SCAF-05 satisfied
- Zero TypeScript warnings in strict mode

## Task Commits

1. **Task 1: Create Base.astro layout, three stub components, and two pages** - `e7ab377` (feat)

## Files Created/Modified

- `site/src/layouts/Base.astro` - Shared HTML shell; imports and renders UtilBar, Masthead, main+slot, Footer in that order
- `site/src/components/UtilBar.astro` - Stub div with data-phase1-stub="util-bar"
- `site/src/components/Masthead.astro` - Stub header with data-phase1-stub="masthead", nav links to / and /about
- `site/src/components/Footer.astro` - Stub footer with data-phase1-stub="footer"
- `site/src/pages/index.astro` - Home page: imports Base, renders placeholder h1
- `site/src/pages/about.astro` - About page: imports Base, renders placeholder h1

## Base.astro Body Section (confirmation of ordering)

```html
<body>
  <UtilBar />
  <Masthead />
  <main><slot /></main>
  <Footer />
</body>
```

Section order: util-bar → masthead → main → footer. This matches the OD-5 ordering Phase 2 will port; Phase 2's work is a CSS/content swap, not a structural rewrite.

## data-phase1-stub Marker Values

| Component | Marker value | Outer element |
|-----------|-------------|---------------|
| UtilBar.astro | `data-phase1-stub="util-bar"` | `<div class="util-bar">` |
| Masthead.astro | `data-phase1-stub="masthead"` | `<header class="masthead">` |
| Footer.astro | `data-phase1-stub="footer"` | `<footer class="footer">` |

Phase 2 removes these attributes when replacing stub bodies with OD-5 content.

## TypeScript Warnings

Zero — strict mode active (astro/tsconfigs/strict). Build output confirmed no warn/error lines.

## Note for Phase 2 Planner (DESN-04)

Correct image target directory is `site/src/assets/photos/`, NOT `site/public/photos/`. Per Pitfall 5 in 01-RESEARCH.md: Astro's `<Image />` component requires images to be in `src/` (processed by Vite) for AVIF/WebP conversion and srcset generation. Files in `public/` are copied verbatim without optimization. Phase 2 (DESN-04) should place the 6 existing photos at `site/src/assets/photos/` when wiring Astro Image components.

## Decisions Made

- Section ordering in Base.astro body locked as UtilBar → Masthead → main(slot) → Footer — matches OD-5 DOM structure
- No CSS or stylesheets in any file — Phase 2 owns all design tokens
- Named head slot (`<slot name="head" />`) added for per-page JSON-LD schema injection (Phase 3+)
- `site/src/assets/photos/` confirmed as correct target for Astro Image (not public/)

## Deviations from Plan

None — plan executed exactly as written. All six files created/overwritten with exact contents from the `<interfaces>` block. Build exits 0 with zero TypeScript warnings.

## Issues Encountered

`node_modules/` not present in worktree (gitignored). Resolved by running `npm install` before build — same pattern as Plan 02. No impact on output.

`rm -rf dist` blocked by bash hook (security policy). Build proceeded without clearing dist — Astro's build overwrites output files in place. No impact on verification.

## Known Stubs

| Stub | File | Reason |
|------|------|--------|
| `(Phase 2: util-bar — phone, hours, walk-ins welcome)` | site/src/components/UtilBar.astro | Intentional — Phase 2 (DESN-01) replaces with OD-5 util bar content |
| `(Phase 2: footer — NAP, social, hours)` | site/src/components/Footer.astro | Intentional — Phase 2 (DESN-04) replaces with OD-5 footer with NAP schema |
| `Joe's Barbershop — Phase 1 placeholder` | site/src/pages/index.astro | Intentional — Phase 2 (DESN-01) replaces with full OD-5 homepage |

All stubs are intentional phase boundaries. Plan 03's goal (SCAF-05: layout renders shared shell on every page) is fully achieved. Plan 04 can verify the markers in deployed HTML.

## Threat Flags

None — no new network endpoints, auth paths, file access patterns, or schema changes introduced. Static HTML only.

---
*Phase: 01-scaffold*
*Completed: 2026-05-07*
