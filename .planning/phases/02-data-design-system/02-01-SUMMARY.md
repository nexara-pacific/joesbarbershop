---
phase: 02-data-design-system
plan: 01
subsystem: design-system
tags:
  - css
  - design-tokens
  - astro-layout
  - google-fonts
dependency_graph:
  requires: []
  provides:
    - site/src/styles/tokens.css
    - site/src/styles/utilities.css
    - site/src/layouts/Base.astro (with CSS imports + Google Fonts)
  affects:
    - All Wave 2+ components (can now reference --bg, .wrap, .check-divider etc.)
tech_stack:
  added: []
  patterns:
    - CSS custom properties via :root in tokens.css (globally cascaded via Base.astro frontmatter import)
    - Shared utility classes in utilities.css (globally cascaded)
    - Google Fonts loaded as <link> tags (not @import — avoids serial round-trip penalty)
    - Astro frontmatter CSS import pattern (inside --- fences, not inside <style> tag)
key_files:
  created:
    - site/src/styles/tokens.css
    - site/src/styles/utilities.css
  modified:
    - site/src/layouts/Base.astro
decisions:
  - "CSS imports placed in Base.astro frontmatter (not <style>) per D-07 — prevents hash-mangling of globals"
  - "Google Fonts loaded as <link> tags per design (not @import) — avoids serial round-trip penalty"
  - "data-font and data-checker variant rules stripped entirely per D-10 (tweaks panel dead code)"
  - "Section order UtilBar -> Masthead -> main(slot) -> Footer preserved unchanged per D-25"
  - "Named slot name='head' preserved per D-26 for Phase 3+ JSON-LD injection"
metrics:
  duration: "~5 minutes"
  completed: "2026-05-07T23:16:00Z"
  tasks_completed: 2
  tasks_total: 2
  files_created: 2
  files_modified: 1
---

# Phase 2 Plan 01: CSS Token Layer + Base.astro Wiring Summary

**One-liner:** OD-5 design token layer extracted into `tokens.css` (oklch palette, font stack, base reset) and `utilities.css` (`.wrap`, `.check-divider`, `.btn`, `.section-head` atoms), both wired as global imports in Base.astro frontmatter with Google Fonts preconnect links.

## Tasks Completed

| Task | Name | Commit | Files |
|------|------|--------|-------|
| 1 | Create tokens.css and utilities.css from OD-5 mockup | 1bcc8dd | site/src/styles/tokens.css, site/src/styles/utilities.css |
| 2 | Update Base.astro — add CSS imports and Google Fonts links | 9c8bce7 | site/src/layouts/Base.astro |

## What Was Built

**tokens.css** — Complete OD-5 `:root` custom properties block (14 color tokens, 6 font-family tokens, `--maxw`, `--gutter`), box-sizing reset, base `html/body/img/a` rules, and global `section` spacing. All `[data-font]` and `[data-checker]` variant rules stripped.

**utilities.css** — 8 shared utility classes: `.display`, `.eyebrow`, `.kicker-rule`, `.wrap`, `.check-divider`, `.section-mark`, `.btn` (with `.outline` + hover states), `.section-head` (with `h2`, `.eyebrow`, `.section-head-text` sub-selectors). No tweaks dead code.

**Base.astro** — Added 2 CSS import lines in frontmatter (after Footer import, before `interface Props`). Added 3 Google Fonts `<link>` tags (2 preconnect + 1 stylesheet for IM Fell English, Playfair Display, DM Serif Display, Newsreader, Oswald, JetBrains Mono) in `<head>` before `<slot name="head" />`. Section order and named head slot untouched.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] npm install required before build**
- **Found during:** Task 2 build verification
- **Issue:** `site/node_modules` was absent from the worktree; `npm run build` invoked `astro` which was not on PATH
- **Fix:** Ran `npm install` in `site/` directory to restore local dependencies
- **Files modified:** `site/node_modules/` (gitignored — no tracked file changes)
- **Commit:** N/A (npm install produces no tracked file changes; `node_modules` is gitignored)

No other deviations — plan executed as written.

## Verification Results

All acceptance criteria passed:

- `tokens.css` exists: PASS
- `utilities.css` exists: PASS
- `grep -c '--bg:' tokens.css` = 1: PASS
- No `data-font|data-checker` in tokens.css: PASS
- No `data-font|data-checker` in utilities.css: PASS
- `.check-divider` in utilities.css: PASS
- `.wrap` in utilities.css: PASS
- `.btn` in utilities.css: PASS
- `import.*tokens.css` in Base.astro frontmatter: PASS
- `import.*utilities.css` in Base.astro frontmatter: PASS
- `fonts.googleapis.com` in Base.astro: PASS
- `IM.Fell.English` in Base.astro: PASS
- `slot name="head"` preserved: PASS
- `npm run build` exits 0: PASS

## Known Stubs

None — this plan creates CSS and layout infrastructure only. No UI content or data stubs.

## Threat Flags

None — this plan creates static CSS files and modifies a layout template. No user input, network calls, authentication, secrets, or new trust boundaries introduced.

## Self-Check: PASSED
