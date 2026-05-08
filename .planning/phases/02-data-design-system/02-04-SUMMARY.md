---
phase: 02-data-design-system
plan: 04
subsystem: components-photos
tags:
  - astro-image
  - components
  - photos
  - design-port
dependency_graph:
  requires:
    - site/src/styles/tokens.css (02-01 — CSS cascade vars available)
    - site/src/styles/utilities.css (02-01 — .check-divider, .section-mark)
    - site/src/data/business.ts (02-02 — business.phone, business.address)
  provides:
    - site/src/assets/photos/01-logo.jpg
    - site/src/assets/photos/02-storefront.jpg
    - site/src/assets/photos/03-interior-hero.jpg
    - site/src/assets/photos/04-heritage-chair.jpg
    - site/src/assets/photos/05-mid-cut.jpg
    - site/src/assets/photos/06-price-board-cash-only.jpg
    - site/src/components/UtilBar.astro (full OD-5 body)
    - site/src/components/Masthead.astro (full OD-5 body)
    - site/src/components/Footer.astro (full OD-5 body with footer-checker)
    - site/src/components/CheckDivider.astro
    - site/src/components/SectionMark.astro
  affects:
    - Wave 3+ page components (Hero, FactStrip, etc.) that consume photos or layout shell
tech_stack:
  added: []
  patterns:
    - Astro Image object-import pattern (import logo from '...'; <Image src={logo} />) — prevents ExpectedImage error
    - Photo assets in src/assets/photos/ (not public/) for AVIF/WebP/srcset processing
    - Per-component scoped <style> blocks carrying OD-5 CSS (locality-first per D-06)
    - Zero-prop static Astro components (CheckDivider, SectionMark)
key_files:
  created:
    - site/src/assets/photos/01-logo.jpg
    - site/src/assets/photos/02-storefront.jpg
    - site/src/assets/photos/03-interior-hero.jpg
    - site/src/assets/photos/04-heritage-chair.jpg
    - site/src/assets/photos/05-mid-cut.jpg
    - site/src/assets/photos/06-price-board-cash-only.jpg
    - site/src/components/CheckDivider.astro
    - site/src/components/SectionMark.astro
  modified:
    - site/src/components/UtilBar.astro
    - site/src/components/Masthead.astro
    - site/src/components/Footer.astro
decisions:
  - "Photos copied to src/assets/photos/ (not public/) per D-11 — required for Astro Image processing"
  - "Filenames preserved verbatim per D-13 (01-logo.jpg, 02-storefront.jpg, etc.)"
  - "Image import as object (import logo from '...') not string path — avoids ExpectedImage build error per D-14"
  - "CheckDivider/SectionMark are zero-prop components; styles live in utilities.css (globally cascaded)"
  - "Footer includes .footer-checker div before <footer> element — checkerboard separator band"
  - "data-phase1-stub attributes fully removed; zero matches after replacement"
metrics:
  duration: "~10 minutes"
  completed: "2026-05-07T23:58:00Z"
  tasks_completed: 2
  tasks_total: 2
  files_created: 8
  files_modified: 3
---

# Phase 2 Plan 04: Photos + UtilBar/Masthead/Footer OD-5 Port Summary

**One-liner:** 6 photos copied to src/assets/photos/ with verbatim filenames for Astro Image processing, Phase 1 UtilBar/Masthead/Footer stubs replaced with full OD-5 bodies using object-import logo pattern, and zero-prop CheckDivider + SectionMark components created.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Copy 6 photos and create CheckDivider + SectionMark components | 9b4722a | 6 photos, CheckDivider.astro, SectionMark.astro |
| 2 | Replace UtilBar, Masthead, Footer stubs with full OD-5 bodies | 0e76bb9 | UtilBar.astro, Masthead.astro, Footer.astro |

## What Was Built

**Photos (6)** — Copied from `inputs/photos/` to `site/src/assets/photos/` with verbatim filenames. Astro Image processed them into AVIF/WebP with srcset on build (confirmed by build output showing 4 webp variants of 01-logo.jpg at sizes 26px/56px/76px/152px).

**CheckDivider.astro** — Zero-prop `<div class="check-divider" aria-hidden="true">`. No scoped `<style>` needed — `.check-divider` rules live in `utilities.css` (globally cascaded via Base.astro).

**SectionMark.astro** — Zero-prop `<span class="section-mark" aria-hidden="true">`. Same rationale — styles global.

**UtilBar.astro** — Full OD-5 util bar: walk-ins/family-friendly/ATM/hours info strip + `{business.phone}` pulled from business.ts. Black bar, uppercase board font, accent-colored dot separators, phone right-aligned (responsive wrap on mobile).

**Masthead.astro** — Full OD-5 masthead: brand lockup (logo Image + name/tagline), primary nav (5 links), Book-a-chair CTA button. Logo imported as object (`import logo from '../assets/photos/01-logo.jpg'`) to satisfy Astro's ExpectedImage constraint. Responsive: nav hides at 980px breakpoint.

**Footer.astro** — Full OD-5 footer: `.footer-checker` checkerboard band above footer, 4-column grid (brand/services/east-county/shop), NAP in legal strip using `business.address.*` and `business.phone`. Logo also imported as object. Dark background, inverted color scheme.

## Deviations from Plan

None — plan executed exactly as written.

## Verification Results

All acceptance criteria passed:

- `ls site/src/assets/photos/ | wc -l` = 6: PASS
- `01-logo.jpg`, `03-interior-hero.jpg`, `06-price-board-cash-only.jpg` exist: PASS
- NOT in `site/public/photos/`: PASS
- `CheckDivider.astro` exists with `check-divider` class: PASS
- `SectionMark.astro` exists with `section-mark` class: PASS
- `grep -r "data-phase1-stub" site/src/` — zero matches: PASS
- `grep -r "tweaks" site/src/` — zero matches: PASS
- `grep -r "data-font\|data-checker" site/src/` — zero matches: PASS
- `grep -rE "applyFont|applyCheck|toggleTweaks" site/src/` — zero matches: PASS
- `grep "business.phone" UtilBar.astro` — 1 match: PASS
- `grep "brand-lockup" Masthead.astro` — match: PASS
- `grep "import logo from" Masthead.astro` — 1 match (object import): PASS
- `grep "footer-checker" Footer.astro` — 1 match: PASS
- `grep "import logo from" Footer.astro` — 1 match (object import): PASS
- `npm run build` exits 0: PASS (2 pages built, 4 webp image variants generated)

## Known Stubs

None — this plan delivers fully-wired components. UtilBar, Masthead, and Footer render real data from `business.ts`. CheckDivider and SectionMark are intentionally zero-prop (they carry no data — they're structural decorators).

## Threat Flags

None — this plan copies static image files and overwrites component markup. No user input, network calls, authentication, secrets, or new trust boundaries introduced. (Consistent with T-02-19 through T-02-24 all accepted in plan threat model.)

## Self-Check: PASSED
