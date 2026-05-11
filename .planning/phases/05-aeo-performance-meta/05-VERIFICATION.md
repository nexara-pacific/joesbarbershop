---
phase: 05-aeo-performance-meta
verified: 2026-05-11T02:05:15Z
gap_closed: 2026-05-11T02:23:10Z
status: passed
score: 5/5 must-haves verified
overrides_applied: 0
gaps_resolved:
  - truth: "Every page ships valid JSON-LD without misleading or placeholder data leaking into the live entity graph"
    original_status: failed
    resolution: "Inline fix committed at 69c2fa1 — business.sameAs.gbp set to real Google Maps short link https://maps.app.goo.gl/fgNmMDkXDYLKJnP68 (resolves to Joe's Barbershop place card, FID 0x87c97e76f07f22ce at 32.8184653,-116.9516888). HairSalon.astro:32 filter hardened with `&& !u.includes('PLACEHOLDER')` defense-in-depth check. Post-fix verification: 0 PLACEHOLDER hits across dist/, 17 pages emit real GBP URL, audit suite 36/0/0, Lighthouse unchanged."
    resolved_by: "main branch fix commit (not gap-closure phase)"
human_verification:
  - test: "Google Rich Results Test against /, /east-county-traditional-barbershop, /2026-east-county-barbershop-cost-guide, /faq on the deployed Vercel preview URL"
    expected: "Green entities for HairSalon (recognized as LocalBusiness subtype), AggregateRating, FAQPage, Article. FAQPage deprecation warnings acceptable per RESEARCH Pitfall 8. NO 'Publisher logo is required' or other hard errors on Article schema."
    why_human: "D-25 manual gate was explicitly deferred from Plan 07 to Phase 6 per orchestrator/user decision (recorded in rich-results/README.md + 05-07-SUMMARY.md). Verifier accepts this deferral as a documented decision but flags here that the manual visual signal — including the impact of CR-04 (Article missing publisher.logo + publisher.url) on Rich Results eligibility — has not been confirmed against deployed HTML."
  - test: "Mobile breakpoint visual parity at 980px and 600px against OD-5 mockup"
    expected: "Layout reflows cleanly at both breakpoints; no broken grids, overlapping text, or images escaping containers."
    why_human: "check_responsive_breakpoints (PERF-01) only greps for the @media rules' existence — it cannot verify the rendered layout matches OD-5. Per Plan 07 Task 4 (revision), visual confirmation at the two breakpoints is the manual checkpoint."
---

# Phase 5: AEO + Performance + Meta — Verification Report

**Phase Goal:** Every page ships valid JSON-LD schema, passes Lighthouse mobile thresholds, and has complete meta tags — making the site parseable by AI crawlers and search engines without structural gaps.

**Verified:** 2026-05-11T02:05:15Z (initial — gaps_found)
**Gap closed:** 2026-05-11T02:23:10Z (inline fix 69c2fa1)
**Status:** passed
**Re-verification:** Inline post-fix — placeholder gap resolved

## Goal Achievement

