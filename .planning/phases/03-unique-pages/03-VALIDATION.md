---
phase: 3
slug: unique-pages
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-07
---

# Phase 3 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution. Phase 3 is content + markup, not application logic — the verification surface is `npm run build` + `grep` audits of build output, plus a human eye-test for OD-5 mockup parity on `/`. No Jest / Vitest / Playwright introduced in this phase (per RESEARCH.md § Wave 0 Gaps).

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | None — build is the test. Static analysis via `grep` against `site/dist/` build output. |
| **Config file** | n/a (no test runner) |
| **Quick run command** | `cd site && npm run build` |
| **Full suite command** | `cd site && npm run build && bash .planning/phases/03-unique-pages/scripts/audit.sh` (audit script is Wave 0 deliverable; see below) |
| **Estimated runtime** | ~10–15s (Astro build) + ~2s (grep suite) |

---

## Sampling Rate

- **After every task commit:** Run `cd site && npm run build` (must exit 0). Plus the page-specific grep audit row from the table below for the page touched.
- **After every plan wave:** Run all grep audits across all touched pages.
- **Before `/gsd-verify-work`:** Full suite green + human visual parity check on `/` against `mockups/home-v5/index.html` at desktop / 980px / 600px.
- **Max feedback latency:** ~15 seconds (build + audit). If a single page audit fails, executor halts the commit and surfaces the failing assertion.

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 03-00-01 | 00 | 0 | n/a — infra | — | N/A | smoke | `cd site && npm run build` | ✅ | ⬜ pending |
| 03-00-02 | 00 | 0 | n/a — infra | — | Audit script exists and runs | smoke | `test -x .planning/phases/03-unique-pages/scripts/audit.sh && bash .planning/phases/03-unique-pages/scripts/audit.sh --self-test` | ❌ W0 | ⬜ pending |
| 03-01-XX | 01 | 1 | n/a — skills setup | — | `.agents/product-marketing-context.md` and `.agents/aeo-frame.md` present and non-empty | smoke | `test -s .agents/product-marketing-context.md && test -s .agents/aeo-frame.md` | ❌ W0 | ⬜ pending |
| 03-02-XX | 02 | 2 | PAGE-05 (data) | — | `data/reviews.json` populated OR fallback placeholder array with `_showcase_review_pending` markers | smoke | `node -e "const r=require('./site/src/data/reviews.json'); process.exit(Array.isArray(r) && r.length>=6 ? 0 : 1)"` (or accept placeholder per D-10) | ❌ W0 | ⬜ pending |
| 03-03-XX | 03 | 2 | PAGE-03 (data) | — | `data/competitors.json` has ≥4 entries OR ≥2 real + archetype rows per D-14 | smoke | `node -e "const c=require('./site/src/data/competitors.json'); process.exit(c.length>=4 ? 0 : 1)"` | ❌ W0 | ⬜ pending |
| 03-04-XX | 04 | 3 | PAGE-01 | — | `/` builds and renders parity-correct against OD-5 mockup at desktop / 980 / 600 | smoke + manual | `cd site && npm run build && grep -q '<section class="hero"' site/dist/index.html` + browser visual diff | ❌ W0 (build); manual (visual) | ⬜ pending |
| 03-04-XX | 04 | 3 | PAGE-01 | — | `/` homepage FAQ block has 5–6 Q&As as flat `<h3>`/`<p>` pairs | grep | `grep -c '<article class="faq-q"' site/dist/index.html` (expect 5 or 6) | ❌ W0 | ⬜ pending |
| 03-05-XX | 05 | 3 | PAGE-02 | — | `/east-county-traditional-barbershop` has 6 FAQ Q&As (flat H3/p, no JS accordion) | grep | `grep -c '<article class="faq-q"' site/dist/east-county-traditional-barbershop/index.html` (expect 6) | ❌ W0 | ⬜ pending |
| 03-05-XX | 05 | 3 | PAGE-02 | — | areaServed list shows 5 neighborhood links | grep | `grep -oE '<a[^>]*href="/[a-z-]+-barber"' site/dist/east-county-traditional-barbershop/index.html \| sort -u \| wc -l` (expect 5) | ❌ W0 | ⬜ pending |
| 03-06-XX | 06 | 3 | PAGE-03 | — | Cost guide cross-links to all 6 service slugs + 5 neighborhood slugs | grep | `bash .planning/phases/03-unique-pages/scripts/audit.sh --check cost-guide-slugs` (canonical 11-slug list) | ❌ W0 | ⬜ pending |
| 03-06-XX | 06 | 3 | PAGE-03 | — | Cost guide has 4–6 entry cards | grep | `grep -c '<article class="entry"' site/dist/2026-east-county-barbershop-cost-guide/index.html` (expect ≥ 4) | ❌ W0 | ⬜ pending |
| 03-07-XX | 07 | 3 | PAGE-04 | — | `/about` mentions Joe Denesowicz and Alex in plain text | grep | `grep -c -E "Joe Denesowicz\|Alex" site/dist/about/index.html` (expect ≥ 2 mentions) | ❌ W0 | ⬜ pending |
| 03-07-XX | 07 | 3 | PAGE-04 | — | Two portrait placeholders carry `data-pending-photo` markers (joe + alex) | grep | `grep -c 'data-pending-photo' site/dist/about/index.html` (expect 2) | ❌ W0 | ⬜ pending |
| 03-08-XX | 08 | 3 | PAGE-05 | — | `/reviews` shows pulled-quote highlights from Google + Yelp (or placeholder fallback) | grep | `grep -E "Google\|Yelp" site/dist/reviews/index.html \| wc -l` (expect ≥ 2 distinct labels) | ❌ W0 | ⬜ pending |
| 03-08-XX | 08 | 3 | PAGE-05 | — | `/reviews` has 6–8 review cards | grep | `grep -c '<article class="review-card"' site/dist/reviews/index.html` (expect 6–8) | ❌ W0 | ⬜ pending |
| 03-09-XX | 09 | 3 | PAGE-06 | — | `/faq` has 10+ visible Q&As as flat H3/p | grep | `grep -c '<article class="faq-q"' site/dist/faq/index.html` (expect ≥ 10) | ❌ W0 | ⬜ pending |
| ALL | * | 3 | — | — | No `client:*` directives anywhere in `site/src/pages/` (zero-JS AEO requirement) | grep | `grep -rE "client:(load\|idle\|visible\|only)" site/src/pages/` (expect 0 matches → exit 1 → success) | ❌ W0 | ⬜ pending |
| ALL | * | 3 | — | — | No banned anti-pattern phrases in page source | grep | `grep -irE "we're more than a barbershop\|experience the difference\|click here\|innovate" site/src/pages/` (expect 0 matches) | ❌ W0 | ⬜ pending |
| ALL | * | 3 | — | — | No accordions / `<details>` / tab panels (AEO no-hidden-content) | grep | `grep -rE "<details>\|aria-expanded\|tab-panel" site/src/pages/` (expect 0 matches) | ❌ W0 | ⬜ pending |
| ALL | * | 3 | — | — | BLUF capsule appears within first ~100 words of `<main>` on every page | grep + manual sample | `bash .planning/phases/03-unique-pages/scripts/audit.sh --check bluf-position` | ❌ W0 (sampled) | ⬜ pending |
| ALL | * | 4 | — | — | Cleanup: `dev-mockup-parity.astro` deleted after `/` parity verified (D-20) | filesystem | `test ! -f site/src/pages/dev-mockup-parity.astro` | ❌ W0 (final task) | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

