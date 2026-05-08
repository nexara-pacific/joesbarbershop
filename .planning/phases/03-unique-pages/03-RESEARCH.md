# Phase 3: Unique Pages - Research

**Researched:** 2026-05-07
**Domain:** Astro 6 page authoring + AEO content generation via marketing-skills chain + Firecrawl-driven competitor / review extraction
**Confidence:** HIGH (all decisions are upstream-locked; research validated tool contracts and surfaced concrete invocation patterns)

## Summary

Phase 3 ships six hand-crafted Astro pages that consume the 12 OD-5 components from Phase 2 and the canonical `business.ts` data layer. The user's CONTEXT.md (D-01..D-22) and UI-SPEC pre-decide stack, composition, voice anchors, accent reservations, and breakpoint targets. Research focused on three open implementation questions: (1) the marketing-skills chain invocation contract — confirmed three skills live in `~/.claude/plugins/marketplaces/marketingskills/skills/{product-marketing-context,ai-seo,copywriting}` and follow a documented `.agents/product-marketing-context.md` handoff convention; (2) Firecrawl variant selection for `/reviews` and the cost guide — `firecrawl scrape` with `--only-main-content` is the right primary path (CLI v1.12.2 installed, 4,355 credits available, 5-job concurrency); (3) Astro 6 page-level patterns — `<Picture>` for hero, `<Image>` for everything else, scoped `<style>` blocks, named `<slot name="head" />` reserved for Phase 5 schema injection, no special handling needed for in-Phase 4 cross-links 404'ing during Phase 3 builds.

The single biggest planner consideration is **commit cadence** (D-05: "one commit per page write") interacting with **failure paths** (D-10/D-14: Firecrawl extraction may fail → ship placeholder cards instead). The planner should structure Phase 3 as **per-page units of work** with each page's commit gated on either successful extraction OR clean placeholder fallback — never blocked on retry loops. Firecrawl scrape outputs land in `.firecrawl/` (not in git), and the executor extracts quotes/competitors into the page markup directly.

**Primary recommendation:** Plan Phase 3 as 1 setup wave (skills + AEO frame) + 6 page-build waves (one per unique page) with Firecrawl scrape as a pre-step for `/reviews` and `/cost-guide` only. Target ~9-11 plans total: 1 skill-setup, 1 reviews-scrape, 1 competitors-scrape, 6 page-builds (one per page), 1 dev-mockup-parity deletion, 1 verification.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

#### Copy Authoring Workflow (PAGE-01..06 prose)

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

#### About + Reviews Sourcing (PAGE-04, PAGE-05)

- **D-06:** `/about` (PAGE-04) ships with **skill-drafted bios** for Joe Denesowicz and Alex.
- **D-07:** Staff portrait images are **not available**. About page uses **placeholder portrait blocks** — initials cards or styled silhouettes, NOT stock photos. Each portrait carries a `data-pending-photo="joe"` / `data-pending-photo="alex"` marker. Bios + photo-pending markers are added to `business.json`'s `_showcase_review_pending` array.
- **D-08:** `/reviews` (PAGE-05) ships with **live-pulled review quotes from Google + Yelp public surfaces** using the `firecrawl` skill (or `firecrawl-scrape` / `firecrawl-extract` variant — planner picks based on what handles bot-detection best).
- **D-09:** Pull 6–8 5-star quotes total across both platforms. Each quote rendered with: reviewer first name + last initial, star rating, source platform label (Google / Yelp), and date if available. No schema in Phase 3.
- **D-10:** **Fallback path** if Firecrawl extraction fails or hits unrecoverable bot-detection: ship the page with **placeholder review-card components** populated with `[Reviewer name pending]` / `[Quote pending]` markers + a `_showcase_review_pending` entry in `business.json`.
- **D-11:** Review quotes from public Yelp + Google with reviewer-first-name-last-initial attribution are within reasonable safe-harbor for "review highlights" use.

#### Cost Guide Format (PAGE-03)

- **D-12:** `/2026-east-county-barbershop-cost-guide` is a **comparative listicle** (Joe + 4–6 East County competitors), 32.5% AI-citation lift on comparative content.
- **D-13:** Competitor data sourced via Firecrawl (Google Maps + Yelp), top-rated barbershops within ~5 miles of `723 E Bradley Ave`. Per-competitor: name, address, phone, hours, price range, star rating + review count, one quote, one differentiator.
- **D-14:** **Fallback** if <4 competitors scrape: hybrid (2–3 real + 2–3 archetype: "the chain shop," "the men's grooming lounge," "the hole-in-the-wall").
- **D-15:** Cross-link strategy: **inline mentions + dedicated 'See also' block** at page bottom enumerating all 6 services + 5 neighborhoods.
- **D-16:** Phase 3 cost guide writes links using **canonical Phase 4 slugs** (`/fades`, `/bostonia-barber`, etc.). Those routes 404 in Phase 3 build but resolve to 200 once Phase 4 lands.

#### Page Composition Strategy

- **D-17:** Reuse pattern: shared chrome (`UtilBar`, `Masthead`, `Footer`, `CheckDivider` via `Base.astro`) + reusable atoms (`FAQ`, `ClosingCTA`, `Visit`, `SectionMark`) + bespoke body. **Homepage-only:** `Hero`, `FactStrip`, `PriceBoard`, `Heritage`. Do NOT reuse on other pages.
- **D-18:** Homepage composition: `CheckDivider → Hero → FactStrip → CheckDivider → PriceBoard → Heritage → CheckDivider → Visit → FAQ (populated, 5–6 Q&As) → CheckDivider → ClosingCTA`. ROADMAP success criterion #1 (pixel-parity at desktop / 980px / 600px) is the verification gate.
- **D-19:** Homepage FAQ Q&As are a **subset** of master `/faq` page's 10+ Q&As. Skill-generated.
- **D-20:** `dev-mockup-parity.astro` is **deleted** during Phase 3 once `index.astro` is verified to render identically. Verification: `npm run dev` + visual check at all 3 breakpoints. Removal commit happens after verification commit.
- **D-21:** PAGE-02 (niche-landing) structure: **article-shaped, no Hero photo**. Composition: `Article header → BLUF capsule → Prose section → areaServed list → 6 FAQ Q&As → ClosingCTA`. The 5-neighborhood links use the same Phase 4 slug convention as D-16.
- **D-22:** PAGE-04, PAGE-05, PAGE-06 compositions are **planner discretion** within D-17. Suggested skeletons:
  - `/about`: header → BLUF → Joe section (portrait placeholder + bio) → Alex section (same) → Visit block → ClosingCTA.
  - `/reviews`: header → BLUF (e.g., "Joe's Barbershop is rated 4.9★ across 124 Google + Yelp reviews") → review-card grid (6–8 cards, Google + Yelp mix) → ClosingCTA.
  - `/faq`: header → BLUF → FAQ component scaled up to 10+ Q&As (or repeated FAQ blocks grouped by topic) → ClosingCTA.

### Claude's Discretion