### Observable Truths (5 Roadmap Success Criteria)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | Google Rich Results Test validates HairSalon + LocalBusiness JSON-LD on / and FAQPage JSON-LD on at least one FAQ-bearing page (D-25 manual gate deferred to Phase 6 per user authority) | OK VERIFIED (post-fix) | HairSalon JSON-LD emits on all 17 pages (HairSalon IS a LocalBusiness subtype per Schema.org inheritance). FAQPage emits on 13 pages (homepage + faq + niche-landing + cost-guide + 6 services + 5 neighborhoods). Initial verification flagged a PLACEHOLDER URL leaking through sameAs — resolved inline at commit 69c2fa1 by setting `business.sameAs.gbp` to Joe's real Maps short link `https://maps.app.goo.gl/fgNmMDkXDYLKJnP68` (resolves to Joe's Barbershop place card) and hardening the HairSalon.astro:32 filter with a PLACEHOLDER guard. Post-fix grep: 0 PLACEHOLDER hits across dist/, 17 hits of the real GBP URL. D-25 manual Rich Results paste remains deferred to Phase 6 against the deployed Vercel preview (documented in `rich-results/README.md` + `05-07-SUMMARY.md`). |
| 2 | Lighthouse mobile on / reports Performance >= 90, Accessibility >= 95, SEO >= 95; LCP < 2.5s and CLS < 0.1 | OK VERIFIED | Median-of-3 from audit.sh check_lighthouse: perf=1.00, a11y=0.98, seo=1.00, LCP=1474.58ms, CLS=0.016. All five metrics exceed thresholds with comfortable margins (perf +0.10, a11y +0.03, seo +0.05, LCP -1025ms, CLS -0.084). |
| 3 | sitemap.xml lists all 17 URLs; robots.txt references it; every page has a unique <title>, <meta name="description">, and Open Graph tags | OK VERIFIED | dist/sitemap-0.xml contains 17 <loc> entries (counted: 1 homepage + 11 templated slugs + 5 unique pages = 17). dist/robots.txt contains `User-agent: *`, `Allow: /`, `Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml`. audit.sh check_meta_unique_titles passes (no duplicate <title> or <meta description> across the 17 pages). audit.sh check_meta_og_twitter passes (all 6 required OG/Twitter tags on every page — og:title, og:url, og:type, og:site_name, twitter:card, twitter:title). Spot-checked dist/index.html: canonical, og:type=website, og:title, og:description, og:url, og:site_name, twitter:card=summary, twitter:title, twitter:description all present. |
| 4 | No page has text inside an <img> that conveys service names, hours, prices, or FAQ questions — all such content is in real DOM text nodes | OK VERIFIED | audit.sh check_text_as_image passes against the src/pages + src/components alt-text grep (price markers + service words 'haircut\|fade\|shave\|hours'). Spot-grep confirmed no matches in source files. |
| 5 | The first 100 words of every page are declarative entity-first prose | OK VERIFIED | audit.sh check_bluf passes on 5 sampled pages (index, fades, bostonia-barber, east-county-traditional-barbershop, 2026-east-county-barbershop-cost-guide); each contains business name + location term + service term in first ~600 chars of `<main>`. Manual spot-check of dist/index.html confirms: BLUF opens with "Joe's Barbershop is the only traditional barbershop in Bostonia — checkerboard floors, mahogany chairs, and a letter board that shows $30 before you sit down. Same barber every visit. Walk-ins always welcome, Tuesday through Saturday. Cash only..." Entity-first, declarative, AEO-grade. |

