---
phase: 02-data-design-system
plan: "05"
subsystem: components
tags:
  - hero
  - fact-strip
  - price-board
  - astro-components
  - picture
  - business-data

dependency_graph:
  requires:
    - 02-01 (tokens.css, utilities.css)
    - 02-02 (business.ts, business.json)
  provides:
    - site/src/components/Hero.astro
    - site/src/components/FactStrip.astro
    - site/src/components/PriceBoard.astro
    - site/src/assets/photos/ (all 6 photos)
  affects:
    - _dev-mockup-parity.astro (02-07 or later page that assembles components)

tech_stack:
  added:
    - astro:assets Picture component (Hero LCP image with AVIF/WebP)
  patterns:
    - Per-component scoped <style> (D-06)
    - Picture with fetchpriority=high for hero LCP (D-14)
    - business.ts import for live data in FactStrip and PriceBoard

key_files:
  created:
    - site/src/components/Hero.astro
    - site/src/components/FactStrip.astro
    - site/src/components/PriceBoard.astro
    - site/src/assets/photos/01-logo.jpg
    - site/src/assets/photos/02-storefront.jpg
    - site/src/assets/photos/03-interior-hero.jpg
    - site/src/assets/photos/04-heritage-chair.jpg
    - site/src/assets/photos/05-mid-cut.jpg
    - site/src/assets/photos/06-price-board-cash-only.jpg
  modified: []

decisions:
  - "Used <span class=\"section-mark\"> inline in PriceBoard rather than importing SectionMark component — SectionMark.astro created by 02-04 (parallel wave); utilities.css already provides the class globally"
  - "Copied all 6 photos from inputs/photos/ to site/src/assets/photos/ — this plan ran before 02-04 could do so; identical content means no merge conflict"
  - "fetchpriority passed as plain HTML attribute on <Picture>, not an Astro prop (per D-14 note)"

metrics:
  duration: "~8 minutes"
  completed: "2026-05-07"
  tasks_completed: 2
  files_created: 9
---

# Phase 2 Plan 05: Hero, FactStrip, and PriceBoard Components Summary

Hero.astro, FactStrip.astro, and PriceBoard.astro ported from OD-5 mockup with full scoped CSS, real data from business.ts, and zero tweaks/data-font/data-checker remnants.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Hero.astro + FactStrip.astro + photos | b751435 | Hero.astro, FactStrip.astro, assets/photos/* (8 files) |
| 2 | PriceBoard.astro + build verification | e511745 | PriceBoard.astro |

## What Was Built

**Hero.astro** — Two-column section with `<Picture formats={['avif','webp']}>` for the interior hero photo (`03-interior-hero.jpg`). Uses `loading="eager"` and `fetchpriority="high"` for LCP optimization. Displays h1 display heading, BLUF paragraph, dual CTA buttons (Book a chair / Get directions), and a meta grid showing hours, address from `business.address.*`, payment info, and `business.ratings.google.value` + count. Checker ribbon rendered as unconditional base rule (tweaks stripped).

**FactStrip.astro** — 5-column fact strip with tiles for Established/Google rating/Neighborhood/Walk-ins/Barbers. Google rating value and count pulled from `business.ratings.google.value` and `business.ratings.google.count`. Yelp value from `business.ratings.yelp.value`. Responsive 2-column layout at 980px.

**PriceBoard.astro** — Letter-board price section with dark `var(--board-bg)` styling. All 5 prices pulled from `business.prices.*` (haircut: $30, shave: $30, beardLineUp: $20, cleanUp: $15, haircutBeard: $50). Section head uses `.section-mark` utility class inline. Price-aside copy provides qualitative context and a Google review quote. Two responsive breakpoints.

**Photos** — All 6 photos copied from `inputs/photos/` to `site/src/assets/photos/` so Astro `<Picture>` and `<Image>` can process them as AVIF/WebP with srcset.

## Deviations from Plan

### Auto-fixed Issues

None — plan executed as written.

### Notes

**Photo copy** — `site/src/assets/photos/` did not exist in this worktree yet (02-04 runs in parallel and also copies photos). This plan created the directory and copied all 6 photos. Since the content is identical, the worktree merge will see no conflict.

**SectionMark inline** — Plan 02-04 creates `SectionMark.astro` in a parallel wave. Since `.section-mark` is a globally-available utility class (utilities.css), PriceBoard uses `<span class="section-mark">` directly without importing the component. No functional difference — both render an identical span.

**npm install** — The worktree's `site/node_modules/` was absent. Ran `npm install` before build verification. Not a code deviation; standard worktree setup requirement.

## Known Stubs

None — Hero, FactStrip, and PriceBoard all render real data from `business.ts`. No hardcoded placeholder values in the data-driven fields.

## Threat Flags

None — static component files with no user input, network calls, auth, or secrets.

## Self-Check: PASSED

- `site/src/components/Hero.astro` — exists, confirmed
- `site/src/components/FactStrip.astro` — exists, confirmed
- `site/src/components/PriceBoard.astro` — exists, confirmed
- Commit b751435 — exists (feat(02-05): add Hero.astro, FactStrip.astro, and photos assets)
- Commit e511745 — exists (feat(02-05): add PriceBoard.astro with business.ts prices; build passes)
- `npm run build` exits 0 — confirmed
