# Phase 4: Templated Pages - Context

**Gathered:** 2026-05-09
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 4 ships the 11 data-driven pages that turn Joe's Barbershop into an AEO citation hub:

1. **6 service pages** (`/fades`, `/kids-cuts`, `/beard-trim`, `/hot-towel-shave`, `/line-up`, `/classic-cut`) — each one becomes the dedicated answer surface for that service's query family ("fade haircut El Cajon", "where to get a kids haircut Bostonia", etc.).
2. **5 neighborhood pages** (`/bostonia-barber`, `/el-cajon-barber`, `/santee-barber`, `/lakeside-barber`, `/la-mesa-barber`) — each one captures micro-local queries for that neighborhood and signals `areaServed` to AI parsers.

The phase delivers (a) the Astro dynamic-route scaffolding that generates all 11 pages from the existing content collections without copy-pasting templates, (b) the AEO-shaped copy authored via marketing-skills (replacing the Phase 2 stubs), and (c) the internal-link mesh between the 11 pages plus connections to homepage, niche-landing, cost guide, and FAQ.

This phase deliberately defers:

- All JSON-LD schema emission (HairSalon, Service, FAQPage, LocalBusiness with areaServed) — Phase 5 (`AEO-01..09`).
- Lighthouse perf tuning (`PERF-01..04`), full meta tag suite (`META-01..04`), `robots.txt` and sitemap polish — Phase 5.
- Live deployment / Joe sign-off — Phase 6 (`SHOW-01`).

ROADMAP success criterion #3 from Phase 3 ("no 404s from cost guide service/neighborhood links") is FINALLY validated end-to-Phase-4 — the 11 routes Phase 3 wrote links to now resolve to 200.

</domain>

<decisions>
## Implementation Decisions

### Routing Structure

- **D-01:** Both routes are flat at the site root, NOT nested under section folders:
  - `src/pages/[service].astro` with `getStaticPaths()` returning the 6 service slugs → generates `/fades`, `/classic-cut`, `/kids-cuts`, `/beard-trim`, `/line-up`, `/hot-towel-shave`.
  - `src/pages/[neighborhood]-barber.astro` with `getStaticPaths()` returning the 5 neighborhood slugs (without the `-barber` suffix; the suffix is in the file name) → generates `/bostonia-barber`, `/el-cajon-barber`, `/santee-barber`, `/lakeside-barber`, `/la-mesa-barber`. **Rationale:** flat root URLs are the dominant Astro convention for local-business / AEO sites (cleaner AI citations, slug-as-keyword-target). All prior project artifacts (ROADMAP success criteria, Phase 3 cost guide D-15/D-16, niche-landing areaServed list) already write these slugs at root — going nested would require retroactive edits to multiple committed pages AND would actively work against the AEO play.
- **D-02:** REQUIREMENTS.md PAGE-07 currently reads `src/pages/services/[slug].astro` — that wording is **stale** and contradicts the canonical flat-route decision. Mirrors the Phase 2 D-12 stale-text pattern (where REQUIREMENTS.md DESN-04 had `public/photos/` instead of `src/assets/photos/`). Treat the literal route file in this CONTEXT.md (`src/pages/[service].astro`) as canonical; queue the wording fix for the next `/gsd-transition` after Phase 4 ships. **Note for executor:** do NOT create a `src/pages/services/` directory; the slug `/fades` lives at site root.
- **D-03:** Astro route precedence: dynamic routes `[service].astro` and `[neighborhood]-barber.astro` only generate the explicit slugs returned by their respective `getStaticPaths()`. Specific routes (`/about.astro`, `/faq.astro`, `/reviews.astro`, etc.) win over dynamic routes by Astro's built-in precedence rules. No collision between `[service].astro` and existing pages — `getStaticPaths()` for `[service].astro` returns ONLY the 6 service slugs, so paths like `/about` never match the dynamic route.

### Service Page Composition

