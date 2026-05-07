# Phase 2: Data + Design System — Research

**Researched:** 2026-05-07
**Domain:** Astro 6 content collections, TypeScript typed data, OD-5 CSS port, Astro Image integration
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- D-01: OD-5 mockup is `mockups/home-v5/index.html` (md5 `75e4749bbe4c9e2d4993bfa6744d3cdc`, 822 lines).
- D-02: Single-file inlined HTML export with all CSS and the live-tweaks panel. DESN-03 strips the tweaks panel.
- D-03: 12 named components are LOCKED: `UtilBar`, `Masthead`, `Hero`, `FactStrip`, `PriceBoard`, `Heritage`, `Visit`, `FAQ`, `ClosingCTA`, `Footer`, `CheckDivider`, `SectionMark`.
- D-04: Derived extras allowed with named mockup line ranges in PLAN.md, but never at cost of the 12.
- D-05: `data-phase1-stub` attributes removed when stub bodies are replaced. Zero matches after phase.
- D-06: Per-component scoped `<style>` by default; component-specific selectors live in matching component file.
- D-07: Globals in `site/src/styles/tokens.css` — all `:root` vars, reset, base rules, Google Fonts `<link>`.
- D-08: Shared atoms in `site/src/styles/utilities.css` — `.wrap`, `.eyebrow`, `.kicker-rule`, `.display`, `.check-divider`, `.section-mark`.
- D-09: Cross-component selectors resolved by: (1) restructure markup, (2) lift to tokens/utilities, (3) consume in parent. Never duplicate.
- D-10: Tweaks panel: strip `<aside class="tweaks">`, all `.tweaks*` CSS, `data-font`/`data-checker` body attrs. Verify both greps zero.
- D-11: Photos to `site/src/assets/photos/` NOT `site/public/photos/`.
- D-12: REQUIREMENTS.md DESN-04 `public/photos/` wording is stale; `src/assets/photos/` is canonical.
- D-13: Filenames preserved verbatim.
- D-14: Hero uses `<Picture formats={['avif','webp']} />`, all others use `<Image />`. Hero: `loading="eager"` + `fetchpriority="high"`. Below-fold: `loading="lazy"`.
- D-15: Phase 2 ships schema-passing stubs only — real prose in Phase 3/4.
- D-16: Phase 3/4 copy generation uses marketing-skills chain (not a Phase 2 concern).
- D-17: Schema enforces shape, not quality — no enum constraints or min word counts.
- D-18: `business.ts` exports 7 fields: `name`, `address`, `phone`, `hours`, `prices`, `ratings`, `sameAs`, `photos`, `areaServed`.
- D-19: `business.json` is the truth; `business.ts` is the typed view. Future edits go in JSON.
- D-20: Phase 5 schema components import `business` and transform — no schema.org shaping in `business.ts`.
- D-21: Data sources: NAP from vault, hours from GBP (user confirms), prices from price-board photo, ratings from Google/Yelp.
- D-22: `services` schema: `title`, `price` (number), `duration` (string), `bluf` (string), `faqs` (array of `{q,a}`), `heroPhoto` (optional string).
- D-23: `neighborhoods` schema: `title`, `landmarks` (string[]), `distance` (string), `bluf` (string), `faqs` (array).
- D-24: Config lives at `site/src/content.config.ts` (Astro 6 standard); entries in `site/src/content/services/*.md` and `site/src/content/neighborhoods/*.md`.
- D-25: Base.astro section ordering locked: `UtilBar → Masthead → main(slot) → Footer`. Phase 2 swaps bodies, not structure.
- D-26: Named `<slot name="head" />` in `Base.astro` is left alone — used by Phase 3+.

### Claude's Discretion

- Which Zod refinement helpers to use (`.url()`, `.regex()`, etc.)
- `business.json` keys: recommend `camelCase`
- Content entry filenames: recommend slug-form matching page slug exactly
- `defineCollection` pattern: recommend `z.object` for both collections (not `z.discriminatedUnion`)

### Deferred Ideas (OUT OF SCOPE)

- Wikidata Q-number + Booksy `sameAs` entries
- `marketing-skills:product-marketing-context` setup (Phase 3)
- Per-service/per-neighborhood deep content (Phase 4)
- Hero AVIF/WebP perf tuning (Phase 5 verification)
- Optional `kidsCut` if not in brief (ask Joe at showcase)
- Sitemap entries for collection pages (Phase 5)
- REQUIREMENTS.md DESN-04 wording correction (next `/gsd-transition`)
- Square Site cutover

</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| DATA-01 | `src/data/business.ts` exports a typed business record (NAP, hours, prices, ratings, sameAs, photos, areaServed) used by every page | Verified: Astro/Vite auto-imports JSON; `import businessData from './business.json'` with a `BusinessRecord` interface typed re-export works under strict mode. See §Code Examples. |
| DATA-02 | `src/content.config.ts` defines typed content collections for `services` and `neighborhoods` | Verified: Astro 6 uses `src/content.config.ts` (NOT `src/content/config.ts`) with Content Layer API + `glob` loader. See §Critical: Astro 6 Config Location and §Code Examples. |
| DATA-03 | 6 service content files with frontmatter (price, duration, BLUF, FAQ) + markdown body | Schema defined in CODE EXAMPLES. Files: `fades.md`, `kids-cuts.md`, `beard-trim.md`, `hot-towel-shave.md`, `line-up.md`, `classic-cut.md`. Phase 2 ships stubs only (D-15). |
| DATA-04 | 5 neighborhood content files with frontmatter (landmarks, distance, BLUF, FAQ) + markdown body | Schema defined in CODE EXAMPLES. Files: `bostonia.md`, `el-cajon.md`, `santee.md`, `lakeside.md`, `la-mesa.md`. Phase 2 ships stubs only (D-15). |
| DESN-01 | OD-5 CSS ported to `src/styles/global.css` preserving all design tokens | Per D-06/D-07/D-08: split into `tokens.css` (globals + `:root` vars) and `utilities.css` (shared atoms), NOT a monolithic `global.css`. DESN-01 wording says `global.css` but D-07/D-08 lock the two-file structure. Planner should note this reconciliation. Both files imported once in `Base.astro`. |
| DESN-02 | Component library extracted: 12 named components | Full section-by-section mockup map in §OD-5 Mockup Decomposition. CSS selectors per component in §CSS Port Map. |
| DESN-03 | Live tweaks panel removed from production build | Three-layer removal: markup (`<aside class="tweaks">`), CSS (`.tweaks*` rules), script block (~50 lines). Verification: two grep commands defined in §Tweaks Panel Removal. |
| DESN-04 | 6 photos in `src/assets/photos/` rendered through `<Image />` | Target is `src/assets/photos/` (D-11 corrects REQUIREMENTS.md). Photos are currently in `inputs/photos/`. Hero uses `<Picture>`, others use `<Image>`. See §Image Integration. |

</phase_requirements>

---

## Summary

Phase 2 has three parallel workstreams: (1) data layer — `business.json` + `business.ts` typed re-export + 11 content-collection stub files, (2) CSS port — split the single `<style>` block in the OD-5 mockup into `tokens.css` globals, `utilities.css` shared atoms, and 12 per-component `<style>` blocks, and (3) asset migration — copy 6 photos to `src/assets/photos/` and wire Astro `<Image />`/`<Picture />` in components.

The most important finding for the planner is a **Astro 6 Content Collections API change**: the config file must be at `site/src/content.config.ts` (NOT `site/src/content/config.ts`), and it must use the Content Layer API with a `glob` loader — not the legacy Astro 4 pattern. `src/content/config.ts` will throw a hard build error in Astro 6.3.0. Additionally, `z` must be imported from `astro/zod`, and each `defineCollection` must include an explicit `loader` property.

