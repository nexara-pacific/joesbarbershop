---
phase: 03-unique-pages
plan: 16
subsystem: content
tags:
  - faq
  - copywriting
  - aeo
  - gap-closure
dependency_graph:
  requires:
    - 03-09
    - 03-01
    - 03-00
  provides:
    - /faq authoritative operational reference
  affects:
    - site/src/pages/faq.astro
tech_stack:
  added: []
  patterns:
    - Authoritative-vs-teaser Q&A depth pattern (faq.astro = full detail, FAQ.astro = summary)
key_files:
  created: []
  modified:
    - site/src/pages/faq.astro
decisions:
  - /faq Q04/Q05/Q07/Q10/Q12 expanded to authoritative depth; FAQ.astro teaser versions left intentionally shorter
  - Q12 (location) extended with I-8 freeway navigation, phone, hours inline — making it a one-stop navigation answer
  - BLUF updated to reference 14 Q&As (accurate count) and enumerate topic coverage
metrics:
  duration: 8m
  completed_date: "2026-05-08"
  tasks_completed: 1
  files_modified: 1
---

# Phase 03 Plan 16: FAQ Master Page Authoritative Depth Summary

**One-liner:** Expanded /faq Q&As (Q04, Q05, Q07, Q10, Q12) to authoritative reference depth — each now 2-3x the length of the homepage FAQ.astro teaser counterpart, with operational detail that makes /faq the canonical citation target for hours, payment, walk-in policy, and kids facts.

## What Was Built

Revised `site/src/pages/faq.astro` to serve as the definitive operational reference page. Five Q&As identified as near-verbatim duplicates of the homepage `FAQ.astro` teaser were expanded with depth that makes the /faq version the authoritative source.

### Changes Made

**BLUF:** Updated to reference 14 Q&As (was "10 questions"), enumerate specific topic categories (hours, payment, wait times, kids cuts, how to find the shop), and clarify Square booking option.

**Q04 — Do I need an appointment?** (552 chars vs FAQ.astro 181 chars)
Expanded from a 2-sentence walk-in confirmation to full operational detail: how walk-in queue works, Square booking card-hold distinction, call-ahead recommendation for busy Fridays/Saturdays.

**Q05 — How long does a haircut take?**
Added peak-hours context: service times vs. actual shop time distinction, quiet Tuesday/Wednesday morning vs. busy Friday/Saturday afternoon timing guidance, call-ahead recommendation.

**Q07 — Do you take cards?**
Added WHY cash-only explanation (no processing fee in the $30 price), full list of payment types not accepted (credit, debit, tap-to-pay, digital wallets), clarification that Square booking accepts card for appointment hold but chair payment is still cash.

**Q10 — Do you cut kids' hair?**
Expanded from 65-word confirmation to full kids-policy answer: school-age through teens, no separate "kids pricing" tier, no separate kids queue/slot, minimum-age note for very young children needing parent alongside.

**Q12 — Where is Joe's Barbershop?**
Expanded with I-8 freeway exit directions (Greenfield Drive/Johnson Avenue), directional guidance (south side of Bradley Avenue), phone and hours inline for one-stop navigation answer.

## Acceptance Criteria Results

| Check | Result |
|-------|--------|
| npm run build exits 0 | PASS |
| audit.sh 18/18 exits 0 | PASS |
| astro check 0 errors / 0 warnings | PASS |
| faq-master-count (>= 10, actual 14) | PASS |
| BLUF contains "Tuesday through Saturday" | PASS |
| 5 topic-group H2s present | PASS |
| Continuous 01–14 numbering intact (14) | PASS |
| No banned phrases | PASS (exit 1) |
| Q04 answer longer than FAQ.astro Q1 (552c vs 181c) | PASS |

## Deviations from Plan

None — plan executed exactly as written.

## Known Stubs

None — all answers reference verified operational facts from business.ts/business.json.

## Threat Surface Scan

No new network endpoints, auth paths, file access patterns, or schema changes introduced. Static page edit only. T-03-16-01 (hours facts) mitigated — BLUF and Q01 both carry canonical "Tuesday through Saturday, 10am to 7:30pm" string. T-03-16-02 (faq-q count) mitigated — 14 faq-q articles confirmed in built HTML.

## Self-Check: PASSED

- `/faq.astro` modified: confirmed
- Commit `3354ac4` exists: confirmed
- Build output `/faq/index.html` present: confirmed
- 14 faq-q articles in built HTML: confirmed
- 5 H2 topic groups: confirmed
