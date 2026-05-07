---
phase: 01-scaffold
verified: 2026-05-07T08:40:00Z
status: human_needed
score: 13/14 must-haves verified
overrides_applied: 0
human_verification:
  - test: "Confirm site/.vercel/project.json contains projectId and orgId"
    expected: "File exists with projectId and orgId keys, orgId matches darrell-tangs-projects personal scope"
    why_human: "Sandbox security hook blocks all access to .vercel/ paths — cannot ls, stat, cat, or test the file programmatically. Git confirms it is gitignored (not committed). SUMMARY.md documents projectId and orgId. Human must confirm the file exists and contains correct values."
---

# Phase 1: Scaffold Verification Report

**Phase Goal:** Establish the deployable Astro project foundation with Vercel preview hosting and a single base layout — every later phase plugs into this scaffold.
**Verified:** 2026-05-07T08:40:00Z
**Status:** human_needed
**Re-verification:** No — initial verification

---

## Goal Achievement

### Observable Truths

| #  | Truth | Status | Evidence |
|----|-------|--------|---------|
| 1  | An Astro project exists at site/ with TypeScript strict mode enforced | ✓ VERIFIED | `site/tsconfig.json` extends `astro/tsconfigs/strict`; `site/package.json` declares `astro: ^6.3.0` |
| 2  | `npm run build` inside `site/` exits 0 with no TypeScript errors | ✓ VERIFIED | Live build run exits 0 in 405ms; 2 pages built; no error/warning lines |
| 3  | `tsconfig.json` extends `astro/tsconfigs/strict` | ✓ VERIFIED | File contains `"extends": "astro/tsconfigs/strict"` verbatim |
| 4  | `@astrojs/vercel 10.x` installed and imported via unified path (no /static or /serverless) | ✓ VERIFIED | `package.json`: `@astrojs/vercel: ^10.0.6`; `astro.config.mjs`: `from '@astrojs/vercel'` |
| 5  | `@astrojs/sitemap 3.x` installed and registered as integration | ✓ VERIFIED | `package.json`: `@astrojs/sitemap: ^3.7.2`; registered in `integrations: [sitemap()]` |
| 6  | `site:` URL set in `astro.config.mjs` | ✓ VERIFIED | `site: 'https://joesbarbershop.vercel.app'` present |
| 7  | `image.layout: 'constrained'` set in `astro.config.mjs` | ✓ VERIFIED | `image: { layout: 'constrained', responsiveStyles: true }` present |
| 8  | `output:` is NOT set to `'server'` (stays static) | ✓ VERIFIED | No `output:` field in `astro.config.mjs`; build mode confirmed `"static"` in build log |
| 9  | Build produces `dist/sitemap-index.xml` (not `sitemap.xml`) | ✓ VERIFIED | `site/dist/sitemap-index.xml` exists post-build; contains `<sitemapindex` |
| 10 | Every Phase 1 page renders shared util-bar, masthead, and footer in correct DOM order | ✓ VERIFIED | `Base.astro` body order: UtilBar (pos 5) → Masthead (pos 21) → main (pos 38) → Footer (pos 64) |
| 11 | Two pages (`/` and `/about`) both import `Base.astro` — proves layout reuse | ✓ VERIFIED | Both files contain `import Base from '../layouts/Base.astro'` |
| 12 | Each stub component carries `data-phase1-stub` attribute; both built HTML files contain it | ✓ VERIFIED | Grep confirms marker in `dist/index.html` and `dist/about/index.html` (pre- and post-build) |
| 13 | Vercel preview URL `https://site-psi-liard.vercel.app` returns 200 on `/` and `/about`; both serve `data-phase1-stub` markers | ✓ VERIFIED | `curl` confirms: `/` → 200 + marker; `/about` → 200 + marker; `/sitemap-index.xml` returns valid XML |
| 14 | `site/.vercel/project.json` exists with `projectId` and `orgId` | ? UNCERTAIN | Sandbox security hook blocks all `.vercel/` path access. Git confirms file is gitignored (not committed). SUMMARY.md documents `projectId: prj_K0vpi4oJOuSHTGJnYZhP5RQQwN8N` and `orgId: team_QiwsTgAWs5PsLwbBMCUYp1z6`. Live Vercel deploy succeeded, which requires the link file to exist. Needs human confirmation. |

**Score:** 13/14 truths verified

---

### Deferred Items

None. All Phase 1 must-haves are either verified or pending human check.

