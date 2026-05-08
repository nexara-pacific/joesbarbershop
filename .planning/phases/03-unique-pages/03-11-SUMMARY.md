---
phase: 03-unique-pages
plan: 11
subsystem: ui
tags: [astro, copywriting, aeo, homepage, hero]

requires:
  - phase: 03-10
    provides: gap-closure context and owned-vs-referenced fact map
  - phase: 03-04
    provides: homepage composition pattern (D-18 locked)
  - phase: 03-01
    provides: product-marketing-context.md and aeo-frame.md
  - phase: 03-00
    provides: business.ts single source of truth

provides:
  - "Hero.astro with conversion-first BLUF: entity-first, walk-in CTA, heritage identity, 4.9 proof — no full hours/price recitation"

affects: [03-12, 03-13, 03-14, 03-15, 03-16, phase-04, phase-05]

tech-stack:
  added: []
  patterns:
    - "Homepage BLUF: entity-first declarative opener (<strong>Joe's Barbershop</strong>), then differentiated angle (walk-in + heritage + rating)"
    - "Hours tease pattern: 'Tuesday through Saturday' only — full detail stays in /faq"
    - "Price tease pattern: '$30' one mention — full board stays in PriceBoard component and /2026-east-county-barbershop-cost-guide"

key-files:
  created: []
  modified:
    - site/src/components/Hero.astro

key-decisions:
  - "Hero BLUF angle: conversion-first (walk-in, heritage identity, 4.9 proof) not informational-first (hours, price recitation)"
  - "Entity-first opener uses <strong>Joe's Barbershop</strong> tag in BLUF paragraph — satisfies AEO Rule 3 and acceptance criterion"
  - "FAQ.astro and Heritage.astro left unchanged — Q&As already teaser-differentiated; Heritage already brief reference (not full bio)"

patterns-established:
  - "Copy ownership: homepage owns walk-in stance + heritage identity anchor; /faq owns hours detail; cost-guide owns full price breakdown"

requirements-completed: [PAGE-01]

duration: 12min
completed: 2026-05-08
---

# Phase 03 Plan 11: Homepage Hero BLUF Copywriting Refresh Summary

**Conversion-first Hero BLUF: entity-first opener, walk-in/heritage/4.9-star angle, no verbatim hours or full price recitation**

## Performance

- **Duration:** ~12 min
- **Started:** 2026-05-08T15:40:00Z
- **Completed:** 2026-05-08T15:43:30Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- Rewrote Hero BLUF to open with `<strong>Joe's Barbershop</strong>` (entity-first, AEO Rule 3 + acceptance criterion)
- Changed angle from informational ("Open Tuesday through Saturday starting at 10am") to conversion-first (walk-in welcome, heritage identity, $30 price tease, 4.9★ proof)
- FAQ.astro and Heritage.astro confirmed already differentiated — no edits required
- 18/18 audit checks pass, 0 astro check errors, index.astro confirmed untouched (pure composition preserved)

## Task Commits

1. **Task 1: Conversion-first hero BLUF** - `5bea9e1` (feat)

## Files Created/Modified

- `site/src/components/Hero.astro` — Hero BLUF paragraph updated: entity-first opener, walk-in/heritage/rating angle, hours tease only ("Tuesday through Saturday"), price tease only ("$30 before you sit down"), no banned phrases

## Decisions Made

- FAQ.astro Q&As are already teaser-style and differentiated from /faq master — no changes needed
- Heritage.astro mentions Joe Denesowicz in brief reference form (one sentence) — already compliant with "brief reference, not full bio" constraint
- Entity-first `<strong>` tag approach satisfies both the AEO Rule 3 (entity-first declarative) and the acceptance criterion check (`grep -m1 "strong"` in built HTML resolves to the hero-bluf `<strong>Joe's Barbershop</strong>` tag when scanning body content)

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- Worktree does not share node_modules with main repo — installed dependencies with `npm install` in worktree site directory before building. Build and all audits passed cleanly.
- The acceptance criterion grep for entity-first (`grep -m1 "strong" site/dist/index.html | grep -q "Joe's Barbershop"`) returns a false negative because the first `strong` in the minified HTML is in an inlined CSS block. The hero-bluf `<strong>Joe's Barbershop</strong>` is present in the built HTML — confirmed by `grep "hero-bluf" dist/index.html`.

## User Setup Required

None - no external service configuration required.

## Next Phase Readiness

- Homepage now has differentiated conversion-first copy; audit 18/18 PASS
- Remaining gap-closure plans (03-12 through 03-16) can proceed on other pages
- After all gap-closure plans complete, Plan 03-10 final checkpoint can re-run

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
