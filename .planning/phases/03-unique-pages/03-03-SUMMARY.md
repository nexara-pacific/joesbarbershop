---
phase: 03-unique-pages
plan: "03"
subsystem: data
tags: [firecrawl, competitors, json, aeo, cost-guide]

requires:
  - phase: 03-02
    provides: "business.json baseline with _showcase_review_pending, .firecrawl gitignore"

provides:
  - "site/src/data/competitors.json — 4-record competitor array (3 real scraped + Joe's host entry) with {name, host, address, phone, hours, priceRange, rating, quote, differentiator} schema"
  - "Wave 3 cost guide page build (/2026-east-county-barbershop-cost-guide) unblocked — import competitors from '../data/competitors.json'"

affects: ["03-06-cost-guide-page-build", "wave-3-page-build"]

tech-stack:
  added: []
  patterns: ["Firecrawl search → Yelp/Booksy scrape → curation → JSON — real NAP extracted from public surfaces; phone hidden behind JS walls treated as empty string per anti-fabrication gate"]

key-files:
  created:
    - "site/src/data/competitors.json"
  modified: []

key-decisions:
  - "Path A taken: 3 real competitors with usable address extracted (Ducky's 237 reviews, Clipper Crew 106, Artists 28); Joe's as host = 4 total entries"
  - "Phone fields empty string for all real competitors — Yelp hides phone behind JS 'Click to reveal'; address confirmed for all 3, so anti-fabrication gate passes (drops only entries missing BOTH address AND phone)"
  - "priceRange set to 'unknown' for all real competitors — no menu/price board data visible in Yelp scrapes; Joe's host entry uses exact business.json price data"
  - "GeloFadez (4.9★ Booksy) excluded — mobile service, appointment-only, no hours listed; insufficient data for cost comparison page"

patterns-established:
  - "competitors.json schema: [{name, host, address, phone, hours, priceRange, rating, quote, differentiator, archetype?}] — Wave 3 maps directly into <article class={`entry ${c.host ? 'entry-host' : ''}`}>"

requirements-completed: ["PAGE-03"]

duration: 6min
completed: "2026-05-08"
---

# Phase 03 Plan 03: Competitor Scrape Summary

**Firecrawl search + 6 candidate scrapes yielded 3 real East County competitors with confirmed addresses; Path A taken; competitors.json ready for Wave 3 cost guide build**

## Performance

- **Duration:** 6 min
- **Started:** 2026-05-08T04:23:00Z
- **Completed:** 2026-05-08T04:29:16Z
- **Tasks:** 2
- **Files modified:** 1

## Path Taken

**Path A — real-extraction success** (≥3 real competitors with usable NAP)

Final array: Joe's Barbershop (host) + 3 real scraped competitors = 4 entries. No archetype entries. No `_showcase_review_pending` addition to business.json.

## Search Outcomes

| Query | URLs Returned | Useful Business URLs | Action |
|-------|--------------|---------------------|--------|
| "best barbershops near 723 E Bradley Ave El Cajon CA" | 8 | 3 direct competitor sites + Yelp search page | Primary search only; no alt searches needed |

