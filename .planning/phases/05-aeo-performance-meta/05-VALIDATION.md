---
phase: 5
slug: aeo-performance-meta
status: ready
nyquist_compliant: true
wave_0_complete: false
created: 2026-05-10
revised: 2026-05-10
---

# Phase 5 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | `bash scripts/audit.sh` (existing, extended in Wave 6) + `node scripts/validate-schema.mjs` (new) + `lighthouse` CLI |
| **Config file** | `scripts/audit.sh`, `scripts/validate-schema.mjs`, `scripts/canonical-slugs.txt` |
| **Quick run command** | `npm run build && bash scripts/audit.sh --quick` (skips Lighthouse — ~10–15s) |
| **Full suite command** | `npm run build && bash scripts/audit.sh phase-5` (includes Lighthouse median-of-3) |
| **Estimated runtime** | Quick: ~15s; Full: ~3–5 min (Lighthouse dominant) |

---

## Sampling Rate

- **After every task commit:** Run `npm run build` (catches schema component compile errors immediately)
- **After every plan wave:** Run `bash scripts/audit.sh --quick` (validates JSON-LD + sitemap + robots without Lighthouse)
- **Before `/gsd-verify-work`:** Full suite (`bash scripts/audit.sh phase-5`) must exit 0
- **Max feedback latency:** 15s for quick run; 5 min for full suite

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | Status |
|---------|------|------|-------------|-----------|-------------------|--------|
| 05-01-T1 | 05-01 | 1 | META-04 (env scaffolding) | structural | `node -e "..." && test -f .env.example && test -f public/robots.txt && test -f rich-results/.gitkeep && ! git check-ignore site/.env.example` | ⬜ pending |
| 05-01-T2 | 05-01 | 1 | (scaffolding for AEO-01..06 + AEO-06) | structural | `node site/scripts/validate-schema.mjs && node site/scripts/generate-mtimes.mjs && grep -q "git-mtimes.json" site/.gitignore` | ⬜ pending |
| 05-01-T3 | 05-01 | 1 | (scaffolding for D-23 check_* dispatch) | structural | `bash audit.sh jsonld && ... && [ "$(grep -cE '^check_(jsonld|sitemap_links|robots|text_as_image|bluf|lighthouse)\(\)' audit.sh)" = "6" ]` | ⬜ pending |
| 05-02-T1 | 05-02 | 2 | AEO-04, AEO-05, AEO-09 (data layer) | structural | `node -e "const b=require('./site/src/data/business.json'); if(typeof b.geo?.latitude!=='number'||b.priceRange!=='\\$\\$') process.exit(1)"` | ⬜ pending |
| 05-02-T2 | 05-02 | 2 | AEO-04, AEO-05, AEO-09 (helpers) | structural | `cd site && npx astro check 2>&1 | grep -q "0 errors" && [ "$(grep -cE '^export (function|const) (toE164\|toOpeningHoursSpecification\|aggregateRating\|canonicalUrl)' src/data/business.ts)" = "4" ]` | ⬜ pending |
| 05-03-T1 | 05-03 | 3 | AEO-01, AEO-02, AEO-03, AEO-09 (4 schema components) | structural | `cd site && npx astro check 2>&1 | grep -q "0 errors" && [ "$(ls src/components/schema/*.astro 2>/dev/null | wc -l | tr -d ' ')" -ge "4" ] && grep -q "'@type': 'HairSalon'" src/components/schema/HairSalon.astro` | ⬜ pending |
| 05-03-T2 | 05-03 | 3 | AEO-04, AEO-06 (3 schema components) | structural | `cd site && npx astro check 2>&1 | grep -q "0 errors" && [ "$(ls src/components/schema/*.astro 2>/dev/null | wc -l | tr -d ' ')" = "7" ] && npm run build` | ⬜ pending |
| 05-04-T1 | 05-04 | 4 | AEO-01, META-01, META-02, META-03 (Base frontmatter) | structural | `cd site && npx astro check 2>&1 | grep -q "0 errors" && grep -q "PUBLIC_CLARITY_PROJECT_ID" src/layouts/Base.astro && grep -q "canonicalUrl = new URL" src/layouts/Base.astro` | ⬜ pending |
| 05-04-T2 | 05-04 | 4 | AEO-01, META-01, META-02, META-03 (Base head emission, all 17 pages) | structural | `cd site && npm run build && while IFS= read -r slug; do path="dist/${slug}/index.html"; [ "$slug" = "/" ] && path="dist/index.html"; grep -q '"@type":"HairSalon"' "$path"; done < /tmp/all-17-slugs.txt` | ⬜ pending |
| 05-05-T1 | 05-05 | 5 | AEO-02, AEO-04, AEO-06, AEO-08 (4 unique pages) | structural | `cd site && npm run build && grep -q '"@type":"AggregateRating"' dist/index.html && grep -q '"@type":"Person"' dist/about/index.html && grep -q '"@type":"Review"' dist/reviews/index.html && grep -q '"@type":"FAQPage"' dist/faq/index.html` | ⬜ pending |
| 05-05-T2 | 05-05 | 5 | AEO-02, AEO-06 (2 Article pages) | structural | `cd site && npm run build && grep -q '"@type":"Article"' dist/east-county-traditional-barbershop/index.html && grep -q '"@type":"Article"' dist/2026-east-county-barbershop-cost-guide/index.html && grep -q 'property="og:type" content="article"' dist/east-county-traditional-barbershop/index.html` | ⬜ pending |
| 05-05-T3 | 05-05 | 5 | AEO-03, AEO-07, PERF-03 (templated pages + hero priority) | structural | `cd site && npm run build && for slug in fades classic-cut kids-cuts beard-trim line-up hot-towel-shave; do grep -q '"@type":"Service"' "dist/${slug}/index.html"; done && [ "$(grep -c 'fetchpriority=\"high\"' dist/index.html)" = "1" ]` | ⬜ pending |
| 05-06-T1 | 05-06 | 6 | AEO-06 (git mtime script + prebuild) | structural | `node site/scripts/generate-mtimes.mjs && node -e "const m=require('./site/src/data/git-mtimes.json'); if(Object.keys(m).length!==2) process.exit(1)" && grep -q '"prebuild":' site/package.json` | ⬜ pending |
| 05-06-T2 | 05-06 | 6 | AEO-06 (LastUpdated + Article dateModified) | structural | `cd site && npm run build && grep -q "Last updated:" dist/east-county-traditional-barbershop/index.html && grep -q "Last updated:" dist/2026-east-county-barbershop-cost-guide/index.html && [ "$(grep -c 'TODO Plan 06' src/pages/east-county-traditional-barbershop.astro)" = "0" ]` | ⬜ pending |
| 05-07-T1 | 05-07 | 7 | AEO-01..06 (validate-schema.mjs real) | structural | `cd site && npm run build && node scripts/validate-schema.mjs` | ⬜ pending |
| 05-07-T2 | 05-07 | 7 | AEO-07, AEO-08, PERF-01..04, META-02, META-03 (5 real check_* + responsive verification) | metric | `cd site && npm run build && bash ../.planning/phases/03-unique-pages/scripts/audit.sh phase-5` | ⬜ pending |
| 05-07-T3 | 05-07 | 7 | AEO-06 (D-25 manual gate) | manual | `test -s .planning/phases/05-aeo-performance-meta/rich-results/homepage-rich-results.png && test -s .planning/phases/05-aeo-performance-meta/rich-results/niche-landing-rich-results.png` | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `scripts/validate-schema.mjs` — node script parsing `dist/**/*.html` for `<script type="application/ld+json">` blocks; required-field validation per Schema.org type
- [ ] `scripts/generate-mtimes.mjs` — pre-build script writing `src/data/git-mtimes.json` from `git log -1 --format=%cI`
- [ ] `scripts/canonical-slugs.txt` — already exists from Phase 3; no Wave 0 work
- [ ] `site/public/robots.txt` — hand-written, references `https://joesbarbershop.vercel.app/sitemap-index.xml`
- [ ] `.env.example` — documents `PUBLIC_CLARITY_PROJECT_ID`
- [ ] `.planning/phases/05-aeo-performance-meta/rich-results/` — directory for D-25 manual paste screenshots
- [ ] devDeps installed — `lighthouse`, `schema-dts`, `cheerio`
- [ ] runtime deps installed — `@vercel/analytics`, `@vercel/speed-insights`
- [ ] `audit.sh` extended with 6 new check functions (D-23): `check_jsonld`, `check_sitemap_links`, `check_robots`, `check_text_as_image`, `check_bluf`, `check_lighthouse`

