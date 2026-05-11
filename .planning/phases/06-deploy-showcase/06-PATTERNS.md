# Phase 6: Deploy + Showcase - Pattern Map

**Mapped:** 2026-05-10
**Files analyzed:** 11 (5 MODIFY source, 1 NEW source, 1 MODIFY script, 1 OPTIONAL MODIFY audit, 3 NEW planning artifacts)
**Analogs found:** 11 / 11 — every file is either a self-extension of an existing artifact (10) or has no analog by design (1 — `SHARE-CHECKLIST.md`)

> **Path correction:** CONTEXT.md mentions `site/src/lib/business.ts`. The actual file lives at `site/src/data/business.ts` (verified — `site/src/lib/` does not exist). All references in this PATTERNS.md use the real path.

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `site/src/data/business.ts` (MODIFY — CR-02) | typed data helpers | static transform | itself, lines 96-104 (`aggregateRating()` body) | exact (self-extension; guard added) |
| `site/src/data/business.json` (MODIFY — D-01 geo) | data source | static config | itself, lines 10-13 (`geo` block) | exact (self-extension; coordinate values change only) |
| `site/scripts/validate-schema.mjs` (MODIFY — CR-03) | build/CI script | file-I/O (read `dist/**/*.html`) | itself, lines 99-102 (preflight block) | exact (self-extension; one import + one boolean reorder) |
| `site/src/components/schema/Article.astro` (MODIFY — CR-04) | schema component | static transform (props → JSON-LD) | itself, lines 30-34 (`publisher` block) | exact (self-extension; 3 fields added to publisher object) |
| `site/public/robots.txt` (MODIFY — D-02 noindex) | static asset | static-serve via Astro `public/` passthrough | itself, lines 1-4 (4-line text) | exact (self-extension; conditional content based on env flag) |
| `site/src/layouts/Base.astro` (MODIFY — D-02/D-03 noindex meta) | layout | request-response (every page) | itself, lines 31-33 (existing env-gated Clarity pattern lines 32-33 + lines 71-79) | exact (self-extension; new gate mirrors `enableClarity` shape) |
| `site/.env.example` (MODIFY — D-04 new flag doc) | config doc | static | itself, lines 1-5 (existing `PUBLIC_CLARITY_PROJECT_ID` block) | exact (self-extension; second variable documented in same shape) |
| `.planning/phases/03-unique-pages/scripts/audit.sh` (OPTIONAL MODIFY — D-05 route-200 check) | bash test/validation | network I/O (curl deployed URL) | itself, `check_lighthouse` lines 516-565 (network-aware optional check pattern) | role-match (network rather than file-I/O, but same `command -v` skip-guard + early-return idiom) |
| `.planning/phases/06-deploy-showcase/SHARE-CHECKLIST.md` (NEW — D-10/D-11) | planning doc / Joe-voice cheat-sheet | static doc | none in repo; closest is the `rich-results/README.md` brief-note pattern | no-direct-analog (voice-guide-driven content) |
| `.planning/phases/06-deploy-showcase/joe-approval/` (NEW dir — D-12 SHOW-01 artifact) | planning artifact | file-store | `.planning/phases/05-aeo-performance-meta/rich-results/` (image+README placeholder dir) | exact (same shape: directory holding human-captured artifacts + README) |
| `.planning/phases/05-aeo-performance-meta/rich-results/` (REUSE — D-08 D-25 screenshots) | planning artifact | file-store | itself, `README.md` already in place | exact (drop two PNG screenshots alongside existing README) |

---

## Pattern Assignments

### `site/src/data/business.ts` (MODIFY — CR-02 aggregateRating guard)

**Analog:** itself, current lines 96-104. The fix is a 2-line addition that guards against `totalCount === 0` before the divide.

**Current code** (lines 96-104):

```typescript
export function aggregateRating(
  ratings: BusinessRecord['ratings']
): { ratingValue: number; reviewCount: number } {
  const sources = Object.values(ratings);
  const totalCount = sources.reduce((sum, r) => sum + r.count, 0);
  const weightedSum = sources.reduce((sum, r) => sum + r.value * r.count, 0);
  const ratingValue = Number((weightedSum / totalCount).toFixed(2));
  return { ratingValue, reviewCount: totalCount };
}
```

**Fix pattern** (per `05-REVIEW.md` CR-02 fix block, lines 86-98):

```typescript
export function aggregateRating(
  ratings: BusinessRecord['ratings']
): { ratingValue: number; reviewCount: number } {
  const sources = Object.values(ratings);
  const totalCount = sources.reduce((sum, r) => sum + r.count, 0);
  if (totalCount === 0) {
    throw new Error('aggregateRating: no rating sources with count > 0');
  }
  const weightedSum = sources.reduce((sum, r) => sum + r.value * r.count, 0);
  const ratingValue = Number((weightedSum / totalCount).toFixed(2));
  return { ratingValue, reviewCount: totalCount };
}
```

