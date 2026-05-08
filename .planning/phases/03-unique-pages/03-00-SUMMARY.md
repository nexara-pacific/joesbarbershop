---
phase: 03-unique-pages
plan: "00"
subsystem: testing
tags: [bash, grep, audit, aeo, gitignore]

requires:
  - phase: 02-data-design-system
    provides: site/src/pages/ and site/src/components/ built by Phase 2; audit.sh reads these for no-client-directives and no-anti-patterns checks

provides:
  - audit.sh — 14-check grep harness for Phase 3 AEO compliance; supports --self-test, --check <name>, and no-arg modes
  - canonical-slugs.txt — 11 canonical Phase 4 slugs (single source of truth for cost-guide-slugs check)
  - .gitignore policy — .firecrawl/ ignored, .agents/ committed

affects:
  - 03-01 through 03-10 — all Wave 1-3 plans use audit.sh as their per-task verify gate
  - cost-guide plan (03-06) reads canonical-slugs.txt to validate cross-links

tech-stack:
  added: []
  patterns:
    - "grep audit against site/dist/ HTML — build is the test, no test runner added"
    - "canonical-slugs.txt as single source of truth for slug lists consumed by shell scripts"

key-files:
  created:
    - .planning/phases/03-unique-pages/scripts/audit.sh
    - .planning/phases/03-unique-pages/scripts/canonical-slugs.txt
  modified:
    - .gitignore

key-decisions:
  - "4 levels up from scripts/ reaches repo root (not 5) — fixed REPO_ROOT path in audit.sh"
  - "pipefail-safe grep: use || true on zero-match greps to avoid set -euo pipefail exits on legitimate empty results"
  - ".firecrawl/ ignored (stale scrape output); .agents/ explicitly allowed (reusable skill output)"

patterns-established:
  - "audit.sh --check <name>: per-task verify pattern for all Wave 1-3 plans"
  - "SKIP: <check-name> — page not built yet: allows mid-phase partial runs without false failures"

requirements-completed: []

duration: 15min
completed: 2026-05-08
---

# Phase 3 Plan 00: Wave 0 Validation Infrastructure Summary

**Bash grep harness with 14 named AEO checks, 11-slug canonical list, and gitignore policy — Wave 1-3 plans invoke `audit.sh --check <name>` as their verify gate**

## Performance

- **Duration:** ~15 min
- **Started:** 2026-05-08
- **Completed:** 2026-05-08
- **Tasks:** 3
- **Files modified:** 3

## Accomplishments

- Created `audit.sh` — executable Bash script with `--self-test`, `--check <name>`, and no-arg modes; 14 named checks covering BLUF position, cost guide slugs, no-client-directives, no-anti-patterns, no-accordions, homepage FAQ count, niche FAQ/areaServed, about staff names/pending-photos, reviews cards/sources, and master FAQ count
- Created `canonical-slugs.txt` — 11 Phase 4 slugs (6 services + 5 neighborhoods), cross-verified against `Footer.astro` strings
- Updated `.gitignore` — `.firecrawl/` ignored (scrape output); `!.agents/` explicitly tracked (skill outputs)

## Task Commits

1. **Task 1: Create canonical-slugs.txt** — `7555c68` (chore)
2. **Task 2: Write audit.sh suite** — `6a8efb1` (chore)
3. **Task 3: Update .gitignore** — `4f13449` (chore)

## Files Created/Modified

- `.planning/phases/03-unique-pages/scripts/canonical-slugs.txt` — 11 canonical Phase 4 slugs, one per line, no leading slashes
- `.planning/phases/03-unique-pages/scripts/audit.sh` — Phase 3 AEO audit suite (395 lines, executable)
- `.gitignore` — added `.firecrawl/` ignore rule and `!.agents/` allow rule

## The 14 Named Checks

