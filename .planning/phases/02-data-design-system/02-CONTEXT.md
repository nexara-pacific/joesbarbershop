# Phase 2: Data + Design System - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 2 builds the foundation that page-building phases consume. After this phase:

- A typed `business.ts` exports a single source of truth for NAP, hours, prices, ratings, sameAs, photos, and areaServed — every page imports it.
- Two content collections (`services`, `neighborhoods`) are configured with Zod schemas; **11 schema-passing entries** (6 services + 5 neighborhoods) exist with stub frontmatter and short body, sufficient for `getCollection()` to validate without errors. **Real BLUF prose, full FAQs, and full markdown bodies are NOT authored here** — they land in Phase 3 (unique pages) and Phase 4 (templated pages) using marketing skills.
- The OD-5 design is ported into Astro: 12 named components extracted from `mockups/home-v5/index.html`, design tokens preserved exactly, live-tweaks panel removed. A scratch Astro page renders pixel-identical to the mockup.
- 6 photos live in `site/src/assets/photos/` and render through Astro `<Image />` with AVIF/WebP/srcset processing.

This phase deliberately defers all page-level copy authoring, all per-page schema (JSON-LD) emission, and all routing for templated pages. Phases 3 and 4 are the page builders; Phase 5 is the schema/perf/meta phase.

</domain>

<decisions>
## Implementation Decisions

### OD-5 Mockup Source

- **D-01:** OD-5 mockup is now at `mockups/home-v5/index.html` (md5 `75e4749bbe4c9e2d4993bfa6744d3cdc`, 822 lines, 48 KB). Copied during discuss-phase from `~/Downloads/joes-barbershop-home-5.html` (originally exported 2026-05-06). It is committed alongside this CONTEXT.md so the repo is self-contained from this point on.
- **D-02:** The mockup is a single-file inlined HTML export with `<style>` block containing all design tokens (oklch palette, font stack: IM Fell English / Playfair Display / DM Serif Display / Newsreader / Oswald / JetBrains Mono), and includes the live-tweaks panel (`.tweaks` class, `data-font` / `data-checker` body attributes). DESN-03 strips the tweaks panel during port — see decision D-09.

### Component Extraction (DESN-02)

- **D-03:** The 12 named components in DESN-02 are LOCKED: `UtilBar`, `Masthead`, `Hero`, `FactStrip`, `PriceBoard`, `Heritage`, `Visit`, `FAQ`, `ClosingCTA`, `Footer`, `CheckDivider`, `SectionMark`. Planner does not rename, merge, or remove any of them.
- **D-04:** If mockup inspection reveals additional reusable bits (e.g., a quote block, an hours sub-block, a NAP card), planner may add them as **derived extras** under explicit names — but never at the cost of one of the 12. Document any extras in PLAN.md with the mockup line range they came from.
- **D-05:** Phase 1 stub components (`UtilBar`, `Masthead`, `Footer`) carry `data-phase1-stub="..."` markers on their outer element. Phase 2 removes these attributes when replacing stub bodies with the OD-5 content. Verification: after Phase 2, `grep -r data-phase1-stub site/src/` returns zero matches.

### CSS Port Strategy (DESN-01)

- **D-06:** Per-component scoped `<style>` in each `.astro` file is the default. Component-specific selectors (`.util-bar`, `.masthead`, `.hero`, `.fact-strip`, `.price-board`, `.heritage`, `.visit`, `.faq`, `.closing-cta`, `.footer`) move into the matching component's `<style>` block. **Rationale:** locality of markup + styles minimizes handoff cost — this is the user's explicitly stated maintenance priority.
- **D-07:** Globals live in `site/src/styles/tokens.css` (the `:root { --bg, --surface, --fg, --muted, --border, --hairline, --accent, --accent-2, --gold, --board-bg, --board-fg, --check-fg, --check-bg, --font-display-fell, --font-display-playfair, --font-display-dm, --font-display, --font-body, --font-board, --font-mono, --maxw, --gutter }` block, the `*, *::before, *::after { box-sizing: border-box }` reset, base `html, body, img, a` rules, and the `@font` Google Fonts `<link>` references) imported once in `Base.astro`.
- **D-08:** Small shared atoms — `.wrap`, `.eyebrow`, `.kicker-rule`, `.display`, `.check-divider`, `.section-mark` — go in `site/src/styles/utilities.css`, also imported once in `Base.astro`. **Rationale:** these classes appear in many components; duplicating per-component would be the wrong answer.
- **D-09:** When the planner finds a CSS rule that legitimately spans two components (e.g., a parent-child selector, a sibling selector), prefer in this order: (1) restructure markup so the rule lives in one component, (2) move the rule to `tokens.css`/`utilities.css` as a shared atom, (3) move the rule into the consuming component (parent). NEVER duplicate the rule across both files. Flag every such case in PLAN.md.
- **D-10:** Live-tweaks panel removal (DESN-03) — strip the `.tweaks` `<aside>` from the markup, remove the `.tweaks*` CSS rules from the port, and remove the `data-font` / `data-checker` attributes from `<html>`/`<body>`. Verification: `grep -r tweaks site/src/` and `grep -r 'data-font\|data-checker' site/src/` both return zero matches.

