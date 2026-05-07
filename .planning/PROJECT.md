# Joe's Barbershop — AEO-Optimized Website

## What This Is

The deployable website for Joe's Barbershop (Bostonia, El Cajon CA) — a 17–19 page, AEO-optimized site built in Astro, deployed to Vercel as a preview URL for Joe to review before any cutover. Replaces the current empty Square Site (`joe-104613.square.site`).

## Core Value

Win AI-assistant citations and Google AI Mode visibility for "barbershop in East County / El Cajon" queries while reading as the authentic strip-mall heritage shop Joe runs — so Joe approves the site, customers find him through ChatGPT/Perplexity/Google, and the build itself becomes a documented case study for productizing the AEO-Hub Site offer.

## Requirements

### Validated

<!-- Shipped and confirmed valuable. -->

- [x] Astro project scaffolded with TypeScript strict mode (Phase 01) — `site/` directory, Astro 6.3, base layout + stub components + 2 pages, deployed to Vercel preview URL `https://site-psi-liard.vercel.app`. Content collections deferred to Phase 02.

### Active

<!-- Current scope. Building toward these. -->

- [ ] Single source of truth via Astro content collections (`src/content/`)
- [ ] Single `src/data/business.ts` source of truth (NAP, hours, prices, ratings, sameAs links)
- [ ] OD-5 homepage design preserved exactly (heritage typography, checker motif, letter-board pricing) — no Tailwind migration
- [ ] Homepage rendered from Astro components, parity with `mockups/home-v5/index.html`
- [ ] `/east-county-traditional-barbershop` niche-query landing
- [ ] 6 service pages (Fades, Kids Cuts, Hot-Towel Shave, Beard Trim, Line-up, Classic Cut) generated from one template + content collection
- [ ] 5 neighborhood pages (Bostonia, El Cajon, Santee, Lakeside, La Mesa) generated from one template + content collection
- [ ] Cost guide (`/2026-east-county-barbershop-cost-guide`) — comparative listicle format
- [ ] FAQ, About, Reviews pages
- [ ] JSON-LD schema on every page (HairSalon, FAQPage, Service, Person, LocalBusiness, sameAs) generated from `business.ts`
- [ ] BLUF first 100 words on every page; no tabs/accordions hiding content; FAQ as flat text
- [ ] Images optimized via Astro `<Image />` (AVIF/WebP, srcset, lazy-load below-fold)
- [ ] Mobile responsive parity with the OD-5 mockup
- [x] Vercel preview URL deployed (Phase 01 — `https://site-psi-liard.vercel.app`)
- [ ] Joe approval secured on the showcased site

### Out of Scope

<!-- Explicit boundaries. Includes reasoning to prevent re-adding. -->

- Square Site replacement / GBP website-link cutover — separate post-approval phase, not part of v1
- Custom domain registration — Vercel preview URL is sufficient until Joe approves; domain is a v1.5 step
- Paid CMS or admin UI — Joe doesn't edit; updates go through the repo
- Booking system replacement — keep linking to existing Square booking widget
- Wikidata Q-number registration — separate off-site task, doesn't block site launch
- Foursquare / Bing Places claim — separate off-site task, doesn't block site launch
- Reddit / Medium off-site content — separate post-launch task
- New photography / in-shop photo shoot — 6 existing photos in `inputs/photos/` are sufficient for v1
- Re-generating pages in Open Design beyond the locked OD-5 homepage — additional pages are coded directly in Astro from data
- Strategy / audit / playbook / methodology content in this repo — those live in the vault

## Context

- This repo is the **application** of strategy already developed elsewhere — not a duplicate of it. Vault is the knowledge base; this repo is the deployable.
- Vault references most relevant to this build (don't duplicate, link):
  - `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md` — audit baseline + sandbox experiment log
  - `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-visual-direction.md` — strategic visual narrative
  - `~/Documents/DT Vault/1-projects/dt-consulting-llc/aeo-playbook-smb.md` — AEO mechanics, NotebookLM-validated 2026-05-04
  - `~/Documents/DT Vault/1-projects/dt-consulting-llc/audit-baseline-recipe.md` — methodology
- Joe's locked design: `mockups/home-v5/index.html` (Open Design iteration 5, confirmed by user 2026-05-06)
- Build inputs in `inputs/` (point Open Design here for iterations): brief, page list, AEO constraints, photo notes, 6 photos
- Joe (Joe Denesowicz) hasn't seen any of this yet — the deployed Vercel preview IS the pitch artifact
- Joe's current online presence: Square Site (essentially empty), GBP managed (4.9★ / ~91 reviews), Yelp (4.9★ / 33 reviews / 102 photos), no Booksy listing, unmanaged Fresha listing
- Joe's brand asset (Western/Victorian heritage logo, ESTD. 2020) is already established and is the design anchor
- Audience: East County working-class Latino + Anglo demographic, family-friendly, walk-ins welcome, cash-only positioning

## Constraints

- **Tech stack**: Astro — zero-JS-by-default aligns with AEO requirements (parsers see all content); data-driven content collections eliminate duplication across the 11 templated pages
- **Hosting**: Vercel — established precedent in `~/dtconsulting/john-olsen-mockup/`; preview URLs support pre-approval showcase model
- **Design fidelity**: Preserve the OD-5 design exactly — port existing OD-generated CSS, no Tailwind migration
- **Photo set**: Limited to 6 existing photos in `inputs/photos/` for v1 — additional photos require Joe's permission and an in-shop visit
- **AEO structural rules**: BLUF first 100 words, no hidden content, FAQ as flat text, schema on every page (per `inputs/02-aeo-constraints.md`)
- **No live deployment** before Joe approves the showcase
- **No edits to Joe's external surfaces** (GBP, Yelp, Booksy, etc.) as part of this build
- **No duplication of vault content** in this repo

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| Astro over Next.js or vanilla HTML | Zero-JS-by-default = AEO-correct; data-driven content collections match 17–19 page architecture; eliminates duplication across templated pages | — Pending |
| Vercel hosting | Existing precedent in the dtconsulting workspace; preview URLs support pre-approval showcase model | — Pending |
| Keep OD-generated CSS (no Tailwind migration) | Preserves design exactly; lower migration risk; OD-5 is the locked design | — Pending |
| Showcase to Joe before any GBP cutover | Joe sees a polished site without committing him; reduces approval risk | — Pending |
| All 17–19 pages in v1 (not staged) | Realizes the AEO compounding effect at launch; data-driven templates make this feasible | — Pending |
| Schema generated from `src/data/business.ts` (single source of truth) | NAP/hours/prices across pages stay consistent without drift | — Pending |
| Photos set limited to 6 existing | Avoids blocking on Joe permissions / in-shop visit; sufficient for v1 visual coverage | — Pending |
| Strategy/playbook/learnings stay in vault, NOT this repo | Repo is the deployable; vault is the knowledge base; no duplication | — Pending |

## Evolution

This document evolves at phase transitions and milestone boundaries.

**After each phase transition** (via `/gsd-transition`):
1. Requirements invalidated? → Move to Out of Scope with reason
2. Requirements validated? → Move to Validated with phase reference
3. New requirements emerged? → Add to Active
4. Decisions to log? → Add to Key Decisions
5. "What This Is" still accurate? → Update if drifted

**After each milestone** (via `/gsd-complete-milestone`):
1. Full review of all sections
2. Core Value check — still the right priority?
3. Audit Out of Scope — reasons still valid?
4. Update Context with current state

---
*Last updated: 2026-05-07 after Phase 01 (scaffold) completion*