| Check name | Target | Assertion | Invocation |
|------------|--------|-----------|-----------|
| `bluf-position` | 5 non-homepage built pages | BLUF section appears before first content block | `bash audit.sh --check bluf-position` |
| `cost-guide-slugs` | `site/dist/2026-east-county-barbershop-cost-guide/index.html` | All 11 canonical slugs linked via `href="/slug"` | `bash audit.sh --check cost-guide-slugs` |
| `no-client-directives` | `site/src/pages/` (source) | Zero `client:*` directives (zero-JS AEO requirement) | `bash audit.sh --check no-client-directives` |
| `no-anti-patterns` | `site/src/pages/` (source) | Zero banned phrases ("we're more than a barbershop", "click here", etc.) | `bash audit.sh --check no-anti-patterns` |
| `no-accordions` | `site/src/pages/` (source) | Zero `<details>`, `aria-expanded`, `tab-panel` patterns | `bash audit.sh --check no-accordions` |
| `homepage-faq` | `site/dist/index.html` | 5 or 6 `<article class="faq-q">` | `bash audit.sh --check homepage-faq` |
| `niche-faq` | `site/dist/east-county-traditional-barbershop/index.html` | Exactly 6 `<article class="faq-q">` | `bash audit.sh --check niche-faq` |
| `niche-areaserved` | `site/dist/east-county-traditional-barbershop/index.html` | 5 neighborhood `href="/x-barber"` links in areaServed section | `bash audit.sh --check niche-areaserved` |
| `cost-guide-entries` | `site/dist/2026-east-county-barbershop-cost-guide/index.html` | >= 4 `<article class="entry">` | `bash audit.sh --check cost-guide-entries` |
| `about-staff-names` | `site/dist/about/index.html` | Both `<h2>Joe Denesowicz</h2>` and `<h2>Alex</h2>` | `bash audit.sh --check about-staff-names` |
| `about-pending-photos` | `site/dist/about/index.html` | Exactly 2 `data-pending-photo` attributes | `bash audit.sh --check about-pending-photos` |
| `reviews-cards` | `site/dist/reviews/index.html` | 6–8 `<article class="review-card">` | `bash audit.sh --check reviews-cards` |
| `reviews-sources` | `site/dist/reviews/index.html` | Both "Google" and "Yelp" strings present | `bash audit.sh --check reviews-sources` |
| `faq-master-count` | `site/dist/faq/index.html` | >= 10 `<article class="faq-q">` | `bash audit.sh --check faq-master-count` |

## The 11 Canonical Slugs

Services: `fades`, `classic-cut`, `kids-cuts`, `beard-trim`, `line-up`, `hot-towel-shave`

Neighborhoods: `bostonia-barber`, `el-cajon-barber`, `santee-barber`, `lakeside-barber`, `la-mesa-barber`

All 11 verified against `site/src/components/Footer.astro` link hrefs.

## .gitignore Policy

- `.firecrawl/` — **ignored**: stale scrape output (Google Maps, Yelp), large, not useful in repo history
- `!.agents/` — **committed**: durable skill outputs (`product-marketing-context.md`, `aeo-frame.md`) consumed by downstream plans

## Decisions Made

- **REPO_ROOT path**: `scripts/` is 4 levels below repo root (not 5), so `audit.sh` uses `../../../..` to reach `site/`
- **pipefail-safe grep**: all zero-match-tolerant greps use `|| true` to avoid `set -euo pipefail` exits on legitimate empty results; matching lines are captured to a variable first, then counted via `grep -c '.'`
- **SKIP vs FAIL**: checks that target `site/dist/` HTML skip (not fail) when the HTML file doesn't exist — allows mid-phase runs before all pages are built

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Fixed REPO_ROOT path calculation**
- **Found during:** Task 2 (write audit.sh, self-test)
- **Issue:** Initial path used `../../../../..` (5 levels) but `scripts/` is only 4 levels below repo root; self-test output "site/ directory not found"
- **Fix:** Changed to `../../../..` (4 levels)
- **Files modified:** `.planning/phases/03-unique-pages/scripts/audit.sh`
- **Verification:** `--self-test` reached site/ correctly, output "BUILD FIRST" instead of "SELF-TEST FAIL: site/ directory not found"
- **Committed in:** `6a8efb1`

**2. [Rule 1 - Bug] Fixed pipefail exits on zero-match grep**
- **Found during:** Task 2 (no-arg audit run test)
- **Issue:** `grep ... | wc -l` with `set -euo pipefail` causes early exit when grep finds 0 matches (exit code 1 from grep propagates through the pipeline); script was stopping after the first SKIP block
- **Fix:** Refactored `check_no_client_directives`, `check_no_anti_patterns`, `check_no_accordions` to capture grep output with `|| true`, then count via `grep -c '.' || echo 0`; applied `|| echo 0` to pipeline tails in `check_reviews_sources` and `check_niche_areaserved`
- **Files modified:** `.planning/phases/03-unique-pages/scripts/audit.sh`
- **Verification:** No-arg mode completes all 14 checks (3 pass, 11 skip), exit 0
- **Committed in:** `6a8efb1`

---

**Total deviations:** 2 auto-fixed (both Rule 1 — bugs caught during task verification)
**Impact on plan:** Both fixes necessary for correctness. No scope creep.

## Issues Encountered

None beyond the two auto-fixed bugs above.

## User Setup Required

None — no external service configuration required.

## Next Phase Readiness

- Wave 1 plans (03-01, 03-02, 03-03) can invoke `bash .planning/phases/03-unique-pages/scripts/audit.sh --check <name>` as their verify gate
- Cost guide plan (03-06) reads `canonical-slugs.txt` directly
- `.agents/` directory is tracked; Wave 1 skill outputs will land there and be committed
- `site/dist/` does not yet exist; `--self-test` correctly outputs "BUILD FIRST" — Wave 3+ page builds will populate it

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
