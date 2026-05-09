# Phase 4: Templated Pages - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-09
**Phase:** 4-Templated Pages
**Areas discussed:** Routing structure, Service page composition, Neighborhood page composition, Copy authoring approach

---

## Purpose Clarification (pre-discussion)

User asked: "I don't understand what these pages are intended for. what purpose do they serve?"

Claude explained: The 11 templated pages are AEO citation-surface multipliers — without them the site is a 6-page boutique with no AI citations; with them it's a 17-page hub that hits the Toronto plumber 20–40-page benchmark. Each service page is the dedicated answer surface for that service's query family ("fade haircut El Cajon", "kids haircut Bostonia"); each neighborhood page captures micro-local queries ("barber in Santee") and signals areaServed per neighborhood.

Evidence cited: `inputs/01-page-list.md` (JavaLogix Toronto plumber playbook + corroborating sources), `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` (AEO mechanics + 32.5% citation lift on comparative content).

User accepted the framing and said "we can talk about all of them" — proceed with the 4 gray areas.

---

## Routing structure

| Option | Description | Selected |
|--------|-------------|----------|
| Both at root | src/pages/[service].astro → /fades, etc. AND src/pages/[neighborhood]-barber.astro → /bostonia-barber, etc. Matches ROADMAP slugs and Phase 3 cost guide links. | ✓ |
| Services nested, neighborhoods at root | src/pages/services/[slug].astro → /services/fades, etc. Matches REQUIREMENTS.md PAGE-07 wording literally but breaks ROADMAP success criterion + Phase 3 cost guide links. | |
| Both nested under section folders | /services/fades, /neighborhoods/bostonia. Most conventional Astro pattern for large content sites; breaks ROADMAP slugs and forces multi-page retro-edits. | |

**User's choice:** Both at root (after follow-up clarification on Astro convention)
**Notes:** User pushed back on initial recommendation — asked whether "Astro convention" was being followed and was willing to rewrite prior phases. Claude clarified: Astro itself doesn't dictate flat-vs-nested; both are first-class. For AEO/local-business sites at this size (17-19 pages), flat root IS the dominant convention because shorter URLs cite more readably and the slug becomes the keyword target directly. Plus the project's prior decisions (ROADMAP, Phase 3 cost guide links, niche-landing areaServed) are already aligned to flat. After clarification, user confirmed flat root.

REQUIREMENTS.md PAGE-07 wording (`src/pages/services/[slug].astro`) flagged as stale — same pattern as Phase 2 D-12 stale-text — to be fixed at next /gsd-transition.

---

## Service page composition

### Hero photo

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — use heroPhoto field per service | Each service page renders heroPhoto from collection file. Below-fold, lazy load. | ✓ |
| No — prose-only like the niche landing | Skip the hero. Article-shaped pages straight from H1 to BLUF to prose. | |
| Hybrid — hero on services with strong photos, none on others | Per-service decisions; breaks template uniformity. | |

**User's choice:** Yes — use heroPhoto field per service
**Notes:** —

### Price callout treatment

| Option | Description | Selected |
|--------|-------------|----------|
| Dedicated price callout block | After BLUF, a styled block: large $30, "30 min", "cash only". Echoes OD-5 PriceBoard heritage without reusing the homepage-only PriceBoard component. | ✓ |
| Inline in BLUF only | Price mentioned only in BLUF prose. Cleaner but loses visual hook and structured price signal. | |
| Both — inline + dedicated callout | Belt-and-suspenders. Risk of redundancy on a short page. | |

**User's choice:** Dedicated price callout block
**Notes:** —

### FAQ count per service page

| Option | Description | Selected |
|--------|-------------|----------|
| 4–5 per page (matches inputs/01-page-list.md) | Inputs spec says 4-5. Skill-generated. | |
| 3 per page (tighter, more uniform) | Drop to 3 to keep templated pages skim-fast. Sacrifices long-tail coverage. | |
| Variable per service — skill chain decides | programmatic-seo or copywriting picks the right count per service based on actual question patterns. | ✓ |

**User's choice:** Variable per service — skill chain decides
**Notes:** —

### Cross-link strategy for service pages

| Option | Description | Selected |
|--------|-------------|----------|
| Both: areaServed list + 'See also' related services | Full mesh: 5 neighborhood links + 2-3 sibling service links + cost guide. Mirrors Phase 3 D-15 belt-and-suspenders. | ✓ |
| areaServed list only | 5 neighborhood links, no related-services block. Cleaner; weaker mesh. | |
| Inline links only — no dedicated link blocks | Mention naturally in prose. Most article-like; risks missing some cross-links. | |

**User's choice:** Both: areaServed list + 'See also' related services
**Notes:** —

User chose "Next area" after these 4 questions; declined to discuss smaller details (Visit/NAP on services, eyebrow text convention, related-services selection logic) — defaulted to Claude/planner discretion.

---

## Neighborhood page composition

### Photo on neighborhood pages

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — storefront photo on every neighborhood | Reuse 02-storefront.jpg as a shared neighborhood photo. Visual anchor; signals "this is the actual shop." | ✓ |
| No — prose + landmarks only | Skip photo. Article-shaped pages. | |
| Per-neighborhood photo (would need new photos) | Out of scope for v1: requires Joe's permission + new shoot. | |