**Why throw, not return null:** matches the existing "fail loud at build time" idiom already used in `validate-schema.mjs` (`process.exit(1)` on errors) and `generate-mtimes.mjs` (stderr warnings + non-fatal fallback). A thrown error in a build-time helper will abort the Astro build before broken JSON-LD ships. Returning `null` would require every caller to handle nullability, which the existing helper exports do not.

**JSDoc preservation:** lines 90-95 (the existing `/** ... */` block) stay verbatim. Just append a sentence at the end of the block noting the empty-input throw.

---

### `site/src/data/business.json` (MODIFY — D-01 geo correction)

**Analog:** itself, lines 10-13 (the `geo` block).

**Current values** (lines 10-13):

```json
"geo": {
  "latitude": 32.8211,
  "longitude": -116.9303
},
```

**Corrected values** (per CONTEXT D-01 + specifics line 137 — resolved from `maps.app.goo.gl/fgNmMDkXDYLKJnP68`):

```json
"geo": {
  "latitude": 32.8184653,
  "longitude": -116.9516888
},
```

**No other JSON edits in this fix.** The `_showcase_review_pending` array (lines 52-63) stays untouched. The `sameAs.gbp` value at line 38 was already corrected from the placeholder to the real maps short-link in Phase 5 — no further edit needed here.

**Verification after edit:** rebuild + grep `dist/index.html` for `"latitude":32.8184653` — must appear in HairSalon JSON-LD `geo` block.

---

### `site/scripts/validate-schema.mjs` (MODIFY — CR-03 preflight reorder)

**Analog:** itself, lines 99-102.

**Current code** (lines 99-102, plus line 10 for context):

```javascript
import { readFileSync, readdirSync, statSync } from 'node:fs';
// ...
if (!statSync(distDir).isDirectory()) {
  console.error(`FAIL: dist directory not found at ${distDir} — run \`npm run build\` first`);
  process.exit(1);
}
```

**Bug:** `statSync(distDir)` throws `ENOENT` when `distDir` does not exist — the throw fires before `!` can evaluate, making the `console.error` line unreachable. Developers see a raw Node stack trace, not the helpful message.

**Fix pattern** (per `05-REVIEW.md` CR-03 fix block, lines 117-122):

```javascript
import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
// ...
if (!existsSync(distDir) || !statSync(distDir).isDirectory()) {
  console.error(`FAIL: dist directory not found at ${distDir} — run \`npm run build\` first`);
  process.exit(1);
}
```

**Two-line surgical change:**
1. Line 10 — add `existsSync` to the destructured imports from `node:fs`.
2. Line 99 — prepend `!existsSync(distDir) ||` to the condition (short-circuit prevents the `statSync` throw).

**Verification after fix:** temporarily rename `site/dist` → `site/dist.bak`, run `node site/scripts/validate-schema.mjs`, confirm output is `FAIL: dist directory not found at ...` (not a stack trace). Rename back.

---

### `site/src/components/schema/Article.astro` (MODIFY — CR-04 publisher block)

**Analog:** itself, lines 30-34 (current `publisher` block).

**Current code** (lines 30-34):

```typescript
publisher: {
  '@type': 'Organization',
  '@id': `${canonicalUrl}/#business`,
  name: "Joe's Barbershop",
},
```

**Why this fails Google Rich Results:** Per Google's Article structured-data guidelines, `publisher` MUST include `logo` as a fully-specified `ImageObject` (url + width + height) for Article rich-result eligibility. Today's `@id` reference to `#business` does pull in HairSalon's data via entity-graph linking — Google's validator processes Article in isolation and flags "Publisher logo is required."

**Fix pattern** (per `05-REVIEW.md` CR-04 fix block, lines 141-152):

```typescript
publisher: {
  '@type': 'Organization',
  '@id': `${canonicalUrl}/#business`,
  name: "Joe's Barbershop",
  url: canonicalUrl,
  logo: {
    '@type': 'ImageObject',
    url: `${canonicalUrl}/photos/01-logo.jpg`,
    width: 600,    // hand-set; Google requires width+height for ImageObject in publisher.logo
    height: 600,   // 01-logo.jpg is square per inputs/photos/ — verify before commit
  },
},
```

**Logo source decision:** `business.json` line 44 already lists `photos.logo: "01-logo.jpg"`. Per WR-08 in 05-REVIEW (hard-coded filename anti-pattern), the planner may choose:
- **Quick fix (matches existing Article line 28 pattern):** hard-code `01-logo.jpg` in the path string — same idiom as the existing `image: \`${canonicalUrl}/photos/02-storefront.jpg\`` at line 28.
- **Better fix (resolves WR-08 in passing):** `import { business, canonicalUrl } from '../../data/business'` and use `${canonicalUrl}/photos/${business.photos.logo}`. Adds one import line; eliminates the drift risk.

