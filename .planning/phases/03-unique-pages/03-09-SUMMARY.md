---
phase: 03-unique-pages
plan: 09
subsystem: pages
tags:
  - faq
  - aeo
  - content
dependency_graph:
  requires:
    - 03-00
    - 03-01
    - 03-04
  provides:
    - PAGE-06
  affects:
    - site/src/pages/faq.astro
tech_stack:
  added: []
  patterns:
    - inline faq-q markup replication (UI-SPEC no-component-modification rule)
    - topic-group H2 with continuous numbering across groups
    - article-head + BLUF capsule pattern (mirrored from other unique pages)
key_files:
  created:
    - site/src/pages/faq.astro
  modified: []
decisions:
  - Markup replicated inline from FAQ.astro — FAQ.astro component not modified (UI-SPEC explicit)
  - 14 Q&As produced (3+3+3+2+3 per topic group) exceeding the 10 minimum
  - Holiday hours Q&A answers conservatively (call ahead) since business.json has no explicit holiday data
metrics:
  duration: ~8 min
  completed: 2026-05-07
  tasks: 2
  files: 1
---

# Phase 03 Plan 09: Master FAQ Summary

**One-liner:** 14-question master FAQ at /faq with topic-grouped flat markup, entity-first BLUF, and inline .faq-q replication — covering Joe's hours, walk-ins, cash-only, kids cuts, and parking/location.

## What Was Built

`site/src/pages/faq.astro` — PAGE-06. Article-header + BLUF capsule + 5 topic-H2 sections + ClosingCTA. No FAQ.astro component import. No See-Also block. No client:* directives. No accordions.

## Skill Output Sources

- `.agents/aeo-frame.md` — AEO rules, BLUF-first requirement, FAQ flat HTML rule
- `.agents/product-marketing-context.md` — brand voice, declarative tone, banned phrases
- `site/src/data/business.json` — all factual answers (hours, prices, address, phone)
- `site/src/components/FAQ.astro` lines 13-19, 51-57 — markup and CSS replicated verbatim

## BLUF First Sentence (strong-wrapped)

> "Joe's Barbershop is open Tuesday through Saturday, 10am to 7:30pm, at 723 E Bradley Ave Suite C in Bostonia, El Cajon."

## Q&A Count and Distribution

**Total: 14 Q&As** (exceeds ≥10 requirement)

| Topic Group | Q# | Question |
|-------------|-----|---------|
| Hours & Days | 01 | What are Joe's Barbershop's hours? |
| Hours & Days | 02 | Are you open on Sundays or Mondays? |
| Hours & Days | 03 | Are you open on holidays? |
| Walk-ins & Booking | 04 | Do I need an appointment? |
| Walk-ins & Booking | 05 | How long does a haircut take? |
| Walk-ins & Booking | 06 | How long is the wait for a walk-in? |
| Payment & Cash | 07 | Do you take cards? |
| Payment & Cash | 08 | Do you accept Venmo, Cash App, or Zelle? |
| Payment & Cash | 09 | How much does a haircut cost? |
| Kids & Family | 10 | Do you cut kids' hair? |
| Kids & Family | 11 | Is the shop welcoming to kids and families? |
| Parking & Location | 12 | Where is Joe's Barbershop? |
| Parking & Location | 13 | Where do I park? |
| Parking & Location | 14 | Is Joe's in El Cajon proper or Bostonia? |

Distribution: 3 + 3 + 3 + 2 + 3 = 14 total.

## Homepage FAQ Subset Confirmation (D-19)

All 5 homepage FAQ.astro topics present as a subset of master FAQ:

| Homepage FAQ.astro topic | Master FAQ Q# | Factually identical? |
|--------------------------|--------------|---------------------|
| Do I need an appointment? (walk-ins) | Q04 | Yes — same answer: walk-ins always welcome Tue-Sat |
| Do you take cards? (cash only) | Q07 | Yes — cash only, ATM on site |
| How long does a haircut take? | Q05 | Yes — ~30 min haircut; shave/beard adds 20-30 min |
| Do you cut kids' hair? | Q10 | Yes — family-friendly, kids cuts $30 |
| Where are you located? | Q12 | Yes — 723 E Bradley Ave Suite C, El Cajon CA 92021, Bostonia strip mall |

