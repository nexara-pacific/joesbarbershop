# Phase 2: Data + Design System - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-07
**Phase:** 02-data-design-system
**Areas discussed:** OD-5 mockup source, Photos directory, Content authoring depth, business.ts shape & data source

---

## OD-5 Mockup Source

### Q1: Where is the OD-5 mockup actually located, or does it need to be produced?

| Option | Description | Selected |
|--------|-------------|----------|
| It exists — I'll drop it in | OD-5 export lives outside the repo (vault, OD account, Downloads); user places files into `mockups/home-v5/` before Phase 2 executes. | |
| Needs to be re-generated in OD | OD-5 wasn't exported; user regens and exports from Open Design before Phase 2 starts. | |
| Build directly in Astro from `inputs/` | Skip the mockup-as-artifact step; build components from brief + inputs + brand. Looser fidelity. | |
| Other / explain | User describes what's actually true. | ✓ |

**User's choice:** "The repository should contain a static HTML file. It might have been renamed, but the HTML file is still the most recently downloaded item in my downloads folder. Cross-reference what exists in the directory with the file in my downloads and see if there is an exact match, unless Phase 1 work has undone that or tweaked it in some way."

**Investigation:** Repo `mockups/home-v5/` directory was empty. Found `~/Downloads/joes-barbershop-home-5.html` (48 KB, dated 2026-05-06 — exactly matches "OD-5 locked 2026-05-06" in PROJECT.md). File contents verified: oklch palette, IM Fell English / Playfair Display / DM Serif Display / Newsreader / Oswald / JetBrains Mono fonts, `.check-divider` + `.section-mark` motifs, `.tweaks` live-panel inline. md5 = `75e4749bbe4c9e2d4993bfa6744d3cdc`.

---

### Q2: How should the OD-5 mockup file get placed into `mockups/home-v5/`?

| Option | Description | Selected |
|--------|-------------|----------|
| I'll copy it now during discuss | Copy `~/Downloads/joes-barbershop-home-5.html` → `mockups/home-v5/index.html` and commit alongside CONTEXT.md. Phase 2 starts with the mockup already in the repo. | ✓ |
| Make it Plan 01 of Phase 2 | Don't copy now; add as the first task in the Phase 2 plan. Cleaner audit trail in a phase commit. | |
| I'll copy it manually before planning | User drops it in before `/gsd-plan-phase 2`. Discuss-phase records the assumption. | |

**User's choice:** "I'll copy it now during discuss"

**Action taken:** `mkdir -p mockups/home-v5 && cp ~/Downloads/joes-barbershop-home-5.html mockups/home-v5/index.html` — md5 verified identical (`75e4749bbe4c9e2d4993bfa6744d3cdc`). Will commit in this discuss-phase commit.

---

### Q3: Components — take DESN-02's 12 names as locked, or derive from mockup?

| Option | Description | Selected |
|--------|-------------|----------|
| Take the 12 names as locked | Planner enforces exactly 12; extra sections filed under "extra" with explicit ask. | |
| Derive from the mockup | Planner inspects mockup DOM, proposes actual breakdown. 12 names are guidance, not contract. | |
| Lock the 12, add 'derived extras' as needed | Hybrid: 12 firm; extras allowed if found by inspection; no rename/remove of the 12. | ✓ |

**User's choice:** "Lock the 12, add 'derived extras' as needed"

---

### Q4: CSS port — single global vs split globals vs per-component scoped?

| Option | Description | Selected |
|--------|-------------|----------|
| Single global stylesheet at `src/styles/global.css` | Closest to OD output; one file imported in Base.astro. | |
| Split: tokens.css + components.css + utilities.css | Three global stylesheets; easier to navigate. | |
| Per-component scoped `<style>` in each `.astro` file | Most idiomatic Astro; bigger structural change. | |
| Other / Claude's recommendation | User asked for Claude's recommendation grounded in handoff cost. | ✓ |

**User's choice:** "What would be easier to maintain and understand if I need to hand this website off to somebody else in the future? With the understanding that it will primarily be you Claude maintaining this, if we have to hand off to another human being, there will be some cognitive price that needs to be paid. I want to minimize that as a best practice."

**Claude's recommendation (accepted):** **Per-component scoped `<style>` blocks + a small global `tokens.css` for `:root` vars and shared atoms (`.wrap`, `.eyebrow`, `.check-divider`, `.section-mark`).** Rationale: locality (markup + styles together when opening a file), Astro idiom (zero "what's the convention here" overhead), refactor safety (auto-scoping), and tokens stay discoverable in one canonical location. Cross-component rules go to `tokens.css`/`utilities.css` or restructure markup — never duplicate.

---

## Photos Directory

### Q5: `site/public/photos/` (per DESN-04) vs `site/src/assets/photos/` (per Phase 1 research)?

| Option | Description | Selected |
|--------|-------------|----------|
| `src/assets/photos/` (Astro Image processed) | Astro Image generates AVIF/WebP/srcset at build. Phase 5 perf becomes trivial. Update DESN-04 wording at phase transition. | ✓ |
| `public/photos/` (raw, no processing) | Honors literal requirement text but breaks Phase 5 perf targets. | |
| Both — src/assets for processed, public for raw URLs | Hero/in-page in `src/assets/`; logo/favicon and JSON-LD URL targets in `public/`. | |

