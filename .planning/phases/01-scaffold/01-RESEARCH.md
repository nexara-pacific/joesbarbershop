# Phase 1: Scaffold - Research

**Researched:** 2026-05-06
**Domain:** Astro 6 project initialization, Vercel deployment, base layout patterns
**Confidence:** HIGH

## Summary

Phase 1 stands up a working Astro 6 project in `site/` that builds, deploys to a Vercel preview URL, and renders a shared layout shell. Astro 6.2.2 ships with `strict` TypeScript as the default for new projects (the wizard no longer asks), and the built-in Image component (Sharp by default) already produces lazy-loaded WebP from local assets without any extra config. The Vercel adapter — and this is the load-bearing finding — is **NOT required for purely static Astro deploys to Vercel** per Vercel's own docs; it is only needed if you want Vercel-specific features like Web Analytics, on-demand Image Optimization at the CDN edge, ISR, or SSR. Phase 1 is currently scoped as static-only with no SSR. SCAF-04's literal text ("Vercel adapter configured for static deploy") technically overspecs the phase: the phase goal can be met with zero adapter and zero `vercel.json`, and the adapter would only matter when Phase 5 wants Vercel's CDN-level image optimization. I recommend installing `@astrojs/vercel` 10.x anyway (it's a one-liner, unblocks Phase 5, and satisfies the literal requirement) but configuring it as the no-op default — not adding `output: 'static'` (deprecated/redundant) nor a custom adapter.

The other notable wrinkle is that `@astrojs/sitemap` outputs `/sitemap-index.xml` (plus numbered `/sitemap-0.xml` files), not `/sitemap.xml`. SCAF-03's literal text says `/sitemap.xml` — this is a benign mismatch since search engines accept either, but the planner should know not to write a verification step that curls `/sitemap.xml` expecting a 200.

**Primary recommendation:** Run `npm create astro@latest site -- --template minimal --yes`, then `npx astro add sitemap vercel` from inside `site/`. Add `image.layout: 'constrained'` and a `site:` URL to `astro.config.mjs`. Build a single `Base.astro` layout with empty/placeholder `<Masthead />`, `<UtilBar />`, `<Footer />` components (real content lands in Phase 2). Deploy via `vercel --cwd site` for the preview URL. Done.

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| HTML rendering (all pages) | Astro static build (CDN/Static) | — | Zero-JS-by-default static output; AEO requires parsers see content in DOM; no runtime needed |
| Image optimization (build-time srcset/AVIF/WebP) | Astro Image (build) | Sharp (Node build process) | Sharp ships with Astro 6; runs at `astro build` time; outputs hashed assets to `_astro/` |
| Sitemap generation | Astro Sitemap integration (build) | — | Build-time crawl of generated pages; emits `/sitemap-index.xml` + `/sitemap-0.xml` |
| Static asset hosting | Vercel CDN | — | Preview URL, immutable cache headers, automatic gzip/brotli |
| Layout composition (masthead/utilbar/footer) | Astro layout component (`Base.astro` with `<slot />`) | — | Standard Astro pattern; no JS runtime; one file imported by every page |
| TypeScript type-checking | `astro check` (build pipeline) | tsc-equivalent via `astro/tsconfigs/strict` preset | Astro v5+ defaults to `strict`; `astro check` runs as part of `npm run build` flow |

**Why this matters:** Phase 1 is intentionally a single-tier deploy — no API, no DB, no SSR. Every capability lives at static-build or CDN tier. Any task that mentions "server", "function", "API route", "middleware" is out of scope for Phase 1 and is a flag for the planner.

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| SCAF-01 | Astro project initialized in `site/` with TypeScript strict mode | Astro v5+ defaults to `strict` preset automatically; verified via official upgrade-to-v5 doc. `npm create astro@latest site` is sufficient — no `--typescript` flag (removed in v5). Just confirm `tsconfig.json` extends `astro/tsconfigs/strict`. |
| SCAF-02 | Astro Image integration configured (AVIF/WebP/srcset, lazy-load) | `astro:assets` is built-in (no separate package since Astro 3). Sharp is the default image service. Lazy-load + `decoding="async"` are auto-applied. For srcset, set `image.layout: 'constrained'` in `astro.config.mjs` (stable since 5.10). For AVIF use `<Picture formats={['avif','webp']} />`. |
| SCAF-03 | Astro Sitemap integration configured for `/sitemap.xml` | Install `@astrojs/sitemap` 3.7.2 via `npx astro add sitemap`. **Caveat:** integration emits `/sitemap-index.xml` (not `/sitemap.xml`); this is the standard sitemap-index pattern and is what `robots.txt` should reference. Requires `site:` URL in config. |
| SCAF-04 | Vercel adapter configured for static deploy | **Tension flagged:** Vercel docs explicitly say "deploy a static Astro app to Vercel with zero configuration" — adapter is NOT required for pure static. However, installing `@astrojs/vercel` 10.0.6 (peer dep `astro: ^6.0.0`) satisfies the literal requirement and unblocks Phase 5 (Vercel Image Optimization, Web Analytics). Use unified import `import vercel from '@astrojs/vercel'` (no `/static` subpath — that path was removed in v8+). |
| SCAF-05 | Base layout (`src/layouts/Base.astro`) renders shared masthead, util bar, footer on every page | Standard Astro layout pattern: `<html><head>{slots}</head><body><UtilBar /><Masthead /><slot /><Footer /></body></html>`. Each page imports `Base.astro` and wraps content. For Phase 1, masthead/utilbar/footer can be visible-but-stubbed (real OD-5 design lands in Phase 2). |

