# Phase 3: Unique Pages - Context

**Gathered:** 2026-05-07
**Status:** Ready for planning

<domain>
## Phase Boundary

Phase 3 ships the six hand-crafted, AEO-readable pages of Joe's Barbershop:

1. `/` (homepage) — PAGE-01 — pixel-parity with `mockups/home-v5/index.html` at desktop, 980px, 600px breakpoints, plus a populated FAQ block (5–6 Q&As) inside the existing FAQ component.
2. `/east-county-traditional-barbershop` — PAGE-02 — niche-query landing as an article: H1 + BLUF capsule + prose section + areaServed list with neighborhood links + 6 FAQ Q&As (flat H3/p) + ClosingCTA. No Hero photo.
3. `/2026-east-county-barbershop-cost-guide` — PAGE-03 — comparative listicle (Joe + 4–6 real East County competitors) with inline service/neighborhood links plus a 'See also' block, hitting all 6 service slugs and 5 neighborhood slugs.
4. `/about` — PAGE-04 — skill-drafted bios for Joe Denesowicz and Alex with placeholder portraits flagged for showcase resolution.
5. `/reviews` — PAGE-05 — pulled-quote highlights from Google + Yelp via Firecrawl (with placeholder fallback if extraction fails). AggregateRating schema is Phase 5; visible quote layout is here.
6. `/faq` — PAGE-06 — master FAQ with 10+ flat Q&As covering hours, walk-ins, cash-only, kids policy, parking, payment, ATM.

This phase ships the **visible HTML and prose content** for these 6 pages, consuming the 12 OD-5 components from Phase 2. It deliberately defers:

- All JSON-LD schema emission (HairSalon, FAQPage, Service, Person, Article, AggregateRating, sameAs) — Phase 5 (`AEO-01..09`).
- Lighthouse perf tuning (`PERF-01..04`), meta tags + Open Graph (`META-01..04`), `robots.txt` and sitemap polish — Phase 5.
- The 11 templated pages (6 services, 5 neighborhoods) — Phase 4 reads the same content collections and generates them.
- Live deployment / Joe sign-off — Phase 6 (`SHOW-01`).

Phase 4 routes do not yet exist when Phase 3 ships. Internal links from the cost guide and homepage to those routes are written using the canonical Phase 4 slugs (`/fades`, `/bostonia-barber`, etc.); they 404 in Phase 3 builds and resolve to 200 once Phase 4 lands. ROADMAP success criterion #3 ("no 404s from cost guide service/neighborhood links") is therefore validated end-to-Phase-4, not end-of-Phase-3.

</domain>

<decisions>
## Implementation Decisions

### Copy Authoring Workflow (PAGE-01..06 prose)

- **D-01:** The marketing-skills chain documented in Phase 2 D-16 is **active** for Phase 3. Three-skill chain runs:
  1. `marketing-skills:product-marketing-context` — runs **once** at Phase 3 start. Produces `.agents/product-marketing-context.md` capturing positioning, audience (East County working-class Latino + Anglo, 25–65, family-friendly, walk-ins, cash-only), tone (heritage / no-frills / Western-Victorian), anti-prompts (no Brooklyn-grooming-bro, no luxury-spa, no SaaS-coded), and brand context (Joe + Alex, ESTD. 2020, strip-mall storefront, 4.9★ ratings).
  2. `marketing-skills:ai-seo` — runs **once** at Phase 3 start to produce a global AEO frame document the copywriting skill consumes; **plus per-page primary-query injection** so each page's BLUF answers the page's specific primary query. Primary queries per page:
     - `/` → "barbershop in Bostonia / El Cajon / East County"
     - `/east-county-traditional-barbershop` → "traditional barbershop East County" (the niche-query AEO win this page locks in)
     - `/2026-east-county-barbershop-cost-guide` → "how much does a barbershop cost in East County / El Cajon 2026"
     - `/about` → "who owns Joe's Barbershop in El Cajon"
     - `/reviews` → "Joe's Barbershop reviews / ratings"
     - `/faq` → "Joe's Barbershop hours, payment, walk-ins, kids cuts"
  3. `marketing-skills:copywriting` — runs **per page** consuming the global frame + page-specific primary query + page-specific section requirements (BLUF, H2/H3 structure, FAQ count, areaServed list, etc.).
