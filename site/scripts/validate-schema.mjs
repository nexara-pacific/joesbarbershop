#!/usr/bin/env node
// site/scripts/validate-schema.mjs
//
// Per D-23.1: parse dist/**/*.html, extract every <script type="application/ld+json">
// block, validate required fields per Schema.org type, and assert no rendered block
// contains the literal substring '</script>' (RESEARCH Pitfall 1).
//
// Exits 0 if all blocks pass; exits 1 with a detailed FAIL list otherwise.

import { readFileSync, readdirSync, statSync, existsSync } from 'node:fs';
import { join, dirname, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';
import { load } from 'cheerio';

const __dirname = dirname(fileURLToPath(import.meta.url));
const distDir = resolve(__dirname, '..', 'dist');

// Schema.org required-field manifest (RESEARCH § Schema.org required-field cheatsheet).
const REQUIRED = {
  HairSalon:        ['name', 'address', 'telephone', 'openingHoursSpecification'],
  LocalBusiness:    ['name', 'address', 'telephone'],
  Service:          ['name', 'provider'],
  FAQPage:          ['mainEntity'],
  Question:         ['name', 'acceptedAnswer'],
  Answer:           ['text'],
  Person:           ['name'],
  Article:          ['headline', 'datePublished', 'dateModified', 'author'],
  AggregateRating:  ['ratingValue', 'reviewCount'],
  Review:           ['author', 'reviewRating'],
  PostalAddress:    ['streetAddress', 'addressLocality', 'addressRegion', 'postalCode'],
  GeoCoordinates:   ['latitude', 'longitude'],
  OpeningHoursSpecification: ['dayOfWeek', 'opens', 'closes'],
  Offer:            ['price', 'priceCurrency'],
};

const errors = [];

function checkBlock(block, file) {
  if (!block || typeof block !== 'object') return;
  const type = block['@type'];
  if (type && REQUIRED[type]) {
    for (const field of REQUIRED[type]) {
      const val = block[field];
      if (val === undefined || val === null || val === '') {
        errors.push(`${file}: ${type} missing required field '${field}'`);
      }
    }
  }
  // Recurse into nested objects + arrays
  for (const v of Object.values(block)) {
    if (Array.isArray(v)) {
      for (const item of v) {
        if (item && typeof item === 'object') checkBlock(item, file);
      }
    } else if (v && typeof v === 'object') {
      checkBlock(v, file);
    }
  }
}

function checkFile(filepath) {
  const html = readFileSync(filepath, 'utf8');
  const $ = load(html);
  const rel = filepath.replace(distDir + '/', '');

  $('script[type="application/ld+json"]').each((_, el) => {
    const raw = $(el).html() ?? '';

    // Pitfall 1 guard
    if (raw.includes('</script>')) {
      errors.push(`${rel}: JSON-LD block contains literal '</script>' substring`);
      return;
    }

    let parsed;
    try {
      parsed = JSON.parse(raw);
    } catch (err) {
      errors.push(`${rel}: unparseable JSON-LD — ${err.message}`);
      return;
    }

    // Block may be an object or an array (e.g., Review.astro emits one block but Review.astro
    // pattern emits one <script> per review — both shapes work)
    const blocks = Array.isArray(parsed) ? parsed : [parsed];
    for (const block of blocks) checkBlock(block, rel);
  });
}

function walk(dir) {
  for (const name of readdirSync(dir)) {
    const full = join(dir, name);
    const stat = statSync(full);
    if (stat.isDirectory()) walk(full);
    else if (name.endsWith('.html')) checkFile(full);
  }
}

if (!existsSync(distDir) || !statSync(distDir).isDirectory()) {
  console.error(`FAIL: dist directory not found at ${distDir} — run \`npm run build\` first`);
  process.exit(1);
}

walk(distDir);

if (errors.length > 0) {
  console.error(`validate-schema.mjs — ${errors.length} error(s):`);
  for (const e of errors) console.error(`  ${e}`);
  process.exit(1);
}

console.log(`validate-schema.mjs — OK (all JSON-LD blocks validate)`);
process.exit(0);
