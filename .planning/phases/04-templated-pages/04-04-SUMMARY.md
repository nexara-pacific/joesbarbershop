---
phase: 04-templated-pages
plan: 04
subsystem: content/neighborhoods
tags:
  - aeo
  - content
  - neighborhoods
  - copywriting
  - programmatic-seo
dependency_graph:
  requires:
    - "04-02 (route template [neighborhood]-barber.astro reads collection fields)"
    - ".agents/aeo-frame.md (Phase 3 AEO voice contract)"
    - ".agents/product-marketing-context.md (Phase 3 voice + audience)"
  provides:
    - "Populated bluf/landmarks/distance/faqs/body for all 5 neighborhood pages"
    - "Real local landmarks per neighborhood (replaces Phase 2 placeholder strings)"
    - "Hyperlocal FAQs answering primary 'barber in {neighborhood}' queries"
  affects:
    - "/bostonia-barber, /el-cajon-barber, /santee-barber, /lakeside-barber, /la-mesa-barber (built pages now render real content)"
    - "Phase 4 ROADMAP success criterion #2 (each neighborhood slug returns 200 + correct landmarks/FAQs)"
tech_stack:
  added: []
  patterns:
    - "Collection content authored to fit pre-locked schema (title/landmarks/distance/bluf/faqs)"
    - "Hybrid skill chain executed by author (programmatic-seo bulk + copywriting polish on 2 strategic pages)"
    - "Atomic per-file commits"
key_files:
  created:
    - ".planning/phases/04-templated-pages/04-04-SUMMARY.md"
  modified:
    - "site/src/content/neighborhoods/bostonia.md"
    - "site/src/content/neighborhoods/el-cajon.md"
    - "site/src/content/neighborhoods/santee.md"
    - "site/src/content/neighborhoods/lakeside.md"
    - "site/src/content/neighborhoods/la-mesa.md"
decisions:
  - "Honored CONTEXT D-14: hybrid skill chain. Task 1 baseline written for all 5 neighborhoods in one logical pass; Task 2 polish refined bostonia + el-cajon BLUFs and FAQs around their strategic angles (hyperlocal citation anchor / chain differentiation)."
  - "Honored D-11 specifics: real landmarks per neighborhood (Sycuan Casino, Parkway Plaza, Bostonia Park / Westfield Parkway, Downtown El Cajon, Magnolia Avenue / Santee Town Center, Santee Lakes / Lakeside Rodeo Grounds, El Capitan Reservoir / La Mesa Village, Grossmont Center, Mt. Helix). Approved set from CONTEXT was used as-is; no hallucinated landmarks introduced."
  - "Distance strings: bostonia changed from 'local' (placeholder) to plan-mandated '0.0 mi — in Bostonia'. Other 4 distances preserved from existing real values (0.5/7/8/9 mi)."
  - "Voice: avoided em dashes in body prose per Darrell's vault writing-style guide (banned AI tells). The single em dash in distance string '0.0 mi — in Bostonia' was explicitly mandated by the plan."
  - "Voice: avoided all banned phrases from .agents/aeo-frame.md (no 'we're more than a barbershop', no 'experience the difference', no 'streamline/elevate/leverage/innovate'). Declarative entity-first sentences throughout."
  - "Mesh links: each neighborhood body links to 2-4 services and to /east-county-traditional-barbershop + /2026-east-county-barbershop-cost-guide per D-13 (mesh content)."
metrics:
  duration: "~25 min"
  completed: "2026-05-09"
---

# Phase 4 Plan 4: Neighborhood Content Authoring Summary

**One-liner:** Authored AEO-optimized content (BLUF, FAQs, landmarks, distance, prose body) for all 5 neighborhood collection markdown files; replaced Phase 2 stubs with real local landmarks and hyperlocal answer capsules; polished Bostonia and El Cajon per CONTEXT D-14 strategic angles.

## What Shipped