- Exact prose phrasing in skill-generated copy — skills produce, executor commits.
- Whether to introduce a new `<UniquePageLayout>` wrapper (recommend: no — one-Base-many-pages for now; only 5 non-homepage pages and they don't share enough scaffolding).
- Per-page metadata wording — Phase 5 owns `META-01..04`; Phase 3 sets basic `<title>` + `<description>` for dev visibility, no over-investment.
- Skill output post-processing — markdown → `.astro` conversion happens without manual review.
- Number of `H2`/`H3` sections per page beyond minimums — skills produce what fits the AEO 130–160 word capsule rule.
- Specific competitor names included in cost guide listicle — depends on Firecrawl outputs.
- Internal link anchor text precise wording — skills produce.

### Deferred Ideas (OUT OF SCOPE)

- **JSON-LD schema emission** on all 6 unique pages — Phase 5 (`AEO-01..09`).
- **Lighthouse perf tuning + `META-01..04`** — Phase 5.
- **Templated services + neighborhoods routes** — Phase 4 (`PAGE-07`, `PAGE-08`).
- **Real Joe + Alex portrait photography** — pending Joe's permission + in-shop visit.
- **Mid-page section ratings widget on homepage** — out of scope.
- **Featured-services strip on homepage with links to Phase 4 routes** — rejected (D-18 favors mockup parity).
- **Per-service "Joe's [Service] page" hero treatment** — Phase 4.
- **Per-neighborhood landmarks + neighborhood-specific FAQs** — Phase 4.
- **Voice guides as a hard dependency** for the skill chain — currently advisory.
- **Cost guide secondary distribution** (Medium mirror) — v2.
- **Booksy + Wikidata sameAs additions** — v2.
- **Square Site cutover / GBP website-link update** — Phase 6 + post-showcase.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| PAGE-01 | `/` (homepage) renders parity with `mockups/home-v5/index.html` using shared components | Pixel-parity port via D-18 composition; existing `dev-mockup-parity.astro` is the working template; 12 components already wired and verified in Phase 2 (4/5 truths VERIFIED, 1 awaiting human visual sign-off) |
| PAGE-02 | `/east-county-traditional-barbershop` niche-query landing — FAQPage schema (deferred to Phase 5); areaServed list; 6 niche-specific FAQ Q&As | UI-SPEC `## Article Header` + `## AreaServed List` provide visual contracts; D-21 locks article-shaped structure; copywriting skill produces BLUF + 6 FAQs + areaServed prose with primary query "traditional barbershop East County" |
| PAGE-03 | `/2026-east-county-barbershop-cost-guide` comparative listicle with cross-links to all 6 service pages + 5 neighborhood pages | UI-SPEC `## Cost Guide Entry Card` + `## See-Also Block` provide visual contracts; D-12..16 lock format; Firecrawl scrape provides 4–6 competitor entries (with archetype fallback per D-14); See-Also block guarantees all 11 cross-links present (D-15) |
| PAGE-04 | `/about` with Person schema (deferred to Phase 5) | UI-SPEC `## About Page Portrait Placeholder` provides CSS pattern; D-06/D-07 lock skill-drafted bios + initials placeholders; `data-pending-photo` markers for post-showcase swap |
| PAGE-05 | `/reviews` with AggregateRating schema (deferred to Phase 5) and quote highlights from public Google + Yelp reviews | UI-SPEC `## Review Card` provides visual contract; D-08..11 lock Firecrawl scrape path; D-10 fallback path for placeholder cards if extraction fails; `firecrawl scrape --only-main-content` is right primary tool variant |
| PAGE-06 | `/faq` master FAQ with FAQPage schema (deferred to Phase 5) (10+ Q&As) | UI-SPEC `## FAQ Master Page Layout` provides scaling pattern; D-19 specifies homepage FAQ is subset of master; topic-group H2 headings every 3–4 questions |
</phase_requirements>

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Page rendering (6 unique pages) | CDN / Static (Astro SSG output) | — | Phase 1 + Phase 2 wired Astro for static output via Vercel adapter. No SSR, no client JS. AEO requires zero-JS DOM. |
| Markup composition (per-page bespoke body + reusable atoms) | Astro Frontmatter (build-time) | — | All composition is `.astro` template logic at build time; no runtime composition. |
| Data binding (NAP, ratings, prices) | Build-time via `business.ts` import | — | `business` is imported as a typed constant, fields resolve at build via Vite. |
| AEO copy generation (BLUF, FAQs, areaServed prose, cost guide entries, bios) | Local agent execution (marketing-skills chain) | — | Skills run during plan execution; outputs are written to `.astro` files OR intermediate markdown that the executor converts. Not a runtime concern. |
| Review extraction (Google Maps + Yelp public reviews) | Local CLI tool (Firecrawl) | — | `firecrawl scrape` runs during plan execution; outputs land in `.firecrawl/` (gitignored); executor extracts quotes into page markup. Not a runtime concern. |
| Competitor extraction (4–6 East County barbershops) | Local CLI tool (Firecrawl) | — | Same flow as reviews; output extracted into cost guide entry cards at build-time. |
| Image rendering (5 photos referenced; about page uses CSS placeholder) | CDN / Static (Astro `<Image>` / `<Picture>`) | — | Phase 2 verified Astro Image pipeline emits hashed AVIF/WebP variants; Phase 3 doesn't add new photos but references existing 5 (storefront on /about Visit, hero on /, others not used in Phase 3 unique pages). |
| Cross-link routing (Phase 4 slugs that 404 in Phase 3 builds) | Static routing (Astro file-based) | — | Static pages link to `/fades`, `/bostonia-barber`, etc. Astro generates 404s for missing routes; build does not fail. ROADMAP success criterion #3 ("no 404s from cost guide links") is end-of-Phase-4, not Phase-3. |

## Standard Stack

### Core (already installed and verified in Phase 2)

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `astro` | 6.3.0 | Static site framework | [VERIFIED: site/package.json + npm list] Already installed; Phase 1 + 2 verified `npm run build` exits 0. Phase 3 adds pages, no framework upgrade. |
| `@astrojs/sitemap` | 3.7.2 | Auto-discovers built routes for sitemap.xml | [VERIFIED: site/package.json] Already installed; Phase 5 owns full sitemap polish but the integration runs on every build automatically. |
| `@astrojs/vercel` | 10.0.6 | Vercel adapter | [VERIFIED: site/package.json] Already installed; static output. |
| `@astrojs/check` | 0.9.9 | TypeScript checker | [VERIFIED: site/package.json] Already installed; ensures `business.ts` imports stay typed. |
| `typescript` | 6.0.3 | Strict TS | [VERIFIED: site/package.json] Strict mode enforced from Phase 1. |

### Supporting (already available)

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| `firecrawl` CLI | 1.12.2 | Web scraping for review + competitor extraction | [VERIFIED: `firecrawl --status` returned authenticated; 4,355 / 5,000 credits remaining; concurrency 0/5] Used per D-08, D-13. |
| `marketing-skills` plugin | n/a (latest) | product-marketing-context, ai-seo, copywriting skill chain | [VERIFIED: located at `/Users/darrelltang/.claude/plugins/marketplaces/marketingskills/skills/{product-marketing-context,ai-seo,copywriting}/SKILL.md`] Plugin is installed; skills are invocable via the standard `/skill-name` slash-command pattern. |
| Node.js | 25.9.0 | Runtime for build | [VERIFIED: `node --version`] Exceeds package.json `engines.node >=22.12.0`. |
| npm | 11.12.1 | Package manager | [VERIFIED: `npm --version`] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff | Recommendation |
|------------|-----------|----------|----------------|
| `firecrawl scrape` | `firecrawl agent --schema` | Agent navigates multi-page autonomously and returns structured JSON; takes 2–5 min per run; consumes more credits | **Use `scrape` first** for both reviews and competitors. Each Yelp/Google Maps URL is a single page; structured extraction can be done by reading the markdown ourselves with grep/jq. Agent is overkill at Phase 3 budget. Escalate to agent only if scrape gets bot-blocked. |
| `firecrawl scrape` | `firecrawl interact` (formerly `browser`) | Lets us click "Show more reviews" on Yelp, paginate, etc. | **Avoid unless scrape fails.** SKILL.md explicitly says "Try scrape before interact." For 6–8 quotes we don't need pagination — first page has enough 5★ reviews. |
| `firecrawl scrape` | `firecrawl search --scrape` | One-shot search + scrape | **Use `search --scrape` for competitor discovery** (D-13: "top-rated barbershops within ~5 miles") since we don't have specific URLs yet. Then scrape each result page individually for richer data. |
| Astro Image `<Image>` for portrait placeholder | CSS-only div | UI-SPEC mandates CSS-only (D-07: "NOT bitmap, NOT stock photo") | **CSS-only.** UI-SPEC defines exact pattern. Real `<Image>` swap is post-Phase-3. |
| Inline data in `.astro` for cost guide entries | `data/competitors.json` | Inline keeps everything visible in one file; JSON allows reuse | **Use inline in `.astro`** — see Pattern 4 below. The data is page-specific; abstracting to JSON adds an indirection without payoff. |
| Inline review data in `/reviews.astro` | `data/reviews.json` | Same tradeoff | **Use inline in `.astro`.** Same reasoning. |

**Installation:** No new packages needed. All required tooling is already installed.

**Version verification:**

```bash
cd site && npm list astro @astrojs/sitemap @astrojs/vercel @astrojs/check typescript
# Output (verified 2026-05-07):
# astro@6.3.0
# @astrojs/sitemap@3.7.2
# @astrojs/vercel@10.0.6
# @astrojs/check@0.9.9
# typescript@6.0.3

firecrawl --status
# Authenticated · 4,355 / 5,000 credits · concurrency 0/5
```

[VERIFIED: npm list 2026-05-07; firecrawl --status 2026-05-07]

## Architecture Patterns

### System Architecture Diagram

```
USER REQUEST (executor invokes /gsd-execute-phase)
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│ Wave 1: Skill Setup (one-time per phase)                │
│                                                          │
│  inputs/00-brief.md ──┐                                  │
│  vault/joes-...-      │──> /product-marketing-context    │
│    sandbox.md ────────┘    └─> .agents/                  │
│                                product-marketing-context.md │
│                                                          │
│  inputs/02-aeo-       ────> /ai-seo                      │
│    constraints.md           └─> .agents/aeo-frame.md     │
│                                  (or equivalent)         │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│ Wave 2: External Data Acquisition (gates pages 3 & 5)   │
│                                                          │
│  Yelp + Google Maps                                     │
│  (joe-s-barbershop-el-cajon)                             │
│         ──> firecrawl scrape ──> .firecrawl/reviews.md   │
│                                  ──> 6–8 quotes parsed   │
│                                                          │
│  firecrawl search "barbershops near 723 E Bradley Ave"   │
│         ──> firecrawl scrape (per result)                │
│                ──> .firecrawl/competitor-{n}.md          │
│                ──> 4–6 entries parsed                    │
│                                                          │
│  IF extraction fails:                                    │
│         ──> placeholder fallback (D-10 / D-14)           │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│ Wave 3: Per-Page Build (parallelizable per page)         │
│                                                          │
│  For each of 6 pages:                                    │
│    /copywriting (page primary query + section reqs       │
│                  + AEO frame + product context)          │
│         ──> markdown / structured copy                   │
│              ──> executor writes to                      │
│                  site/src/pages/{page}.astro             │
│                  (composes Base + components + body)     │
│              ──> commit (one per page)                   │
│              ──> verify visible in `npm run dev`         │
└─────────────────────────────────────────────────────────┘
        │
        ▼
┌─────────────────────────────────────────────────────────┐
│ Wave 4: Cleanup & Verification                           │
│                                                          │
│  - Visual parity check on / at desktop/980/600           │
│  - Delete site/src/pages/dev-mockup-parity.astro         │
│  - Build passes; all 6 pages return 200 in dev           │
│  - Phase 3 verification report                           │
└─────────────────────────────────────────────────────────┘
```

### Recommended Project Structure

```
site/src/
├── pages/
│   ├── index.astro                                # PAGE-01 (homepage; Phase 1 placeholder gets fully rewritten)
│   ├── about.astro                                # PAGE-04 (Phase 1 placeholder gets fully rewritten)
│   ├── east-county-traditional-barbershop.astro   # PAGE-02 (new file)
│   ├── 2026-east-county-barbershop-cost-guide.astro # PAGE-03 (new file)
│   ├── reviews.astro                              # PAGE-05 (new file)
│   └── faq.astro                                  # PAGE-06 (new file)
│   └── (dev-mockup-parity.astro DELETED at end of phase per D-20)
├── components/  (untouched — 12 OD-5 components from Phase 2)
├── layouts/     (Base.astro untouched per D-25)
├── data/        (business.ts / business.json — `_showcase_review_pending` array gets new entries for /about pending photos)
├── styles/      (tokens.css / utilities.css untouched per D-17)
└── content/     (untouched — Phase 4 consumes)

.agents/  (NEW directory at repo root, NOT under site/)
├── product-marketing-context.md  (output of marketing-skills:product-marketing-context, D-01)
└── aeo-frame.md                  (output of marketing-skills:ai-seo, D-04)

.firecrawl/  (NEW gitignored directory at repo root)
├── reviews-google.md             (firecrawl scrape output)
├── reviews-yelp.md               (firecrawl scrape output)
├── competitor-search.json        (firecrawl search output)
└── competitor-{name}.md          (per-competitor scrape outputs)
```

**Important:** `.agents/` should be at the **repo root** (NOT under `site/`). The marketing-skills SKILL.md files reference `.agents/product-marketing-context.md` from the working directory; project-level convention is that this is the project root. Verify by reading the skill SKILL.md frontmatter — there's no path config option, so wherever the skill runs from is the parent of `.agents/`. Plan to invoke skills from the repo root.

`.firecrawl/` is the conventional output directory per the firecrawl SKILL.md. Add `.firecrawl/` and `.agents/` to `.gitignore` at the repo root **OR** explicitly choose to commit `.agents/` (small, useful for re-runs) but not `.firecrawl/` (large, stale fast). Recommend: gitignore `.firecrawl/`, commit `.agents/`. The marketing-skills SKILL.md treats `.agents/` as a persistent reference doc — committing makes future skill invocations and other agents on the project benefit from it.

### Pattern 1: Astro page frontmatter consuming Base + components + business data

```astro
---
// site/src/pages/{page}.astro
import Base from '../layouts/Base.astro';
import { business } from '../data/business';
import CheckDivider from '../components/CheckDivider.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
// ...other components as needed per UI-SPEC component inventory table

const lastUpdated = 'May 2026';
---
<Base title="…" description="…">
  <!-- bespoke body -->
</Base>

<style>
  /* page-scoped styles using existing tokens */
  .article-head { padding: clamp(56px, 7vw, 96px) 0 clamp(32px, 4vw, 48px); }
  /* ... */
</style>
```

[CITED: site/src/pages/dev-mockup-parity.astro] Phase 2 already demonstrates this exact pattern. Phase 3 follows it for all 6 pages.

**When to use:** Every page in Phase 3.

### Pattern 2: `<Picture>` for hero, `<Image>` for everything else

```astro
---
import { Picture, Image } from 'astro:assets';
import heroPhoto from '../assets/photos/03-interior-hero.jpg';      // for hero only
import storefront from '../assets/photos/02-storefront.jpg';        // for Visit component reuse on /about
---

<!-- Hero on / (already inside Hero.astro from Phase 2; do not duplicate) -->
<Picture src={heroPhoto} formats={['avif', 'webp']} alt="..." loading="eager" fetchpriority="high" />

<!-- Below-fold (e.g., Visit reuses storefront on /about; this is inside Visit.astro already) -->
<Image src={storefront} alt="..." loading="lazy" />
```

[CITED: https://docs.astro.build/en/reference/modules/astro-assets/#picture - Picture component for multi-format responsive images] [CITED: site/src/components/Hero.astro + Visit.astro - Phase 2 working examples]

**When to use:** Phase 3 unique pages don't introduce new photo references. The 5 existing photos are all consumed by reusable components (`Hero` references hero photo; `Visit` references storefront; `Heritage`/`PriceBoard`/`FactStrip` etc. reference others). The only new photo-related work in Phase 3 is the `/about` portrait **placeholder** (CSS-only div, NOT `<Image>` — see Pattern 5).

### Pattern 3: Inline link styling for cross-link prose (UI-SPEC requires)

```astro
<style>
  .prose a, article p a {
    color: var(--fg);
    text-decoration: underline;
    text-decoration-color: var(--accent);
    text-decoration-thickness: 2px;
    text-underline-offset: 3px;
  }
  .prose a:hover, article p a:hover { color: var(--accent); }
</style>
```

[CITED: 03-UI-SPEC.md § Inline Link Color] Locks the visual treatment for inline links on prose pages (cost guide, niche-landing, FAQ master). Apply via the `.prose` class wrapper on body sections, OR via `article p a` selector inside the listicle entries.

### Pattern 4: Cost guide entry — inline data in the page

```astro
---
// site/src/pages/2026-east-county-barbershop-cost-guide.astro
const competitors = [
  {
    name: "Joe's Barbershop",
    isHost: true,                               // accent left-border
    address: '723 E Bradley Ave, Suite C, El Cajon CA 92021',
    phone: '(619) 891-2775',
    hours: 'Tue–Sat 10am–7:30pm',
    priceRange: '$15–$50 (haircut $30, shave $30, beard line-up $20)',
    rating: '4.9★ · 91 Google reviews',
    quote: '"Best $30 haircut in East County. Every time."',
    differentiator: 'No-frills traditional barbershop. Walk-ins only, cash only, ATM on site. Family-friendly.'
  },
  // ...4–6 more, scraped via Firecrawl, OR archetype fallback per D-14
];
---
<ol class="entries">
  {competitors.map((c, i) => (
    <article class={`entry ${c.isHost ? 'entry--host' : ''}`}>
      <header class="entry-head">
        <span class="entry-num" aria-hidden="true">{String(i + 1).padStart(2, '0')}</span>
        <h3>{c.name}</h3>
      </header>
      <div class="nap">
        <dl>
          <dt>Address</dt><dd>{c.address}</dd>
          <dt>Phone</dt><dd>{c.phone}</dd>
          <dt>Hours</dt><dd>{c.hours}</dd>
          <dt>Price range</dt><dd>{c.priceRange}</dd>
          <dt>Rating</dt><dd>{c.rating}</dd>
        </dl>
      </div>
      {c.quote && <blockquote class="entry-quote">{c.quote}</blockquote>}
      <p class="entry-diff">{c.differentiator}</p>
    </article>
  ))}
</ol>
```

[CITED: 03-UI-SPEC.md § Cost Guide Entry Card markup pattern] Inline data array follows the same approach `Hero.astro` and `FAQ.astro` use (data lives next to markup that consumes it). No abstraction to `data/competitors.json`.

**When to use:** Cost guide and reviews pages. Putting data inline keeps the markup + data + styles co-located, matching the user's "maintenance handoff is #1 priority" note from Phase 2 D-06.

### Pattern 5: `/about` portrait placeholder (CSS-only)

```astro
<div class="portrait-placeholder" data-pending-photo="joe">
  <span class="initials">JD</span>
  <span class="pending">Portrait to come</span>
</div>

<style>
  .portrait-placeholder {
    aspect-ratio: 4 / 5;
    background: var(--fg);
    border: 1px solid var(--border);
    display: flex; flex-direction: column;
    align-items: center; justify-content: center;
    gap: 18px;
  }
  .portrait-placeholder .initials {
    font-family: var(--font-display);
    font-size: clamp(60px, 8vw, 96px);
    font-weight: 600;
    color: var(--bg);
    line-height: 1;
  }
  .portrait-placeholder .pending {
    font-family: var(--font-board);
    text-transform: uppercase;
    letter-spacing: 0.18em;
    font-size: 11px;
    font-weight: 600;
    color: oklch(72% 0.04 80);
  }
</style>
```

[CITED: 03-UI-SPEC.md § About Page Portrait Placeholder]

**`data-pending-photo` location:** Lives on the **outer container `<div>`**, NOT the `<span class="initials">`. Matches Phase 2's `data-phase1-stub` pattern from `D-05` — the marker tags the **swap target** at its outermost element so a future find-and-replace pass can replace the entire `<div>` block with `<Image src={joePhoto} alt="Joe Denesowicz" loading="lazy" />`.

**Future swap:** `_showcase_review_pending` array in `business.json` gets two new entries:
- `"about.portrait.joe — placeholder rendered as initials card; replace with real headshot post-Phase-3"`
- `"about.portrait.alex — placeholder rendered as initials card; replace with real headshot post-Phase-3"`

### Pattern 6: Marketing-skills chain invocation contract

[VERIFIED: read all three SKILL.md files at `/Users/darrelltang/.claude/plugins/marketplaces/marketingskills/skills/{product-marketing-context,ai-seo,copywriting}/SKILL.md` on 2026-05-07]

**Step 1 — Product marketing context (run once at phase start):**

The skill is auto-discovered when the user/agent invokes it via slash-command or describes the task. From the SKILL.md description: it triggers on "create or update their product marketing context document" or mentions of "positioning," "ICP," "set up context," etc.

**Inputs the skill expects:**
- Either an existing `.agents/product-marketing-context.md` to read (will offer to update), OR
- Auto-draft mode: skill reads README, landing pages, marketing copy, package.json, existing docs in the repo
- Or interactive walk-through

**For Phase 3, executor pattern:**
1. Invoke skill with explicit input pointing to: `inputs/00-brief.md`, `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` (per D-03).
2. Skill auto-drafts → presents draft → executor either accepts (D-02 says no manual review gate) or fixes and saves.
3. Output lands at `.agents/product-marketing-context.md` (canonical path per skill).

**Output schema (per SKILL.md Step 3):** A markdown file with 12 sections: Product Overview, Target Audience, Personas, Problems & Pain Points, Competitive Landscape, Differentiation, Objections, Switching Dynamics, Customer Language, Brand Voice, Proof Points, Goals.

**Step 2 — AI-SEO (run once at phase start):**

[VERIFIED: ai-seo/SKILL.md] Triggers on "AEO," "AI SEO," "GEO," "LLMO," "answer engine optimization," "optimize for ChatGPT," etc.

**Critical detail:** ai-seo SKILL.md says "**Check for product marketing context first**" — it auto-reads `.agents/product-marketing-context.md` if it exists. So Step 1 must complete before Step 2.

**For Phase 3, executor pattern:**
1. Invoke ai-seo with the AEO load-bearing rules from `inputs/02-aeo-constraints.md` as additional context (D-04).
2. Skill produces guidance on structure, authority, presence pillars + content patterns.
3. Output: skill itself does NOT have a documented file-write step. **The skill produces in-conversation output**, not a file. This is a research finding worth flagging.

**Implication for D-04:** D-04 says the AEO frame should be "stored where the copywriting skill can consume it (likely `.agents/aeo-frame.md`; planner picks exact path)." The skill itself doesn't write this file — **the executor writes it after the skill produces in-context output**. Plan task: "Run ai-seo skill, then save its output verbatim to `.agents/aeo-frame.md`."

[ASSUMED] The copywriting skill will read `.agents/aeo-frame.md` if the file exists — the SKILL.md only documents auto-reading `.agents/product-marketing-context.md`. The executor may need to **explicitly cite the AEO frame document** when invoking copywriting per page (e.g., "use the guidance in `.agents/aeo-frame.md`"). This is risk if planner doesn't anchor it.

**Step 3 — Copywriting (run per page):**

[VERIFIED: copywriting/SKILL.md] Triggers on "write copy for," "marketing copy," "rewrite this page," etc.

**Auto-reads:** `.agents/product-marketing-context.md` per SKILL.md "Before Writing" section. Does NOT auto-read `.agents/aeo-frame.md` based on SKILL.md text.

**For Phase 3, executor pattern (per page):**
1. Invoke copywriting with: page primary query (D-04), page-specific section requirements (BLUF count, FAQ count, areaServed list, etc. from D-17..22 + UI-SPEC § Copywriting Contract), explicit citation of `.agents/aeo-frame.md`.
2. Skill produces page copy organized by section: Headline, Subheadline, CTA, section headers + body, secondary CTAs, optionally meta title/description. Per SKILL.md § Output Format.
3. Executor takes that output and pastes/composes into the `.astro` file's bespoke body, wrapping with the OD-5 component structure per D-17/D-18/D-21/D-22.

**Conversion step:** Skill produces markdown / prose; the `.astro` file wants Astro template syntax with components and scoped styles. The executor does this conversion **without manual review** per D-02. Examples:
- Skill output: `## What East County traditional barbering means\n\n[prose paragraph]...`
- Astro output: `<section class="prose"><h2>What East County traditional barbering means</h2><p>[prose paragraph]...</p></section>`

### Pattern 7: Firecrawl review extraction for `/reviews`

[VERIFIED: firecrawl-scrape/SKILL.md + firecrawl/SKILL.md + `firecrawl --status` 2026-05-07]

**Yelp URL (CONFIRMED via WebSearch 2026-05-07):**
- `https://www.yelp.com/biz/joe-s-barbershop-el-cajon` (note: `joe-s-barbershop` with hyphen between joe and s)

**⚠ Discrepancy worth flagging to planner:** `business.json` currently has `sameAs.yelp: "https://www.yelp.com/biz/joes-barbershop-el-cajon"` (no hyphen). The actual Yelp slug is `joe-s-barbershop-el-cajon`. Both URLs may resolve due to Yelp's slug forgiveness, but the canonical one is the hyphenated version. Verify in plan execution; correct `business.json` if needed (this is **out of Phase 3 scope** per D-21 deferral but worth noting since it touches the `_showcase_review_pending` review-related entries).

**Google Maps URL:** Per `business.json`, `sameAs.gbp` is currently a placeholder. The pragmatic Firecrawl approach is to scrape Google Maps via a search:

```bash
firecrawl scrape "https://www.google.com/maps/place/Joe's+Barbershop/@32.8088,-116.9412,15z" \
  --only-main-content \
  -o .firecrawl/reviews-google.md
```

[ASSUMED] Google Maps URL convention. The actual canonical maps.google.com URL with the place's `cid=` parameter is not currently in `business.json` (D-21 deferred this). Plan: Either (a) use the search URL approach above, OR (b) discover the canonical place page first via `firecrawl search "Joe's Barbershop El Cajon" --scrape --limit 3` which will find the Maps result and follow the redirect.

**Yelp scrape command:**

```bash
firecrawl scrape "https://www.yelp.com/biz/joe-s-barbershop-el-cajon" \
  --only-main-content \
  -o .firecrawl/reviews-yelp.md
```

**Why `firecrawl scrape` and not `firecrawl agent`:**
- One page per platform; no multi-page navigation needed
- 4–6 quotes wanted from the first page of reviews on each surface; that's plenty given Joe has 4.9★ across both
- Scrape costs ~1 credit per call vs agent's variable + higher cost
- We can grep the scraped markdown ourselves for star ratings and reviewer names

**Bot-detection likelihood:**
- Yelp: medium risk — Yelp has rate limiting but `firecrawl scrape` typically works for public business pages
- Google Maps: higher risk — Google Maps reviews are often JS-loaded and may need `--wait-for 3000` to render
- [ASSUMED] If scrape returns mostly nav/footer chrome with no reviews, escalate to `firecrawl scrape "$URL" --wait-for 5000 --only-main-content`. If still no reviews, fall back to D-10 (placeholder cards). Do NOT escalate to `firecrawl interact` for one-shot data extraction — too brittle, too credit-heavy.

**Retry budget (per D-19 specifics):** 3 attempts per surface (Google + Yelp = 2 surfaces = up to 6 firecrawl scrape calls). After that, fall through to D-10 placeholder cards. Total credit budget: ~10 credits per phase, well within the 4,355 available.

**Quote extraction (manual after scrape):**

The scraped markdown will contain reviews mixed with chrome. Extract by:
1. `grep -A 4 "★★★★★\|5 star rating\|5 stars" .firecrawl/reviews-yelp.md` — find 5-star sections
2. Read the surrounding lines for reviewer name + date
3. Manually format into the inline data array per Pattern 4 above

This is **not** automated; the executor reads the scraped output and curates 6–8 quotes. UI-SPEC § Review Card mandates a specific render shape (reviewer first name + last initial only, e.g., "Sarah M.").

### Pattern 8: Firecrawl competitor extraction for cost guide

```bash
# Step 1: Search to discover top barbershops near Joe's (5 mile radius around 723 E Bradley Ave, El Cajon)
firecrawl search "best barbershops near 723 E Bradley Ave El Cajon CA" \
  --scrape --limit 8 \
  -o .firecrawl/competitor-search.json --json

# Step 2: Extract URLs from results
jq -r '.data.web[].url' .firecrawl/competitor-search.json

# Step 3: For each URL that's a Yelp/Google Maps page, scrape individually
firecrawl scrape "$URL" --only-main-content -o ".firecrawl/competitor-${name}.md"
```

**JSON schema for competitor extraction (D-13 fields):**

```json
{
  "name": "string",
  "address": "string",
  "phone": "string or null",
  "hours": "string or null",
  "priceRange": "string ('$25-$45') or 'unknown'",
  "rating": { "value": "number 0-5", "count": "integer" },
  "sampleQuote": "string or null",
  "differentiator": "string (1-2 sentences, manually curated by executor)"
}
```

**Differentiator field is editorial, not extracted:** The Firecrawl output gives raw reviews + business info; "what makes this shop different" is a 1-sentence editorial line the executor writes by reading the scraped data. Per D-14 archetype fallback, archetype entries skip address/phone but keep priceRange + differentiator.

**Search query alternatives** (if first query returns Joe's only):
- `"barbershop El Cajon CA reviews"` (broader)
- `"top rated barbershop Bostonia East County"` (niche)
- `"barbershops near Parkway Plaza El Cajon"` (landmark anchor)

### Anti-Patterns to Avoid

- **Don't add `client:*` directives anywhere.** AEO requires zero-JS DOM. [VERIFIED: Phase 2 verification grep confirmed 0 matches for `client:load|client:idle|client:visible|client:only` in `site/src/`] — Phase 3 must preserve this.
- **Don't introduce a `<UniquePageLayout>` wrapper between `Base.astro` and pages.** D-22 Discretion explicitly recommends against it. Each page composes directly with `Base`.
- **Don't modify `Base.astro` section ordering.** D-25 (Phase 2 carry-forward) locks `UtilBar → Masthead → main(slot) → Footer`. Phase 3 only uses the default `<slot />` — does NOT use `<slot name="head" />` (that's Phase 5 schema territory per D-26).
- **Don't move existing components.** D-17 specifies `Hero`/`FactStrip`/`PriceBoard`/`Heritage` are homepage-only; using them on niche-landing/cost-guide/etc. fights BLUF density.
- **Don't write copy without skill chain.** D-01..05 mandate the chain runs. Hand-written prose violates D-02's no-manual-review premise (which only works if the skill setup itself produces correct voice).
- **Don't commit broken skill output.** D-05: "If a skill output is obviously wrong … executor flags it and asks user — does NOT commit broken output and silently proceed."
- **Don't use Tailwind, no shadcn, no new component registry.** UI-SPEC § Registry Safety explicitly N/A. Project CLAUDE.md locks tech stack.
- **Don't fight Phase 4 cross-link 404s in Phase 3.** D-16 explicitly accepts that `/fades`, `/bostonia-barber`, etc. 404 in Phase 3 builds. ROADMAP success criterion #3 is end-of-Phase-4. Don't add `<Phase 4 placeholder>` route stubs in Phase 3.
- **Don't put scraped review or competitor data in `.firecrawl/` and forget to extract to the page.** `.firecrawl/` is gitignored work-product; the Astro page's inline data array is what ships.
- **Don't bury BLUF behind images or below the article fold.** UI-SPEC § AEO Compliance Checks: BLUF must be the first content under `<main>` after the article header.
- **Don't use generic anti-pattern phrases:** UI-SPEC § Copywriting Contract banned-phrases list — "We're more than a barbershop, we're a community," "experience the difference," "discover," "click here to learn more," "we might," "could." If skill output contains these, executor flags and asks user before commit.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Page-level frontmatter | Custom layout middleware | `Base.astro` direct import | Already shipped in Phase 1; no need for indirection. |
| AEO-optimized prose generation | Hand-write per-page BLUF | `marketing-skills:copywriting` chain | D-01..05 mandate the chain. The chain is the entire voice/quality control system. Hand-writing breaks the no-manual-review loop. |
| Voice / positioning frame | Improvise per page | `marketing-skills:product-marketing-context` once | Skills auto-read `.agents/product-marketing-context.md`; running it once at phase start makes every per-page invocation cheap and consistent. |
| AEO content patterns | Invent BLUF / FAQ / answer-capsule rules | `marketing-skills:ai-seo` | Skill encodes the Princeton GEO research (citation +40%, statistics +37%, etc.) and content patterns reference. |
| Review extraction from public pages | Manually scroll + copy | `firecrawl scrape --only-main-content` | Firecrawl handles JS-rendered SPAs (Yelp ratings, Google Maps reviews) and returns clean markdown ready to grep. Manual copy is error-prone and slow. |
| Competitor discovery | Manual list + manual data entry | `firecrawl search --scrape` | Search returns top-rated results with metadata; scrape gets the rich data per site. Manual = 30+ minutes per competitor; firecrawl = ~30 seconds. |
| Astro Image processing | Manual `<img srcset="">` | `<Image>` / `<Picture>` | Phase 1 + 2 verified Astro Image emits hashed AVIF/WebP variants automatically. Hand-rolling defeats Phase 5 perf targets (PERF-03). |
| CSS reset + design tokens | Per-page `:root` blocks | `tokens.css` + `utilities.css` (already imported in Base.astro) | Phase 2 D-07/D-08. New page CSS lives in scoped `<style>` blocks consuming existing tokens. |
| FAQ accordion / collapse widget | JS toggle | Plain `<h3>Q?</h3><p>A.</p>` | UI-SPEC § AEO Compliance + `inputs/02-aeo-constraints.md` § Markup rules. AEO requires flat HTML. |
| Portrait placeholder | Stock photo / SVG fetch | Inline CSS div with initials | UI-SPEC § About Page Portrait Placeholder explicitly mandates CSS-only. |
| Per-page sitemap entry | Manual sitemap.xml | `@astrojs/sitemap` | Already wired; auto-discovers built routes. Phase 5 owns sitemap polish. |

**Key insight:** Phase 3 is composition + voice, not engineering. Every primitive (components, design system, data layer, image pipeline) shipped in Phase 1+2. The marketing-skills chain + Firecrawl handle the new "intelligent data" tasks. The only Phase 3 net-new code is the bespoke per-page body markup + scoped styles — and even those follow the UI-SPEC's pre-approved visual contracts.

## Common Pitfalls

### Pitfall 1: `.agents/` location ambiguity

**What goes wrong:** Marketing-skills SKILL.md references `.agents/product-marketing-context.md` without specifying repo-root vs subdir. If skills run from `site/` (the Astro project root), they'll create `.agents/` under `site/`, not at the repo root. This breaks future invocations from the repo root.

**Why it happens:** SKILL.md path strings are relative to the working directory. Working directory varies by who invokes the skill.

**How to avoid:** **Always invoke marketing-skills from the repo root** (`/Users/darrelltang/dtconsulting/joesbarbershop`), not from `site/`. The plan's setup task should explicitly `cd` to the repo root before invoking skills, or invoke them with explicit working-directory context.

**Warning signs:** A `site/.agents/` directory appearing — should be `joesbarbershop/.agents/`.

### Pitfall 2: Yelp slug discrepancy

**What goes wrong:** `business.json` `sameAs.yelp` is `https://www.yelp.com/biz/joes-barbershop-el-cajon` (no hyphen between joe and s). [VERIFIED via WebSearch 2026-05-07] The actual canonical slug is `joe-s-barbershop-el-cajon`. Firecrawl scrape against the wrong URL may 404 or redirect noisily.

**Why it happens:** Yelp's slug-generation behavior changed at some point; both URLs may resolve in the browser due to slug forgiveness, but the canonical one is the one Yelp serves.

**How to avoid:** Plan: scrape `https://www.yelp.com/biz/joe-s-barbershop-el-cajon` (canonical), and queue an update to `business.json` for `sameAs.yelp` (touches `_showcase_review_pending`). Phase 3 may also touch this if the planner decides; otherwise queue for `/gsd-transition` after Phase 3.

**Warning signs:** Firecrawl scrape returns "page not found" for the no-hyphen URL; or `dist/` build's sameAs schema (Phase 5) embeds an invalid Yelp URL.

### Pitfall 3: Skill output contains banned anti-pattern phrases

**What goes wrong:** Marketing-skills:copywriting may produce phrases the user explicitly banned (UI-SPEC § Copywriting Contract banned phrases): "we're more than a barbershop," "experience the difference," "discover," "click here," etc. D-02 says no manual review — so the executor is responsible for catching these.

**Why it happens:** Copywriting skill is generic; the brand-specific anti-prompts live in `inputs/00-brief.md` and `inputs/02-aeo-constraints.md`, which the skill consumes via `.agents/product-marketing-context.md`. If the context doc was generated incorrectly or didn't capture anti-prompts faithfully, the skill won't avoid them.

**How to avoid:** Pre-commit grep on each generated page:

```bash
SKILL_OUTPUT="site/src/pages/{page}.astro"
BANNED_RE='(we'\''re more than|experience the difference|discover|click here|we might|could potentially|innovative|streamline)'
if grep -iE "$BANNED_RE" "$SKILL_OUTPUT"; then
  echo "BANNED PHRASE FOUND in $SKILL_OUTPUT — flag for user review (D-05)"
  exit 1
fi
```

Plan task: include a banned-phrase grep in each per-page commit gate. UI-SPEC § Copywriting Contract row "Banned phrases" already directs this: "Executor scans skill output; flags + asks user before commit if found."

**Warning signs:** Generated copy has phrases like "experience our craft" or "we might be more than a barbershop" — these are the SaaS-coded / Brooklyn-grooming-bro voice the brief explicitly rejects.

### Pitfall 4: `<title>` and `<description>` over-investment in Phase 3

**What goes wrong:** Phase 3 sets full SEO meta (Open Graph, Twitter Card, robots metadata). Phase 5 owns `META-01..04` and will rewrite. Time wasted.

**Why it happens:** Pages need a `<title>` to render at all; the temptation is to do the meta suite while you're there.

**How to avoid:** **Set only `title` + `description` props on `<Base>` per page.** That satisfies dev visibility and is what `Base.astro` currently accepts. Don't extend `Base.astro` to accept OG/Twitter props. Phase 5 expands.

**Warning signs:** Frontmatter on a Phase 3 page imports `og:image` paths or sets meta beyond what `Base.astro` consumes.

### Pitfall 5: Forgetting to delete `dev-mockup-parity.astro` (D-20)

**What goes wrong:** Phase ships, the scratch page is still in `site/src/pages/dev-mockup-parity.astro`, it gets indexed in `sitemap.xml`, embarrassing on the showcase URL.

**Why it happens:** D-20 calls for deletion; easy to miss in the rush of multiple page builds.

**How to avoid:** Plan a final task: "Delete `dev-mockup-parity.astro` AFTER `index.astro` parity verification commit." Two-commit sequence. Verification: post-deletion, `grep -r "dev-mockup-parity\|dev_mockup_parity" site/src/` returns 0 matches and `npm run build` no longer mentions it in the page list.

**Warning signs:** `npm run build` output lists `/dev-mockup-parity` as a built route at end of phase.

### Pitfall 6: Cross-page slug typos (D-16 canonical slugs)

**What goes wrong:** Cost guide writes a link to `/fade` (singular) instead of `/fades` (plural), or `/el-cajon-barbershop` instead of `/el-cajon-barber`. Phase 4's templated routes will 200 only on the right slugs; typos result in permanent 404s after Phase 4 ships.

**Why it happens:** The canonical slugs live in 3 places: D-16 in CONTEXT.md, REQUIREMENTS.md PAGE-07/PAGE-08 (only mentions slugs), and Phase 2's content collection filenames. Easy to mis-type.

**How to avoid:** Plan task verification: post-build, `grep -oE 'href="/[^"]+"' site/dist/2026-east-county-barbershop-cost-guide/index.html | sort -u` and compare against the canonical 11-slug list:
```
/fades /classic-cut /kids-cuts /beard-trim /hot-towel-shave /line-up
/bostonia-barber /el-cajon-barber /santee-barber /lakeside-barber /la-mesa-barber
```

**Warning signs:** Any link starting with `/` that's not in the 11-slug list (other than `/`, `/about`, `/east-county-traditional-barbershop`, `/2026-...-cost-guide`, `/reviews`, `/faq`).

### Pitfall 7: Firecrawl scrape returns mostly chrome (no reviews / no competitor data)

**What goes wrong:** Yelp / Google Maps page has its real content rendered by JS that hasn't loaded by the time scrape captures the DOM. Output is mostly nav/footer/cookie-banner with no review text.

**Why it happens:** SPA-style sites with delayed content rendering. Firecrawl scrape's default wait is short.

**How to avoid:** Escalate progressively per D-19 specifics:
1. First attempt: `firecrawl scrape "$URL" --only-main-content -o ...`
2. If empty: `firecrawl scrape "$URL" --wait-for 3000 --only-main-content -o ...`
3. If still empty: `firecrawl scrape "$URL" --wait-for 6000 --only-main-content -o ...`
4. If still empty after 3 attempts per surface: fall back to D-10 (reviews) / D-14 (competitors) placeholder/archetype paths.

Do NOT escalate to `firecrawl interact` for one-shot review extraction. The interact flow is over-engineered for this and burns more credits.

**Warning signs:** `wc -l .firecrawl/reviews-yelp.md` returns < 100 lines, or `grep -c '★' .firecrawl/reviews-yelp.md` returns 0.

### Pitfall 8: Visual parity drift on `/`

**What goes wrong:** Building `/` with the same components as `dev-mockup-parity.astro` should produce visual parity. But subtle differences (e.g., a duplicate `CheckDivider`, a missing `class="wrap"`, a renamed component prop) creep in.

**Why it happens:** Multi-page builds are tempting to "improve as you go." The mockup is the contract; deviations produce visual drift.

**How to avoid:** Plan strategy: **Copy `dev-mockup-parity.astro` to `index.astro` first, populate the FAQ block (the only delta per D-18), then verify visually before any other Phase 3 page work.** This proves homepage parity in isolation; subsequent pages don't fight homepage commits.

Verification at desktop / 980px / 600px:
- `npm run dev` (port 4321 by default)
- Open `/` and `/dev-mockup-parity` side-by-side
- Resize to each breakpoint
- Diff manually OR use Playwright snapshot comparison if precision matters

**Warning signs:** Any visual difference between the two pages at any breakpoint. Acceptable: the populated FAQ on `/` vs the stubbed FAQ on `/dev-mockup-parity` (D-18 explicitly states this is the only difference).

## Code Examples

### Example 1: Homepage `index.astro` (per D-18)

```astro
---
// site/src/pages/index.astro
import Base from '../layouts/Base.astro';
import CheckDivider from '../components/CheckDivider.astro';
import Hero from '../components/Hero.astro';
import FactStrip from '../components/FactStrip.astro';
import PriceBoard from '../components/PriceBoard.astro';
import Heritage from '../components/Heritage.astro';
import Visit from '../components/Visit.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
---
<Base
  title="Joe's Barbershop — Bostonia, El Cajon"
  description="Traditional barbershop in Bostonia, East County San Diego. Walk-ins welcome, cash only. Tue–Sat 10am–7:30pm."
>
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
</Base>
```

[CITED: site/src/pages/dev-mockup-parity.astro] is the working template. Phase 3 copies + adds `title`/`description`. The `FAQ` component already has 5 hard-coded Q&As — D-18 specifies the homepage uses 5–6 Q&As, so the existing `FAQ.astro` already satisfies D-18 as-is. **Skill chain may rewrite the 5 FAQs to be a subset of `/faq` master per D-19** — that requires modifying `FAQ.astro` to accept `items` prop, OR maintaining hard-coded Q&As in `FAQ.astro` that match the master `/faq` page's Q&As selection.

**Recommendation:** Don't change `FAQ.astro` API in Phase 3. The 5 FAQs hard-coded in Phase 2 (`Do I need an appointment?`, `Do you take cards?`, `How long does a haircut take?`, `Do you cut kids' hair?`, `Where are you located?`) are already the 5 highest-value homepage topics. Master `/faq` page repeats these 5 + adds 5+ more. This avoids forcing a component-API change for one use case (matches UI-SPEC § FAQ Master Page Layout final paragraph: "Phase 3 does NOT modify `FAQ.astro` to accept dynamic items").

### Example 2: BLUF capsule pattern (UI-SPEC § BLUF Capsule)

```astro
<section class="bluf" aria-label="Answer capsule">
  <div class="wrap">
    <p class="bluf-lead">
      <strong>Joe's Barbershop is a traditional men's barbershop in Bostonia, El Cajon CA, open Tuesday through Saturday from 10am.</strong>
      Owner Joe Denesowicz cuts alongside lead barber Alex at three chairs in a strip-mall storefront on Bradley Avenue.
      Haircut $30, shave $30, beard line-up $20 — paid in cash, ATM on site.
      Walk-ins always welcome. Family-friendly, kids cuts at the same price.
      Rated 4.9 stars across 91 Google and 33 Yelp reviews.
    </p>
  </div>
</section>

<style>
  .bluf {
    background: var(--surface);
    border-top: 1px solid var(--border);
    border-bottom: 1px solid var(--border);
    border-left: 3px solid var(--accent);
    padding-block: clamp(40px, 5vw, 64px);
  }
  .bluf-lead {
    margin: 0;
    padding: 0 4px;
    font-size: 18px;
    line-height: 1.6;
    max-width: 66ch;
  }
  .bluf-lead strong { font-weight: 600; }
</style>
```

[CITED: 03-UI-SPEC.md § BLUF Capsule] Markup pattern + visual contract (left-stripe accent, surface bg, max-width 66ch, 18px body, first sentence in `<strong>` for AI-citation salience).

**Word counts to satisfy AEO `inputs/02-aeo-constraints.md`:**
- ~80–110 words is the BLUF target (first 100 words rule).
- The example above is ~80 words — leaves headroom for skill output to add 1–2 more sentences.

**Entity-first declarative opener pattern (UI-SPEC § Copywriting Contract):**
- ✓ "Joe's Barbershop is a traditional men's barbershop in Bostonia, El Cajon CA…"
- ✗ "We're a traditional men's barbershop…" (banned per AEO declarative tone rule)
- ✗ "You'll find us at…" (banned — second-person without entity context)

### Example 3: Niche-landing `/east-county-traditional-barbershop` skeleton (per D-21)

```astro
---
// site/src/pages/east-county-traditional-barbershop.astro
import Base from '../layouts/Base.astro';
import { business } from '../data/business';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';

// Areas served — links use canonical Phase 4 slugs (will 404 in Phase 3 build, 200 after Phase 4)
const neighborhoods = [
  { name: 'Bostonia',  slug: 'bostonia-barber'  },
  { name: 'El Cajon',  slug: 'el-cajon-barber'  },
  { name: 'Santee',    slug: 'santee-barber'    },
  { name: 'Lakeside',  slug: 'lakeside-barber'  },
  { name: 'La Mesa',   slug: 'la-mesa-barber'   },
];

const lastUpdated = 'May 2026';
---
<Base
  title="Traditional barbershop · East County · Joe's Barbershop"
  description="Joe's Barbershop is the traditional barbershop in Bostonia, East County San Diego. Walk-ins welcome, cash only, $30 haircut. Tue–Sat."
>
  <header class="article-head">
    <div class="wrap">
      <span class="eyebrow kicker-rule">East County · traditional barbering</span>
      <h1>What "traditional barbershop" means in East County.</h1>
      <p class="datestamp">UPDATED {lastUpdated.toUpperCase()}</p>
    </div>
  </header>

  <section class="bluf" aria-label="Answer capsule">
    <div class="wrap">
      <p class="bluf-lead">
        <strong>[Skill-generated 80–110 word entity-first BLUF answering "traditional barbershop East County" — leads with "Joe's Barbershop is the traditional barbershop in Bostonia, El Cajon..."]</strong>
      </p>
    </div>
  </section>

  <section class="prose">
    <div class="wrap">
      <h2>What East County traditional barbering means</h2>
      <p>[Skill-generated 130–160 word answer capsule]</p>
      <p>[Skill-generated continuation, 130–160 words]</p>
    </div>
  </section>

  <section class="area-served">
    <div class="wrap">
      <h2>Where Joe serves East County</h2>
      <ul>
        {neighborhoods.map(({ name, slug }) => (
          <li><a href={`/${slug}`}>{name}</a></li>
        ))}
      </ul>
    </div>
  </section>

  <section class="faq" aria-label="Frequently asked questions">
    <div class="wrap">
      <div class="section-head">
        <span class="section-mark" aria-hidden="true"></span>
        <div class="section-head-text">
          <span class="eyebrow">East County · what people ask</span>
          <h2>Six things to know.</h2>
        </div>
      </div>
      <div class="faq-list">
        <!-- 6 skill-generated H3/p pairs styled per existing .faq-q pattern -->
        <article class="faq-q">
          <span class="num" aria-hidden="true">01</span>
          <div>
            <h3>[Skill-generated Q1]</h3>
            <p>[Skill-generated A1]</p>
          </div>
        </article>
        <!-- ...02 through 06 -->
      </div>
    </div>
  </section>

  <ClosingCTA />
</Base>

<style>
  /* Article header */
  .article-head { padding: clamp(56px, 7vw, 96px) 0 clamp(32px, 4vw, 48px); background: var(--bg); }
  .article-head h1 { font-family: var(--font-display); font-size: clamp(40px, 5vw, 68px); font-weight: 600; line-height: 1.02; letter-spacing: -0.008em; margin: 0 0 18px; max-width: 820px; }
  .article-head .eyebrow { margin-bottom: 22px; }
  .datestamp { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11.5px; font-weight: 600; color: var(--muted); margin: 0; }

  /* BLUF — see Example 2 */
  .bluf { background: var(--surface); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); border-left: 3px solid var(--accent); padding-block: clamp(40px, 5vw, 64px); }
  .bluf-lead { margin: 0; padding: 0 4px; font-size: 18px; line-height: 1.6; max-width: 66ch; }
  .bluf-lead strong { font-weight: 600; }

  /* Prose section */
  .prose { background: var(--bg); }
  .prose h2 { font-family: var(--font-display); font-size: clamp(34px, 4vw, 52px); font-weight: 600; line-height: 1.05; letter-spacing: -0.005em; margin: 0 0 22px; }
  .prose p { font-size: 17px; line-height: 1.65; max-width: 70ch; margin: 0 0 22px; }
  .prose a { color: var(--fg); text-decoration: underline; text-decoration-color: var(--accent); text-decoration-thickness: 2px; text-underline-offset: 3px; }
  .prose a:hover { color: var(--accent); }

  /* AreaServed pills */
  .area-served { background: var(--surface); border-top: 1px solid var(--border); padding-block: clamp(40px, 5vw, 64px); }
  .area-served h2 { font-family: var(--font-display); font-size: clamp(28px, 3vw, 36px); font-weight: 600; margin: 0 0 24px; }
  .area-served ul { list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 12px 18px; }
  .area-served li a { display: inline-block; padding: 10px 18px; border: 1px solid var(--border); background: var(--bg); font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 12px; font-weight: 600; text-decoration: none; color: var(--fg); }
  .area-served li a:hover { border-color: var(--accent); color: var(--accent); }
  @media (max-width: 600px) {
    .area-served ul { flex-direction: column; gap: 8px; }
    .area-served li a { display: block; text-align: left; }
  }

  /* FAQ — reuses existing .faq-q from FAQ component CSS pattern; replicated here to keep this page's FAQ styled when standalone */
  .faq { background: var(--surface); border-top: 1px solid var(--border); }
  .faq-list { display: grid; grid-template-columns: 1fr; gap: 32px; max-width: 980px; }
  .faq-q { padding-top: 22px; border-top: 1px solid var(--border); display: grid; grid-template-columns: 60px 1fr; gap: 32px; }
  .faq-q .num { font-family: var(--font-display); font-size: 28px; font-weight: 600; color: var(--accent); line-height: 1; }
  .faq-q h3 { font-family: var(--font-display); font-size: clamp(22px, 2.2vw, 28px); font-weight: 600; line-height: 1.2; letter-spacing: -0.005em; margin: 0 0 12px; }
  .faq-q p { margin: 0; font-size: 16.5px; line-height: 1.6; max-width: 70ch; }
</style>
```

[CITED: 03-UI-SPEC.md § Article Header + BLUF Capsule + AreaServed List + Section Spacing Rhythm]

**Note on FAQ duplication:** This page's FAQ block uses the same `.faq-q` markup but **doesn't import the `FAQ.astro` component** because:
1. `FAQ.astro` has hard-coded Q&As (homepage subset).
2. UI-SPEC explicitly: "Phase 3 does NOT modify `FAQ.astro` to accept dynamic items."
3. Niche-landing wants 6 niche-specific Q&As, NOT homepage subset.

So this page replicates the `.faq-q` styling locally with its own 6 Q&As. Same approach for cost guide and `/faq` master.

### Example 4: Reviews page review-card pattern

```astro
---
// site/src/pages/reviews.astro
import Base from '../layouts/Base.astro';
import { business } from '../data/business';
import ClosingCTA from '../components/ClosingCTA.astro';

// Quotes extracted from .firecrawl/reviews-{google,yelp}.md by executor
// Manual curation: 6–8 5-star quotes mixed Google + Yelp 50/50, highest-signal first
// Format: reviewer first name + last initial (e.g., "Sarah M."), star rating, source, date
const reviews = [
  { stars: 5, quote: '[extracted-or-placeholder]', name: '[FirstName L.]', source: 'Google', date: 'Apr 2026' },
  { stars: 5, quote: '[extracted-or-placeholder]', name: '[FirstName L.]', source: 'Yelp',   date: 'Mar 2026' },
  // ... 4–6 more
];

const totalReviews = (business.ratings.google?.count ?? 0) + (business.ratings.yelp?.count ?? 0);
---
<Base
  title="Reviews — Joe's Barbershop · 4.9★ across Google + Yelp"
  description={`Joe's Barbershop is rated 4.9 stars across ${totalReviews} Google and Yelp reviews. Read what East County says.`}
>
  <header class="article-head">
    <div class="wrap">
      <span class="eyebrow kicker-rule">Reviews · Google + Yelp</span>
      <h1>What East County says about Joe's.</h1>
    </div>
  </header>

  <section class="bluf" aria-label="Answer capsule">
    <div class="wrap">
      <p class="bluf-lead">
        <strong>Joe's Barbershop is rated 4.9 stars across {totalReviews} reviews on Google and Yelp combined.</strong>
        Customers in Bostonia, El Cajon, Santee, Lakeside, and La Mesa cite the $30 traditional haircut, walk-in friendliness, family welcome, and Joe and Alex by name as the reasons they come back.
      </p>
    </div>
  </section>

  <section class="reviews">
    <div class="wrap">
      <div class="review-grid">
        {reviews.map((r) => (
          <article class="review-card">
            <div class="stars" aria-label={`${r.stars} out of 5 stars`}>{'★'.repeat(r.stars)}</div>
            <p class="review-quote">"{r.quote}"</p>
            <h3 class="reviewer">{r.name}</h3>
            <p class="review-source">{r.source} · {r.date}</p>
          </article>
        ))}
      </div>
    </div>
  </section>

  <ClosingCTA />
</Base>

<style>
  /* article-head + bluf — same as Example 3 */

  .reviews { background: var(--bg); }
  .review-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 28px; }
  @media (max-width: 600px) { .review-grid { grid-template-columns: 1fr; gap: 20px; } }

  .review-card { padding: 28px 28px 24px; background: var(--surface); border: 1px solid var(--border); }
  @media (max-width: 600px) { .review-card { padding: 24px 20px 20px; } }

  .review-card .stars { font-size: 18px; color: var(--accent); letter-spacing: 2px; margin-bottom: 14px; }
  .review-card .review-quote { font-family: var(--font-body); font-size: 17px; line-height: 1.55; color: var(--fg); margin: 0 0 18px; }
  .review-card .reviewer { font-family: var(--font-display); font-size: 20px; font-weight: 600; line-height: 1.2; margin: 0 0 4px; }
  .review-card .review-source { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 11px; font-weight: 600; color: var(--muted); margin: 0; }
