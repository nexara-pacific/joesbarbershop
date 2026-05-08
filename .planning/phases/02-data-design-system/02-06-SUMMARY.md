---
phase: 02-data-design-system
plan: "06"
subsystem: design-system
tags:
  - astro-components
  - heritage
  - visit
  - faq
  - closing-cta
  - aeo
  - nap
dependency_graph:
  requires:
    - 02-01 (tokens.css + utilities.css cascade)
    - 02-02 (business.ts with address/phone/hours fields)
  provides:
    - site/src/components/Heritage.astro
    - site/src/components/Visit.astro
    - site/src/components/FAQ.astro
    - site/src/components/ClosingCTA.astro
  affects:
    - site/src/pages/_dev-mockup-parity.astro (imports these components)
    - Phase 3 homepage (imports these components)
tech_stack:
  added: []
  patterns:
    - Astro Image (lazy-loaded) for below-fold photos (Heritage, Visit)
    - business.ts import for NAP data in Visit
    - Flat h3/p FAQ pairs per AEO constraint (no JS accordions)
    - Scoped component CSS per D-06
    - Dead-code strip per D-09/D-10 (no [data-checker] variants)
key_files:
  created:
    - site/src/components/Heritage.astro
    - site/src/components/Visit.astro
    - site/src/components/FAQ.astro
    - site/src/components/ClosingCTA.astro
    - site/src/assets/photos/02-storefront.jpg
    - site/src/assets/photos/04-heritage-chair.jpg
  modified: []
decisions:
  - "Heritage.astro omits heritage-frame [data-checker='heavy'] CSS variant — dead code after tweaks strip (D-09 option 1)"
  - "FAQ uses flat article/h3/p structure — no <details>/<summary> or JS per AEO constraint"
  - "Visit pulls address.street/suite/city/state/zip and phone from business.ts via import"
  - "Photos copied from inputs/photos/ to site/src/assets/photos/ — src/ path required for Astro Image processing (D-11)"
  - "ClosingCTA has no business.ts import — booking URL is static (joe-104613.square.site)"
metrics:
  duration: "~10 minutes"
  completed: "2026-05-07"
  tasks_completed: 2
  tasks_total: 2
  files_created: 6
  files_modified: 0
requirements:
  - DESN-02
  - DESN-03
---

# Phase 2 Plan 06: Heritage, Visit, FAQ, ClosingCTA Components Summary

**One-liner:** Four OD-5 body-section components ported from mockup with scoped CSS, lazy-loaded images via `<Image />`, NAP data from business.ts in Visit, flat h3/p FAQ pairs per AEO constraint, and zero tweaks/data-checker remnants.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Heritage.astro and Visit.astro | 105e75a | Heritage.astro, Visit.astro, 02-storefront.jpg, 04-heritage-chair.jpg |
| 2 | FAQ.astro and ClosingCTA.astro; build check | d5c1358 | FAQ.astro, ClosingCTA.astro |

## What Was Built

**Heritage.astro** — Two-column grid section (photo left, copy + 3-stat block right). Imports `04-heritage-chair.jpg` via `<Image loading="lazy" />`. Three stats: 4.9 Google rating, 90+ reviews, 5yr serving Bostonia. Scoped CSS with responsive collapse at 980px. No `[data-checker]` variant rules — dead code stripped per D-09/D-10.

**Visit.astro** — Storefront photo + NAP dl/dt/dd card. Imports `02-storefront.jpg` via `<Image loading="lazy" />`. Pulls `business.address.*` and `business.phone` from `../data/business`. Includes Get Directions button to Google Maps. Responsive at 980px.

**FAQ.astro** — Five flat `article.faq-q` items, each with a numeric `.num` span, `<h3>` question, and `<p>` answer. No `<details>`, `<summary>`, `onclick`, or JavaScript of any kind. AEO parsers see all content unconditionally. Topics: appointments, payment, timing, kids, location.

**ClosingCTA.astro** — Centered full-width CTA section with static booking URL (`joe-104613.square.site`). Two buttons: "Book a chair" (Square Site) and "Get directions" (#visit anchor). Trust line: "Walk-ins welcome · Est. 2020 · Bostonia, El Cajon". No business.ts import needed.

**Photos** — `02-storefront.jpg` and `04-heritage-chair.jpg` copied from `inputs/photos/` to `site/src/assets/photos/` for Astro Image processing (AVIF/WebP pipeline).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] npm install required before build verification**
- **Found during:** Task 2 build verification
- **Issue:** `node_modules` absent from worktree; `astro` command not on PATH
- **Fix:** Ran `npm install` in `site/` before `npm run build`
- **Files modified:** `site/node_modules/` (gitignored)
- **Commit:** N/A (no tracked file changes)

No other deviations — components implemented exactly as specified in PLAN.md.

## Verification Results

All acceptance criteria passed:

- `Heritage.astro` exists: PASS
- `Visit.astro` exists: PASS
- `FAQ.astro` exists: PASS
- `ClosingCTA.astro` exists: PASS
- `heritagePhoto` import in Heritage.astro (1 match): PASS
- `loading="lazy"` in Heritage.astro (1 match): PASS
- No `data-checker`/`heritage-frame.*heavy` in Heritage.astro: PASS
- `business.phone` in Visit.astro (1 match): PASS
- `business.address` in Visit.astro (2+ matches): PASS
- `loading="lazy"` in Visit.astro (1 match): PASS
- No `data-checker`/`data-font` in Visit.astro: PASS
- No `<details>`/`<summary>`/`onclick` in FAQ.astro: PASS
- `faq-q` in FAQ.astro (9 matches, >=5): PASS
- `<h3>` in FAQ.astro (5 matches): PASS
- `closing-cta` in ClosingCTA.astro (7 matches, >=2): PASS
- `square.site` in ClosingCTA.astro (1 match): PASS
- No `data-checker`/`data-font` in FAQ.astro or ClosingCTA.astro: PASS
- `npm run build` exits 0: PASS

## Known Stubs

None — all four components render their intended content. Visit uses live business.ts data (not hardcoded). FAQ content is final placeholder-quality copy (will be replaced with AEO-optimized prose in Phase 3, but renders now).

## Threat Flags

None — all four components are static Astro files. No user input, no network calls, no auth surfaces, no secrets. Only public business data (NAP, hours) rendered from business.ts.

## Self-Check: PASSED
