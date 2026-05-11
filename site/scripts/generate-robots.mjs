#!/usr/bin/env node
// site/scripts/generate-robots.mjs
//
// Pre-build hook (D-02 + D-03). Rewrites site/public/robots.txt based on
// process.env.PUBLIC_SHOWCASE_MODE:
//   - unset or any value !== 'false'  -> Disallow: / (showcase mode, fail-safe default)
//   - 'false'                          -> Allow: / + Sitemap: (go-live mode)
//
// Wired via site/package.json "prebuild" alongside generate-mtimes.mjs.
// Default-to-true semantics: an unset env var is treated as showcase mode.

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