## Standard Stack

### Core

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| `astro` | 6.2.2 | Web framework — zero-JS by default, content-first | Phase aligns with project's locked decision; AEO requires parser-visible DOM |
| `typescript` | 5.x (peer of astro) | Type safety | Astro's `strict` preset is the v5+ default; no opt-in needed |
| `@astrojs/sitemap` | 3.7.2 | Auto-generates `sitemap-index.xml` | Official Astro integration, only ~5KB of build-time work |
| `@astrojs/vercel` | 10.0.6 | Vercel adapter (optional but install for Phase 5) | Required peer `astro: ^6.0.0`; unified import in 10.x |
| `sharp` | 0.34.5 | Image processing engine | Astro 6 defaults to Sharp; auto-installed when `astro add` is used |

[VERIFIED: npm view astro version → 6.2.2]
[VERIFIED: npm view @astrojs/vercel version → 10.0.6, peerDependencies = { astro: '^6.0.0' }]
[VERIFIED: npm view @astrojs/sitemap version → 3.7.2]
[VERIFIED: npm view sharp version → 0.34.5]

### Supporting

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| `@astrojs/check` | latest | TypeScript checker for `.astro` files | Auto-installed by `astro add`; powers `astro check` |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `@astrojs/vercel` adapter | Nothing (zero-config static deploy) | Cleaner; matches Vercel's docs exactly; but Phase 5 will need the adapter for Web Analytics or Vercel-edge image optimization, so installing now amortizes a future config change. **Decision: install but configure as no-op.** |
| `astro:assets` `<Image />` | `<Picture />` for multi-format | `<Image />` outputs single `<img>` with WebP; `<Picture />` outputs `<picture>` with AVIF + WebP fallbacks. Use `<Picture formats={['avif','webp']} />` for the hero image (Phase 5 perf), `<Image />` everywhere else. |
| Vercel CLI deploy from subdirectory via `--cwd` | Set Root Directory in Vercel dashboard | `--cwd site` works first-try; dashboard requires a Git-connected project. For preview-only, `--cwd` is simpler. |

**Installation:**

```bash
# From repo root (one-time)
npm create astro@latest site -- --template minimal --yes --no-git --skip-houston --install

# From site/ subdirectory
cd site
npx astro add sitemap vercel  # accepts both adds in one command; auto-edits astro.config.mjs
```

**Version verification (run before locking the plan):**

```bash
npm view astro version           # expect 6.x
npm view @astrojs/vercel version # expect 10.x with peer astro ^6
npm view @astrojs/sitemap version
```

## Architecture Patterns

### System Architecture Diagram

```
┌──────────────────────────────────────────────────────────────────────┐
│                        DEVELOPMENT (local)                           │
│                                                                      │
│   site/src/pages/*.astro  ─┐                                         │
│   site/src/layouts/*.astro ─┼──► astro build  ──► site/dist/*.html   │
│   site/src/data/*.ts       ─┤    (Sharp +                            │
│   site/public/photos/*     ─┘     Sitemap +                          │
│                                   Vercel adapter)                    │
└──────────────────────────────────────────┬───────────────────────────┘
                                           │
                                           ▼
                                    vercel --cwd site
                                           │
                                           ▼
┌──────────────────────────────────────────────────────────────────────┐
│                         VERCEL CDN (preview)                         │
│                                                                      │
│   https://<project>-<hash>.vercel.app/         ──► HTML              │
│   https://<project>-<hash>.vercel.app/sitemap-index.xml ──► XML      │
│   https://<project>-<hash>.vercel.app/_astro/<hash>.webp  ──► image  │
│                                                                      │
│   No serverless functions. No middleware. Pure static cache.         │
└──────────────────────────────────────────────────────────────────────┘
```

For Phase 1, the only "request" path is browser → Vercel CDN → static asset. There is no runtime processing on Vercel.

### Recommended Project Structure