**User's choice:** Yes — storefront photo on every neighborhood
**Notes:** —

### Landmarks and distance display

| Option | Description | Selected |
|--------|-------------|----------|
| Dedicated 'Getting here from {neighborhood}' block | After BLUF, structured block: distance + 2-3 landmarks. Strong AEO signal. | ✓ |
| Prose-embedded only | Mention naturally; weaker structured signal. | |
| Both — block + prose mention | Belt-and-suspenders. Risks redundancy. | |

**User's choice:** Dedicated 'Getting here from {neighborhood}' block
**Notes:** —

### Visit/NAP block on neighborhood pages

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — NAP block on every neighborhood page | Local-SEO best practice. NAP repetition reinforces business identity for Google + AI parsers. | ✓ |
| No — rely on Footer + Masthead phone | Cleaner; weaker per-neighborhood NAP signal. | |
| Yes for neighborhoods, optional for services | Template differentiation. | |

**User's choice:** Yes — NAP block on every neighborhood page
**Notes:** Service pages do NOT get the Visit block — the price callout already provides the structural signal services need (per CONTEXT.md D-12).

### Cross-link strategy for neighborhood pages

| Option | Description | Selected |
|--------|-------------|----------|
| All 6 services + niche-landing + cost guide | Full mesh; mirrors services' belt-and-suspenders pattern. | ✓ |
| 3-4 services + niche-landing only | Curated subset; cleaner pages; trust planner judgment. | |
| Other neighborhoods + niche-landing only | Neighborhood ring; skips service cross-linking. | |

**User's choice:** All 6 services + niche-landing + cost guide
**Notes:** —

User chose "Next area" after these 4 questions; declined to discuss smaller details (FAQ count target, landmark sourcing, distance string format) — defaulted to Claude/planner discretion.

---

## Copy authoring approach

| Option | Description | Selected |
|--------|-------------|----------|
| marketing-skills:programmatic-seo | Single skill invocation per type. Fastest; consistent voice. Per Phase 2 D-16. | |
| Per-page marketing-skills:copywriting | Mirrors Phase 3 chain. 11 invocations. Tightest per-page control; risk of voice drift. | |
| Hybrid — programmatic-seo bulk + copywriting polish on strategic pages | Bulk baseline for all 11; per-page polish on 2-3 strategic pages. Highest quality; most invocations. | ✓ |
| Direct authoring — no skill chain | Planner writes prose directly using AEO frame as checklist. Fastest; loses skill enforcement; Phase 2 D-16 actively recommended against. | |

**User's choice:** Hybrid — programmatic-seo bulk + copywriting polish on strategic pages
**Notes:** —

### Polish set selection

| Option | Description | Selected |
|--------|-------------|----------|
| /fades (highest service search volume) | Fade queries dominate barbershop search. Most likely page in 'fade haircut El Cajon' AI citations. | ✓ |
| /bostonia-barber (Joe's home neighborhood) | Joe's literal location; primary local-citation surface. | ✓ |
| /el-cajon-barber (biggest market name) | Largest searchable city name; highest competition with chains. | ✓ |
| /kids-cuts (family-friendly differentiator) | Joe's "walk in with the family" positioning is a real differentiator. | ✓ |

**User's choice:** All 4 (multiSelect)
**Notes:** Polish budget is 4 pages on top of programmatic-seo baseline for all 11.

---

## Claude's Discretion

User explicitly deferred these to planner / skill chain judgment:
- Exact prose phrasing in skill-generated copy.
- Selection of 2-3 "related services" for each service page's "See also" block.
- Distance string format for neighborhoods (e.g., "2.1 mi from shop" vs "a 5-minute drive").
- Source for landmark data per neighborhood (vault, web search, or Joe-confirmed).
- Which photo to use as service-page hero when heroPhoto field doesn't have a natural fit.
- Whether to add a `dateModified` line to each templated page.
- Per-page eyebrow text and H1 phrasing.
- Whether to introduce a `<UniquePageLayout>` wrapper between Base.astro and templated pages (Claude recommended NOT to introduce a new layer).
- FAQ count target for neighborhood pages (skipped during discussion; defaults to inputs/01-page-list.md "3–4 FAQs").

## Deferred Ideas

- JSON-LD schema emission (Phase 5).
- Lighthouse perf tuning + full meta tag suite (Phase 5).
- /contact and /blog/[seasonal-post] optional pages (out of scope for Phase 4 v1).
- Per-neighborhood photography (out of scope for v1; PROJECT.md photo-set constraint).
- Programmatic-SEO scale-up beyond 11 pages (deferred as v2 expansion).
- Per-service "deeper variant" pages (sub-niching deferred to v2).
- Mid-page customer-quote ribbons on neighborhood pages (future iteration).
- Auto-generated `<RelatedServices>` / `<RelatedNeighborhoods>` components (not needed at v1 size).
- REQUIREMENTS.md PAGE-07 wording fix (apply at next /gsd-transition).
- `.agents/aeo-frame.md` regeneration (only if voice drift detected; default is reuse).
- kidsCut price confirmation (pending Joe's showcase confirmation).
