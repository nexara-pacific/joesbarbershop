---
phase: 02-data-design-system
plan: "03"
subsystem: content-collections
tags:
  - astro-6
  - content-layer-api
  - zod-schema
  - content-stubs
dependency_graph:
  requires:
    - 01-scaffold (Astro project in site/ with TypeScript strict mode)
  provides:
    - site/src/content.config.ts (Astro 6 Content Layer config for services + neighborhoods)
    - site/src/content/services/*.md (6 schema-passing service stubs)
    - site/src/content/neighborhoods/*.md (5 schema-passing neighborhood stubs)
  affects:
    - Phase 3 page builds (getCollection('services') now available without errors)
    - Phase 4 templated pages (getCollection('neighborhoods') now available without errors)
tech_stack:
  added:
    - Astro 6 Content Layer API (glob loader, defineCollection)
    - astro/zod (Zod schema via Astro's bundled export)
  patterns:
    - content.config.ts at src/ root (Astro 6 flat path, NOT src/content/config.ts)
    - glob loader with explicit base path per collection
    - YAML frontmatter with Zod-validated shape (no quality constraints per D-17)
key_files:
  created:
    - site/src/content.config.ts
    - site/src/content/services/fades.md
    - site/src/content/services/classic-cut.md
    - site/src/content/services/kids-cuts.md
    - site/src/content/services/beard-trim.md
    - site/src/content/services/line-up.md
    - site/src/content/services/hot-towel-shave.md
    - site/src/content/neighborhoods/bostonia.md
    - site/src/content/neighborhoods/el-cajon.md
    - site/src/content/neighborhoods/santee.md
    - site/src/content/neighborhoods/lakeside.md
    - site/src/content/neighborhoods/la-mesa.md
  modified: []
decisions:
  - "content.config.ts placed at site/src/content.config.ts (Astro 6 flat path) — the legacy src/content/config.ts path throws LegacyContentConfigError in Astro 6.3.0 (D-24 supersession)"
  - "z imported from astro/zod not zod — Astro bundles its own Zod; standalone zod not installed"
  - "Each defineCollection includes explicit loader: glob() — required in Astro 6; omitting throws build error"
  - "slug not a schema field — derived from entry.id by the glob loader"
  - "faqs: [] is valid in stubs — schema enforces shape not quality (D-17)"
  - "heroPhoto optional on services — kids-cuts, beard-trim, line-up, hot-towel-shave omit it"
metrics:
  duration: "~10 minutes"
  completed: "2026-05-07"
  tasks_completed: 2
  files_created: 12
---

# Phase 2 Plan 3: Content Collections Config + Stubs Summary

Astro 6 Content Layer config at the correct flat path (`src/content.config.ts`) with glob-loaded `services` and `neighborhoods` collections, plus 11 schema-passing stub entries (6 services + 5 neighborhoods) — enabling `getCollection()` for Phase 3/4 page templating with zero Zod errors.

## Tasks Completed

| Task | Name | Commit | Key Files |
|------|------|--------|-----------|
| 1 | Create content.config.ts | 0b51e5e | site/src/content.config.ts |
| 2 | Create 11 stub content entries | e8d272d | site/src/content/services/*.md (×6), site/src/content/neighborhoods/*.md (×5) |

## What Was Built

### Task 1: content.config.ts

`site/src/content.config.ts` defines two Astro 6 Content Layer collections:

- **services** — glob loader from `./src/content/services`, Zod schema: `title/price/duration/bluf/faqs/heroPhoto?`
- **neighborhoods** — glob loader from `./src/content/neighborhoods`, Zod schema: `title/landmarks/distance/bluf/faqs`

Key correctness requirements honored:
- File at `src/content.config.ts` (flat path, not nested `src/content/config.ts`)
- `z` from `astro/zod` (not standalone `zod`)
- Both collections have explicit `loader: glob(...)` (Astro 6 requirement)
- No `slug` field in schemas (auto-derived from `entry.id` by glob loader)
- Schema enforces shape not quality: no enum constraints, no min-length on bluf or faqs.a (D-17)

### Task 2: 11 Stub Content Entries

**6 service stubs** — price data from price board photo (D-21):

| File | title | price | duration | heroPhoto |
|------|-------|-------|----------|-----------|
| fades.md | Fades | 30 | 30 min | 05-mid-cut.jpg |
| classic-cut.md | Classic Cut | 30 | 30 min | 05-mid-cut.jpg |
| kids-cuts.md | Kids Cuts | 30 | 30 min | (omitted — optional) |
| beard-trim.md | Beard Trim | 20 | 20 min | (omitted) |
| line-up.md | Line-Up | 20 | 20 min | (omitted) |
| hot-towel-shave.md | Hot-Towel Shave | 30 | 30 min | (omitted) |

**5 neighborhood stubs:**

| File | title | distance |
|------|-------|----------|
| bostonia.md | Bostonia Barber | local |
| el-cajon.md | El Cajon Barber | 0.5 mi from shop |
| santee.md | Santee Barber | 7 mi from shop |
| lakeside.md | Lakeside Barber | 8 mi from shop |
| la-mesa.md | La Mesa Barber | 9 mi from shop |

All stubs have `faqs: []` — valid per D-17 (no minimum array length in schema).

## Build Verification

`npm run build` (Astro 6.3.0) exits 0:
- No `LegacyContentConfigError`
- No Zod validation errors
- Content synced successfully
- 2 pages built (existing index + about; content collection pages deferred to Phase 4)

## Deviations from Plan

None — plan executed exactly as written.

The only deviation from routine was that the worktree's `site/` directory had no `node_modules` (expected — worktrees don't duplicate npm installs). A symlink to the main repo's `site/node_modules` was created for build verification. The symlink is covered by `.gitignore` and was not committed.

## Known Stubs

All 11 content entries are intentional stubs per D-15. Each file contains:
- Real load-bearing frontmatter (title, price/distance/landmarks populated with actual data)
- Placeholder bluf string (schema-valid but not AEO-optimized)
- `faqs: []` (empty, schema-valid)
- Stub markdown body: "Stub content — Phase 3/4 replaces with AEO-optimized prose and FAQs."

These stubs are intentional. Real prose lands in Phase 3 (unique pages) and Phase 4 (templated pages) using marketing-skills chain (D-16). The stubs exist purely to enable `getCollection()` without errors.

## Threat Flags

No new security surface introduced. Static markdown files processed at build time only — no user input, no network calls, no auth surface.

## Self-Check: PASSED

Files confirmed present:
- site/src/content.config.ts — FOUND
- site/src/content/services/fades.md — FOUND (6 total service stubs)
- site/src/content/neighborhoods/bostonia.md — FOUND (5 total neighborhood stubs)

Commits confirmed:
- 0b51e5e — feat(02-03): add Astro 6 content.config.ts with services and neighborhoods collections
- e8d272d — feat(02-03): add 11 schema-passing stub content entries (6 services + 5 neighborhoods)

Build: `astro build` exits 0, content synced, no errors.