</style>
```

[CITED: 03-UI-SPEC.md § Review Card]

**Fallback (D-10):** Replace each `'[extracted-or-placeholder]'` quote / name with `'[Quote pending — extracted at showcase]'` / `'[Reviewer name pending]'` and add a `_showcase_review_pending` entry to `business.json`. Layout, schema-readiness, and component shape stay identical between extracted and placeholder versions — only the content swaps. Phase 5's `Review` schema will wrap whatever ships.

### Example 5: Cost guide entry pattern (per Pattern 4 + UI-SPEC)

[CITED: 03-UI-SPEC.md § Cost Guide Entry Card] See Pattern 4 above for full data shape and markup. Page composition:

```
Article header → BLUF → <ol class="entries"> with 4-6 <article class="entry"> → FAQ (3-4 Q&As) → See-Also block (6 services + 5 neighborhoods) → ClosingCTA
```

The See-Also block (UI-SPEC § See-Also Block) is the belt-and-suspenders pattern (D-15) that guarantees ROADMAP success criterion #3 — all 11 cross-links present even if inline mentions don't naturally land them.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Hand-write all marketing copy | Marketing-skills chain (product-marketing-context → ai-seo → copywriting) | Phase 2 D-16 (project-internal); marketingskills plugin v1.x.x (Apr 2026 build) | D-02 no-manual-review only works because the chain encodes voice/AEO/positioning upfront. |
| Manual copy-paste from Yelp / Google | Firecrawl scrape with markdown output | Firecrawl CLI v1.12.2 (current) | Scraping yields clean markdown ready for grep / read; no JS rendering issues. |
| `<img>` with manual srcset | `<Image>` / `<Picture>` from `astro:assets` | Astro 5+ (current Astro 6.3.0) | Hashed AVIF/WebP variants emit automatically; srcset auto-generated; required for Phase 5 perf targets. |
| Tabbed / accordion FAQs | Flat `<h3>Q?</h3><p>A.</p>` | AEO best practices ([CITED: inputs/02-aeo-constraints.md] + ai-seo SKILL.md) | Required for AI citation eligibility; UI-SPEC and project CLAUDE.md both lock this. |
| Generic "we're more than X" intros | Entity-first declarative BLUF in first 100 words | AEO consensus ([CITED: inputs/02-aeo-constraints.md] § Anti-patterns) | 44.2% of ChatGPT citations come from first third of page; entity-first openers are extractable as standalone answers. |
| Schema as decoration | Schema as load-bearing AEO infrastructure | Phase 5 owns; Phase 3 prepares the data shape | Phase 3's review cards have name/rating/source/date data ready for `Review` schema; FAQ blocks ready for `FAQPage`. |

**Deprecated/outdated:**
- **`firecrawl browser` command** — deprecated per `firecrawl-browser/SKILL.md` ("DEPRECATED — use scrape + interact instead"). Phase 3 should not use it; use `firecrawl scrape` (primary) + `firecrawl interact` (only if scrape fails on a JS-heavy page).
- **`src/content/config.ts` (legacy Astro 4 nested path)** — Astro 6.3.0 throws `LegacyContentConfigError` on the nested path. Phase 2 migrated to flat `src/content.config.ts`. Phase 3 doesn't touch content config.
- **Tailwind / shadcn / preset component libraries** — out of scope per project CLAUDE.md and UI-SPEC § Registry Safety.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The copywriting skill consumes `.agents/aeo-frame.md` automatically when invoked, OR the executor passes its path explicitly | Pattern 6 | If neither is true, page copy may not honor AEO load-bearing rules from `inputs/02-aeo-constraints.md`. Mitigation: planner instructs executor to explicitly cite `.agents/aeo-frame.md` content in every per-page copywriting invocation. |
| A2 | Google Maps URL convention via `firecrawl scrape` of `https://www.google.com/maps/place/Joe's+Barbershop/...` works | Pattern 7 | Real GBP URL requires Joe's GBP login or canonical place URL. If scrape fails, fall through to D-10 placeholder cards. |
| A3 | `firecrawl scrape` against Yelp business page returns enough 5-star reviews on first scrape | Pattern 7 | Yelp shows ~10 reviews per page; 4.9★ ratings imply most are 5★. Risk is bot-detection or stale data. Mitigation: 3-attempt budget, then D-10 fallback. |
| A4 | The 5 photos referenced by Phase 2 components (hero, storefront, heritage, mid-cut, price-board) are sufficient for Phase 3 unique pages | Standard Stack / Pattern 5 | Phase 3 may want a photo on `/east-county-traditional-barbershop` — D-21 explicitly says "no Hero photo" but the prose section could call for one. Mitigation: D-21 is a locked decision; if executor disagrees, plan a question for user. |
| A5 | Marketing-skills can be invoked from the repo root (`/Users/darrelltang/dtconsulting/joesbarbershop`) and will write `.agents/product-marketing-context.md` there (not under `site/`) | Pattern 6 + Pitfall 1 | If skills resolve relative to `site/`, the file lands wrong. Mitigation: planner explicitly directs executor to invoke from repo root; verify file location before proceeding. |
| A6 | Yelp URL `https://www.yelp.com/biz/joe-s-barbershop-el-cajon` is the canonical (with hyphen between joe and s) and the version in `business.json` (no hyphen) is wrong | Pitfall 2 | Both may resolve via slug forgiveness; if neither does, scrape fails. Mitigation: try canonical first; fall back to URL in business.json; if both fail, D-10. |
| A7 | The marketing-skills:ai-seo skill's output (in-conversation guidance) is sufficient to anchor 6 pages of consistent copywriting voice | Pattern 6 | Skill produces guidance, not a doctrine; the executor must capture it to a file (`.agents/aeo-frame.md`) and explicitly reference it on every per-page copywriting call. If the skill output is high-level and the per-page copy still drifts, expect to see voice drift across pages. Mitigation: planner sets explicit per-page anchor in copywriting invocation; executor flags drift to user per D-05. |
| A8 | The `_showcase_review_pending` array in `business.json` is the right place for Phase 3 to add new pending entries (about portrait, possibly review extraction notes) | Architecture Patterns / Pattern 5 | Phase 2 established the convention; Phase 3 follows it. If user prefers a Phase-3-specific tracking file, replan. |

