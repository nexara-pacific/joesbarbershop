---
phase: 03-unique-pages
plan: "06"
subsystem: pages
tags:
  - cost-guide
  - aeo
  - comparative-listicle
  - cross-links
dependency_graph:
  requires:
    - 03-00
    - 03-01
    - 03-03
    - 03-04
  provides:
    - PAGE-03
  affects:
    - roadmap-criterion-3
tech_stack:
  added: []
  patterns:
    - data-driven competitors.json import
    - scoped article-head/bluf/prose/entries/faq/see-also layout
    - data-host attribute for host-entry accent (audit-compatible)
key_files:
  created:
    - site/src/pages/2026-east-county-barbershop-cost-guide.astro
  modified: []
decisions:
  - "Used data-host attribute instead of entry-host class on <article> to satisfy audit.sh which greps for <article class=\"entry\"> exactly — host accent still applied via CSS .entry[data-host] rule"
metrics:
  duration: 8m
  completed: 2026-05-07
  tasks_completed: 2
  files_created: 1
---

# Phase 03 Plan 06: Cost Guide Page Summary

**One-liner:** Comparative-listicle cost guide for East County barbershop pricing, data-driven from competitors.json, with BLUF + prose + 4 FAQs + See-Also block covering all 11 Phase 4 slugs.

---

## Tasks Completed

| Task | Name | Status | Commit |
|------|------|--------|--------|
| 1 | Run copywriting skill for BLUF + intro prose + cost FAQs | Done | (in-context; embedded in Task 2 commit) |
| 2 | Create cost guide page with data-driven entries + see-also block | Done | feat(03-06) |

---

## Skill Output Sources Cited

