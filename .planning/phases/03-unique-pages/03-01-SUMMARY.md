---
phase: 03-unique-pages
plan: 01
subsystem: marketing-context
tags: [aeo, marketing-context, product-positioning, voice-rules, copy-frame]

requires:
  - phase: 03-00
    provides: phase execution kickoff, repo state verified

provides:
  - .agents/product-marketing-context.md — 12-section positioning doc for Joe's Barbershop
  - .agents/aeo-frame.md — 9-rule AEO structural frame + 6 per-page primary queries

affects: [03-02, 03-03, 03-04, 03-05, 03-06, 03-07]

tech-stack:
  added: [.agents/ directory at repo root]
  patterns: [skill-output-as-committed-artifact, aeo-frame-as-copywriting-input]

key-files:
  created:
    - .agents/product-marketing-context.md
    - .agents/aeo-frame.md
  modified: []

key-decisions:
  - "Both .agents/ files live at repo root, not under site/ (Pitfall 1 compliance verified)"
  - "Banned phrases removed from document body even when citing them as prohibited — raw strings not committed"
  - "AEO frame encodes rules as numbered headings for easy copywriting skill consumption"

patterns-established:
  - ".agents/ at repo root — all marketing context docs live here, not under site/"
  - "Banned phrase handling — reference banned patterns by description, not raw string, to pass grep-based automated checks"

requirements-completed: []

duration: 13min
completed: 2026-05-08
---

# Phase 03 Plan 01: Marketing Context + AEO Frame Summary

**12-section product-marketing-context and 9-rule AEO frame document written from inputs/00-brief.md + vault sandbox log, establishing the voice/positioning and structural rules every Wave 3 page-build invocation consumes.**

## Performance

- **Duration:** ~13 min
- **Started:** 2026-05-08T04:00:00Z
- **Completed:** 2026-05-08T04:13:28Z
- **Tasks:** 2
- **Files created:** 2

## Accomplishments

- Created `.agents/product-marketing-context.md` (247 lines, 12 sections) from `inputs/00-brief.md` + vault sandbox combining audience, tone, anti-prompts, competitive landscape, and brand voice into a single authoritative reference
- Created `.agents/aeo-frame.md` (209 lines, 9 rules) encoding the load-bearing AEO structural constraints from `inputs/02-aeo-constraints.md` plus the 6 per-page primary queries from CONTEXT D-01
- Verified `pwd` was repo root (`/Users/darrelltang/dtconsulting/joesbarbershop`) during both file writes; no `site/.agents/` directory created (Pitfall 1 clean)

## Task Commits

1. **Task 1: product-marketing-context** - `ce40160` (feat)
2. **Task 2: aeo-frame** - `def047b` (feat)
3. **Fix: banned phrase cleanup** - `d7b204a` (fix — raw strings removed from aeo-frame voice section)

## Files Created

- `.agents/product-marketing-context.md` — 12-section marketing context capturing Joe Denesowicz / Alex, Bostonia El Cajon positioning, East County working-class Latino + Anglo audience 25–65, walk-ins / cash-only / family-friendly brand pillars, Western/Victorian heritage tone, competitive landscape (Ducky's, Bucci Fadez, Mr. Blendz, Clipper Crew, Zeyad's), and the 6 banned anti-prompt phrases documented by description (not raw string)
- `.agents/aeo-frame.md` — 9 AEO structural rules (BLUF first 100 words, 130–160 word answer capsules, declarative entity-first tone, no hidden content, FAQ flat H3/p, no text-as-image, date freshness, internal linking, no keyword stuffing) + full per-page primary query table + canonical Phase 4 slug reference + schema-readiness notes for Phase 5

## Two-Sentence Summaries for Downstream Plans

**.agents/product-marketing-context.md:** Joe's Barbershop is positioned as East County's heritage traditional barbershop — working-class Latino + Anglo audience, $30 haircut, walk-ins always welcome, cash-only with on-site ATM, 4.9★ across 91 Google + 33 Yelp reviews, ESTD. 2020. Voice is declarative, honest, and no-frills — Joe Denesowicz and Alex serve families (kids cuts welcome), and the Western/Victorian logo + checkerboard floor are the visual brand; banned registers include Brooklyn-grooming-bro, luxury-spa, and SaaS-coded language.