**Score: 5 of 5 must-haves verified** (initial 4/5 → 5/5 after inline gap closure at 69c2fa1).

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `site/src/components/schema/HairSalon.astro` | Auto-injected HairSalon LocalBusiness JSON-LD | OK VERIFIED | Emits via Base.astro on all 17 dist pages; required fields name, address, telephone, openingHoursSpecification all present per validate-schema.mjs |
| `site/src/components/schema/AggregateRating.astro` | Homepage rating schema | OK VERIFIED | Emits on dist/index.html only; references HairSalon via @id |
| `site/src/components/schema/FAQPage.astro` | Per-page FAQ overlay | OK VERIFIED | Emits on 13 dist pages (homepage + faq + niche-landing + cost-guide + 6 services + 5 neighborhoods — though spot grep verified key set) |
| `site/src/components/schema/Service.astro` | Service schema on 6 service pages | OK VERIFIED | Emits on dist/{fades,classic-cut,kids-cuts,beard-trim,line-up,hot-towel-shave}/index.html |
| `site/src/components/schema/Person.astro` | Joe Denesowicz Person on /about | OK VERIFIED | Emits on dist/about/index.html; worksFor.@id references business |
| `site/src/components/schema/Article.astro` | Article schema on 2 Article pages | WARN PARTIAL | Emits on both Article pages with real datePublished + dateModified (git-mtime-driven), image field present. **However, `publisher` lacks `url` and `logo` fields** that Google Article rich-result eligibility requires (CR-04). validate-schema.mjs checks Schema.org required fields only — Google's stricter Rich Results validator will flag this at Phase 6's deferred D-25 manual gate. |
| `site/src/components/schema/Review.astro` | Review[] on /reviews | OK VERIFIED | Emits on dist/reviews/index.html; itemReviewed.@id references business |
| `site/src/components/LastUpdated.astro` | Visible "Last updated:" line | OK VERIFIED | Renders on dist/east-county-traditional-barbershop/index.html and dist/2026-east-county-barbershop-cost-guide/index.html (grep -c "Last updated:" returns 1 each) |
| `site/src/data/business.json` | NAP + geo + priceRange + hours + ratings + sameAs | WARN PARTIAL | All required fields present and typed. **However, sameAs.gbp is the literal placeholder `"https://maps.google.com/?cid=PLACEHOLDER-confirm-with-Joe"` which flows through to all 17 dist pages' JSON-LD without sanitization (CR-01).** |
| `site/src/data/business.ts` | Typed view + helpers (toE164, toOpeningHoursSpecification, aggregateRating, canonicalUrl) | OK VERIFIED | All 4 named exports present; BusinessRecord interface includes geo + priceRange; npx astro check exits 0 |
| `site/src/layouts/Base.astro` | Auto-emit HairSalon + canonical + OG + Twitter + telemetry | OK VERIFIED | All directives present and rendering in dist (verified per-page spot-checks) |
| `site/public/robots.txt` | allow-all + Sitemap directive | OK VERIFIED | Renders verbatim to dist/robots.txt |
| `site/scripts/validate-schema.mjs` | Real cheerio JSON-LD validator | OK VERIFIED | 14-type REQUIRED-fields map; recursive nested-object walk; Pitfall 1 `</script>` guard. Exits 0 against current build. |
| `site/scripts/generate-mtimes.mjs` | Real git-mtime walker with prebuild hook | OK VERIFIED | Writes site/src/data/git-mtimes.json with real ISO timestamps; package.json scripts.prebuild wires it; npm run build regenerates manifest before astro build |
| `site/src/data/git-mtimes.json` | Generated mtime manifest | OK VERIFIED | Gitignored; contains 2 entries (the 2 Article pages) with real ISO 8601 timestamps |
| `.planning/phases/03-unique-pages/scripts/audit.sh` | 9 Phase 5 check_* functions with real bodies | OK VERIFIED | Full suite exits 0 with 36 passed / 0 failed / 0 skipped. All 9 Phase 5 checks have real implementations replacing Plan 01 stubs. |
| `.planning/phases/05-aeo-performance-meta/rich-results/homepage-rich-results.png` | D-25 screenshot | WARN DEFERRED | Not present. README.md placeholder documents that this artifact is deferred to Phase 6 against the deployed Vercel preview URL per user-authorized decision at orchestrator checkpoint. Verifier accepts the deferral as documented but flags in human_verification. |
| `.planning/phases/05-aeo-performance-meta/rich-results/niche-landing-rich-results.png` | D-25 screenshot | WARN DEFERRED | Same as above |

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|----|--------|---------|
| Base.astro | schema/HairSalon.astro | import + render | OK WIRED | `<HairSalon />` emits on all 17 dist pages |
| page files (8 of them) | schema/*.astro | `<Fragment slot="head">` | OK WIRED | Each archetype emits its expected overlay (Service on services, Person on /about, Review on /reviews, Article on the 2 Article pages, FAQPage broadly, AggregateRating only on /) |
| business.ts | business.json | import + typed cast | OK WIRED | `businessData as BusinessRecord` |
| HairSalon.astro | business.json sameAs | filter + JSON.stringify | x BROKEN | Filter only drops empty strings; placeholder URL passes through. **CR-01 BLOCKER.** |
| Article.astro | publisher.logo | required by Google Rich Results | x MISSING | Schema emits publisher with @id but NO logo + NO url. validate-schema.mjs does not check this; Google's Rich Results validator will. **CR-04 — material risk to AEO eligibility.** |
| Article pages | git-mtimes.json | `import mtimes from '../data/git-mtimes.json'` | OK WIRED | dateModified in dist HTML is a real 2026-05-10T16:11:22-07:00 timestamp, not the placeholder string |
| audit.sh check_jsonld | validate-schema.mjs | node subshell from REPO_ROOT | OK WIRED | check_jsonld invokes the validator and propagates exit code |
| package.json scripts.prebuild | generate-mtimes.mjs | npm prebuild lifecycle | OK WIRED | `npm run build` runs prebuild → mtime generation → astro build |
| robots.txt | sitemap-index.xml | Sitemap: directive | OK WIRED | dist/robots.txt contains the directive line verbatim |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
|----------|---------------|--------|---------------------|--------|
| HairSalon.astro | business (NAP, hours, geo, priceRange) | business.json via business.ts | Yes (all fields populated) | OK FLOWING |
| HairSalon.astro | business.sameAs (URL list) | business.json | Mostly yes; one entry is `PLACEHOLDER-confirm-with-Joe` literal | WARN STATIC (placeholder leaks) |
| AggregateRating.astro | aggregateRating(business.ratings) | weighted average 5.0*114 + 4.9*33 / 147 = 4.98 | Yes (real values) | OK FLOWING |
| Article.astro | dateModified | mtimes[page-path] from git log | Yes (real 2026-05-10 ISO timestamps) | OK FLOWING |
| LastUpdated.astro | isoDate | Article page's dateModified | Yes ("Last updated: May 10, 2026" rendered to dist) | OK FLOWING |
| FAQPage.astro | faqs prop | Per-page content collection or hand-typed homepageFaqs/allFaqs arrays | Yes (visible Q&A text matches schema text) | OK FLOWING |
| Service.astro | entry.data.price | services content collection | Yes (real values $30, $50, etc) | OK FLOWING |
| Review.astro | reviews prop | site/src/data/reviews.json | Yes (real customer quotes from Google + Yelp scrapes) | OK FLOWING |

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| validate-schema.mjs exits 0 against current build | `node site/scripts/validate-schema.mjs` | `validate-schema.mjs — OK (all JSON-LD blocks validate)` | OK PASS |
| Full audit suite exits 0 | `bash .planning/phases/03-unique-pages/scripts/audit.sh` | `audit complete: 36 passed, 0 failed, 0 skipped` | OK PASS |
| HairSalon emits on all 17 pages | `grep -c '"@type":"HairSalon"' dist/**/index.html dist/index.html` | 17 hits | OK PASS |
| Sitemap lists all 17 URLs | `grep -c '<loc>' dist/sitemap-0.xml` | 17 | OK PASS |
| robots.txt contains Sitemap directive | `grep '^Sitemap:' dist/robots.txt` | `Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml` | OK PASS |
| Article.dateModified is real ISO timestamp | `grep -oE '"dateModified":"[^"]+"' dist/east-county-traditional-barbershop/index.html` | `"dateModified":"2026-05-10T16:11:22-07:00"` | OK PASS |
| LastUpdated rendered on Article pages | `grep -c 'Last updated:' dist/east-county-*/index.html` | 1 each | OK PASS |
| PLACEHOLDER URL absent from dist | `grep -c "PLACEHOLDER-confirm-with-Joe" dist/**/*.html` | **17 hits across all built pages** | x FAIL |
| Article publisher.logo present | `grep -oE '"publisher":\{[^}]+\}' dist/east-county-traditional-barbershop/index.html` | `"publisher":{"@type":"Organization","@id":"...#business","name":"Joe's Barbershop"}` — no logo, no url | x FAIL |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| AEO-01 | 05-03, 05-04, 05-07 | HairSalonSchema emits LocalBusiness + HairSalon JSON-LD on every page | OK SATISFIED (with warning) | HairSalon emits on all 17 dist pages; HairSalon IS LocalBusiness via Schema.org inheritance. Warning: sameAs poisoned by placeholder URL |
| AEO-02 | 05-03, 05-05, 05-07 | FAQPageSchema emits on every FAQ-bearing page | OK SATISFIED | FAQPage emits on / + /faq + 2 Article pages + 6 services + 5 neighborhoods |
| AEO-03 | 05-03, 05-05, 05-07 | ServiceSchema on each service page | OK SATISFIED | Service emits on all 6 service pages |
| AEO-04 | 05-03, 05-04, 05-05, 05-07 | PersonSchema for Joe on /about | OK SATISFIED | Per D-09, Alex de-scoped; Joe-only emission as planned |
| AEO-05 | 05-02, 05-07 | BLUF answer capsule in first 100 words of every page | OK SATISFIED | check_bluf passes; manual spot-check on homepage confirms |
| AEO-06 | 05-06, 05-07 | Zero tabs/accordions — flat FAQ HTML | OK SATISFIED | All FAQ rendering is flat `<article class="faq-q">` per Phase 3 D-19; no JS toggle anywhere |
| AEO-07 | 05-05, 05-07 | No text-as-image | OK SATISFIED | check_text_as_image passes; spot-grep confirms |
| AEO-08 | 05-05, 05-07 | H2/H3 sections as self-contained answer capsules | OK SATISFIED | check_bluf gates first-100-words; H2/H3 capsule discipline carried from Phase 3 |
| AEO-09 | 05-02, 05-03, 05-07 | sameAs links to GBP, Yelp, IG, FB | x BLOCKED | GBP entry is a placeholder URL, not a real GBP canonical URL. The phase technically emits a sameAs entry for "gbp", but the entry is broken. **CR-01 BLOCKER.** |
| PERF-01 | 05-07 | Mobile responsive parity (980px + 600px breakpoints) | OK SATISFIED | check_responsive_breakpoints passes (greps confirm @media rules in src/). Note: visual confirmation deferred to human verification |
| PERF-02 | 05-04, 05-07 | Lighthouse mobile P>=90, A>=95, S>=95 | OK SATISFIED | Median perf=1.00, a11y=0.98, seo=1.00 |
| PERF-03 | 05-04, 05-05, 05-07 | Hero fetchpriority="high"; below-fold lazy | OK SATISFIED | grep -c fetchpriority="high" returns 1 on index.html, fades/index.html, bostonia-barber/index.html |
| PERF-04 | 05-04, 05-07 | LCP < 2.5s, CLS < 0.1 | OK SATISFIED | Median LCP=1.47s, CLS=0.016 |
| META-01 | 05-01, 05-07 | sitemap.xml covers all 17-19 pages | OK SATISFIED | dist/sitemap-0.xml has 17 entries |
| META-02 | 05-04, 05-07 | Unique title + meta description per page | OK SATISFIED | check_meta_unique_titles passes; spot-check on 5 pages confirms uniqueness |
| META-03 | 05-01, 05-04, 05-07 | Open Graph + Twitter Card on every page | OK SATISFIED | check_meta_og_twitter passes; spot-check on homepage confirms 6 OG + 3 Twitter tags |
| META-04 | 05-01, 05-04, 05-07 | robots.txt allows all, references sitemap | OK SATISFIED | dist/robots.txt has User-agent: *, Allow: /, Sitemap: directive |

All 17 Phase 5 requirements are mapped to plans. **AEO-09 is BLOCKED** by the placeholder URL leak (CR-01); all other 16 are satisfied with one warning on AEO-01 (Article publisher.logo per CR-04 affects Article rich-result eligibility but does not invalidate HairSalon AEO-01).

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| site/src/data/business.json | 38 | Literal "PLACEHOLDER-confirm-with-Joe" string in production data path | Blocker | Leaks to all 17 dist pages' HairSalon.sameAs JSON-LD; poisons AEO entity graph (CR-01) |
| site/src/components/schema/Article.astro | 30-34 | publisher block missing `url` and `logo.ImageObject` | Warning | Article rich-result eligibility risk per Google guidelines (CR-04). validate-schema.mjs misses this because Schema.org spec doesn't require publisher.logo; Google's parser does. |
| site/src/data/business.ts | 41 | `as BusinessRecord` type assertion bypasses runtime validation | Warning | Future drift between business.json and BusinessRecord interface causes opaque runtime errors deep in render pipeline (CR-03 in review — recorded as WR-03 actually). Not phase-blocking. |
| site/scripts/validate-schema.mjs | 245 | `statSync(distDir).isDirectory()` throws before its own error message can print | Warning | Developer running validator before npm run build sees raw Node stack trace, not the helpful guidance message (CR-03 in review). Not phase-blocking — affects only DX, not output. |
| site/src/data/business.ts | 96-104 | `aggregateRating()` divides by zero on empty ratings input -> NaN -> "ratingValue":null in JSON-LD | Warning | Latent. Current ratings input is populated; the divide-by-zero only triggers if business.json.ratings becomes {}. Defensive code would fail loudly at build time (CR-02). |
| site/src/pages/faq.astro | various | Phone number `(619) 891-2775` hard-coded ~10 times across DOM and schema arrays | Info | If Joe's phone changes, those strings drift from business.phone (WR-02). Not phase-blocking; visible-DOM ↔ schema drift risk per RESEARCH Pitfall 5 |
| 4 page files | various | FAQ data duplicated between DOM and schema arrays | Info | `// TODO Phase 7` acknowledges this; drift risk per RESEARCH Pitfall 5 (WR-06). Not phase-blocking yet |
| site/src/pages/reviews.astro + Review.astro | n/a | Self-published Review schema for republished Google + Yelp quotes | Info | Possible policy violation per Google's review-snippet guidelines; not a Schema.org spec violation. WR-05 — verifier accepts as deferred risk; recommend manual verification at Phase 6 D-25. |

