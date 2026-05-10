#!/usr/bin/env node
// site/scripts/generate-mtimes.mjs
//
// Purpose (D-10): Pre-build hook. For each tracked page file, run
// `git log -1 --format=%cI -- <file>` and write the ISO timestamp to
// site/src/data/git-mtimes.json so .astro pages can import dateModified
// values into Article schema + LastUpdated component.
//
// STUB: Plan 06 (Wave 5) replaces this body. For now, write an empty
// manifest so the file exists (Article + LastUpdated will need it once
// they're wired in Plan 05 / Plan 06).
//
// Vercel caveat (RESEARCH Pitfall 3): default git clone depth is shallow.
// Plan 06 will fall back to filesystem mtime if `git log` returns empty,
// AND surface an operator note recommending VERCEL_DEEP_CLONE=1.

import { writeFileSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const outPath = join(__dirname, '..', 'src', 'data', 'git-mtimes.json');
mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(outPath, JSON.stringify({}, null, 2) + '\n');
console.log(`generate-mtimes.mjs — STUB wrote empty manifest to ${outPath}`);
process.exit(0);