- **D-04:** Service template skeleton (consumed by `src/pages/[service].astro`):
  ```
  Header (eyebrow + H1) → BLUF capsule (~100 words)
  → Hero photo (from heroPhoto field; lazy-load below the BLUF)
  → Price callout block (dedicated styled block)
  → Prose section ("What this service is" + "What's different at Joe's")
  → "See also" related services (2-3 sibling service links + cost guide link)
  → areaServed list (5 neighborhood links)
  → FAQ (flat H3/p, count variable per service)
  → ClosingCTA
  ```
  Mirrors the Phase 3 niche-landing archetype (`east-county-traditional-barbershop.astro`) plus a service-specific price callout. Reuses the locked component set per Phase 3 D-17: shared chrome + atoms (`FAQ`, `ClosingCTA`, `CheckDivider`, `SectionMark`); does NOT reuse `Hero`, `FactStrip`, `PriceBoard`, `Heritage` (homepage-only).
- **D-05:** Hero photo is rendered on every service page from each collection file's `heroPhoto` field. Existing services have `heroPhoto: "05-mid-cut.jpg"` for `/fades`; planner picks fallbacks for services without a natural fit (likely `03-interior-hero.jpg` or `06-price-board-cash-only.jpg` — Joe's existing 6-photo set is the only source). Photo renders below-the-fold (after BLUF) with `loading="lazy"`. Hero on these pages is NOT the OD-5 `<Hero>` component — it's a simple `<Image />` block scoped to this template.
- **D-06:** Each service page has a **dedicated price callout block** (NOT just inline mention). Visual treatment echoes the OD-5 `PriceBoard` heritage (board font, large $30 callout, 'cash only' tag, duration string from `duration` collection field) without reusing the `PriceBoard` component itself (homepage-only per D-17). **Rationale:** price is one of the highest-cited fields for service queries — AI parsers extract structured price + duration pairs from styled callouts more reliably than from prose. Phase 5 will wrap this with `Service` + `Offer` JSON-LD.
- **D-07:** **FAQ count is variable per service** — the marketing-skills chain (D-12) decides count based on which questions are actually asked about each service. Inputs/01-page-list.md specs "4–5 FAQs" for service pages; treat that as a soft target, not a hard count. `/fades` may carry 6 (popular service, more long-tail queries); `/line-up` may carry 3. Schema enforces shape (per Phase 2 D-22), not count.
- **D-08:** Service-page cross-link strategy — **belt-and-suspenders mesh**:
  - **areaServed list block:** all 5 neighborhood links rendered as a dedicated block ("Available across East County"), styled like the niche-landing's areaServed list. Mirrors the Phase 3 cross-link guarantee pattern (D-15).
  - **"See also" related services block:** 2-3 sibling service links chosen by planner/skill (e.g., `/fades` links to `/classic-cut` + `/line-up`) + 1 link to `/2026-east-county-barbershop-cost-guide`. Surfaces internal-link mesh density that the AEO playbook calls for.
  - **Inline links in prose:** secondary mesh — natural mentions of related services or neighborhoods in body prose (e.g., "Fades pair well with a [beard line-up](/beard-trim)"). Skill chain produces these where prose flow allows.

### Neighborhood Page Composition

- **D-09:** Neighborhood template skeleton (consumed by `src/pages/[neighborhood]-barber.astro`):
  ```
  Header (eyebrow + H1) → BLUF capsule (~100 words)
  → Storefront photo (shared 02-storefront.jpg on every neighborhood)
  → "Getting here from {neighborhood}" block (distance + 2-3 landmarks)
  → Prose section ("How Joe's serves {neighborhood}")
  → Visit/NAP block (address + phone + hours)
  → Services block (all 6 service links: "What we cut for {neighborhood} customers")
  → Cross-links: niche-landing /east-county-traditional-barbershop + cost guide
  → FAQ (flat H3/p, 3-4 Q&As per inputs/01-page-list.md)
  → ClosingCTA
  ```
  Same archetype as services minus the price callout, plus a landmarks/distance block, plus a NAP block. Reuses the same component set as services per D-04.