**User's choice:** "src/assets/photos/ (Astro Image processed)"

**Note:** REQUIREMENTS.md DESN-04 wording correction queued for next phase transition.

---

## Content Authoring Depth

### Q6: How much real content does Phase 2 author?

| Option | Description | Selected |
|--------|-------------|----------|
| Schema-passing stubs only | Frontmatter satisfies Zod schema; BLUF placeholder, 1 FAQ placeholder, ~30-word body. Phase 3/4 author prose. | ✓ |
| Full prose now | Author complete BLUF + 4-5 FAQs + body for all 11 entries in Phase 2. | |
| Real BLUF + 1 FAQ + body skeleton | Middle ground; load-bearing BLUF + 1 real FAQ in Phase 2; rest in Phase 3/4. | |

**User's choice:** "Schema-passing stubs only"

---

### Q7: Where does the actual copy come from?

| Option | Description | Selected |
|--------|-------------|----------|
| I'll write it as we go | Executor pauses at each content file; user fills BLUF + FAQ. | |
| Claude drafts from inputs/, vault, mockup; I review at PR time | Executor drafts AEO-compliant prose; user sanity-checks. | |
| Pull from vault — audit-baseline-recipe + aeo-playbook-smb | Adapt existing fragments. Risks duplicating vault content. | |
| Other / use marketing skills | User specified marketing skills should drive copy generation. | ✓ |

**User's choice:** "I want to use the marketing skills that are appropriate (of which we have many) to generate all the copy and information and text on these pages."

**Captured chain (forward-looking, not Phase 2):** `marketing-skills:product-marketing-context` (one-time setup, Phase 3 start) → `marketing-skills:ai-seo` (AEO frame, one-time) → `marketing-skills:copywriting` (Phase 3 unique pages, per page) → `marketing-skills:programmatic-seo` (Phase 4 templated pages).

---

## business.ts Shape & Data Source

### Q8 (initial): What fields belong in business.ts?

| Option | Description | Selected |
|--------|-------------|----------|
| Lean: 7 fields from DATA-01 | Minimal record; cross-page only. | |
| Lean + brand (logo, palette tokens, tagline) | Adds brand-level constants. | |
| Lean + schema-org helpers (JSON-LD pre-shaped) | Hours/address pre-shaped; less Phase 5 code. | |
| (Other / unclear) | User indicated implications were unclear. | ✓ |

**User's choice:** "I don't understand the implications of these three options"

**Action taken:** Re-explained options with concrete examples (plain JS shape vs brand bolt-on vs JSON-LD pre-shape) and recommended Option 1 (Lean) on grounds of handoff cognitive load — matches the user's stated maintenance priority. Re-asked.

---

### Q8 (re-asked): Now that the options are clear: which shape for business.ts?

| Option | Description | Selected |
|--------|-------------|----------|
| Option 1: Lean (Recommended) | 7 fields, plain JS shapes; Phase 5 transforms to JSON-LD. | ✓ |
| Option 2: Lean + brand | Lean plus logo/tagline/ESTD constants. | |
| Option 3: Lean + schema-org helpers | Lean, but hours/address pre-shaped as JSON-LD types. | |

**User's choice:** "Option 1: Lean (Recommended)"

---

### Q9: Where do the actual values come from?

| Option | Description | Selected |
|--------|-------------|----------|
| Hard-coded inline in business.ts | Values typed directly into the .ts file. Most JS-idiomatic. | |
| JSON file imported by business.ts | Values in `business.json`; .ts imports + types + re-exports. | ✓ |
| Hand-pulled from PROJECT.md / vault / inputs/ | Claude gathers; user confirms; values land in business.ts. | |

**User's choice:** "JSON file imported by business.ts"

**Implementation:** `site/src/data/business.json` (canonical values) + `site/src/data/business.ts` (typed re-export).

---

## Claude's Discretion

- Zod refinement helpers (`.url()`, `.regex()`) — planner picks per natural fit.
- `business.json` key casing — recommend `camelCase` for TS ergonomics.
- Content entry filenames — recommend matching page slug exactly (`fades.md`, `bostonia.md`).
- `defineCollection` schema mode — recommend `z.object` (single shape per collection) over `z.discriminatedUnion`.

## Deferred Ideas

- Wikidata Q-number / Booksy listing → already v2 (OFFS-01, OFFS-02).
- `marketing-skills:product-marketing-context` setup → Phase 3 start.
- Per-service / per-neighborhood deep content → Phase 4.
- Hero `<Picture />` AVIF/WebP perf tuning → wired in Phase 2, verified in Phase 5.
- `kidsCut` price → mark TBD if not in `inputs/00-brief.md`; ask Joe at showcase.
- Sitemap entries for collection pages → Phase 5 (auto-discovered).
- REQUIREMENTS.md DESN-04 wording fix → next phase transition.
- Square Site cutover → already out-of-scope.