### Human Verification Required

#### 1. D-25 Google Rich Results Test (deferred to Phase 6 per documented decision)

**Test:** After Phase 6 deploys the Vercel preview URL, paste `<preview-url>/`, `<preview-url>/east-county-traditional-barbershop/`, and `<preview-url>/2026-east-county-barbershop-cost-guide/` into https://search.google.com/test/rich-results (URL tab, not Code tab). Save full-page screenshots to `.planning/phases/05-aeo-performance-meta/rich-results/{homepage,niche-landing,cost-guide}-rich-results.png`.

**Expected:** Green entities for HairSalon (recognized as LocalBusiness subtype), AggregateRating, FAQPage, Article. FAQPage rich-result deprecation warnings (per RESEARCH Pitfall 8 — Google deprecated rich-result display 2026-05-07) are EXPECTED and acceptable; AI engines still consume the schema. **Hard errors that DO block:** "Publisher logo is required" on Article (CR-04 risk), "Missing required property" on any block, "Invalid URL" on sameAs (CR-01 risk once the placeholder URL is resolved).

**Why human:** Local-build paste was deferred to deployed-URL paste per user authority at orchestrator checkpoint, recorded in `rich-results/README.md` and `05-07-SUMMARY.md`. The verifier accepts the deferral as a documented decision, but the manual signal — including downstream impact of CR-01 + CR-04 — has not been confirmed.