---

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `site/package.json` | Astro 6 project root with build/dev/preview scripts | ✓ VERIFIED | `astro: ^6.3.0`; scripts: dev, build, preview, astro |
| `site/tsconfig.json` | TypeScript strict preset extension | ✓ VERIFIED | `extends: astro/tsconfigs/strict` |
| `site/astro.config.mjs` | Vercel adapter, Sitemap, Image config, site: URL | ✓ VERIFIED | All four elements present; no `output: 'server'`; no deprecated subpath imports |
| `site/src/pages/index.astro` | Home page using Base.astro | ✓ VERIFIED | Imports Base; renders placeholder content |
| `site/src/pages/about.astro` | Second page proving layout reuse | ✓ VERIFIED | Imports Base; renders placeholder content |
| `site/src/layouts/Base.astro` | Shared HTML shell with correct section ordering | ✓ VERIFIED | 27 lines; imports all three components; slot present; head slot present |
| `site/src/components/UtilBar.astro` | Stub with `data-phase1-stub="util-bar"` | ✓ VERIFIED | Outer `<div>` carries the attribute |
| `site/src/components/Masthead.astro` | Stub with `data-phase1-stub="masthead"` | ✓ VERIFIED | Outer `<header>` carries the attribute |
| `site/src/components/Footer.astro` | Stub with `data-phase1-stub="footer"` | ✓ VERIFIED | Outer `<footer>` carries the attribute |
| `site/.gitignore` | Contains `.vercel` entry | ✓ VERIFIED | Two entries: `.vercel/` (in Vercel artifacts comment block) and `.vercel` (bare) |
| `site/.vercel/project.json` | Persisted Vercel project link with projectId and orgId | ? UNCERTAIN | Sandbox blocks path; live deploy success implies file exists |
| `site/dist/index.html` | Built homepage | ✓ VERIFIED | Exists post-build; contains `data-phase1-stub` |
| `site/dist/about/index.html` | Built about page | ✓ VERIFIED | Exists post-build; contains `data-phase1-stub` |
| `site/dist/sitemap-index.xml` | Sitemap index emitted at build | ✓ VERIFIED | Exists post-build; contains `<sitemapindex` |

---

### Key Link Verification

| From | To | Via | Status | Details |
|------|----|-----|--------|---------|
| `site/package.json scripts.build` | `astro build` | npm script | ✓ WIRED | `"build": "astro build"` present |
| `site/astro.config.mjs` | `@astrojs/vercel` | unified default import + adapter call | ✓ WIRED | `import vercel from '@astrojs/vercel'`; `adapter: vercel()` |
| `site/astro.config.mjs` | `@astrojs/sitemap` | integrations array entry | ✓ WIRED | `import sitemap from '@astrojs/sitemap'`; `integrations: [sitemap()]` |
| `site/astro.config.mjs` | sitemap site URL | `site:` config field | ✓ WIRED | `site: 'https://joesbarbershop.vercel.app'` |
| `site/src/pages/index.astro` | `site/src/layouts/Base.astro` | import + JSX wrap | ✓ WIRED | `import Base from '../layouts/Base.astro'`; content wrapped in `<Base>` |
| `site/src/pages/about.astro` | `site/src/layouts/Base.astro` | import + JSX wrap | ✓ WIRED | `import Base from '../layouts/Base.astro'`; content wrapped in `<Base>` |
| `site/src/layouts/Base.astro` | UtilBar, Masthead, Footer | component imports + JSX usage | ✓ WIRED | All three imported from `../components/`; all three used in body |

---

### Data-Flow Trace (Level 4)

Not applicable. Phase 1 is a static scaffold with no dynamic data queries, stores, or API fetches. All content is hardcoded placeholder text by design (Phase 2 introduces `business.ts` data).

---

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| `npm run build` exits 0 | `cd site && npm run build` | exit 0, 405ms, 2 pages | ✓ PASS |
| `dist/index.html` exists after build | `test -f site/dist/index.html` | file exists | ✓ PASS |
| `dist/about/index.html` exists after build | `test -f site/dist/about/index.html` | file exists | ✓ PASS |
| `dist/sitemap-index.xml` exists after build | `test -f site/dist/sitemap-index.xml` | file exists + `<sitemapindex` | ✓ PASS |
| Both built pages carry `data-phase1-stub` | `grep -l data-phase1-stub dist/index.html dist/about/index.html` | both files listed | ✓ PASS |
| Preview URL `/` returns 200 | `curl -w "%{http_code}" https://site-psi-liard.vercel.app/` | 200 | ✓ PASS |
| Preview URL `/about` returns 200 | `curl -w "%{http_code}" https://site-psi-liard.vercel.app/about` | 200 | ✓ PASS |
| Live `/` body has `data-phase1-stub` | `curl ... / \| grep data-phase1-stub` | match found | ✓ PASS |
| Live `/about` body has `data-phase1-stub` | `curl ... /about \| grep data-phase1-stub` | match found | ✓ PASS |
| Live `/sitemap-index.xml` returns `<sitemapindex` | `curl .../sitemap-index.xml \| grep '<sitemapindex'` | match found | ✓ PASS |
| Static build mode (no SSR functions dir) | Build log shows `"static"` mode; adapter copies to `.vercel/output/static` | confirmed | ✓ PASS |

