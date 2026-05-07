<!-- GSD:project-start source:PROJECT.md -->
## Project

**Joe's Barbershop — AEO-Optimized Website**

The deployable website for Joe's Barbershop (Bostonia, El Cajon CA) — a 17–19 page, AEO-optimized site built in Astro, deployed to Vercel as a preview URL for Joe to review before any cutover. Replaces the current empty Square Site (`joe-104613.square.site`).

**Core Value:** Win AI-assistant citations and Google AI Mode visibility for "barbershop in East County / El Cajon" queries while reading as the authentic strip-mall heritage shop Joe runs — so Joe approves the site, customers find him through ChatGPT/Perplexity/Google, and the build itself becomes a documented case study for productizing the AEO-Hub Site offer.

### Constraints

- **Tech stack**: Astro — zero-JS-by-default aligns with AEO requirements (parsers see all content); data-driven content collections eliminate duplication across the 11 templated pages
- **Hosting**: Vercel — established precedent in `~/dtconsulting/john-olsen-mockup/`; preview URLs support pre-approval showcase model
- **Design fidelity**: Preserve the OD-5 design exactly — port existing OD-generated CSS, no Tailwind migration
- **Photo set**: Limited to 6 existing photos in `inputs/photos/` for v1 — additional photos require Joe's permission and an in-shop visit
- **AEO structural rules**: BLUF first 100 words, no hidden content, FAQ as flat text, schema on every page (per `inputs/02-aeo-constraints.md`)
- **No live deployment** before Joe approves the showcase
- **No edits to Joe's external surfaces** (GBP, Yelp, Booksy, etc.) as part of this build
- **No duplication of vault content** in this repo
<!-- GSD:project-end -->

<!-- GSD:stack-start source:STACK.md -->
## Technology Stack

Technology stack not yet documented. Will populate after codebase mapping or first phase.
<!-- GSD:stack-end -->

<!-- GSD:conventions-start source:CONVENTIONS.md -->
## Conventions

Conventions not yet established. Will populate as patterns emerge during development.
<!-- GSD:conventions-end -->

<!-- GSD:architecture-start source:ARCHITECTURE.md -->
## Architecture

Architecture not yet mapped. Follow existing patterns found in the codebase.
<!-- GSD:architecture-end -->

<!-- GSD:skills-start source:skills/ -->
## Project Skills

No project skills found. Add skills to any of: `.claude/skills/`, `.agents/skills/`, `.cursor/skills/`, `.github/skills/`, or `.codex/skills/` with a `SKILL.md` index file.
<!-- GSD:skills-end -->

<!-- GSD:workflow-start source:GSD defaults -->
## GSD Workflow Enforcement

Before using Edit, Write, or other file-changing tools, start work through a GSD command so planning artifacts and execution context stay in sync.

Use these entry points:
- `/gsd-quick` for small fixes, doc updates, and ad-hoc tasks
- `/gsd-debug` for investigation and bug fixing
- `/gsd-execute-phase` for planned phase work

Do not make direct repo edits outside a GSD workflow unless the user explicitly asks to bypass it.
<!-- GSD:workflow-end -->



<!-- GSD:profile-start -->
## Developer Profile

> Profile not yet configured. Run `/gsd-profile-user` to generate your developer profile.
> This section is managed by `generate-claude-profile` -- do not edit manually.
<!-- GSD:profile-end -->