- **D-02:** **No manual review gate between skill output and commit.** Skills run, output gets written into the page's `.astro` file (or per-page `.md` content for sections that benefit from markdown), commit lands. User reviews on the deployed Vercel preview URL, not in the editor. **Rationale:** user explicitly chose speed/trust over per-page review touchpoints. **Implication:** skills must be configured carefully (D-03..05) — there is no second checkpoint to catch voice drift before commit.
- **D-03:** `product-marketing-context` source inputs: `inputs/00-brief.md` (audience + tone + visual cues + anti-prompts) **AND** `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` (audit baseline + sandbox experiment log + strategic depth). Skill must read both. **Rationale:** brief alone misses the strategic AEO depth (why this site exists, what queries it targets); audit baseline alone misses the visual / anti-prompt detail. The combined context is what produces voice consistent with both Joe's actual brand and Darrell's strategic intent.
- **D-04:** AEO frame (output of `marketing-skills:ai-seo`) must encode the load-bearing rules from `inputs/02-aeo-constraints.md`: BLUF first 100 words, 130–160 word answer capsules per H2/H3, declarative tone, no "we" without entity context, no tabs/accordions, FAQ flat H3/p, no text-as-image. Skill output stored where the copywriting skill can consume it (likely `.agents/aeo-frame.md`; planner picks exact path).
- **D-05:** Copy generated by the skill chain is committed atomically per page (one commit per `.astro` page write). Commits use the project's short-line convention. If a skill output is obviously wrong (factually incorrect, off-brand, hallucinated competitor data), executor flags it and asks user — does NOT commit broken output and silently proceed.

### About + Reviews Sourcing (PAGE-04, PAGE-05)

- **D-06:** `/about` (PAGE-04) ships with **skill-drafted bios** for Joe Denesowicz and Alex. Bios are generated by `marketing-skills:copywriting` using:
  - Joe: owner, established the shop in 2020, heritage-barbershop framing, Western/Victorian brand lineage, working-class East County positioning. Audit baseline is the source for any biographical specifics.
  - Alex: lead barber. Specifics minimal — bio is plausible-but-conservative until Joe confirms at showcase.