**Recommended:** quick fix for Phase 6 (one-line change, ships with existing inconsistency), file WR-08 cleanup separately. Phase 6's wave-1 budget is "fix the 4 carryforward blockers, no extra refactors."

**Width/height verification step:** before commit, `identify -format '%wx%h' /Users/darrelltang/dtconsulting/joesbarbershop/site/src/assets/photos/01-logo.jpg` (or open the file) to confirm actual pixel dimensions. Google rejects ImageObject with wrong-axis dimensions.

---

### `site/public/robots.txt` (MODIFY — D-02 showcase noindex)

**Analog:** itself, lines 1-4 (current 4-line allow-all-with-sitemap content).

**Current content** (4 lines):

```
User-agent: *
Allow: /

Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml
```

**Astro's `public/` directory behavior:** files in `site/public/` are copied verbatim into `dist/` at build time. There is no template processing — robots.txt is plain text. To make the content env-flag-conditional, the planner has two viable approaches:

**Approach A (preferred per D-03 — single env flag flip):** Use a build script (similar to `generate-mtimes.mjs` pre-build hook) to rewrite `site/public/robots.txt` from a template based on `process.env.PUBLIC_SHOWCASE_MODE`. This keeps robots.txt as a real static file at build time while making it conditional on env state.

```javascript
// site/scripts/generate-robots.mjs (NEW — mirrors generate-mtimes.mjs pattern)
import { writeFileSync } from 'node:fs';
import { resolve, dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const robotsPath = resolve(__dirname, '..', 'public', 'robots.txt');

const showcaseMode = process.env.PUBLIC_SHOWCASE_MODE !== 'false';

const showcaseContent = `User-agent: *
Disallow: /

# Showcase mode (PUBLIC_SHOWCASE_MODE=true) — site is noindex until Joe approves.
`;

const goLiveContent = `User-agent: *
Allow: /

Sitemap: https://joesbarbershop.vercel.app/sitemap-index.xml
`;

writeFileSync(robotsPath, showcaseMode ? showcaseContent : goLiveContent);
console.log(`generate-robots.mjs — wrote ${showcaseMode ? 'showcase (Disallow)' : 'go-live (Allow)'} robots.txt`);
```

**Wiring:** extend `site/package.json` `prebuild` script from `node scripts/generate-mtimes.mjs` to `node scripts/generate-mtimes.mjs && node scripts/generate-robots.mjs`. Mirrors the existing pre-build hook idiom Plan 05-06 established.

**Approach B (lighter — manual flip):** Treat robots.txt as a hand-edited file with two known states. Wave 2 commits the showcase variant; Wave 5 commits the go-live variant. No script needed; trade-off is two flip-commits instead of one env-var change.

**Recommended:** Approach A. CONTEXT D-03 explicitly calls out "go-live flip after Joe's approval is a one-env-var change + redeploy, not a hand-edit of robots.txt + Base.astro at the moment Joe says yes." A pre-build script honors that decision and reduces Wave 5 to a single Vercel-env-var flip + redeploy.

**Default env-flag value:** `PUBLIC_SHOWCASE_MODE=true` is the safe default (treats unset == showcase mode). Only an explicit `false` flips to go-live.

---

### `site/src/layouts/Base.astro` (MODIFY — D-02/D-03 conditional noindex meta)

**Analog:** itself, lines 31-33 + 71-79 — the existing `enableClarity` env-gated emission. The noindex flag follows the **identical pattern**.

**Current code — Clarity env-gate pattern** (lines 31-33):

```typescript
// Microsoft Clarity gating per D-02 + D-03.
const clarityId = import.meta.env.PUBLIC_CLARITY_PROJECT_ID;
const enableClarity = import.meta.env.PROD && clarityId;
```

**And template conditional** (lines 71-79):

```astro
{enableClarity && (
  <script is:inline define:vars={{ clarityId }}>
    ...
  </script>
)}
```

