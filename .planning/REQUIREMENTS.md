# Requirements: Joe's Barbershop — AEO-Optimized Website

**Defined:** 2026-05-06
**Core Value:** Win AI-assistant citations and Google AI Mode visibility for "barbershop in East County / El Cajon" queries while reading as the authentic strip-mall heritage shop Joe runs.

## v1 Requirements

Requirements for the showcase build delivered to Joe for sign-off.

### Scaffold

- [ ] **SCAF-01**: Astro project initialized in `site/` with TypeScript strict mode
- [ ] **SCAF-02**: Astro Image integration configured (AVIF/WebP/srcset, lazy-load)
- [ ] **SCAF-03**: Astro Sitemap integration configured for `/sitemap.xml`
- [ ] **SCAF-04**: Vercel adapter configured for static deploy
- [ ] **SCAF-05**: Base layout (`src/layouts/Base.astro`) renders shared masthead, util bar, footer on every page

### Data Source of Truth

- [ ] **DATA-01**: `src/data/business.ts` exports a typed business record (NAP, hours, prices, ratings, sameAs, photos, areaServed) used by every page
- [ ] **DATA-02**: `src/content.config.ts` (Astro 6 flat path — NOT the legacy nested `src/content/config.ts`, which throws `LegacyContentConfigError`) defines typed content collections for `services` and `neighborhoods`
- [ ] **DATA-03**: 6 service content files (`fades`, `kids-cuts`, `beard-trim`, `hot-towel-shave`, `line-up`, `classic-cut`) with frontmatter (price, duration, BLUF, FAQ) + markdown body
- [ ] **DATA-04**: 5 neighborhood content files (`bostonia`, `el-cajon`, `santee`, `lakeside`, `la-mesa`) with frontmatter (landmarks, distance, BLUF, FAQ) + markdown body

### Design Port

- [ ] **DESN-01**: OD-5 CSS ported to `src/styles/tokens.css` (`:root` oklch palette + reset + base rules) and `src/styles/utilities.css` (shared atoms — `.wrap`, `.eyebrow`, `.kicker-rule`, `.display`, `.check-divider`, `.section-mark`, `.section-head`, `.btn`), both imported once in `Base.astro` frontmatter; component-specific selectors live in per-component scoped `<style>` blocks. Preserves all design tokens (palette, fonts, checkerboard motif, spacing, breakpoints).
- [ ] **DESN-02**: Component library extracted: UtilBar, Masthead, Hero, FactStrip, PriceBoard, Heritage, Visit, FAQ, ClosingCTA, Footer, CheckDivider, SectionMark
- [ ] **DESN-03**: Live tweaks panel removed from production build (was OD review tool only)
- [ ] **DESN-04**: 6 photos copied to `src/assets/photos/` (NOT `public/photos/` — Astro `<Image />` only processes `src/`-based assets for AVIF/WebP/srcset/hash; files in `public/` are served verbatim and break Phase 5 perf targets) and rendered through Astro `<Image />` (or `<Picture>` for the hero)

### Pages — Unique

- [x] **PAGE-01**: `/` (homepage) renders parity with `mockups/home-v5/index.html` using shared components
- [x] **PAGE-02**: `/east-county-traditional-barbershop` niche-query landing — locks in current accidental AEO win; FAQPage schema; areaServed list; 6 niche-specific FAQ Q&As
- [x] **PAGE-03**: `/2026-east-county-barbershop-cost-guide` comparative listicle with Article schema; cross-links to all 6 service pages and 5 neighborhood pages
- [x] **PAGE-04**: `/about` with Person schema for Joe Denesowicz and Alex
- [x] **PAGE-05**: `/reviews` with AggregateRating schema and quote highlights from public Google + Yelp reviews
- [ ] **PAGE-06**: `/faq` master FAQ with FAQPage schema (10+ Q&As)

### Pages — Templated (data-driven)

- [ ] **PAGE-07**: `src/pages/services/[slug].astro` generates the 6 service pages from the `services` content collection
- [ ] **PAGE-08**: `src/pages/[neighborhood]-barber.astro` generates the 5 neighborhood pages from the `neighborhoods` content collection

### AEO Schema + Structure

- [ ] **AEO-01**: `<HairSalonSchema />` component emits `LocalBusiness` + `HairSalon` JSON-LD from `business.ts`, embedded on every page
- [ ] **AEO-02**: `<FAQPageSchema />` component emits `FAQPage` JSON-LD from page FAQ data wherever FAQs appear
- [ ] **AEO-03**: `<ServiceSchema />` component emits `Service` JSON-LD on each service page from collection data
- [ ] **AEO-04**: `<PersonSchema />` component emits `Person` JSON-LD for Joe + Alex on `/about`
- [ ] **AEO-05**: Every page leads with a BLUF answer capsule in the first 100 words (declarative entity-first prose)
- [ ] **AEO-06**: Zero tabs/accordions — all FAQ content is flat HTML
- [ ] **AEO-07**: No text-as-image for headlines, services, hours, FAQ questions
- [ ] **AEO-08**: H2/H3 sections written as self-contained answer capsules (sampled review, not exhaustively measured)
- [ ] **AEO-09**: `sameAs` JSON-LD links to GBP, Yelp, IG, FB (Booksy + Wikidata Q-number deferred)

### Performance + Responsive

- [ ] **PERF-01**: Mobile responsive parity with OD-5 (breakpoints at 980px and 600px)
- [ ] **PERF-02**: Lighthouse mobile audit on homepage shows Performance ≥ 90, Accessibility ≥ 95, SEO ≥ 95
- [ ] **PERF-03**: Hero image uses `fetchpriority="high"`; below-fold images use `loading="lazy"`
- [ ] **PERF-04**: LCP < 2.5s and CLS < 0.1 on homepage (mobile)