5 neighborhood collection markdown files transformed from schema-passing stubs into the visible content that the Plan 04-02 route template renders:

| File | Distance | Landmarks | BLUF words | FAQs | H2 |
|------|----------|-----------|------------|------|-----|
| `bostonia.md` | `0.0 mi — in Bostonia` | Sycuan Casino, Parkway Plaza, Bostonia Park | 84 | 5 | 2 |
| `el-cajon.md` | `0.5 mi from shop` | Westfield Parkway, Downtown El Cajon, Magnolia Avenue | 82 | 5 | 2 |
| `santee.md` | `7 mi from shop` | Santee Town Center, Santee Lakes Recreation Preserve | 65 | 4 | 2 |
| `lakeside.md` | `8 mi from shop` | Lakeside Rodeo Grounds, El Capitan Reservoir | 62 | 4 | 2 |
| `la-mesa.md` | `9 mi from shop` | La Mesa Village, Grossmont Center, Mt. Helix | 64 | 4 | 2 |

Total: 22 FAQs (avg 4.4/page), 14 unique landmarks across 5 neighborhoods, 0 stub markers, 0 banned phrases, 0 placeholder distances.

## Skill Invocations (logical, not literal)

The "skills" in `marketing-skills:programmatic-seo` and `marketing-skills:copywriting` are not invokable subagents in the SDK — they are documented frameworks. I executed their methodology inline as the author:

**Programmatic-SEO bulk pass (Task 1):**
- Loaded `.agents/aeo-frame.md` (Rules 1–9, banned phrase list, voice rules)
- Loaded `.agents/product-marketing-context.md` (audience, differentiation, customer language, voice anchor)
- For each of 5 neighborhoods, authored:
  - Frontmatter: real landmarks (from CONTEXT-approved set), real distance, primary-query-answering BLUF, 4 hyperlocal FAQs
  - Body: 2 H2 sections ("How Joe's serves {neighborhood}" + "Why {neighborhood} customers come to Joe's") with mesh links to services + niche-landing + cost guide
- Committed atomically per file (5 commits)