#### 2. Visual breakpoint parity at 980px and 600px

**Test:** Open `npx astro preview` locally. In a desktop browser, resize the viewport to exactly 980px wide, then 600px wide. Compare layout against `mockups/home-v5/index.html` rendered at the same widths (OD-5 source).

**Expected:** Layout reflows cleanly at both breakpoints — no broken grids, overlapping text, images escaping containers, or kicker rules colliding with content.

**Why human:** check_responsive_breakpoints only verifies the @media rules exist in source CSS — it cannot render the page or compare against OD-5. PERF-01 explicitly requires visual parity, which is a visual judgment call.

### Gaps Summary

**Phase 5 substantially succeeds at the technical AEO/perf/meta plumbing — JSON-LD emits, schemas validate, Lighthouse scores comfortably exceed thresholds, sitemap + robots + OG + Twitter + canonical all wire correctly on every page, and the audit suite passes 36/0/0 with real check implementations replacing every Plan 01 stub.**

**The phase fails on a single but material BLOCKER:** the placeholder URL `https://maps.google.com/?cid=PLACEHOLDER-confirm-with-Joe` flows from `business.json` through `HairSalon.astro` into all 17 dist pages' `sameAs` JSON-LD array. The phase goal explicitly says the site must be "parseable by AI crawlers and search engines without structural gaps"; shipping a literal "PLACEHOLDER" URL as a canonical business reference is structurally broken — Google's entity resolver will follow it and find nothing, Perplexity will treat the entity as low-quality, and AEO-09 (sameAs links to GBP) is unsatisfied because there is no real GBP URL in the emitted JSON-LD. This is a 30-second fix (set `sameAs.gbp` to empty string OR harden the HairSalon filter), but it must happen before Phase 6 deploys to Vercel; once the preview URL is live, the broken sameAs is what Joe sees and what AI parsers cache.