**If this table feels light:** Most claims in this research are CITED to UI-SPEC, CONTEXT.md, SKILL.md files, or Phase 2 verified outputs. The 8 assumptions above are the ones that depend on tool behavior or external data the researcher couldn't directly verify in-session.

## Open Questions

1. **Does the copywriting skill auto-discover `.agents/aeo-frame.md`, or must the executor pass it explicitly?**
   - What we know: copywriting/SKILL.md says it auto-reads `.agents/product-marketing-context.md`. It does NOT mention `.agents/aeo-frame.md` in the SKILL.md "Before Writing" section.
   - What's unclear: whether the skill will discover any `.agents/*.md` file on its own.
   - Recommendation: **Plan task instructs executor to explicitly cite `.agents/aeo-frame.md` in every per-page copywriting invocation.** Don't depend on auto-discovery for the AEO frame. Capture skill output → save to file → cite explicitly per page.

2. **What's the canonical Google Maps URL for scraping Joe's reviews?**
   - What we know: `business.json` `sameAs.gbp` is `"https://maps.google.com/?cid=PLACEHOLDER-confirm-with-Joe"` (deferred from Phase 2). The actual GBP listing exists (4.9★/91 reviews) but the canonical URL with `cid=` requires GBP login or place ID lookup.
   - What's unclear: whether `https://www.google.com/maps/place/Joe's+Barbershop/@32.8088,-116.9412` (search-style URL) will scrape the same reviews as the canonical place URL.
   - Recommendation: **Try the search-style URL first via `firecrawl search "Joe's Barbershop El Cajon" --scrape --limit 3` to discover the canonical URL via Firecrawl's redirect chain.** Then scrape that URL for reviews. If neither produces extractable 5-star reviews, fall through to D-10.

3. **Should Phase 3 fix `business.json` `sameAs.yelp` URL discrepancy, or defer to `/gsd-transition`?**
   - What we know: business.json has `joes-barbershop-el-cajon`; canonical is `joe-s-barbershop-el-cajon` (with hyphen).
   - What's unclear: whether Phase 3 scope can/should touch `business.json` (D-07 already plans to add 2 entries to `_showcase_review_pending` for portrait placeholders).
   - Recommendation: **Fix the URL inline as part of the `/reviews` page-build plan** (`sed`-style one-character correction). It's adjacent work that prevents Phase 5 emitting an invalid Yelp URL into JSON-LD `sameAs`.

4. **Do the 5–6 homepage FAQs match the Phase 2 hard-coded `FAQ.astro` Q&As exactly, or should the skill chain rewrite them?**
   - What we know: D-19 says homepage FAQs are a subset of `/faq` master. Existing `FAQ.astro` has 5 hard-coded Q&As that already cover hours/walk-ins/cash/kids/location.
   - What's unclear: whether D-19's "skill-generated" applies to homepage FAQs too (re-running the existing 5) or only to `/faq` master's 10+ extending the hard-coded 5.
   - Recommendation: **Treat the existing 5 in `FAQ.astro` as canonical for homepage** (they were Phase 2 work; re-generating risks voice drift between homepage and `/faq` master). The skill chain generates `/faq` master's 10+ Q&As, of which 5 are the existing homepage subset, and 5+ are new (parking, services-offered, walk-in-vs-appointment, family-friendly, COVID-or-similar).

5. **What's the exact verification protocol for D-18 ROADMAP success criterion #1 (pixel-parity at desktop / 980px / 600px)?**
   - What we know: Phase 2 verification report has SC-3 still in "human_needed" status — visual fidelity awaits a human eye-test against `mockups/home-v5/index.html`.
   - What's unclear: whether Phase 3 ships with that human eye-test still pending, or whether Phase 3's per-page parity verification on `/` clears it.
   - Recommendation: **Phase 3 ships with `index.astro` matching `dev-mockup-parity.astro` exactly except for populated FAQ.** Since Phase 2's parity verification is structural (auto-passed) and visual (human-pending), Phase 3 inherits that. The verification gate is: "open `/` and `/dev-mockup-parity` side-by-side at 1440 / 980 / 600; FAQ block content differs, everything else identical." After verification commit, delete `dev-mockup-parity.astro` per D-20.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Node.js | Astro build | ✓ | 25.9.0 (>= required 22.12.0) | — |
| npm | Package management | ✓ | 11.12.1 | — |
| Astro | Page builds | ✓ | 6.3.0 | — |
| firecrawl CLI | Reviews + competitor scraping | ✓ | 1.12.2 (authenticated, 4,355 / 5,000 credits) | If credits depleted: skip extraction, ship with D-10 / D-14 placeholder/archetype paths |
| marketing-skills:product-marketing-context | One-time setup | ✓ | latest (in `~/.claude/plugins/marketplaces/marketingskills/skills/product-marketing-context/`) | Manual writing of `.agents/product-marketing-context.md` from `inputs/00-brief.md` + vault sources — but D-02 no-review-gate breaks down without skill anchoring; would need manual review reinstated |
| marketing-skills:ai-seo | One-time AEO frame | ✓ | latest (in `~/.claude/plugins/marketplaces/marketingskills/skills/ai-seo/`) | Manual writing of `.agents/aeo-frame.md` from `inputs/02-aeo-constraints.md` |
| marketing-skills:copywriting | Per-page copy generation | ✓ | latest (in `~/.claude/plugins/marketplaces/marketingskills/skills/copywriting/`) | Manual writing per page — same caveat as product-marketing-context fallback |
| Vault path: `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` | product-marketing-context input (D-03) | [check at execution time] | — | Use only `inputs/00-brief.md` if vault not accessible — but loses strategic AEO depth (D-03 explicit) |
| `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` | Cost guide format rationale (D-12) | [check at execution time] | — | Use only `inputs/02-aeo-constraints.md`; no impact on Phase 3 deliverables since D-12 is locked |
| `mockups/home-v5/index.html` | Homepage parity reference (D-18) | ✓ | committed in repo (md5 75e4749bbe4c9e2d4993bfa6744d3cdc per Phase 2 D-01) | — |
| Browser DevTools | Visual parity verification at 980/600px breakpoints | [user environment] | — | Playwright snapshot diff tooling not currently configured; visual diff is a manual human gate |

**Missing dependencies with no fallback:**
- None. All blocking dependencies are available.

**Missing dependencies with fallback:**
- Vault paths (`~/Documents/DT Vault/...`) — accessible on user's machine; if executor can't read them, plan asks user to confirm content or quote relevant sections.

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None — no unit/integration test runner installed in `site/`. Phase 3 verification is a combination of (a) `npm run build` exit code, (b) `grep` audits of `dist/` output for AEO-load-bearing markup, (c) human visual eye-test for `/` parity. |
| Config file | n/a |
| Quick run command | `cd site && npm run build` (build is the test in this phase) |
| Full suite command | `cd site && npm run build && grep -rE "client:load\|client:idle\|client:visible\|client:only" src/ \|\| echo "OK no client:* directives"` |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| PAGE-01 | `/` matches mockup at desktop / 980 / 600 | manual visual | open `http://localhost:4321/` and `mockups/home-v5/index.html` side-by-side | n/a (human gate) |
| PAGE-01 | `/` builds without errors | smoke (build) | `cd site && npm run build` | ❌ Wave 0 (verification gate) |
| PAGE-02 | `/east-county-traditional-barbershop` exists, returns 200, has 6 FAQ Q&As as flat H3/p | smoke + grep | `npm run build && grep -c '<article class="faq-q">' site/dist/east-county-traditional-barbershop/index.html` (expect 6) | ❌ Wave 0 |
| PAGE-02 | areaServed list visible in DOM (5 neighborhood links) | grep | `grep -oE '<a[^>]*href="/[a-z-]+-barber"' site/dist/east-county-traditional-barbershop/index.html \| sort -u \| wc -l` (expect 5) | ❌ Wave 0 |
| PAGE-03 | Cost guide cross-links to all 6 service slugs + 5 neighborhood slugs | grep | post-build grep against canonical 11-slug list (see Pitfall 6) | ❌ Wave 0 |
| PAGE-03 | Cost guide has 4–6 entry cards | grep | `grep -c '<article class="entry"' site/dist/2026-east-county-barbershop-cost-guide/index.html` (expect ≥ 4) | ❌ Wave 0 |
| PAGE-04 | `/about` mentions Joe Denesowicz and Alex in plain text | grep | `grep -E "Joe Denesowicz\|Alex" site/dist/about/index.html \| wc -l` (expect ≥ 2) | ❌ Wave 0 |
| PAGE-04 | Portrait placeholders exist with `data-pending-photo` markers | grep | `grep -c 'data-pending-photo' site/dist/about/index.html` (expect 2) | ❌ Wave 0 |
| PAGE-05 | `/reviews` shows pulled-quote highlights from Google + Yelp | grep | `grep -E "Google\|Yelp" site/dist/reviews/index.html` (expect both labels) | ❌ Wave 0 |
| PAGE-05 | `/reviews` has 6–8 review cards | grep | `grep -c '<article class="review-card"' site/dist/reviews/index.html` (expect 6–8) | ❌ Wave 0 |
| PAGE-06 | `/faq` has 10+ visible Q&As | grep | `grep -c '<article class="faq-q">' site/dist/faq/index.html` (expect ≥ 10) | ❌ Wave 0 |
| All pages | BLUF appears in first ~100 words | grep + manual | `head -120 site/dist/{page}/index.html` and inspect for BLUF | ❌ Wave 0 (sampled) |
| All pages | No `client:*` directives | grep | `grep -rE "client:(load\|idle\|visible\|only)" site/src/pages/` (expect 0 matches) | ❌ Wave 0 |
| All pages | No banned anti-pattern phrases | grep | `grep -irE "we're more than\|experience the difference\|click here\|innovate" site/src/pages/` (expect 0 matches) | ❌ Wave 0 |
| All pages | No tabs / accordions | grep | `grep -rE "<details>\|aria-expanded\|tab-panel" site/src/pages/` (expect 0 matches) | ❌ Wave 0 |
| `/` | dev-mockup-parity.astro deleted | filesystem | `test ! -f site/src/pages/dev-mockup-parity.astro && echo OK` | ❌ Wave 0 (final cleanup task) |

