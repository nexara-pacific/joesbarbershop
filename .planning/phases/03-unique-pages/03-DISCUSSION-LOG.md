# Phase 3: Unique Pages - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-07
**Phase:** 3-unique-pages
**Areas discussed:** Copy authoring workflow, About + Reviews sourcing, Cost guide format (PAGE-03), Page composition strategy

---

## Copy Authoring Workflow

### Q1 — Overall copy authoring approach

| Option | Description | Selected |
|--------|-------------|----------|
| Marketing-skills chain (Recommended) | Run product-marketing-context once + ai-seo once at start, then copywriting per page. | ✓ |
| Hand-write every page | Skip the skills chain. User drafts each page directly. | |
| AI-draft inline (no skills) | Claude drafts copy directly per page during execution, no skills plugins. | |
| Mix: skills for templates, hand-write hero | Skills for niche-landing/cost guide/FAQ/reviews/about; hand-write homepage hero to preserve OD-5 mockup tuning. | |

**User's choice:** Marketing-skills chain
**Notes:** Aligns with D-16 from Phase 2 CONTEXT.md.

---

### Q2 — Review gate

| Option | Description | Selected |
|--------|-------------|----------|
| Per-page review gate (Recommended) | After each page's skill output, user reviews before commit. | |
| Batch all 6, review at end | Skills generate all 6, review at the end. | |
| Trust the skills, no manual review | Skills run, output committed directly, user reviews on Vercel preview. | ✓ |
| Per-page gate for unique copy, batch the FAQ list | Hybrid — review the unique pages individually, batch the FAQ list. | |

**User's choice:** Trust the skills, no manual review
**Notes:** User explicitly chose speed/trust. Implication captured in CONTEXT D-02 — no second checkpoint, so skills must be configured carefully.

---

### Q3 — `product-marketing-context` source

| Option | Description | Selected |
|--------|-------------|----------|
| inputs/00-brief.md + business.json (Recommended) | Self-contained in repo, no vault dependency. | |
| Vault audit baseline + brief | Audit baseline + brief together for strategic depth. | ✓ |
| Brief + vault + voice guides | Add voice guides as hard inputs. | |
| Brief only, keep it tight | Just the brief. | |

**User's choice:** Vault audit baseline + brief
**Notes:** Captured in CONTEXT D-03. Voice guides relegated to advisory / escalation per Deferred Ideas — added to `product-marketing-context` only if voice drift is detected post-Phase 3.

---

### Q4 — `marketing-skills:ai-seo` plugin pattern

| Option | Description | Selected |
|--------|-------------|----------|
| Run once, output codified into context (Recommended) | Single run, output stored as a reference doc. | |
| Run per page | 6× invocations, fresh AEO analysis per page. | |
| Skip ai-seo — inputs/02-aeo-constraints.md is enough | Pass constraints directly to copywriting. | |
| Run once + per-page primary query injection | Single global frame + per-page primary query handed to copywriting. | ✓ |

**User's choice:** Run once + per-page primary query injection
**Notes:** Captured in CONTEXT D-01 + D-04. Primary queries per page enumerated.

---

## About + Reviews Sourcing

### Q1 — `/about` content

| Option | Description | Selected |
|--------|-------------|----------|
| Skill-drafted bios + staged photo placeholders (Recommended) | Marketing-skills drafts bios; placeholder portrait blocks until photos arrive. | ✓ |
| Names only, no bio yet | Sparse page, names + role labels only. | |
| Skip /about until showcase | Coming-soon stub; would fail ROADMAP success criterion #4. | |
| Hand-write the bios yourself | User writes bios directly. | |

