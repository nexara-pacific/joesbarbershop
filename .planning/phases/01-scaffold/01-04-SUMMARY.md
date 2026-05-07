---
phase: 01-scaffold
plan: 04
type: execute
status: complete
requirements:
  - SCAF-01
  - SCAF-02
  - SCAF-03
  - SCAF-04
  - SCAF-05
key-files:
  created:
    - /tmp/joes-preview-url.txt
    - /tmp/build-01-04.log
  modified:
    - site/.gitignore
    - site/.vercel/project.json
---

# Plan 01-04 Summary — Vercel Preview Deploy + Cross-Cutting Verification

Cross-cutting goal-backward gate for Phase 1. All four ROADMAP success criteria for Phase 1 are now true in production.

## What was done

### Task 1 — Pre-flight + Vercel link (human-verified)
- `gh auth status`: confirmed active account is `DarrellTang` (matches MEMORY.md sandbox guidance).
- `vercel whoami`: confirmed personal scope `darrelltang`.
- `vercel link --cwd site --yes`: linked to `darrell-tangs-projects/site` (auto-created personal team).
- `site/.gitignore`: Vercel CLI auto-added `.vercel` (no manual edit needed).
- Human checkpoint: scope confirmed correct (personal sandbox, not consulting/client team).

### Task 2 — Clean build, scripted preview deploy, curl-verify
- `cd site && npm run build` → exit 0, 2 pages built in **410ms**, `dist/sitemap-index.xml` emitted.
- `vercel --cwd site --yes` (NO `--prod`) → preview deploy successful in ~30s.
- All artifacts present: `dist/index.html`, `dist/about/index.html`, `dist/sitemap-index.xml`.
- No `missing adapter` or `integration error` strings in build log.

## Captured artifacts

**Preview URL:** `https://site-psi-liard.vercel.app`
(Saved to `/tmp/joes-preview-url.txt`. Vercel also generated the deployment-unique URL `site-7afevnbid-darrell-tangs-projects.vercel.app`, both serve the same content.)

**Vercel scope:**
- `orgId`: `team_QiwsTgAWs5PsLwbBMCUYp1z6` (team `darrell-tangs-projects` — Darrell Tang's personal team)
- `projectId`: `prj_K0vpi4oJOuSHTGJnYZhP5RQQwN8N`
- `projectName`: `site`

**`.gitignore` confirmation:**
```
$ grep '^\.vercel' site/.gitignore
.vercel
```

**Build duration:** 410ms (2 pages, static output, Vercel adapter copying to `.vercel/output/static`).

## Verification results

| Check | Result |
|-------|--------|
| `GET https://site-psi-liard.vercel.app/` | HTTP 200 |
| `/` body contains `data-phase1-stub` | ✓ (1 match) |
| `/about` body contains `data-phase1-stub` | ✓ (1 match) |
| `/sitemap-index.xml` returns valid `<sitemapindex>` XML | ✓ |
| `vercel --prod` invoked anywhere in Phase 1 | ✗ (project constraint honored) |

## Phase 1 Success Criteria — End-to-End Status

1. ✓ `npm run build` inside `site/` exits 0 with no TypeScript errors
2. ✓ Vercel CLI deploys `site/` to a preview URL that returns 200 on `/`
3. ✓ Base layout renders shared masthead, util bar, footer on every page (verified via `data-phase1-stub` on `/` and `/about`)
4. ✓ Astro Image and Sitemap integrations don't error at build (no integration-error strings in `/tmp/build-01-04.log`)

SCAF-01..05 all end-to-end verified.

## Cross-phase notes

**For Phase 2 (DESN-01..04):** Per `01-03-SUMMARY.md`, photo path is `site/src/assets/photos/` (not `site/public/photos/`) — Pitfall 5 already corrected.

**For Phase 6 (showcase):** The `site:` value in `astro.config.mjs` is the placeholder `https://joesbarbershop.vercel.app`. Phase 6 must update it to the actual production preview URL before Joe's review (otherwise `sitemap-index.xml` references the wrong host). The current preview URL is `https://site-psi-liard.vercel.app`.

## Deviations from plan

None. All checkpoint and automated steps ran as designed. Vercel CLI auto-added `.vercel` to `.gitignore` so the manual `printf '\n.vercel/\n' >> site/.gitignore` step in Task 1 was a no-op.