### Meta + Sitemap

- [ ] **META-01**: Auto-generated `sitemap.xml` covers all 17–19 pages
- [ ] **META-02**: Every page has unique `<title>` and `<meta name="description">` aligned with its primary query
- [ ] **META-03**: Open Graph + Twitter Card meta tags on every page
- [ ] **META-04**: `robots.txt` allows all crawlers, references sitemap

### Deploy

- [ ] **DPLY-01**: `npm run build` succeeds without errors
- [ ] **DPLY-02**: Deployed to a Vercel preview URL
- [ ] **DPLY-03**: All 17–19 routes return 200 (no broken internal links)

### Showcase

- [ ] **SHOW-01**: Joe receives the Vercel preview URL and gives sign-off — the gating event that moves v1 → Validated

## v2 Requirements

Deferred — addressed after Joe approves and v1 ships.

### Off-site Reinforcement

- **OFFS-01**: Wikidata Q-number registered for Joe's Barbershop LLC; `sameAs` updated
- **OFFS-02**: Booksy listing created; `sameAs` updated
- **OFFS-03**: Foursquare listing claimed; NAP synced
- **OFFS-04**: Bing Places listing claimed; NAP synced
- **OFFS-05**: Reddit organic presence in r/sandiego / r/eastcountysd
- **OFFS-06**: Medium mirror of `/2026-east-county-barbershop-cost-guide`

### Cutover

- **CUT-01**: Custom domain registered (e.g., `joesbarbershopelcajon.com`)
- **CUT-02**: Site migrated from Vercel preview URL to custom domain
- **CUT-03**: GBP website link updated to new domain
- **CUT-04**: Square Site retained for booking widget or deprecated per Joe's preference

### Measurement

- **MEAS-01**: Prompt-panel established (5 baseline + 5 long-tail queries × 3 LLMs)
- **MEAS-02**: 30-day re-test
- **MEAS-03**: 60-day re-test
- **MEAS-04**: 90-day re-test (target: 6+ new query appearances per Toronto plumber benchmark)

## Out of Scope

| Feature | Reason |
|---------|--------|
| Square Site replacement | Showcase-first model — Joe approves before any cutover |
| Custom domain | Vercel preview URL sufficient until Joe approves; deferred to v1.5 |
| Paid CMS / admin UI | Joe doesn't edit the site; updates flow through the repo |
| Booking system replacement | Square booking widget is fine; replacing it would alienate Joe's existing customers |
| In-shop photo shoot | Six existing photos sufficient for v1; new photos require Joe's permission and a visit |
| OD iteration on additional pages | Templated pages are coded in Astro from data; OD reserved for unique designs only |
| Tailwind migration | Preserves OD-5 design; lower migration risk |
| Off-site reinforcement (Wikidata, Foursquare, Bing, Booksy, Reddit, Medium) | Doesn't block this site's deployment; tracked as v2 |
| Strategy / audit / playbook / methodology content | Lives in the vault — repo is the deployable, not the knowledge base |
| Spanish localization | English brand voice carries the working-class tone for the bilingual audience; not v1 |
| Analytics dashboard | Optional and trivial to add later (Plausible / GA4); not blocking |

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| SCAF-01 | Phase 1 | Pending |
| SCAF-02 | Phase 1 | Pending |
| SCAF-03 | Phase 1 | Pending |
| SCAF-04 | Phase 1 | Pending |
| SCAF-05 | Phase 1 | Pending |
| DATA-01 | Phase 2 | Pending |
| DATA-02 | Phase 2 | Pending |
| DATA-03 | Phase 2 | Pending |
| DATA-04 | Phase 2 | Pending |
| DESN-01 | Phase 2 | Pending |
| DESN-02 | Phase 2 | Pending |
| DESN-03 | Phase 2 | Pending |
| DESN-04 | Phase 2 | Pending |
| PAGE-01 | Phase 3 | Complete |
| PAGE-02 | Phase 3 | Complete |
| PAGE-03 | Phase 3 | Complete |
| PAGE-04 | Phase 3 | Complete |
| PAGE-05 | Phase 3 | Complete |
| PAGE-06 | Phase 3 | Pending |
| PAGE-07 | Phase 4 | Pending |
| PAGE-08 | Phase 4 | Pending |
| AEO-01 | Phase 5 | Pending |
| AEO-02 | Phase 5 | Pending |
| AEO-03 | Phase 5 | Pending |
| AEO-04 | Phase 5 | Pending |
| AEO-05 | Phase 5 | Pending |
| AEO-06 | Phase 5 | Pending |
| AEO-07 | Phase 5 | Pending |
| AEO-08 | Phase 5 | Pending |
| AEO-09 | Phase 5 | Pending |
| PERF-01 | Phase 5 | Pending |
| PERF-02 | Phase 5 | Pending |
| PERF-03 | Phase 5 | Pending |
| PERF-04 | Phase 5 | Pending |
| META-01 | Phase 5 | Pending |
| META-02 | Phase 5 | Pending |
| META-03 | Phase 5 | Pending |
| META-04 | Phase 5 | Pending |
| DPLY-01 | Phase 6 | Pending |
| DPLY-02 | Phase 6 | Pending |
| DPLY-03 | Phase 6 | Pending |
| SHOW-01 | Phase 6 | Pending |

**Coverage:**
- v1 requirements: 42 total
- Mapped to phases: 42 ✓
- Unmapped: 0

---
*Requirements defined: 2026-05-06*
*Last updated: 2026-04-29 after roadmap creation*
