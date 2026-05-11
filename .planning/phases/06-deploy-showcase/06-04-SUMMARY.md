---
phase: 06-deploy-showcase
plan: "04"
subsystem: schema-data
tags:
  - geo-correction
  - schema
  - business-json
  - aeo
dependency_graph:
  requires: []
  provides:
    - correct-shop-geo-coordinates
  affects:
    - site/src/components/schema/HairSalon.astro
    - all-built-pages
tech_stack:
  added: []
  patterns:
    - Single source of truth: business.json -> business.ts -> HairSalon.astro -> every page
key_files:
  created: []
  modified:
    - site/src/data/business.json
decisions:
  - "D-01 geo correction: use 32.8184653, -116.9516888 from maps.app.goo.gl/fgNmMDkXDYLKJnP68 — the real 723 E Bradley Ave #C pin, not the legacy 32.8211/-116.9303 value"
metrics:
  duration: "< 5 minutes"
  completed: "2026-05-11"
  tasks_completed: 1
  files_modified: 1
---

# Phase 06 Plan 04: Business Geo Correction Summary

Corrected `business.json` geo block from legacy approximate coordinates to the real shop pin (32.8184653, -116.9516888) — every page's HairSalon JSON-LD now emits the accurate location; audit gate stayed green at 36/0/0.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Update business.json geo coordinates to real shop location | 71c5645 | site/src/data/business.json |

## What Was Done

Changed two numeric values in `site/src/data/business.json` `geo` block:

| Field | Old Value | New Value |
|-------|-----------|-----------|
| latitude | 32.8211 | 32.8184653 |
| longitude | -116.9303 | -116.9516888 |

The source-of-truth file flows through `business.ts` -> `HairSalon.astro` -> every page at build time. All 17 built pages inherit the fix with no per-page changes needed.

## Verification Results

- JSON validity: PASS (`node -e "JSON.parse(...)"` exits 0)
- New latitude present in source: PASS (`"latitude": 32.8184653,`)
- New longitude present in source: PASS (`"longitude": -116.9516888`)
- Old coordinates absent from source: PASS (no `32.8211` or `-116.9303`)
- `npm run build` exit 0: PASS (17 pages built, Complete!)
- `dist/index.html` geo JSON-LD: `"geo":{"@type":"GeoCoordinates","latitude":32.8184653,"longitude":-116.9516888}`
- `dist/about/index.html` has new latitude: PASS (count=1)
- `dist/fades/index.html` has new latitude: PASS (count=1)
- Audit gate: PASS (36 passed, 0 failed, 0 skipped)

## Deviations from Plan

None — plan executed exactly as written.

## Wave 1 Completion Note

This is the final carryforward fix in Wave 1. All 4 D-0x items from Phase 5 are now landed as atomic commits:
- 06-01: CR-02 (about page copy corrections)
- 06-02: CR-03 (fades page corrections)
- 06-03: CR-04 (homepage corrections)
- 06-04: D-01 (geo coordinate correction)

Wave 2 (env-var setup + showcase deploy) can proceed.

## Self-Check: PASSED

- site/src/data/business.json: FOUND and contains correct coordinates
- Commit 71c5645: FOUND in git log
- Build dist/index.html: FOUND with correct geo coordinates
- Audit: 36/0/0 confirmed