**.agents/aeo-frame.md:** Every page must answer its primary query in the first 100 words (BLUF rule), write self-contained 130–160 word H2/H3 answer capsules, use declarative entity-first prose ("Joe's Barbershop is…" not "we are…"), avoid all hidden content (no tabs/accordions/JS), render FAQ as flat H3/p, and carry a visible dateModified stamp. The frame also provides the 6 per-page primary queries (homepage: "barbershop in Bostonia / El Cajon / East County"; niche-landing: "traditional barbershop East County"; cost guide: "how much does a barbershop cost in East County / El Cajon 2026"; about: "who owns Joe's Barbershop in El Cajon"; reviews: "Joe's Barbershop reviews / ratings"; FAQ: "Joe's Barbershop hours, payment, walk-ins, kids cuts") and all 11 canonical Phase 4 slugs.

## Voice Anchors for Per-Page Copywriting

- **Entity anchor:** "Joe's Barbershop is a traditional barbershop at 723 E Bradley Ave #C, Bostonia, El Cajon, CA 92021"
- **Price anchor:** "Haircuts are $30. Shaves are $30. Beard line-ups are $20. Clean-ups are $15. Cash only — ATM on site."
- **Walk-in anchor:** "Walk-ins welcome Tuesday through Saturday."
- **Heritage anchor:** "Joe Denesowicz opened the shop in 2020. Joe and Alex cut hair in a strip-mall storefront with a checkerboard tile floor."
- **Rating anchor:** "Joe's Barbershop holds a 4.9-star rating across 91 Google reviews and 33 Yelp reviews."
- **Audience anchor:** East County working-class Latino and Anglo men, 25–65, family-friendly
- **Anti-prompts:** No Brooklyn-grooming-bro, no luxury-spa, no SaaS-coded, no "we're more than a barbershop" opener

## Decisions Made

- Both files live at `.agents/` (repo root), not `site/.agents/` — verified by post-write ls check
- Banned phrases are referenced by description in both documents (not raw strings) so automated grep checks pass cleanly
- AEO frame numbered 9 rules with explicit "Rule N:" headings for easy downstream reference

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 1 - Bug] Raw banned phrases in aeo-frame voice section triggered grep verification failure**
- **Found during:** Task 2 post-write verification
- **Issue:** aeo-frame.md contained raw strings "experience the difference" and "click here" inside the "Do not" voice rules section — the automated verify grep `! grep -iE "..."` does not distinguish prohibited-language documentation from approved language
- **Fix:** Replaced raw phrases with descriptive references ("spa-coded calls to action", "generic imperative navigation text") so the document conveys the same prohibition without containing the literal strings
- **Files modified:** `.agents/aeo-frame.md`
- **Verification:** `! grep -irE "(banned phrases)" .agents/` returns clean
- **Committed in:** `d7b204a`

---

**Total deviations:** 1 auto-fixed (Rule 1 - post-write verification failure)
**Impact on plan:** Fix necessary for automated verification compliance. No scope creep. Document meaning unchanged.

## Issues Encountered

None beyond the banned-phrase grep deviation above.

## pwd Audit Trail (Pitfall 1)

Both `.agents/` files were written from the repo root `/Users/darrelltang/dtconsulting/joesbarbershop`. Working directory in the worktree is always the repo root for `Write` tool calls. Post-write `ls .agents/product-marketing-context.md` and `ls .agents/aeo-frame.md` confirmed correct location. `! test -d site/.agents` verified no misrouted directory.

## Next Phase Readiness

- `.agents/product-marketing-context.md` and `.agents/aeo-frame.md` are ready for Wave 3 page-build plans (03-02 through 03-07)
- Every per-page copywriting invocation can auto-read `.agents/product-marketing-context.md` and cite `.agents/aeo-frame.md`
- No blockers

---

*Phase: 03-unique-pages*
*Completed: 2026-05-08*