**Pattern to add — showcase noindex meta** (mirror Clarity's shape exactly):

In frontmatter, after line 33:

```typescript
// Showcase-mode noindex gating per D-02 + D-03.
// PUBLIC_SHOWCASE_MODE defaults to true (safe — assume noindex until explicitly flipped).
// Set PUBLIC_SHOWCASE_MODE=false in Vercel env vars after Joe's approval to enable indexing.
const showcaseMode = import.meta.env.PUBLIC_SHOWCASE_MODE !== 'false';
```

In `<head>`, after line 41 (the existing `<meta name="description">` block) and before the canonical link:

```astro
{showcaseMode && <meta name="robots" content="noindex,nofollow,noarchive" />}
```

**Why default-to-true semantics:** matches the "fail-safe" philosophy of the project. An unset env var should ship as noindex, not as indexable. A typo in the env-var name during the go-live flip results in noindex (visible immediately in HTML, easy to debug) rather than accidental indexing (silent, requires Search Console to detect).

**Position of meta tag in `<head>`:** placing it before `<link rel="canonical">` mirrors search-engine processing order (robots directive is read before crawler considers the canonical). Not strictly required — Google parses head in any order — but conventional.

**No HairSalon JSON-LD removal during showcase mode:** the schema still emits; only the HTML `<meta robots>` instruction changes. Schema is information, not crawl-permission. AI assistants reading HTML directly (not via Google index) still see the structured data. This is intentional — gives the D-25 Rich Results paste something to validate against.

---

### `site/.env.example` (MODIFY — D-04 new flag documentation)

**Analog:** itself, lines 1-5 — the existing `PUBLIC_CLARITY_PROJECT_ID` documentation block.

**Current content** (5 lines):

```
# Microsoft Clarity project ID (public; safe to commit this example file).
# Get a project ID at https://clarity.microsoft.com — create one named "Joe's Barbershop".
# Set in Vercel project settings → Environment Variables for Preview + Production.
# Local dev does NOT need this — Clarity is gated by import.meta.env.PROD.
PUBLIC_CLARITY_PROJECT_ID=
```

**Extension pattern** (append, do not modify existing):

```
# Showcase-mode noindex flag (public; safe to commit).
# When unset OR set to anything other than "false", site emits <meta name="robots" content="noindex">
# on every page and serves Disallow: / via robots.txt.
# Flip to "false" in Vercel env vars (Production scope) AFTER Joe's approval to enable indexing.
# Local dev: leave unset (showcase mode) unless explicitly testing indexable behavior.
PUBLIC_SHOWCASE_MODE=true
```

**Mirrors Clarity's documentation block exactly:** 1-line purpose + 1-line how-to-set + 1-line where-to-set + 1-line local-dev-behavior + bare-equals literal.

**Also note in same file (for completeness, since D-04 sets two env vars):** `VERCEL_DEEP_CLONE` is a Vercel-platform-only variable (not consumed by `import.meta.env.*` in the Astro code) — it should be documented as a code comment, not an env-example variable. The existing precedent for this is the Phase 5 summary text. Recommendation: extend `.env.example` with a documentation-only comment block at the bottom:

```
# ─────────────────────────────────────────────────────────────────────────────
# Vercel-platform-only env vars (set in Vercel project settings, NOT consumed
# directly by Astro/Vite at build time):
#
#   VERCEL_DEEP_CLONE=1
#     Set on Preview + Production. Causes Vercel to run `git fetch --unshallow`
#     before the build, so site/scripts/generate-mtimes.mjs can read the full
#     git history for Article dateModified values. Without this, dateModified
#     falls back to file-system mtime (= build time on Vercel) and the Article
#     freshness signal is meaningless.
```

Documenting it in `.env.example` keeps all deploy-side env-var knowledge in one place.

---

### `.planning/phases/03-unique-pages/scripts/audit.sh` (OPTIONAL MODIFY — D-05 deployed-routes check)

**Analog:** itself, `check_lighthouse` lines 516-565 — the existing network-aware optional check pattern. Specifically, the `command -v` skip-guard at lines 517-518 + early-return on missing dependency + median-of-runs network execution.

**Recommended new function — `check_deployed_routes`:**

```bash
check_deployed_routes() {
  if ! command -v curl >/dev/null 2>&1; then
    skip "deployed-routes" "curl not installed"
    return
  fi
  local base_url="${DEPLOYED_BASE_URL:-}"
  if [ -z "$base_url" ]; then
    skip "deployed-routes" "DEPLOYED_BASE_URL env var not set (e.g., DEPLOYED_BASE_URL=https://site-xxx.vercel.app)"
    return
  fi

  # 17 routes: 6 unique pages (homepage + 5 named) + 6 services + 5 neighborhoods
  local unique_routes=("/" "about" "reviews" "faq" "east-county-traditional-barbershop" "2026-east-county-barbershop-cost-guide")
  local missing=()

  for route in "${unique_routes[@]}"; do
    local url
    if [ "$route" = "/" ]; then
      url="${base_url}/"
    else
      url="${base_url}/${route}"
    fi
    local code
    code=$(curl -s -o /dev/null -w '%{http_code}' "$url" 2>/dev/null || echo "000")
    if [ "$code" != "200" ]; then
      missing+=("${route}=${code}")
    fi
  done

  # 11 templated routes from canonical-slugs.txt
  while IFS= read -r slug || [ -n "$slug" ]; do
    [ -z "$slug" ] && continue
    local code
    code=$(curl -s -o /dev/null -w '%{http_code}' "${base_url}/${slug}" 2>/dev/null || echo "000")
    if [ "$code" != "200" ]; then
      missing+=("${slug}=${code}")
    fi
  done < "$SLUGS_FILE"

  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "deployed-routes" "non-200 routes: ${missing[*]}"
  fi
}
```

**Registry wiring** (mirror existing additions — lines 710-746 `run_check` case statement + lines 749-779 `run_all_checks` body):

In `run_check` case (after line 740):

```bash
    deployed-routes)             check_deployed_routes ;;
```

In the positional shortcut case (line 811):

```bash
  jsonld|sitemap-links|robots|text-as-image|bluf|lighthouse|meta-unique-titles|meta-og-twitter|responsive-breakpoints|deployed-routes)
```

In `run_all_checks` — **DO NOT add to the unconditional sweep.** The check requires `DEPLOYED_BASE_URL` and would force every dev `bash audit.sh` invocation to set it. The Phase 6 plan should invoke it explicitly: `bash audit.sh --check deployed-routes` (or `DEPLOYED_BASE_URL=https://... bash audit.sh deployed-routes`) as a Wave 2 step.

**Per CONTEXT § Claude's Discretion (line 70):** the planner may also implement this as a one-off curl-loop script in the Phase 6 dir instead of extending audit.sh. Either works. Extension recommended because:
1. Reuses existing pass/fail/skip helpers + run-summary output.
2. Lets Phase 7 (or any future phase) invoke the same check.
3. Single script registry for all gates.

**Output table option** (per CONTEXT line 68): the function above emits a single pass/fail. If the planner wants a per-route status table artifact, modify the success branch to also write `routes-status-$(date +%Y%m%d).txt` listing every `route → code` pair. Trivial extension.

---

### `.planning/phases/06-deploy-showcase/SHARE-CHECKLIST.md` (NEW — Joe-voice cheat-sheet per D-10/D-11)

**Analog:** none in repo. Closest is `.planning/phases/05-aeo-performance-meta/rich-results/README.md` (3-line brief note) — but that's a placeholder, not a deliverable. SHARE-CHECKLIST.md is Joe-text-formatted content, voice-guide-driven.

**Voice references the executor MUST read before drafting:**
- `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` — master voice reference
- `~/Documents/DT Vault/3-resources/writing-style-guide-anti-ai-voice.md` — banned words/phrases for cheat-sheet content
- `~/Documents/DT Vault/3-resources/writing-style-guide-inter-teammate-voice.md` — Joe-text channel tone (closer to peer-to-peer than client-formal)

**Structure per CONTEXT D-11** (6 sections, plain-English, Joe-voice):

```markdown
# Joe's Review — Quick Cheat-Sheet

Hey Joe — site preview is here: <preview-url>

Run through these 6 things and tell me what's right or wrong. No
order, no rush — just whatever jumps out as you scroll.

## 1. Does it feel like your shop?
Checkerboard floor, mahogany chairs, letter board — does the look
read as Joe's Barbershop, or does it feel like someone else's site
slapped your name on it?

## 2. Are the prices right?
Letter board on the homepage shows: haircut $30, haircut + beard
$50, kids' cut $25. Anything wrong?

## 3. Does the FAQ sound like you?
Scroll the FAQ on the homepage and the master /faq page. Does it
sound like you talking, or like a stranger pretending?

## 4. Phone + hours
Phone: (619) 891-2775 — still right?
Hours: Tue–Sat 8 AM–6 PM — still right?

## 5. Photos
Any photo on the site you don't want on the live version? (Six
photos total — storefront, interior, chair, mid-cut, price board,
logo.)

## 6. Anything else
Anything missing, anything wrong, anything bugging you. Just tell
me. The list above isn't exhaustive — just a starter.

---

When you're done: just text me "looks good" or send a list of
things to fix. Either is fine.
```

**Critical constraints when drafting:**
- **Anti-AI voice:** no "elevate", "leverage", "robust", "seamless", "synergy", "best-in-class", "let's", "delve into", "tapestry". Plain words.
- **No marketing jargon:** not "user experience," not "brand identity," not "value proposition" — say "feel like your shop," "look," "what you charge."
- **Joe is the audience, not the buyer:** he's a barber, not a consultant client. Don't pitch the site. Ask for his read on the work.
- **Channel format:** Joe gets this via text. Lines must read on a phone (no wide tables, no markdown headers that render as `#` literals in iMessage — the planner may consider sending the URL via text and the checklist as a separate plain-text body, OR rendering the markdown on a temporary Vercel preview path).

**Per CONTEXT § Claude's Discretion (line 68):** exact wording is planner/executor judgment. The 6 categories above are locked by D-11; the prose within each category is open.

---

### `.planning/phases/06-deploy-showcase/joe-approval/` (NEW dir — D-12 SHOW-01 artifact)

**Analog:** `.planning/phases/05-aeo-performance-meta/rich-results/` — same shape (a directory holding human-captured artifacts + a README explaining what goes there).

**Directory contents at end of Wave 4:**

```
.planning/phases/06-deploy-showcase/joe-approval/
├── README.md             — explains what this directory holds
├── 2026-MM-DD-joe-signoff.txt   — Joe's text-response (transcribed) OR
├── 2026-MM-DD-joe-signoff.png   — screenshot of Joe's iMessage thread
```

**Pattern for the directory README** (mirror `rich-results/README.md` 3-sentence brief-note shape):

```markdown
# Joe Approval Artifacts — SHOW-01 Gating Event

When Joe responds to the SHARE-CHECKLIST.md text, capture his response here as proof
the SHOW-01 sign-off happened. Filename format: `<YYYY-MM-DD>-joe-signoff.{txt,png}`.
Plain-text transcription preferred for grep-ability; iMessage screenshot acceptable for
fidelity (no privacy concern — this is between Darrell and Joe, both consenting).
If Joe requests changes instead of approving, capture his change list here too as
`<YYYY-MM-DD>-joe-changes.txt` — that becomes the input to Wave 4.5 gap-closure work.
```

**Why a directory not a single file:** Joe may respond in multiple messages over days. Each capture is a discrete file. Also lets Wave 5 (go-live flip) reference a specific dated signoff file as the gating-event trigger.

---

### `.planning/phases/05-aeo-performance-meta/rich-results/` (REUSE — D-08 D-25 screenshots)

**Analog:** itself, current README.md (lines 1-3).

**Existing content** (`README.md`):

```markdown
# D-25 Manual Rich Results Test — Deferred to Phase 6

The D-25 Google Rich Results Test gate was deferred from Plan 05-07 to Phase 6
(showcase deploy). The local `dist/index.html` paste is a weaker signal than the
deployed Vercel preview URL anyway. Once the Phase 6 preview URL is live, paste
`<preview-url>/` and `<preview-url>/east-county-traditional-barbershop/` into
https://search.google.com/test/rich-results (use the **URL** tab, not Code), and
save the resulting full-page screenshots as `homepage-rich-results.png` and
`niche-landing-rich-results.png` in this directory. FAQPage rich-result deprecation
warnings (per RESEARCH § Pitfall 8) are expected and acceptable — AI engines still
consume the schema even though Google deprecated the rich-result display surface
on 2026-05-07.
```

**Phase 6 contribution:** drop two PNGs (`homepage-rich-results.png`, `niche-landing-rich-results.png`) per CONTEXT D-07/D-08. Optionally a third PNG if the bonus cost-guide paste validates (`cost-guide-rich-results.png`).

**Do NOT delete or modify the README.** It's the original deferral context — Phase 6 inherits it, doesn't replace it. The screenshots are the artifact; the README is the explanation.

**Per CONTEXT integration-points line 130:** decision is to reuse Plan 05-07's directory rather than create a new `.planning/phases/06-deploy-showcase/rich-results/`. Reason: the README already explains the deferred-to-Phase-6 context; duplicating that context in a new directory just creates two sources of truth.

---

## Shared Patterns

### Pattern S-1: env-flag gating idiom

**Source:** `site/src/layouts/Base.astro` lines 31-33 + 71-79 (`enableClarity = import.meta.env.PROD && clarityId` pattern, applied to Clarity script conditional emission).

**Apply to:** the new `PUBLIC_SHOWCASE_MODE` flag in Base.astro and the new `generate-robots.mjs` pre-build script.

```typescript
// Frontmatter compute (Base.astro):
const showcaseMode = import.meta.env.PUBLIC_SHOWCASE_MODE !== 'false';

// Template conditional (Base.astro <head>):
{showcaseMode && <meta name="robots" content="noindex,nofollow,noarchive" />}
```

```javascript
// Pre-build script (generate-robots.mjs):
const showcaseMode = process.env.PUBLIC_SHOWCASE_MODE !== 'false';
```

**Convention:** Astro env vars prefixed with `PUBLIC_` are exposed to client + server (per Astro/Vite). Default-to-true semantics (an unset or "true" value treats site as showcase mode) means the flag is fail-safe — accidental unset never ships indexable HTML. Only an explicit `"false"` flips to go-live.

---

### Pattern S-2: prebuild npm-script hook for generated artifacts

**Source:** `site/package.json` `"prebuild": "node scripts/generate-mtimes.mjs"` — Plan 05-06 introduced this. npm runs `prebuild` automatically before `build` with zero additional wiring.

**Apply to:** the new `generate-robots.mjs` script (if Approach A is chosen for robots.txt env-gating).

```json
"prebuild": "node scripts/generate-mtimes.mjs && node scripts/generate-robots.mjs",
```

**Convention:** chain pre-build scripts with `&&` in the same npm-script. Order is irrelevant for these two (they write to different paths). Both consume `process.env.*` directly (not `import.meta.env.*`) since they run in Node, not in Vite's transform pipeline.

**Vercel propagation:** env vars set in Vercel project settings are inherited by both the prebuild scripts (`process.env.*`) and the Astro build (`import.meta.env.*`). Single source of truth.

---

### Pattern S-3: atomic per-task commits

**Source:** Plans 05-01 through 05-07 — every task commits independently with descriptive feat/fix/docs subject. CONTEXT § Established Patterns line 122 calls this out as Phase 6's expectation.

**Apply to:** Wave 1's 4 cleanup tasks (CR-02, CR-03, CR-04, geo correction) — each gets its own commit. Wave 2's env-var setup is a human-action commit (no code change, but a Vercel-dashboard-state change captured in a summary). Wave 2's noindex implementation is one commit (Base.astro + .env.example + optional generate-robots.mjs together — they're one feature). Wave 3 D-25 is a single docs commit dropping the PNGs.