- **D-07:** Staff portrait images are **not available** (the 6 photos in `inputs/photos/` don't include Joe / Alex headshots). About page uses **placeholder portrait blocks** — initials cards or styled silhouettes, NOT stock photos. Each portrait carries a `data-pending-photo="joe"` / `data-pending-photo="alex"` marker so post-showcase swap-in is mechanical. Bios + photo-pending markers are added to `site/src/data/business.json`'s `_showcase_review_pending` array in the same pattern Phase 2 used for `prices.kidsCut` and `sameAs.gbp`.
- **D-08:** `/reviews` (PAGE-05) ships with **live-pulled review quotes from Google + Yelp public surfaces** using the `firecrawl` skill (or `firecrawl-scrape` / `firecrawl-extract` variant — planner picks based on what handles bot-detection best for these surfaces). Targets:
  - Google Maps reviews for "Joe's Barbershop, El Cajon, CA" (4.9★ / ~91 reviews per PROJECT.md)
  - Yelp page `joes-barbershop-el-cajon` (4.9★ / 33 reviews)
- **D-09:** Pull 6–8 5-star quotes total across both platforms. Each quote rendered with: reviewer first name + last initial as displayed publicly, star rating, source platform label (Google / Yelp), and date if available. Layout is review-card style; no schema in Phase 3 (Phase 5 wraps this with `Review` / `AggregateRating` JSON-LD).
- **D-10:** **Fallback path** if Firecrawl extraction fails or hits unrecoverable bot-detection: ship the page with **placeholder review-card components** populated with `[Reviewer name pending]` / `[Quote pending]` markers + a `_showcase_review_pending` entry in `business.json`. User indicated this fallback is acceptable while they figure out the extraction tooling. Layout, schema-readiness, and component shape stay identical between extracted and placeholder versions — only the content swaps.
- **D-11:** Permission / licensing: review quotes from public Yelp + Google surfaces with reviewer-first-name-last-initial attribution are within reasonable safe-harbor for "review highlights" use. Storefront photo `02-storefront.jpg` (`Alejandroam_photography` credit per `inputs/03-photo-notes.md`) attribution check from Phase 2 still applies — not Phase 3's problem unless `/about` reuses that photo.

### Cost Guide Format (PAGE-03)

- **D-12:** `/2026-east-county-barbershop-cost-guide` is a **comparative listicle**: Joe's Barbershop + 4–6 real East County competitors, structured as "Top barbershops in East County (2026) — prices, services, what makes each different." Format chosen for the documented 32.5% AI-citation lift on comparative content (per `aeo-playbook-smb.md`).
- **D-13:** Competitor data sourced via the **same Firecrawl path** used for reviews (D-08): scrape Google Maps + Yelp for top-rated barbershops within ~5 miles of `723 E Bradley Ave, El Cajon CA 92021`. Per-competitor data captured: business name, address, phone, hours (where listed), price range (from menu / board photos if visible), star rating + review count, one representative review quote, and one differentiating note (e.g., "appointment-only," "men's grooming lounge," "chain"). Joe is one of the 5–7 entries — not pre-eminent, but the entry returns "no-frills, walk-in, cash-only, $30 base, family-friendly" as differentiators.
- **D-14:** **Fallback path** if Firecrawl extraction yields fewer than 4 competitors with usable data: planner pivots to a **hybrid format** — 2–3 real competitor names that scraped successfully + 2–3 archetype entries ("the chain shop," "the men's grooming lounge," "the hole-in-the-wall") to round out the listicle. User pre-approved this contingency. The page still SHIPS — does not block on competitor data quality.
- **D-15:** Cross-link strategy: **inline mentions + dedicated 'See also' block at page bottom**. Inline as services / neighborhoods are naturally mentioned in body prose (e.g., "[Fades](/fades) at Joe's run $30, in line with East County market"). 'See also' block at page bottom enumerates all 6 services + 5 neighborhoods with anchor text. This belt-and-suspenders pattern guarantees ROADMAP success criterion #3 (all 11 cross-links present) without forcing unnatural inline insertion if a service / neighborhood doesn't fit the prose flow.
- **D-16:** Phase 3 cost guide writes links using the **canonical Phase 4 slugs** (`/fades`, `/kids-cuts`, `/beard-trim`, `/hot-towel-shave`, `/line-up`, `/classic-cut`, `/bostonia-barber`, `/el-cajon-barber`, `/santee-barber`, `/lakeside-barber`, `/la-mesa-barber`). Those routes 404 in a Phase 3 standalone build but resolve to 200 once Phase 4 lands. **The link strings are correct from day one** — Phase 4 does not have to retrofit them. ROADMAP success criterion #3 is interpreted as "no broken slugs" rather than "all slugs return 200 at Phase 3 build" because Phase 3 cannot satisfy the latter without making Phase 4's routes a Phase 3 dependency, which contradicts the ROADMAP's `Depends on: Phase 3` declaration for Phase 4.

### Page Composition Strategy

- **D-17:** Reuse pattern across the 5 non-homepage pages: **shared chrome + reusable atoms + bespoke body**.
  - Shared chrome (every page, via `Base.astro`): `UtilBar`, `Masthead`, `Footer`, `CheckDivider` between sections.
  - Reusable atoms across many pages: `FAQ` component (every page that has FAQs — niche-landing, cost guide, services-not-applicable-here-but-Phase-4, FAQ master, homepage), `ClosingCTA` (every page, bottom of body), `Visit` (only `/about` for the "find us" reinforcement), `SectionMark` (decorative section dividers where the layout calls for it).
  - **Homepage-specific** (do NOT reuse on other pages): `Hero` (hero photo + tuned hero copy), `FactStrip` (4-column NAP/hours/payment/rating row), `PriceBoard` (letter-board prices), `Heritage` (heritage angle prose). These are visual-language load-bearing for the homepage; reusing them on niche-landing / cost guide / FAQ / about / reviews would fight BLUF density and dilute the homepage's visual signature.
  - **Bespoke per page:** the body content (prose, headings, areaServed list, review cards, comparative listicle entries). Each page builds its own body markup using the OD-5 design tokens (oklch palette, font stack, spacing system) without forking the homepage components.
- **D-18:** Homepage (`site/src/pages/index.astro`) build approach: **pixel-parity port of the OD-5 mockup, plus a populated FAQ block**. Composition (in order):

  ```
  CheckDivider → Hero → FactStrip → CheckDivider → PriceBoard → Heritage
  → CheckDivider → Visit → FAQ (populated, 5-6 Q&As) → CheckDivider → ClosingCTA
  ```

  This matches `site/src/pages/dev-mockup-parity.astro` exactly except the FAQ block is filled with real questions instead of stub. ROADMAP success criterion #1 (pixel-parity at desktop / 980px / 600px) is the verification gate.
- **D-19:** The 5–6 homepage FAQ Q&As are a **subset** of the master `/faq` page's 10+ Q&As — chosen for highest-value-on-the-homepage topics: hours, walk-ins, cash-only, kids cuts, payment / ATM. Skill-generated; user does not pre-curate. Master `/faq` page contains these plus parking, services-offered, walk-in-vs-appointment, family-friendly, COVID-policy-or-similar, and 1–2 more.
- **D-20:** `dev-mockup-parity.astro` (Phase 2 scratch page) is **deleted** during Phase 3 once `index.astro` is verified to render identically. Verification: `npm run dev` + visual check at all 3 breakpoints. Removal commit happens after the verification commit.
- **D-21:** PAGE-02 (niche-query landing `/east-county-traditional-barbershop`) structure: **article-shaped, no Hero photo**. Composition (in order):

  ```
  Article header (H1 + dateModified) → BLUF capsule (~100 words)
  → Prose section ("What East County traditional barbering means")
  → areaServed list (5 neighborhoods, each with link to its Phase 4 route)
  → 6 FAQ Q&As (flat H3/p) → ClosingCTA
  ```

  The page is prose-and-citation-driven, not visual. Hero photo would fight BLUF density and dilute the AEO win this page locks in. The 5-neighborhood links use the same Phase 4 slug convention as D-16 (will 404 until Phase 4 ships).
- **D-22:** PAGE-04 (`/about`), PAGE-05 (`/reviews`), PAGE-06 (`/faq`) compositions are **planner discretion** within the constraints of D-17. Suggested skeletons (planner refines):
  - `/about`: header → BLUF → "Joe" section (portrait placeholder + bio) → "Alex" section (portrait placeholder + bio) → Visit block → ClosingCTA.
  - `/reviews`: header → BLUF (e.g., "Joe's Barbershop is rated 4.9★ across 124 Google + Yelp reviews") → review-card grid (6–8 cards, mixed Google + Yelp) → ClosingCTA.
  - `/faq`: header → BLUF → FAQ component scaled up to 10+ Q&As (or repeated FAQ blocks grouped by topic) → ClosingCTA.

### Claude's Discretion

- Exact prose phrasing in skill-generated copy — skills produce, executor commits.
- Whether to introduce a new `<UniquePageLayout>` wrapper that sits between `Base.astro` and individual pages, vs each page composing directly under `Base.astro`. Recommend the latter (one-Base-many-pages) for now since the 5 non-homepage pages don't share enough scaffolding to justify a wrapper layer.
- Per-page metadata (title, description) wording — Phase 5 owns `META-01..04`; Phase 3 may set basic `<title>` for dev visibility but should not over-invest in meta because Phase 5 will rewrite.
- Skill output post-processing — if a skill produces markdown but the page wants direct `.astro` markup, executor converts. No manual review of the conversion (per D-02).
- Number of `H2`/`H3` sections per page beyond the minimums called out in decisions — skills produce what fits the AEO 130–160 word answer capsule rule.
- Specific competitor names included in the cost guide listicle — depends on Firecrawl scrape outputs (D-13).
- Internal link anchor text precise wording — skills produce; executor commits.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase 3 Inputs

- `inputs/00-brief.md` — audience + tone + visual cues + anti-prompts. **Source for `marketing-skills:product-marketing-context`** (D-03).
- `inputs/01-page-list.md` — the 17–19 page architecture, schema priority per page, template strategy. **Defines per-page structural requirements (especially niche-query landing's areaServed and FAQ count, cost guide's comparative-listicle format).**
- `inputs/02-aeo-constraints.md` — load-bearing AEO rules. **Source for `marketing-skills:ai-seo` global frame** (D-04). MUST be encoded into the AEO frame document.
- `inputs/03-photo-notes.md` — what each of the 6 photos shows, attribution, primary use per page. **Defines which photo each page references.**
- `mockups/home-v5/index.html` (md5 `75e4749bbe4c9e2d4993bfa6744d3cdc`) — OD-5 mockup, pixel-parity target for `/`. Phase 2 D-01..D-02 lock its provenance.

### Phase 2 Carry-Forward (REQUIRED before planning)

- `.planning/phases/02-data-design-system/02-CONTEXT.md` — full Phase 2 decisions, especially:
  - **D-16** — marketing-skills chain blueprint (Phase 3 elaborates this in current D-01..05).
  - **D-26** — `<slot name="head" />` reserved for Phase 5 schema injection. Phase 3 does NOT inject schema.
  - **D-25** — section ordering in `Base.astro` is locked: `UtilBar → Masthead → main(slot) → Footer`.
  - **D-22..24** — content collection schemas and the `services` / `neighborhoods` slug conventions Phase 3 cost guide links to.
- `.planning/phases/02-data-design-system/02-PLAN-*.md` (all 7 plans) — context for which components ship and how.
- `.planning/phases/02-data-design-system/02-VERIFICATION.md` — Phase 2 verification report; confirms what's stable before Phase 3 builds on it.

### Project-Level Decisions

- `.planning/PROJECT.md` § Constraints — tech stack lock (Astro, no Tailwind), photo set limit (6), AEO structural rules, no-live-deployment-before-Joe-approves.
- `.planning/PROJECT.md` § Key Decisions — Astro / Vercel / OD CSS / schema-from-business.ts / showcase-first model.
- `.planning/REQUIREMENTS.md` § Pages — Unique — PAGE-01..06 literal text. **Source of truth for what each page must contain.**
- `.planning/ROADMAP.md` § Phase 3 — goal, depends-on (Phase 2), success criteria #1–#4. **Acceptance gate.**

### Vault References (knowledge base — DO NOT duplicate into repo)

- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — audit baseline + sandbox log. **Source for `product-marketing-context`** (D-03). Strategic depth: why this site exists, what AEO queries it targets, audience nuance beyond the brief.
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` — AEO mechanics, comparative-listicle 32.5%-citation-lift evidence (informs PAGE-03 format choice, D-12).
- `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-visual-direction.md` — strategic visual narrative (informs voice + heritage framing for skill-generated copy).
- `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` — master voice reference (consulted IF skill output drifts from Darrell's expected voice; D-02's no-review-gate makes this less load-bearing in Phase 3 but still relevant).
- `~/Documents/DT Vault/3-resources/writing-style-guide-anti-ai-voice.md` — banned words/phrases, anti-AI patterns. Skill chain should respect these.

### Live Repo State (Phase 2 outputs Phase 3 consumes)

- `site/src/components/*.astro` — 12 OD-5 components: `UtilBar`, `Masthead`, `Hero`, `FactStrip`, `PriceBoard`, `Heritage`, `Visit`, `FAQ`, `ClosingCTA`, `Footer`, `CheckDivider`, `SectionMark`. **Phase 3 reuse rules in D-17.**
- `site/src/layouts/Base.astro` — shared HTML shell with locked section ordering and `<slot name="head" />` reserved for Phase 5.
- `site/src/data/business.json` + `site/src/data/business.ts` — canonical NAP / hours / prices / ratings / sameAs / photos / areaServed. **Every page imports from here.**
- `site/src/pages/dev-mockup-parity.astro` — Phase 2 scratch page demonstrating homepage component composition. **Phase 3 deletes this** (D-20) once `index.astro` is verified.
- `site/src/pages/index.astro`, `site/src/pages/about.astro` — Phase 1 placeholder pages. Phase 3 fully rewrites both.
- `site/src/styles/tokens.css` + `site/src/styles/utilities.css` — global design tokens + shared atoms. Imported once in `Base.astro`. New page-specific styles live in scoped `<style>` blocks per page.
- `site/src/content/services/*.md` (6 files) and `site/src/content/neighborhoods/*.md` (5 files) — schema-passing stubs from Phase 2. **Phase 3 does NOT consume these directly** — they are Phase 4's input. Cost guide cross-links use the slugs (`fades`, `bostonia`, etc.) but Phase 3 does not read the markdown bodies.
- `site/src/assets/photos/` (6 photos) — `01-logo.jpg`, `02-storefront.jpg`, `03-interior-hero.jpg`, `04-heritage-chair.jpg`, `05-mid-cut.jpg`, `06-price-board-cash-only.jpg`. Phase 3 references these in component imports; new photo references for `/about` are deferred (D-07 placeholders).

### External Tools (executor invokes)

- `marketing-skills:product-marketing-context` — runs once at Phase 3 start (D-01).
- `marketing-skills:ai-seo` — runs once at Phase 3 start (D-01, D-04).
- `marketing-skills:copywriting` — runs per page (D-01).
- `firecrawl` (or `firecrawl-scrape` / `firecrawl-extract`) — for `/reviews` quote extraction (D-08) and cost guide competitor data (D-13). Planner picks the variant best suited for Google Maps + Yelp bot-detection.

### Astro / Tooling Docs

- Astro 6 docs — page routing under `src/pages/*.astro`, `<Image />` / `<Picture />` for photos, scoped `<style>` patterns. (Researcher reads these only as needed; nothing new vs Phase 2.)

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets

- **The 12 Phase 2 components** under `site/src/components/`. Phase 3 reuse rules per D-17:
  - **Shared chrome** (every page, already wired in `Base.astro`): `UtilBar`, `Masthead`, `Footer`.
  - **Reusable atoms** (multiple pages): `FAQ`, `ClosingCTA`, `Visit`, `CheckDivider`, `SectionMark`.
  - **Homepage-only**: `Hero`, `FactStrip`, `PriceBoard`, `Heritage`. Do NOT reuse these on other unique pages.
- **`site/src/layouts/Base.astro`**: shared HTML shell with locked section ordering and named `<slot name="head" />` reserved for Phase 5 schema injection. Phase 3 imports `Base` on every new page; does not modify it.
- **`site/src/pages/dev-mockup-parity.astro`**: demonstrates the OD-5 homepage composition. **Phase 3 deletes** after `index.astro` is verified parity-correct (D-20). Treat it as a build-and-throw-away reference.
- **`site/src/data/business.json`** + **`business.ts`**: canonical NAP source. Every page imports `business` and renders `business.address.street`, `business.phone`, `business.prices.haircut`, etc. directly in markup. Pattern established in Phase 2's `Hero.astro`.
- **`site/src/styles/tokens.css`** + **`utilities.css`**: global design tokens + shared atoms (`.wrap`, `.eyebrow`, `.kicker-rule`, `.display`, `.check-divider`, `.section-mark`, `.section-head`, `.btn`). Already imported in `Base.astro`. Phase 3 pages style with `<style>` blocks scoped per page consuming these tokens / atoms.
- **6 photos** in `site/src/assets/photos/` accessible via `import photoPath from '../assets/photos/03-interior-hero.jpg'` then `<Image src={photoPath} />` or `<Picture>` for hero.

### Established Patterns

- **Section ordering** (locked from Phase 1): `UtilBar → Masthead → main(slot) → Footer` in `Base.astro`. Phase 3 pages slot their body into `<main>` via `Base`.
- **Per-component scoped CSS** (Phase 2 D-06): each `.astro` file's `<style>` block scopes rules to that component automatically. Page-level pages follow the same pattern.
- **Astro `<Image />` / `<Picture>` for photos**: hero in `Hero.astro` uses `<Picture formats={['avif','webp']}>` + `loading="eager"` + `fetchpriority="high"`. Other photos use `<Image />` + `loading="lazy"`. Phase 5 verifies these survive into the build (`PERF-03`).
- **No `client:*` directives** anywhere. Zero-JS DOM is an AEO requirement. Phase 3 pages stay static.
- **`data-pending-photo` markers** (new pattern, established here): used on `/about` for placeholder portraits awaiting Joe's photos. Mirrors Phase 2's `data-phase1-stub` removal pattern — Phase 3-or-later phase scans for these markers and swaps in real assets.

### Integration Points

- **Page → Base layout**: every page's frontmatter starts with `import Base from '../layouts/Base.astro';` then wraps body in `<Base title="..." description="...">...</Base>`.
- **Page → business data**: `import { business } from '../data/business';` at the top of any page using NAP / hours / prices / ratings.
- **Page → photos**: `import heroPhoto from '../assets/photos/03-interior-hero.jpg';` then `<Picture src={heroPhoto} ... />` or `<Image src={heroPhoto} ... />`.
- **Page → reusable component**: `import FAQ from '../components/FAQ.astro';` then `<FAQ items={...} />` (component prop API set in Phase 2).
- **Page-level meta tags**: pass `title` + `description` to `Base`. Full meta tag suite (`META-01..04`) is Phase 5; Phase 3 only sets `title` + `description` for dev visibility.
- **Phase 5 schema injection**: pages will eventually pass JSON-LD into `Base`'s `<slot name="head" />`. Phase 3 leaves the slot unused.
- **Phase 4 internal linking**: cost guide and homepage write links to `/fades`, `/bostonia-barber`, etc. using the canonical slugs. Those routes 404 in Phase 3 builds; resolve to 200 once Phase 4 lands.

</code_context>

<specifics>
## Specific Ideas

- **Voice anchor for skill-generated copy:** working-class East County, heritage barbershop, no-frills, family-friendly, walk-ins-welcome, cash-only-as-positioning. Avoid "we might / could / experience / discover" verbs. Avoid the "we're more than a barbershop, we're a community" generic open (explicitly listed as an anti-pattern in `inputs/02-aeo-constraints.md` § Anti-patterns).
- **The `/east-county-traditional-barbershop` page is locking in an *accidental* AEO win** that's been observed on the current Square Site state. Treat the niche-query as load-bearing and the page's BLUF + FAQ as the prose that needs to be highest-quality of the 6 unique pages. If the skill chain produces drift here, this is the one page worth re-running with tighter inputs.
- **The cost guide's "$30 base" positioning is Joe's actual differentiator** — most East County barbershops are $25–$45; Joe's at $30 with full traditional services (haircut, shave, beard, line-up) is the working-class-quality value prop. Skill chain should anchor on this.
- **The 6 photos are byte-stable** from Phase 2 (D-13 — filenames preserved). Phase 3 doesn't add new photos; portrait placeholders for `/about` are CSS / SVG, not bitmap.
- **Skill chain runs in execution, not in research.** Researcher does not invoke the marketing-skills chain. Researcher's job is to read the AEO inputs + competitor signals (if any are scrapeable pre-execution) and surface them. The chain runs during plan execution.
- **Firecrawl retry budget** for the reviews and cost-guide scrapes: bound the number of retries so a stuck scrape doesn't block the whole phase. After N attempts (planner picks N; suggest 3 per surface), fall back to D-10 / D-14 paths and proceed. **Bot detection on Google Maps in particular is unreliable** — assume it might fail and have the fallback wired.
- **Skill output consistency** across the 6 pages depends on the global frame (D-04). If pages 4, 5, 6 read off-voice from pages 1, 2, 3, the global frame is the place to fix it — not per-page tweaking.
- **`marketing-skills:product-marketing-context` writes `.agents/product-marketing-context.md`** (the standard location for that skill). Verify the file lands there; downstream copywriting invocations read it from that path automatically.

</specifics>

<deferred>
## Deferred Ideas

- **JSON-LD schema emission on all 6 unique pages** — Phase 5 (`AEO-01..09`). Phase 3 builds the visible content compatibly (review cards have name/rating/source/date data ready for `Review` schema; FAQ blocks are flat H3/p ready for `FAQPage` schema; about page has Joe + Alex names ready for `Person` schema). Phase 5 wraps with `<script type="application/ld+json">` blocks injected into `Base`'s `<slot name="head" />`.
- **Lighthouse perf tuning + `META-01..04`** — Phase 5. Phase 3 sets `title` + `description` for dev visibility only; Phase 5 owns the full meta suite, Open Graph, Twitter Card, robots.txt, sitemap.xml.
- **Templated services + neighborhoods routes** — Phase 4 (`PAGE-07`, `PAGE-08`). Phase 3 cost guide links to those slugs in advance.
- **Real Joe + Alex portrait photography** — pending Joe's permission + an in-shop visit (per `inputs/03-photo-notes.md` § "Photos still to capture"). Markup-level placeholder lands here; photo swap is post-Phase-3, likely at showcase or post-showcase.
- **Mid-page section ratings widget on the homepage** (e.g., a "4.9★ across 91 Google reviews" ribbon above the FAQ) — out of scope for pixel-parity port. Could land in a future homepage iteration if Joe wants ratings emphasized.
- **Featured-services strip on homepage with links to Phase 4 routes** — considered and rejected (D-18 favors mockup parity). Could be revisited in Phase 5+ as an internal-linking strengthening pass.
- **Per-service "Joe's [Service] page" hero treatment** — Phase 4 territory.
- **Per-neighborhood landmarks + neighborhood-specific FAQs** — Phase 4 territory.
- **Voice guides as a hard dependency** for the skill chain — currently advisory (D-03 includes vault audit baseline + brief, not voice guides). If post-Phase-3 review reveals voice drift, escalate by adding `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` + `writing-style-guide-anti-ai-voice.md` as additional `product-marketing-context` inputs.
- **Cost guide secondary distribution** (Medium mirror per `OFFS-06`) — v2.
- **Booksy + Wikidata sameAs additions** — v2 (`OFFS-01`, `OFFS-02`). Phase 3 reviews page ratings layout already accommodates additional source platforms if added later.
- **Square Site cutover / GBP website-link update** — Phase 6 + post-showcase. Phase 3 ships to Vercel preview only.

</deferred>

---

*Phase: 3-Unique Pages*
*Context gathered: 2026-05-07*