- **D-10:** **Shared storefront photo on every neighborhood page** — render `02-storefront.jpg` (from `business.json` `photos.storefront`) on all 5 neighborhood pages. **Rationale:** photo signals "this is the actual shop" for local-trust queries; rotating per-neighborhood photography is out of scope (PROJECT.md photo-set constraint — 6 existing photos, no in-shop visit). Same lazy-load + `<Image />` pattern as services. Schema has no `heroPhoto` field for neighborhoods, so render directly from `business.json` rather than collection frontmatter.
- **D-11:** **Dedicated "Getting here from {neighborhood}" block** with structured distance + landmarks display (NOT prose-embedded only). Format: distance string from collection (`distance` field, e.g., "2.1 mi from shop") + bulleted landmark list from `landmarks` array (e.g., "Sycuan Casino", "Parkway Plaza"). Strong AEO signal — AI parsers extract structured distance/landmark pairs from this format more reliably than from prose. **Note:** existing collection stubs have weak landmarks (`["Bostonia area", "East County San Diego"]`) — Phase 4 copy authoring (D-12) populates real landmarks per neighborhood from vault knowledge / planner research. Distance strings need real values too — currently stubs say `"local"` for most neighborhoods.

### Visit/NAP Block

- **D-12:** **Visit/NAP block on every neighborhood page** (NOT just Footer). Reuses the existing `Visit.astro` component. **Rationale:** local-SEO best practice — NAP repetition across micro-local pages reinforces business identity for Google + AI parsers; in-content NAP carries more weight than Footer NAP for citation matching. Service pages do NOT repeat the Visit block — the price callout already provides the structural signal services need; doubling up would be redundant.

### Neighborhood Cross-Links

- **D-13:** Each neighborhood page links to **all 6 services + niche-landing + cost guide** (full mesh). Layout: a single "What we cut for {neighborhood} customers" block with 6 service links, plus 2 dedicated link slots for `/east-county-traditional-barbershop` (the AEO win the niche-landing locks in) and `/2026-east-county-barbershop-cost-guide`. Mirrors the service-page belt-and-suspenders pattern (D-08). **Rationale:** neighborhood pages are the citation surface for "is there a barber in {town}" queries — the answer needs to immediately surface "yes, and they cut these things, and here's the price comparison." Mesh density is the play.

### Copy Authoring Approach

- **D-14:** **Hybrid skill chain:** `marketing-skills:programmatic-seo` for the bulk baseline (all 11 pages) + per-page `marketing-skills:copywriting` polish on the 4 strategic pages.
  - **Bulk baseline (programmatic-seo):** runs twice — once for the 6 services, once for the 5 neighborhoods. Consumes `.agents/product-marketing-context.md` (set up in Phase 3 D-03) and `.agents/aeo-frame.md` (Phase 3 D-04 / `marketing-skills:ai-seo` output). Produces baseline BLUF + prose + FAQs for each page in a consistent voice. **Per-page primary queries** injected as inputs:
    - `/fades` → "fade haircut El Cajon / East County"
    - `/kids-cuts` → "kids haircut Bostonia / East County family barbershop"
    - `/beard-trim` → "beard trim / line-up East County"
    - `/hot-towel-shave` → "hot towel shave El Cajon / traditional straight-razor shave"
    - `/line-up` → "line-up barber East County"
    - `/classic-cut` → "classic men's haircut El Cajon / traditional barbershop cut"
    - `/bostonia-barber` → "barber in Bostonia / Bostonia barbershop"
    - `/el-cajon-barber` → "barber in El Cajon / El Cajon barbershop"
    - `/santee-barber` → "barber in Santee / Santee barbershop"
    - `/lakeside-barber` → "barber in Lakeside / Lakeside barbershop"
    - `/la-mesa-barber` → "barber in La Mesa / La Mesa barbershop"
  - **Polish pass (copywriting):** per-page invocation on the 4 strategic pages — `/fades`, `/bostonia-barber`, `/el-cajon-barber`, `/kids-cuts` — consuming the same `.agents/` files plus the programmatic-seo baseline as input. Polish tightens BLUF, sharpens differentiators, and aligns with the strategic angles each page carries:
    - `/fades` — highest service search volume; broadest AI-citation surface.
    - `/bostonia-barber` — Joe's literal home neighborhood; primary local-citation surface.
    - `/el-cajon-barber` — biggest market name; highest competition with chain results.
    - `/kids-cuts` — family-friendly differentiator; ties the family signal back to Joe's strategic angle.