**Why per-task atomic:** lets the Wave 5 go-live revert be surgical if needed. If the noindex flag breaks something on flip, `git revert` of one commit reverts just that change, not the four-fix bundle.

---

### Pattern S-4: human-action checkpoint task with step-by-step

**Source:** Plan 05-07 Task 3 / D-25 deferral note + `rich-results/README.md` — the recipe is: explicit URL, explicit click sequence, explicit save path, explicit acceptance criteria (e.g., "Green entities for X; deprecation warnings for Y are acceptable").

**Apply to:** Wave 2's env-var-setting task (D-05), Wave 3's D-25 paste (D-06), Wave 4's Joe-text (D-10), Wave 5's go-live flip.

**Plan-task shape for a human-action checkpoint:**

```markdown
**Task: Set Vercel env vars** (human action, ~3 min)

Pre-conditions: vercel CLI authed to `darrelltang` (verify with `gh auth status` per global CLAUDE.md).

Steps:
1. `cd /Users/darrelltang/dtconsulting/joesbarbershop`
2. `vercel env add VERCEL_DEEP_CLONE preview production` — paste value `1`
3. `vercel env add VERCEL_DEEP_CLONE production` — paste value `1`
4. `vercel env add PUBLIC_CLARITY_PROJECT_ID production` — paste value from clarity.microsoft.com
5. `vercel env add PUBLIC_SHOWCASE_MODE preview production` — paste value `true`

Acceptance: `vercel env ls` shows all 3 vars across the listed scopes.
```

