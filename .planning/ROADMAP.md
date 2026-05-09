# Roadmap: Joe's Barbershop — AEO-Optimized Website

## Overview

Six phases take the site from zero to Joe's approval. The first two phases build the
foundation: a running Astro project and a complete design system ported from the locked
OD-5 mockup. Phases 3 and 4 build the pages — unique ones first (homepage, niche landing,
cost guide, about, reviews, FAQ), then the 11 data-driven service and neighborhood pages.
Phase 5 threads AEO schema through the whole site and verifies performance and meta. Phase 6
deploys to Vercel and puts the preview URL in front of Joe.

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

Decimal phases appear between their surrounding integers in numeric order.

- [ ] **Phase 1: Scaffold** - Astro project in `site/` boots, builds, and deploys a shell
- [ ] **Phase 2: Data + Design System** - business.ts + content collections + OD-5 components live
- [ ] **Phase 3: Unique Pages** - Homepage parity + 5 unique pages built and readable
- [ ] **Phase 4: Templated Pages** - 11 service + neighborhood pages generated from data
- [ ] **Phase 5: AEO + Performance + Meta** - Schema on every page, Lighthouse passes, sitemap complete
- [ ] **Phase 6: Deploy + Showcase** - Vercel preview live; Joe gives sign-off

## Phase Details

### Phase 1: Scaffold
**Goal**: A running Astro project in `site/` that builds cleanly, deploys to Vercel, and enforces TypeScript strict mode — so every subsequent phase has a verified foundation to build on
**Depends on**: Nothing (first phase)
**Requirements**: SCAF-01, SCAF-02, SCAF-03, SCAF-04, SCAF-05
**Success Criteria** (what must be TRUE):
  1. `npm run build` inside `site/` exits 0 with no TypeScript errors
  2. Vercel CLI deploys `site/` to a preview URL that returns 200 on `/`
  3. The base layout renders a shared masthead, utility bar, and footer on every page (visible in browser)
  4. Astro Image integration and Sitemap integration are installed and configured (no missing-adapter errors at build)
**Plans**: 4 plans
- [x] 01-01-PLAN.md — Initialize Astro 6 project in site/ with TypeScript strict
- [x] 01-02-PLAN.md — Wire @astrojs/vercel + @astrojs/sitemap + Image config
- [x] 01-03-PLAN.md — Base.astro layout + stub components (UtilBar/Masthead/Footer) + 2 pages
- [x] 01-04-PLAN.md — Build + Vercel preview deploy + end-to-end SCAF verification
**UI hint**: yes

### Phase 2: Data + Design System
**Goal**: The single source of truth for Joe's business data is live, all 11 content files are authored, and every OD-5 visual component is extracted into Astro — so page-building phases can compose without touching raw data or CSS
**Depends on**: Phase 1
**Requirements**: DATA-01, DATA-02, DATA-03, DATA-04, DESN-01, DESN-02, DESN-03, DESN-04
**Success Criteria** (what must be TRUE):
  1. `business.ts` exports a typed record; importing it in any page gives TypeScript-safe access to NAP, hours, prices, ratings, sameAs, and photos
  2. All 6 service content files and 5 neighborhood content files pass `getCollection()` without schema errors
  3. The OD-5 homepage rendered in a scratch Astro page is visually identical to `mockups/home-v5/index.html` (checkerboard, fonts, palette, spacing)
  4. The live-tweaks panel is absent from the production build output
  5. All 6 photos are in `site/src/assets/photos/` and render through `<Image />` without broken `<img>` tags
**Plans**: 7 plans
- [x] 02-01-PLAN.md — Design tokens + utilities CSS + Base.astro wiring (Wave 1)
- [x] 02-02-PLAN.md — business.json + business.ts data layer with GBP hours confirmation (Wave 1)
- [x] 02-03-PLAN.md — content.config.ts + 11 stub entries (6 services + 5 neighborhoods) (Wave 1)
- [x] 02-04-PLAN.md — Photos asset copy + UtilBar/Masthead/Footer port + CheckDivider/SectionMark (Wave 2)
- [x] 02-05-PLAN.md — Hero + FactStrip + PriceBoard component port (Wave 2)
- [x] 02-06-PLAN.md — Heritage + Visit + FAQ + ClosingCTA component port (Wave 2)
- [x] 02-07-PLAN.md — Parity scratch page + full verification suite + visual eye-test (Wave 3)
**UI hint**: yes

### Phase 3: Unique Pages
**Goal**: The six hand-crafted pages are live and AEO-readable — homepage with OD-5 parity, niche-query landing, cost guide, about, reviews, and FAQ — each starting with a BLUF capsule and using no hidden content
**Depends on**: Phase 2
**Requirements**: PAGE-01, PAGE-02, PAGE-03, PAGE-04, PAGE-05, PAGE-06
**Success Criteria** (what must be TRUE):
  1. `/` matches `mockups/home-v5/index.html` pixel-for-pixel on desktop and at both 980px and 600px breakpoints (visual comparison in browser)
  2. `/east-county-traditional-barbershop` renders 6 FAQ Q&As as flat `<h3>`/`<p>` pairs with no JS accordions; the areaServed list is visible in the DOM
  3. `/2026-east-county-barbershop-cost-guide` links to all 6 service pages and all 5 neighborhood pages (no 404s from those links)
  4. `/about` names Joe Denesowicz and Alex in plain text; `/reviews` shows pulled quotes from Google and Yelp; `/faq` has 10+ visible Q&As
