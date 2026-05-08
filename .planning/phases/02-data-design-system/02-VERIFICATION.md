---
phase: 02-data-design-system
verified: 2026-05-07T17:25:00Z
status: human_needed
score: 4/5
overrides_applied: 0
human_verification:
  - test: "Open /dev-mockup-parity in a browser at 1440px, 980px, and 600px viewports and compare side-by-side with mockups/home-v5/index.html"
    expected: "Checkerboard tile motif, IM Fell English/Playfair Display/Oswald fonts, oklch palette, spacing blocks, letter-board price section, heritage photo placement, visit card layout all visually match the OD-5 mockup"
    why_human: "Visual fidelity cannot be confirmed programmatically — structural HTML/CSS parity is verified but pixel-level rendering differences (font rendering, spacing rounding, oklch color display) require a human eye"
---

# Phase 2: Data + Design System — Verification Report

**Phase Goal:** The single source of truth for Joe's business data is live, all 11 content files are authored, and every OD-5 visual component is extracted into Astro — so page-building phases can compose without touching raw data or CSS.
**Verified:** 2026-05-07T17:25:00Z
**Status:** human_needed (4/5 truths auto-verified; SC-3 visual parity requires human sign-off)
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | `business.ts` exports a typed record; importing it gives TypeScript-safe access to NAP, hours, prices, ratings, sameAs, and photos | VERIFIED | `BusinessRecord` interface defined at `site/src/data/business.ts:10`; all 9 required fields (name, address, phone, hours, prices, ratings, sameAs, photos, areaServed) present in `business.json`; exported as typed const; no `@type`/`@context` schema.org shaping (D-20 clean) |
| 2 | All 6 service content files and 5 neighborhood content files pass `getCollection()` without schema errors | VERIFIED | 6 service files confirmed (`fades`, `classic-cut`, `beard-trim`, `hot-towel-shave`, `kids-cuts`, `line-up`); 5 neighborhood files confirmed (`bostonia`, `el-cajon`, `santee`, `lakeside`, `la-mesa`); `content.config.ts` uses Astro 6 flat path with `defineCollection` + `glob` loader; no `.min()/.max()/enum()` constraints (D-17 clean); `npm run build` exits 0 with no schema errors |
| 3 | The OD-5 homepage rendered in a scratch Astro page is visually identical to `mockups/home-v5/index.html` (checkerboard, fonts, palette, spacing) | HUMAN NEEDED | Structural parity confirmed: all 12 components wired in `dev-mockup-parity.astro`; no tweaks panel, no `data-phase1-stub` markers; oklch tokens, Google Fonts link, all CSS selectors present; prior orchestrator Playwright check approved structural/styling parity. Final pixel-level human eye-test still required at 1440px/980px/600px |
| 4 | The live-tweaks panel is absent from the production build output | VERIFIED | `grep -r "tweaks" site/src/` returns 0 matches; `grep -r "data-font\|data-checker" site/src/` returns 0 matches; `grep -r "applyFont\|applyCheck\|toggleTweaks" site/src/` returns 0 matches; `grep -r "tweaks" site/dist/` returns 0 matches |
| 5 | All 6 photos are in `site/src/assets/photos/` and render through `<Image />` without broken `<img>` tags | VERIFIED | 6 photos confirmed at `site/src/assets/photos/` (01-logo.jpg through 06-price-board-cash-only.jpg); all components use `import` + `<Image>` or `<Picture>` (no raw path strings); build output shows hashed `/_astro/` paths with `srcset` on all image tags; hero uses `<Picture formats={['avif','webp']}>`  with `fetchpriority="high"`; no `public/photos` references anywhere in `site/src/` |

**Score:** 4/5 auto-verified (SC-3 human gate pending)

---

## Requirement Coverage

| REQ-ID | Code Reflection | Status |
|--------|-----------------|--------|
| DATA-01 | `site/src/data/business.ts` exports typed `business` const; `BusinessRecord` interface covers all DATA-01 fields; JSON is the source, TS is the typed view per D-19 | VERIFIED |
| DATA-02 | `site/src/content.config.ts` (Astro 6 flat path per D-24 — supersedes stale `src/content/config.ts` wording in REQUIREMENTS.md); `defineCollection` + `glob` loader for both collections | VERIFIED |
| DATA-03 | 6 service `.md` files in `site/src/content/services/`; frontmatter has `title`, `price` (number), `duration`, `bluf`, `faqs` (array); schema-passing stubs per D-15 | VERIFIED |
| DATA-04 | 5 neighborhood `.md` files in `site/src/content/neighborhoods/`; frontmatter has `title`, `landmarks` (array), `distance`, `bluf`, `faqs` (array); schema-passing stubs per D-15 | VERIFIED |
| DESN-01 | `site/src/styles/tokens.css` has full `:root` block (22 design tokens including `--bg`, palette, font stacks, `--maxw`, `--gutter`); `site/src/styles/utilities.css` has `.wrap`, `.eyebrow`, `.kicker-rule`, `.display`, `.check-divider`, `.section-mark`, `.btn`, `.section-head`; both imported in `Base.astro` | VERIFIED |
| DESN-02 | All 12 named components exist and are substantive: UtilBar, Masthead, Hero, FactStrip, PriceBoard, Heritage, Visit, FAQ, ClosingCTA, Footer, CheckDivider, SectionMark — 9 of 12 consume `business` data; no `data-phase1-stub` markers remain | VERIFIED |
| DESN-03 | No `.tweaks` markup, no `tweaks*` CSS, no `data-font`/`data-checker` attributes, no `applyFont`/`applyCheck`/`toggleTweaks` JS anywhere in `site/src/`; confirmed absent from `site/dist/` as well | VERIFIED |
| DESN-04 | 6 photos in `site/src/assets/photos/` (not `public/photos/`); all 4 photo-consuming components use Astro `<Image>` or `<Picture>` with `import`-style references; build produces hashed AVIF/WebP variants with `srcset` | VERIFIED |

