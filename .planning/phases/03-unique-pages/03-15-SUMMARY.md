---
phase: 03-unique-pages
plan: "15"
subsystem: pages
tags:
  - reviews
  - aeo
  - copy-cohesion
  - gap-closure

dependency_graph:
  requires:
    - "03-08 (reviews.astro initial build)"
    - "03-10 (verification — copy cohesion gap identified)"
  provides:
    - "PAGE-05 — /reviews BLUF refreshed to trust-signal focus"
  affects:
    - "Phase 5 schema — AggregateRating copy now isolated to /reviews BLUF"

tech_stack:
  added: []
  patterns:
    - "business.ratings.* interpolations preserved across two BLUF lines"
    - "Trust-signal BLUF: rating → what it reflects → data transparency → closing"

key_files:
  created: []
  modified:
    - site/src/pages/reviews.astro

decisions:
  - "Closing sentence uses {business.ratings.google.count + business.ratings.yelp.count} interpolation to satisfy >= 2 business.ratings.* lines criterion while keeping copy cohesive"
  - "Placeholder card transparency preserved in BLUF prose — honest about 4 real Yelp + 4 Google pending cards"
  - "Cash-only / walk-in / hours / prices fully removed from BLUF — those are /faq and /cost-guide territory"

metrics:
  duration: "< 15 min"
  completed_date: "2026-05-08"
  tasks_completed: 1
  files_created: 0
  files_modified: 1
---

# Phase 03 Plan 15: Reviews BLUF Trust-Signal Refresh Summary

Replaced the duplicated operational-policy BLUF on /reviews with a trust-signal focused paragraph: 4.9★ across 91 Google + 33 Yelp reviews, what the rating reflects, and honest placeholder transparency. Cash-only, hours, prices, and walk-in policy removed from BLUF — those are /faq and /cost-guide owners.

## What Was Built

**BLUF before (problem):** First sentence correctly led with rating signal, then the paragraph included "Cash-only, no booking app required, walk-ins welcome Tuesday through Saturday" and "Traditional barbering at $30 a cut" — full duplication of /faq and /cost-guide content.

**BLUF after (fixed):**
- Opening `<strong>`: 4.9★ across {google.count} Google + {yelp.count} Yelp = combined verified ratings from East County customers
- Sentence 2: Rating origin — repeat neighborhood customers, same barbers, same shop at 723 E Bradley Ave since 2020 (not a campaign)
- Sentence 3: Data transparency — 4 real Yelp quotes appear below; 4 Google cards are placeholder pending showcase
- Sentence 4: Closing — every quote is from a customer who sat in the chair, {combined count} reasons to walk in

**What was removed:**
- "Cash-only, no booking app required, walk-ins welcome Tuesday through Saturday" (owned by /faq)
- "Traditional barbering at ${business.prices.haircut} a cut" (owned by /cost-guide)

## Verification Results

| Check | Result |
|-------|--------|
| `npm run build` | PASS (exit 0) |
| `audit.sh` (18 checks) | 18 passed, 0 failed |
| `astro check` | 0 errors / 0 warnings / 0 hints |
| `audit.sh --check reviews-cards` | PASS |
| `audit.sh --check reviews-sources` | PASS |
| BLUF contains 4.9 signal in built HTML | PASS |
| No operational block (cash-only/walk-in/Tue-Sat) in BLUF | PASS |
| No banned phrases | PASS |
| No `<blockquote>` in built reviews HTML | PASS (count: 0) |
| `business.ratings.*` interpolations >= 2 lines | PASS (2 lines) |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] business.ratings.* line count dropped to 1 after removing prices line**
- **Found during:** Acceptance criteria check
- **Issue:** Original BLUF had `{business.ratings.google.count + business.ratings.yelp.count}` on the prices line ("backed by N real reviews") — when that line was removed, the combined-count interpolation disappeared, reducing `grep "business.ratings." | wc -l` from 2 to 1, failing the `>= 2` criterion.
- **Fix:** Added `{business.ratings.google.count + business.ratings.yelp.count}` to the closing sentence ("N reasons to walk in"), keeping the interpolation on a second line and the copy cohesive.
- **Files modified:** site/src/pages/reviews.astro
- **Commit:** 8631ae4

## Known Stubs

| File | Stub | Reason |
|------|------|--------|
| `site/src/data/reviews.json` | 4 Google cards: `[Reviewer name pending]` / `[Quote pending]` | D-10 path B: intentional per business.json._showcase_review_pending; BLUF now explicitly references this transparency |

## Threat Flags

None. No new network endpoints, auth paths, or schema changes. T-03-15-01 (rating number hardcoding) — mitigated: `business.ratings.*` interpolations preserved across 2 lines, no literal numeric rating values in BLUF.

## Self-Check: PASSED

- `site/src/pages/reviews.astro` exists: FOUND
- Commit `8631ae4` exists: FOUND
- audit.sh 18/18 PASS: CONFIRMED
- astro check 0 errors/0 warnings: CONFIRMED
