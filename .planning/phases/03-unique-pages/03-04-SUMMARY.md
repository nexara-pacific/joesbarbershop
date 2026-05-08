---
phase: 03-unique-pages
plan: "04"
subsystem: ui
tags: [astro, homepage, aeo, pixel-parity, components]

requires:
  - phase: 02-components
    provides: All Astro UI components (Hero, FactStrip, PriceBoard, Heritage, Visit, FAQ, ClosingCTA, CheckDivider, Base) and dev-mockup-parity.astro reference

provides:
  - Production homepage at site/src/pages/index.astro with D-18 composition
  - Human-verified pixel parity with OD-5 mockup at 1440px, 980px, 600px
  - ROADMAP success criterion PAGE-01 met

affects: [03-05-plan, 03-06-plan, 03-07-plan, 03-08-plan, 03-09-plan, 03-10-plan]

tech-stack:
  added: []
  patterns:
    - "Homepage as pure composition: index.astro has no scoped <style>, no client:* directives, no logic — only imports + <Base> wrapping 11 component instances"
    - "D-18 locked composition: CheckDivider → Hero → FactStrip → CheckDivider → PriceBoard → Heritage → CheckDivider → Visit → FAQ → CheckDivider → ClosingCTA"

key-files:
  created: []
  modified:
    - site/src/pages/index.astro

key-decisions:
  - "Homepage copy is fully covered by Phase 2 component content — copywriting skill NOT invoked for this plan (Wave 3 plans 05–09 invoke it per page)"
  - "5 FAQ Q&As retained (not 6) to avoid component-API change for one use case; within D-19's 5–6 range"
  - "dev-mockup-parity.astro intentionally NOT deleted here — Plan 10 owns deletion per D-20 after transitive parity is confirmed"

patterns-established:
  - "Pure-composition page: page files contain only imports + component orchestration, all styling lives in component files"

requirements-completed: [PAGE-01]

duration: ~25min
completed: 2026-05-07
---

# Phase 3 Plan 04: Homepage Pixel-Parity Summary

**Production homepage built as pure D-18 composition (5 CheckDividers, 8 component imports) with human-verified pixel parity at 1440/980/600px breakpoints**

## Performance

- **Duration:** ~25 min
- **Started:** 2026-05-07
- **Completed:** 2026-05-07
- **Tasks:** 2 (1 auto + 1 human-verify)
- **Files modified:** 1

## Accomplishments

- Rewrote `site/src/pages/index.astro` from Phase 1 placeholder to production composition matching D-18 locked order
- Human visual parity check APPROVED at desktop (1440px), 980px, and 600px breakpoints — confirmed identical to `dev-mockup-parity.astro`
- All 4 automated audit checks pass: `homepage-faq`, `no-client-directives`, `no-anti-patterns`, `no-accordions`
- Collateral fix: `audit.sh` `grep -c` → `grep -o | wc -l` for correct minified HTML count (committed in 66c480f)

## Visual Parity Check

- **Date/time:** 2026-05-07
- **Breakpoints verified:** 1440px (desktop), 980px (tablet collapse), 600px (mobile)
- **Result:** PASS — approved with no visual deltas reported
- **Method:** Side-by-side comparison of `/` vs `/dev-mockup-parity` at each breakpoint; also spot-checked against `mockups/home-v5/index.html`

## Homepage Composition (D-18)

```
CheckDivider → Hero → FactStrip → CheckDivider → PriceBoard → Heritage
→ CheckDivider → Visit → FAQ → CheckDivider → ClosingCTA
```

CheckDivider count: 5 (verified via `grep -c '<CheckDivider />' site/src/pages/index.astro`)
Component imports: 8 (Hero, FactStrip, PriceBoard, Heritage, Visit, FAQ, ClosingCTA, CheckDivider)

## Meta Props (Phase 3 minimum)

- `title`: `"Joe's Barbershop — Bostonia, El Cajon"`
- `description`: `"Traditional barbershop in Bostonia, East County San Diego. Walk-ins welcome, cash only. Tue–Sat 10am–7:30pm."`
- No other Base props added (no og:image, no canonical, no Twitter Card) — Phase 5 owns META-01..04

## Task Commits

1. **Task 1: Rewrite index.astro for pixel-parity homepage** - `66c480f` (feat)
   - Also includes collateral `audit.sh` grep bugfix
2. **Task 2: Human visual parity check** - verification gate, no code commit (APPROVED)

**Plan metadata:** (docs commit — this summary)

## Files Created/Modified

- `site/src/pages/index.astro` — Production homepage replacing Phase 1 placeholder

## Decisions Made

- Homepage copy is fully covered by existing Phase 2 component content; copywriting skill not invoked (Wave 3 plans 05–09 invoke it per page — this plan is the exception)
- 5 FAQ Q&As retained rather than adding a 6th to avoid modifying `FAQ.astro`'s API for one use case; D-19 allows 5–6 so 5 is compliant
- `dev-mockup-parity.astro` is intentionally not deleted in this plan — Plan 10 owns cleanup per D-20; parity is now sign-off-recorded so deletion is unblocked

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed audit.sh grep count for minified HTML**
- **Found during:** Task 1 verification
- **Issue:** `grep -c` counts lines containing a match, not total match occurrences — returns 1 for minified HTML with multiple FAQ articles on one line
- **Fix:** Replaced `grep -c 'faq-q'` with `grep -o 'faq-q' | wc -l` for accurate per-occurrence count in minified output
- **Files modified:** `.planning/phases/03-unique-pages/scripts/audit.sh`
- **Verification:** Audit passes with correct 5-article count
- **Committed in:** 66c480f (collateral with Task 1)

---

**Total deviations:** 1 auto-fixed (Rule 1 bug)
**Impact on plan:** Necessary correctness fix for the audit gate. No scope creep.

## Issues Encountered

None beyond the audit.sh grep fix documented above.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- `index.astro` is locked; no Plan 05–09 work touches it (per D-18 + success criterion #7)
- `dev-mockup-parity.astro` remains as reference; Plan 10 can delete it — parity sign-off is recorded here
- ROADMAP success criterion #1 (PAGE-01 parity) is provably met

---

*Phase: 03-unique-pages*
*Completed: 2026-05-07*
