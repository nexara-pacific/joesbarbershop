#!/usr/bin/env node
// site/scripts/validate-schema.mjs
//
// Purpose (D-23.1): Parse dist/**/*.html, extract every
// <script type="application/ld+json"> block, JSON.parse each, validate
// required fields per Schema.org type, and assert no rendered block
// contains the substring '</script>' (Pitfall 1 from RESEARCH).
//
// STUB: Plan 07 (Wave 6) replaces this body with the real validator using
// cheerio + a hand-rolled REQUIRED-fields map. For now, exit 0 so audit.sh
// can wire the check_jsonld function without breaking earlier waves.

console.log('validate-schema.mjs — STUB (Plan 07 / Wave 6 fills in real validator)');
process.exit(0);