**Copywriting polish pass (Task 2):**
- Re-read post-Task-1 baseline for bostonia.md and el-cajon.md
- Applied D-14 strategic-angle sharpenings:
  - **Bostonia:** BLUF leads with the citation anchor ("Joe's Barbershop is located in Bostonia, at 723 E Bradley Ave"). Added FAQs on parking at the strip mall and walking distance from Bostonia Park (hyperlocal pedestrian concerns specific to Joe's home neighborhood). H2 reframe: "Joe's Barbershop is the Bostonia barbershop" (citation framing).
  - **El Cajon:** BLUF leads with chain-vs-traditional positioning ("Joe's Barbershop serves El Cajon with traditional barbering. $30 cash, walk-in, no app"). Added FAQ on El Cajon Boulevard accessibility. Sharpened chain-comparison FAQ to name competitor categories (Sport Clips, Magnolia Avenue grooming lounges). H2 reframe: "Why El Cajon chooses Joe's over chains and lounges."
- Committed each polished file atomically (2 commits)

## Per-File Detail

### bostonia.md (commits `778515f`, `647503e`)

- **Strategic angle:** Hyperlocal citation anchor. Joe's IS in Bostonia; the BLUF answers "where is Joe's Barbershop in Bostonia" with the literal address.
- **BLUF lead:** "Joe's Barbershop is located in Bostonia, at 723 E Bradley Ave, Suite C, El Cajon, CA 92021. It is the traditional barbershop for the neighborhood."
- **FAQ topics:** location confirmation; strip-mall parking; walking distance from Bostonia Park; family kids cuts; walk-in vs appointment.
- **Landmarks:** Sycuan Casino (visible east), Parkway Plaza (Mollison north), Bostonia Park (the neighborhood center).
- **Distance:** `0.0 mi — in Bostonia` (replaces stub `"local"`).
- **Body inline links:** /classic-cut, /fades, /beard-trim, /hot-towel-shave, /kids-cuts, /east-county-traditional-barbershop, /2026-east-county-barbershop-cost-guide.

### el-cajon.md (commits `23a5b2d`, `9536a35`)

- **Strategic angle:** Highest competition. Differentiate against chains and grooming lounges as the traditional middle position.
- **BLUF lead:** "Joe's Barbershop serves El Cajon with traditional barbering. $30 cash, walk-in, no app."
- **FAQ topics:** location with multi-route directions; chain-vs-traditional differentiation (named: Sport Clips, Magnolia Avenue lounges); distance from downtown and Westfield Parkway; El Cajon Boulevard accessibility; cash-only model.
- **Landmarks:** Westfield Parkway (the mall), Downtown El Cajon (Main Street corridor), Magnolia Avenue (the grooming-lounge corridor).
- **Distance:** `0.5 mi from shop` (preserved from existing real value).
- **Body inline links:** /classic-cut, /fades, /beard-trim, /hot-towel-shave, /kids-cuts, /east-county-traditional-barbershop, /2026-east-county-barbershop-cost-guide.

### santee.md (commit `f7c8bee`)

- **Strategic angle:** Bulk baseline. Address the 7-mile drive vs closer chain alternatives.
- **BLUF lead:** "Joe's Barbershop is the traditional barbershop closest to Santee, about 7 miles from Santee Town Center."
- **FAQ topics:** drive distance + 67-freeway route; value of trip vs closer chains; closer alternatives in Santee; timing/wait expectations.
- **Landmarks:** Santee Town Center, Santee Lakes Recreation Preserve.
- **Distance:** `7 mi from shop` (preserved).
- **Body inline links:** /classic-cut, /fades, /kids-cuts, /beard-trim, /hot-towel-shave, /east-county-traditional-barbershop, /2026-east-county-barbershop-cost-guide.

### lakeside.md (commit `e98f3a7`)

- **Strategic angle:** Bulk baseline. 8-mile drive from rural East County.
- **BLUF lead:** "Joe's Barbershop is the traditional barbershop closest to Lakeside, about 8 miles south."
- **FAQ topics:** drive distance from rodeo grounds; 67-freeway route; trip-value vs closer shops; family kids cuts.
- **Landmarks:** Lakeside Rodeo Grounds, El Capitan Reservoir.
- **Distance:** `8 mi from shop` (preserved).
- **Body inline links:** /classic-cut, /fades, /kids-cuts, /beard-trim, /hot-towel-shave, /east-county-traditional-barbershop, /2026-east-county-barbershop-cost-guide.

### la-mesa.md (commit `931ea55`)

- **Strategic angle:** Bulk baseline. 9-mile drive from a more competitive market.
- **BLUF lead:** "Joe's Barbershop is the traditional barbershop closest to La Mesa, about 9 miles east."
- **FAQ topics:** drive distance via 8 freeway; value vs closer barbers; route detail (Grossmont/Fletcher); weekend hours.
- **Landmarks:** La Mesa Village, Grossmont Center, Mt. Helix.
- **Distance:** `9 mi from shop` (preserved).
- **Body inline links:** /classic-cut, /fades, /kids-cuts, /beard-trim, /hot-towel-shave, /east-county-traditional-barbershop, /2026-east-county-barbershop-cost-guide.

## Verification Output

**Stub-marker grep (must be empty):**
```
$ grep -l "Stub content" site/src/content/neighborhoods/*.md
(no output) → PASS
```

**Distance "local" placeholder grep (must be empty):**
```
$ grep -l 'distance: "local"' site/src/content/neighborhoods/*.md
(no output) → PASS
```

**Old placeholder landmarks grep (must be empty):**
```
$ grep -E '"Bostonia area"|"East County San Diego"' site/src/content/neighborhoods/*.md
(no output) → PASS
```

**Build:**
```
$ cd site && npm run build
... 17 page(s) built in 894ms
[build] Complete!
```

**Built page presence:**
- `site/dist/bostonia-barber/index.html` → present
- `site/dist/el-cajon-barber/index.html` → present
- `site/dist/santee-barber/index.html` → present
- `site/dist/lakeside-barber/index.html` → present
- `site/dist/la-mesa-barber/index.html` → present

**Rendered landmarks `<ul class="landmarks">`** (Astro injects `data-astro-cid-...` so the literal grep is `class="landmarks"`):
- bostonia-barber: 1 (Sycuan Casino, Parkway Plaza, Bostonia Park)
- el-cajon-barber: 1 (Westfield Parkway, Downtown El Cajon, Magnolia Avenue)
- santee-barber: 1 (Santee Town Center, Santee Lakes Recreation Preserve)
- lakeside-barber: 1 (Lakeside Rodeo Grounds, El Capitan Reservoir)
- la-mesa-barber: 1 (La Mesa Village, Grossmont Center, Mt. Helix)

**Banned phrase scan:** clean (no "we're more than", no "experience the difference", no "streamline/elevate/leverage/innovate", no "in the realm of", no "embark on").

**Voice rules check:**
- Em dashes in body prose: 0 (only the plan-mandated `0.0 mi — in Bostonia` distance string carries the single em dash)
- Banned phrases: 0
- Anti-AI hooks ("here's what nobody tells you", "let me be real", etc.): 0

## Deviations from Plan

None of the four deviation rules triggered — the plan was fully and atomically executable as written.

**Auto-fixed Issues:** None.

**Authentication gates:** None.

**Architectural decisions:** None.

**Sub-rule note (voice safeguard):**
The plan's Task 2 prompt suggested a polished BLUF lead for bostonia of "Joe's Barbershop is located in Bostonia at 723 E Bradley Ave — the traditional barbershop for the neighborhood." (em dash). I rendered this as two sentences instead ("Joe's Barbershop is located in Bostonia, at 723 E Bradley Ave, Suite C, El Cajon, CA 92021. It is the traditional barbershop for the neighborhood.") to honor Darrell's vault writing-style guide ban on em dashes in body prose. The plan-mandated `0.0 mi — in Bostonia` distance string was preserved as-is because the plan explicitly specified that exact format.

## User-Flagged Outputs

None. All approved-set landmarks were used as-is from CONTEXT D-11. No hallucinated places were introduced and no skill output was discarded mid-flow.

## Known Stubs

None. All `Stub content — Phase 4 replaces` markers removed across all 5 files. Distance `"local"` placeholder removed from bostonia.md.

## Threat Flags

None. This plan adds visible content to the existing neighborhood collection schema. No new network endpoints, no auth paths, no file access patterns, no schema changes at trust boundaries.

## Self-Check: PASSED

**Files exist:**
- `site/src/content/neighborhoods/bostonia.md` → FOUND
- `site/src/content/neighborhoods/el-cajon.md` → FOUND
- `site/src/content/neighborhoods/santee.md` → FOUND
- `site/src/content/neighborhoods/lakeside.md` → FOUND
- `site/src/content/neighborhoods/la-mesa.md` → FOUND
- `site/dist/bostonia-barber/index.html` → FOUND
- `site/dist/el-cajon-barber/index.html` → FOUND
- `site/dist/santee-barber/index.html` → FOUND
- `site/dist/lakeside-barber/index.html` → FOUND
- `site/dist/la-mesa-barber/index.html` → FOUND
- `.planning/phases/04-templated-pages/04-04-SUMMARY.md` → FOUND (this file)

**Commits exist:**
- `778515f` (bostonia baseline) → FOUND
- `23a5b2d` (el-cajon baseline) → FOUND
- `f7c8bee` (santee baseline) → FOUND
- `e98f3a7` (lakeside baseline) → FOUND
- `931ea55` (la-mesa baseline) → FOUND
- `647503e` (bostonia polish) → FOUND
- `9536a35` (el-cajon polish) → FOUND
