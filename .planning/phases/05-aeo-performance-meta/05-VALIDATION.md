---
phase: 5
slug: aeo-performance-meta
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-05-10
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

> Filled in by planner during Step 8. Each task gets one row mapping to a REQ-ID and an automated check (preferred) or Wave 0 dependency.

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | Status |
|---------|------|------|-------------|-----------|-------------------|--------|
| TBD | TBD | TBD | TBD | TBD | TBD | ⬜ pending |

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
| Sitemap 17-URL coverage | META-04 | All 17 canonical slugs in `dist/sitemap-0.xml` | `bash scripts/audit.sh check_sitemap_links` | exit 0 |
| Sitemap URLs return 200 | META-04 | Every URL in sitemap HEAD-resolves on `astro preview` | within `check_sitemap_links` | exit 0 |
| robots.txt presence + sitemap ref | META-03 | `dist/robots.txt` exists, contains `Sitemap:` line, URL resolves | `bash scripts/audit.sh check_robots` | exit 0 |
| Text-as-image regression | AEO-07 | Zero matches for `alt=".*\$[0-9]\|alt=".*(haircut\|fade\|shave)"` in `site/src/` | `bash scripts/audit.sh check_text_as_image` | exit 0 |
| BLUF spot-check (5 pages) | AEO-08 | First 100 words of `/`, `/fades`, `/bostonia-barber`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide` each contain business name + location term + service term | `bash scripts/audit.sh check_bluf` | exit 0 |
| Lighthouse Performance mobile | PERF-02 | ≥ 90 (median of 3) | `lighthouse <url> --preset=mobile --output=json --quiet --chrome-flags="--headless --no-sandbox"` | exit 0 |
| Lighthouse Accessibility mobile | PERF-02 | ≥ 95 (median of 3) | within `check_lighthouse` | exit 0 |
| Lighthouse SEO mobile | PERF-02 | ≥ 95 (median of 3) | within `check_lighthouse` | exit 0 |
| LCP mobile | PERF-04 | < 2500 ms | within `check_lighthouse` (read `audits['largest-contentful-paint'].numericValue`) | exit 0 |
| CLS mobile | PERF-04 | < 0.1 | within `check_lighthouse` (read `audits['cumulative-layout-shift'].numericValue`) | exit 0 |
| Hero `fetchpriority="high"` | PERF-03 | Homepage HTML contains `fetchpriority="high"` on hero `<img>` | `grep -c 'fetchpriority="high"' dist/index.html` ≥ 1 | exit 0 |
| Below-fold lazy loading | PERF-03 | All non-hero images carry `loading="lazy"` | grep heuristic in `check_lighthouse` | exit 0 |
| `</script>` XSS guard | AEO-01 | No JSON-LD block contains the substring `</script>` | within `validate-schema.mjs` | exit 0 |
| `@id` cross-page dedup | AEO-02 | Every page emitting business entity uses identical `"@id"` URL | within `validate-schema.mjs` | exit 0 |

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Google Rich Results Test paste | AEO-06 | Google's validator catches issues a generic JSON-LD parser misses (e.g., Article without `image`); no API for the eyeball gate | Paste rendered HTML of `/` and `/east-county-traditional-barbershop` into `https://search.google.com/test/rich-results`; capture screenshots; store in `.planning/phases/05-aeo-performance-meta/rich-results/` |
| Microsoft Clarity dashboard receives sessions | MEAS-01 (partial; full verification in Phase 7) | Requires real-browser interaction post-deploy; no automated path | After Phase 6 deploys to Vercel preview, open the preview URL on a phone, confirm session appears in `clarity.microsoft.com` dashboard within 5 min |
| Vercel Web Analytics dashboard receives pageviews | MEAS-02 (partial) | Same — needs production-mode deploy | After Phase 6 deploy, navigate 3 routes, confirm pageviews in Vercel Analytics tab within 5 min |
| Vercel Speed Insights surfaces Core Web Vitals | MEAS-02 (partial) | Same — needs real user metrics | After Phase 6 + 24h idle, confirm Speed Insights tab shows non-zero LCP/FID/CLS data |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references (validate-schema.mjs, generate-mtimes.mjs, robots.txt, .env.example, devDeps install)
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s (quick) / 5 min (full)
- [ ] `nyquist_compliant: true` set in frontmatter (after planner fills Per-Task map)

**Approval:** pending