```
joesbarbershop/                    # repo root (existing)
├── inputs/                        # already exists (brief, photos, AEO rules)
├── mockups/                       # already exists (currently empty)
├── .planning/                     # already exists (GSD workflow files)
└── site/                          # NEW — Phase 1 creates this
    ├── public/                    # static assets served as-is
    │   └── robots.txt             # added in Phase 5; Phase 1 can leave default
    ├── src/
    │   ├── layouts/
    │   │   └── Base.astro         # SCAF-05 — shared shell
    │   ├── components/
    │   │   ├── Masthead.astro     # Phase 1 stub; Phase 2 fills in
    │   │   ├── UtilBar.astro      # Phase 1 stub; Phase 2 fills in
    │   │   └── Footer.astro       # Phase 1 stub; Phase 2 fills in
    │   └── pages/
    │       ├── index.astro        # smoke-test page that uses Base.astro
    │       └── about.astro        # second page to prove layout reuse
    ├── astro.config.mjs           # integrations + image.layout + site URL
    ├── package.json
    └── tsconfig.json              # extends astro/tsconfigs/strict
```

**Why a flat single-package layout (not a monorepo):** The repo holds inputs/, mockups/, .planning/, and site/. Only `site/` is npm-managed. There's no benefit from npm workspaces here — no shared packages between subdirectories. Keep `site/` as its own self-contained npm root with its own `package.json`. The repo root stays npm-free.

### Pattern 1: Astro Layout with `<slot />`

**What:** A reusable HTML shell that accepts page-specific content via `<slot />` and page-specific `<head>` content via `<slot name="head" />`.

**When to use:** Every page in the site. Phase 1 needs exactly one layout (`Base.astro`); Phase 2 may add specialized layouts that compose `Base.astro`.

**Example:**

```astro
---
// Source: https://docs.astro.build/en/basics/layouts/
// site/src/layouts/Base.astro
import UtilBar from '../components/UtilBar.astro';
import Masthead from '../components/Masthead.astro';
import Footer from '../components/Footer.astro';

interface Props {
  title: string;
  description?: string;
}

const { title, description } = Astro.props;
---
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title}</title>
    {description && <meta name="description" content={description} />}
    <slot name="head" />
  </head>
  <body>
    <UtilBar />
    <Masthead />
    <main><slot /></main>
    <Footer />
  </body>
</html>
```

**Page using the layout:**

```astro
---
// site/src/pages/index.astro
import Base from '../layouts/Base.astro';
---
<Base title="Joe's Barbershop — Bostonia, El Cajon">
  <h1>Joe's Barbershop</h1>
  <p>Phase 1 placeholder content. Phase 3 fills this in.</p>
</Base>
```

### Pattern 2: Astro Image with Sharp (default)

**What:** `<Image>` from `astro:assets` accepts an imported asset, infers width/height to prevent CLS, outputs an `<img>` with `loading="lazy"` and `decoding="async"`, and rewrites the src to a hashed WebP under `_astro/`.

**When to use:** Every photo. For the hero (above the fold), use `loading="eager"` + `fetchpriority="high"` (Phase 5 perf concern, not Phase 1).

**Example:**

```astro
---
// Source: https://docs.astro.build/en/guides/images/
import { Image, Picture } from 'astro:assets';
import storefront from '../assets/storefront.jpg';
---
<!-- Single-format (WebP), lazy-loaded -->
<Image src={storefront} alt="Joe's Barbershop storefront on Broadway" />

<!-- Multi-format with AVIF + WebP fallback -->
<Picture
  src={storefront}
  formats={['avif', 'webp']}
  alt="Joe's Barbershop storefront on Broadway"
/>
```

**Phase 1 wiring:** photos go to `site/src/assets/` (NOT `site/public/`) — only assets imported through `astro:assets` get optimized. Files in `public/` are served verbatim.

### Pattern 3: `astro.config.mjs` shape for Phase 1

**What:** Single config file declaring integrations, the `site:` URL (required by sitemap), and image layout.

**Example:**

```javascript
// Source: https://docs.astro.build/en/guides/integrations-guide/sitemap/
//         https://docs.astro.build/en/guides/integrations-guide/vercel/
//         https://docs.astro.build/en/guides/images/
// site/astro.config.mjs
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import vercel from '@astrojs/vercel';

export default defineConfig({
  // REQUIRED by @astrojs/sitemap. Use a placeholder until the preview URL exists,
  // then update to the actual Vercel URL after first deploy.
  site: 'https://joesbarbershop.vercel.app',
  integrations: [sitemap()],
  adapter: vercel(),       // No-op for pure static; unlocks Phase 5 Vercel features
  image: {
    layout: 'constrained', // stable since Astro 5.10 — auto-srcset + sizes
    responsiveStyles: true,
  },
});
```

### Anti-Patterns to Avoid

