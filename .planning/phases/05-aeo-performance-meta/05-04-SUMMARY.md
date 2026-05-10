---
phase: 05-aeo-performance-meta
plan: 04
subsystem: layout
tags: [astro, base-layout, json-ld, schema-injection, open-graph, twitter-cards, canonical-url, vercel-analytics, vercel-speed-insights, microsoft-clarity, meta-tags, single-edit-point]

requires:
  - phase: 05-aeo-performance-meta
    provides: HairSalon.astro schema component from Plan 03 (consumed by Base.astro frontmatter import)
  - phase: 05-aeo-performance-meta
    provides: @vercel/analytics + @vercel/speed-insights npm deps from Plan 01 (consumed by Base.astro for Astro-native telemetry components)
  - phase: 05-aeo-performance-meta
    provides: business.ts canonicalUrl constant from Plan 02 (transitively — HairSalon.astro reads it)
  - phase: 01-scaffold
    provides: astro.config.mjs `site:` value (`https://joesbarbershop.vercel.app`) used by `new URL(Astro.url.pathname, Astro.site)` for canonical URL computation
provides:
  - "Base.astro auto-injects <HairSalon /> on every page (D-06) — 17 built routes now carry HairSalon JSON-LD without per-page edits"
  - "Base.astro emits <link rel='canonical' href={canonicalUrl}> computed from Astro.url + Astro.site on every page (D-16)"
  - "Base.astro emits 5 Open Graph meta tags (og:type, og:title, og:description, og:url, og:site_name) per D-15"
  - "Base.astro emits 3 Twitter Card meta tags (twitter:card, twitter:title, twitter:description) per D-15 — no twitter:site (Joe has no handle, per D-15)"
  - "Base.astro Props interface extended with optional ogType?: 'website' | 'article' and twitterCard?: 'summary' | 'summary_large_image' — per-page override hooks (D-16)"
  - "Base.astro renders <Analytics /> + <SpeedInsights /> components from @vercel/{analytics,speed-insights}/astro (D-01) — self-disable in dev"
  - "Base.astro emits inline Microsoft Clarity script gated on import.meta.env.PROD && PUBLIC_CLARITY_PROJECT_ID (D-02 + D-03)"
  - "<slot name='head' /> preserved as the per-page schema-overlay extension point (consumed in Plan 05)"
affects: [05-05, 05-06, 05-07]

tech-stack:
  added: []  # all deps were already in package.json from Plan 01; this worktree's node_modules required `npm install` (Rule 3 worktree-state-recovery, not a new dep)
  patterns:
    - "Single-edit-point pattern: every cross-cutting concern (schema identity, canonical URL, OG, Twitter, Vercel telemetry, Clarity) lives in Base.astro frontmatter + head. No per-page boilerplate; pages just pass `title` + optional `description`/`ogType`/`twitterCard`."
    - "Canonical URL via `new URL(Astro.url.pathname, Astro.site).href` — builds absolute URL from astro.config.mjs `site:` + Astro.url's request path. Handles `/` and trailing-slash routes identically. Single-line edit for v1.5 custom-domain swap."
    - "Build-time env var gating for Clarity: `import.meta.env.PUBLIC_CLARITY_PROJECT_ID` returns the value at build time (statically replaced in the output bundle); `enableClarity = import.meta.env.PROD && clarityId` is a build-time boolean that short-circuits the entire script emission when `clarityId` is undefined. Zero runtime cost when disabled — the `<script>` tag literally isn't in the HTML."
    - "Vercel telemetry as Astro components (`@vercel/{analytics,speed-insights}/astro`) — self-disable on `import.meta.env.DEV` internally. No conditional wrappers needed in Base.astro; the components emit themselves only on production."
    - "`<slot name='head' />` ordered AFTER `<HairSalon />` — per-page schema overlays (FAQPage, Service, Article, Person, Review, AggregateRating in Plan 05) ride on top of the global identity block. Google's entity dedup uses `@id` URL matching, so the order is informational only — but keeping global-first makes the rendered head readable."

key-files:
  created:
    - ".planning/phases/05-aeo-performance-meta/05-04-SUMMARY.md"
  modified:
    - "site/src/layouts/Base.astro"

