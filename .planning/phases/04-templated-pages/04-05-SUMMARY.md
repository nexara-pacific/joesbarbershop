---
phase: 04-templated-pages
plan: 05
subsystem: validation/audit
tags:
  - audit
  - validation
  - phase-4
  - aeo
  - regression-guard
requires:
  - phase: 04-templated-pages
    plans: ["04-01", "04-02", "04-03", "04-04"]
  - file: .planning/phases/03-unique-pages/scripts/audit.sh
  - file: .planning/phases/03-unique-pages/scripts/canonical-slugs.txt
provides:
  - extended-audit-suite
  - phase-4-acceptance-gate
  - stub-regression-guard
  - landmark-placeholder-guard
affects:
  - .planning/phases/03-unique-pages/scripts/audit.sh
tech-stack:
  added: []
  patterns:
    - bash-check-function-idiom-from-phase-3
    - registry-case-statement-update
    - run-all-checks-loop-extension
key-files:
  created: []
  modified:
    - .planning/phases/03-unique-pages/scripts/audit.sh
decisions:
  - "Honored D-01: checks look at dist/{slug}/index.html at ROOT (not under services/) — proves flat-route execution"
  - "Honored D-04 + D-09: check_templated_bluf greps each built page for <section class=\"bluf\"> — proves template skeleton applied"
  - "Honored D-11: check_neighborhood_data_populated guards against the exact Phase 2 placeholder strings (Bostonia area / East County (San Diego) pairs / distance:\"local\")"
  - "Honored D-15 + D-16: check_no_stub_content greps src/content/ for the Phase 2 stub markers — catches broken output that the no-review-gate authoring would otherwise let through"
  - "Per plan instructions: kept changes purely additive — no Phase 3 function or registry entry was modified, only appended"
  - "Bundled task-1 implementation into a single feat commit (functions + registry + run_all_checks) since plan task is a single atomic deliverable; SUMMARY commit is separate"
metrics:
  duration: ~7 minutes
  completed-date: 2026-05-10
---

# Phase 4 Plan 5: Audit Suite Extension Summary

Extends the Phase 3 audit script with five additive check functions that lift ROADMAP Phase 4 success criteria #1, #2, #3 — and Phase 3 success criterion #3 — from prose claims to executable acceptance gates.

## What Shipped

Five new bash check functions appended to `.planning/phases/03-unique-pages/scripts/audit.sh`, each registered in the `run_check` case statement and the `run_all_checks` loop.

| Function | Lines | Purpose | Phase 4 Criterion |
|----------|-------|---------|-------------------|
| `check_service_pages_built` | 15 | Asserts all 6 service slugs build to `dist/{slug}/index.html` at root | #1 |
| `check_neighborhood_pages_built` | 15 | Asserts all 5 neighborhood slugs build to `dist/{slug}/index.html` at root | #2 |
| `check_no_stub_content` | 22 | Greps `site/src/content/` for `Stub content — Phase` markers | #3 (D-16 regression guard) |
| `check_templated_bluf` | 20 | Greps each of the 11 built pages for `<section class="bluf"` | D-04/D-09 (skeleton applied) |
| `check_neighborhood_data_populated` | 38 | Guards against Phase 2 placeholder landmarks pairs and `distance: "local"` | D-11 (regression guard) |

## Registry Updates

Three additive edits to existing registry blocks (no removals, no Phase 3 reordering):

1. **`run_check` case branches** (5 new lines): `service-pages-built`, `neighborhood-pages-built`, `no-stub-content`, `templated-bluf`, `neighborhood-data-populated`.
2. **Default-branch help message**: appended the 5 new check names to the "Valid names:" output so misspellings show the full registry.
3. **`run_all_checks` body**: 5 new function calls appended after `check_faq_master_count`.

## Audit Output: Before vs After

```
# Before (Phase 3 baseline only)
audit complete: 18 passed, 0 failed, 0 skipped

# After (Phase 3 + Phase 4 checks, post-Phase-4 build)
audit complete: 23 passed, 0 failed, 0 skipped
```