- **Using `output: 'static'` in astro.config.mjs:** Static is already the default in Astro 6 — adding it is redundant and the `'hybrid'` value was deprecated. Just leave it unset.
- **Importing `@astrojs/vercel/static` or `@astrojs/vercel/serverless`:** These subpaths were unified in v8+. The current package only exports the root path. Import as `import vercel from '@astrojs/vercel'`.
- **Putting photos in `site/public/photos/`:** Files in `public/` bypass `astro:assets`, so they get NO optimization — no AVIF, no srcset, no hash, no CLS prevention. Photos must go in `site/src/assets/` and be imported into pages. (Phase 2 will need to remember this when porting the 6 photos from `inputs/photos/`.) NOTE: REQUIREMENTS.md DESN-04 says "6 photos copied to `site/public/photos/`" — this is a **bug in the requirement**; the planner for Phase 2 should flag it.
- **Trying to put `rootDirectory` in `vercel.json`:** Not supported. Vercel's Root Directory is dashboard-only or via CLI `--cwd`. For Phase 1, use `--cwd site`.
- **Hand-rolling a `vercel.json` with `framework: 'astro'`:** Vercel auto-detects Astro from `package.json`. Adding `vercel.json` only matters if you need redirects, headers, or output overrides. Phase 1 doesn't need it.
- **Adding any client-side JS framework integration (React/Vue/Svelte):** Project constraint — zero-JS-by-default for AEO. Pure Astro components only.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Image optimization (resize, format conversion, srcset) | Custom Sharp pipeline + PicturePolyfill | `astro:assets` `<Image />` / `<Picture />` | Built into Astro 6, handles AVIF/WebP, srcset, lazy-load, CLS prevention; one import |
| Sitemap XML generation | Manual XML writer iterating page routes | `@astrojs/sitemap` | Auto-discovers all pages, splits at 45k entries, supports lastmod/changefreq, validates against sitemap.org schema |
| Page layout duplication (head/header/footer per page) | `import './header.html'` or copy-paste | Astro layout component with `<slot />` | First-class Astro pattern; SSR-safe; supports slot composition for advanced needs |
| TypeScript strict mode setup | Custom `tsconfig.json` from scratch | `"extends": "astro/tsconfigs/strict"` | Astro ships three presets (base/strict/strictest); strict is the v5+ default and includes `verbatimModuleSyntax`, `strictNullChecks`, `allowJs` for content collections |
| Vercel deployment config | Custom build scripts + curl-uploads | `vercel` CLI from `site/` (or `--cwd site`) | Auto-detects Astro framework, sets correct build command, output dir, headers; outputs preview URL to stdout |

**Key insight:** Phase 1 is almost entirely "use the defaults." Astro 6 + Vercel make a near-zero-config combo for static sites. Resist the urge to add custom build scripts, custom Vite config, or custom Vercel routing. Every line of custom config is a future maintenance liability and an AEO risk if it accidentally introduces JS.

## Common Pitfalls

### Pitfall 1: Sitemap caveat — `/sitemap.xml` does not exist

**What goes wrong:** SCAF-03 says "Sitemap integration configured for `/sitemap.xml`". A literal verification step that curls `/sitemap.xml` returns 404.
**Why it happens:** `@astrojs/sitemap` always emits `/sitemap-index.xml` plus `/sitemap-0.xml` (numbered shards), regardless of how few pages exist. There is no `/sitemap.xml` output.
**How to avoid:** Verify by curling `/sitemap-index.xml` instead. The `robots.txt` (Phase 5) should reference `/sitemap-index.xml`. Update SCAF-03's verification language in the plan.
**Warning signs:** A plan task that says "curl `/sitemap.xml` and expect 200" — that test will fail.

### Pitfall 2: `site:` URL is required for sitemap and isn't known until first deploy

**What goes wrong:** First `npm run build` fails or sitemap is empty because `site:` config is missing/wrong.
**Why it happens:** `@astrojs/sitemap` requires a fully-qualified `site:` value to generate absolute `<loc>` entries. Vercel's preview URL isn't known until after the first `vercel` invocation.
**How to avoid:** (a) Use a placeholder `site:` URL during initial scaffolding (e.g., `https://joesbarbershop.vercel.app` — the project name suggests this is what Vercel will assign by default). (b) After first deploy, update `site:` to match the actual preview URL Vercel returned. (c) Phase 6 will revisit `site:` again before showcase.
**Warning signs:** Build error "site option required by @astrojs/sitemap" or sitemap entries with relative paths.

### Pitfall 3: `vercel --cwd site` first-run interactive prompts

**What goes wrong:** First `vercel --cwd site` invocation prompts for project name, scope, and "link to existing project?" — interactive flow blocks scripted deploys.
**Why it happens:** Vercel CLI links a local directory to a Vercel project on first deploy and persists that link in `site/.vercel/project.json`.
**How to avoid:** First run interactively (`vercel --cwd site`), accept defaults, get the preview URL. Subsequent runs are non-interactive. Alternatively, pass `--yes` to accept all defaults. Verify the active GitHub account is correct before running (`gh auth status`) per global CLAUDE.md.
**Warning signs:** Trying to run from CI without an existing `.vercel/project.json`.

