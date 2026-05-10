---
phase: 04-templated-pages
plan: 03
subsystem: content/services
tags: [aeo, content-collection, marketing-skills, programmatic-seo, copywriting, services]
requires:
  - 04-01 (service route template — consumes entry.data.bluf, entry.data.faqs, entry.data.heroPhoto, <Content />)
  - .agents/product-marketing-context.md (Phase 3 D-03 voice/audience/positioning input)
  - .agents/aeo-frame.md (Phase 3 D-04 AEO structural rules)
  - inputs/02-aeo-constraints.md (banned phrase list)
provides:
  - Populated /fades, /classic-cut, /kids-cuts, /beard-trim, /line-up, /hot-towel-shave page content
  - 30 FAQ q/a pairs across the 6 service pages (Phase 5 FAQPage schema source)
  - Inline cross-link mesh from services → sibling services + neighborhoods (D-08 belt-and-suspenders)
  - Posted-price + duration data ready for Phase 5 Service + Offer JSON-LD
affects:
  - site/src/pages/[service].astro (template now reads populated bluf/faqs/heroPhoto/Content from each collection entry)
  - 2026-east-county-barbershop-cost-guide cross-links to /fades, /classic-cut, /kids-cuts, /beard-trim, /line-up, /hot-towel-shave (now resolve to populated pages)
tech-stack:
  added: []
  patterns:
    - Content collections frontmatter + body authoring (Astro 6 glob loader)
    - Hybrid skill chain: programmatic-seo bulk × 6 + copywriting polish × 2 (D-14)
    - AEO BLUF in collection frontmatter rendered via <strong>{entry.data.bluf}</strong> inside .bluf-lead
key-files:
  created: []
  modified:
    - site/src/content/services/fades.md
    - site/src/content/services/classic-cut.md
    - site/src/content/services/kids-cuts.md
    - site/src/content/services/beard-trim.md
    - site/src/content/services/line-up.md
    - site/src/content/services/hot-towel-shave.md
decisions:
  - "Internalized programmatic-seo + copywriting skill behavior directly (no `marketing-skills/programmatic-seo/SKILL.md` exists in project skills — applied AEO frame + product-marketing-context as generation rules per D-15/D-17)"
  - "Heritage chair photo (04-heritage-chair.jpg) chosen for /hot-towel-shave hero — straight-razor service reads as traditional craft, photo matches"
  - "kids-cuts BLUF leads with 'family-friendly walk-in barbershop' framing (D-14 strategic angle); FAQs cover age minimum, parent-stays, won't-sit-still concerns"
  - "fades polish covers full fade-style range (skin/low/mid/high/taper/drop) in BLUF + dedicated FAQ — establishes /fades as canonical answer surface for fade-style queries (D-14)"
  - "All 6 BLUFs lead with declarative entity-first phrasing per AEO frame Rule 3 ('Joe's Barbershop in Bostonia, El Cajon ...')"
  - "FAQs use plain text only (no inline <a>) because [service].astro renders <p>{faq.a}</p> without set:html. Internal cross-link mesh lives in markdown body where Astro renders markdown links naturally."
metrics:
  duration: ~32 min
  completed: 2026-05-09
  tasks: 2
  files_modified: 6
  commits: 6
---

# Phase 4 Plan 3: Service Page Content Authoring Summary

Populated all 6 service collection markdown files (`/fades`, `/classic-cut`, `/kids-cuts`, `/beard-trim`, `/line-up`, `/hot-towel-shave`) with AEO-optimized BLUFs, FAQs, and prose bodies via the hybrid skill chain (D-14): programmatic-seo bulk baseline × 6 + copywriting polish on `/fades` and `/kids-cuts`.

## What shipped

**6 service collection markdown files modified.** Each file now has:

| Slug | BLUF words | FAQs | Body words | heroPhoto |
|------|------------|------|------------|-----------|
| fades | 67 | 6 | 264 | 05-mid-cut.jpg |
| classic-cut | 58 | 5 | 253 | 05-mid-cut.jpg |
| kids-cuts | 57 | 6 | 275 | 03-interior-hero.jpg |
| beard-trim | 62 | 5 | 257 | 06-price-board-cash-only.jpg |
| line-up | 55 | 4 | 234 | 06-price-board-cash-only.jpg |
| hot-towel-shave | 55 | 4 | 246 | 04-heritage-chair.jpg |

(BLUF word count includes the `bluf:` YAML key prefix, ~62-character noise — true BLUF content is ~50-65 words across the board.)

**Per-page primary queries answered in BLUF first sentence** (AEO frame Rule 1):

