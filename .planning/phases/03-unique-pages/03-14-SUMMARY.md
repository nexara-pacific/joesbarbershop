---
phase: 03-unique-pages
plan: 14
subsystem: ui
tags: [astro, copywriting, aeo, about-page, biography]

# Dependency graph
requires:
  - phase: 03-unique-pages/03-10
    provides: about.astro page scaffold with bio sections and data-pending-photo markers
  - phase: 03-unique-pages/03-07
    provides: Visit component and ClosingCTA used in about.astro
  - phase: 03-unique-pages/03-01
    provides: aeo-frame.md and product-marketing-context.md context files
  - phase: 03-unique-pages/03-00
    provides: business.ts data source for dynamic values
provides:
  - /about page with owner-identity BLUF answering "who owns Joe's Barbershop in El Cajon"
  - Joe bio focused on founding story and community-anchor framing (not craft/competitor contrast)
  - Alex bio conservative/minimal per D-06 with walk-in framing without operational hours recitation
  - No hours (10am-7:30pm) or full price board in BLUF or bio prose
affects: [03-16, phase-04, phase-05]

# Tech tracking
tech-stack:
  added: []
  patterns: [cross-page fact ownership — /about owns identity/founding, /faq owns hours, /east-county-traditional-barbershop owns craft contrast]

key-files:
  created: []
  modified:
    - site/src/pages/about.astro

key-decisions:
  - "BLUF angle: answer 'who owns Joe's Barbershop' with founding story and quality proof, not operational policy recitation"
  - "Joe bio paragraph 2 shifted from craft/heritage visual identity (owned by /east-county-traditional-barbershop) to community-anchor framing (regulars, families, repeat customers)"
  - "Alex bio paragraph 2 replaced Tuesday-Saturday hours recitation with walk-in model framing (no explicit hours)"

patterns-established:
  - "Cross-page fact ownership enforced: each page leads with its unique angle; operational facts referenced contextually not as anchors"

requirements-completed: [PAGE-04]

# Metrics
duration: 8min
completed: 2026-05-08
---

# Phase 03 Plan 14: About Page Identity-Focused Copy Refresh Summary

**Owner-identity BLUF and community-anchor bio prose replacing operational-policy duplication from /faq and craft-contrast duplication from /east-county-traditional-barbershop**

## Performance

- **Duration:** ~8 min
- **Started:** 2026-05-08T22:35:00Z
- **Completed:** 2026-05-08T22:43:09Z
- **Tasks:** 1
- **Files modified:** 1

## Accomplishments

- BLUF revised: answers "who owns Joe's Barbershop" with Joe Denesowicz as named entity, founding story, and quality proof (4.9 stars) — no more operational hours/cash/price recitation in BLUF body
- Joe bio paragraph 2 shifted from craft/heritage visual identity framing (owned by /east-county-traditional-barbershop) to community-anchor framing: regulars, fathers bringing sons, consistent repeat patronage
- Alex bio paragraph 2 replaced explicit Tuesday-Saturday hours recitation with walk-in model framing, removing the operational duplication while preserving the walk-in policy signal
- All structural invariants preserved: 2 data-pending-photo markers, Visit component, ClosingCTA, Joe Denesowicz and Alex in plain DOM text, no banned phrases

## Task Commits

1. **Task 1: Invoke copywriting skill for about page and apply identity-focused copy** - `44f47c7` (feat)

## Files Created/Modified

- `site/src/pages/about.astro` - BLUF paragraph, Joe bio paragraph 2, Alex bio paragraph 2 revised with cross-page fact ownership awareness

## Decisions Made

- BLUF body after the owner-identity first sentence shifted to quality proof and community framing; "cash-only with an ATM on site, walk-ins are always welcome Tuesday through Saturday, and a haircut is $30" removed as BLUF anchor (these are /faq's owned facts)
- Joe bio paragraph 2 removes checkerboard/ornate-serif/letter-board visual identity description (that craft-and-heritage contrast angle belongs to /east-county-traditional-barbershop); replaced with regulars narrative
- Alex bio paragraph 2 "Walk-ins are welcome any time the shop is open, Tuesday through Saturday" removed; replaced with "Alex's chair runs on the same walk-in model as the shop. No booking required." — retains the walk-in signal without reciting /faq's hours ownership

## Deviations from Plan

None - plan executed exactly as written.

## Issues Encountered

- npm run build in the worktree required `npm install` first since node_modules were not present in the worktree (resolved with Rule 3 auto-fix: ran `npm install` before build). No code changes required.

## Stub Scan

No stubs found. All dynamic values (`business.ratings.google.count`, `business.ratings.yelp.count`, `business.prices.haircut`) wired from `business.ts` source of truth. Portrait placeholders marked with `data-pending-photo` as designed — these are intentional pending-photo markers, not stubs blocking page function.

## Threat Surface Scan

No new trust boundaries introduced. This plan only edits bio prose copy. No new network endpoints, auth paths, file access patterns, or schema changes.

T-03-14-01 (fabrication risk): No fabricated biographical specifics introduced. Joe bio covers: opening year (2020), location (Bostonia, El Cajon), founding intent (neighborhood shop, fair price, repeat customers), quality proof (4.9 stars, review counts). Alex bio covers: lead barber role, location, consistent quality signal. No schools, prior shops, or hometown details fabricated.

T-03-14-02 (data-pending-photo tampering): Both markers verified intact in source and dist.

## Self-Check: PASSED

- `site/src/pages/about.astro` exists and modified: FOUND
- Commit `44f47c7` exists: FOUND
- `npm run build` exits 0: PASS
- `audit.sh` 18/18 PASS: PASS
- `astro check` 0 errors / 0 warnings: PASS
- `data-pending-photo="joe"` count in dist: 1
- `data-pending-photo="alex"` count in dist: 1
- "Joe Denesowicz" in dist: PASS
- No "10am to 7:30pm" in about.astro source: PASS
- No banned phrases: PASS

## Next Phase Readiness

- /about.astro is cross-page-coherent: owns identity/founding, references hours only via Visit component downstream, no full price board recitation
- Ready for Plan 03-16 (final verification pass / Plan 03-10 checkpoint re-run)
- No blockers

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