### Pitfall 4: TypeScript strict mode breaks because of an `any` in a content collection schema

**What goes wrong:** Phase 1 builds clean. Phase 2 adds content collections with loose schemas, build breaks under `strict` mode.
**Why it happens:** `astro/tsconfigs/strict` enforces `noImplicitAny`. Zod schemas in `content/config.ts` are typed precisely; mistakes show up at build time rather than runtime.
**How to avoid:** Phase 1 doesn't author content collections — but Phase 1's tsconfig sets the rules Phase 2 will live under. Document this so Phase 2's plan knows to expect strict-mode pushback when authoring collection schemas.
**Warning signs:** Phase 2 plans that say "use `z.any()`" — that's a strict-mode escape hatch and shouldn't be used.

### Pitfall 5: Photos in `public/` get no optimization

**What goes wrong:** Photos placed in `site/public/photos/` and referenced via `<img src="/photos/foo.jpg">` are served verbatim — no AVIF, no srcset, no width/height inference, large file sizes.
**Why it happens:** Astro's `<Image />` only optimizes assets imported through `astro:assets` from `src/`. The `public/` directory is a static-passthrough, treated like a CDN drop.
**How to avoid:** Photos must be in `site/src/assets/` and imported into pages. **REQUIREMENTS.md DESN-04 says `site/public/photos/` — this is wrong; flag it for the Phase 2 planner.** Phase 1 doesn't yet copy photos so this isn't actionable in Phase 1, but the research is where this gets discovered.
**Warning signs:** Phase 5 Lighthouse audit shows large image weights; AVIF not delivered to supporting browsers.

### Pitfall 6: SCAF-04 tension — adapter not strictly required

**What goes wrong:** Plan adds `@astrojs/vercel`, configures `output: 'server'` to "really use the adapter", and now the build outputs a serverless function instead of static HTML.
**Why it happens:** Misreading the adapter's purpose. The adapter is a *capability* — it doesn't change rendering mode unless you also set `output:`. Setting `output: 'server'` makes everything SSR, which is wrong for Phase 1.
**How to avoid:** Install `@astrojs/vercel` 10.x (satisfies SCAF-04 literal text and unblocks Phase 5). DO NOT set `output:` in `astro.config.mjs` (default is static). The adapter will be a no-op until Phase 5 adds Web Analytics or `imageService: true`.
**Warning signs:** `astro build` output mentions ".vercel/output/functions" — that's serverless mode, wrong for Phase 1.

## Runtime State Inventory

Phase 1 is greenfield (no existing runtime state to migrate). N/A.

## Code Examples

### Example 1: Minimal `package.json` after `astro add`

```json
{
  "name": "joes-barbershop-site",
  "version": "0.0.1",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "astro dev",
    "build": "astro build",
    "preview": "astro preview",
    "astro": "astro"
  },
  "dependencies": {
    "@astrojs/sitemap": "^3.7.2",
    "@astrojs/vercel": "^10.0.6",
    "astro": "^6.2.2",
    "sharp": "^0.34.5"
  },
  "devDependencies": {
    "@astrojs/check": "latest",
    "typescript": "^5.0.0"
  }
}
```

### Example 2: `tsconfig.json`

```json
{
  "extends": "astro/tsconfigs/strict",
  "include": [".astro/types.d.ts", "**/*"],
  "exclude": ["dist"]
}
```

This is what `npm create astro@latest` writes by default in v5+. Verify it's present after init; do not author manually unless missing.

### Example 3: First two pages (smoke-test layout reuse)

```astro
---
// site/src/pages/index.astro
import Base from '../layouts/Base.astro';
---
<Base title="Joe's Barbershop">
  <h1>Joe's Barbershop — Phase 1 placeholder</h1>
  <p>This page exists to verify the Base layout renders.</p>
</Base>
```

```astro
---
// site/src/pages/about.astro
import Base from '../layouts/Base.astro';
---
<Base title="About — Joe's Barbershop">
  <h1>About</h1>
  <p>Second page proves UtilBar/Masthead/Footer reuse.</p>
</Base>
```

Two pages are the minimum needed to satisfy success criterion #3 ("base layout renders shared masthead, utility bar, and footer on every page" — "every" needs to mean ≥2).

### Example 4: Stub components (real content in Phase 2)

```astro
---
// site/src/components/UtilBar.astro
---
<div class="util-bar" data-phase1-stub>
  <span>(Phase 2: util-bar — phone, hours, walk-ins welcome)</span>
</div>
```