### Sampling Rate

- **Per task commit:** `cd site && npm run build` (must exit 0); plus the page-specific grep audits from the table above.
- **Per wave merge:** all grep audits across all touched pages.
- **Phase gate (before `/gsd-verify-work`):** full suite, including human visual parity check on `/`.

### Wave 0 Gaps

There is no Jest/Vitest framework in this project — Phase 3 doesn't introduce one. The verification surface is `npm run build` + grep audits. **Plan should NOT add a test framework in Phase 3** — that's a separate decision. If a future phase wants Playwright snapshot diff for parity, that's its own scope.

- [ ] No new test files needed.
- [ ] No new test fixtures needed.
- [ ] Framework install: not required.

*Existing test infrastructure (build + grep) covers all Phase 3 requirements.*

## Project Constraints (from CLAUDE.md)

The repo CLAUDE.md and the user's global CLAUDE.md add constraints the planner must honor.

### From `/Users/darrelltang/dtconsulting/joesbarbershop/CLAUDE.md`:

- **Tech stack:** Astro — zero-JS-by-default, data-driven content collections, no Tailwind. **Phase 3 honors this; no `client:*` directives, no Tailwind utility classes, all CSS lives in `tokens.css` / `utilities.css` / per-component scoped `<style>` blocks.**
- **Hosting:** Vercel preview URLs. **Phase 6 ships the preview URL; Phase 3 does not deploy.**
- **Design fidelity:** Preserve the OD-5 design exactly — port existing OD-generated CSS, no Tailwind migration. **Phase 3 reuses Phase 2's components and tokens; introduces no new visual primitives beyond what UI-SPEC explicitly defines.**
- **Photo set:** Limited to 6 existing photos. Additional photos require permission + visit. **Phase 3 about page uses CSS placeholder per D-07.**
- **AEO structural rules:** BLUF first 100 words, no hidden content, FAQ flat text, schema on every page (per `inputs/02-aeo-constraints.md`). **Phase 3 enforces all rules except schema (deferred to Phase 5).**
- **No live deployment** before Joe approves the showcase. **Phase 3 ships to Vercel preview only via Phase 6.**
- **No edits to Joe's external surfaces** (GBP, Yelp, Booksy). **Phase 3 reads (scrapes) public surfaces but does not edit them.**
- **No duplication of vault content in this repo.** **Phase 3 reads `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` for product-marketing-context, but does NOT copy its content into the repo. Skill output goes to `.agents/`, which is a thin reference, not a duplication of the vault.**
- **GSD Workflow Enforcement:** Use `/gsd-execute-phase` for planned phase work; do not make direct repo edits outside a GSD workflow. **Phase 3 work happens through `/gsd-execute-phase` end-to-end.**