**Convention:** human-action tasks include the exact CLI commands or dashboard URLs. The executor is the human; the agent's role is to verify the work happened (via `vercel env ls` output capture or screenshot).

---

### Pattern S-5: wave-gate via audit.sh

**Source:** CONTEXT § Established Patterns line 124 — `bash audit.sh` exits 0/0/0 (passed/failed/skipped) before any wave advances. Plan 05's seven plans all ended with this gate.

**Apply to:** every Phase 6 wave boundary.

- **End of Wave 1 (cleanup):** `cd site && npm run build && bash ../.planning/phases/03-unique-pages/scripts/audit.sh` — must show 36 passed / 0 failed / 0 skipped (current baseline) or higher.
- **End of Wave 2 (showcase deploy):** same audit + new `bash audit.sh --check deployed-routes` against the preview URL — must pass.
- **End of Wave 5 (go-live flip):** same audit + `bash audit.sh --check deployed-routes` against the production URL with `PUBLIC_SHOWCASE_MODE=false` — must pass. Also: curl `<url>/robots.txt` must show `Allow: /`, NOT `Disallow: /`. Also: curl `<url>/` HTML must NOT contain `<meta name="robots" content="noindex`.

**Pre-existing baseline (per `05-07-SUMMARY.md` line 80):** `audit.sh` full suite emits "audit complete: 36 passed, 0 failed, 0 skipped" against current build. Phase 6 must preserve this.

