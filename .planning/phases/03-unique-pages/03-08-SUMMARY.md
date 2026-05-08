---
phase: 03-unique-pages
plan: "08"
subsystem: pages
tags:
  - reviews
  - aeo
  - page

dependency_graph:
  requires:
    - "03-00 (Base layout)"
    - "03-02 (reviews.json)"
    - "03-04 (ClosingCTA)"
  provides:
    - "PAGE-05 — /reviews page with 6-8 review cards"
  affects:
    - "Phase 5 schema injection — review cards are schema-ready (name/rating/quote/source/date)"

tech_stack:
  added: []
  patterns:
    - "JSON-driven card grid via reviews.map()"
    - "Scoped CSS article-head + BLUF capsule + review-grid pattern"
    - "2-col → 2-col → 1-col responsive grid breakpoints (980px, 600px)"

key_files:
  created:
    - site/src/pages/reviews.astro
  modified: []

decisions:
  - "D-10 fallback: reviews.json contained 4 real Yelp + 4 Google placeholders; rendered all 8 — intentional per plan"
  - "reviewer H3 font-size: clamp(20px, 2vw, 24px) — UI-SPEC specifies 20px fixed; used clamp with 20px floor to match spec intent at /reviews H3 size token"
  - "BLUF uses business.ratings arithmetic directly in JSX expression (count + count) — dynamic, not hardcoded"

metrics:
  duration: "< 10 min"
  completed_date: "2026-05-08"
  tasks_completed: 2
  files_created: 1
---

# Phase 03 Plan 08: Reviews Page Summary

Built `/reviews` at `site/src/pages/reviews.astro`. Data-driven review card grid with BLUF answering primary query "Joe's Barbershop reviews / ratings" using exact rating values from business.json.

## What Was Built

- Article header with eyebrow "Reviews · Google + Yelp", H1 "What customers say.", datestamp "UPDATED MAY 2026"
- BLUF capsule: first sentence in `<strong>`, rating numbers interpolated from `business.ratings.*` — no hardcoding
- 2-column review grid (desktop + tablet ≤980px), 1-column at ≤600px
- 8 review cards: 4 real Yelp reviews + 4 Google placeholder cards (Plan 02 D-10 path B)
- ClosingCTA component
- NO FAQ component, NO `<blockquote>`, NO Hero/FactStrip/PriceBoard/Heritage/Visit

## Task 1: BLUF Copy (in-context, no file write)

BLUF generated inline per marketing-skills:copywriting guidance:

**First sentence (strong-wrapped):** "Joe's Barbershop is rated 4.9★ across 91 Google reviews and 33 Yelp reviews — 124 verified ratings from East County customers."

Rating values used (verified against business.json):
- `ratings.google.value`: 4.9
- `ratings.google.count`: 91
- `ratings.yelp.value`: 4.9
- `ratings.yelp.count`: 33
- Combined: 124 (91 + 33, computed in JSX)

Banned-phrase check: PASS — no "experience the difference", "we're more than a barbershop", "discover", "click here", "we might", "could potentially".

## Task 2: reviews.astro

**Card count:** 8 (6-8 range satisfied)

**Google / Yelp split:**
- 4 Yelp (real, extracted): Javier H., Jay W., Daniel V., Larry A.
- 4 Google (placeholder per D-10 path B): `[Reviewer name pending]` / `[Quote pending — extracted at showcase]`

**Plan 02 path:** Path B (mixed) — 4 real Yelp + 4 Google placeholders. Both source labels appear in built HTML. Placeholder presence is intentional per T-03-08-03 (accepted risk).

**Structural invariants confirmed:**
- NO `<FAQ />` component imported or rendered
- NO `<blockquote>` element — review quotes use `<p class="review-quote">` with inline curly quotes
- NO Hero / FactStrip / PriceBoard / Heritage / Visit
- NO `client:*` directives
- NO `<details>` / accordion markup
- BLUF precedes reviews-section (bluf-position audit: PASS)
- Source labels: plain `var(--muted)` — no Google-blue / Yelp-red brand colors

## Verification Results

| Check | Result |
|-------|--------|
| `npm run build` | PASS (exit 0) |
| `audit.sh --check reviews-cards` | PASS (8 cards) |
| `audit.sh --check reviews-sources` | PASS (Google + Yelp both present) |
| `audit.sh --check no-anti-patterns` | PASS |
| `audit.sh --check no-accordions` | PASS |
| `audit.sh --check no-client-directives` | PASS |
| `audit.sh --check bluf-position` | PASS (faq skip expected) |
| No `<blockquote>` in built HTML | PASS |
| No `faq-q` in built HTML | PASS |
| Rating 4.9 / 91 / 33 in built HTML | PASS |

## Phase 5 Readiness

Each review card renders: reviewer name, star rating (as visible `★` glyphs), platform source (Google/Yelp), date if available. Structure maps cleanly to `Review` schema:
- `reviewRating.ratingValue` ← `r.rating`
- `reviewBody` ← `r.quote`
- `author.name` ← `r.name`
- `publisher.name` ← `r.source`
- `datePublished` ← `r.date`

## Deviations from Plan

None — plan executed exactly as written.

## Known Stubs

| File | Stub | Reason |
|------|------|--------|
| `site/src/data/reviews.json` | 4 Google cards show `[Reviewer name pending]` / `[Quote pending]` | D-10 path B: Google Maps review content blocked by JS gating at time of extraction; placeholder cards intentional per `_showcase_review_pending` marker in business.json |

Placeholder cards are intentional and tracked in `business.json._showcase_review_pending`. Layout and data shape are stable for Phase 5 schema wrapping. Real Google quotes to be swapped at showcase.

## Threat Flags

None. No new network endpoints, auth paths, or schema changes at trust boundaries introduced.

## Self-Check: PASSED

- `site/src/pages/reviews.astro` exists: FOUND
- Commit `ad41e2e` exists: FOUND