The second critical finding is a **hours data discrepancy** between vault baseline and the mockup. The vault records `Thu-Sat 10:00-19:30` but the mockup shows `Thu, Fri 10am–7:30pm` and `Sat 10am–6:30pm`. The plan must include a step where the executor reads the current GBP listing and confirms hours before committing `business.json`.

The mockup decomposes cleanly into the 12 locked components. The CSS port is mechanical — all component-specific selectors are class-scoped with no naming collisions. The three cross-component CSS cases (`.hero-checker-ribbon`, `.heritage-frame`, `.footer-checker`) are analyzed and resolved in §Cross-Component CSS.

**Primary recommendation:** Execute the three workstreams in waves: Wave 1 (data layer: business.json + content.config.ts + 11 stub files), Wave 2 (CSS: tokens.css + utilities.css + 12 component files), Wave 3 (photos + Image wiring + parity page). Each wave is independently verifiable.

---

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Business data (NAP, hours, prices) | `site/src/data/business.ts` | — | Single typed import; all pages consume it; no runtime needed |
| Content collections (service/neighborhood entries) | `site/src/content.config.ts` + `.md` files | Astro Content Layer (build-time) | Astro 6 Content Layer API processes MD at build; zero runtime |
| Design tokens (CSS variables, reset) | `site/src/styles/tokens.css` (imported in `Base.astro`) | — | Cascade: one import reaches all components |
| Shared utility classes | `site/src/styles/utilities.css` (imported in `Base.astro`) | — | Classes used across 4+ components; duplication would be wrong |
| Per-component styles | Scoped `<style>` in each `.astro` component | — | Locality for maintenance; Astro auto-scopes to component |
| Image optimization | Astro `<Image />`/`<Picture />` (build-time Sharp) | — | `src/assets/` assets processed at build; AVIF/WebP/srcset generated |
| Parity verification | `site/src/pages/_dev-mockup-parity.astro` (dev-only scratch page) | Browser side-by-side | No screenshot diffing tool required; spot-check checkerboard, fonts, palette |

---

## Standard Stack

### Core (all already installed in Phase 1)

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `astro` | 6.3.0 | Framework — static build, scoped styles, Content Layer | Installed; project constraint |
| `typescript` | 5.x (peer) | Strict typing for `BusinessRecord` interface, collection schemas | `astro/tsconfigs/strict` already configured |
| `astro/zod` | (bundled with astro) | Zod schema for `defineCollection` | Re-exported from Astro; must NOT install `zod` separately — use `import { z } from 'astro/zod'` |
| `astro:assets` | (built-in) | `<Image />` / `<Picture />` for processed photo output | Built into Astro 6; no separate install |

[VERIFIED: site/node_modules/astro/package.json → 6.3.0]

### No New Dependencies

Phase 2 requires zero new npm installs. All capability is built into the Phase 1 scaffold:
- Zod: `import { z } from 'astro/zod'` (re-exported by astro)
- Content collections: `import { defineCollection, getCollection } from 'astro:content'`
- Image: `import { Image, Picture } from 'astro:assets'`
- Loaders: `import { glob } from 'astro/loaders'`

---

## Architecture Patterns

### System Architecture Diagram

```
mockups/home-v5/index.html (822 lines, locked)
  │
  ├──► CSS extraction ──► site/src/styles/tokens.css       (design vars, reset, base)
  │                  ──► site/src/styles/utilities.css     (.wrap, .eyebrow, .check-divider, etc.)
  │                  ──► 12 × component <style> blocks     (per-component selectors)
  │
  └──► DOM extraction ──► 12 × site/src/components/*.astro (markup + scoped styles)

~/Documents/DT Vault/joes-barbershop-sandbox.md  ─┐
inputs/photos/06-price-board-cash-only.jpg        ─┼──► site/src/data/business.json
GBP listing (executor confirms hours)              ─┘         │
                                                              ▼
                                                    site/src/data/business.ts
                                                    (TypeScript typed re-export)
                                                              │
                                                              ▼
                                                    components import { business }
                                                    pages import { business }

inputs/photos/ ──► copy verbatim ──► site/src/assets/photos/
                                              │
                                              ▼
                              Hero.astro <Picture formats={['avif','webp']} />
                              All others  <Image />

site/src/content/services/*.md (6 stubs)      ─┐
site/src/content/neighborhoods/*.md (5 stubs) ─┴──► getCollection() at build time
                                                       (Phase 3/4 consumers)
```

### Recommended Project Structure (Phase 2 additions to existing scaffold)

```
site/src/
├── assets/
│   └── photos/                        # Phase 2 creates — 6 photos copied from inputs/photos/
│       ├── 01-logo.jpg
│       ├── 02-storefront.jpg
│       ├── 03-interior-hero.jpg
│       ├── 04-heritage-chair.jpg
│       ├── 05-mid-cut.jpg
│       └── 06-price-board-cash-only.jpg
├── components/
│   ├── UtilBar.astro                  # Phase 2 replaces stub body; removes data-phase1-stub
│   ├── Masthead.astro                 # Phase 2 replaces stub body; removes data-phase1-stub
│   ├── Footer.astro                   # Phase 2 replaces stub body; removes data-phase1-stub
│   ├── Hero.astro                     # Phase 2 creates NEW
│   ├── FactStrip.astro                # Phase 2 creates NEW
│   ├── PriceBoard.astro               # Phase 2 creates NEW
│   ├── Heritage.astro                 # Phase 2 creates NEW
│   ├── Visit.astro                    # Phase 2 creates NEW
│   ├── FAQ.astro                      # Phase 2 creates NEW
│   ├── ClosingCTA.astro               # Phase 2 creates NEW
│   ├── CheckDivider.astro             # Phase 2 creates NEW
│   └── SectionMark.astro              # Phase 2 creates NEW
├── content/
│   ├── services/
│   │   ├── fades.md
│   │   ├── kids-cuts.md
│   │   ├── beard-trim.md
│   │   ├── hot-towel-shave.md
│   │   ├── line-up.md
│   │   └── classic-cut.md
│   └── neighborhoods/
│       ├── bostonia.md
│       ├── el-cajon.md
│       ├── santee.md
│       ├── lakeside.md
│       └── la-mesa.md
├── content.config.ts                  # Astro 6 Content Layer config (NEW — NOT src/content/config.ts)
├── data/
│   ├── business.json                  # Canonical NAP, hours, prices, ratings, sameAs, photos
│   └── business.ts                    # Typed re-export
├── layouts/
│   └── Base.astro                     # Phase 2 adds tokens.css + utilities.css imports
├── pages/
│   ├── index.astro                    # Phase 2 leaves alone (Phase 3 rewrites)
│   ├── about.astro                    # Phase 2 leaves alone (Phase 3 rewrites)
│   └── _dev-mockup-parity.astro       # Phase 2 creates (dev-only parity scratch page)
└── styles/
    ├── tokens.css                     # NEW — :root vars, reset, base rules, Google Fonts link
    └── utilities.css                  # NEW — .wrap, .eyebrow, .kicker-rule, .display, .check-divider, .section-mark
```

---

## Critical Finding: Astro 6 Content Collections API Change

**LOAD-BEARING — The CONTEXT.md (D-24) says `site/src/content/config.ts`. This is WRONG for Astro 6.**

[VERIFIED: Context7 /withastro/docs — "Legacy content config file found. A legacy content config file was found in src/content/config.ts. To resolve this issue, move the file to src/content.config.ts"]
[VERIFIED: Context7 /withastro/docs — Astro 6 upgrade guide "All collections must now use the Content Layer API with explicit loaders, a content.config.ts file at the project root"]

| Property | Legacy (Astro 4, removed) | Current (Astro 6, required) |
|----------|--------------------------|----------------------------|
| Config file path | `src/content/config.ts` | `src/content.config.ts` |
| `defineCollection` | No `loader` required | MUST include `loader` |
| Zod import | `import { z } from 'zod'` | `import { z } from 'astro/zod'` |
| `defineCollection` import | `from 'astro:content'` | `from 'astro:content'` (same) |
| Slug field on entry | `entry.slug` | `entry.id` (slug is now id) |
| Render function | `entry.render()` | `render(entry)` from `astro:content` |

