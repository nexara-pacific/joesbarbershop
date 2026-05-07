---
phase: 02-data-design-system
plan: "02"
subsystem: data
tags:
  - business-data
  - typescript
  - json
  - nap
  - astro
dependency_graph:
  requires:
    - 01-scaffold
  provides:
    - site/src/data/business.json
    - site/src/data/business.ts
  affects:
    - all components that render NAP, hours, prices, ratings
tech_stack:
  added: []
  patterns:
    - JSON canonical data source with typed TypeScript re-export
    - _showcase_review_pending pattern for flagging unconfirmed values
key_files:
  created:
    - site/src/data/business.json
    - site/src/data/business.ts
  modified: []
decisions:
  - "hours Tue-Sat 10:00-19:30 from vault baseline; Sat 18:30 discrepancy from mockup flagged for Joe's GBP confirmation"
  - "haircutBeard=50 cited from inputs/00-brief.md L25 Square Site listing; flagged for showcase confirmation"
  - "kidsCut=null — not present in any input source; flagged for showcase"
  - "sameAs.gbp is placeholder URL — GBP canonical URL requires login; flagged for showcase"
  - "_showcase_review_pending field added to BusinessRecord interface as optional string[] for grep-discoverability"
metrics:
  duration: "~10 minutes"
  completed: "2026-05-07"
  tasks_completed: 1
  tasks_total: 1
  files_changed: 2
requirements:
  - DATA-01
---

# Phase 2 Plan 02: Business Data Source of Truth Summary

Single-sentence summary: Canonical business.json with NAP/hours/prices/ratings/sameAs/photos/areaServed and typed business.ts re-export, with grep-discoverable TBD markers for all values pending Joe's showcase confirmation.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 2 | Create business.json and business.ts | e09c8d9 | site/src/data/business.json, site/src/data/business.ts |

(Task 1 was a checkpoint:human-verify pre-resolved by user — skipped per objective.)

## What Was Built

- `site/src/data/business.json` — canonical data file with all 9 DATA-01 fields: name, address, phone, hours, prices, ratings, sameAs, photos, areaServed. Includes `_showcase_review_pending` array listing 6 values flagged for Joe's confirmation at showcase.
- `site/src/data/business.ts` — typed re-export with `HoursEntry` and `BusinessRecord` interfaces. `BusinessRecord` includes all 9 data fields plus optional `_showcase_review_pending?: string[]`. Exports `business` constant as typed view of the JSON.

## Data Sources

| Field | Source | Confidence |
|-------|--------|------------|
| NAP (name/address/phone) | vault joes-barbershop-sandbox.md audit baseline | high |
| Hours Tue-Fri | vault baseline: 10:00-19:30 | high |
| Hours Saturday close | vault says 19:30, mockup shows 18:30 | flagged — pending GBP |
| Hours Sun/Mon | closed (null) | high |
| prices.haircut/shave/beardLineUp/cleanUp | inputs/03-photo-notes.md price board photo | high |
| prices.haircutBeard | inputs/00-brief.md L25 "Square Site adds Haircut + Beard $50" | medium — flagged |
| prices.kidsCut | not in any input | null — flagged |
| ratings | inputs/00-brief.md L23 (4.9★/91 Google, 4.9★/33 Yelp) | high |
| sameAs.gbp | placeholder — GBP login required | flagged |
| sameAs.yelp | best-effort canonical URL | flagged |
| sameAs.instagram | from brief context | medium |
| sameAs.facebook | empty — no FB page found | flagged |

## Deviations from Plan

None — plan executed exactly as written. Task 1 (checkpoint) was pre-resolved by user per objective instructions. haircutBeard=50 was set (not null) because inputs/00-brief.md L25 provides explicit citation: "Square Site adds Haircut + Beard $50" — this satisfies the plan's requirement to cite evidence before using 50 rather than null.

## Known Stubs

None that prevent the plan's goal. The `_showcase_review_pending` field is intentionally an audit trail, not a stub — the data values are populated (not empty). The flagged values are best-effort baselines that Joe will confirm or correct at showcase time.

## Threat Flags

None. business.json contains only public business information (NAP, hours, prices). No PII, no credentials, no network surface.

## Self-Check: PASSED

- `site/src/data/business.json` exists: FOUND
- `site/src/data/business.ts` exists: FOUND
- commit e09c8d9 exists: FOUND
- build passes (npm run build exits 0): CONFIRMED
- `_showcase_review_pending` in business.json: 1 match CONFIRMED
- `haircutBeard": 50` in business.json: CONFIRMED
- no `@type`/`@context` in business.ts: CONFIRMED
- `export const business` in business.ts: CONFIRMED
- `BusinessRecord` occurrences >= 2 in business.ts: 2 CONFIRMED
