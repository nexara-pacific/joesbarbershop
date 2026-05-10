# Phase 5: AEO + Performance + Meta - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-10
**Phase:** 5-aeo-performance-meta
**Areas discussed:** Telemetry Timing, Schema Body + Entity Architecture, Freshness + dateModified, Meta + OG + Verification

---

## Pre-discussion vault sweep

User redirected the first gray-area selection to ask: "What about the AEO research and tools in the vault? Microsoft Clarity, other tools that were suggested?"

Pulled the following vault docs via `qmd`:
- `vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` — NotebookLM-verified 2026-05-04 (25-source corpus). Load-bearing for Phase 5.
- `vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — Joe-specific audit baseline + E9 spec.
- `vault/1-projects/dt-consulting-llc/joes-visual-direction.md` — visual narrative (Phase 3/4 territory).
- `vault/1-projects/dt-consulting-llc/rank-and-rent-landscape-briefing.md` — broader strategy context.

**Key findings that shifted Phase 5 scope:**
- Schema body gaps: playbook reference example includes geo/priceRange/E.164-phone/openingHoursSpecification/aggregateRating that `business.json` doesn't have today.
- `llms.txt` is "essentially worthless" — two large studies show zero correlation; removing improves citation-prediction model accuracy.
- `dateModified` on Article-schema pages is load-bearing for freshness.
- Microsoft Clarity + Vercel Web Analytics + Vercel Speed Insights are the trivial 1-line on-site tools recommended in playbook § 7. User's hint that "Clarity was a recommendation" surfaced the timing question: leave in Phase 7 (current ROADMAP) or absorb into Phase 5.

---

## Telemetry Timing

| Option | Description | Selected |
|--------|-------------|----------|
| Move to Phase 5 | All three (Clarity + Vercel Analytics + Speed Insights) wire in Phase 5 Base.astro. Telemetry fires Day-0 of showcase. Phase 7 keeps Search Console verification, CallRail, LocalFalcon, manual prompt panel, baseline capture. | ✓ |
| Keep ROADMAP as-is | Phase 7 owns all measurement per current ROADMAP; Phase 5 stays narrowly schema+perf+meta. | |
| Move only Clarity | Just Microsoft Clarity in Phase 5; Vercel tools stay in Phase 7. | |

**User's choice:** Move to Phase 5 (Recommended).
**Notes:** User explicitly flagged that "microsoft clarity was a recommendation" from vault research. The cleaner Phase-5/Phase-7 split (Phase 5 = on-site instrumentation, Phase 7 = external measurement + baseline) emerged from synthesizing playbook § 7 with the existing ROADMAP boundaries.

### Follow-up: Clarity Config

| Option | Description | Selected |
|--------|-------------|----------|
| Env var via Vercel | `PUBLIC_CLARITY_PROJECT_ID` in Vercel project settings + `.env.example`. Astro reads via `import.meta.env`. PROD-only via `import.meta.env.PROD` guard. | ✓ |
| Hard-coded constant | Paste Clarity ID directly in Base.astro. | |
| Create Clarity account during Phase 5 | Wire script with placeholder; create dashboard during execution. | |

**User's choice:** Env var via Vercel (Recommended).
**Notes:** Implicitly assumes Clarity account is created during Phase 5 execution (operator creates at clarity.microsoft.com, sets `PUBLIC_CLARITY_PROJECT_ID` in Vercel before Phase 6 deploys).

---

## Schema Body + Entity Architecture

### Q1: business.ts Expansion

| Option | Description | Selected |
|--------|-------------|----------|
| Expand to playbook-grade | Add geo lat/long + E.164 phone helper + priceRange + openingHoursSpecification array helper + aggregateRating helper. Matches playbook reference example end-to-end. | ✓ |
| MVP first, expand later | Emit JSON-LD with what business.json has today; add missing fields in v1.5 if measurement shows gaps. | |
| Hybrid (geo + E.164 + priceRange now; defer aggregateRating + openingHoursSpecification) | Quick lookups/format changes now; defer freshness-sensitive ratings + holiday-aware hours. | |

**User's choice:** Expand to playbook-grade (Recommended).

### Q2: Schema Architecture

User initially asked for clarification: "Why hairsalon? This isn't a hair salon."

Claude clarified: HairSalon is a Schema.org type (invisible JSON-LD), not a marketing label. Schema.org has no `BarberShop` type; HairSalon (HealthAndBeautyBusiness → HairSalon) is the most specific subtype for a barbershop. Google Rich Results explicitly supports it. The human-facing word "barbershop" stays in all copy. Playbook (`aeo-playbook-smb.md` § 10) confirms this priority: "FAQPage → HairSalon → LocalBusiness → Service → Person → sameAs."

| Option | Description | Selected |
|--------|-------------|----------|
| Auto-inject baseline + per-page overlays | Base.astro auto-emits HairSalon with `@id` for entity dedup; pages add page-specific schemas via `<slot name="head" />`. | ✓ |
| Per-page explicit imports | Each page imports exactly what it needs; more verbose, risk of forgetting identity block. | |
| Single SchemaPack component per page-type | One component decides emissions based on pageType prop. | |

**User's choice:** Auto-inject baseline + per-page overlays (Recommended).

### Q3: aggregateRating Placement

| Option | Description | Selected |
|--------|-------------|----------|
| Homepage only | aggregateRating block (Google + Yelp) in homepage HairSalon JSON-LD only. /reviews emits its own Review array. | ✓ |
| On every page in auto-injected HairSalon | Maximalist; site-wide consistency. | |
| Defer aggregateRating to v1.5 | Skip Phase 5; revisit when ratings-refresh policy exists. | |

**User's choice:** Only on homepage (Recommended).

---

## Freshness + dateModified

### Q1: dateModified Source

| Option | Description | Selected |
|--------|-------------|----------|
| Git mtime at build time | Astro hook reads `git log -1 --format=%cI <file>`; auto-updates on edit; zero manual upkeep. | ✓ |
| Hand-set per page in frontmatter | Each page has `dateModified` field; depends on discipline. | |
| Build-time constant (today's date) | All Article schemas get same dateModified = build timestamp. | |
| Skip dateModified for v1 | Defer to v1.5. | |

**User's choice:** Git mtime at build time (Recommended).

### Q2: Visible "Last updated" Stamp

| Option | Description | Selected |
|--------|-------------|----------|
| Visible stamp on cost guide + niche-landing | Small "Last updated: YYYY-MM-DD" line on the two Article-schema pages; same git-mtime source. | ✓ |
| Schema-only, no visible stamp | Date in JSON-LD only; cleaner visual. | |
| Visible stamp on every page | Footer or page-meta line on all 17 pages. | |

**User's choice:** Visible stamp on cost guide + niche-landing (Recommended).

---

## Meta + OG + Verification

### Q1: Title Format

| Option | Description | Selected |
|--------|-------------|----------|
| "Topic \| Joe's Barbershop" | Standardized suffix; homepage gets unique format. | ✓ |
| "Topic in El Cajon \| Joe's Barbershop" | Add city suffix for stronger local query matching. | |
| No suffix — each page picks its own title | Most flexible; loses brand reinforcement. | |

**User's choice:** "Topic \| Joe's Barbershop" (Recommended).

### Q2: Description Authoring

| Option | Description | Selected |
|--------|-------------|----------|
| Derive from collection BLUF for templated; hand-author for unique pages | Service + neighborhood pages auto-derive; the 6 unique pages get crafted descriptions. | ✓ |
| Hand-author every description | Most control; most maintenance. | |
| Auto-derive everywhere | Zero maintenance; descriptions read as page content not CTAs. | |

**User's choice:** Derive from collection BLUF for templated pages, hand-author for unique pages (Recommended).

### Q3: Open Graph Image Strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Single shared OG image — 03-interior-hero.jpg | All pages share the homepage hero. | |
| Per-page-type | Services use 05-mid-cut.jpg; neighborhoods use 02-storefront.jpg; unique pages use their own hero. | |
| Per-page custom | Each page hand-picks an OG image. | |
| Skip Open Graph for v1 | Ship without OG/Twitter Card. | |

**User's choice:** Free-text — "defer this for now because I'm building out a lot of the infrastructure, but I do not have original assets from Joe. He said he would be able to get me better pictures. Eventually, in the future, I think we'll have a bunch of pictures of haircuts that he's done as social proof as well. This can be put off until we have more information."

**Notes:** Claude interpreted as: defer the og:image specifically; still ship the cheap OG text tags (`og:title`, `og:description`, `og:url`, `og:type`, `og:site_name`) + Twitter `summary` card (no image). Upgrade to per-page-type OG images + `summary_large_image` in v1.5 when Joe sends new photos. Confirmed in CONTEXT.md D-15.

### Q4: Verification Approach

| Option | Description | Selected |
|--------|-------------|----------|
| Hybrid — scripted what's scriptable, manual the rest | Extend audit.sh with JSON-LD validator + sitemap check + robots.txt presence + text-as-image heuristic; manual `npx lighthouse` + Rich Results Test paste. | |
| Fully scripted (also runs Lighthouse via CLI) | Everything in audit.sh including Lighthouse CLI with thresholds as exit codes. | ✓ |
| Fully manual checklist | Human runs checks per page; no repeatability. | |

**User's choice:** Fully scripted (also runs Lighthouse via CLI).
**Notes:** Means planner needs to handle Lighthouse first-run flakiness — likely median-of-3 invocations or `--throttling=devtools` for consistency. Manual Rich Results Test paste retained as final eyeball gate per D-25 (not a CI block).

---

## Claude's Discretion

Captured in CONTEXT.md `<decisions>` § "Claude's Discretion". Notable items:
- Exact Astro integration mechanism for git mtime → dateModified
- Schema component file shape (props API)
- JSON-LD validator implementation
- Lighthouse CLI runtime strategy (local preview vs Vercel preview)
- Median-of-N for Lighthouse stability
- robots.txt per-bot policy (default allow-all)
- Font preload decision (default keep CDN preconnect; preload only if LCP fails)
- CLS fallback (default `display=swap`; `font-display: optional` only if CLS > 0.1)
- `llms.txt` — default skip per playbook
- Twitter handle (omit `twitter:site` since Joe has no known account)
- Geocoding source for lat/long
- `priceRange` symbol count (`"$$"`)

---

## Deferred Ideas

Captured in full in CONTEXT.md `<deferred>` section. Highlights:
- Wikidata Q-number + sameAs (v2 — AEO-09)
- Booksy / Foursquare / Bing Places (v2 — off-site)
- Search Console + Bing Webmaster verification (Phase 7 — needs real domain)
- CallRail / LocalFalcon / manual prompt panel / hire-trigger doc (Phase 7)
- Counter-card QR + /welcome?src=qr (Phase 7)
- Per-page-type OG images + Twitter `summary_large_image` (v1.5 — pending Joe's photos)
- Custom domain + @id URL update (v1.5)
- Site-wide `dateModified` (Phase 7 decides based on measurement)
- FAQ-rotation freshness cadence (Phase 7 + operational)
- Self-hosting Google Fonts (perf-conditional)
- `llms.txt` (default skip per vault research)
- REQUIREMENTS.md note that Phase 5 absorbs MEAS-01 + MEAS-02 on-site portions — needs `/gsd-transition` after Phase 5 ships to update traceability table.