The plan must use `site/src/content.config.ts` (at the `src/` level) with a `glob` loader. If the executor creates `site/src/content/config.ts` instead, Astro will throw `LegacyContentConfigError` and the build will fail.

---

## OD-5 Mockup Decomposition

The mockup is 822 lines. The full source is at `mockups/home-v5/index.html`. MD5: `75e4749bbe4c9e2d4993bfa6744d3cdc`.

### Section-by-Section Component Map

| Component | Line Range | DOM Root | Description |
|-----------|-----------|----------|-------------|
| **[TWEAKS STRIP]** | 262–292 | `<aside class="tweaks">` | STRIP ENTIRELY — see §Tweaks Panel Removal |
| **UtilBar** | 294–305 | `<div class="util-bar">` | Dark top bar: walk-ins, family-friendly, ATM, hours, phone |
| **CheckDivider** | 327 | `<div class="check-divider">` | Single div — the B&W checkerboard pattern band |
| **Masthead** | 307–325 | `<header class="masthead">` | Logo lockup, primary nav, Book CTA button |
| **Hero** | 329–382 | `<section class="hero">` | Two-column: copy side (h1, BLUF, CTAs, meta grid) + photo side |
| **FactStrip** | 384–412 | `<section class="fact-strip tight">` | 5-column grid of fact tiles (established, rating, neighborhood, walk-ins, barbers) |
| **[CheckDivider]** | 414 | `<div class="check-divider">` | Reused between FactStrip and PriceBoard |
| **PriceBoard** | 416–458 | `<section class="price-section" id="prices">` | Price letter-board (dark bg) + aside copy |
| **Heritage** | 460–500 | `<section class="heritage">` | Heritage chair photo + copy + 3-stat block |
| **[CheckDivider]** | 502 | `<div class="check-divider">` | Reused between Heritage and Visit |
| **Visit** | 504–557 | `<section class="visit" id="visit">` | Storefront photo + NAP card (dl/dt/dd) |
| **FAQ** | 559–633 | `<section class="faq">` | Section head + 5 FAQ articles (numbered) |
| **[CheckDivider]** | 635 | `<div class="check-divider">` | Reused between FAQ and ClosingCTA |
| **ClosingCTA** | 637–653 | `<section class="closing-cta">` | Centered CTA: headline, sub, two buttons, trust line |
| **[footer-checker]** | 655 | `<div class="footer-checker">` | Decorative checker strip above footer (not a named component — see §Derived Extras) |
| **Footer** | 656–716 | `<footer>` | 4-column grid (brand, services, east county, shop) + legal row |
| **[JSON-LD]** | 718–766 | `<script type="application/ld+json">` | Strip from mockup — Phase 5 adds schema via `<HairSalonSchema />` in `<slot name="head" />` |
| **[Tweaks Script]** | 768–819 | `<script>` | STRIP ENTIRELY — the tweaks panel JS |

### CheckDivider Instance Count

There are **4 instances** of `<div class="check-divider">` in the DOM (lines 327, 414, 502, 635). `CheckDivider` is a standalone component — `<CheckDivider />` is placed by whatever parent composes the page. It takes no props. In Phase 2, it belongs in the scratch `_dev-mockup-parity.astro` page between sections matching the mockup order.

### SectionMark

`<span class="section-mark">` appears inside `.section-head` at lines 419, 508, 563. It is a reusable cosmetic element — a small circular checker-pattern ornament. In Phase 2, it is either a `<SectionMark />` component (zero props, aria-hidden) or a utility class element. Given its tiny footprint (one `<span>`), the planner may choose to keep it as the `.section-mark` class applied directly without a component wrapper — acceptable per D-04's "derived extras" provision. If extracted as a component: zero props, renders `<span class="section-mark" aria-hidden="true"></span>`.

### Derived Extras (per D-04)

| Name | Mockup Lines | Description | Decision |
|------|-------------|-------------|----------|
| `.footer-checker` div | Line 655 | Decorative checker strip immediately above `<footer>` | Planner may either (a) include it inside `Footer.astro` as the first element or (b) extract as a standalone `FooterChecker` component. Recommend: include inside `Footer.astro` — it has no standalone utility and never appears elsewhere |
| `.hero-checker-ribbon` div | Lines 379–380 | Decorative checker ribbon in bottom-right corner of hero photo cell | Lives inside `Hero.astro` — it is scoped to the hero photo div; not reusable |
| `.brand-lockup` | Lines 309–315 | Logo + text lockup in Masthead | Lives inside `Masthead.astro` |
| `.nap dl` block | Lines 521–553 | NAP data list inside Visit card | Lives inside `Visit.astro`; no need to extract |

---

## CSS Port Map

### tokens.css Contents

Everything that is global and must cascade to all components.

```
:root { ... }                          — all 22 CSS variables (lines 39–61)
*, *::before, *::after { box-sizing }  — reset (line 62)
html, body { margin: 0; padding: 0 }   — base (line 63)
body { background, color, font-family, font-size, line-height, text-rendering, antialiased } (line 64)
img { display: block; max-width: 100%; height: auto } (line 65)
a { color: inherit }                   (line 66)
section { padding-block: clamp(...) }  (line 135) — global section spacing
section.tight { padding-block: clamp(...) } (line 136)
```

**Google Fonts `<link>` placement:** The mockup places the Google Fonts `<link>` tags in `<head>` (lines 33–35). In Astro, the cleanest approach is to add them directly to `Base.astro`'s `<head>`. The `preconnect` hints and the stylesheet `<link>` go in `Base.astro`'s `<head>` above the CSS imports. Do NOT use `@import url(...)` in tokens.css — `@import` in CSS blocks rendering (adds a serial network round-trip). Keep the three `<link>` tags in HTML.

**Phase 5 flag:** The Google Fonts load is 6 font families with multiple weights. Phase 5 should audit which weights are actually used and trim the query string. Flag this in the plan — do not optimize in Phase 2.

### utilities.css Contents

Shared atoms used by multiple components.

| Class | Used In (components) | Source Lines |
|-------|---------------------|--------------|
| `.wrap` | UtilBar, Masthead, Hero, FactStrip, PriceBoard, Heritage, Visit, FAQ, ClosingCTA, Footer | Line 73 |
| `.eyebrow` | Hero, PriceBoard, Heritage, Visit, ClosingCTA | Line 70 |
| `.kicker-rule` | Hero, Heritage, Visit, ClosingCTA | Lines 71–72 |
| `.display` | Hero (h1), section heads, ClosingCTA | Lines 67–69 |
| `.check-divider` | Standalone component AND controls checker display via `:root[data-checker]` | Lines 74–77 |
| `.section-mark` | PriceBoard, Visit, FAQ (inside `.section-head`) | Lines 78–79 |
| `.btn` | Masthead, Hero, ClosingCTA | Lines 104–107 |
| `.section-head`, `.section-head-text` | PriceBoard, Visit, FAQ | Lines 137–142 |

**Note on `.btn`:** Although `.btn` appears in Masthead, Hero, and ClosingCTA, it is an atom usable everywhere. Place in utilities.css. The `.btn.outline` variant is also in utilities.css.

### Per-Component CSS — What Goes in Each Scoped `<style>`