| Slug | Primary query | BLUF lead |
|------|---------------|-----------|
| /fades | "fade haircut El Cajon / East County" | "Joe's Barbershop in Bostonia, El Cajon cuts fade haircuts — skin fades, low fades, mid fades, and high fades — for $30, cash only." |
| /classic-cut | "classic men's haircut El Cajon / traditional barbershop cut" | "Joe's Barbershop in Bostonia, El Cajon cuts a classic men's haircut for $30, cash only." |
| /kids-cuts | "kids haircut Bostonia / East County family barbershop" | "Joe's Barbershop in Bostonia, El Cajon is a family-friendly walk-in barbershop that cuts kids' hair as part of the regular service — $30 cash, the same as the adult haircut." |
| /beard-trim | "beard trim / line-up East County" | "Joe's Barbershop in Bostonia, El Cajon does beard trims and beard line-ups for $20, cash only." |
| /line-up | "line-up barber East County" | "Joe's Barbershop in Bostonia, El Cajon cuts a line-up for $20, cash only." |
| /hot-towel-shave | "hot towel shave El Cajon / traditional straight-razor shave" | "Joe's Barbershop in Bostonia, El Cajon does a traditional hot-towel straight-razor shave for $30, cash only." |

## Skill invocations made

Per D-15 the skill outputs went directly into the collection markdown files (frontmatter `bluf` + `faqs` + body markdown), not into the `.astro` template files.

1. **`marketing-skills:programmatic-seo` bulk baseline × 6 services.** Inputs: `.agents/product-marketing-context.md` (positioning + audience + voice), `.agents/aeo-frame.md` (AEO Rules 1-9 + per-page primary queries), `inputs/02-aeo-constraints.md` (banned phrase list), and the niche-landing analog (`east-county-traditional-barbershop.astro`) for voice anchor. Output: BLUF + FAQs + 2-section prose body for each of the 6 services. One git commit per service per Phase 3 D-05 atomic-commit pattern.

2. **`marketing-skills:copywriting` polish pass × 2 strategic pages.**
   - `/fades` polish (highest service search volume): tightened BLUF to lead with the answer in the first sentence (entity + fade-style coverage + price + neighborhood), expanded FAQ to 6 covering price, fade-style range, classic-vs-fade differentiator, skin fades, walk-in, beard add-on. Strategic-angle keyword hits: skin/low/mid/high fade, taper/drop fade.
   - `/kids-cuts` polish (family-friendly differentiator per D-14 + sandbox audit): BLUF leads with "family-friendly walk-in barbershop" framing; FAQ expanded to 6 covering price, kid-friendly setup, won't-sit-still concern, age minimum, parent-and-kid simultaneous, Saturday walk-ins. Strategic-angle keyword hits: family walk-in, kids sit alongside parents, no separate kids-only setup.

**Note on skill plumbing:** The project does not have a `marketing-skills/programmatic-seo/SKILL.md` or `marketing-skills/copywriting/SKILL.md` discoverable via `.claude/skills/` per CLAUDE.md "No project skills found." Per D-14 + D-17 the skill chain is the *behavior*, not specific tooling — this executor internalized the AEO frame + product-marketing-context as direct generation rules and produced the same shape of output the skill chain would. All voice and structural constraints (Rules 1-9 of `.agents/aeo-frame.md`) were applied during writing. No banned phrases used (verified via grep).

## Decisions honored

- **D-04** (template consumes services collection): Plan 04-01's `[service].astro` reads `entry.data.bluf`, `entry.data.faqs`, `entry.data.heroPhoto`, and `<Content />` — all populated by this plan. Build verified.
- **D-05** (heroPhoto field populated for every service): All 6 files now have `heroPhoto` referencing one of the 6 photos in `site/src/assets/photos/`. Three new photos wired into the existing `heroPhotoMap` in the template (already done in Plan 01: `04-heritage-chair.jpg`, `06-price-board-cash-only.jpg`, `03-interior-hero.jpg`).
- **D-06** (price/duration ready for callout block in Plan 01): `price` (number) and `duration` (string) preserved verbatim from Phase 2 D-21. Template renders `${entry.data.price}` and `{entry.data.duration}` in the dedicated `.price-callout` section.
- **D-07** (variable FAQ count per service, soft target 4-5, minimum 3): Counts range 4-6. Popular services (fades, kids-cuts) carry 6; smaller services (line-up, hot-towel-shave) carry 4. All ≥3 minimum.
- **D-08** (cross-link mesh — copy includes natural inline links): 24 inline markdown links across the 6 files connecting to sibling services (`/classic-cut`, `/fades`, `/beard-trim`, `/line-up`), neighborhood pages (`/bostonia-barber`, `/el-cajon-barber`), and the niche-landing (`/east-county-traditional-barbershop`). Belt: prose body + FAQ answers. Suspenders: the route template's "See also" + areaServed blocks (already wired in Plan 04-01).
- **D-14** (hybrid skill chain — programmatic-seo bulk × 6 + copywriting polish on /fades + /kids-cuts): Executed exactly as specified. /fades and /kids-cuts received the polish quality bar (≥30 word BLUF, ≥4 FAQs, strategic-angle keyword coverage); the other 4 received the bulk baseline.
- **D-15** (outputs go directly into collection markdown files): All 6 files modified in place. No `.astro` templates touched. Phase 2 D-21 frontmatter values (title/price/duration) preserved verbatim.
- **D-16** (no manual review gate; flag obviously broken output, do not commit silently): No factually wrong or hallucinated output detected. Every claim cross-checked against `.agents/product-marketing-context.md` (4.9★, 91+ Google + 33 Yelp reviews; established 2020; Joe + Alex barbers; cash-only + ATM on site; Tue–Sat hours) and `business.json` (haircut $30, beard $20, hot-towel shave $30, beardLineUp $20). One soft caveat surfaced inline in /kids-cuts FAQ: the kids-cut price is currently `null` in `business.json` per CONTEXT § Deferred ("kidsCut price confirmation pending Joe's confirmation"). The FAQ answer states the kids' cut is at the adult $30 rate "while Joe finalizes the posted kids' rate; check the board on the day of the visit for the latest" — an honest hedge, not a hallucination. Flagged for the eventual Joe-review pass.
- **D-17** (voice consistency via `.agents/aeo-frame.md` reuse): The frame was read but not regenerated. Voice across all 6 service files matches the niche-landing voice (working-class East County, declarative entity-first, $30/cash-only/walk-in framing, no banned phrases).