```astro
---
// site/src/components/Masthead.astro
---
<header class="masthead" data-phase1-stub>
  <strong>Joe's Barbershop</strong>
  <nav><a href="/">Home</a> <a href="/about">About</a></nav>
</header>
```

```astro
---
// site/src/components/Footer.astro
---
<footer class="footer" data-phase1-stub>
  <small>(Phase 2: footer — NAP, social, hours)</small>
</footer>
```

The `data-phase1-stub` attribute makes it easy for Phase 2 to grep and verify these placeholders were all replaced.

### Example 5: Vercel CLI deploy commands

```bash
# First-time setup (interactive, accept defaults)
vercel --cwd site

# After link is established, scripted preview deploy
vercel --cwd site --yes > deployment-url.txt
PREVIEW_URL=$(cat deployment-url.txt)
curl -fsS -o /dev/null -w "%{http_code}\n" "$PREVIEW_URL"  # expect 200
```

[CITED: https://vercel.com/docs/cli/deploy — "vercel --cwd [path-to-project]" and "stdout is always the Deployment URL"]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `import vercel from '@astrojs/vercel/static'` | `import vercel from '@astrojs/vercel'` (unified) | @astrojs/vercel v8 (~2024) | Stale tutorials still show `/static` and `/serverless` subpaths — they no longer exist in the package's `exports` map. |
| `output: 'hybrid'` for mixing static + SSR | `output: 'static'` is default; `prerender = false` per route for opt-in SSR | Astro 5 | `'hybrid'` value removed; project-wide SSR is `'server'`, otherwise the default. |
| `--typescript strict` flag during `create-astro` | `strict` is default; flag removed | Astro 5 | Wizard no longer prompts for TS preset. |
| Manual `srcset`/`sizes` on `<img>` | `image.layout: 'constrained'` config | Astro 5.10 (stable) | Auto-generated srcset/sizes; no per-image config needed. |
| Astro Image as separate `@astrojs/image` package | Built-in `astro:assets` module | Astro 3 (2023) | Don't install `@astrojs/image` — it's deprecated. |

**Deprecated / outdated patterns to reject:**
- Tutorials referencing `@astrojs/image` package — that's the pre-3.0 module, removed.
- Configs with `experimental.assets: true` — assets are no longer experimental.
- Configs with `output: 'hybrid'` — collapsed into `'server'` with per-route `prerender`.
- Configs with `experimental.responsiveImages: true` — stable since 5.10.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | Vercel preview URL pattern will be `https://joesbarbershop.vercel.app` (project name slugged) | Pattern 3 — `astro.config.mjs` | Low — placeholder `site:` URL only matters for the sitemap's absolute `<loc>` values. Update after first `vercel` deploy reveals the actual URL. |
| A2 | `npm create astro@latest --template minimal` accepts the `site` directory name as positional arg | Installation block | Low — Astro CLI accepts `npm create astro@latest <dir>`; if it doesn't, use `npm create astro@latest -- --dir site`. |
| A3 | `vercel --cwd site --yes` is non-interactive on subsequent runs after first `.vercel/project.json` is written | Pitfall 3 | Low — verified via Vercel CLI docs but exact `--yes` behavior best confirmed in execution. |
| A4 | DESN-04 in REQUIREMENTS.md ("photos copied to site/public/photos/") is a requirement bug because `public/` skips Astro Image optimization | Pitfall 5, Anti-Patterns | Medium — if the user intended verbatim public-served photos (no optimization), this is correct as written. But that contradicts SCAF-02's "AVIF/WebP/srcset, lazy-load" — flag for Phase 2 planner to confirm with user. |

## Open Questions

1. **Should Phase 1 install `@astrojs/vercel` if it's strictly not required?**
   - What we know: Vercel deploys static Astro with zero config; the adapter is required only for Vercel-specific features (Web Analytics, Image Optimization, ISR, SSR) which are Phase 5 concerns.
   - What's unclear: Does SCAF-04's literal text ("Vercel adapter configured for static deploy") want the adapter installed even if it's a no-op? Or was the requirement written before researching that Vercel auto-detects Astro?
   - Recommendation: Install `@astrojs/vercel` 10.x and call `vercel()` (no args) in `astro.config.mjs`. Satisfies the literal requirement; zero runtime cost; unblocks Phase 5 with no extra work. Note this in the plan so the user can override if they want the cleaner zero-adapter approach.

2. **Where should the 6 photos in `inputs/photos/` end up — `site/src/assets/` or `site/public/photos/`?**
   - What we know: `<Image />` only optimizes assets imported from `src/`. Photos in `public/` are served raw.
   - What's unclear: REQUIREMENTS.md DESN-04 explicitly says `site/public/photos/`. SCAF-02 explicitly says "AVIF/WebP/srcset". These contradict.
   - Recommendation: This is a Phase 2 question (Phase 1 doesn't move photos), but flag it in Phase 2's research so the planner asks the user. Best answer is `site/src/assets/photos/` so Astro Image runs.

3. **Sitemap path — should the plan rephrase SCAF-03 or just verify `/sitemap-index.xml`?**
   - What we know: Integration emits `/sitemap-index.xml`, never `/sitemap.xml`.
   - What's unclear: Whether the requirement should be edited in REQUIREMENTS.md or the plan should just translate it on the fly.
   - Recommendation: Phase 1 verification step curls `/sitemap-index.xml`. Note in the plan output that REQUIREMENTS.md's "/sitemap.xml" wording should be updated at the next milestone review.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Node.js | Astro build, Vercel CLI | ✓ | v25.9.0 | — (Astro 6 requires Node 18.20.8+ / 20.3.0+ / 22+; v25 is fine) |
| npm | Package install | ✓ | 11.12.1 | — |
| Vercel CLI | Preview deploy | ✓ | 50.33.0 | Could use `vercel.com` Git integration but CLI is simpler for showcase model |
| `gh` CLI | Account verification before deploys | ✓ (assumed from global CLAUDE.md workflow) | — | Without it, deploy may go to wrong Vercel account; user must run `gh auth status` and `vercel whoami` before first deploy |
| Sharp (build dep) | Astro Image optimization | ✓ (installed via `astro add`) | 0.34.5 | If Sharp install fails on this Mac (rare), use `image: { service: passthroughImageService() }` — but loses optimization |

**No external service dependencies** for Phase 1 beyond Vercel itself. No DB, no API, no auth, no CDN config.

**Pre-deploy verification:**

```bash
gh auth status                  # confirm DarrellTang or darrell-tang-consulting active
vercel whoami                   # confirm Vercel account matches
```

Neither account is locked-in for this project; the user should confirm which Vercel team should host the preview.

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | None — Phase 1 uses build/curl smoke checks, not unit tests |
| Config file | None |
| Quick run command | `cd site && npm run build` (~5–10s) + `curl -fsS <preview-url>` |
| Full suite command | Same as quick run for Phase 1 |

Phase 1 doesn't introduce a unit-test framework. Pages are static HTML — visual + curl smoke tests are sufficient. Phase 2 may introduce Vitest for `business.ts` typing tests; Phase 5 may introduce Lighthouse CI. Neither is a Phase 1 concern.

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|--------------|
| SCAF-01 | Astro project initialized in `site/` with TS strict | smoke (build) | `cd site && npm run build` exits 0; `cat site/tsconfig.json \| grep '"extends":.*"astro/tsconfigs/strict"'` | ❌ Wave 0 (creates `site/`) |
| SCAF-02 | Astro Image integration configured | smoke (build) | After build: `find site/dist -name "*.webp"` returns ≥1 hit if a test image is referenced; otherwise verify `import { Image } from 'astro:assets'` resolves with no error | ❌ Wave 0 |
| SCAF-03 | Sitemap configured | smoke (build + content) | `test -f site/dist/sitemap-index.xml && grep -q '<sitemapindex' site/dist/sitemap-index.xml` | ❌ Wave 0 |
| SCAF-04 | Vercel adapter configured | static (config) | `grep -q "from '@astrojs/vercel'" site/astro.config.mjs` AND `npm run build` exits 0 with no "missing adapter" warnings | ❌ Wave 0 |
| SCAF-05 | Base layout renders shared masthead/utilbar/footer on every page | smoke (HTML inspection) | After build: `grep -l 'data-phase1-stub' site/dist/index.html site/dist/about/index.html` returns both files | ❌ Wave 0 |
| Success #1 | `npm run build` exits 0 | smoke | `cd site && npm run build && echo OK` | ❌ Wave 0 |
| Success #2 | Vercel preview URL returns 200 on `/` | smoke | `curl -fsS -o /dev/null -w "%{http_code}" "$PREVIEW_URL"` returns "200" | ❌ Wave 0 |
| Success #3 | Layout renders on every page | manual + automated | manual: visit preview URL in browser, see masthead/utilbar/footer on `/` and `/about`. automated: grep `data-phase1-stub` in built HTML for both pages | ❌ Wave 0 |
| Success #4 | Image + Sitemap don't error at build | smoke | `npm run build 2>&1 \| tee build.log; ! grep -E "(missing adapter\|integration error)" build.log` | ❌ Wave 0 |

### Sampling Rate

- **Per task commit:** `cd site && npm run build` (exits 0)
- **Per wave merge:** Above + `cd site && npm run preview &` then `curl localhost:4321` returns 200
- **Phase gate:** Above + actual `vercel --cwd site` deploy returns a 200 preview URL

### Wave 0 Gaps

- [ ] `site/` directory does not yet exist — entire scaffold is Wave 0 work
- [ ] No `vercel link` exists for the project — first deploy will be interactive (one-time setup)
- [ ] `gh auth status` not verified — should be a manual pre-flight check before the first deploy task
- [ ] `inputs/photos/` photos are NOT yet in `site/src/assets/` — but that's Phase 2's job (DESN-04). Phase 1's image-integration verification can use a built-in test image or skip image rendering and just verify the integration registers.

## Project Constraints (from CLAUDE.md)

These constraints from `/Users/darrelltang/dtconsulting/joesbarbershop/CLAUDE.md` apply to Phase 1:

| Constraint | Source | Phase 1 Impact |
|------------|--------|----------------|
| Tech stack: Astro (zero-JS-by-default) | CLAUDE.md > Constraints | No React/Vue/Svelte integrations; pure Astro components only |
| Astro project lives in `site/` subdirectory | CLAUDE.md > Project | Repo root stays npm-free; all `npm` commands run from `site/` |
| Hosting: Vercel | CLAUDE.md > Constraints | Use `vercel` CLI (already installed); Vercel auto-detects Astro |
| No Tailwind | CLAUDE.md > Constraints | No `@astrojs/tailwind` or `tailwindcss` packages in Phase 1 (or ever) |
| No live deployment before Joe approves | CLAUDE.md > Constraints | Preview URL only — never `vercel --prod`; never connect a custom domain in Phase 1 |
| No edits to Joe's external surfaces | CLAUDE.md > Constraints | Out of scope for Phase 1 entirely |
| No duplication of vault content | CLAUDE.md > Constraints | Don't import or copy vault docs into the repo |

From global `~/.claude/CLAUDE.md`:

| Constraint | Source | Phase 1 Impact |
|------------|--------|----------------|
| Verify GitHub account before repo/push operations | Global > GitHub Accounts | Run `gh auth status` before any git push (Phase 1 stays local; this matters more in Phase 6) |
| Validate changes through primary interaction pattern before committing | Global > Work Style | "Build green + curl preview URL = 200" is the validation gate before commit |
| GSD Workflow Enforcement | CLAUDE.md > GSD Workflow | All file edits go through `/gsd-execute-phase` |

## Sources

### Primary (HIGH confidence)
- Context7 / `/llmstxt/astro_build_llms-full_txt` — Astro layout patterns, slot composition, image component API, v5 upgrade notes
- https://docs.astro.build/en/guides/typescript/ — TypeScript presets (base/strict/strictest), `verbatimModuleSyntax`
- https://docs.astro.build/en/guides/upgrade-to/v5/ — `strict` is the default; `--typescript` flag removed
- https://docs.astro.build/en/guides/integrations-guide/vercel/ — adapter installation, configuration options, when adapter is required
- https://docs.astro.build/en/guides/integrations-guide/sitemap/ — sitemap config, `site:` requirement, output filenames (`/sitemap-index.xml`)
- https://docs.astro.build/en/guides/images/ — built-in `<Image />` and `<Picture />`, default Sharp service, `image.layout: 'constrained'`
- https://docs.astro.build/en/basics/layouts/ — layout component pattern with `<slot />`
- https://docs.astro.build/en/guides/deploy/vercel/ — official Astro→Vercel deployment guide
- https://vercel.com/docs/frameworks/frontend/astro — Vercel's Astro guide; static deploys need zero config
- https://vercel.com/docs/cli/deploy — `vercel deploy` CLI reference, `--cwd`, `--prebuilt`, `--yes`, stdout = deployment URL
- https://vercel.com/docs/builds/configure-a-build — Root Directory is dashboard-only for Git-connected projects
- npm registry (`npm view`) — verified versions: astro 6.2.2, @astrojs/vercel 10.0.6, @astrojs/sitemap 3.7.2, sharp 0.34.5

### Secondary (MEDIUM confidence)
- https://medium.com/@aisyndromeart/deploying-an-astro-js-site-with-vercel-a-step-by-step-tutorial-cc082b002624 — third-party tutorial; cross-checked against official docs
- https://dev.to/uzukwu_michael_91a95b823b/from-code-to-live-in-minutes-deploying-my-astro-starlight-static-site-on-vercel-49ca — third-party tutorial; cross-checked

### Tertiary (LOW confidence)
- None — every load-bearing claim was verified via Context7, official docs, or `npm view`.

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — versions verified live against npm registry, peer deps confirmed
- Architecture: HIGH — single-tier static deploy, well-documented patterns, no novel composition
- Pitfalls: HIGH — sitemap path mismatch, public/ vs src/assets/, adapter-not-required tension all verified against official docs
- TypeScript strict mode: HIGH — Astro v5 changelog explicitly states strict is default
- Vercel CLI subdirectory deploy: HIGH — `--cwd` documented in Vercel CLI reference

**Research date:** 2026-05-06
**Valid until:** 2026-06-05 (30 days — Astro/Vercel stack is stable; no major releases expected in window)