| Component | Selectors to scope |
|-----------|-------------------|
| `UtilBar.astro` | `.util-bar`, `.util-bar .wrap`, `.util-bar .util-dot`, `.util-bar .util-phone` (lines 88–91) |
| `Masthead.astro` | `.masthead`, `.masthead .wrap`, `.brand-lockup`, `.brand-lockup img`, `.brand-text`, `.brand-text .name`, `.brand-text .tag`, `nav.primary`, `nav.primary a`, `nav.primary a:hover` (lines 92–103) |
| `Hero.astro` | `.hero`, `.hero-grid`, `.hero-copy`, `.hero-copy .eyebrow`, `.hero-copy h1`, `.hero-copy h1 .accent-word`, `.hero-bluf`, `.hero-ctas`, `.hero-meta`, `.hero-meta strong`, `.hero-photo`, `.hero-photo img`, `.hero-photo::after`, `.hero-photo .photo-credit`, `.hero-checker-ribbon` + responsive variants (lines 108–124, plus media queries) |
| `FactStrip.astro` | `.fact-strip`, `.fact-strip .wrap`, `.fact`, `.fact .label`, `.fact .value`, `.fact .value .star`, `.fact .sub` + responsive variants (lines 125–134) |
| `PriceBoard.astro` | `.price-section`, `.price-grid`, `.price-board`, `.price-board .head`, `.price-board ul`, `.price-board li`, `.price-board li .dots`, `.price-board li .num`, `.price-board .foot`, `.price-board .foot .red`, `.price-aside h3`, `.price-aside p`, `.price-aside .quote` + responsive (lines 143–158) |
| `Heritage.astro` | `.heritage`, `.heritage-grid`, `.heritage-photo`, `.heritage-photo img`, `.heritage-copy h2`, `.heritage-copy p`, `.heritage-stats`, `.heritage-stats .stat .num`, `.heritage-stats .stat .label` + `.heritage-frame` cross-component rule (see §Cross-Component CSS) + responsive (lines 159–171) |
| `Visit.astro` | `.visit`, `.visit-grid`, `.visit-photo`, `.visit-photo img`, `.visit-card`, `.visit-card h3`, `.nap dl`, `.nap dt`, `.nap dd`, `.nap dd strong`, `.nap dd .mono` + responsive (lines 172–184) |
| `FAQ.astro` | `.faq`, `.faq-list`, `.faq-q`, `.faq-q .num`, `.faq-q h3`, `.faq-q p` + responsive (lines 185–194) |
| `ClosingCTA.astro` | `.closing-cta`, `.closing-cta .eyebrow.kicker-rule` modifier, `.closing-heading`, `.closing-sub`, `.closing-ctas`, `.closing-trust` (lines 195–204) |
| `Footer.astro` | `footer`, `footer .wrap.foot-grid`, `footer h4`, `footer ul`, `footer a`, `footer a:hover`, `footer .foot-brand`, `footer .foot-brand .lockup`, `footer .foot-brand .lockup img`, `footer .foot-brand .lockup .name`, `footer .foot-brand p`, `footer .legal`, `footer .legal .wrap`, `footer .legal .right`, `.footer-checker` + responsive (lines 205–220, 221 data-checker variants, plus derived `.footer-checker` at line 85–87) |
| `CheckDivider.astro` | Receives its rules from utilities.css — `.check-divider` is a shared atom. No scoped `<style>` needed unless CheckDivider wants to add its own wrapper class |
| `SectionMark.astro` | Receives its rules from utilities.css — `.section-mark` is a shared atom |

### Cross-Component CSS (D-09 Cases)

Three CSS rules in the mockup span component boundaries:

**Case 1: `.heritage-frame` (line 84)**
```css
:root[data-checker="heavy"] .heritage-frame { padding: 18px; background-image: ...; }
```
`.heritage-frame` is a `<div>` inside `Heritage.astro`. The `:root[data-checker="heavy"]` parent is on `<html>`. Resolution: **this rule goes in `Heritage.astro`'s scoped `<style>` as `html[data-checker="heavy"] .heritage-frame`**. Astro scoped styles allow targeting parent elements outside the component via `:global(html[data-checker="heavy"]) .heritage-frame`. But since we are removing the tweaks panel and hardcoding `standard` checker, this rule may never fire at runtime. Port it for correctness; flag for Phase 5 cleanup.

**Case 2: `[data-font]` variants on `.display`, `.brand-text .name`, etc. (lines 68–69, 98–99, 113–115, etc.)**
These are `data-font` body attribute variants used by the tweaks panel. Since the tweaks panel is stripped (D-10), these rules become dead code. Resolution: **strip all `:root[data-font="playfair"]` and `:root[data-font="dm"]` variants when porting**. Only the base `.display` rules survive.

**Case 3: `[data-checker]` variants on `.check-divider`, `.section-mark`, `.footer-checker`, `.hero-checker-ribbon`**
These control checker intensity. The tweaks panel being stripped means no runtime changes to `data-checker`. Resolution: **port the `standard` checker state as the default, unconditional rule**. The `data-checker="standard"` variants become the base rule. The `data-checker="off"`, `data-checker="subtle"`, `data-checker="heavy"` variants become dead code — strip them or leave as comments; recommend stripping to keep the code clean.

---

## Tweaks Panel Removal (DESN-03, D-10)

### What to strip

**Layer 1 — Markup** (lines 262–292):
```html
<aside class="tweaks" id="tweaks" aria-label="Design tweaks">
  ...
</aside>
```
The entire `<aside>` block. 31 lines.

**Layer 2 — CSS** (lines 221–235 plus media query at line 247):
```
.tweaks { position: fixed; ... }
.tweaks.collapsed .tweaks-body { ... }
.tweaks header { ... }
.tweaks header .dot { ... }
.tweaks header .title { ... }
.tweaks header .toggle { ... }
.tweaks-body { ... }
.tweak-row .label { ... }
.seg { ... }
.seg.four { ... }
.seg button { ... }
.seg button:last-child { ... }
.seg button[aria-pressed="true"] { ... }
.tweak-note { ... }
.tweak-note .now { ... }
@media (max-width: 980px) .tweaks { ... }   (line 247)
```

Also strip the `[data-font]` and `[data-checker]` variant rules (see §Cross-Component CSS Case 2 and 3 above). These are dead code once the tweaks panel is gone.

**Layer 3 — Script** (lines 768–819):
```html
<script>
  const root = document.documentElement;
  ...applyFont / applyCheck / toggleTweaks / event listeners...
</script>
```
52 lines. Includes the inline localStorage shim in `<head>` (lines 4–27) which is also tweaks-only. Both `<script>` blocks strip.

**Also strip from `<head>` (lines 4–27):**
```html
<script>(function(){ ... tryShim('localStorage'); tryShim('sessionStorage'); })()</script>
```
This localStorage shim exists solely for the tweaks panel's font/checker persistence. Unused in production.

### Verification Commands (D-10)

```bash
grep -r "tweaks" site/src/           # expect 0 matches
grep -r 'data-font\|data-checker' site/src/   # expect 0 matches
grep -r 'applyFont\|applyCheck\|toggleTweaks' site/src/   # expect 0 matches (script removed)
grep -r 'data-phase1-stub' site/src/    # expect 0 matches (D-05)
```

---

## Astro Content Collections (DATA-02)

### Config File Location — CRITICAL

**Correct path: `site/src/content.config.ts`**
**Wrong path: `site/src/content/config.ts`** (throws `LegacyContentConfigError` in Astro 6.3.0)

[VERIFIED: Context7 /withastro/docs — upgrade-to-v6.mdx: "if your configuration is currently located at src/content/config.ts, it must be moved and renamed to the root-level src/content.config.ts file"]

### getCollection() Behavior

- Returns all entries from the named collection.
- If frontmatter fails schema validation, `astro build` throws a type error — the build fails, not just warns.
- In strict mode: `noImplicitAny` is active; all schema fields accessed via `entry.data.fieldName` must be typed.
- Slug is derived from filename: `fades.md` → `entry.id = 'fades'`. (Astro 6 uses `id`, not `slug`.)
- `getCollection('services')` returns `CollectionEntry<'services'>[]`.

### Schema Design Principles (D-17)

- All fields plain types: `z.string()`, `z.number()`, `z.array(...)` — no `.min()`, `.max()`, `.regex()`, no enums.
- Optional fields: `z.string().optional()` — for `heroPhoto` in services.
- FAQs allow empty array so stub files don't need placeholder FAQ objects.
- `title` is required (string) — it's the display name on Phase 3/4 pages.
- The schema does NOT include `slug` as a frontmatter field — slug comes from `entry.id` (the filename).