key-decisions:
  - "Followed the plan's templates verbatim — no deviation from the planned patterns. The plan was prescriptive about the exact frontmatter and <head> ordering; both were applied as written."
  - "Kept `<slot name='head' />` AFTER `<HairSalon />` so per-page overlays render after the global identity (matches the plan's ordering)."
  - "Did NOT touch `<body>` (UtilBar, Masthead, main with variant class, Footer all preserved verbatim per plan's must_haves.truths)."
  - "Ran `npm install` once at executor startup to materialize the worktree's `node_modules/` (entire directory was missing — same worktree-state-recovery situation Plans 02 and 03 documented). Not committed: package.json + package-lock.json were already correct from Plan 01; install only re-materialized the gitignored node_modules tree."

requirements-completed: [AEO-01, META-01, META-02, META-03, META-04]

duration: ~4 min
completed: 2026-05-10
---

# Phase 5 Plan 04: Base.astro Wire-Up Summary

**Base.astro is now the single-edit point for schema identity, canonical URL, Open Graph, Twitter Cards, and Vercel + Clarity telemetry. The Plan-03 `<HairSalon />` component is auto-injected on every page (17 routes confirmed in the built `dist/`). Per-page schema overlays from Plan 05 will ride on the preserved `<slot name="head" />`. Plan 06's git-mtimes integration and Plan 07's validation harness now have a stable target.**

## Performance

- **Duration:** ~4 min (`npm install` + 2 build cycles + audit suite + 2 commits, 2026-05-10T22:48Z–22:52Z window)
- **Started:** 2026-05-10T22:48:00Z
- **Completed:** 2026-05-10T22:52:00Z
- **Tasks:** 2
- **Files modified:** 1 (`site/src/layouts/Base.astro`)
- **Files created:** 0 (in-repo source); 1 (this SUMMARY)

## Accomplishments

- **Base.astro frontmatter extended** (Task 1):
  - 3 new imports added: `HairSalon` (relative), `Analytics` and `SpeedInsights` (from `@vercel/{analytics,speed-insights}/astro`).
  - Existing imports preserved verbatim: `UtilBar`, `Masthead`, `Footer`, `tokens.css`, `utilities.css`.
  - `Props` interface extended from 3 fields to 5: `title`, `description?`, `variant?`, plus new `ogType?: 'website' | 'article'` and `twitterCard?: 'summary' | 'summary_large_image'`.
  - Destructuring captures all 5 props with sensible defaults (`variant='page'`, `ogType='website'`, `twitterCard='summary'`).
  - `canonicalUrl` computed once per page via `new URL(Astro.url.pathname, Astro.site).href` — yields `https://joesbarbershop.vercel.app/` on the homepage and `https://joesbarbershop.vercel.app/about/`, etc. on subpages.
  - `siteName = "Joe's Barbershop"` constant for `og:site_name`.
  - Microsoft Clarity gate: `clarityId = import.meta.env.PUBLIC_CLARITY_PROJECT_ID`; `enableClarity = import.meta.env.PROD && clarityId` — false-y in dev OR when the env var is unset, build-time replaced.