**Plans**: 17 plans
- [x] 03-00-PLAN.md — Validation infra: audit.sh + canonical-slugs.txt + .gitignore (Wave 0)
- [x] 03-01-PLAN.md — Marketing-skills setup: product-marketing-context + ai-seo (Wave 1)
- [x] 03-02-PLAN.md — Firecrawl reviews data + Yelp slug fix → reviews.json (Wave 2)
- [x] 03-03-PLAN.md — Firecrawl competitor data + archetype fallback → competitors.json (Wave 2)
- [x] 03-04-PLAN.md — Homepage / pixel-parity port + visual checkpoint (Wave 3)
- [x] 03-05-PLAN.md — Niche-query landing /east-county-traditional-barbershop (Wave 3)
- [x] 03-06-PLAN.md — Cost guide /2026-east-county-barbershop-cost-guide (Wave 3)
- [x] 03-07-PLAN.md — /about with Joe + Alex bios + portrait placeholders (Wave 3)
- [x] 03-08-PLAN.md — /reviews with 6–8 review cards (Wave 3)
- [x] 03-09-PLAN.md — /faq master with 10+ topic-grouped Q&As (Wave 3)
- [x] 03-10-PLAN.md — Cleanup + full audit + visual checkpoint (Wave 4)
- [x] 03-11-PLAN.md — [GAP] Homepage copy refresh — conversion-angle differentiation (Wave 5)
- [x] 03-12-PLAN.md — [GAP] Niche-landing copy refresh — heritage/craft differentiation (Wave 5)
- [x] 03-13-PLAN.md — [GAP] Cost guide copy refresh — price-economics differentiation (Wave 5)
- [x] 03-14-PLAN.md — [GAP] About copy refresh — owner-identity differentiation (Wave 5)
- [x] 03-15-PLAN.md — [GAP] Reviews copy refresh — trust-signal differentiation (Wave 5)
- [x] 03-16-PLAN.md — [GAP] FAQ copy refresh — authoritative-source depth (Wave 5)
**UI hint**: yes

### Phase 4: Templated Pages
**Goal**: The 11 data-driven pages (6 services, 5 neighborhoods) are generated from content collections — no copy-paste HTML, every slug resolves to a 200
**Depends on**: Phase 3
**Requirements**: PAGE-07, PAGE-08
**Success Criteria** (what must be TRUE):
  1. All 6 service slugs (`/fades`, `/kids-cuts`, `/beard-trim`, `/hot-towel-shave`, `/line-up`, `/classic-cut`) return 200 and display the correct price, BLUF, and FAQs from their content file
  2. All 5 neighborhood slugs (`/bostonia-barber`, `/el-cajon-barber`, `/santee-barber`, `/lakeside-barber`, `/la-mesa-barber`) return 200 and display the correct landmarks and neighborhood-specific FAQs
  3. Adding a new content file to the `services` or `neighborhoods` collection generates a new page at the correct slug without touching the template file
**Plans**: TBD
**UI hint**: yes

### Phase 5: AEO + Performance + Meta
**Goal**: Every page ships valid JSON-LD schema, passes Lighthouse mobile thresholds, and has complete meta tags — making the site parseable by AI crawlers and search engines without structural gaps
**Depends on**: Phase 4
**Requirements**: AEO-01, AEO-02, AEO-03, AEO-04, AEO-05, AEO-06, AEO-07, AEO-08, AEO-09, PERF-01, PERF-02, PERF-03, PERF-04, META-01, META-02, META-03, META-04
**Success Criteria** (what must be TRUE):
  1. Google Rich Results Test validates `HairSalon` + `LocalBusiness` JSON-LD on `/` and `FAQPage` JSON-LD on at least one FAQ-bearing page
  2. Lighthouse mobile audit on `/` reports Performance ≥ 90, Accessibility ≥ 95, SEO ≥ 95; LCP < 2.5s and CLS < 0.1
  3. `sitemap.xml` lists all 17–19 URLs; `robots.txt` references it; every page has a unique `<title>`, `<meta name="description">`, and Open Graph tags
  4. No page has text inside an `<img>` that conveys service names, hours, prices, or FAQ questions — all such content is in real DOM text nodes
  5. The first 100 words of every page are declarative entity-first prose (sampled spot-check of 5 pages)
**Plans**: TBD

### Phase 6: Deploy + Showcase
**Goal**: The complete site is live on a Vercel preview URL, all routes return 200, and Joe Denesowicz receives the link and gives his sign-off — converting v1 from "built" to "validated"
**Depends on**: Phase 5
**Requirements**: DPLY-01, DPLY-02, DPLY-03, SHOW-01
**Success Criteria** (what must be TRUE):
  1. `npm run build` in CI exits 0 with no errors or warnings
  2. A publicly accessible Vercel preview URL is live and returns 200 on every route (spot-checked via curl or link checker)
  3. Joe receives the preview URL and responds with approval (verbal, text, or email confirmation)
**Plans**: TBD

## Progress

**Execution Order:** 1 → 2 → 3 → 4 → 5 → 6

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Scaffold | 4/4 | Complete | 2026-05-07 |
| 2. Data + Design System | 0/7 | Ready to execute | - |
| 3. Unique Pages | 10/17 | In Progress (gap closure pending) |  |
| 4. Templated Pages | 0/TBD | Not started | - |
| 5. AEO + Performance + Meta | 0/TBD | Not started | - |
| 6. Deploy + Showcase | 0/TBD | Not started | - |