---

## business.ts Shape (DATA-01)

### Key Architecture Decision

`business.json` is the canonical source of truth. `business.ts` imports it and re-exports with a TypeScript `interface`. This pattern works in Astro/Vite because:
- Vite natively processes `import data from './business.json'`
- The JSON import is typed as `Record<string, unknown>` by default
- Adding an explicit `interface BusinessRecord` and casting satisfies TypeScript strict mode
- Future editors open `business.json` and edit plain JSON — no TS knowledge needed

[VERIFIED: Context7 /withastro/docs — imports.mdx: "Astro allows for the direct import of JSON files. The default export returns the fully parsed JSON object."]

### Hours Data Discrepancy — EXECUTOR ACTION REQUIRED

The vault baseline records: `Tue-Wed 10:00-18:30, Thu-Sat 10:00-19:30`
The mockup HTML shows: `Tue, Wed, Sat: 10am–6:30pm` and `Thu, Fri: 10am–7:30pm` (Saturday closes at 6:30pm not 7:30pm)

These differ on Saturday close time. **The plan must include a step: executor reads current GBP listing and transcribes exact hours before writing `business.json`.** Do not assume either source.

### `kidsCut` Price

`inputs/00-brief.md` confirms: "Haircut $30, Shave $30, Beard Line-up $20, Clean Up $15, Haircut + Beard $50." No standalone `kidsCut` price is listed. The Square Site brief confirms "Haircut + Beard trim $50" as a combo. Per D-21 (deferred): if not explicitly listed, mark `TBD` in `business.json` and ask Joe at showcase time.

The `prices` field should use `null` (not `TBD` string) for `kidsCut` in TypeScript: `kidsCut: number | null`.

---

## Image Integration (DESN-04)

### Photo Source → Destination

```
inputs/photos/01-logo.jpg            → site/src/assets/photos/01-logo.jpg
inputs/photos/02-storefront.jpg      → site/src/assets/photos/02-storefront.jpg
inputs/photos/03-interior-hero.jpg   → site/src/assets/photos/03-interior-hero.jpg
inputs/photos/04-heritage-chair.jpg  → site/src/assets/photos/04-heritage-chair.jpg
inputs/photos/05-mid-cut.jpg         → site/src/assets/photos/05-mid-cut.jpg
inputs/photos/06-price-board-cash-only.jpg → site/src/assets/photos/06-price-board-cash-only.jpg
```

Copy with `cp inputs/photos/* site/src/assets/photos/`. Do not rename (D-13).

### Usage Patterns by Component

| Component | Photo | Component | Attributes |
|-----------|-------|-----------|-----------|
| Masthead | `01-logo.jpg` | `<Image />` | `width={76}` `height={76}` `class="brand-logo"` `alt="Joe's Barbershop logo"` |
| Hero (photo side) | `03-interior-hero.jpg` | `<Picture formats={['avif','webp']} />` | `loading="eager"` `fetchpriority="high"` |
| Heritage | `04-heritage-chair.jpg` | `<Image />` | `loading="lazy"` |
| Visit | `02-storefront.jpg` | `<Image />` | `loading="lazy"` |
| Footer | `01-logo.jpg` | `<Image />` | `width={56}` `height={56}` `class="foot-logo"` |
| PriceBoard | No photo | — | — |
| ClosingCTA | No photo | — | — |
| FAQ | No photo | — | — |

`05-mid-cut.jpg` and `06-price-board-cash-only.jpg` are not used in homepage components — they are referenced in inputs/03-photo-notes.md for service pages (Phase 3/4). Copy them to `src/assets/photos/` anyway so they are available.

### Import Pattern in Components

```astro
---
import { Image, Picture } from 'astro:assets';
import heroPhoto from '../assets/photos/03-interior-hero.jpg';
---
<Picture
  src={heroPhoto}
  formats={['avif', 'webp']}
  alt="Inside Joe's Barbershop — black and white checkerboard tile floor..."
  loading="eager"
  fetchpriority="high"
/>
```

The `src` must be a **full imported image object** — not a string path. `src="../assets/photos/03-interior-hero.jpg"` is invalid with `<Image />`.

[VERIFIED: Context7 /withastro/docs — errors/local-image-used-wrongly.mdx: "src must be the full imported image object, not a filepath string"]

### Astro Image `layout: 'constrained'` Interaction

`astro.config.mjs` already sets `image.layout: 'constrained'`. This means:
- `<Image />` auto-generates `srcset` and `sizes` — no per-image config needed.
- `width` and `height` can be omitted if the image is imported (Astro infers from file).
- For `<Picture />`, the same config applies automatically.
- Hero gets `fetchpriority="high"` — this is an HTML attribute, not an Astro prop; pass as a plain attribute on the element.

---

## Parity Verification Strategy (Success Criterion #3)

### The Scratch Page

Create `site/src/pages/_dev-mockup-parity.astro`. This page:
- Imports all 12 components in the locked order
- Passes stub/hardcoded props matching the mockup content
- Is **not gitignored** — it stays in the repo as a Phase 2 artifact that Phase 3 replaces with the real index.astro
- Is clearly commented as dev-only scratch
- Uses `Base.astro` layout so tokens.css + utilities.css load

The parity page composition order matches the mockup DOM:
```
<UtilBar />
<Masthead />
<CheckDivider />
<Hero />
<FactStrip />
<CheckDivider />
<PriceBoard />
<Heritage />
<CheckDivider />
<Visit />
<FAQ />
<CheckDivider />
<ClosingCTA />
```
`Footer` renders via `Base.astro`. `CheckDivider` appears 4 times.

### What to Spot-Check (No Screenshot Tool)

| Check | How to Verify |
|-------|--------------|
| Checkerboard renders (standard mode) | Section dividers show B&W checker pattern; `background-size: 22px 22px` visible |
| Google Fonts loaded | Browser DevTools Network tab — 6 font families present; or inspect `font-family` computed style |
| oklch() palette renders | Body background is warm off-white (not default white); accent color is muted red |
| Hero layout (2-column desktop) | Copy left, photo right; grid-template-columns ratio visible |
| PriceBoard dark background | Board section has dark `--board-bg` background, white text |
| Masthead logo renders | Round logo visible; not broken `<img>` |
| Footer 4-column grid | Desktop: 4 columns; tablet at 980px: 2 columns |
| Zero .tweaks panel visible | No floating panel in top-right corner |

### Build Verification (Success Criterion #5 / #8)

```bash
cd site && npm run build
# Expect: exit 0, no TypeScript errors, no Zod validation errors
# Expect: dist/ contains _astro/*.avif and _astro/*.webp for hero photo
# Verify: grep -l "tweaks" dist/index.html → 0 lines
```

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Zod schema validation | Custom JSON validator | `import { z } from 'astro/zod'` | Bundled with Astro; strict-mode compatible; generates TS types automatically |
| TypeScript types for collection entries | Manual interface per entry | `CollectionEntry<'services'>` from `astro:content` | Auto-generated from schema; stays in sync with changes |
| Image srcset/AVIF/WebP | Custom Sharp pipeline or manual `<picture>` | `<Image />` / `<Picture />` from `astro:assets` | Handles AVIF, WebP, srcset, CLS prevention, hash — one import |
| Font loading | Self-hosting Google Fonts manually | Google Fonts `<link>` in `Base.astro` head | Phase 5 will evaluate self-hosting; Phase 2 preserves the OD-5 pattern |
| CSS variable cascade | Inline styles or per-component variable redefinition | `:root` vars in `tokens.css` | Cascade reaches all components; one edit changes the whole site |
| Content collection routing | Manual `import.meta.glob` + slugs | `getCollection()` + `entry.id` | Type-safe, schema-validated, lazy-loaded, maintained by Astro |