**User's choice:** Skill-drafted bios + staged photo placeholders
**Notes:** Photo placeholders use `data-pending-photo` markers (new pattern, mirrors Phase 2's `data-phase1-stub`). Bios + photo-pending entries appended to `business.json`'s `_showcase_review_pending` list.

---

### Q2 — `/reviews` quote sourcing

| Option | Description | Selected |
|--------|-------------|----------|
| Pull live from Yelp public surface (Recommended) | Yelp-only scrape. | |
| Pull from Google + Yelp | Both surfaces. | |
| Placeholder review cards — Joe curates at showcase | Layout only, content TBD. | |
| Hardcode 4-6 reviews from existing GBP scrape | Quick manual pull. | |

**User's choice:** Free-text — "We'll probably need to use Firecrawl or some other way to get around the bot automation issue. I'd like to pull live from both Google reviews and Yelp if we can. Otherwise we can put placeholders for now while I figure out how to extract that information."
**Notes:** Captured in CONTEXT D-08 (primary path: Firecrawl Google + Yelp), D-10 (fallback: placeholder cards with `_showcase_review_pending` flagging). Bot-detection on Google Maps explicitly acknowledged as unreliable; Firecrawl retry budget noted in Specifics.

---

## Cost Guide Format (PAGE-03)

### Q1 — Cost guide structural shape

| Option | Description | Selected |
|--------|-------------|----------|
| Comparative listicle: Joe + 4-6 East County competitors (Recommended) | Long-form listicle naming real competitors. | ✓ |
| Service-by-service cost breakdown (no competitor names) | H2 per service with generic market context. | |
| Decision-tree-style 'How much should you pay?' | Article framed around buying decisions. | |
| Comparison table + per-service H2s | Table + depth hybrid. | |

**User's choice:** Comparative listicle: Joe + 4-6 East County competitors
**Notes:** Captured in CONTEXT D-12. Anchored to `aeo-playbook-smb.md`'s 32.5% citation-lift evidence for comparative content.

---

### Q2 — Competitor data source

| Option | Description | Selected |
|--------|-------------|----------|
| Firecrawl GBP / Yelp for top East County barbershops (Recommended) | Same scraping pattern as reviews page. | ✓ |
| Vault audit baseline (if it has competitor data) | Reuse prior research if available. | |
| Generic 'East County barbershop' archetypes (no real names) | Avoid naming competitors. | |
| Hybrid: 2-3 real names + 2-3 archetypes | Middle ground. | |

**User's choice:** Firecrawl GBP / Yelp for top East County barbershops
**Notes:** Captured in CONTEXT D-13 (primary) and D-14 (fallback to hybrid format if scrape yields fewer than 4 competitors).

---

### Q3 — Cross-link strategy

| Option | Description | Selected |
|--------|-------------|----------|
| Inline mentions + dedicated 'See also' block (Recommended) | Belt-and-suspenders approach. | ✓ |
| Inline mentions only | Cleaner reading, risk of missing links. | |
| Dedicated link grid only | All links in a grid, no inline. | |
| Skip cross-links — add in Phase 4 | Defer; would fail ROADMAP success criterion #3. | |

**User's choice:** Inline mentions + dedicated 'See also' block
**Notes:** Captured in CONTEXT D-15. Cross-link slug convention captured in D-16 — uses canonical Phase 4 slugs that 404 in Phase 3 builds and resolve in Phase 4.

---

## Page Composition Strategy

### Q1 — Component reuse pattern

| Option | Description | Selected |
|--------|-------------|----------|
| Reuse FAQ + ClosingCTA + Visit + dividers; bespoke body per page (Recommended) | Shared chrome + reusable atoms + bespoke body. | ✓ |
| Reuse everything aggressively (Hero on every page) | Maximum component reuse. | |
| Bespoke layouts per page, shared chrome only | Maximum flexibility per page. | |
| Article layout for /cost-guide + /faq + /east-county; full chrome for /about + /reviews | Two-pattern split. | |

**User's choice:** Reuse FAQ + ClosingCTA + Visit + dividers; bespoke body per page
**Notes:** Captured in CONTEXT D-17. Homepage-only components (Hero, FactStrip, PriceBoard, Heritage) explicitly walled off from non-homepage reuse.

---

### Q2 — Homepage build approach

| Option | Description | Selected |
|--------|-------------|----------|
| Pixel-parity port, exactly matching mockup (Recommended) | Composition exactly matches mockup. | |
| Mockup parity + a homepage FAQ block populated | Parity composition, FAQ populated with real Q&As. | ✓ |
| Mockup parity + featured-services strip linking to Phase 4 routes | Add internal-linking strip; deviates from mockup. | |
| Mockup parity + areaServed strip | Add neighborhoods strip; deviates from mockup. | |

**User's choice:** Mockup parity + a homepage FAQ block populated
**Notes:** Captured in CONTEXT D-18, D-19, D-20. The 5–6 homepage FAQ Q&As are a subset of the master `/faq` page's 10+. `dev-mockup-parity.astro` deletes after `index.astro` parity-verifies.

---

### Q3 — Niche-query landing structure (PAGE-02)

| Option | Description | Selected |
|--------|-------------|----------|
| Article header + BLUF + areaServed list + 6 FAQ + ClosingCTA (Recommended) | Article-shaped, no Hero photo. | ✓ |
| Hero (smaller) + same body structure | Hero with different copy + photo. | |
| Same composition as homepage minus PriceBoard/Heritage | Reuse most homepage components. | |
| Pure article: H1 → BLUF → H2 sections → FAQ | Stripped editorial format. | |

**User's choice:** Article header + BLUF + areaServed list + 6 FAQ + ClosingCTA
**Notes:** Captured in CONTEXT D-21. Page is prose-and-citation-driven; Hero photo would fight BLUF density.

---

## Claude's Discretion

Captured in CONTEXT.md `<decisions>` § Claude's Discretion. Includes:

- Exact prose phrasing (skills produce, executor commits).
- Whether to introduce a `UniquePageLayout` wrapper (recommend not to — one Base, many pages).
- Per-page metadata wording (Phase 5 owns the full meta suite).
- Skill output post-processing (markdown-to-Astro conversion if needed).
- Number of `H2`/`H3` sections beyond minimums (skills enforce 130–160 word capsule rule).
- Specific competitor names (depends on Firecrawl scrape outputs).
- Internal link anchor text wording.
- Exact `/about`, `/reviews`, `/faq` body skeletons (D-22 suggests; planner refines).

## Deferred Ideas

Captured in CONTEXT.md `<deferred>`. Highlights:

- Schema emission (Phase 5).
- Lighthouse perf + full meta tags + sitemap (Phase 5).
- Templated services + neighborhoods routes (Phase 4).
- Real Joe + Alex portrait photography (post-showcase / showcase visit).
- Mid-page ratings ribbon on homepage (rejected for parity; future iteration).
- Featured-services or areaServed strip on homepage (rejected for parity).
- Voice guides as hard skill input (escalation if voice drift detected).
- Cost guide Medium mirror (v2 OFFS-06).
- Booksy + Wikidata sameAs additions (v2).
- Square Site cutover / GBP website-link update (Phase 6 + post-showcase).
