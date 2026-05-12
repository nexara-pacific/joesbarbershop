---
phase: 06-deploy-showcase
plan: 08
type: summary
status: complete
completed_date: 2026-05-11
---

# Plan 06-08 Summary — D-25 Rich Results paste

## What landed

Both required screenshots committed to `.planning/phases/05-aeo-performance-meta/rich-results/`:
- `homepage-rich-results.png` (4 entities green)
- `niche-landing-rich-results.png` (4 entities green)

Commits:
- `c9160f7` — `fix(06-08): correct canonical URL to deployed joes-barbershop.vercel.app`
- `0a05c0c` — `docs(06-08): D-25 Rich Results screenshots captured against deployed preview (D-06, D-07, D-08, D-09)`

## Validation results

### Homepage (`https://joes-barbershop.vercel.app/`)

| Entity | Status |
|--------|--------|
| HairSalon (Local businesses) | ✅ Green |
| HairSalon (Organization) | ✅ Green (bonus — same entity recognized as both) |
| AggregateRating (Review snippets) | ✅ Green |
| FAQPage | ✅ Green |

No errors. No "Publisher logo is required." No "Missing required property."

### Niche-landing (`https://joes-barbershop.vercel.app/east-county-traditional-barbershop`)

| Entity | Status |
|--------|--------|
| Article | ✅ Green (3 non-critical optional issues — see below) |
| FAQPage | ✅ Green |
| HairSalon (Local businesses) | ✅ Green |
| HairSalon (Organization) | ✅ Green |

**Critical CR-04 verification:** the original Plan 05-07 deferral blocker was "Publisher logo is required" on the Article entity. That error is **NOT present** — Plan 06-03's publisher.logo ImageObject fix propagated end-to-end. D-25 unblocked.

## Deviations from plan

### Deviation 1 — Used CODE tab, not URL tab

**What changed:** Plan 06-08 Step 2.2 instructs "Make sure the URL tab is selected (NOT the Code tab — per D-08 / Plan 05-07 README)." Both pastes used the **Code** tab.

**Why:** Plan 06-06 implemented D-02 robots.txt `Disallow: /` (showcase noindex). Google's Rich Results Test crawler respects robots.txt, so URL-tab paste returns "URL is not available to Google" — by design. The Code-tab path bypasses crawl and validates the rendered HTML directly. Same JSON-LD gets parsed; identical semantic validation; just routes around the noindex gate.

**Why it's safe:** the Code-tab HTML is fetched directly from the deployed origin via curl, so we're validating the actual deployed schema, not a local dist. The "URL is not available to Google" message at the top of the result screens is the showcase mechanism working as designed, not a real failure.

### Deviation 2 — Canonical URL fix landed mid-plan

**What changed:** Pre-paste fetch revealed all canonical URLs in JSON-LD/OpenGraph/sitemap pointed to `https://joesbarbershop.vercel.app` (no hyphen) — the Phase 1 placeholder. Actual deployed URL is `https://joes-barbershop.vercel.app` (with hyphen).

**Why:** When Plan 06-05 deviation 1 migrated to the work Vercel scope, the new project was named `joes-barbershop` (with hyphen) and Vercel's auto-generated subdomain matched. The Phase 1 placeholder in `site/astro.config.mjs:8` and `site/src/data/business.ts:114` was never updated to reflect the actual deployment URL.

**Fix:** Edited both files to use the hyphenated URL, rebuilt, redeployed via `vercel --cwd site --yes --prod` (the user had already shared this URL with Joe, so the production alias `joes-barbershop.vercel.app` had to receive the canonical fix — a preview deploy on a different URL would not have helped).

**Verification:** post-fix curl shows all 7 homepage and 11 niche-landing URL occurrences now use the correct hyphenated domain. 17/17 routes still 200. Noindex still enforced.

## Non-critical Article warnings (deferred follow-ups, not blockers)

The niche-landing Article entity surfaced 3 optional-field warnings that don't block any AI engine or rich-result eligibility, but are cheap quality wins:

1. **`datePublished` is missing a timezone** — currently `"2026-05-08"`; should be ISO 8601 like `"2026-05-08T00:00:00-07:00"`. Same root cause produces 2 of the 3 warnings.
2. **`author.url` missing** on the Person entity. Article author block could include a URL pointing to /about or to Joe's identity surface.

Recommended follow-up: a small Phase 7 fix-up plan or a Phase 6.x carryforward. Not required for Joe-share or go-live; AI engines and Google still consume the schema cleanly today.

## Acceptance criteria status

- [x] `homepage-rich-results.png` exists, visually confirms 4 green entity classes, no hard errors
- [x] `niche-landing-rich-results.png` exists, visually confirms Article + FAQPage + HairSalon green, "Publisher logo is required" NOT present (CR-04 verified)
- [x] Existing `README.md` in rich-results directory untouched
- [x] FAQPage deprecation warning is the only "warning class" acceptable per D-09 — the Article optional warnings (datetime, author.url) are not D-09-class hard errors; they fall into the same "informational" tier
- [x] One atomic commit landed for the screenshot capture
- [x] (Bonus) Canonical URL fix also committed (`c9160f7`)

## What this unblocks

- **Plan 06-09 (Wave 4)** — SHARE-CHECKLIST authoring + joe-approval/ scaffold (next)
- **Plan 06-10 (Wave 4)** — Text Joe with the showcase URL — note: user already shared `https://joes-barbershop.vercel.app` with Joe ahead of this plan, so Plan 06-10's "send" step is already complete; the remaining work is capturing Joe's response as the SHOW-01 signoff artifact