---

### Pattern S-6: STATE.md / ROADMAP.md orchestrator-only

**Source:** CONTEXT § Established Patterns line 123 — Plan 05 executors did NOT touch these files. Orchestrator owns them.

**Apply to:** all Phase 6 plans. Executors update PHASE-summary files only. Phase-level rollups (STATE.md "Current Position", ROADMAP.md Phase 6 checkbox + Progress table row) are orchestrator territory at `/gsd-execute-phase` and `/gsd-transition` boundaries.

---

## No Analog Found

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `.planning/phases/06-deploy-showcase/SHARE-CHECKLIST.md` | Joe-voice cheat-sheet | static doc | Voice-guide-driven content; no template in repo. Vault voice guides (darrells-voice-guide.md + writing-style-guide-anti-ai-voice.md + writing-style-guide-inter-teammate-voice.md) are the canonical references, NOT a code analog. |

The new `generate-robots.mjs` script is also conceptually no-analog as a Phase 6 introduction — but it directly inherits the `generate-mtimes.mjs` file shape (imports, write-path, `dirname(fileURLToPath)` boilerplate), so it's covered under the existing pre-build-script idiom. Not a "no analog" — explicitly modeled on `generate-mtimes.mjs`.

---

## Metadata

**Analog search scope:**
- `site/src/data/` — 5 files (business.json, business.ts, reviews.json, competitors.json, git-mtimes.json)
- `site/src/layouts/` — 1 file (Base.astro — pattern source for env-flag gating)
- `site/src/components/schema/` — 7 files (Article.astro is the CR-04 target; others provide schema-component-shape reference)
- `site/scripts/` — 2 files (validate-schema.mjs CR-03 target; generate-mtimes.mjs is the prebuild idiom analog)
- `site/public/` — robots.txt only
- `site/` — .env.example, package.json (prebuild script wiring)
- `.planning/phases/03-unique-pages/scripts/` — audit.sh (28 existing check_* functions; pattern source for the new deployed-routes check)
- `.planning/phases/05-aeo-performance-meta/` — rich-results/ directory (REUSE; pattern for joe-approval/ directory)
- `.planning/phases/05-aeo-performance-meta/` — REVIEW.md (exact fix snippets for CR-02/CR-03/CR-04)
- `.planning/phases/05-aeo-performance-meta/` — 05-04, 05-06, 05-07 SUMMARY.md (operator-action context for env-var-setting tasks)