### Photos Directory (DESN-04)

- **D-11:** 6 existing photos in `inputs/photos/` (`01-logo.jpg`, `02-storefront.jpg`, `03-interior-hero.jpg`, `04-heritage-chair.jpg`, `05-mid-cut.jpg`, `06-price-board-cash-only.jpg`) are copied to `site/src/assets/photos/` — **NOT** `site/public/photos/`. **Rationale:** Astro `<Image />` only processes `src/`-based assets (AVIF/WebP/srcset/hash). Files in `public/` are served verbatim and break Phase 5 perf targets (PERF-03 fetchpriority on hero, LCP < 2.5s).
- **D-12:** REQUIREMENTS.md DESN-04 currently reads "site/public/photos/" — that wording is stale and contradicts Phase 1 research (`01-RESEARCH.md` Pitfall 5). Same wording correction queued for ROADMAP Phase 2 success criterion #5. Both updates happen at the next phase transition (`/gsd-transition` after Phase 2 ships) so REQUIREMENTS.md stays accurate going forward. **Note for executor:** treat the literal directory in this CONTEXT.md (`src/assets/photos/`) as the canonical target — the requirement text is the wrong-stale one.
- **D-13:** Filenames are preserved verbatim across the copy — no renaming. The `01-`/`02-`/etc. prefixes carry semantic ordering (logo → storefront → hero → heritage → mid-cut → price-board) that components reference by filename.
- **D-14:** Image rendering preference (per Phase 1 research): `<Picture formats={['avif','webp']} />` for the hero photo (`03-interior-hero.jpg`), `<Image />` for everything else. Hero gets `loading="eager"` + `fetchpriority="high"`; below-fold get `loading="lazy"`. Phase 5 PERF-03 verifies these attributes survive into the build.

### Content Authoring Depth (DATA-03, DATA-04)

- **D-15:** Phase 2 ships **schema-passing stubs only** for all 11 content entries. Each frontmatter has the load-bearing fields (price, duration for services; landmarks, distance for neighborhoods) populated with real data from `inputs/00-brief.md`, `inputs/01-page-list.md`, and `inputs/03-photo-notes.md` (the price board image gives the actual prices). BLUF, FAQ, and markdown body are placeholder text — long enough to satisfy any minimum-length schema constraint, short enough to make it obvious to a reader that this is a stub.
- **D-16** [informational]: Real prose authoring is a **Phase 3 + Phase 4 responsibility**. Forward-looking guidance for those phase planners (not a Phase 2 plan-trackable decision — recorded here so future phase planners pick up the marketing-skills chain without rediscovering it):
  - **Setup (one-time, runs at start of Phase 3):** invoke `marketing-skills:product-marketing-context` to set up `.agents/product-marketing-context.md` with Joe's positioning, audience (East County working-class Latino + Anglo, family-friendly, walk-ins, cash-only), and ICP. Subsequent skills reference this file.
  - **AEO frame:** invoke `marketing-skills:ai-seo` once to set the entity-first / answer-capsule / BLUF / no-hidden-content frame for all subsequent copy generation. Output stored as guidance the copywriting skill consumes.
  - **Unique pages (Phase 3 — homepage, niche-query landing, cost guide, about, reviews, FAQ):** invoke `marketing-skills:copywriting` per page. Each page gets a hand-tuned BLUF + section bodies + FAQs.
  - **Templated pages (Phase 4 — 6 services + 5 neighborhoods):** invoke `marketing-skills:programmatic-seo` to generate the 11 entries with consistent BLUF structure but page-specific specifics (per-service offerings, per-neighborhood landmarks).
- **D-17:** Stub schema must be designed so Phase 3/4 can drop in real prose without schema changes. That means the schema's BLUF/FAQ fields are typed as plain strings/arrays — no enum constraints on content, no minimum word counts (which would force planners to pad). The schema enforces **shape**, not **quality**.

