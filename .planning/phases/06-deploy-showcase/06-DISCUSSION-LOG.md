# Phase 6: Deploy + Showcase - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-10
**Phase:** 06-deploy-showcase
**Areas discussed:** Pre-deploy quality cleanup, Indexing posture during showcase, D-25 Rich Results execution timing, Joe-share artifact format, Vercel env var setup

---

## Pre-deploy quality cleanup

| Option | Description | Selected |
|--------|-------------|----------|
| CR-04 + business.geo only | Fix what Joe will see (Article Rich Results) + AEO accuracy (real shop coords). ~6 min. | |
| All 4 carryforward items | CR-02 NaN guard + CR-03 statSync reorder + CR-04 Article publisher + geo correction. ~11 min. | ✓ |
| CR-04 only | Just fix what Google Rich Results will flag. ~5 min. | |
| Defer everything, deploy as-is | Carry CR-02/03/04 + geo into follow-up. | |

**User's choice:** All 4 carryforward items
**Notes:** Cleanest baseline going into Phase 6. ~11 min total fix time. Each fix becomes an atomic commit in Wave 1.

---

## Indexing posture during showcase

| Option | Description | Selected |
|--------|-------------|----------|
| noindex until Joe signs off | robots.txt Disallow / + meta robots noindex; flip after approval; cleanest preview semantics | ✓ |
| Fully indexable from day one | Faster AEO signal but anything broken gets cached pre-fix | |
| Index Google, block AI crawlers | Hybrid: robots allows Google + Bing, blocks PerplexityBot/ChatGPT-User/GPTBot/ClaudeBot/Google-Extended | |

**User's choice:** noindex until Joe signs off
**Notes:** Two mechanisms (robots.txt + meta tag) for belt-and-suspenders. Implementation gated on a build-time env var so go-live flip is one env var + redeploy.

---

## D-25 Rich Results execution timing

| Option | Description | Selected |
|--------|-------------|----------|
| Plan task between deploy and Joe-share | Checkpoint task. Paste deployed HTML into Rich Results, capture screenshots, then Joe-share. | ✓ |
| Ad-hoc post-deploy, not in plan | You eyeball Rich Results separately from the plan flow. | |
| Skip D-25 — trust local validation | validate-schema.mjs + audit.sh already pass; skip Google's-own-parser cross-check. | |

**User's choice:** Plan task between deploy and Joe-share
**Notes:** Plan 05-07 deferred D-25 once already. Embedding it in Phase 6's plan flow ensures it actually runs against the deployed HTML before Joe sees anything. ~5 min human action mid-phase.

---

## Joe-share artifact format

| Option | Description | Selected |
|--------|-------------|----------|
| In-person walkthrough | Visit shop, walk Joe through page-by-page, capture verbatim reactions. Strongest sign-off, most time. | |
| URL + one-page cheat-sheet | Text URL + SHARE-CHECKLIST.md with structured review prompts. Async, low friction, informed sign-off. | ✓ |
| URL + Loom walkthrough | 2-3 min recorded walkthrough + URL via text. Hybrid async. | |
| URL-only text | Single text + 'let me know what you think.' Risk: pro-forma approval. | |

**User's choice:** URL + one-page cheat-sheet
**Notes:** Joe's primary channel is text. Cheat-sheet structures his review around: heritage feel · letter-board pricing · FAQ phrasing · phone/hours · photos · anything missing/wrong. Authored in Joe-voice per writing-style-guide-anti-ai-voice.md.

---

## Vercel env var setup

| Option | Description | Selected |
|--------|-------------|----------|
| VERCEL_DEEP_CLONE only, defer Clarity to Phase 7 | Set deep-clone now; Phase 7 handles all telemetry env vars together. | |
| Set both VERCEL_DEEP_CLONE + Clarity now | Both env vars in Phase 6. Clarity starts collecting from showcase day. Affects Phase 7 'Day 0 baseline' narrative. | ✓ |
| Defer both env vars to Phase 7 | Deploy without either; Article dateModified falls back to build time. | |

**User's choice:** Set both VERCEL_DEEP_CLONE + Clarity now
**Notes:** Trade-off acknowledged — Clarity starts collecting at showcase deploy time, so the Phase 7 'Day 0 baseline' moment is actually showcase-time, not phase-7-time. User explicitly accepted this. Microsoft Clarity project must be created in clarity.microsoft.com before Phase 6 deploy.

---

## Claude's Discretion

- Specific naming of the showcase noindex env var (`PUBLIC_SHOWCASE_MODE` placeholder — planner picks final name consistent with `PUBLIC_CLARITY_PROJECT_ID` style)
- Exact wording of the SHARE-CHECKLIST.md prompts (must follow voice guides; planner/executor judgment)
- Whether the route-200 curl gate produces a per-route status table artifact or is just a wave gate
- Whether to extend audit.sh with `check_deployed_routes <base-url>` or use a one-off curl loop for the route-200 check

---

## Deferred Ideas

- Custom domain setup (`joesbarbershop.com` or similar) — Joe hasn't picked a domain
- Cutover from existing Square Site (`joe-104613.square.site`) — happens only after Joe approves + domain decision
- Production-mode `vercel --prod` promotion — only matters once a custom domain attaches
- Lighthouse against deployed URL (vs local dist) — Phase 7 covers via Vercel Speed Insights
- AI crawler-specific robots rules — Considered as middle-ground option, rejected in favor of full noindex
- Microsoft Clarity dashboard setup + Day-0 baseline capture — Phase 6 only sets the env var; Phase 7 owns dashboard config and measurement narrative