### From `~/.claude/CLAUDE.md`:

- **Git Commits:** Use short, single-line commit messages. No commit body. **D-05 already specifies this for Phase 3 atomic per-page commits.**
- **No commit body or extended description.** No Claude Code attribution footer or Co-Authored-By line. **Plan must not include these in commit message templates.**
- **Validate changes through primary interaction pattern before committing.** **Phase 3 primary interaction = `npm run dev` + browser; verify visible before commit.**
- **Tables, diagrams, and lists preferred over prose** in documentation. **Plan task descriptions follow this style.**
- **No unnecessary comments — code should be self-documenting.** **`.astro` page files use minimal in-code comments; the UI-SPEC is the documentation, not inline comments.**
- **Practical, working solutions over abstract patterns.** Don't over-engineer. **D-22 Discretion: don't add `<UniquePageLayout>` wrapper — direct `Base.astro` use is the simpler answer.**

## Sources

### Primary (HIGH confidence)

- [VERIFIED: ./CLAUDE.md] - project instructions, tech stack, AEO structural rules
- [VERIFIED: .planning/REQUIREMENTS.md] - PAGE-01..06 spec
- [VERIFIED: .planning/ROADMAP.md] - Phase 3 success criteria
- [VERIFIED: .planning/phases/03-unique-pages/03-CONTEXT.md] - D-01..D-22 locked decisions
- [VERIFIED: .planning/phases/03-unique-pages/03-UI-SPEC.md] - approved visual contract for all 6 pages + 5 new layouts
- [VERIFIED: .planning/phases/02-data-design-system/02-CONTEXT.md] - Phase 2 carry-forward (D-25 Base.astro section ordering, D-26 head slot)
- [VERIFIED: .planning/phases/02-data-design-system/02-VERIFICATION.md] - Phase 2 4/5 truths verified, SC-3 human-needed
- [VERIFIED: site/src/pages/dev-mockup-parity.astro] - working homepage composition template
- [VERIFIED: site/src/components/Hero.astro, FAQ.astro, Visit.astro, ClosingCTA.astro] - established Astro patterns
- [VERIFIED: site/src/data/business.{json,ts}] - canonical data layer with `_showcase_review_pending` array
- [VERIFIED: site/src/styles/{tokens,utilities}.css] - design tokens and shared atoms
- [VERIFIED: site/package.json + npm list 2026-05-07] - astro 6.3.0, @astrojs/sitemap 3.7.2, @astrojs/vercel 10.0.6
- [VERIFIED: ~/.claude/plugins/marketplaces/marketingskills/skills/product-marketing-context/SKILL.md] - skill input/output contract
- [VERIFIED: ~/.claude/plugins/marketplaces/marketingskills/skills/ai-seo/SKILL.md] - AEO/AI-SEO skill description, content patterns, Princeton GEO research stats
- [VERIFIED: ~/.claude/plugins/marketplaces/marketingskills/skills/copywriting/SKILL.md] - copywriting skill output format
- [VERIFIED: ~/.claude/skills/firecrawl/SKILL.md] - workflow escalation pattern, parallelization, output organization
- [VERIFIED: ~/.claude/skills/firecrawl-scrape/SKILL.md] - scrape options, --only-main-content, --wait-for
- [VERIFIED: ~/.claude/skills/firecrawl-agent/SKILL.md] - agent for autonomous structured extraction
- [VERIFIED: ~/.claude/skills/firecrawl-browser/SKILL.md] - DEPRECATED notice, use scrape + interact instead
- [VERIFIED: `firecrawl --status` 2026-05-07] - 4,355 / 5,000 credits, authenticated
- [CITED: https://docs.astro.build/en/reference/modules/astro-assets/ via ctx7 fetch] - `<Image>` and `<Picture>` component contracts
- [CITED: inputs/00-brief.md] - audience, tone, anti-prompts, photo notes, voice
- [CITED: inputs/01-page-list.md] - 17–19 page architecture, schema priority per page
- [CITED: inputs/02-aeo-constraints.md] - load-bearing AEO rules: BLUF, 130–160 word capsules, declarative tone, no tabs/accordions, no text-as-image, anti-pattern phrases
- [CITED: inputs/03-photo-notes.md] - 6 photos catalog and primary use per page

### Secondary (MEDIUM confidence)

- [VERIFIED: WebSearch 2026-05-07 "Joe's Barbershop El Cajon Bostonia 723 E Bradley Yelp Google reviews"] - Joe's Yelp URL `joe-s-barbershop-el-cajon` (with hyphen), 4.9★ ratings confirmed across surfaces
- [VERIFIED: WebSearch 2026-05-07 "East County San Diego barbershops El Cajon Bostonia haircut prices 2026"] - East County competitor names: Ducky's, Refined Barber, Faded Barbershop, Clipper Crew, T25, Zeyad's Gentlemen's; Booksy + Yelp + Fresha as discovery surfaces

### Tertiary (LOW confidence)

- None.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all tooling (Astro 6.3.0, firecrawl 1.12.2, marketing-skills, Node 25, npm 11) verified installed and working in this session.
- Architecture: HIGH — Phase 1 + 2 outputs verified in `site/src/`; Phase 3 patterns derive directly from Phase 2 working examples + UI-SPEC's pre-approved visual contracts.
- Pitfalls: HIGH — pitfalls 1, 5, 6, 7, 8 derived from CONTEXT.md decisions + Phase 2 verification report; pitfall 2 verified via WebSearch; pitfalls 3, 4 derived from documented user constraints.
- Skill chain invocation: MEDIUM-HIGH — three SKILL.md files read verbatim; one assumption (A1) about copywriting auto-discovering aeo-frame is flagged.
- Firecrawl extraction: MEDIUM — CLI verified, scrape primary path locked, but Yelp/Google bot-detection behavior at scrape time is empirical (3-attempt budget + D-10/D-14 fallback path mitigates).

**Research date:** 2026-05-07
**Valid until:** 2026-06-07 (stable framework + locked design system; firecrawl behavior may shift if Yelp/Google change anti-bot heuristics)