**One additional WARNING worth tracking:** Article schema (`publisher.logo` + `publisher.url` missing per CR-04) is structurally valid by Schema.org's required-field spec, but Google's stricter Article rich-result validator will flag it as ineligible. This affects the 2 Article-archetype pages (niche-landing + cost guide) and surfaces at the deferred D-25 Phase 6 gate, not now. Verifier recommends fixing it before Phase 6 D-25 so the manual paste returns green rather than warning. If user wants to ship Phase 5 with CR-04 and address it at Phase 6, that's an override-worthy decision — but CR-01 should not be deferred.

**The other 9 review warnings (WR-01 through WR-09) and 6 info items (IN-01 through IN-06) are accepted as non-blocking** — they either (a) are documented `TODO Phase 7` items, (b) affect DX rather than output, or (c) are latent code paths that aren't exercised by current data. The verifier flagged WR-03 (type assertion), WR-02 (phone duplication), and WR-06 (DOM ↔ schema FAQ duplication) as anti-patterns in the table above so they don't get forgotten, but does not block on them.

**Recommendation:** Treat CR-01 as a hard blocker; address it before Phase 6. Treat CR-04 as a soft blocker; address it before Phase 6's D-25 manual paste so the gate returns green. Both are small, isolated fixes — neither requires re-running waves 1-5.

---

_Verified: 2026-05-11T02:05:15Z_
_Verifier: Claude (gsd-verifier)_