**Files scanned:** 21

**Pattern extraction date:** 2026-05-10

**Strongest analog idioms identified:**
1. **Carryforward fix snippets** — `05-REVIEW.md` CR-02/CR-03/CR-04 contain exact code-replacement blocks. Wave 1 is essentially a copy-paste-and-verify exercise, not a design exercise.
2. **`enableClarity` env-flag pattern in Base.astro** — directly replicable for `showcaseMode`. Same compute-in-frontmatter + template-conditional shape.
3. **`generate-mtimes.mjs` prebuild idiom** — drop-in pattern for `generate-robots.mjs`. Imports, path-resolution, write-file, npm-script wiring all transferable.
4. **`check_lighthouse` network-aware check shape in audit.sh** — directly replicable for `check_deployed_routes`. `command -v` skip-guard + env-var-driven URL + curl-loop + pass/fail aggregation.
5. **`rich-results/README.md` artifact-directory pattern** — replicable for `joe-approval/README.md`. Brief explanation + filename convention + acceptance criteria.

**Critical wave dependencies surfaced by pattern mapping:**
- Wave 1 (cleanup) must complete before Wave 2 (deploy) — CR-04 publisher fix is a prerequisite for D-25 Article validation in Wave 3.
- Wave 2 env-var setup must complete before Wave 2 deploy — `PUBLIC_SHOWCASE_MODE=true` must exist in Vercel before the first showcase deploy, or the build computes `showcaseMode === false` against the empty env-var (still safe due to default-to-true logic, but explicit-set is cleaner).
- Wave 4 SHARE-CHECKLIST.md authoring depends on Wave 3 D-25 validation passing — if D-25 surfaces a "Publisher logo is required" error, Wave 4 cannot ship until a Wave-1-style fix cycle re-completes Wave 1 → Wave 2 → Wave 3.

---

*Phase: 06-deploy-showcase*
*Pattern mapping completed: 2026-05-10*
