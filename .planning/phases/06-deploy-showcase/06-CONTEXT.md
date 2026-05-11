# Phase 6: Deploy + Showcase - Context

**Gathered:** 2026-05-10
**Status:** Ready for planning

<domain>
## Phase Boundary

Get the v1 site onto a live, publicly-reachable Vercel preview URL with all 17 routes returning 200, deliver the link to Joe Denesowicz with structured guidance for review, and convert his sign-off into the gating event that promotes v1 from "built" to "validated." Two deploy moments: (1) noindex showcase deploy for Joe-review; (2) indexable go-live deploy after his approval.

**Not in this phase:** telemetry instrumentation beyond setting env vars (Phase 7 owns Clarity/Speed Insights/Search Console/CallRail dashboards + Day-0 baseline capture); custom domain setup (Joe hasn't picked one); cutover from the existing Square Site (out of scope per PROJECT.md until Joe approves).

</domain>

<decisions>
## Implementation Decisions

### Pre-deploy quality cleanup
- **D-01:** Fix all 4 carryforward items from Phase 5 `05-REVIEW.md` before the showcase deploy. The cleanup is its own wave preceding the deploy itself:
  - **CR-02** (`business.ts:96-104`) — `aggregateRating()` must guard against empty input (divide-by-zero → NaN). Throw an explicit error or return `null`, but never emit NaN into JSON-LD.
  - **CR-03** (`validate-schema.mjs:99`) — Reorder preflight so `fs.existsSync()` runs before `statSync`; otherwise the helpful "dist missing — run build first" error is unreachable.
  - **CR-04** (`Article.astro:30-34`) — Add `publisher.@type` (Organization), `publisher.name`, `publisher.url`, and `publisher.logo` (ImageObject with url + width + height) to satisfy Google Rich Results Article eligibility. Without this, the D-25 paste will flag both Article pages.
  - **business.geo correction** — Update `business.json` from `(32.8211, -116.9303)` to the actual shop location `(32.8184653, -116.9516888)` per the resolved `maps.app.goo.gl/fgNmMDkXDYLKJnP68` data. The 200m discrepancy currently ships in HairSalon JSON-LD's `geo` field on every page.

### Indexing posture during showcase
- **D-02:** Deploy the showcase preview with **full noindex** until Joe signs off. Two mechanisms, belt-and-suspenders:
  - `site/public/robots.txt` — set `User-agent: *` + `Disallow: /` during showcase (revert after approval).
  - `site/src/layouts/Base.astro` — emit `<meta name="robots" content="noindex,nofollow,noarchive">` on every page during showcase.
- **D-03:** Gate the noindex on a build-time mechanism (preferred: an `astro:env`/`import.meta.env` flag like `PUBLIC_SHOWCASE_MODE` defaulting to `true`), so the go-live flip after Joe's approval is a one-env-var change + redeploy, not a hand-edit of robots.txt + Base.astro at the moment Joe says yes. Reduces sign-off-to-live latency to a single deploy cycle.

### Vercel env vars
- **D-04:** Set both env vars during Phase 6 setup, not deferred to Phase 7:
  - `VERCEL_DEEP_CLONE=1` — required for `generate-mtimes.mjs` prebuild hook to read full git history. Without it, both Article pages' `dateModified` falls back to fs mtime (= build time) instead of real edit date. Set on both Preview and Production scopes.
  - `PUBLIC_CLARITY_PROJECT_ID` — Microsoft Clarity project ID, sourced from clarity.microsoft.com dashboard. Set on Production scope only. Clarity activates from the moment of showcase deploy; Phase 7 inherits an already-collecting Clarity project (affects the "Day 0 baseline" narrative — explicit user trade-off).
- **D-05:** Setting env vars is a **human-action task** in Phase 6 — the planner should produce a checkpoint task with step-by-step instructions for the Vercel dashboard route (`vercel.com/<scope>/site/settings/environment-variables`) or the CLI route (`vercel env add VERCEL_DEEP_CLONE preview production` + `vercel env add PUBLIC_CLARITY_PROJECT_ID production`).

### D-25 Google Rich Results execution
- **D-06:** D-25 (deferred from Plan 05-07) becomes a **planned checkpoint task between the noindex deploy and the Joe-share wave**. Phase flow guarantees Rich Results validation against the actual deployed HTML before Joe sees anything.
- **D-07:** Paste targets (minimum two):
  - `https://<preview-url>/` — homepage (HairSalon + AggregateRating + FAQPage)
  - `https://<preview-url>/east-county-traditional-barbershop` — niche-landing Article (Article + FAQPage)
  - Optional bonus: `https://<preview-url>/2026-east-county-barbershop-cost-guide` if the homepage Article validates without errors (second Article page sanity-check).
- **D-08:** Screenshots saved to `.planning/phases/06-deploy-showcase/rich-results/`. The `rich-results/README.md` placeholder from Plan 05-07 carries the original deferral context — Phase 6 plan should reference but not delete it; new screenshots land alongside.
- **D-09:** Acceptance: green entities for HairSalon (recognized as LocalBusiness subtype), AggregateRating, FAQPage, Article. FAQPage rich-result deprecation warnings (per Phase 5 RESEARCH Pitfall 8 — Google deprecated 2026-05-07) are **expected and acceptable**; AI engines still consume the schema. Any hard error ("Publisher logo is required", "Missing required property X") blocks the Joe-share wave until fixed-and-redeployed.

### Joe-share artifact format
- **D-10:** Deliver via **URL + a one-page cheat-sheet** (`SHARE-CHECKLIST.md`), texted to Joe (text is his primary channel per repeated prior pattern). The cheat-sheet structures his review so SHOW-01 sign-off is informed, not pro-forma.
- **D-11:** Cheat-sheet structure (Joe-voice, plain-English, no marketing jargon — see writing-style-guide-anti-ai-voice.md):
  - **Heritage feel** — does it read like your shop? Checkerboard, mahogany chairs, letter board?
  - **Letter-board pricing** — are the prices right? ($30 haircut, $50 haircut+beard, $25 kids')
  - **FAQ phrasing** — does it sound like you, or like a stranger pretending?
  - **Phone + hours** — `(619) 891-2775` correct? Tue–Sat 8 AM–6 PM correct?
  - **Photos** — any photo you don't want on the live site?
  - **Anything missing or wrong** — open-ended catch-all
- **D-12:** Sign-off capture: a screenshot/copy of Joe's text response saved into `.planning/phases/06-deploy-showcase/joe-approval/` as `<date>-joe-signoff.txt` (or `.png` for screenshot). This is the SHOW-01 artifact that proves the gating event happened.

### Phase wave structure
- **D-13:** [informational] Phase 6 organizes into 5 waves (implemented via each plan's `wave:` frontmatter field — not a single-plan decision):
  - **Wave 1 — Cleanup:** Apply D-01 fixes. Each fix is its own atomic commit; full `npm run build` + `audit.sh` gate at end of wave.
  - **Wave 2 — Pre-deploy setup + showcase deploy:** Set env vars (D-04/D-05), implement noindex flag (D-02/D-03), build, deploy via `vercel --cwd site --yes` (preview, NOT `--prod`) to the existing project, curl every route for 200 status.
  - **Wave 3 — D-25 Rich Results paste:** Human-action checkpoint per D-06/07/08/09.
  - **Wave 4 — Joe-share:** Author `SHARE-CHECKLIST.md` per D-11, text Joe, await response (human-action checkpoint for SHOW-01).
  - **Wave 5 — Go-live flip (post-approval, conditional):** Flip `PUBLIC_SHOWCASE_MODE=false`, redeploy. This wave only fires after Joe says yes; if he requests changes instead, a gap-closure subcycle runs first.

### Claude's Discretion
- Specific naming of the showcase flag env var (`PUBLIC_SHOWCASE_MODE` is a placeholder — planner picks the final name consistent with the existing `PUBLIC_CLARITY_PROJECT_ID` pattern)
- Exact wording of the SHARE-CHECKLIST.md prompts (must follow Joe-voice / anti-AI-voice guidance, planner-or-executor judgment)
- Whether the route-200 curl check produces a per-route status table artifact or is just a wave gate

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Phase goal + requirements
- `.planning/ROADMAP.md` §"Phase 6: Deploy + Showcase" — goal, success criteria, requirement IDs (DPLY-01/02/03, SHOW-01)
- `.planning/REQUIREMENTS.md` — full text of DPLY-01/02/03 and SHOW-01
- `.planning/PROJECT.md` — Core Value statement (Joe approval is the gating event for "Validated"); Constraint "No live deployment before Joe approves the showcase"

### Vercel project setup (Phase 1 artifacts — already linked)
- `.planning/phases/01-scaffold/01-04-SUMMARY.md` — Vercel project linkage (`darrell-tangs-projects/site`, orgId `team_QiwsTgAWs5PsLwbBMCUYp1z6`, projectId `prj_K0vpi4oJOuSHTGJnYZhP5RQQwN8N`). Preview URL pattern: `https://site-psi-liard.vercel.app` (stable alias) + per-deploy unique URL.

### Carryforward items requiring fixes (Wave 1)
- `.planning/phases/05-aeo-performance-meta/05-REVIEW.md` §CR-02, §CR-03, §CR-04 — exact line numbers + fix snippets for the 4 carryforward items
- `.planning/phases/05-aeo-performance-meta/05-VERIFICATION.md` — context on why CR-04 (Article publisher) was flagged as a Rich Results blocker

### Phase 5 operator handoffs Phase 6 must consume
- `.planning/phases/05-aeo-performance-meta/05-06-SUMMARY.md` — `VERCEL_DEEP_CLONE=1` operator note (D-04 driver)
- `.planning/phases/05-aeo-performance-meta/05-04-SUMMARY.md` — `PUBLIC_CLARITY_PROJECT_ID` operator note (D-04 driver)
- `.planning/phases/05-aeo-performance-meta/05-07-SUMMARY.md` — D-25 deferral context (drives D-06/07/08/09)
- `.planning/phases/05-aeo-performance-meta/rich-results/README.md` — D-25 paste instructions written by Plan 05-07

### Quality gates + scripts to extend
- `.planning/phases/03-unique-pages/scripts/audit.sh` — existing audit script with 36 checks; Wave 2 may add `check_deployed_routes <base-url>` to curl all 17 routes for 200 status
- `site/scripts/validate-schema.mjs` — receives CR-03 preflight fix in Wave 1
- `site/scripts/generate-mtimes.mjs` — receives env-var documentation update (already operational, but VERCEL_DEEP_CLONE=1 unlocks real git mtimes)

### Voice + write-style guides (for SHARE-CHECKLIST.md)
- `~/Documents/DT Vault/3-resources/darrells-voice-guide.md` — master voice reference for anything Darrell-authored
- `~/Documents/DT Vault/3-resources/writing-style-guide-anti-ai-voice.md` — banned words/phrases for the cheat-sheet
- `~/Documents/DT Vault/3-resources/writing-style-guide-inter-teammate-voice.md` — text-to-client tone (the Joe-text fits this guide)

### Existing Vercel deploy precedent
- `~/dtconsulting/john-olsen-mockup/` — PROJECT.md cites this as the Vercel preview-URL showcase precedent. Worth a quick `ls` and a glance at any deploy scripts if Phase 1's pattern needs cross-reference.

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **Vercel project link (`.vercel/project.json`)** — Already in place from Phase 1. `vercel --cwd site --yes` works without re-linking; same project, same scope (personal `darrell-tangs-projects`). Phase 1 verified the link works end-to-end (preview URL served Phase 1's 2-page shell).
- **`audit.sh` (`.planning/phases/03-unique-pages/scripts/audit.sh`)** — 36 passing checks against local `dist/`. Wave 2's route-200 check can either extend this script (add `check_deployed_routes` taking a base URL arg) or be a one-off curl loop. The script's existing test-runner shape makes extension cheap.
- **`validate-schema.mjs` + `generate-mtimes.mjs`** — both are real implementations from Plan 05-06/07. Wave 1 only adjusts CR-03's preflight ordering; no functional changes needed.
- **`Base.astro` `<Fragment slot="head">` mechanism** — Phase 5 wired this for per-page schema overlays. Wave 2's noindex meta tag rides the same head-injection pattern (could add to Base.astro frontmatter directly or via a new `<RobotsNoIndex />` component if the planner wants explicit composition).
- **`business.json` single-source-of-truth pattern** — every data update (D-01 geo correction, plus any future updates) goes through `business.json`. No page-level hardcoding.

### Established Patterns
- **Per-task atomic commits** — Plans 05-01 through 05-07 all followed this; Phase 6 plans should too (one commit per fix, one per env-var doc, etc.).
- **Worktree isolation for parallel plans** — Phase 5 used this. Phase 6's waves are mostly sequential (cleanup → deploy → D-25 → Joe-share → go-live), so worktree benefit is minor. Wave 1's 4 cleanup tasks could run in parallel (each fix touches different files: business.ts vs validate-schema.mjs vs Article.astro vs business.json), but the time saved isn't worth the orchestration overhead for ~10 min of work.
- **STATE.md / ROADMAP.md owned by orchestrator** — executor agents must NOT update them. This pattern from Phase 5 carries forward unchanged.
- **Audit gate at end of every wave** — `bash audit.sh` should exit 0/0/0 before any wave advances.

### Integration Points
- **`site/.vercel/project.json` (gitignored)** — the Vercel link. Don't commit. The `vercel --cwd site --yes` command picks it up automatically.
- **`site/public/robots.txt`** — Phase 5 created this. Wave 2 modifies it (showcase noindex → go-live allow). Conditional rendering at build time via `import.meta.env.PUBLIC_SHOWCASE_MODE` (or final flag name chosen by planner).
- **`site/src/layouts/Base.astro` `<head>`** — Wave 2 adds conditional `<meta name="robots">` here, gated on the same showcase flag.
- **`.planning/phases/05-aeo-performance-meta/rich-results/`** — D-25 screenshot directory. Plan 06 may either reuse it or create `.planning/phases/06-deploy-showcase/rich-results/`. Decision: reuse Plan 05-07's location since the README.md there already explains the deferred-to-Phase-6 context.

</code_context>

<specifics>
## Specific Ideas

- **GBP URL precedent set in Phase 5 gap closure** — Joe's real Google Maps short link `https://maps.app.goo.gl/fgNmMDkXDYLKJnP68` resolves to coordinates `(32.8184653, -116.9516888)`. Use these exact coordinates for the geo correction in D-01.
- **Pre-deploy fixes go in a single Wave 1, not threaded through deploy** — the user prefers a clean cutoff between "cleanup" and "deploy" so the deploy commit history reads as a single intentional event, not as four cleanups + a deploy.
- **Joe-text channel** — Joe's primary outreach is text message, not email. The SHARE-CHECKLIST.md cheat-sheet can ride as a separate markdown link/paste, but the primary delivery is a text containing the preview URL + the cheat-sheet content (formatted for phone reading).
- **Phase 1 verified the personal-scope Vercel project works** — Phase 6 inherits this. No need to re-verify scope or re-link.

</specifics>

<deferred>
## Deferred Ideas

- **Custom domain setup (e.g., `joesbarbershop.com` or similar)** — Joe hasn't picked a domain; current Square Site is `joe-104613.square.site`. Custom domain is a Phase 7+ decision after he approves the showcase and decides whether to migrate.
- **Cutover from Square Site** — Out of scope for v1 per PROJECT.md. Cutover happens only after Joe approves, picks a domain, and decides on a switchover plan. Not Phase 6.
- **Production-mode Vercel deploy semantics (`--prod` flag)** — While we technically have a "go-live flip" in Wave 5, the Vercel `--prod` promotion would only matter once a custom domain is attached. For v1 showcase + go-live on the vercel.app URL, preview deploys with the showcase flag toggled is sufficient.
- **Lighthouse against deployed URL (not just local dist)** — Phase 5's audit.sh runs Lighthouse against the local build. Deployed-URL Lighthouse is a stronger signal (real network, real Vercel edge) but adds CLI dependencies and runtime. Defer to Phase 7 measurement work where Vercel Speed Insights provides this continuously.
- **AI crawler-specific robots rules** — The middle-ground option (allow Google, block PerplexityBot/ChatGPT-User/GPTBot/ClaudeBot/Google-Extended) was considered and rejected in favor of full noindex during showcase. Worth revisiting if the indexing strategy evolves post-launch, but explicitly not Phase 6's concern.
- **Microsoft Clarity dashboard setup** — Phase 6 sets the env var; Phase 7 owns the actual dashboard, baseline capture, and Day-0 measurement narrative. The Clarity project must exist in clarity.microsoft.com before Phase 6 deploy (since the env var needs a real ID), but everything downstream of "the env var is set" is Phase 7.

</deferred>

---

*Phase: 06-deploy-showcase*
*Context gathered: 2026-05-10*
