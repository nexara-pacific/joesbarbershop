---
phase: 04-templated-pages
plan: 01
subsystem: site/src/pages
tags: [astro, dynamic-route, content-collections, aeo, services]
requires:
  - site/src/content.config.ts (services schema)
  - site/src/content/services/*.md (6 collection entries)
  - site/src/layouts/Base.astro (variant="article")
  - site/src/components/ClosingCTA.astro
  - site/src/data/business.ts
provides:
  - 6 service routes at /fades, /classic-cut, /kids-cuts, /beard-trim, /line-up, /hot-towel-shave
  - Dynamic-route template that auto-generates a new page per services-collection file (no template edits needed)
affects:
  - Phase 3 ROADMAP success criterion #3 (cost guide service-link 404s) — service routes now resolve to 200 at template level (content polish lands in 04-03)
tech-stack:
  added:
    - astro Content Layer API render() (Astro 6 canonical, replaces deprecated entry.render())
  patterns:
    - getStaticPaths() over getCollection('services') with entry.id as the slug param
    - Static heroPhoto import map (Astro asset-pipeline requires static imports; runtime string lookup of pre-imported ImageMetadata)
    - Article-page typography copied verbatim from niche-landing analog (.article-head, .bluf, .prose, .area-served, .faq, .faq-q)
    - Bespoke section CSS for .service-hero, .price-callout, .see-also (echoes PriceBoard heritage without importing the homepage-only component)
key-files:
  created:
    - site/src/pages/[service].astro (431 lines)
  modified: []
decisions:
  - "Astro 6 canonical content render API: import { render } from 'astro:content' + await render(entry); the plan's pattern using await entry.render() is the deprecated v4 idiom and would have failed at build (Rule 3 — auto-fix blocking issue)"
  - "Related-services map uses planner-picked natural pairings per CONTEXT D-08 / Claude's Discretion (fades→classic-cut+line-up; classic-cut→fades+beard-trim; kids-cuts→classic-cut+fades; beard-trim→hot-towel-shave+line-up; line-up→beard-trim+fades; hot-towel-shave→beard-trim+classic-cut)"
  - "heroPhoto fallback to interiorHero (03-interior-hero.jpg) when entry.data.heroPhoto is missing or unmapped — services without heroPhoto in their stub frontmatter (beard-trim, hot-towel-shave, kids-cuts, line-up) render the interior shot as the v1 placeholder; Plan 04-02 may set explicit heroPhoto values per service"
metrics:
  duration_seconds: ~120
  completed_date: 2026-05-09
---

# Phase 4 Plan 01: [service].astro dynamic-route template — Summary

Dynamic-route Astro template that generates all 6 service pages (`/fades`, `/classic-cut`, `/kids-cuts`, `/beard-trim`, `/line-up`, `/hot-towel-shave`) from the services content collection, replacing what would otherwise be 6 hand-coded service files.

## Tasks Completed

| Task | Name                                        | Commit  | Files                              |
| ---- | ------------------------------------------- | ------- | ---------------------------------- |
| 1    | Create [service].astro dynamic-route template | 1c53489 | site/src/pages/[service].astro     |

## What Was Built

**Single new file:** `site/src/pages/[service].astro` (431 lines)

### `getStaticPaths()` shape

```ts
const services = await getCollection('services');
return services.map((entry) => ({
  params: { service: entry.id },  // entry.id is the slug from filename (Astro 6 glob loader)
  props: { entry },
}));
```

Returns exactly 6 entries — one per file in `site/src/content/services/`. Adding a new collection file generates a new page with zero template edits (verified by adding `test-service.md` mid-build → `dist/test-service/index.html` materialized → file removed).

### Sections rendered (in order)

1. `<header class="article-head">` — eyebrow + H1 + `UPDATED MAY 2026` date stamp
2. `<section class="bluf">` — `entry.data.bluf` wrapped in `<strong>` for AEO answer-capsule signal
3. `<section class="service-hero">` — `<Image src={heroPhoto} loading="lazy" />` from heroPhoto static-import map
4. `<section class="price-callout">` — board-style card with `${entry.data.price}` callout, "Posted price · cash only" eyebrow, "{duration} · ATM on site" meta line (echoes PriceBoard heritage per D-06 without importing the homepage-only component)
5. `<section class="prose">` — renders `<Content />` from `await render(entry)` (Astro 6 canonical API)
6. `<aside class="see-also">` — 2 related service links + cost-guide link (planner-picked pairings per D-08)
7. `<section class="area-served">` — 5 neighborhood links (Bostonia, El Cajon, Santee, Lakeside, La Mesa) styled as letter-board chips
8. `<section class="faq">` — `entry.data.faqs.map()` with numbered `.faq-q` markers (renders empty list pre-Plan-04-03 since stubs have `faqs: []`; structure passes audit grep)
9. `<ClosingCTA />`

### Scoped CSS additions

- **Copied verbatim from niche-landing analog:** `.article-head`, `.bluf`, `.prose`, `.area-served`, `.faq`, `.faq-q`, `.bluf-lead`, `.section-head` styles (preserves the Phase 3 article-page typography exactly)
- **New bespoke rules:**
  - `.service-hero` — 820px wrap, lazy-loaded image, max-width 980px, centered
  - `.price-callout` — board-bg backdrop, board-fg foreground, large `clamp(56px, 7vw, 96px)` `$30` callout in `var(--font-board)`, uppercase `letter-spacing: 0.14em` meta line
  - `.see-also` — surface backdrop, board-style chip links mirroring `.area-served li a` (1px border, 12px uppercase letter-board font)

### Constraints honored

| Constraint | Enforcement |
|------------|-------------|
| D-01: Flat root routing | File at `site/src/pages/[service].astro`, NOT under `src/pages/services/` |
| D-04 / Phase 3 D-17: No homepage-only components | Zero imports of `Hero`, `FactStrip`, `PriceBoard`, `Heritage` (verified by grep) |
| D-05: Hero photo lazy-loaded below BLUF | `<Image src={heroPhoto} loading="lazy" />` after `.bluf`, NOT a `<Hero>` component |
| D-06: Dedicated price callout block | Standalone `<section class="price-callout">`, not inline-only |
| D-08: Belt-and-suspenders mesh | areaServed (5 links) + see-also (2 services + cost-guide) — both rendered, no inline-only mesh |
| AEO: zero-JS DOM | Zero `client:*` directives anywhere in the file |
| Phase 5 boundary | `<slot name="head" />` left untouched (no JSON-LD this phase) |

## Verification Output

```
=== File exists === OK
=== getStaticPaths === OK
=== getCollection === OK
=== <section class=bluf> === OK
=== <section class=price-callout> === OK
=== <section class=service-hero> === OK
=== <aside class=see-also> === OK
=== 5 neighborhood slugs === OK (all 5)
=== No homepage-only imports === OK
=== No client: directives === OK
=== 6 dist files === OK (all 6)
=== Each built page has BLUF === OK (all 6)
=== Each built page has price-callout === OK (all 6)
=== Each page has 5 unique neighborhood links === OK (all 6 = 5)
=== Existing pages still build (route precedence) === OK (about, niche-landing)
=== Dynamic-route auto-gen (test-service.md added → dist/test-service/index.html built → file removed) === OK
```

`npm run build` exit 0; total pages built: 12 (6 existing + 6 new service routes).

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 — Blocking] Astro 6 content-render API correction**

- **Found during:** Task 1 implementation (before write)
- **Issue:** Plan and PATTERNS.md both specified `const { Content } = await entry.render();` — this is the Astro v4 idiom. Astro 6 (the project's pinned version, 6.3.0) deprecated `entry.render()`. The canonical Astro 6 API is `import { render } from 'astro:content'; const { Content } = await render(entry);`. Using the deprecated form would throw at build time.
- **Fix:** Used the Astro 6 canonical form. Verified against Context7 Astro 6.3.1 docs (`/withastro/astro` — content collections render() reference).
- **Files modified:** `site/src/pages/[service].astro` (single file under construction; not yet committed)
- **Commit:** Folded into the same `feat(04-01)` commit (1c53489) since it's the initial implementation, not an after-the-fact fix.

### Auth Gates

None.

### No-Action Items (informational)

- 4 of 6 service stubs (`beard-trim`, `hot-towel-shave`, `kids-cuts`, `line-up`) lack the optional `heroPhoto` frontmatter field. The template's fallback to `03-interior-hero.jpg` handles these correctly. Setting explicit per-service heroPhoto values is content authoring, scoped to Plan 04-02.
- Stub `bluf` strings are short (~20 words). The plan acknowledges this is expected pre-Plan-04-03 ("Plan 3 will lengthen the BLUF to ~100 words; template just renders the field"). The template renders whatever the field contains — no hardcoded BLUF text in the route file.

## Known Stubs

| File | Line | Reason |
|------|------|--------|
| `site/src/content/services/{beard-trim,classic-cut,fades,hot-towel-shave,kids-cuts,line-up}.md` | `faqs: []` (frontmatter) | Plan 04-03 (programmatic-seo authoring) populates the FAQ array. Template renders the `<section class="faq">` shell with an empty `.faq-list` div — does not break audit grep for the section, just renders no Q&As. |
| Same files | `bluf` stubs (~20 words) | Plan 04-03 expands to AEO-shaped ~100-word answer capsules. Template is BLUF-field-agnostic; no template change required. |

These stubs are intentional — the plan explicitly scopes content authoring to Plan 04-03. The route template ships in Plan 04-01; content fills in Plan 04-03.

## Self-Check: PASSED

- File `site/src/pages/[service].astro` exists ✓
- Commit `1c53489` exists in `git log` ✓
- All 6 dist files (`fades`, `classic-cut`, `kids-cuts`, `beard-trim`, `line-up`, `hot-towel-shave`) materialized in `site/dist/` ✓
- Existing pages (`about`, `east-county-traditional-barbershop`, `2026-east-county-barbershop-cost-guide`, `faq`, `reviews`, `index`) still build → no route-precedence collision ✓
- Dynamic-route auto-gen test passed (test-service.md added → built → removed) ✓