---

## Automated Check Thresholds (D-23 contract)

Each check exits non-zero with a clear "WHY this failed + WHAT TO FIX" message.

| Check | Requirement | Threshold | Command | Acceptance |
|-------|-------------|-----------|---------|------------|
| JSON-LD parse + required fields | AEO-01..06 | 100% pages parse; all required fields present per Schema.org type | `node scripts/validate-schema.mjs` | exit 0 |
| Sitemap 17-URL coverage | META-01, META-04 | All 17 canonical slugs in `dist/sitemap-0.xml` | `bash scripts/audit.sh check_sitemap_links` | exit 0 |
| Sitemap URLs return 200 | META-01 | Every URL in sitemap HEAD-resolves on `astro preview` | within `check_sitemap_links` | exit 0 |
| robots.txt presence + sitemap ref | META-04 | `dist/robots.txt` exists, contains `Sitemap:` line, URL resolves | `bash scripts/audit.sh check_robots` | exit 0 |
| Meta uniqueness (title + description) | META-02 | Every dist/**/*.html has a `<title>` and `<meta name="description">`; values are unique across all 17 pages | `bash scripts/audit.sh check_meta_unique_titles` | exit 0 |
| OG + Twitter Card on every page | META-03 | Every dist/**/*.html contains `og:title`, `og:url`, `og:type`, `og:site_name`, `twitter:card`, `twitter:title` | `bash scripts/audit.sh check_meta_og_twitter` | exit 0 |
| Text-as-image regression | AEO-07 | Zero matches for `alt=".*\$[0-9]\|alt=".*(haircut\|fade\|shave)"` in `site/src/` | `bash scripts/audit.sh check_text_as_image` | exit 0 |
| BLUF spot-check (5 pages) | AEO-08 | First 100 words of `/`, `/fades`, `/bostonia-barber`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide` each contain business name + location term + service term | `bash scripts/audit.sh check_bluf` | exit 0 |
| Lighthouse Performance mobile | PERF-02 | ≥ 90 (median of 3) | `lighthouse <url> --preset=mobile --output=json --quiet --chrome-flags="--headless --no-sandbox"` | exit 0 |
| Lighthouse Accessibility mobile | PERF-02 | ≥ 95 (median of 3) | within `check_lighthouse` | exit 0 |
| Lighthouse SEO mobile | PERF-02 | ≥ 95 (median of 3) | within `check_lighthouse` | exit 0 |
| LCP mobile | PERF-04 | < 2500 ms | within `check_lighthouse` (read `audits['largest-contentful-paint'].numericValue`) | exit 0 |
| CLS mobile | PERF-04 | < 0.1 | within `check_lighthouse` (read `audits['cumulative-layout-shift'].numericValue`) | exit 0 |
| Responsive breakpoints (980px + 600px) | PERF-01 | OD-5 CSS port (Phase 1 DESN-01) preserves `980px` and `600px` media queries; spot-check sample article width holds at both breakpoints | `bash scripts/audit.sh check_responsive_breakpoints` + manual viewport-resize checkpoint in 05-07-T2 | exit 0 |
| Hero `fetchpriority="high"` | PERF-03 | Homepage HTML contains `fetchpriority="high"` on hero `<img>` | `grep -c 'fetchpriority="high"' dist/index.html` ≥ 1 | exit 0 |
| Below-fold lazy loading | PERF-03 | All non-hero images carry `loading="lazy"` | grep heuristic in `check_lighthouse` | exit 0 |
| `</script>` XSS guard | AEO-01 | No JSON-LD block contains the substring `</script>` | within `validate-schema.mjs` | exit 0 |
| `@id` cross-page dedup | AEO-02 | Every page emitting business entity uses identical `"@id"` URL | within `validate-schema.mjs` | exit 0 |

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Google Rich Results Test paste | AEO-06 | Google's validator catches issues a generic JSON-LD parser misses (e.g., Article without `image`); no API for the eyeball gate | Paste rendered HTML of `/` and `/east-county-traditional-barbershop` into `https://search.google.com/test/rich-results`; capture screenshots; store in `.planning/phases/05-aeo-performance-meta/rich-results/` |
| Responsive parity at 980px + 600px | PERF-01 | Visual judgment of layout integrity at the two named breakpoints — automated checks confirm CSS presence; eyeballing confirms intended layout | After Plan 04 + Plan 05 ship, open the built homepage + a service page + a neighborhood page in a browser; resize viewport to 980px and 600px; confirm no horizontal scroll, hero/typography reflow as designed. Discharged largely by Phase 1 DESN-01 (OD-5 CSS port) and Phase 4 responsive templates; Phase 5 verifies no regression. |
| Microsoft Clarity dashboard receives sessions | MEAS-01 (partial; full verification in Phase 7) | Requires real-browser interaction post-deploy; no automated path | After Phase 6 deploys to Vercel preview, open the preview URL on a phone, confirm session appears in `clarity.microsoft.com` dashboard within 5 min |
| Vercel Web Analytics dashboard receives pageviews | MEAS-02 (partial) | Same — needs production-mode deploy | After Phase 6 deploy, navigate 3 routes, confirm pageviews in Vercel Analytics tab within 5 min |
| Vercel Speed Insights surfaces Core Web Vitals | MEAS-02 (partial) | Same — needs real user metrics | After Phase 6 + 24h idle, confirm Speed Insights tab shows non-zero LCP/FID/CLS data |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify or Wave 0 dependencies
- [x] Sampling continuity: no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references (validate-schema.mjs, generate-mtimes.mjs, robots.txt, .env.example, devDeps install)
- [x] No watch-mode flags
- [x] Feedback latency < 15s (quick) / 5 min (full)
- [x] `nyquist_compliant: true` set in frontmatter (Per-Task map populated 2026-05-10)

**Approval:** ready