---

## Common Pitfalls

### Pitfall 1: Wrong content config file path (Astro 6)

**What goes wrong:** `LegacyContentConfigError` at build time — hard error, build fails.
**Why it happens:** Pre-Astro-6 tutorials and the CONTEXT.md D-24 reference `src/content/config.ts`. Astro 6 removed this path.
**How to avoid:** Config file MUST be `site/src/content.config.ts`. The `src/content/` directory still holds the `.md` files; only the config moves up one level.
**Warning signs:** Any plan step that writes to `site/src/content/config.ts`.

### Pitfall 2: Missing `loader` in `defineCollection`

**What goes wrong:** TypeScript error at build — `defineCollection` in Astro 6 requires a `loader` property.
**Why it happens:** Legacy Astro 4 `defineCollection({ schema: ... })` without a loader is no longer valid.
**How to avoid:** Always include `loader: glob({ pattern: '**/*.md', base: './src/content/services' })` in each `defineCollection` call.
**Warning signs:** `defineCollection({ schema: z.object({ ... }) })` without `loader:` anywhere in the config.

### Pitfall 3: `z` imported from `zod` instead of `astro/zod`

**What goes wrong:** Potential version mismatch; `zod` may not be installed as a direct dependency.
**Why it happens:** Older tutorials import from `'zod'` directly. Astro re-exports Zod at `'astro/zod'`.
**How to avoid:** `import { z } from 'astro/zod'` — always.
**Warning signs:** `import { z } from 'zod'` in content.config.ts.

### Pitfall 4: `entry.slug` instead of `entry.id` (Astro 6)

**What goes wrong:** TypeScript error — `entry.slug` does not exist in Astro 6 collection entries.
**Why it happens:** Pre-Astro-6 code used `entry.slug`. Astro 6 renamed this to `entry.id`.
**How to avoid:** Use `entry.id` for slug-based routing: `params: { slug: entry.id }`.
**Warning signs:** Phase 4 plan that references `post.slug` for `getStaticPaths`.

### Pitfall 5: Importing photo as string path instead of image object

**What goes wrong:** Astro throws `ExpectedImage` error — `<Image src="../assets/photos/foo.jpg">` is invalid.
**Why it happens:** OD-5 mockup uses string `src` attributes on `<img>`. The port must change these to import-and-pass-object pattern.
**How to avoid:** Always: `import hero from '../assets/photos/03-interior-hero.jpg'; <Image src={hero} />`.
**Warning signs:** Any `<Image src="..." />` or `<Picture src="..." />` where `...` is a string path.

### Pitfall 6: Scoped `<style>` in Astro doesn't apply to child components

**What goes wrong:** A CSS rule in `Base.astro`'s `<style>` block doesn't affect `.util-bar` inside `UtilBar.astro`.
**Why it happens:** Astro auto-scopes styles by adding a hash to selectors and elements. Parent styles don't cross component boundaries.
**How to avoid:** Component-specific styles go in the component's own `<style>`. Shared utilities go in `utilities.css` (imported globally in `Base.astro` frontmatter, which bypasses scoping). If a style truly must reach child components: use `:global(...)` — but this is a smell; restructure instead.
**Warning signs:** Any style in `Base.astro`'s `<style>` block that targets a `.class` name defined in a child component.

### Pitfall 7: oklch() color format in browser dev tools comparison

**What goes wrong:** The parity spot-check appears to fail because browser dev tools show computed colors in rgb() format, not oklch().
**Why it happens:** oklch() is rendered correctly by all modern browsers (2026), but DevTools may normalize to rgb() in computed styles.
**How to avoid:** This is cosmetic — oklch() is rendering correctly. Verify design intent by visual inspection, not by comparing color string formats.

### Pitfall 8: `Base.astro` CSS imports in frontmatter vs `<style>`

**What goes wrong:** Putting `tokens.css` inside a `<style>` block instead of importing it in frontmatter causes the CSS to be scoped and hash-mangled.
**Why it happens:** Unfamiliarity with Astro style mechanics.
**How to avoid:** Global CSS must be imported in the frontmatter (the `---` fences): `import '../styles/tokens.css';`. This tells Vite to bundle it as a global CSS file without scoping.
**Warning signs:** `<style>@import "../styles/tokens.css";</style>` in Base.astro — this would scope the tokens to Base.astro only.

---

## Code Examples

### Content Config (`site/src/content.config.ts`)

```typescript
// Source: https://docs.astro.build/en/guides/content-collections/
// NOTE: This file is at src/content.config.ts — NOT src/content/config.ts (Astro 6 requirement)
import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from 'astro/loaders';

const services = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/services' }),
  schema: z.object({
    title: z.string(),
    price: z.number(),
    duration: z.string(),
    bluf: z.string(),
    faqs: z.array(z.object({ q: z.string(), a: z.string() })),
    heroPhoto: z.string().optional(),
  }),
});

const neighborhoods = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/neighborhoods' }),
  schema: z.object({
    title: z.string(),
    landmarks: z.array(z.string()),
    distance: z.string(),
    bluf: z.string(),
    faqs: z.array(z.object({ q: z.string(), a: z.string() })),
  }),
});

export const collections = { services, neighborhoods };
```

### Stub Service Entry (`site/src/content/services/fades.md`)

```markdown
---
title: "Fades"
price: 30
duration: "30 min"
bluf: "Joe's Barbershop offers fade haircuts in Bostonia, El Cajon. Haircut $30. Walk-ins welcome."
faqs: []
heroPhoto: "05-mid-cut.jpg"
---

Stub content — Phase 3 replaces with AEO-optimized prose and FAQs.
```

### Stub Neighborhood Entry (`site/src/content/neighborhoods/bostonia.md`)

```markdown
---
title: "Bostonia Barber"
landmarks: ["Bostonia area", "East County San Diego"]
distance: "local"
bluf: "Joe's Barbershop is the traditional barbershop serving Bostonia in El Cajon, East County San Diego."
faqs: []
---

Stub content — Phase 4 replaces with AEO-optimized neighborhood-specific prose.
```

### Business JSON (`site/src/data/business.json`)

```json
{
  "name": "Joe's Barbershop",
  "address": {
    "street": "723 E Bradley Ave",
    "suite": "#C",
    "city": "El Cajon",
    "state": "CA",
    "zip": "92021"
  },
  "phone": "(619) 891-2775",
  "hours": {
    "tuesday":   { "open": "10:00", "close": "18:30" },
    "wednesday": { "open": "10:00", "close": "18:30" },
    "thursday":  { "open": "10:00", "close": "19:30" },
    "friday":    { "open": "10:00", "close": "19:30" },
    "saturday":  { "open": "10:00", "close": "19:30" },
    "sunday":    null,
    "monday":    null
  },
  "prices": {
    "haircut":     30,
    "shave":       30,
    "beardLineUp": 20,
    "cleanUp":     15,
    "haircutBeard": 50,
    "kidsCut":     null
  },
  "ratings": {
    "google": { "value": 4.9, "count": 91, "asOf": "2026-05-07" },
    "yelp":   { "value": 4.9, "count": 33, "asOf": "2026-05-07" }
  },
  "sameAs": {
    "gbp":       "https://www.google.com/maps/place/Joes-Barbershop-El-Cajon",
    "yelp":      "https://www.yelp.com/biz/joes-barbershop-el-cajon",
    "instagram": "https://www.instagram.com/joes_barbershop_el_cajon",
    "facebook":  ""
  },
  "photos": {
    "logo":        "01-logo.jpg",
    "storefront":  "02-storefront.jpg",
    "hero":        "03-interior-hero.jpg",
    "heritage":    "04-heritage-chair.jpg",
    "midCut":      "05-mid-cut.jpg",
    "priceBoard":  "06-price-board-cash-only.jpg"
  },
  "areaServed": ["El Cajon", "Bostonia", "Santee", "Lakeside", "La Mesa"]
}
```