- **D-15:** Authoring outputs go directly into the content collection markdown files at `site/src/content/services/{slug}.md` and `site/src/content/neighborhoods/{slug}.md`. Frontmatter `bluf` / `faqs` / `landmarks` / `distance` fields get populated; markdown body holds the prose section. The route templates (`[service].astro`, `[neighborhood]-barber.astro`) read these via `getCollection()` per Phase 2 D-24.
- **D-16:** **No manual review gate** between skill output and commit (mirrors Phase 3 D-02). Commits land per page; user reviews on the eventual Vercel preview, not in the editor. Skills must be configured carefully (the global `.agents/aeo-frame.md` from Phase 3 is the load-bearing input — if it's drifted since Phase 3, regenerate before running programmatic-seo). If a skill output is obviously wrong (factually incorrect, off-brand, hallucinated landmarks), executor flags it and asks the user — does NOT commit broken output.
- **D-17:** **Voice consistency:** the `marketing-skills:programmatic-seo` skill must produce voice consistent with the Phase 3 unique pages. The `.agents/product-marketing-context.md` and `.agents/aeo-frame.md` files Phase 3 generated are reused as-is. If post-baseline review reveals voice drift across the 11 templated pages relative to Phase 3, the global frame is the place to fix (per Phase 3 D-04 / D-17 specifics) — NOT per-page tweaking after generation.

### Claude's Discretion

- Exact prose phrasing in skill-generated copy — skills produce, executor commits (per D-16).
- Selection of 2-3 "related services" for each service page's "See also" block — planner / skill picks based on natural-pairing (e.g., `/fades` → `/classic-cut` + `/line-up`; `/hot-towel-shave` → `/beard-trim` + `/classic-cut`). No hard constraint here.
- Distance string format for neighborhoods — `"2.1 mi from shop"` vs `"a 5-minute drive"` vs `"2.1 mi · 8-min drive"`. Recommend keeping the existing `"2.1 mi from shop"` style with a structured number-prefix for AI parsing; planner picks final format.
- Source for landmark data per neighborhood — vault knowledge (`joes-barbershop-sandbox.md` audit baseline), Joe's local knowledge, or web-search confirmation per neighborhood. Planner researches.
- Which photo to use as service-page hero when `heroPhoto` field doesn't have a natural fit — fallback to `03-interior-hero.jpg` or `06-price-board-cash-only.jpg`. Planner picks per service.
- Whether to add a `dateModified` line to each templated page (matches the Phase 3 niche-landing pattern). Recommend yes — supports `dateModified` schema in Phase 5.
- Per-page eyebrow text and H1 phrasing — skill-generated within the AEO frame.
- Whether to expose a `<UniquePageLayout>` wrapper between `Base.astro` and these templated pages. Recommend NOT introducing a new layer — the niche-landing didn't need it (Phase 3 D-17 specifics) and the templated pages have similar shape; one-Base-many-templates stays the pattern.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 4 Inputs

- `inputs/00-brief.md` — project brief; audience + tone + visual cues + anti-prompts. Source for `marketing-skills:product-marketing-context` (already consumed in Phase 3, but `.agents/product-marketing-context.md` regeneration may need this if drift detected).
- `inputs/01-page-list.md` — 17–19 page architecture; defines per-page primary queries, schema priority, FAQ count targets ("4–5 FAQs" services, "3–4 FAQs" neighborhoods), template strategy. **Source of truth for the 11 templated pages' structural requirements.**
- `inputs/02-aeo-constraints.md` — load-bearing AEO rules. Encoded in `.agents/aeo-frame.md` from Phase 3; reused by Phase 4 programmatic-seo per D-14. **MUST read** before any copy authoring.
- `inputs/03-photo-notes.md` — what each of the 6 photos shows; defines `02-storefront.jpg` as the shared neighborhood photo and `05-mid-cut.jpg` as `/fades` hero (already in collection).

### Phase 3 Carry-Forward (REQUIRED before planning)

- `.planning/phases/03-unique-pages/03-CONTEXT.md` — Phase 3 decisions, especially:
  - **D-01..05** — marketing-skills chain blueprint (Phase 4 reuses `.agents/product-marketing-context.md` and `.agents/aeo-frame.md`).
  - **D-15..16** — cost guide cross-link strategy and canonical Phase 4 slugs (Phase 4 routes resolve these).
  - **D-17** — component reuse rules (Hero/FactStrip/PriceBoard/Heritage are homepage-only; FAQ/ClosingCTA/Visit/CheckDivider/SectionMark are reusable atoms).
  - **D-21** — niche-landing skeleton (Phase 4 service template mirrors this with price callout added; neighborhood template mirrors with landmarks block + Visit added).
- `.planning/phases/03-unique-pages/03-04-SUMMARY.md` (homepage parity) and `03-05-SUMMARY.md` (niche-landing) — implementation references for the page archetype Phase 4 reuses.
- `.planning/phases/03-unique-pages/scripts/audit.sh` — Phase 3 validation infra; Phase 4 extends with the 11 new slug checks.
- `.planning/phases/03-unique-pages/scripts/canonical-slugs.txt` — canonical Phase 4 slugs were committed here in Phase 3 D-16; Phase 4's audit verifies all 11 resolve to 200.

### Phase 2 Carry-Forward

- `.planning/phases/02-data-design-system/02-CONTEXT.md` — especially:
  - **D-16** — marketing-skills chain forward-looking guidance; Phase 4 elaborates the `programmatic-seo` portion in current D-14.
  - **D-22, D-23, D-24** — content collection schemas (services + neighborhoods) and `src/content.config.ts` flat path. **Phase 4 consumers MUST use the flat-path import** — `defineCollection` plus `getCollection('services')` / `getCollection('neighborhoods')`.
  - **D-26** — `<slot name="head" />` reserved for Phase 5 schema injection; Phase 4 leaves this slot unused (no JSON-LD).

### Project-Level Decisions

- `.planning/PROJECT.md` § Constraints — Astro / no-Tailwind / 6-photo limit / AEO structural rules / no-live-deployment-before-Joe-approves.
- `.planning/PROJECT.md` § Key Decisions — Astro / Vercel / OD CSS preserved / schema-from-business.ts / showcase-first.
- `.planning/REQUIREMENTS.md` § Pages — Templated — PAGE-07, PAGE-08 literal text. **Source of truth for what the 11 templated pages must contain.** Note PAGE-07 `src/pages/services/[slug].astro` wording is stale per D-02 — treat the technical reality (flat root) as canonical.
- `.planning/ROADMAP.md` § Phase 4 — goal, depends-on (Phase 3), success criteria #1-#3. **Acceptance gate.** Success criterion #1 lists the 6 service slugs at root (`/fades`, etc.); criterion #2 lists the 5 neighborhood slugs at root.

### Vault References (knowledge base — DO NOT duplicate into repo)

- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — audit baseline; primary source for landmarks per neighborhood and any Joe-specific differentiation per service. Already a load-bearing input for `marketing-skills:product-marketing-context` (Phase 3 D-03).
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` — AEO mechanics + Toronto plumber 20–40-page benchmark + comparative-listicle 32.5%-citation-lift evidence. Justifies the 11-page templated mesh.
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-visual-direction.md` — strategic visual narrative (informs voice + heritage framing for skill-generated copy).
- `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` — master voice reference (consulted IF skill output drifts; D-16's no-review-gate makes this less load-bearing, but still relevant if drift detected).
- `~/Documents/DT Vault/3-resources/writing-style-guide-anti-ai-voice.md` — banned words/phrases, anti-AI patterns. Skill chain should respect.

### Live Repo State (Phase 2/3 outputs Phase 4 consumes)

- `site/src/content.config.ts` — content collection definitions (Astro 6 flat path; Zod schemas locked per Phase 2 D-22..24).
- `site/src/content/services/*.md` (6 stub files) and `site/src/content/neighborhoods/*.md` (5 stub files) — **stub bodies in place; Phase 4 replaces** with real BLUF + prose + FAQs + populated landmarks/distance per D-15.
- `site/src/data/business.json` + `site/src/data/business.ts` — canonical NAP / hours / prices / ratings / sameAs / photos / areaServed. Service pages use `business.prices.*` and `business.ratings.*`; neighborhood pages use `business.address.*` + `business.phone` + `business.hours.*` for the Visit block + `business.photos.storefront` for the shared photo.
- `site/src/components/{FAQ,ClosingCTA,Visit,CheckDivider,SectionMark}.astro` — reusable atoms per D-04, D-09. Component prop APIs locked from Phase 2.
- `site/src/components/{Hero,FactStrip,PriceBoard,Heritage}.astro` — **homepage-only**; do NOT import in Phase 4 templates per D-04.
- `site/src/layouts/Base.astro` — shared HTML shell with locked section ordering and `<slot name="head" />` (unused this phase).
- `site/src/styles/{tokens.css,utilities.css}` — global tokens + shared atoms (`.wrap`, `.eyebrow`, `.kicker-rule`, `.display`, `.check-divider`, `.section-mark`, `.section-head`, `.btn`). Already imported in `Base.astro`. Phase 4 templates style their bespoke sections (price callout, landmarks block) with scoped `<style>` blocks consuming these tokens.
- `site/src/pages/east-county-traditional-barbershop.astro` — niche-landing archetype Phase 4 service/neighborhood templates mirror (article-shaped: header → BLUF → prose → mesh → FAQ → CTA).
- `site/src/pages/2026-east-county-barbershop-cost-guide.astro` — cost guide; Phase 3 D-15/D-16 wrote inline links to all 11 Phase 4 slugs. Phase 4 routes finally resolve these to 200.
- `site/src/assets/photos/` — 6 photos. `02-storefront.jpg` = shared neighborhood photo (D-10); `05-mid-cut.jpg` = `/fades` hero (already in collection); fallbacks for other services per planner discretion.
- `.agents/product-marketing-context.md` — generated in Phase 3 D-03 by `marketing-skills:product-marketing-context`. Phase 4 reuses as-is unless drift detected.
- `.agents/aeo-frame.md` (or wherever Phase 3 stored the `marketing-skills:ai-seo` output) — generated in Phase 3 D-04. Phase 4 reuses as-is.

### External Tools (executor invokes)

- `marketing-skills:programmatic-seo` — bulk baseline for all 11 pages per D-14. Two invocations (services × 6, neighborhoods × 5).
- `marketing-skills:copywriting` — polish pass on `/fades`, `/bostonia-barber`, `/el-cajon-barber`, `/kids-cuts` per D-14.
- `getCollection()` (Astro built-in) — consumer of services and neighborhoods collections in route templates.
- Web search (planner) — landmark research per neighborhood if vault baseline insufficient.

### Astro / Tooling Docs

- Astro 6 dynamic-route docs — `[param].astro` file naming, `getStaticPaths()` patterns, `[neighborhood]-barber.astro` mixed-segment routing. Researcher reads as needed.
- Astro Content Collections docs — `getCollection()`, frontmatter access, body rendering with `<Content />`.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- **Niche-landing archetype** (`site/src/pages/east-county-traditional-barbershop.astro`): the article-shaped page Phase 4 templates mirror. Section pattern: `.article-head` → `.bluf` → `.prose` → `.area-served` → `.faq` → `<ClosingCTA>`. Scoped `<style>` block defines the article-page typography (max-width 820px column, BLUF lead with accent border-left, FAQ grid layout). Phase 4 templates copy this pattern with section additions per D-04 / D-09.
- **Cost guide page** (`site/src/pages/2026-east-county-barbershop-cost-guide.astro`): already writes inline links to all 11 Phase 4 slugs (`/fades`, `/classic-cut`, `/bostonia-barber`, etc.). Phase 4 routes resolve these to 200 — no link edits required in Phase 4.
- **Content collection stubs** (`site/src/content/services/*.md`, `site/src/content/neighborhoods/*.md`): 11 files exist with schema-passing frontmatter. Body says "Stub content — Phase 3/4 replaces with AEO-optimized prose and FAQs." Phase 4 swaps these in.
- **`Base.astro` `variant` prop**: niche-landing uses `variant="article"` — implies Phase 2 wired a layout-variant prop. Service + neighborhood templates likely use the same variant for consistent article-shape rendering.
- **`Visit.astro` component**: renders address + phone + hours from `business`. Phase 4 imports on neighborhood pages per D-12.
- **`FAQ.astro` component**: takes `items` prop (per Phase 3 D-19 inline pattern). Phase 4 templates pass `entry.data.faqs` (or each entry's parsed FAQs) into this component.
- **6 photos** in `site/src/assets/photos/`: `02-storefront.jpg` (shared neighborhood photo), `03-interior-hero.jpg` (fallback service hero), `05-mid-cut.jpg` (default `/fades` hero, already in collection), `06-price-board-cash-only.jpg` (potential price-callout backdrop or service-page fallback hero).

### Established Patterns

- **Astro 6 flat-path content collections**: `src/content.config.ts` (NOT `src/content/config.ts`) with `defineCollection({ loader: glob({...}), schema: z.object({...}) })`. Phase 2 D-24 locks this path; Phase 4 consumers must use `getCollection('services')` / `getCollection('neighborhoods')`.
- **Article-page typography** (Phase 3): `.bluf` block with `border-left: 3px solid var(--accent)` and `surface` background; `.prose` with 70ch max-width; FAQ grid with `60px 1fr` template columns and numbered `<span class="num">` markers. Phase 4 templates copy these styles directly into their scoped `<style>` blocks (or move to a shared `article-page.css` if duplication grows — planner judgment).
- **`data-host` / `data-archetype` markers**: cost guide uses `data-host` for Joe's entry accent and `data-archetype` for fallback entries (Phase 3 D-13/D-14). Phase 4 doesn't need these — services and neighborhoods are not competitor entries.
- **No `client:*` directives**: zero-JS DOM is an AEO requirement. Phase 4 pages stay static.
- **Per-component / per-page scoped CSS**: Astro `<style>` is scoped by default. Phase 4 templates define their bespoke section styles (price callout, landmarks block, Visit-on-neighborhood) inline.
- **Skill chain output writes to collection markdown**: Phase 4 D-15 — programmatic-seo / copywriting outputs go directly into `site/src/content/services/{slug}.md` and `site/src/content/neighborhoods/{slug}.md` frontmatter + body, NOT into the `.astro` template files. Templates read via `getCollection()`.

### Integration Points

- **Page → Base layout**: `import Base from '../layouts/Base.astro';` then `<Base title="..." description="..." variant="article">...</Base>`. Service + neighborhood templates wrap their body in `<Base>` per the niche-landing pattern.
- **Page → business data**: `import { business } from '../data/business';` for NAP / hours / photos / ratings / prices.
- **Page → collection entry**: `const entry = await getEntry('services', Astro.params.service)` (or `'neighborhoods'`); `<Content />` for body; `entry.data.bluf` / `entry.data.faqs` / `entry.data.landmarks` / etc. for frontmatter access.
- **Page → photos**: `import storefront from '../assets/photos/02-storefront.jpg';` then `<Image src={storefront} loading="lazy" />`. Service heroPhoto field is a string filename — template resolves to import or uses `<Image>` `src={...}` with a lookup.
- **Page → reusable atoms**: `import FAQ from '../components/FAQ.astro';` `import Visit from '../components/Visit.astro';` `import ClosingCTA from '../components/ClosingCTA.astro';`. Each takes specific props per Phase 2 component contracts.
- **Phase 5 schema slot**: `Base.astro`'s `<slot name="head" />` is unused in Phase 4. Phase 5 will pass `Service` / `LocalBusiness with areaServed` / `FAQPage` / `Offer` JSON-LD blocks via that slot.
- **Audit script integration**: Phase 3's `scripts/audit.sh` checks the Phase 3 page slugs. Phase 4 extends to verify all 11 Phase 4 slugs return 200 (success criterion #3 from ROADMAP) and that the 6 service collection entries / 5 neighborhood entries each populate non-empty BLUF + non-empty FAQs (acceptance for D-15 swap-in).

</code_context>

<specifics>
## Specific Ideas

- **The 11 templated pages are the AEO citation-surface multiplier** — without them the site is a 6-page boutique that gets no AI citations; with them it's a 17-page hub that hits the Toronto plumber benchmark sweet spot. The mesh density (services↔neighborhoods cross-linking per D-08, D-13) IS the AEO play, not decoration.
- **Voice anchor is unchanged from Phase 3**: working-class East County, heritage barbershop, no-frills, family-friendly, walk-ins-welcome, cash-only-as-positioning. Avoid "we're more than a barbershop" generic opens (anti-pattern in `inputs/02-aeo-constraints.md`). The `.agents/aeo-frame.md` from Phase 3 already encodes this; reuse as-is.
- **Per-page primary queries (D-14) are the load-bearing programmatic-seo input.** Each page's BLUF must answer its own primary query, not a generic "barbershop in El Cajon." Voice and structure are uniform across the 11; specifics differ.
- **Real landmark data per neighborhood is a vault-knowledge ask.** Existing collection stubs have placeholder landmarks (`["Bostonia area", "East County San Diego"]`) — Phase 4 planner pulls real landmarks from the vault audit baseline + planner research. Bostonia → Sycuan Casino, Parkway Plaza. El Cajon → Westfield Parkway. Santee → Santee Town Center, Lakes. Lakeside → Lakeside Rodeo Grounds. La Mesa → La Mesa Village, Grossmont Center. Planner verifies before commit.
- **Price callout (D-06) is the structural signal AI parsers extract for service pricing.** Inline-only mention ranks lower for "what does X cost at Joe's" queries. Visual treatment echoing the OD-5 PriceBoard heritage gives both human visual coherence AND structured-data signal.
- **`/east-county-traditional-barbershop` is the AEO "win" page** (Phase 3 D-21). Phase 4 service + neighborhood pages reinforce it — every service links to it; every neighborhood links to it. Does NOT compete with it (the niche-landing covers "traditional barbershop East County" as a category; Phase 4 pages cover specific services and specific neighborhoods).
- **Stub content body in collection markdown is a DELETE before Phase 4 ships.** Phase 4 verification: zero matches for "Stub content — Phase 3/4 replaces" under `site/src/content/`.
- **`/kids-cuts` polish (D-14) ties to Joe's strategic differentiator.** "Family walk-ins" is a real differentiator in the East County market (Latino + Anglo working-class audience, family-friendly positioning). The polish should make this page the canonical answer for "family barbershop near me / kids haircut Bostonia" — not just one of 6 service pages.

</specifics>

<deferred>
## Deferred Ideas

- **JSON-LD schema emission on all 11 templated pages** — Phase 5 (`AEO-01..09`). Phase 4 builds visible content compatibly: service pages have price/duration/FAQs ready for `Service` + `Offer` + `FAQPage` schema; neighborhood pages have NAP/landmarks/areaServed ready for `LocalBusiness with areaServed` schema. Phase 5 wraps with `<script type="application/ld+json">` blocks via `Base`'s `<slot name="head" />`.
- **Lighthouse perf tuning + meta tag suite** — Phase 5 (`PERF-01..04`, `META-01..04`). Phase 4 sets `<title>` + `<meta name="description">` for dev visibility only; full meta + Open Graph + Twitter Card + sitemap polish + robots.txt land in Phase 5.
- **`/contact` (page 18, optional) and `/blog/[seasonal-post]` (page 19, optional)** — out of scope for Phase 4 v1 templated set per `inputs/01-page-list.md` table. Could land later if Joe's booking flow needs a dedicated contact surface or if a freshness signal is needed.
- **Per-neighborhood photography** — out of scope for v1 (PROJECT.md photo-set constraint: 6 photos, no in-shop visit). Could land post-showcase if Joe approves an in-shop visit.
- **Programmatic-SEO scale-up beyond 11 pages** — Phase 4 ships exactly 11. The skill's "scale" capability supports many more; deferred as a v2 expansion if AEO measurement (Phase 7) shows specific query gaps.
- **Per-service "deeper variant" pages** (e.g., `/fades/skin-fade`, `/fades/burst-fade`) — sub-niching deferred to v2. Toronto plumber benchmark says 20-40 pages is the sweet spot; sub-niching would push past 40.
- **Mid-page customer-quote ribbons on neighborhood pages** (e.g., a real Santee customer's review embedded mid-page) — could land in a future iteration once Phase 7 measurement shows where citation gaps are.
- **Auto-generated `<RelatedServices>` / `<RelatedNeighborhoods>` components** — could replace the manual cross-link blocks if the mesh grows past 11. Deferred — not needed at v1 size.
- **REQUIREMENTS.md PAGE-07 wording fix** (`src/pages/services/[slug].astro` → flat-route) — apply at next `/gsd-transition` after Phase 4 ships, mirroring Phase 2 D-12.
- **`marketing-skills:programmatic-seo` skill drift / regeneration of `.agents/aeo-frame.md`** — only triggers if Phase 4 baseline output shows voice drift from Phase 3. Default path is reuse-as-is per D-17.
- **kidsCut price confirmation** (`business.json` field is `null`) — pending Joe's confirmation at showcase. Phase 4 `/kids-cuts` page will likely show the haircut price ($30) inherited or note "TBD pending confirmation" until Joe confirms.

</deferred>

---

*Phase: 4-Templated Pages*
*Context gathered: 2026-05-09*