### business.ts Shape & Data Source (DATA-01)

- **D-18:** business.ts is the **lean** shape — 7 fields exactly matching DATA-01: `name`, `address` (street/city/state/zip/suite), `phone`, `hours` (per weekday open/close), `prices` (haircut/shave/beardLineUp/cleanUp/kidsCut), `ratings` (per platform value + count), `sameAs` (URLs to GBP, Yelp, IG, FB), `photos` (paths or imports — TBD by planner), `areaServed` (array of neighborhood names). Plain JS shapes — NO schema.org `@type` shaping at this layer.
- **D-19:** Values live in `site/src/data/business.json`. `site/src/data/business.ts` does the import, applies a TypeScript `interface` (or `type`) named `BusinessRecord`, and re-exports as the typed `business` constant. **Rationale:** future-you (or Joe, or another dev) can edit JSON without touching TS; the JSON is the truth, the TS is the typed view. The single canonical source stays the JSON.
- **D-20:** Phase 5 (`AEO-01`/`AEO-04`) builds a `<HairSalonSchema />` and other schema components that import `business` and transform it into JSON-LD at render time. The transformation logic lives in those schema components — NOT in `business.ts`. business.ts stays generic.
- **D-21:** Source of canonical NAP, hours, prices, ratings, sameAs URLs:
  - NAP / suite / phone: pull from `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` (audit baseline). User confirms before commit.
  - Hours: pull from current GBP listing (Joe's actual schedule). User confirms before commit.
  - Prices: from `inputs/photos/06-price-board-cash-only.jpg` (HAIRCUT 30 / SHAVE 30 / BEARD LINE-UP 20 / CLEAN UP 15) — already documented in `inputs/03-photo-notes.md`. Plus `kidsCut` from `inputs/00-brief.md` if specified there; else mark TBD and ask Joe at showcase time.
  - Ratings: from current Google + Yelp public surfaces (4.9★ / ~91 Google reviews; 4.9★ / 33 Yelp reviews / 102 photos per PROJECT.md). Date-stamp the value.
  - sameAs: GBP URL, Yelp URL, IG handle URL, FB page URL. Per AEO-09, Booksy + Wikidata are deferred to v2 (`OFFS-01`, `OFFS-02`).

### Content Collection Schema (DATA-02)

- **D-22:** `services` collection schema (Zod): `slug` (auto-derived from filename), `title`, `price` (number), `duration` (string, e.g., "30 min"), `bluf` (string, stub OK in Phase 2), `faqs` (array of `{ q: string; a: string }`, can be empty in Phase 2), `heroPhoto` (optional, references a path under `src/assets/photos/`).
- **D-23:** `neighborhoods` collection schema (Zod): `slug` (auto-derived), `title`, `landmarks` (array of strings — e.g., "Parkway Plaza", "Sycuan Casino"), `distance` (string, e.g., "2.1 mi from shop"), `bluf` (string, stub OK), `faqs` (array, can be empty).
- **D-24:** Schema lives at `site/src/content.config.ts` (Astro 6 standard — flat path). Each entry is a `.md` file in `site/src/content/services/` or `site/src/content/neighborhoods/`. Frontmatter satisfies the schema; markdown body is the prose (stub in Phase 2). **SUPERSEDED-NOTE (2026-05-07):** earlier draft of this decision said `site/src/content/config.ts` (the legacy Astro 4 nested path); RESEARCH.md §Critical Finding documents that Astro 6.3.0 throws `LegacyContentConfigError` on the nested path and requires the flat path shown above. The flat path is canonical from this commit forward; any plan / executor that sees this decision should use `site/src/content.config.ts`.

### Phase 1 Carry-Forward

- **D-25:** Section ordering in `Base.astro` body is locked from Phase 1: `UtilBar → Masthead → main(slot) → Footer`. Phase 2 swaps component bodies WITHOUT structural rewrite. Verification: `Base.astro` diff before/after Phase 2 changes only imports + per-page slot logic, never section order.
- **D-26:** Named `<slot name="head" />` exists in `Base.astro` for per-page schema injection. Phase 2 does NOT use it (no schema this phase). Phase 3+ uses it for JSON-LD `<script type="application/ld+json">` blocks.

### Claude's Discretion

- Which Zod refinement helpers to use (`.url()`, `.regex()`, etc.) — planner picks based on what's natural.
- Whether `business.json` keys are `camelCase` (matches TS) or `kebab-case` (matches AEO requirements naming) — recommend `camelCase` for ergonomics.
- File-naming for content entries — recommend `slug-form.md` matching the page slug exactly (e.g., `fades.md`, `bostonia.md`).
- Whether Astro `defineCollection({ type: 'content', schema: ... })` uses `z.object` or `z.discriminatedUnion` (recommend `z.object` for both — single shape per collection).

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Locked Mockup (the design)

- `mockups/home-v5/index.html` — OD-5 mockup; the single source of truth for design tokens, component layout, and CSS. Pixel-parity is a Phase 2 success criterion. Researcher and planner inspect this file extensively. **MUST read before any port work.**

### Phase Inputs

- `inputs/00-brief.md` — project brief; design intent and audience.
- `inputs/01-page-list.md` — 17–19 page architecture, schema priority per page, template strategy. **Defines what content collections need to support.**
- `inputs/02-aeo-constraints.md` — load-bearing AEO rules (BLUF, no-hidden-content, schema priority, anti-patterns). **MUST read before any copy authoring** (deferred to Phase 3/4 but constrains stub authoring too).
- `inputs/03-photo-notes.md` — what each photo shows, attribution, primary use per page. **Defines which photo each component uses; price board image holds the canonical prices.**

### Phase 1 Artifacts (carry-forward context)

- `.planning/phases/01-scaffold/01-RESEARCH.md` — Astro 6 setup, Image integration, Vercel adapter rationale. **§ Pitfall 5 (`src/assets/` vs `public/`) is load-bearing for DESN-04.**
- `.planning/phases/01-scaffold/01-03-SUMMARY.md` — Base.astro layout structure, stub component naming, `data-phase1-stub` markers, named `<slot name="head" />`. **Defines what Phase 2 starts from.**
- `.planning/phases/01-scaffold/01-04-SUMMARY.md` — Vercel preview URL (`https://site-psi-liard.vercel.app`); for showcase reference only.

### Project-Level Decisions

- `.planning/PROJECT.md` § Constraints — tech stack lock (Astro, no Tailwind), photo set limit (6), AEO structural rules.
- `.planning/PROJECT.md` § Key Decisions — Astro, Vercel, OD CSS preserved, schema from `business.ts`.
- `.planning/REQUIREMENTS.md` § Data Source of Truth + Design Port — DATA-01..04, DESN-01..04 literal text.
- `.planning/ROADMAP.md` § Phase 2 — goal, depends-on, success criteria.

### Vault References (knowledge base — DO NOT duplicate into repo)

- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — audit baseline; canonical NAP source for `business.json`.
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-visual-direction.md` — strategic visual narrative (informs component naming intent).
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` — AEO mechanics (informs Phase 3/4 copy generation, not Phase 2 directly).

### Astro / Tooling Docs (researcher reads these)

- Astro 6 docs — content collections, `<Image />` / `<Picture />`, scoped `<style>`, `Base.astro` layout pattern.
- `@astrojs/sitemap` — emits `sitemap-index.xml` (already wired in Phase 1; Phase 2 doesn't touch).
- Zod docs — schema definition for content collections.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- **Phase 1 stub components** (`site/src/components/UtilBar.astro`, `Masthead.astro`, `Footer.astro`): outer-element shells already exist with `data-phase1-stub` markers. Phase 2 replaces the body, removes the marker, leaves the file path stable so existing imports in `Base.astro` keep working.
- **`site/src/layouts/Base.astro`**: shared HTML shell with locked section ordering and named `<slot name="head" />`. Phase 2 imports `tokens.css` + `utilities.css` here, no other structural change.
- **`site/src/pages/index.astro`** + **`site/src/pages/about.astro`**: Phase 1 placeholder pages. Phase 2 leaves them alone — they get fully rewritten in Phase 3 (PAGE-01 homepage, PAGE-04 about). Phase 2 may add a `site/src/pages/_dev-mockup-parity.astro` (gitignored or marked clearly as a dev-only scratch) to hit success criterion #3 (visual parity check).
- **`mockups/home-v5/index.html`**: the source of all CSS rules and DOM structure. Component extraction is a mechanical "find this section in the HTML, port markup to component, port CSS to scoped style or shared atoms" loop.
- **`inputs/photos/`**: 6 source photos. Copy targets `site/src/assets/photos/` (NOT `public/`).

### Established Patterns

- **Section ordering** (Phase 1): `UtilBar → Masthead → main(slot) → Footer` is locked in `Base.astro`. Phase 2 must not change it.
- **`data-phase1-stub` removal**: Phase 2 strips these attributes when replacing stub bodies. Verification: zero matches under `site/src/` after the phase.
- **Astro Image processed assets in `src/`** (Phase 1 Pitfall 5): file path target is `site/src/assets/photos/`. `<Image src={import('...path...')} />` import-style references.
- **Zero client: directives** (Phase 1): all Phase 2 components are static — no `client:load` / `client:idle` / `client:visible`. AEO requires zero-JS DOM.
- **Astro `<style>` is scoped by default**: writing `<style>...</style>` in a `.astro` file scopes the rules to that component automatically. No explicit class-name munging needed.

### Integration Points

- **`Base.astro` imports**: Phase 2 adds `import '../styles/tokens.css';` and `import '../styles/utilities.css';` near the top of the frontmatter. Components individually import `tokens.css` only if they reference a `:root` var directly (not needed; cascade works).
- **`business.ts` consumer pattern**: components import `import { business } from '../data/business';` at the frontmatter top. Use `business.address.city`, `business.phone`, `business.prices.haircut` directly in the markup.
- **Content collection consumer pattern** (Phase 3/4): pages call `await getCollection('services')` and iterate. Phase 2 just defines the collections — no consumer code yet.
- **`<Image />` in components**: hero photo in `Hero.astro` uses `<Picture src={import('../assets/photos/03-interior-hero.jpg')} formats={['avif','webp']} />`. Other photos use `<Image />`.

</code_context>

<specifics>
## Specific Ideas

- **Maintenance handoff is the user's stated #1 priority for code structure decisions.** Choose locality (per-component scoped CSS) over abstraction (split global stylesheets) wherever a tradeoff exists. Future-you opening `PriceBoard.astro` should see markup AND styles together.
- **`mockups/home-v5/index.html` is byte-stable from this commit forward.** md5 checksum: `75e4749bbe4c9e2d4993bfa6744d3cdc`. If a regenerated mockup arrives later, treat it as a new version (`home-v6`) and decide whether to re-port — don't silently overwrite v5.
- **The OD-5 export embeds the live-tweaks panel** at `<aside class="tweaks">` near the page bottom plus `data-font` / `data-checker` body attributes plus a `~150-line` script block that toggles them. All three layers strip during the port (DESN-03).
- **Font loading is via Google Fonts `<link>`** in the mockup: `IM+Fell+English`, `Playfair+Display`, `DM+Serif+Display`, `Newsreader`, `Oswald`, `JetBrains+Mono`. The port keeps this as the single `<link>` in `Base.astro` (or moved to `tokens.css` `@import url(...)`). Phase 5 perf may want to drop unused weights — flag for that phase.
- **The OD design uses `oklch()` color space** throughout. Browser support is universal in modern evergreens; no fallback needed for Joe's 2026 audience.
- **Marketing-skills chain for Phase 3/4 copy** is recorded in D-16. Planners for those phases should treat that as a starting blueprint, not the only valid path.
- **No `<live-tweaks>` panel verification step in Phase 2** beyond the two grep checks (D-10). DESN-03 is satisfied by absence; no positive assertion needed.

</specifics>

<deferred>
## Deferred Ideas

- **Wikidata Q-number registration** + Booksy listing — already in REQUIREMENTS.md v2 (OFFS-01, OFFS-02). When those land, `business.json` `sameAs` updates with one edit.
- **`marketing-skills:product-marketing-context` setup** — runs at the start of Phase 3, not Phase 2. Phase 2 ships stubs that don't need positioning context.
- **Per-service offerings + per-neighborhood landmarks deep-content** — Phase 4 territory. Phase 2 stubs may have placeholder landmarks; real ones from `aeo-playbook-smb.md` and Joe's local knowledge come in Phase 4.
- **Hero `<Picture />` AVIF/WebP perf tuning** — wired in Phase 2 but verified in Phase 5 (PERF-03/PERF-04).
- **Optional `kidsCut` price** — if not specified in `inputs/00-brief.md`, mark `TBD` in `business.json` and ask Joe at showcase time. Doesn't block Phase 2.
- **Sitemap entries for content-collection pages** — Phase 5 territory; `@astrojs/sitemap` auto-discovers built routes, so no explicit work in Phase 2.
- **Deprecation of REQUIREMENTS.md DESN-04 wording** (`public/photos/` → `src/assets/photos/`) — apply at next phase transition (`/gsd-transition` after Phase 2). Phase 2 honors the technical reality (D-11), not the stale text.
- **Removal of the empty Square Site cutover** — already documented as out-of-scope; not blocked by Phase 2.

</deferred>

---

*Phase: 2-Data + Design System*
*Context gathered: 2026-05-07*