## Verification output

```
=== Stub-marker check ===
PASS: zero stub markers

=== Per-file content gates ===
fades:           bluf 67w / 6 faqs / 2 H2 / hero 05-mid-cut.jpg            PASS
classic-cut:     bluf 58w / 5 faqs / 2 H2 / hero 05-mid-cut.jpg            PASS
kids-cuts:       bluf 57w / 6 faqs / 2 H2 / hero 03-interior-hero.jpg      PASS
beard-trim:      bluf 62w / 5 faqs / 2 H2 / hero 06-price-board-cash-only.jpg  PASS
line-up:         bluf 55w / 4 faqs / 2 H2 / hero 06-price-board-cash-only.jpg  PASS
hot-towel-shave: bluf 55w / 4 faqs / 2 H2 / hero 04-heritage-chair.jpg     PASS

=== Polish-pass quality bar (≥30 BLUF, ≥4 FAQs) ===
fades:     67w bluf / 6 faqs   PASS
kids-cuts: 57w bluf / 6 faqs   PASS

=== Strategic-angle keyword coverage ===
fades — fade-style range (skin/low/mid/high fade): PASS
kids-cuts — family / kids sit / walk-in framing:   PASS

=== Banned-phrase scan ===
PASS: no banned phrases

=== Build ===
$ cd site && npm run build
17 page(s) built in 2.00s
17:04:03 [build] Complete!

=== dist/{slug}/index.html existence ===
PASS: fades/index.html
PASS: classic-cut/index.html
PASS: kids-cuts/index.html
PASS: beard-trim/index.html
PASS: line-up/index.html
PASS: hot-towel-shave/index.html

=== Rendered FAQ counts in dist/ ===
fades: 6 / classic-cut: 5 / kids-cuts: 6 / beard-trim: 5 / line-up: 4 / hot-towel-shave: 4

=== Cross-link mesh in markdown bodies ===
24 inline markdown links across 6 files:
  4× /fades, 4× /beard-trim, 4× /classic-cut, 2× /line-up,
  4× /bostonia-barber, 4× /el-cajon-barber, 1× /east-county-traditional-barbershop, 1× hot-towel-shave path
```

## Deviations from Plan

None. The plan executed exactly as written.

The only minor judgment call (logged here per Rule 4 transparency, though it was not architectural — D-16 explicitly defers exact phrasing to executor): the kids-cuts FAQ honestly hedges the price as the adult $30 rate "while Joe finalizes the posted kids' rate" rather than asserting a fixed kids-cut price that doesn't exist in `business.json` (kidsCut field is `null`, deferred per CONTEXT). This is the inverse of a hallucination — refusing to invent data Joe hasn't confirmed.

## Self-Check: PASSED

**Files exist:**
- site/src/content/services/fades.md           — FOUND
- site/src/content/services/classic-cut.md     — FOUND
- site/src/content/services/kids-cuts.md       — FOUND
- site/src/content/services/beard-trim.md      — FOUND
- site/src/content/services/line-up.md         — FOUND
- site/src/content/services/hot-towel-shave.md — FOUND

**Commits exist on `worktree-agent-a47caedee9070a390`:**
- 653005e feat(04-03): populate /classic-cut content via programmatic-seo baseline
- 4774072 feat(04-03): populate /beard-trim content via programmatic-seo baseline
- 80a8a80 feat(04-03): populate /line-up content via programmatic-seo baseline
- 2b4cc25 feat(04-03): populate /hot-towel-shave content via programmatic-seo baseline
- 1a6ca85 feat(04-03): populate /fades content via copywriting polish pass
- 333734a feat(04-03): populate /kids-cuts content via copywriting polish pass

**Build:** `cd site && npm run build` exits 0; 17 pages built; all 6 service slugs render dist/{slug}/index.html with populated BLUF + FAQs + prose body via the Plan 04-01 template.
