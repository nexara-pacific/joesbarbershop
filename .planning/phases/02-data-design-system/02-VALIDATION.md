---
phase: 2
slug: data-design-system
status: approved
nyquist_compliant: true
wave_0_complete: true
created: 2026-05-07
approved: 2026-05-07
---

# Phase 2 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Astro build (`astro check` for types + Zod schema validation; no test runner — Phase 2 ships data + components, no runtime logic) |
| **Config file** | `site/astro.config.mjs`, `site/tsconfig.json`, `site/src/content.config.ts` |
| **Quick run command** | `cd site && npx astro check` |
| **Full suite command** | `cd site && npm run build` |
| **Estimated runtime** | ~30 seconds (check) / ~60 seconds (full build) |

---

## Sampling Rate

- **After every task commit:** Run `cd site && npx astro check`
- **After every plan wave:** Run `cd site && npm run build`
- **Before `/gsd-verify-work`:** Full build must succeed and the dev parity page must render
- **Max feedback latency:** 60 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 02-01-T1 | 01 | 1 | DESN-01 | T-02-01..06 (all N/A) | N/A — static CSS file creation | file-exists + grep | `test -f site/src/styles/tokens.css && test -f site/src/styles/utilities.css && grep -c -- '--bg:' site/src/styles/tokens.css` exits 0 with count 1 | ❌ W0 | ⬜ pending |
| 02-01-T2 | 01 | 1 | DESN-01 | — | N/A — layout edit | grep + build | `grep "import.*tokens\.css" site/src/layouts/Base.astro && grep 'slot name="head"' site/src/layouts/Base.astro && cd site && npm run build` exits 0 | ❌ W0 | ⬜ pending |
| 02-02-T1 | 02 | 1 | DATA-01 | T-02-07..12 (all N/A) | Human checkpoint — confirm GBP hours | manual | User confirms Saturday close time from live Google Business Profile | N/A | ⬜ pending |
| 02-02-T2 | 02 | 1 | DATA-01 | — | N/A — static data file | file-exists + grep + build | `test -f site/src/data/business.json && test -f site/src/data/business.ts && grep -E '"haircutBeard": (50\|null)' site/src/data/business.json && grep -E '@type\|@context' site/src/data/business.ts` (last grep returns NO matches) + `cd site && npm run build` exits 0 | ❌ W0 | ⬜ pending |
| 02-03-T1 | 03 | 1 | DATA-02 | — | N/A — config file | file-exists + path-check | `test -f site/src/content.config.ts && test ! -f site/src/content/config.ts` (Astro 6 path; legacy nested path absent) | ❌ W0 | ⬜ pending |
| 02-03-T2 | 03 | 1 | DATA-03, DATA-04 | — | N/A — markdown stubs | file-count + getCollection | `ls site/src/content/services/*.md \| wc -l` returns 6 + `ls site/src/content/neighborhoods/*.md \| wc -l` returns 5 + `cd site && npm run build` exits 0 (no Zod errors) | ❌ W0 | ⬜ pending |
| 02-04-T1 | 04 | 2 | DESN-04, DESN-02 | T-02-19..24 (all N/A) | N/A — static asset copy + new components | file-count + file-exists | `ls site/src/assets/photos/*.jpg \| wc -l` returns 6 + `test -f site/src/components/CheckDivider.astro && test -f site/src/components/SectionMark.astro` | ❌ W0 | ⬜ pending |
| 02-04-T2 | 04 | 2 | DESN-02, DESN-03 | — | N/A — component port | grep + build | `grep -r "data-phase1-stub" site/src/` returns 0 matches + `grep -r "tweaks" site/src/` returns 0 + `grep -r "data-font\|data-checker" site/src/` returns 0 + `grep -rE "applyFont\|applyCheck\|toggleTweaks" site/src/` returns 0 + `cd site && npm run build` exits 0 | ❌ W0 | ⬜ pending |
| 02-05-T1 | 05 | 2 | DESN-02 | T-02-25..30 (all N/A) | N/A — component creation | file-exists + grep | `test -f site/src/components/Hero.astro && test -f site/src/components/FactStrip.astro && grep "<Picture" site/src/components/Hero.astro` (hero uses Picture per D-14) | ❌ W0 | ⬜ pending |
| 02-05-T2 | 05 | 2 | DESN-02 | — | N/A — component creation | file-exists + build | `test -f site/src/components/PriceBoard.astro && cd site && npm run build` exits 0 | ❌ W0 | ⬜ pending |
| 02-06-T1 | 06 | 2 | DESN-02 | T-02-31..36 (all N/A) | N/A — component creation | file-exists | `test -f site/src/components/Heritage.astro && test -f site/src/components/Visit.astro` | ❌ W0 | ⬜ pending |
| 02-06-T2 | 06 | 2 | DESN-02, DESN-03 | — | N/A — component creation | file-exists + build | `test -f site/src/components/FAQ.astro && test -f site/src/components/ClosingCTA.astro && cd site && npm run build` exits 0 | ❌ W0 | ⬜ pending |
| 02-07-T1 | 07 | 3 | DESN-01..04 | T-02-37..42 (all N/A) | N/A — dev scratch page | full suite | `test -f site/src/pages/_dev-mockup-parity.astro` + named-12-components existence loop + `grep -r "tweaks\|data-phase1-stub\|data-font\|data-checker" site/src/` all return 0 + `grep -rE "applyFont\|applyCheck\|toggleTweaks" site/src/` returns 0 + `cd site && npm run build` exits 0 + `cd site && npx astro check` exits 0 | ❌ W0 | ⬜ pending |
| 02-07-T2 | 07 | 3 | DESN-01..04 (success criterion #3) | — | Human checkpoint — visual eye-test | manual | User compares /_dev-mockup-parity render in dev server to mockups/home-v5/index.html and confirms "approved" | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky · `File Exists ❌ W0` = file does not exist yet — Wave 0 dependency is the executor creating it as part of the task.*

**Sampling continuity:** No 3 consecutive tasks lack automated verification. Two human checkpoints are the only manual gates (02-02-T1, 02-07-T2); both are bracketed by automated tasks on either side.

**Planner note:** Phase 2 has no runtime logic (no auth, no API, no DB). Verification is dominated by:
- File-existence checks (`test -f`, `ls`)
- Grep negation checks (`grep -r data-phase1-stub site/src/` returns 0 matches; same for `tweaks`, `data-font`, `data-checker`, `applyFont|applyCheck|toggleTweaks`)
- Type/schema checks (`npx astro check` exits 0)
- Build success (`npm run build` exits 0)
- Visual parity (manual: open scratch parity page, compare to mockup)

---

## Wave 0 Requirements

*No test stubs needed.* `astro check` and `astro build` are the validation harness; both come from Phase 1.

If the planner adds any runtime logic (e.g., a custom transformation in `business.ts` that goes beyond import + re-export), it must declare a Wave 0 task to add a vitest stub for that function.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Visual parity with mockup | DESN-01, DESN-02 (Phase 2 success #3) | "Pixel-identical" requires human eye — checkerboard, font rendering, palette, spacing | Open `site/src/pages/_dev-mockup-parity.astro` in dev (`npm run dev`), open `mockups/home-v5/index.html` in another tab, side-by-side compare |
| Hours value confirmation | DATA-01 | Vault baseline (Sat 19:30 close) conflicts with mockup (Sat 18:30) — must read current GBP listing | Executor opens Joe's Google Business Profile, copies the live hours into `business.json` |
| `kidsCut` price confirmation | DATA-01 | Not in any input file; Joe must answer | Executor sets `null` initially; Joe confirms at showcase, then PR-edit |
| `sameAs` URL collection | DATA-01 (D-21) | Each URL needs human verification (account ownership, public visibility) | Executor visits each platform (GBP, Yelp, IG, FB), copies canonical URL, paste into `business.json` |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies (all 13 tasks above; 2 are human checkpoints with bracketed automated tasks)
- [x] Sampling continuity: no 3 consecutive tasks without automated verify (verified — only 2 manual tasks, each bracketed)
- [x] Wave 0 covers all MISSING references (none for Phase 2 — `astro check` and `npm run build` are the harness; both come from Phase 1)
- [x] No watch-mode flags (`npm run build` is one-shot; `astro check` is one-shot)
- [x] Feedback latency < 60s (build is ~30-60s; check is ~10-30s)
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-05-07 (during plan-phase verification, after gsd-plan-checker iteration 1)