**Note on DATA-02 path:** REQUIREMENTS.md still reads `src/content/config.ts` (Astro 4 legacy path). D-24 documents this as a known stale wording — Astro 6.3.0 requires `src/content.config.ts`. The correct Astro 6 path is in use and the build confirms it works. REQUIREMENTS.md update is queued for `/gsd-transition` after Phase 2 (per D-12).

---

## Build + Quality Gates

| Gate | Command | Result | Status |
|------|---------|--------|--------|
| Build exits 0 | `npm run build` in `site/` | "✓ Completed in 1.29s. 3 page(s) built" — no errors, no TS errors | PASS |
| Tweaks absent from build output | `grep -r "tweaks" site/dist/` | No output | PASS |
| data-phase1-stub removed | `grep -r "data-phase1-stub" site/src/` | 0 matches | PASS |
| Images processed (not verbatim) | Inspect `site/dist/dev-mockup-parity/index.html` img src attrs | All image `src` values are `/_astro/[hash].[ext]` — Astro Image pipeline ran | PASS |
| Hero fetchpriority | Inspect `<picture>` in build output | `fetchpriority="high"` on hero img; below-fold images have `loading="lazy"` | PASS |
| Zero client: directives | `grep -r "client:load\|client:idle\|client:visible\|client:only" site/src/` | 0 matches | PASS |
| No public/photos references | `grep -r "src/public/photos\|public/photos" site/src/` | 0 matches | PASS |
| content/config.ts (bad path) absent | `test -f site/src/content/config.ts` | NOT FOUND | PASS |
| No Zod min/max/enum on stub fields | `grep -E '\.min\(|\.max\(|enum\(' site/src/content.config.ts` | 0 matches (D-17 honored) | PASS |

---

## Decision Coverage (D-01..D-26)

| Decision | Trackable Claim | Verified |
|----------|-----------------|---------|
| D-03 | 12 named components locked — no renames/merges | All 12 present with exact locked names |
| D-05 | `data-phase1-stub` removed when replacing stub bodies | 0 matches in `site/src/` |
| D-07 | Globals in `tokens.css`, small atoms in `utilities.css`, both imported in `Base.astro` | Confirmed |
| D-10 | Tweaks panel stripped at 3 layers (markup, CSS, body attrs) | All 3 layers clean |
| D-11 | Photos at `site/src/assets/photos/` not `public/photos/` | Correct path; no `public/photos` refs |
| D-17 | Schema enforces shape, not quality — no min/max/enum on BLUF/FAQ fields | Confirmed |
| D-19 | JSON is truth, TS is the typed view | `business.json` + `business.ts` pattern correct |
| D-20 | No `@type`/`@context` shaping in `business.ts` | Confirmed absent |
| D-24 | Flat `content.config.ts` path (Astro 6), not `content/config.ts` | Correct path in use |
| D-25 | Section order locked: UtilBar → Masthead → main(slot) → Footer | `Base.astro` lines 28-31 confirm |
| D-26 | Named `<slot name="head" />` in `Base.astro` | Present at line 25 |

**Silent drops:** None detected. All 11 trackable decisions are reflected in the codebase.

---

## Data-Flow Trace (Level 4)

| Component | Data Variable | Source | Produces Real Data | Status |
|-----------|---------------|--------|--------------------|--------|
| UtilBar | `business.phone` | `import { business } from '../data/business'` → `business.json` | Real phone from JSON | FLOWING |
| Hero | `business.address.*`, `business.ratings.google.*` | Same import chain | Real NAP/ratings from JSON | FLOWING |
| FactStrip | `business.ratings.google.value`, `business.ratings.google.count`, `business.ratings.yelp.value` | Same import chain | Real review counts from JSON | FLOWING |
| PriceBoard | `business.prices.*` (haircut:30, shave:30, beardLineUp:20, cleanUp:15, haircutBeard:50) | Same import chain | Real prices from price-board photo | FLOWING |
| Visit | `business.address.*`, `business.phone` | Same import chain | Real NAP from JSON | FLOWING |
| Footer | `business.address.*`, `business.phone` | Same import chain | Real NAP from JSON | FLOWING |