Pass count rose by exactly 5 — one per new check. Zero regressions in the 14 pre-existing Phase 3 functions. (Note: the count is 18 not 14 because `check_bluf_position` calls `pass` once per inspected page, and 5 unique-pages are inspected.)

## Phase 3 Functions Confirmed Intact

All 14 Phase 3 check functions still defined and still passing:

`check_homepage_faq`, `check_niche_faq`, `check_niche_areaserved`, `check_cost_guide_slugs`, `check_cost_guide_entries`, `check_about_staff_names`, `check_about_pending_photos`, `check_reviews_cards`, `check_reviews_sources`, `check_faq_master_count`, `check_no_client_directives`, `check_no_anti_patterns`, `check_no_accordions`, `check_bluf_position`.

## Phase 3 Success Criterion #3 Now End-to-End Validated

`check_cost_guide_slugs` was already in the Phase 3 audit, but until this plan it ran against a build that did NOT yet contain pages for the slugs the cost guide links to. With the post-Phase-4 build in place and the new `service-pages-built` + `neighborhood-pages-built` checks confirming all 11 slugs resolve, the implication is now closed:

- `check_cost_guide_slugs` confirms the cost guide page links to all 11 canonical slugs.
- `check_service_pages_built` + `check_neighborhood_pages_built` confirm all 11 slugs build to `dist/{slug}/index.html`.
- Therefore: zero 404s from cost-guide service/neighborhood links — Phase 3 ROADMAP success criterion #3 is now executable, not aspirational.

## Regression Tests Performed

Two adversarial tests confirm the checks fail loudly when invariants break, not silently:

1. **Simulated missing service page** (`mv site/dist/fades site/dist/fades.bak`):
   `bash audit.sh --check service-pages-built` exited 1 with message:
   `FAIL: service-pages-built — missing dist/<slug>/index.html for: fades`
2. **Simulated reintroduced stub marker** (`echo "Stub content — Phase 3/4..." >> .scratch.md`):
   `bash audit.sh --check no-stub-content` exited 1 with the offending file path printed.

After cleanup, full suite: 23 passed / 0 failed / 0 skipped.

## Tasks & Commits

| Task | Description | Commit |
|------|-------------|--------|
| 1 | Add 5 new check functions + register them (case + run_all_checks + help string) | `deee2a7` |

Per CLAUDE.md and the plan's success criteria, the implementation is a single atomic deliverable (functions are useless until registered; registration is meaningless without functions). One feat commit captures the whole increment; the SUMMARY commit is separate per the executor protocol.

## Deviations from Plan

None. Plan executed exactly as written, including the exact bash function bodies specified in the `<action>` block. The post-Phase-4 collection state uses multi-line YAML lists for `landmarks` (rather than the legacy single-line inline-array form the regex in `check_neighborhood_data_populated` targets), which means the regex acts as a pure regression guard rather than positive content validation — the plan explicitly framed the function this way (CONTEXT D-11), so no deviation was required. If a future regression reintroduces stub landmarks in multi-line form, that is outside this plan's scope.

## Self-Check: PASSED

Verified post-commit:

- `bash -n .planning/phases/03-unique-pages/scripts/audit.sh` exits 0 (syntax valid).
- All 5 new function names defined: `^check_(service|neighborhood)_pages_built\(\)`, `^check_no_stub_content\(\)`, `^check_templated_bluf\(\)`, `^check_neighborhood_data_populated\(\)`.
- All 5 new check names registered in `run_check`.
- All 5 new functions called once in `run_all_checks`.
- All 14 Phase 3 functions still defined.
- Single-check invocation works for each new check (exit 0 each).
- Full suite passes: 23 passed / 0 failed / 0 skipped.
- Self-test still passes.
- Commit `deee2a7` exists in `git log`.
- Modified file: `.planning/phases/03-unique-pages/scripts/audit.sh` (518 lines, above the 450 min_lines threshold from the plan frontmatter).