**Hours note:** Values above are from vault baseline. The plan MUST include a step where the executor reads the current GBP listing and corrects any discrepancy before writing business.json. The vault and the mockup disagree on Saturday hours.

### Business TypeScript Re-export (`site/src/data/business.ts`)

```typescript
// Source: https://docs.astro.build/en/guides/imports/#json
import businessData from './business.json';

interface HoursEntry {
  open: string;
  close: string;
}

interface BusinessRecord {
  name: string;
  address: {
    street: string;
    suite: string;
    city: string;
    state: string;
    zip: string;
  };
  phone: string;
  hours: Record<string, HoursEntry | null>;
  prices: {
    haircut: number;
    shave: number;
    beardLineUp: number;
    cleanUp: number;
    haircutBeard: number;
    kidsCut: number | null;
  };
  ratings: Record<string, { value: number; count: number; asOf: string }>;
  sameAs: Record<string, string>;
  photos: Record<string, string>;
  areaServed: string[];
}

export const business = businessData as BusinessRecord;
```

### Base.astro with tokens.css + utilities.css imports

```astro
---
// site/src/layouts/Base.astro — Phase 2 adds the two CSS imports
import UtilBar from '../components/UtilBar.astro';
import Masthead from '../components/Masthead.astro';
import Footer from '../components/Footer.astro';
import '../styles/tokens.css';
import '../styles/utilities.css';

interface Props {
  title: string;
  description?: string;
}

const { title, description } = Astro.props;
---
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title}</title>
    {description && <meta name="description" content={description} />}
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IM+Fell+English:ital@0;1&family=Playfair+Display:wght@600;800;900&family=DM+Serif+Display:ital@0;1&family=Newsreader:opsz,wght@6..72,400;6..72,500;6..72,600&family=Oswald:wght@500;600;700&family=JetBrains+Mono:wght@500&display=swap" />
    <slot name="head" />
  </head>
  <body>
    <UtilBar />
    <Masthead />
    <main><slot /></main>
    <Footer />
  </body>
</html>
```

### Hero Component Skeleton (`site/src/components/Hero.astro`)

```astro
---
import { Picture } from 'astro:assets';
import heroPhoto from '../assets/photos/03-interior-hero.jpg';
import { business } from '../data/business';
---
<section class="hero" aria-label="Joe's Barbershop in Bostonia">
  <div class="hero-grid">
    <div class="hero-copy">
      <!-- hero copy using business.phone, business.ratings.google, etc. -->
    </div>
    <div class="hero-photo">
      <Picture
        src={heroPhoto}
        formats={['avif', 'webp']}
        alt="Inside Joe's Barbershop — black and white checkerboard tile floor stretching across the shop, three barber chairs along the right wall"
        loading="eager"
        fetchpriority="high"
      />
      <span class="photo-credit">Bostonia · interior of Joe's, three stations.</span>
      <div class="hero-checker-ribbon" aria-hidden="true"></div>
    </div>
  </div>
</section>
<style>
  .hero { position: relative; overflow: hidden; border-bottom: 1px solid var(--border); }
  /* ... remaining hero-specific CSS ... */
</style>
```

---

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None (Vitest not installed) — build + grep smoke checks |
| Config file | None |
| Quick run command | `cd site && npm run build` |
| Full suite command | `cd site && npm run build` + grep verification suite |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| DATA-01 | `business.ts` exports typed record; pages can access `business.phone` etc. | smoke (build) | `npm run build` exits 0 (TypeScript errors surface here) | ❌ Wave 0 |
| DATA-01 | `business.ts` imports `business.json` and re-exports typed | static (grep) | `grep -q "BusinessRecord" site/src/data/business.ts` | ❌ Wave 0 |
| DATA-02 | `content.config.ts` exists at `src/` level, not `src/content/` level | static (existence) | `test -f site/src/content.config.ts && ! test -f "site/src/content/config.ts"` | ❌ Wave 0 |
| DATA-02 | `getCollection('services')` returns 6 entries at build | smoke (build) | `npm run build` + check for 6 service routes (Phase 4, not Phase 2); Phase 2 just validates schema | ❌ Wave 0 |
| DATA-03 | 6 service stubs pass schema validation | smoke (build) | `npm run build` exits 0 — Zod validation errors fail the build | ❌ Wave 0 |
| DATA-04 | 5 neighborhood stubs pass schema validation | smoke (build) | Same — build exits 0 | ❌ Wave 0 |
| DESN-01 | tokens.css + utilities.css exist and are imported in Base.astro | static (grep) | `grep -q "tokens.css" site/src/layouts/Base.astro && grep -q "utilities.css" site/src/layouts/Base.astro` | ❌ Wave 0 |
| DESN-02 | 12 component files exist | static (existence) | `ls site/src/components/ \| grep -E "(Hero\|FactStrip\|PriceBoard\|Heritage\|Visit\|FAQ\|ClosingCTA\|CheckDivider\|SectionMark\|UtilBar\|Masthead\|Footer)\.astro" \| wc -l` = 12 | ❌ Wave 0 |
| DESN-03 | No tweaks panel in output | static (grep) | `grep -r "tweaks" site/src/` = 0; `grep -r 'data-font\|data-checker' site/src/` = 0 | ❌ Wave 0 |
| DESN-03 | No tweaks in built HTML | smoke (build + grep) | `npm run build && ! grep -q "tweaks" site/dist/index.html` | ❌ Wave 0 |
| DESN-04 | 6 photos in src/assets/photos/ | static (existence) | `ls site/src/assets/photos/ \| wc -l` = 6 | ❌ Wave 0 |
| DESN-04 | Hero uses Picture, others use Image | static (grep) | `grep -q "Picture" site/src/components/Hero.astro` | ❌ Wave 0 |
| DESN-04 | Hero has fetchpriority=high | static (grep) | `grep -q 'fetchpriority="high"' site/src/components/Hero.astro` | ❌ Wave 0 |
| Phase SC-1 | `business.ts` TypeScript-safe imports | smoke (build) | `npm run build` exits 0 | ❌ Wave 0 |
| Phase SC-2 | `getCollection()` validates without schema errors | smoke (build) | `npm run build` exits 0 | ❌ Wave 0 |
| Phase SC-3 | OD-5 visually identical | manual | Browser side-by-side comparison of `_dev-mockup-parity.astro` vs mockup | ❌ Wave 0 (scratch page) |
| Phase SC-4 | Tweaks panel absent | smoke (build + grep) | `npm run build && ! grep -q "tweaks" site/dist/index.html` | ❌ Wave 0 |
| Phase SC-5 | Photos render (no broken img) | smoke (build + visual) | `npm run build` exits 0; open parity page and check images | ❌ Wave 0 |
| D-05 | data-phase1-stub removed | static (grep) | `grep -r "data-phase1-stub" site/src/` = 0 | ❌ Wave 0 |

### Sampling Rate

- **Per task commit:** `cd site && npm run build` exits 0
- **Per wave merge:** Build exit 0 + run full grep verification suite (tweaks, data-phase1-stub, data-font, data-checker)
- **Phase gate:** All grep checks clean + parity page renders correctly + `npm run build` exit 0

### Wave 0 Gaps (everything)

- [ ] `site/src/data/business.json` — create with canonical NAP (executor must verify hours from GBP first)
- [ ] `site/src/data/business.ts` — create typed re-export
- [ ] `site/src/content.config.ts` — create with services + neighborhoods collection definitions
- [ ] `site/src/content/services/*.md` — create 6 stub files
- [ ] `site/src/content/neighborhoods/*.md` — create 5 stub files
- [ ] `site/src/styles/tokens.css` — create with :root vars, reset, base rules
- [ ] `site/src/styles/utilities.css` — create with shared atoms
- [ ] `site/src/assets/photos/` — create directory, copy 6 photos
- [ ] 12 component `.astro` files — replace 3 stubs + create 9 new
- [ ] `site/src/layouts/Base.astro` — add CSS imports + Google Fonts links
- [ ] `site/src/pages/_dev-mockup-parity.astro` — create parity scratch page

