---
phase: 06-deploy-showcase
plan: "06"
subsystem: seo-safety
tags:
  - noindex
  - robots-txt
  - showcase-mode
  - build-time-gating
  - aeo
dependency_graph:
  requires:
    - 06-01 (site scaffold + Vercel wiring)
    - 06-02 (Vercel env vars pattern)
    - 06-03 (generate-mtimes.mjs prebuild pattern)
    - 06-04 (Base.astro enableClarity env-flag pattern)
  provides:
    - build-time noindex gate (showcase mode) for Wave 2 deploy
    - one-env-var go-live flip for Wave 5
  affects:
    - site/public/robots.txt (now build-generated)
    - every built HTML page (conditional meta tag)
tech_stack:
  added:
    - site/scripts/generate-robots.mjs (Node ESM prebuild script)
  patterns:
    - env-flag build gate (PUBLIC_SHOWCASE_MODE !== 'false') mirrors enableClarity idiom
    - prebuild chaining (generate-mtimes.mjs && generate-robots.mjs)
    - gitignore for build-generated public/ file
key_files:
  created:
    - site/scripts/generate-robots.mjs
  modified:
    - site/package.json
    - site/src/layouts/Base.astro
    - site/.gitignore
    - .planning/phases/03-unique-pages/scripts/audit.sh
decisions:
  - "robots.txt removed from git tracking — now build-generated artifact; prevents perpetual working-tree dirt"
  - "audit.sh robots check updated to accept Disallow: / as valid showcase-mode state (Sitemap not required in noindex mode)"
  - "Default-to-true semantics: unset PUBLIC_SHOWCASE_MODE computes showcaseMode=true (fail-safe noindex)"
metrics:
  duration: "~5 minutes"
  completed: "2026-05-11T18:33:44Z"
  tasks_completed: 2
  files_changed: 5
---

# Phase 06 Plan 06: Build-Time Noindex Flag (D-02 + D-03) Summary

**One-liner:** Belt-and-suspenders build-time noindex gate via `generate-robots.mjs` prebuild script (robots.txt) + Base.astro conditional `<meta robots>` tag, both keyed to `PUBLIC_SHOWCASE_MODE !== 'false'` default-to-true env flag.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Create generate-robots.mjs + chain into package.json prebuild | 95184e3 | site/scripts/generate-robots.mjs, site/package.json, site/.gitignore, site/public/robots.txt (removed from tracking) |
| 2 | Add conditional noindex meta tag to Base.astro | 95184e3 | site/src/layouts/Base.astro |

Both tasks landed in one atomic commit per plan spec.

## What Was Built

### generate-robots.mjs (new prebuild script)

Writes `site/public/robots.txt` at build time based on `process.env.PUBLIC_SHOWCASE_MODE`:
- Unset or any value other than `'false'` → `Disallow: /` + showcase comment (fail-safe default)
- `'false'` → `Allow: /` + `Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml`

Mirrors the `generate-mtimes.mjs` pattern exactly (stdlib only: `node:fs`, `node:path`, `node:url`).

### package.json prebuild chain

`"prebuild": "node scripts/generate-mtimes.mjs && node scripts/generate-robots.mjs"`

Robots file regenerated on every `npm run build` — both scripts run sequentially before Astro starts.

### Base.astro showcaseMode gate

Frontmatter addition (after `enableClarity`):
```typescript
const showcaseMode = import.meta.env.PUBLIC_SHOWCASE_MODE !== 'false';
```

Head addition (before `<link rel="canonical">`):
```astro
{showcaseMode && <meta name="robots" content="noindex,nofollow,noarchive" />}
```

### robots.txt gitignored

`site/public/robots.txt` removed from tracking (`git rm --cached`) and added to `site/.gitignore`. The file is now a build artifact — committing it would create perpetual diffs since every `npm run build` rewrites it.

## Verification Results

| Check | Showcase Mode (env unset) | Go-Live Mode (PUBLIC_SHOWCASE_MODE=false) |
|-------|--------------------------|-------------------------------------------|
| `dist/robots.txt` | `Disallow: /` | `Allow: /` + `Sitemap:` |
| HTML pages with noindex meta | 17/17 | 0/17 |
| `npm run build` exit code | 0 | 0 |
| Audit gate | 36 passed, 0 failed, 0 skipped | (not run — go-live not final state) |

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 2 - Missing critical functionality] Updated audit.sh robots check for showcase mode**
- **Found during:** Task 2 verification
- **Issue:** `check_robots()` in audit.sh required `Sitemap:` line unconditionally. Showcase-mode robots.txt intentionally omits `Sitemap:` (only `Disallow: /`), causing `35 passed, 1 failed, 0 skipped`.
- **Fix:** Updated `check_robots()` to accept either `Disallow: /` (showcase mode, no Sitemap required) or `Allow: /` + `Sitemap:` (go-live mode). Both `User-agent:` still required.
- **Files modified:** `.planning/phases/03-unique-pages/scripts/audit.sh`
- **Commit:** 95184e3

## Known Stubs

None.

## Threat Flags

None. All STRIDE threats T-06-13 through T-06-16 mitigated as designed:
- T-06-13: Belt-and-suspenders (robots.txt Disallow + meta noindex)
- T-06-14: Default-to-true semantics verified (unset env = showcase)
- T-06-15: Showcase mode publishes `Disallow: /` (no route enumeration)
- T-06-16: Script uses stdlib only, no network/shell-out

## Self-Check: PASSED

- `site/scripts/generate-robots.mjs` exists and is executable
- Commit 95184e3 exists in git log
- `site/public/robots.txt` not tracked (removed + gitignored)
- `site/dist/robots.txt` contains `Disallow: /` (showcase mode, final state)
- 17 HTML pages in dist contain `name="robots" content="noindex,nofollow,noarchive"`
- Audit gate: 36 passed, 0 failed, 0 skipped