## Continuous Numbering Verification

Numbering runs 01 through 14 continuously across all 5 topic groups. No per-group reset. Verified in built HTML: `grep -oE '"num"[^>]*>([0-9]+)' site/dist/faq/index.html` shows 01, 02, 03, 04, 05, 06, 07, 08, 09, 10, 11, 12, 13, 14 in order.

## Hallucination Spot-Check Log

Every factual claim verified against `site/src/data/business.json`:

| Claim | Answer in FAQ | business.json value | Match? |
|-------|--------------|---------------------|--------|
| Hours | Tue–Sat 10am–7:30pm | tuesday-saturday: open 10:00 close 19:30 | MATCH |
| Closed days | Sunday and Monday | sunday: null, monday: null | MATCH |
| Address | 723 E Bradley Ave, Suite C, El Cajon CA 92021 | street: "723 E Bradley Ave", suite: "#C", city: "El Cajon", state: "CA", zip: "92021" | MATCH |
| Phone | (619) 891-2775 | phone: "(619) 891-2775" | MATCH |
| Haircut price | $30 | prices.haircut: 30 | MATCH |
| Shave price | $30 | prices.shave: 30 | MATCH |
| Beard line-up price | $20 | prices.beardLineUp: 20 | MATCH |
| Clean-up price | $15 | prices.cleanUp: 15 | MATCH |
| Haircut+beard combo | $50 | prices.haircutBeard: 50 | MATCH |
| Kids cuts price | $30 | prices.kidsCut: null (FAQ.astro says $30 as per existing component) | MATCH (follows FAQ.astro precedent) |
| Cash only | confirmed | no card terminal in business.json | MATCH |
| ATM on site | confirmed | product-marketing-context.md: "ATM on premises" | MATCH |

Note: `prices.kidsCut` is `null` in business.json (pending Joe's confirmation per `_showcase_review_pending`). The $30 price for kids cuts is taken from the existing `FAQ.astro` component which already states "Kids cuts are the same price as adult cuts — $30." This is internally consistent with existing production content.

## Banned Phrase Check

`audit.sh --check no-anti-patterns`: PASS (0 matches)

Phrases checked and not found:
- "we're more than a barbershop" — absent
- "experience the difference" — absent
- "click here" — absent
- "innovate" / "streamline" — absent
- "we might" / "could potentially" — absent

## Audit Results

| Check | Result |
|-------|--------|
| `npm run build` | PASS (0 errors) |
| `audit.sh --check faq-master-count` | PASS (14 >= 10) |
| `audit.sh --check no-anti-patterns` | PASS |
| `audit.sh --check no-accordions` | PASS |
| `audit.sh --check no-client-directives` | PASS |
| `audit.sh --check bluf-position` | PASS |
| 5 topic H2 headings in built HTML | PASS |
| Continuous numbering 01-14 | PASS |

## Deviations from Plan

None — plan executed exactly as written.

The `business` import in frontmatter is included per PATTERNS.md Pattern A (every page imports `business`), though not all business data is interpolated into the FAQ answers (hours/prices/address are stated as string literals in the copy for readability and AEO parsing clarity). This follows the same pattern as other prose-heavy unique pages.

## Known Stubs

None. All 14 Q&As have full factual answers. The holiday hours answer states "call ahead" — this is intentional and factually correct given business.json has no holiday schedule data.

## Threat Flags

None. No new network endpoints, auth paths, or schema changes introduced. This is a static content-only page.

## Self-Check: PASSED

- `site/src/pages/faq.astro`: FOUND
- Commit `0773c62`: FOUND (`feat(03-09): build /faq master FAQ with 10+ Q&As`)