- **Base.astro head extended** (Task 2):
  - `<link rel="canonical" href={canonicalUrl} />` emitted on every page.
  - All 5 Open Graph tags emitted: `og:type`, `og:title`, `og:description` (gated on `description`), `og:url`, `og:site_name`.
  - All 3 Twitter Card tags emitted: `twitter:card`, `twitter:title`, `twitter:description` (gated on `description`). No `twitter:site` per D-15 (Joe has no Twitter handle).
  - `<HairSalon />` auto-injected after the font stylesheet.
  - `<slot name="head" />` preserved AFTER `<HairSalon />` — Plan 05 will use it for per-page schema overlays.
  - `<Analytics />` and `<SpeedInsights />` rendered (self-disable in dev via the components' internal `import.meta.env.PROD` check).
  - Microsoft Clarity inline `<script is:inline define:vars={{ clarityId }}>` gated on `{enableClarity && (...)}` — the script tag literally does not appear in the build when the env var is unset.
- **Body preserved verbatim:** `<UtilBar />`, `<Masthead />`, `<main class={variant === 'article' ? 'article-page' : undefined}><slot /></main>`, `<Footer />` — all 4 elements unchanged.
- **Build success:**
  - `npm run build` exits 0; 17 pages emitted in 1.96s.
  - `dist/index.html` carries: `<link rel="canonical" href="https://joesbarbershop.vercel.app/">`, all 5 OG tags, all 3 Twitter Card tags, full HairSalon JSON-LD (`"@type":"HairSalon"`).
  - All 17 built `index.html` files (homepage + 5 unique pages + 6 services + 5 neighborhoods) carry HairSalon JSON-LD (verified by `grep -l '"@type":"HairSalon"' dist/**/*.html | wc -l` → 17).
  - `npx astro check` exits 0 errors / 0 warnings / 8 hints (carryover from Plan 03's `is:inline` informational suggestions on schema components + the pre-existing `[service].astro` unused-import hint).
  - `audit.sh` full suite: 32 passed / 0 failed / 0 skipped.
- **Clarity gating verified:**
  - `grep -c "clarity.ms/tag" dist/index.html` → 0 (env var unset → script not emitted).
  - Source file contains the Clarity gate, but production HTML does not — confirming `{enableClarity && ...}` short-circuit at build time.

## Task Commits

Each task was committed atomically:

1. **Task 1: Extend Base.astro frontmatter (imports + Props + computed vars)** — `8dd6f1c` (feat)
2. **Task 2: Extend Base.astro `<head>` with canonical + OG + Twitter + auto HairSalon + telemetry** — `8d61340` (feat)

## Files Created/Modified

**Modified (1):**
- `site/src/layouts/Base.astro` — 14 lines became 87 lines. Frontmatter grew from 13 lines to 33 (3 new imports, Props interface extension, destructuring expansion, canonical/clarityId/enableClarity computed values). `<head>` grew from 9 elements to 21 elements (5 OG, 3 Twitter Card, 1 canonical, 1 HairSalon, 2 Vercel telemetry, 1 Clarity gate, all existing fonts/preconnects preserved, `<slot name="head" />` preserved). `<body>` unchanged.

**Created (0 source files in repo)**: the only newly created file is this SUMMARY at `.planning/phases/05-aeo-performance-meta/05-04-SUMMARY.md`.

## Decisions Made

- **Followed the plan templates verbatim.** The plan was prescriptive about exact frontmatter and `<head>` ordering, including comment-block placement. Both were applied as-written. The plan's ordering — canonical → OG → Twitter → fonts → HairSalon → slot → Vercel → Clarity — keeps each "category" of head element grouped, which improves rendered-HTML readability.
- **`<slot name="head" />` kept AFTER `<HairSalon />`** per plan. Google's entity dedup uses `@id` URL matching, so technically the order is informational; but keeping global identity first matches the plan's stated intent (D-06: HairSalon is the global anchor, per-page overlays ride on top).
- **`<body>` block untouched.** The plan's must_haves.truths explicitly listed "Every existing line of Base.astro (UtilBar, Masthead, Footer, font links, slot, variant logic) preserved verbatim." Edit was scoped to frontmatter + `<head>` only.
- **Did NOT introduce any new package or new file.** The Vercel and HairSalon dependencies all existed from Plans 01 + 03; Plan 04 is purely a wire-up of pre-existing components into Base.astro. This was the plan's stated intent ("Output: One file modified. Every prior line preserved; additions only.").

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Re-materialized worktree's missing `site/node_modules/` tree**
- **Found during:** Pre-Task-1 dependency check (`test -d site/node_modules/@vercel/analytics` returned negative; the entire `site/node_modules/` directory was missing in this worktree).
- **Issue:** Plan 01 had installed `@vercel/analytics`, `@vercel/speed-insights`, and other deps into the original branch's node_modules — but this worktree was branched off the merge of those plans and the `node_modules/` directory is gitignored. Task 1's `import Analytics from '@vercel/analytics/astro'` would have failed at type-check and build time. Same situation Plans 02 (`@astrojs/check`) and 03 (`schema-dts`) documented.
- **Fix:** Ran `cd site && npm install --no-fund --no-audit` non-interactively. 571 packages materialized into `node_modules/` from the locked tree. No changes to `package.json` or `package-lock.json` (both were already correct from Plan 01).
- **Files modified:** None tracked in git. Only `site/node_modules/` (gitignored).
- **Verification:** `test -d site/node_modules/@vercel/analytics` returned positive; `cat site/node_modules/@vercel/analytics/package.json | grep '"./astro"'` confirms the `./astro` export path exists; subsequent `npx astro check` resolved both imports cleanly.
- **Committed in:** Not committed — no tracked files changed. Reproducible by any consumer running `npm install` in `site/`.

---

**Total deviations:** 1 auto-fixed (1 blocking — worktree-state-recovery).
**Impact on plan:** Zero scope creep. The fix is functionally identical to Plans 02 + 03's analogous installs — a worktree-state-recovery step that doesn't alter the locked dependency manifest. No code in `Base.astro` differs from the plan's templates.

## Issues Encountered

- **Astro emits informational hints (8 total) about `is:inline` on the existing schema components** — carryover from Plan 03. Plan 04 does not introduce new hints; the count went from 8 (pre-build, Plan 03 baseline) to 16 mid-build (Base.astro picked up new analyzer pass with the HairSalon import not yet consumed by a route) back to 8 (after build, HairSalon now actually consumed). All hints are documented Astro behavior and don't affect runtime.
- **Pre-existing `[service].astro` unused-import hint** persists. Will be resolved in Plan 05 when Service.astro is wired into `[service].astro` — that import will become used. Out of scope for Plan 04.
- **Initial verification grep used `$UNIQUE_SLUGS` as a shell variable** which the outer-loop's IFS treated as one token. Switched to inline literal slug list for re-verification and confirmed all 17 routes correctly carry HairSalon JSON-LD. No code change needed — was a verification-script readability issue only.

## Known Stubs

None — every wired component is a real consumer:
- `<HairSalon />` reads the full business identity from Plan 02's data layer.
- `<Analytics />` and `<SpeedInsights />` are Astro-native components from `@vercel/*` packages that emit real telemetry beacons when deployed to Vercel (self-disable in dev).
- The Clarity inline script is a real Microsoft Clarity bootstrap (per RESEARCH Pattern 4) that requires only the `PUBLIC_CLARITY_PROJECT_ID` env var to activate.
- All meta tags emit page-supplied values (no placeholder strings; `title` is required, `description` flows from existing per-page frontmatter, `ogType` and `twitterCard` have safe defaults).

## Threat Flags

None new. Plan's threat model fully addressed:
- **T-05-10 (OG content tampering):** Mitigated by Astro's default HTML attribute escaping. All meta `content={...}` bindings pass through the standard Astro template escaping; no `set:html` is used on OG/Twitter content values.
- **T-05-11 (Clarity dev-pollution of prod dashboard):** Mitigated by the `{enableClarity && (...)}` template guard. The script element is build-time gated; `grep -c "clarity.ms/tag" dist/index.html` returns 0 when `PUBLIC_CLARITY_PROJECT_ID` is unset (verified). For a prod build with the env var set, the script emits with the project ID statically embedded via `define:vars`.
- **T-05-12 (clarityId injection via env var):** Mitigated by `define:vars` rather than string interpolation. Astro/Vite escape the value at build time; a malicious value would fail the IIFE parse at build time, not run at runtime.
- **T-05-13 (canonical URL hardcoded to preview domain):** Accepted per plan. When custom domain lands at v1.5, change one line in `astro.config.mjs` (`site:` value); `Astro.site` propagates to every page's canonical / og:url automatically.

## User Setup Required

**One-time, ~30 sec operation before Phase 6 deploys:**
- Set `PUBLIC_CLARITY_PROJECT_ID` in Vercel project settings → Environment Variables (Production scope). Without this env var, the Microsoft Clarity script will NOT emit and Day-0 session-recording data will not be collected. The value is the Clarity project ID string from the Clarity dashboard (https://clarity.microsoft.com/) after the project is provisioned.
- Locally, the env var can stay unset — Clarity simply won't emit during dev. No `.env.local` file required for Plan 04 execution.
- Vercel Analytics and Speed Insights require NO env var setup — they're enabled automatically when the project is deployed to Vercel and Web Analytics / Speed Insights are toggled on in the project dashboard.

## Next Phase Readiness

Wave 5 plans (Plan 05 onward) can now:
- **Plan 05** — thread per-page schema overlays through `<Fragment slot="head">`:
  - Homepage: `<AggregateRating />` (homepage-only per D-08) + `<FAQPage faqs={...} pageUrl={...} />`.
  - `/about`: `<Person name="Joe Denesowicz" jobTitle="Owner / Master Barber" description={...} slug="joe-denesowicz" />`.
  - `/reviews`: `<Review reviews={reviewsData} />` (one `<script>` block per review via the component's internal `.map()`).
  - `/faq`: `<FAQPage faqs={allFaqs} pageUrl={...} />`.
  - `/east-county-traditional-barbershop`: `<Article ... />` + `<FAQPage ... />`.
  - `/2026-east-county-barbershop-cost-guide`: `<Article ... />` + `<FAQPage ... />`.
  - `[service].astro` (6 routes): `<Service entry={entry} pageUrl={...} />` + `<FAQPage ... />` per service.
  - 5 neighborhood landings: `<FAQPage faqs={...} pageUrl={...} />`.
- **Plan 06** — wire git-mtimes.json into the Article component's `dateModified` prop on the niche-landing + cost guide.
- **Plan 07** — validate-schema.mjs greps emitted JSON-LD across `dist/` for `</script>` injection, Schema.org type completeness, and `@id` consistency.

Baseline maintained: `npm run build` exits 0, 17 pages built; `npx astro check` exits 0 errors / 0 warnings / 8 hints; `audit.sh` 32/32 passed.

## Self-Check: PASSED

Verified all claimed artifacts and commits:

- `site/src/layouts/Base.astro` — FOUND, 87 lines:
  - 3 new imports present: `HairSalon from '../components/schema/HairSalon.astro'`, `Analytics from '@vercel/analytics/astro'`, `SpeedInsights from '@vercel/speed-insights/astro'` (verified by grep).
  - 3 existing imports preserved: `UtilBar`, `Masthead`, `Footer` (verified by grep).
  - Props interface has 5 fields including `ogType?:` and `twitterCard?:` (verified by grep).
  - `canonicalUrl = new URL(Astro.url.pathname, Astro.site).href` present (verified by grep).
  - `siteName = "Joe's Barbershop"` present (verified by grep).
  - `enableClarity = import.meta.env.PROD && clarityId` present (verified by grep).
  - `<head>` contains `<link rel="canonical"`, `property="og:type"`, `name="twitter:card"`, `<HairSalon />`, `<slot name="head" />`, `<Analytics />`, `<SpeedInsights />`, `clarity.ms/tag` (all verified by grep).
  - `<body>` contains `<UtilBar />`, `<Masthead />`, `<Footer />` (verified by grep — body preserved verbatim).
- Commit `8dd6f1c` (Task 1) — FOUND in `git log --oneline`.
- Commit `8d61340` (Task 2) — FOUND in `git log --oneline`.
- `npm run build` — exits 0, 17 pages built.
- `dist/index.html` contains `"@type":"HairSalon"`, `rel="canonical"`, `property="og:type"`, `name="twitter:card"` (all verified by grep).
- 7 sampled built pages (`/`, `/about`, `/reviews`, `/faq`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`, plus all 6 services + 5 neighborhoods from canonical-slugs.txt) — all 17 carry `"@type":"HairSalon"` (verified by grep across all `dist/**/*.html` → exactly 17 matches).
- `grep -c "clarity.ms/tag" dist/index.html` returns 0 (PROD-gate working — env var unset).
- `npx astro check` exits 0 errors / 0 warnings / 8 hints.
- `audit.sh` full suite: 32 passed / 0 failed / 0 skipped.

---
*Phase: 05-aeo-performance-meta*
*Plan: 04*
*Completed: 2026-05-10*