---

## Project Constraints (from CLAUDE.md)

| Constraint | Source | Phase 2 Impact |
|------------|--------|----------------|
| Tech stack: Astro, no Tailwind | CLAUDE.md Constraints | No `@astrojs/tailwind`; port OD-5 CSS as-is |
| No live deployment before Joe approves | CLAUDE.md Constraints | `vercel --prod` never; preview URL only |
| Design fidelity: preserve OD-5 CSS | CLAUDE.md Constraints | No redesign; mechanical port from mockup |
| Photo set limited to 6 existing photos | CLAUDE.md Constraints | Only `inputs/photos/` photos; no AI-generated images |
| AEO structural rules | CLAUDE.md Constraints | No hidden content in Phase 2 components; FAQ as flat text; Phase 3 concern primarily |
| No duplication of vault content | Global CLAUDE.md | Don't copy vault docs into repo; reference business data from vault into business.json |
| Research before implementing | Global CLAUDE.md | This RESEARCH.md fulfills that requirement |

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Node.js | Astro build | ✓ | v25.9.0 | — |
| npm | Package management | ✓ | 11.12.1 | — |
| Astro 6.3.0 | All Phase 2 | ✓ | 6.3.0 (installed) | — |
| astro/zod | Content collections | ✓ | Bundled with astro | — |
| astro:assets | Image components | ✓ | Built into Astro 6 | — |
| astro/loaders (glob) | Content config | ✓ | Built into Astro 6 | — |
| Sharp | Image processing at build | ✓ | 0.34.5 (from Phase 1) | — |
| GBP listing (current hours) | business.json hours field | requires executor action | Public URL | Vault baseline (with discrepancy flag) |
| Facebook page URL for sameAs | business.json sameAs.facebook | unknown | — | Leave empty string, Phase 5 populates |

[VERIFIED: site/node_modules/astro/package.json → 6.3.0]
[VERIFIED: npm view astro version → 6.3.1 (latest); site has 6.3.0 — one patch behind, no action needed for Phase 2]

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `src/content/config.ts` | `src/content.config.ts` | Astro 6.0 | Build error if wrong path used |
| `defineCollection({ schema })` | `defineCollection({ loader, schema })` | Astro 5/6 | Build error if loader omitted |
| `import { z } from 'zod'` | `import { z } from 'astro/zod'` | Astro 3+ | Wrong package if `zod` not in deps |
| `entry.slug` | `entry.id` | Astro 6.0 | TypeScript error |
| `entry.render()` | `render(entry)` from `astro:content` | Astro 6.0 | Phase 4 concern, not Phase 2 |
| `<img src="./photo.jpg">` | `import photo from '...'; <Image src={photo} />` | Astro 3+ | No optimization if string src used |
| `site/public/photos/` | `site/src/assets/photos/` | Astro 3+ (AVIF/WebP) | Files in public/ get no optimization |
| `image.layout: 'constrained'` behind `experimental.responsiveImages` flag | Stable, no flag needed | Astro 5.10 | Config in Phase 1 already correct |

---

## Open Questions

1. **Facebook page URL for `sameAs`**
   - What we know: The vault does not record a Facebook page URL for Joe's Barbershop.
   - What's unclear: Whether a Facebook page exists and its URL.
   - Recommendation: Set `sameAs.facebook: ""` in `business.json`. The plan should include a note for the executor to check and fill in if found. Phase 5 (AEO-09) will verify sameAs completeness.

2. **`kidsCut` price**
   - What we know: No standalone kids cut price appears in `inputs/00-brief.md`, `inputs/03-photo-notes.md`, or the mockup price board.
   - What's unclear: Whether kids cuts are the same price as adult haircuts ($30) or discounted.
   - Recommendation: Set `prices.kidsCut: null` in `business.json`. The `services/kids-cuts.md` stub sets `price: 30` as a placeholder — the plan should flag this as "confirm with Joe."

3. **Saturday hours discrepancy**
   - What we know: Vault says `Thu-Sat 10:00-19:30`. Mockup shows `Sat 10am-6:30pm` (closes at 18:30).
   - What's unclear: Which is current. Mockup may have been authored with older data.
   - Recommendation: The plan MUST include a mandatory step: executor reads current GBP listing before writing business.json. This is not skippable.

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Facebook page URL for Joe's is unknown / empty | business.json shape | Low — empty string is safe; Phase 5 fills in |
| A2 | `kidsCut` price is null / TBD (not explicitly priced in inputs) | business.json prices | Low — null + ask Joe at showcase; doesn't block build |
| A3 | `data-checker="standard"` is the production default (tweaks panel stripped, standard checker hardcoded) | CSS port strategy | Low — the mockup's briefed default is "Standard"; stripping tweaks locks this in permanently |
| A4 | Google Fonts font weights specified in the mockup `<link>` URL are the complete set needed (no additional weights used inline) | tokens.css / Base.astro | Low — visual parity check will catch any missing weights |
| A5 | The `[data-font]` CSS variants (playfair, dm) are dead code once tweaks panel is removed | CSS port — cross-component CSS Case 2 | Low — tweaks panel is stripped; these variants cannot be activated without the JS |

---

## Sources

### Primary (HIGH confidence)

- Context7 `/withastro/docs` — content collections config location, `defineCollection` with `loader`, `getCollection` API, `entry.id` vs `entry.slug`, `glob` loader, JSON imports, Image/Picture component usage, `src/content.config.ts` requirement in Astro 6
- `mockups/home-v5/index.html` lines 1–822 — full direct inspection; all component line ranges, CSS selectors, DOM structure
- `site/node_modules/astro/package.json` — version 6.3.0 confirmed installed
- `.planning/phases/02-data-design-system/02-CONTEXT.md` — all locked decisions D-01 through D-26
- `.planning/phases/01-scaffold/01-RESEARCH.md` — Pitfall 5 (public/ vs src/assets/), Pitfall 4 (TypeScript strict), Image component patterns
- `.planning/phases/01-scaffold/01-03-SUMMARY.md` — confirmed Base.astro structure, data-phase1-stub marker values, section ordering
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — canonical NAP baseline: address 723 E Bradley Ave #C, El Cajon CA 92021; phone (619) 891-2775; owner Joe Denesowicz; ratings 4.9/91 Google, 4.9/33 Yelp
- `inputs/03-photo-notes.md` — canonical price board data (HAIRCUT 30, SHAVE 30, BEARD LINE-UP 20, CLEAN UP 15), photo-to-component assignments
- `inputs/00-brief.md` — confirms HAIRCUT+BEARD $50 combo; no standalone kidsCut price listed

### Secondary (MEDIUM confidence)

- `npm view astro version` → 6.3.1 (latest patch ahead of installed 6.3.0; no critical Phase 2 changes expected in patch)

### Tertiary (LOW confidence)

- None — all load-bearing claims verified via Context7 or direct file inspection.

---

## Metadata

**Confidence breakdown:**
- Content Collections API (Astro 6): HIGH — verified via Context7 official docs; config path change is documented as a hard error
- OD-5 component decomposition: HIGH — line ranges from direct inspection of locked mockup file
- CSS port strategy: HIGH — direct inspection + D-06..D-09 decisions lock the structure
- business.ts pattern: HIGH — Astro/Vite JSON import documented; interface pattern is idiomatic TypeScript
- Image integration: HIGH — verified via Context7; Phase 1 research confirmed src/assets/ target
- Hours data: MEDIUM — vault baseline available but GBP confirmation is required (discrepancy found)
- sameAs URLs: MEDIUM — Google + Yelp URLs visible in mockup; IG handle confirmed in vault; FB URL unknown

**Research date:** 2026-05-07
**Valid until:** 2026-06-07 (Astro/Zod stack stable; content collections API fully stable in 6.x)