**All data-consuming components pull from `business.json` through the typed `business` export. No hardcoded empty arrays or disconnected props detected.**

---

## Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| `content/services/*.md` | body | "Stub content — Phase 3/4 replaces..." | INFO | Intentional per D-15; load-bearing frontmatter (price, duration) is real; BLUF/FAQ stub text is labeled as such |
| `content/neighborhoods/*.md` | body | "Stub content — Phase 4 replaces..." | INFO | Intentional per D-15; landmark/distance data is real; stub label is explicit |
| `data/business.json` | sameAs.gbp | `"PLACEHOLDER-confirm-with-Joe"` | INFO | Intentional per D-21; documented in `_showcase_review_pending` array |
| `data/business.json` | sameAs.facebook | Empty string `""` | INFO | Intentional per D-21; documented in `_showcase_review_pending` |
| `data/business.json` | prices.kidsCut | `null` | INFO | Intentional per D-21; documented in `_showcase_review_pending` |

No blockers. All anti-patterns are intentional stubs with explicit documentation in `business.json._showcase_review_pending`.

---

## Behavioral Spot-Checks

| Behavior | Command/Check | Result | Status |
|----------|---------------|--------|--------|
| Build completes without errors | `npm run build` exit code | Exit 0, 3 pages built | PASS |
| Content collections loaded by Astro | Build produces 3 pages without schema errors | 0 collection errors in build output | PASS |
| Astro Image pipeline processed photos | `site/dist/_astro/*.avif` + `*.webp` files exist | 21 image variants generated (avif + webp + jpg fallbacks) | PASS |
| business.ts imports resolve | Build succeeds with TypeScript strict mode | 0 TS errors | PASS |
| Parity page renders full component tree | `site/dist/dev-mockup-parity/index.html` contains all section markers | All 12 component outputs present in built HTML | PASS |

---

## Human Verification Required

### 1. Visual Parity — OD-5 Pixel Check

**Test:** Open `site/dist/dev-mockup-parity/index.html` (or `npx astro dev` and navigate to `/dev-mockup-parity`) in a browser. Open `mockups/home-v5/index.html` in another tab. Compare side-by-side at 1440px, 980px (breakpoint), and 600px (mobile breakpoint) viewports.

**Expected:** Checkerboard motif (conic-gradient tile pattern) renders on dividers and hero ribbon; IM Fell English displays in headings; Oswald renders in the price board and utility bar; oklch color palette looks warm/antique not bright-primary; letter-board section has dark background with uppercase dot-leader pricing; heritage section shows photo left + copy right; visit section shows storefront photo + NAP card; spacing and max-width feel comparable to the mockup.

**Why human:** Astro's scoped CSS, font rendering across OS/browser, oklch color accuracy, and spacing rounding cannot be verified programmatically. The orchestrator noted prior structural/styling parity was approved via Playwright at 1440px — this is a final sign-off checkpoint for the build artifact.

---

## Open Items / Deferred

These items are documented and intentional — not gaps. They require Joe's input at showcase time.

| Item | Value | Reason Deferred |
|------|-------|-----------------|
| `hours.saturday.close` | `19:30` (vault baseline) | Mockup shows 18:30; conflict documented in `_showcase_review_pending`; Joe to confirm GBP hours at showcase |
| `sameAs.gbp` | `PLACEHOLDER-confirm-with-Joe` | GBP canonical `maps.google.com/?cid=` URL requires GBP login to retrieve |
| `sameAs.yelp` | Best-effort URL | Joe to confirm canonical Yelp URL at showcase |
| `sameAs.facebook` | Empty string | Joe to provide FB page URL if shop has one |
| `prices.kidsCut` | `null` | Joe to confirm price at showcase |
| `prices.haircutBeard` | `50` (from Square Site listing) | Joe to confirm or correct at showcase |

**REQUIREMENTS.md path update:** DATA-02 still reads `src/content/config.ts` — this is stale wording per D-24. Correct path is `src/content.config.ts`. Update queued for `/gsd-transition` after Phase 2 completes.

**Parity page note:** `dev-mockup-parity.astro` currently builds into the production dist (no `dev` exclusion). This is by design for Phase 2 verification. Phase 3 plan should decide whether to delete it or gate it behind `import.meta.env.DEV`.

---

## Verdict

**4/5 success criteria fully verified by automated checks. SC-3 (visual parity) is the only remaining gate and requires a human eye-test — structural and styling parity have been confirmed programmatically, but final visual sign-off is human-only.**

All 8 requirements (DATA-01..04, DESN-01..04) are satisfied in the codebase. The build is clean. All 12 components are substantive, wired, and data-flowing. The tweaks panel is fully excised. Photos are processed through the Astro Image pipeline with AVIF/WebP srcsets.

---

_Verified: 2026-05-07T17:25:00Z_
_Verifier: Claude (gsd-verifier)_