---

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|---------|
| SCAF-01 | 01-01-PLAN, 01-04-PLAN | Astro project initialized in `site/` with TypeScript strict mode | ✓ SATISFIED | `site/tsconfig.json` extends `astro/tsconfigs/strict`; `astro: ^6.3.0` in package.json |
| SCAF-02 | 01-02-PLAN | Astro Image integration configured (AVIF/WebP/srcset, lazy-load) | ✓ SATISFIED | `image: { layout: 'constrained', responsiveStyles: true }` in astro.config.mjs; built-in `astro:assets` (no deprecated @astrojs/image) |
| SCAF-03 | 01-02-PLAN | Astro Sitemap integration configured for `/sitemap.xml` | ✓ SATISFIED (wording discrepancy noted) | Integration installed and emits `sitemap-index.xml` (Astro 3.x always emits the index file, never `sitemap.xml` — this is correct behavior, the requirement text is imprecise) |
| SCAF-04 | 01-02-PLAN, 01-04-PLAN | Vercel adapter configured for static deploy | ✓ SATISFIED | `@astrojs/vercel@^10.0.6` installed; unified import; `adapter: vercel()` in config; build mode confirmed static |
| SCAF-05 | 01-03-PLAN, 01-04-PLAN | Base layout renders shared masthead, util bar, footer on every page | ✓ SATISFIED | `Base.astro` renders correct section order; both pages use it; `data-phase1-stub` markers present in both local build and live Vercel deploy |

**Note on SCAF-03:** REQUIREMENTS.md says "configured for `/sitemap.xml`" but `@astrojs/sitemap` 3.x always emits `sitemap-index.xml` + `sitemap-0.xml` — `sitemap.xml` is never generated by this integration. The 01-02-PLAN explicitly documents this as a known pitfall and the must_have truth specifies `sitemap-index.xml`. The spirit of the requirement (sitemap integration active and producing output) is fully satisfied. This is an imprecise requirement description, not an implementation gap.

---

### Anti-Patterns Found

| File | Pattern | Severity | Impact |
|------|---------|----------|--------|
| `site/src/components/UtilBar.astro` | Stub placeholder text: `(Phase 2: util-bar — phone, hours, walk-ins welcome)` | ℹ️ Info | Intentional phase boundary stub; Phase 2 replaces body |
| `site/src/components/Footer.astro` | Stub placeholder text: `(Phase 2: footer — NAP, social, hours)` | ℹ️ Info | Intentional phase boundary stub; Phase 2 replaces body |
| `site/src/pages/index.astro` | Placeholder h1: `Joe's Barbershop — Phase 1 placeholder` | ℹ️ Info | Intentional; Phase 2 replaces with full OD-5 homepage |

No blockers. All stubs are intentional and documented. No `client:*` directives, no CSS, no Tailwind, no deprecated packages, no SSR mode activation.

---

### Human Verification Required

#### 1. Vercel Project Link File

**Test:** Navigate to `site/.vercel/project.json` in Finder or run `cat site/.vercel/project.json` in a terminal (outside this Claude session's sandbox).
**Expected:** JSON file exists containing:
- `"projectId": "prj_K0vpi4oJOuSHTGJnYZhP5RQQwN8N"` (or any non-empty projectId)
- `"orgId": "team_QiwsTgAWs5PsLwbBMCUYp1z6"` (or similar — the darrell-tangs-projects personal scope)
**Why human:** The sandbox security hook blocks all access to `.vercel/` paths (ls, stat, cat, test all blocked). The live Vercel deploy at `https://site-psi-liard.vercel.app` returning 200 is strong circumstantial evidence the link file exists and is valid — Vercel CLI requires it for scripted deploys. Git confirms the file is properly gitignored.

---

### Gaps Summary

No blockers found. The single UNCERTAIN item (site/.vercel/project.json access) is unresolvable by automated tooling due to the sandbox security policy, not due to missing implementation. The live Vercel deploy returning 200 is effectively the end-to-end proof that the link exists and is valid.

The SCAF-03 requirement text discrepancy (`/sitemap.xml` vs `sitemap-index.xml`) is a documentation imprecision, not an implementation gap — the integration behaves correctly per its own specification and the Phase 1 plans explicitly account for this.

---

_Verified: 2026-05-07T08:40:00Z_
_Verifier: Claude (gsd-verifier)_
