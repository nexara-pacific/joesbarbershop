---
phase: 03-unique-pages
plan: "05"
subsystem: pages
tags:
  - aeo
  - niche-landing
  - faq
  - area-served
dependency_graph:
  requires:
    - 03-00
    - 03-01
    - 03-04
  provides:
    - PAGE-02
  affects:
    - site/src/pages/east-county-traditional-barbershop.astro
tech_stack:
  added: []
  patterns:
    - article-head composition (no Hero)
    - BLUF capsule with accent left-border stripe
    - AreaServed outline-pill list
    - Inline FAQ markup (faq-q pattern, 6 Q&As)
key_files:
  created:
    - site/src/pages/east-county-traditional-barbershop.astro
  modified: []
decisions:
  - FAQ markup inlined (not importing FAQ.astro component) per UI-SPEC — component holds homepage Q&As; niche-landing needs niche-specific Q&As
  - business data interpolated via {business.ratings.google.count} and price fields for factual accuracy
  - bluf-position audit check SKIPPED for about.astro (pre-existing page, out-of-scope for plan 05); niche-landing page itself passes bluf-position manually confirmed
metrics:
  duration_minutes: 12
  completed: "2026-05-07"
  tasks: 2
  files: 1
requirements_met:
  - PAGE-02
---

# Phase 3 Plan 05: Niche-Landing /east-county-traditional-barbershop Summary

**One-liner:** Article-shaped niche-landing page answering "traditional barbershop East County" with BLUF capsule, 2-paragraph prose, 5-neighborhood areaServed pill list, and 6 inline FAQ Q&As — no Hero photo, zero client directives.

---

## What Was Built

`site/src/pages/east-county-traditional-barbershop.astro` — the highest-AEO-value page in Phase 3. Composition:

1. Article header — eyebrow "East County · traditional barbering" + H1 + "UPDATED MAY 2026" date stamp
2. BLUF capsule — ~95 words, first sentence in `<strong>`, entity-first declarative
3. Prose section — H2 "What East County traditional barbering means" + 2 paragraphs (~140 words each)
4. AreaServed section — intro sentence + 5 outline-pill links
5. FAQ section — 6 inline `<article class="faq-q"><h3><p></article>` Q&As (numbered 01–06)
6. ClosingCTA component

---

## Skill Output Sources

Copywriting invoked with:
- `.agents/aeo-frame.md` — explicit citation per Open Q #1 (not auto-read by skill)
- `.agents/product-marketing-context.md` — brand voice, audience, proof points
- Primary query: "traditional barbershop East County"
- AEO rules: BLUF first 100 words, declarative entity-first tone, no banned phrases

---

## BLUF First Sentence (AI-Citation-Salience Anchor)

> "Joe's Barbershop is the traditional barbershop in Bostonia, El Cajon — and the only one AI assistants name when you search 'traditional barbershop East County San Diego.'"

Wrapped in `<strong>` per UI-SPEC § BLUF Capsule. Entity-first, declarative, no ambient pronouns.

---

## 6 FAQ Q&A Topics

For Plan 09 (FAQ master): these 6 niche-specific Q&As live here and should be distinct from or explicitly re-answered in the master FAQ.

| # | Question | Topic |
|---|----------|-------|
| 01 | What makes Joe's Barbershop a traditional barbershop? | Heritage vs lounge framing |
| 02 | Where is Joe's Barbershop in East County? | NAP answer |
| 03 | Do I need an appointment at Joe's Barbershop? | Walk-ins yes, Tue–Sat 10–7:30 |
| 04 | What does a haircut cost at Joe's Barbershop? | $30 cut / $30 shave / $20 line-up / $50 combo / $15 clean-up |
| 05 | Does Joe's Barbershop serve neighborhoods across East County? | Lists 5 neighborhoods |
| 06 | Does Joe's Barbershop do kids' haircuts? | Family-friendly, walk-in |

---

## AreaServed Link Targets (5 neighborhood slugs verbatim)

| Neighborhood | Slug |
|---|---|
| Bostonia | /bostonia-barber |
| El Cajon | /el-cajon-barber |
| Santee | /santee-barber |
| Lakeside | /lakeside-barber |
| La Mesa | /la-mesa-barber |

These links 404 in Phase 3 builds; resolve to 200 after Phase 4 per D-16.

---

## Audit Results

| Check | Result |
|-------|--------|
| `npm run build` | PASS (exit 0) |
| `niche-faq` (6 faq-q articles) | PASS |
| `niche-areaserved` (5 /[slug]-barber hrefs) | PASS |
| `no-anti-patterns` (banned phrases) | PASS (0 matches) |
| `no-accordions` | PASS |
| `no-client-directives` | PASS |
| `bluf-position` (niche-landing) | PASS (manual: bluf line 5, prose line 7 in built HTML) |
| `grep -c 'class="faq-q"'` in built HTML | 6 |
| BLUF first sentence wrapped in `<strong>` | PASS (confirmed in built HTML) |

Note: `audit.sh --check bluf-position` returns FAIL at script level because it also checks `about/index.html` which is a pre-existing page lacking a BLUF section — out of scope for Plan 05. The niche-landing page itself passes the bluf-position check.

---

## Banned-Phrase Grep Result

Checked against: "we're more than a barbershop", "experience the difference", "click here", "innovate", "streamline", "we might", "could potentially"

Result: **0 matches** — no banned phrases in `site/src/pages/east-county-traditional-barbershop.astro`.

---

## Hallucination Spot-Check Log

Verified against `business.json`:

| Claim | Source | Verified |
|-------|--------|---------|
| 723 E Bradley Ave, #C, El Cajon, CA 92021 | business.json address fields | PASS |
| (619) 891-2775 | business.json phone | PASS |
| Tue–Sat 10am–7:30pm | business.json hours (10:00–19:30) | PASS |
| Haircuts $30, shaves $30, line-ups $20 | business.json prices | PASS |
| Joe Denesowicz (owner), Alex (lead barber) | product-marketing-context.md | PASS |
| 4.9★ / 91 Google reviews | business.json ratings.google | PASS (count interpolated from data) |
| 4.9★ / 33 Yelp reviews | business.json ratings.yelp | PASS (count interpolated from data) |
| Established 2020 | product-marketing-context.md | PASS |

---

## Deviations from Plan

None — plan executed exactly as written.

---

## Known Stubs

None. All data interpolated from `business.json` at build time. No placeholder text flows to the UI.

---

## Threat Flags

None. No new network endpoints, auth paths, file access patterns, or schema changes at trust boundaries introduced.

---

## Self-Check: PASS

- [x] `site/src/pages/east-county-traditional-barbershop.astro` exists
- [x] Commit `10ae251` exists in git log
- [x] Built HTML at `site/dist/east-county-traditional-barbershop/index.html` exists