- `.agents/aeo-frame.md` — AEO structural rules (BLUF first, 130–160w capsules, declarative tone, no hidden content)
- `.agents/product-marketing-context.md` — Joe positioning, voice rules, banned phrases, heritage barbershop register
- `site/src/data/competitors.json` — 4 entries (Joe's host + 3 real competitors) drove price spectrum framing
- `site/src/data/business.json` — specific price verification ($30 haircut, $30 shave, $20 beard line-up, $15 clean-up, $50 haircut+beard)

---

## BLUF First Sentence (strong-wrapped)

> "Barbershop prices in East County, San Diego range from $15 to $50 in 2026 — with traditional walk-in shops anchored at $30 for a standard haircut."

---

## Cost FAQ Topics (4 questions)

1. **Why is $30 the base price in East County?** — strip-mall overhead, cash-only = no processing fee, stable since 2020
2. **Do East County barbershops take cards?** — most do; Joe's is cash-only with ATM on site; Clipper Crew takes cards/Zelle
3. **Does a walk-in haircut cost more than booking an appointment?** — no; difference is wait time not price; appointment-only shops tend toward higher bases due to lower volume
4. **What's the cheapest haircut in El Cajon versus the most expensive?** — $15 clean-up at Joe's at low end; $50–$75 grooming lounges at high end; kids-cuts and hot-towel-shave cross-links included

---

## Inline Cross-Links in Prose

Prose section contains 6 canonical inline cross-links:
- `/fades` (paragraph 1)
- `/classic-cut` (paragraph 1)
- `/beard-trim` (paragraph 1)
- `/hot-towel-shave` (paragraph 2)
- `/line-up` (paragraph 2)
- `/bostonia-barber` (paragraph 2)

FAQ 4 also contains 2 additional inline cross-links:
- `/kids-cuts`
- `/hot-towel-shave`

**Total inline cross-links: 8** (target was ≥ 3 service + ≥ 1 neighborhood — exceeded)

---

## See-Also Block Coverage

All 11 canonical Phase 4 slugs present in See-Also block:

**Services (6):** fades, classic-cut, kids-cuts, beard-trim, line-up, hot-towel-shave

**Neighborhoods (5):** bostonia-barber, el-cajon-barber, santee-barber, lakeside-barber, la-mesa-barber

`audit.sh --check cost-guide-slugs` confirms all 11 present as href attributes in built HTML.

---

## Entry Card Confirmation

- **Total entries:** 4 (from competitors.json)
- **Host entry (Joe's):** 1 — accent left-border applied via `[data-host]` CSS selector
- **Archetype entries:** 0 — Plan 03 (03-03) delivered 4 real entries; no fallback archetypes needed
- All entries rendered from `competitors.json` import; no inline competitor data duplication

---

## Archetype Entry Handling

competitors.json has no `archetype: true` entries (Plan 03 Path A — 4 real entries scraped). The `data-archetype` attribute is handled but no entries triggered it. This path remains available if data is updated.

---

## Hallucination Spot-Check Log

| Claim | Source Verified |
|-------|----------------|
| "range from $15 to $50 in 2026" | business.json: prices.cleanUp=15, prices.haircutBeard=50 — CONFIRMED |
| "$30 for a standard haircut" | business.json: prices.haircut=30 — CONFIRMED |
| "$30 for a straight-razor shave" | business.json: prices.shave=30 — CONFIRMED |
| "$20 for a beard line-up" | business.json: prices.beardLineUp=20 — CONFIRMED |
| "$15 for a clean-up" | business.json: prices.cleanUp=15 — CONFIRMED |
| "$25–$45 at a chain or volume shop" | Editorial range; competitors.json shows all 3 competitors as "unknown" price range — framed as editorial market context, not competitor-specific data |
| "$40–$75 at grooming lounges" | Editorial range; no grooming lounge in competitors.json — framed as general market context |
| "Clipper Crew accept cards and Zelle" | competitors.json differentiator field: "Accepts credit cards and Zelle" — CONFIRMED |
| "$50 haircut-plus-beard combo" | business.json: prices.haircutBeard=50 — CONFIRMED |

---

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] data-host attribute instead of entry-host class for audit compatibility**
- **Found during:** Task 2 verify — audit.sh checks `<article class="entry"` exactly; host entry had `class="entry entry-host"` which the grep doesn't match
- **Issue:** audit.sh line 104 uses `grep -o '<article class="entry"'` — exact string match. entry-host class appended after "entry" breaks the match for the first (host) entry, reporting 3 instead of 4
- **Fix:** Changed `class="entry entry-host"` to `class="entry" data-host="true"` for the host entry; CSS updated to `.entry[data-host]` selector for accent styling — functionally identical, audit-compatible
- **Files modified:** `site/src/pages/2026-east-county-barbershop-cost-guide.astro`
- **Commit:** included in feat(03-06) commit

### Pre-existing Out-of-Scope Issue

- `bluf-position` audit check fails for `about/index.html` — the about page (Plan 03-05) does not have a `<section class="bluf">` element. This predates Plan 03-06 and is out of scope. Logged to deferred-items.

---

## For Plan 09 (FAQ Master): Cost FAQ Topics to Include or Distinct

The 4 cost FAQs in this page:
1. Why is $30 the base price in East County?
2. Do East County barbershops take cards?
3. Does a walk-in haircut cost more than booking an appointment?
4. What's the cheapest haircut in El Cajon versus the most expensive?

FAQ master (Plan 09) should either: (a) link to this page for cost-related questions, or (b) include distinct cost questions that don't duplicate these verbatim. Topics 2 (cards) and 3 (walk-in pricing) overlap with general FAQ topics — Plan 09 can reuse the same answers with entity-explicit wording.

---

## Verification Results

| Check | Result |
|-------|--------|
| `npm run build` exits 0 | PASS |
| `audit.sh --check cost-guide-slugs` | PASS — all 11 slugs present |
| `audit.sh --check cost-guide-entries` | PASS — 4 entries found |
| `audit.sh --check no-anti-patterns` | PASS |
| `audit.sh --check no-accordions` | PASS |
| `audit.sh --check no-client-directives` | PASS |
| `audit.sh --check bluf-position` (cost guide) | PASS (about page pre-existing failure is out of scope) |
| `entry-host` accent on Joe's entry | PASS — `data-host="true"` + `.entry[data-host]` CSS |
| See-Also block both columns | PASS — 6 services + 5 neighborhoods |

---

## Threat Surface Scan

No new network endpoints, auth paths, file access patterns, or schema changes introduced. Page is static Astro with compile-time JSON import. No new threat surface.

---

## Self-Check: PASSED

- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` — FOUND
- `site/dist/2026-east-county-barbershop-cost-guide/index.html` — FOUND
- All 11 canonical slugs in built HTML — CONFIRMED by audit
- 4 entry articles — CONFIRMED by audit
- 1 host entry with data-host — CONFIRMED