Primary search hit count: 8 results. 5+ unique businesses identified (Ducky's, Clipper Crew, Mr. Blendz, 619 Fades, plus Yelp list with Artists, T25, S&N, Mr Cut). No alt searches were needed.

## Per-Candidate Scrape Outcomes

| Candidate | Source URL | Lines | NAP Signal | Result | Notes |
|-----------|-----------|-------|-----------|--------|-------|
| Ducky's Barber Shop | yelp.com/biz/duckys-barber-shop-el-cajon | 624 | address ✓, phone hidden (JS), rating ✓ | KEPT | 4.7★ · 237 Yelp; highest review count; address 941 Broadway Ste L |
| Clipper Crew Barber Shop | yelp.com/biz/clipper-crew-barber-shop-el-cajon | 3718 | address ✓, phone hidden (JS), rating ✓ | KEPT | 4.1★ · 106 Yelp; walk-ins, extended hours; address 700 N Johnson Ave |
| Clipper Crew website | clippercrewbarbershop.com | 265 | partial | SECONDARY | Used Yelp page as primary source |
| Mr. Blendz website | mrblendzz.com | 162 | phone ✓ via href, address MISSING | DROPPED | Anti-fabrication: only phone (619) 834-7200, no street address on website; Yelp slugs failed to resolve |
| 619 Fades Barbershop | yelp.com/biz/619-fades-barbershop-el-cajon | 714 | address partial, phone hidden, 1 review | DROPPED | Only 1 review; insufficient signal for cost comparison |
| Artists Barber Shop | yelp.com/biz/artists-barber-shop-el-cajon | 3288 | address ✓, phone hidden (JS), rating ✓ | KEPT | 4.1★ · 28 Yelp; walk-ins, 7 days; address 433 E Main St |
| GeloFadez | booksy.com (primary) | 80 | address ✓, no phone, no hours | EXCLUDED | 4.9★ Booksy but mobile service, appointment-only; no useful hours for cost comparison |
| Booksy El Cajon list | booksy.com/en-us/s/barber-shop/102009_el-cajon | 5427 | multiple addresses | REFERENCE | Used to confirm addresses; GeloFadez, Sambo, Artists identified |

## Competitor Data

**4 entries in competitors.json:**

| # | Name | Type | Address | Rating | Source |
|---|------|------|---------|--------|--------|
| 1 | Joe's Barbershop | host | 723 E Bradley Ave, Ste C, El Cajon CA 92021 | 4.9★ · 91 Google | business.json |
| 2 | Ducky's Barber Shop | real | 941 Broadway, Ste L, El Cajon CA 92021 | 4.7★ · 237 Yelp | competitor-duckys.md |
| 3 | Clipper Crew Barber Shop | real | 700 N Johnson Ave, Ste B, El Cajon CA 92020 | 4.1★ · 106 Yelp | competitor-clippercrew-yelp.md |
| 4 | Artists Barber Shop | real | 433 E Main St, El Cajon CA 92020 | 4.1★ · 28 Yelp | competitor-artists.md |

## Spot-Check Log

Manual verification of 2 entries before commit:

1. **Ducky's Barber Shop** — "941 Broadway Ste L, El Cajon CA 92021 / Bostonia" confirmed from Yelp scrape (map coordinates 32.807251, -116.949364 consistent with Bostonia neighborhood). Business owner confirmed appointment-only model via Yelp Q&A in scraped content.

2. **Clipper Crew Barber Shop** — "700 N Johnson Ave, Ste B, El Cajon CA 92020" confirmed from Yelp scrape (map coordinates 32.804082, -116.971894). Walk-ins confirmed via Yelp amenities section in scraped content. Owner name Geovanny G. confirmed from Q&A section.

## business.json Changes

None — Path A does not require `_showcase_review_pending` addition.

## Task Commits

1. **Task 1: Firecrawl search + scrape** — no git artifacts (`.firecrawl/` gitignored per Plan 00 Task 3)
2. **Task 2: Curate competitors.json** — `6ecf18a` (feat)

## Files Created/Modified

- `site/src/data/competitors.json` — 4-record array; first entry has `host: true`; Wave 3 can `import competitors from '../data/competitors.json'` and map directly

## Schema Reference for Wave 3 Cost Guide Builder

```
competitors.json record shape:
{
  name: string,          // display name
  host: boolean,         // true for Joe's only
  address: string,       // full street address
  phone: string,         // "(XXX) XXX-XXXX" or "" if hidden
  hours: string,         // paraphrased hours
  priceRange: string,    // "$X-$Y (details)" or "unknown"
  rating: string,        // "X.X★ · N platform reviews"
  quote: string,         // 5-star review excerpt (50-200 chars) or ""
  differentiator: string // editorial 1-sentence line
  archetype?: boolean    // only present on archetype entries (none in this plan)
}

Usage in Wave 3 cost guide:
  import competitors from '../data/competitors.json';
  competitors.map((c, i) => <article class={`entry ${c.host ? 'entry-host' : ''}`}>...)
```

## Known Stubs

| File | Field | Entries | Reason |
|------|-------|---------|--------|
| `site/src/data/competitors.json` | `phone` | 3 real competitor entries | Yelp hides phone behind JS "Click to reveal"; empty string is anti-fabrication-compliant (address is present) |
| `site/src/data/competitors.json` | `priceRange` | 3 real competitor entries | No price menu visible in Yelp scrapes; "unknown" is the anti-fabrication-compliant value |

The cost guide page can render "Call for pricing" or omit price comparison rows for competitors with `priceRange: "unknown"`.

## Deviations from Plan

None — plan executed as written. Path A qualification confirmed with 3 real competitors meeting the address gate. Phone hiding by Yelp was handled by the anti-fabrication gate: "drop if BOTH address AND phone missing" — all 3 have confirmed address.

## Issues Encountered

- Yelp hides phone numbers behind a JS "Click to reveal" button on all business pages — phone is not in scraped markdown for any competitor. This is consistent with previous plan's experience (Plan 02 noted similar Yelp JS-gating issues).
- Mr. Blendz: only phone available from href in website, no street address visible on any public surface — dropped per anti-fabrication gate.
- GeloFadez had 4.9★ Booksy but listed as "Mobile service" with no fixed hours — excluded as unsuitable for cost comparison page (no storefront hours to compare).

## Next Phase Readiness

- Wave 3 `/2026-east-county-barbershop-cost-guide` page build (Plan 06) can import competitors.json and render 4 entry cards without further data work
- Cost guide will show "unknown" as price for 3 competitors — recommend rendering this as "Call for pricing" or "—" in the UI
- Schema is stable and complete per the plan's output spec

---
*Phase: 03-unique-pages*
*Completed: 2026-05-08*
