#!/usr/bin/env node
// site/scripts/generate-mtimes.mjs
//
// Per D-10: for each tracked page file, run `git log -1 --format=%cI -- <file>`
// and write the ISO timestamp to site/src/data/git-mtimes.json so .astro pages
// can import dateModified values into Article schema + LastUpdated component.
//
// Vercel caveat (RESEARCH Pitfall 3): default git clone depth is shallow.
// Operator note: set VERCEL_DEEP_CLONE=1 in Vercel project settings.
// This script falls back to filesystem mtime if `git log` returns empty.

import { execSync } from 'node:child_process';
import { writeFileSync, statSync, mkdirSync } from 'node:fs';
import { dirname, join, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));
const repoRoot = resolve(__dirname, '..', '..');  // .../joesbarbershop

// Pages whose dateModified is consumed by Article schema + LastUpdated component.
// Paths are relative to the repo root (where `git log` runs).
const PAGES = [
  'site/src/pages/east-county-traditional-barbershop.astro',
  'site/src/pages/2026-east-county-barbershop-cost-guide.astro',
];

const mtimes = {};

for (const page of PAGES) {
  const absPath = join(repoRoot, page);
  let iso = '';
  try {
    iso = execSync(`git log -1 --format=%cI -- "${page}"`, {
      cwd: repoRoot,
      encoding: 'utf8',
    }).trim();
  } catch (err) {
    console.warn(`WARN: git log failed for ${page}: ${err.message}`);
  }
  if (!iso) {
    // Fallback: filesystem mtime (uncommitted or Vercel shallow-clone)
    try {
      iso = statSync(absPath).mtime.toISOString();
      console.warn(`WARN: ${page} — git mtime unavailable; falling back to fs mtime ${iso}`);
    } catch (err) {
      // File missing — write current time as last resort (build will still validate)
      iso = new Date().toISOString();
      console.warn(`WARN: ${page} — fs stat failed (${err.message}); using build time`);
    }
  }
  mtimes[page] = iso;
}

const outPath = join(__dirname, '..', 'src', 'data', 'git-mtimes.json');
mkdirSync(dirname(outPath), { recursive: true });
writeFileSync(outPath, JSON.stringify(mtimes, null, 2) + '\n');
console.log(`generate-mtimes.mjs — wrote ${Object.keys(mtimes).length} entries to ${outPath}`);
