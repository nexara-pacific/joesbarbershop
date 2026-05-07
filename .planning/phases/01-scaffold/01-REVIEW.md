---
phase: 01-scaffold
reviewed: 2026-05-07T16:00:00Z
depth: standard
files_reviewed: 10
files_reviewed_list:
  - site/astro.config.mjs
  - site/package.json
  - site/tsconfig.json
  - site/.gitignore
  - site/src/pages/index.astro
  - site/src/pages/about.astro
  - site/src/layouts/Base.astro
  - site/src/components/UtilBar.astro
  - site/src/components/Masthead.astro
  - site/src/components/Footer.astro
findings:
  critical: 0
  warning: 2
  info: 4
  total: 6
status: issues_found
---

# Phase 01: Code Review Report

**Reviewed:** 2026-05-07T16:00:00Z
**Depth:** standard
**Files Reviewed:** 10
**Status:** issues_found

## Summary

Phase 01 is a clean Astro 6 scaffold. Configuration is correct: TypeScript strict mode is inherited from `astro/tsconfigs/strict`, the Vercel adapter and sitemap integration are wired, and the `image.layout: 'constrained'` setting takes advantage of the Astro 5.10+ stable responsive image API. Components are pure HTML stubs with no XSS surface area (no `set:html`, no unescaped interpolation, no inline event handlers). No hardcoded secrets, no dangerous APIs, no debug artifacts.

Two `WARNING`-class issues were found, both in `site/.gitignore`:

1. **Incomplete `.env.*` exclusion** — Astro/Vite's standard `.env.local`, `.env.development`, `.env.development.local`, `.env.production.local` files are not ignored. Any local secret accidentally written to one of these will be tracked. This is a security defect (data exposure risk), classified as a BLOCKER for the gitignore policy but downgraded to WARNING since no secrets exist yet.
2. **Duplicate `.vercel` entry** — `.vercel/` (line 21) and `.vercel` (line 28) both exist; the second is redundant noise.

Info-level items are scaffold-stage gaps that Phase 2+ will close (no canonical link in `<head>`, no `lang` parameterization, no `description` passed from `index.astro`). These are tracked here so they are not forgotten — they are not defects in Phase 01's stated scope.

## Warnings

### WR-01: Incomplete `.env.*` exclusion creates secret-leak risk

**File:** `site/.gitignore:17-19`
**Issue:** The gitignore excludes only `.env` and `.env.production`. Astro is built on Vite, which loads environment variables from `.env`, `.env.local`, `.env.development`, `.env.test`, `.env.production`, and the corresponding `*.local` overrides (per Vite's [env files documentation](https://vite.dev/guide/env-and-mode#env-files)). A developer running `astro dev` who creates `.env.local` to hold a Vercel token, Sanity key, or other secret will have that file tracked by git. The standard Astro/Vite pattern is to exclude all of `.env*` and then re-include `.env.example`. This is a defensive-depth issue — there are no secrets in the repo today — but the gitignore is the wrong shape for the framework being used.

**Fix:**
```gitignore
# environment variables
.env
.env.*
!.env.example
```

This matches the pattern already used in the **root** `.gitignore` (`/Users/darrelltang/dtconsulting/joesbarbershop/.gitignore` lines 7-9), so the two files diverge unnecessarily today. Aligning them removes the divergence.

### WR-02: Duplicate `.vercel` entry in gitignore

**File:** `site/.gitignore:21,28`
**Issue:** Line 21 declares `.vercel/` (directory form) and line 28 declares `.vercel` (bare form). Both match the same path. Git tolerates this, but it indicates the file was edited twice without consolidating, and a future reader may assume the duplicate is intentional and copy the pattern. Verified via `git check-ignore -v site/.vercel`: line 28 wins, but line 21 is the more correct form (trailing slash signals "directory only").

**Fix:** Delete line 28. Keep `.vercel/` on line 21.

```gitignore
# Vercel deployment artifacts
.vercel/

# macOS-specific files
.DS_Store

# jetbrains setting folder
.idea/
```

## Info

### IN-01: `index.astro` does not pass `description` to `Base` layout

**File:** `site/src/pages/index.astro:4`
**Issue:** The `Base` layout accepts an optional `description` prop and emits `<meta name="description">` when present (`Base.astro:19`). The homepage passes only `title`, so the rendered HTML has no meta description. For a Phase 01 stub this is acceptable, but the homepage meta description is the single most important AEO signal per `inputs/02-aeo-constraints.md` — track this so Phase 2 does not ship without it.

**Fix:** Phase 2 should pass `description` from every page that wraps `Base`. No change needed in Phase 01.

### IN-02: `<html lang="en">` is hardcoded in `Base.astro`

**File:** `site/src/layouts/Base.astro:14`
**Issue:** The `lang` attribute is hardcoded. Joe's Barbershop is an English-only site for v1, so this is fine, but if a future phase adds Spanish copy (East County / El Cajon has a substantial Spanish-speaking population), this will need parameterization. Flagging as Info, not a defect.

**Fix:** None for v1. Consider `interface Props { ...; lang?: string }` with default `'en'` if multilingual is ever in scope.

### IN-03: Empty frontmatter blocks in stub components

**File:** `site/src/components/UtilBar.astro:1-2`, `site/src/components/Masthead.astro:1-2`, `site/src/components/Footer.astro:1-2`
**Issue:** Each stub component has an empty `---\n---\n` frontmatter fence. This is valid Astro syntax and produces no runtime cost, but the fences can be omitted entirely when there is no script. Cosmetic only.

**Fix:** Optional. Either leave as-is (consistent with Astro starter conventions) or remove the empty fences.

### IN-04: `tsconfig.json` `include: ["**/*"]` is broader than needed

**File:** `site/tsconfig.json:3`
**Issue:** `"**/*"` includes everything in the project, including `public/`, `astro.config.mjs`, and `package.json` (TS will skip non-TS files but still walks the tree). The `exclude` array lists only `dist`. `node_modules` is excluded by TypeScript's default behavior, so this is fine, but the official Astro template uses a more conservative pattern. Not a defect — just broader than necessary.

**Fix:** None required. If TS scanning of `public/` ever causes issues, narrow `include` to `["src/**/*", ".astro/types.d.ts"]`.

---

_Reviewed: 2026-05-07T16:00:00Z_
_Reviewer: Claude (gsd-code-reviewer)_
_Depth: standard_