> Task IDs ending in `-XX` are placeholder ranges — the planner assigns concrete IDs (`-01`, `-02`, etc.) per plan. The Wave column reflects the recommended execution waves from RESEARCH.md § Architectural Responsibility Map.

---

## Wave 0 Requirements

- [ ] `.planning/phases/03-unique-pages/scripts/audit.sh` — single shell script that runs the grep suite. Supports `--check <name>` for targeted single-row runs (`bluf-position`, `cost-guide-slugs`, `no-client-directives`, `no-anti-patterns`, `no-accordions`) and `--self-test` for sanity-checking the script itself. Exits non-zero on any failure with a one-line failing-assertion message.
- [ ] `.planning/phases/03-unique-pages/scripts/canonical-slugs.txt` — the 11 Phase 4 slugs (6 services + 5 neighborhoods) the cost guide must link to. Single source of truth for the cost-guide-slugs check.
- [ ] **No test framework install required.** Phase 3 deliberately does NOT add Jest / Vitest / Playwright. RESEARCH.md § Wave 0 Gaps documents the rationale. If a future phase wants snapshot-based parity diffing, it owns that scope.

*Existing infrastructure (Astro `npm run build` + grep against `dist/`) covers all Phase 3 automated verification.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| `/` matches `mockups/home-v5/index.html` pixel-for-pixel at desktop, 980px, 600px | PAGE-01 (ROADMAP success criterion #1) | Pixel parity is a human visual gate; no Playwright snapshot infra in this phase | Open `http://localhost:4321/` in a browser. Set viewport to 1440px wide → eyeball-compare against `mockups/home-v5/index.html` open in another tab. Repeat at 980px and 600px viewport widths. Log any deltas in the verification commit message. Acceptable deltas: FAQ block has 5–6 real Q&As where the mockup may have stub. Non-acceptable deltas: any spacing / typography / color difference. |
| Skill-generated copy reads as Joe's voice (heritage / no-frills / Western-Victorian / not Brooklyn-grooming-bro / not luxury-spa) | PAGE-01..06 (D-02 no-review-gate) | Voice is not algorithmically checkable beyond the banned-phrase grep; subjective Darrell judgment | Read each page on `npm run dev` once before the verification commit. If voice drifts, escalate by adding `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` to the `product-marketing-context` skill inputs and re-running the offending page (per D-04 / Deferred Ideas). |
| Reviews / cost-guide content is factually plausible (no hallucinated competitor names or fabricated review quotes) | PAGE-03, PAGE-05 (D-05 commit-on-broken-output prohibition) | Firecrawl scrape is empirical; placeholder fallback content (D-10, D-14) is acceptable but the executor must NOT silently commit fabricated data | Spot-check 2–3 cost guide entries against original Google Maps listings. Spot-check 2–3 review quotes against original Google / Yelp surfaces. If fabrication detected, halt and re-scrape or fall through to D-10 / D-14 placeholder path. |

---

## Validation Sign-Off

- [ ] All tasks have automated verify command OR are listed in Manual-Only Verifications with explicit reason
- [ ] Sampling continuity: every wave has at least one automated verify; no 3 consecutive tasks without automated verify
- [ ] Wave 0 deliverables (`audit.sh`, `canonical-slugs.txt`) created before Wave 1 starts
- [ ] No watch-mode flags (`npm run build`, not `npm run dev` for verification — dev mode used for human inspection only)
- [ ] Feedback latency < 20s (build ~15s + audit ~2s)
- [ ] `nyquist_compliant: true` set in frontmatter when planner approves audit script signatures

**Approval:** pending
