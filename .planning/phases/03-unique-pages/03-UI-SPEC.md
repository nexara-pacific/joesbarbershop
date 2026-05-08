---
phase: 3
slug: unique-pages
status: approved
shadcn_initialized: false
preset: none
created: 2026-05-07
reviewed_at: 2026-05-07
---

# Phase 3 — UI Design Contract

> Visual and interaction contract for the 6 hand-crafted unique pages (`/`, `/east-county-traditional-barbershop`, `/2026-east-county-barbershop-cost-guide`, `/about`, `/reviews`, `/faq`). Phase 3 REUSES the OD-5 design system locked in Phase 2; this spec covers only the per-page composition rules and the few new layouts (BLUF capsule, article header, listicle entry card, review card, portrait placeholder) that the existing 12 components don't dictate.

---

## Design System

| Property | Value |
|----------|-------|
| Tool | none (manual port; no shadcn) |
| Preset | not applicable |
| Component library | OD-5 hand-port — 12 Astro components in `site/src/components/` (Phase 2 D-03) |
| Icon library | none — icon glyphs are inline Unicode (`●`, `★`) consistent with OD-5 mockup |
| Display font | IM Fell English (Victorian serif) — `--font-display` |
| Body font | Newsreader — `--font-body` |
| Board / label font | Oswald (uppercase tracked) — `--font-board` |
| Mono | JetBrains Mono — `--font-mono` |

Source: tokens locked in `site/src/styles/tokens.css`; components locked in Phase 2; mockup `mockups/home-v5/index.html` (md5 `75e4749bbe4c9e2d4993bfa6744d3cdc`) is pixel-parity target for `/`.

Phase 3 does NOT introduce new tokens, fonts, palette colors, or shared atoms. New per-page CSS lives in scoped `<style>` blocks per page consuming the existing tokens (Phase 2 D-06).

---

## Spacing Scale

OD-5 uses a 4px-grounded scale that's already in tokens / utilities / components. Phase 3 pages MUST consume these values, not invent new ones.

| Token | Value | Usage |
|-------|-------|-------|
| xs | 4px | Inline gaps between adjacent meta values |
| sm | 8–10px | Compact element gaps (button gap, inline icon gap) |
| md | 14–16px | Default element spacing (paragraph margin, list gap, NAP row gap) |
| lg | 22–28px | Section-head margin-bottom, hero meta gap, primary CTA cluster gap |
| xl | 32px | Major content blocks gap (FAQ list gap, prose section gap) |
| 2xl | 56–64px | Inter-section padding shoulder (tight sections) |
| 3xl | clamp(56px, 7vw, 96px) | Standard `<section>` vertical padding (tokens.css `section`) |
| 4xl | clamp(64px, 8vw, 112px) | ClosingCTA vertical padding |

Container width: `--maxw: 1240px`, gutter `clamp(20px, 4vw, 56px)` (`.wrap`).

Breakpoints (locked from OD-5; ROADMAP success criterion #1):
- Desktop: ≥ 981px
- Tablet: ≤ 980px (multi-column grids collapse to 1fr; nav.primary hides)
- Mobile: ≤ 600px (price-board font-size reduces, footer collapses to 1fr, util-bar phone reflows)

Exceptions:
- Section vertical padding uses `clamp()` rather than fixed token — preserves OD-5 fluid scaling. Do not replace with fixed values.
- CTA button padding `12px 20px` and footer link gap `10px` are sub-token values established in OD-5. Preserve verbatim.

---

## Typography

### Token Reference (from OD-5 — already in components)

| Role | Size | Weight | Line Height | Family |
|------|------|--------|-------------|--------|
| Body | 17px (root) | 400 | 1.55 | Newsreader |
| BLUF / lead paragraph | 18px | 400 | 1.55–1.6 | Newsreader |
| Body prose (heritage / visit blurb) | 17–17.5px | 400 | 1.6–1.65 | Newsreader |
| Footnote / quote | 15.5px | 400 italic | 1.5 | Newsreader |
| Meta / sub | 13.5–14.5px | 400 | 1.5 | Newsreader |
| Eyebrow / label | 10.5–12px | 600 uppercase, 0.16–0.22em tracking | 1 | Oswald |
| Display H1 (hero) | clamp(48px, 6.6vw, 96px) | 600 | 0.96 | IM Fell English |
| Display H1 (article — non-hero pages) | clamp(40px, 5vw, 68px) | 600 | 1.02 | IM Fell English |
| Section H2 | clamp(34px, 4vw, 52px) | 600 | 1.05 | IM Fell English |
| Heritage / Visit / Closing H2 (oversized) | clamp(38–40px, 4.4–5vw, 60–68px) | 600 | 1.02 | IM Fell English |
| Sub-section H3 (visit-card, faq-q, price-aside) | clamp(22px, 2.2vw, 38px) | 600 | 1.05–1.2 | IM Fell English |

### Per-Page Hierarchy Rules (Phase 3 specifies)

Homepage (`/`) — pixel-parity port. Hierarchy is dictated by mockup; do not deviate.

For the 5 non-homepage pages:

| Page | H1 size token | H2 size token | H3 size token | Notes |
|------|---------------|---------------|---------------|-------|
| `/east-county-traditional-barbershop` | `clamp(40px, 5vw, 68px)` | `clamp(34px, 4vw, 52px)` | `clamp(22px, 2.2vw, 28px)` | Article-shape; H1 in article-header block; H2 starts the prose section after BLUF; H3 used in FAQ block (matches faq-q H3 token). |
| `/2026-east-county-barbershop-cost-guide` | `clamp(40px, 5vw, 68px)` | `clamp(34px, 4vw, 52px)` | `clamp(22px, 2.2vw, 28px)` | Same as niche-landing. H3 names each listicle entry (competitor name) and each FAQ question. |
| `/about` | `clamp(40px, 5vw, 68px)` | `clamp(34px, 4vw, 52px)` | `clamp(28px, 2.6vw, 38px)` | H2 starts each barber section ("Joe", "Alex"); H3 oversized to match Visit-card aesthetic since each barber gets a card-like layout. |
| `/reviews` | `clamp(40px, 5vw, 68px)` | `clamp(34px, 4vw, 52px)` | `clamp(20px, 2vw, 24px)` | H3 only inside review cards (reviewer name); smaller than other H3s because cards are dense. |
| `/faq` | `clamp(40px, 5vw, 68px)` | `clamp(28px, 3vw, 36px)` | `clamp(22px, 2.2vw, 28px)` | H2 used for topic-group headings (Hours, Payment, Walk-ins, Kids, Parking) when 10+ Q&As are grouped; reduced H2 size keeps grouping subtle vs question-level H3 prominence. H3 = question (matches faq-q). |

### Weight Discipline

Two weights only: **400 regular** (body) + **600 semibold** (display H1/H2/H3, eyebrows, board labels, button text, NAP `<dt>`). No 500, no 700, no 800. (OD-5 mockup includes Playfair-800 / DM-400 swap variants from the live-tweaks panel — those are STRIPPED in Phase 2 D-10. IM Fell English at 600 is canonical from this commit forward.)

### Body Line Length

- BLUF capsule: max-width `56ch` (matches `.hero-bluf`).
- Prose paragraphs (article body): max-width `66ch` to match comfortable AEO long-form reading; existing `.heritage-copy p` uses `60ch` and `.faq-q p` uses `70ch` — use the higher value (`70ch`) as the upper bound for new prose in scoped styles.
- Listicle entry / review-card prose: no max-width (cards constrain naturally).
- FAQ answer paragraph: max-width `70ch` (matches `.faq-q p`).

---

## Color

OD-5 60/30/10 split — already locked. Phase 3 introduces NO new color values.

| Role | Token | Value | Usage |
|------|-------|-------|-------|
| Dominant (60%) | `--bg` | `oklch(95% 0.022 80)` | Page background, hero copy bg, visit / closing-cta sections |
| Secondary (30%) | `--surface` | `oklch(99% 0.008 80)` | Fact strip, heritage, FAQ, visit-card, listicle entry cards, review cards |
| Foreground / dark inversion | `--fg` | `oklch(15% 0.02 60)` | Body text, util-bar bg, footer bg, primary `.btn` bg |
| Muted | `--muted` | `oklch(45% 0.025 50)` | Eyebrows, meta sub-labels, photo credit, footnotes |
| Border / hairline | `--border` / `--hairline` | `oklch(86% 0.025 80)` / `oklch(80% 0.030 75)` | Card borders, fact-strip dividers, section borders |
| Accent (10%) | `--accent` | `oklch(56% 0.17 28)` (warm rust-red) | RESERVED-FOR list below |
| Accent-2 | `--accent-2` | `oklch(36% 0.10 260)` | Reserved — not used in Phase 3 (mockup carries the variable but no live usage) |
| Gold | `--gold` | `oklch(68% 0.10 80)` | Section-mark center dot only |
| Board | `--board-bg` / `--board-fg` | `oklch(13% 0.005 60)` / `oklch(96% 0.005 80)` | Price-board only (homepage exclusive) |

### Accent Reserved For (LOCKED — do not extend in Phase 3)

The `--accent` rust-red is reserved for these specific elements only:
1. `.kicker-rule::before` (the 28×2px rule preceding eyebrow text in section heads)
2. `.btn:hover` background (primary CTA hover state)
3. `nav.primary a:hover` border-bottom (masthead nav hover)
4. `.faq-q .num` (FAQ number "01" / "02") — also used for cost guide listicle entry numbers and review-card star ratings
5. `.heritage-stats .stat .num` (oversized stat numbers like "4.9★")
6. `.hero-copy h1 .accent-word` (single accent word in H1, e.g. "shave.")
7. `.price-aside .quote` left border (3px stripe on pull-quote)
8. `.util-bar .util-dot` separator dots
9. `.fact .value .star` (rating star in fact-strip)
10. **Phase 3 additions:**
    - Star rating glyphs (★) in review cards on `/reviews` (color: `--accent`)
    - Listicle entry-card numbering "01 / 02 / 03" on `/2026-east-county-barbershop-cost-guide` (color: `--accent`, matches `.faq-q .num` aesthetic)
    - "Joe's Barbershop" entry highlight on the cost guide — accent left-border 3px stripe (matches `.price-aside .quote`)
    - BLUF capsule left-border accent stripe (3px, matches the pull-quote pattern) — see BLUF treatment below

### NEVER use accent for

- Inline body text (links use `color: inherit` per `tokens.css` `a` rule)
- Plain hyperlinks in body prose — see Cross-Link treatment
- Generic interactive hover states beyond the listed rules
- Decorative borders without semantic meaning

### Inline Link Color (Phase 3 specifies)

OD-5 base `a { color: inherit }` is body-color. For Phase 3 prose pages with inline cross-links (cost guide, niche-landing, FAQ master), inline links MUST be visually distinct from body without burning accent budget. Rule:

```css
.prose a { color: var(--fg); text-decoration: underline; text-decoration-color: var(--accent); text-decoration-thickness: 2px; text-underline-offset: 3px; }
.prose a:hover { color: var(--accent); }
```

Rationale: matches the `nav.primary a:hover` border-accent pattern (accent on hover, not at rest); distinguishes links from body without the "every-link-is-accent-red" failure mode; honors AEO requirement that every cross-link be obvious in DOM and visual (`AEO-07`-adjacent — not text-as-image).

### Destructive

None. Phase 3 has zero destructive actions (no delete, no signup, no form submit). No destructive token needed.

---

## Component Inventory

Reuse rules per Phase 3 D-17. This table is the contract.

| Component | Homepage | Niche-landing | Cost guide | About | Reviews | FAQ master |
|-----------|:--------:|:-------------:|:----------:|:-----:|:-------:|:----------:|
| `UtilBar` (chrome) | yes | yes | yes | yes | yes | yes |
| `Masthead` (chrome) | yes | yes | yes | yes | yes | yes |
| `Footer` (chrome) | yes | yes | yes | yes | yes | yes |
| `CheckDivider` | yes (5×) | optional | optional | optional | optional | optional |
| `SectionMark` | yes (in section-heads) | yes | yes | yes | yes | yes |
| `Hero` | YES | NO | NO | NO | NO | NO |
| `FactStrip` | YES | NO | NO | NO | NO | NO |
| `PriceBoard` | YES | NO | NO | NO | NO | NO |
| `Heritage` | YES | NO | NO | NO | NO | NO |
| `Visit` | YES | NO | NO | YES | NO | NO |
| `FAQ` | YES (5–6 Q&As) | YES (6 Q&As) | YES (3–4 Q&As) | NO | NO | YES (10+ Q&As, scaled) |
| `ClosingCTA` | yes | yes | yes | yes | yes | yes |

Page-bespoke layouts (defined in scoped `<style>` per page, NOT new shared components):
- BLUF capsule (5 non-homepage pages — homepage uses Hero's `.hero-bluf` instead)
- Article header (niche-landing, cost guide)
- AreaServed list (niche-landing only)
- Listicle entry card (cost guide only)
- Review card (reviews only)
- Portrait placeholder (about only)
- See-also block (cost guide; optional pattern repeatable)
- Topic-group heading (FAQ master only — when 10+ Q&As get grouped)

---

## BLUF Capsule (NEW — defined here)

The BLUF (first ~100 words answer capsule) is the load-bearing AEO element on the 5 non-homepage pages. Visual contract:

| Property | Value |
|----------|-------|
| Container | `<section class="bluf">` immediately following article-header (no `CheckDivider` between) |
| Background | `var(--surface)` |
| Border | `1px solid var(--border)` top + bottom; no left/right |
| Accent | 3px left stripe `var(--accent)` extending full container height (matches `.price-aside .quote` pattern) |
| Padding | `28px 32px 28px 28px` desktop; `24px 20px 24px 20px` ≤600px |
| Max-width (inner) | `--maxw` via `.wrap`; BLUF text itself max-width `66ch` |
| Typography | Body 18px / 1.6 / weight 400 (matches `.hero-bluf` size); first sentence may be wrapped in `<strong>` for AI-citation salience |
| Spacing | `padding-block: clamp(40px, 5vw, 64px)` (uses existing `.tight` section pattern) |

Markup pattern:

```astro
<section class="bluf" aria-label="Answer capsule">
  <div class="wrap">
    <p class="bluf-lead"><strong>Joe's Barbershop is a traditional…</strong> [rest of 100-word answer]</p>
  </div>
</section>
```

Rationale: distinct from body prose so a parser sees "this is the answer." Uses an existing OD-5 idiom (left accent stripe from `.price-aside .quote`) so it doesn't introduce a foreign visual. Satisfies AEO-05 (BLUF first 100 words) and the 44.2% rule (front-load citation surface).

---

## Article Header (NEW — niche-landing + cost guide)

| Property | Value |
|----------|-------|
| Container | `<header class="article-head">` inside `<main>`, before BLUF |
| Padding | `clamp(56px, 7vw, 96px) 0 clamp(32px, 4vw, 48px)` (top matches standard section, bottom is tighter to lead into BLUF) |
| Background | `var(--bg)` |
| Eyebrow | Existing `.eyebrow.kicker-rule` — text per page (e.g. "Niche-query landing" / "2026 cost guide"); margin-bottom 22px |
| H1 | `font-family: var(--font-display); font-size: clamp(40px, 5vw, 68px); font-weight: 600; line-height: 1.02; letter-spacing: -0.008em; margin: 0 0 18px;` (matches `.closing-heading` size token) |
| Date stamp | Below H1, right under or inline. `font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11.5px; font-weight: 600; color: var(--muted);` Format: `UPDATED MAY 2026` |
| Subtitle (optional) | If present: 18px / 1.55 / weight 400 / `color: var(--muted)`; max-width 60ch; margin-top 14px |
| Max-width | Article header content max-width `820px` (narrower than `--maxw` so the H1 doesn't run too wide and prose stays readable from headline through BLUF without re-anchoring the eye) |

No hero photo on these pages (D-21 explicit). The page leads with H1 → date → optional subtitle → BLUF.

---

## AreaServed List (NEW — niche-landing only)

5 neighborhood links rendered as a compact list — visible in DOM (AEO requirement: areaServed list MUST be in DOM, not buried in schema only).

| Property | Value |
|----------|-------|
| Container | `<section class="area-served">` after the prose section, before FAQ |
| Background | `var(--surface)` |
| Padding | `clamp(40px, 5vw, 64px) 0` (`.tight` pattern) |
| Heading | H2 `clamp(28px, 3vw, 36px)` weight 600 IM Fell — text "Where Joe serves East County" or similar |
| Layout | `<ul>` flex row wrap on desktop; `display: flex; flex-wrap: wrap; gap: 12px 18px;` |
| Item | `<li><a>` styled as outline pill: `padding: 10px 18px; border: 1px solid var(--border); background: var(--bg); font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 12px; font-weight: 600; text-decoration: none; color: var(--fg);` |
| Hover | `border-color: var(--accent); color: var(--accent);` |
| ≤600px | Stack vertically: `flex-direction: column; gap: 8px;` items go full-width with same padding |
| Link targets | `/bostonia-barber`, `/el-cajon-barber`, `/santee-barber`, `/lakeside-barber`, `/la-mesa-barber` (canonical Phase 4 slugs per D-16) |

Each pill renders the neighborhood plain-text name (e.g. "Bostonia", "El Cajon"). Link text is the full neighborhood name — NOT clipped, NOT image-replaced.

---

## Cost Guide Entry Card (NEW — cost guide only)

4–6 competitor entries (including Joe's Barbershop as one of them, per D-13). Layout vertical-stack on every breakpoint — NO grid columns. Reasoning: AEO comparative listicles are most-cited when each entry is a self-contained answer capsule that can be extracted in isolation; grid columns dilute that.

| Property | Value |
|----------|-------|
| Container | `<article class="entry">` per competitor; `<ol class="entries">` parent |
| Spacing between entries | `gap: 48px` desktop; `gap: 36px` ≤980px; `gap: 28px` ≤600px |
| Entry padding | `32px` desktop; `24px` ≤980px; `20px` ≤600px |
| Background | `var(--surface)` |
| Border | `1px solid var(--border)` |
| Joe's entry override | Add 3px left-border `var(--accent)` to indicate it's the "host" entry |
| Number | `<span class="entry-num">01</span>` — IM Fell, 28px, weight 600, color `var(--accent)` (matches `.faq-q .num`) |
| Name (H3) | `font-family: var(--font-display); font-size: clamp(22px, 2.2vw, 28px); font-weight: 600; line-height: 1.2; margin: 0 0 14px;` |
| Meta block | NAP grid using same `.nap dl` pattern as `Visit.astro` — `grid-template-columns: 110px 1fr; gap: 10px 16px;` font-size 14.5–15px |
| Meta `<dt>` labels | Same Oswald uppercase pattern as Visit: `font-size: 11px; letter-spacing: 0.16em; color: var(--muted);` Labels: ADDRESS / PHONE / HOURS / PRICE RANGE / RATING |
| Quote | If present, 1 representative review quote, italic, `font-size: 15.5px; color: var(--muted); border-left: 2px solid var(--border); padding-left: 14px; margin-top: 16px;` |
| Differentiator | Final paragraph 16px regular body, no special styling — answers "what makes this shop different" in 1–2 sentences |

Entry markup pattern:

```astro
<article class="entry">
  <header class="entry-head">
    <span class="entry-num" aria-hidden="true">01</span>
    <h3>Joe's Barbershop</h3>
  </header>
  <div class="nap">
    <dl>
      <dt>Address</dt><dd>723 E Bradley Ave, Suite C, El Cajon CA 92021</dd>
      <dt>Phone</dt><dd>(619) 891-2775</dd>
      <dt>Hours</dt><dd>Tue–Sat 10am–7:30pm</dd>
      <dt>Price range</dt><dd>$15–$50 (haircut $30, shave $30, beard line-up $20)</dd>
      <dt>Rating</dt><dd>4.9★ · 91 Google reviews</dd>
    </dl>
  </div>
  <blockquote class="entry-quote">"Best $30 haircut in East County. Every time."</blockquote>
  <p class="entry-diff">No-frills traditional barbershop. Walk-ins only, cash only, ATM on site. Family-friendly. The $30 base price is the East County value anchor.</p>
</article>
```

### See-Also Block (cost guide bottom)

| Property | Value |
|----------|-------|
| Container | `<aside class="see-also">` placed AFTER FAQ (if cost guide has FAQ) and BEFORE ClosingCTA |
| Background | `var(--bg)` |
| Padding | `clamp(40px, 5vw, 64px) 0` |
| Heading | H2 `clamp(28px, 3vw, 36px)` IM Fell weight 600 — text "See also: services & neighborhoods" |
| Layout | Two columns desktop (`grid-template-columns: 1fr 1fr; gap: 48px;`); 1 column ≤980px |
| Lists | Plain `<ul>` no-bullet, gap 10px, font-size 16px; link styling = inline-link rule |
| Column 1 contents | All 6 service slugs as anchor text (Fades, Classic Cut, Kids Cuts, Beard Trim, Line-Up, Hot-Towel Shave) |
| Column 2 contents | All 5 neighborhood slugs (Bostonia, El Cajon, Santee, Lakeside, La Mesa) |

This block is the belt-and-suspenders pattern (D-15) — guarantees ROADMAP success criterion #3 (all 11 cross-links present).

---

## Review Card (NEW — reviews only)

6–8 cards rendered in a grid. Each card is a self-contained `Review` schema candidate (Phase 5 wraps).

| Property | Value |
|----------|-------|
| Grid container | `<div class="review-grid">` |
| Columns | Desktop: `grid-template-columns: repeat(2, 1fr); gap: 28px;` |
| 980px | `grid-template-columns: repeat(2, 1fr); gap: 22px;` (kept at 2 cols — content density still acceptable) |
| 600px | `grid-template-columns: 1fr; gap: 20px;` |
| Card | `<article class="review-card">` with `padding: 28px 28px 24px;` (24/20/16 at ≤600); `background: var(--surface); border: 1px solid var(--border);` |
| Star row | Top of card. 5 stars rendered as Unicode `★` glyphs at `font-size: 18px; color: var(--accent); letter-spacing: 2px; margin-bottom: 14px;` Unfilled stars (if any — but quotes pulled are 5★ per D-09) use `color: var(--border)` |
| Quote | Body of card. `font-family: var(--font-body); font-size: 17px; line-height: 1.55; color: var(--fg); margin: 0 0 18px;` Quote uses curly quotes (`"…"`) inline — NO `<blockquote>` element to keep schema-clean |
| Reviewer name (H3) | `font-family: var(--font-display); font-size: 20px; font-weight: 600; line-height: 1.2; margin: 0 0 4px;` Format: "Sarah M." |
| Source + date | Single line below name. `font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 11px; font-weight: 600; color: var(--muted);` Format: `GOOGLE · APR 2026` or `YELP · MAR 2026` |
| Source label color | Plain `var(--muted)` — DO NOT colorize per platform (no Google-blue / Yelp-red brand colors). Text-only stays AEO-clean |

Card markup pattern:

```astro
<article class="review-card">
  <div class="stars" aria-label="5 out of 5 stars">★★★★★</div>
  <p class="review-quote">"Best $30 haircut in East County. Every time."</p>
  <h3 class="reviewer">Sarah M.</h3>
  <p class="review-source">Google · Apr 2026</p>
</article>
```

Mix Google + Yelp 50/50 across the 6–8 cards. Order: highest-signal quotes first (`Sarah M.` 5★ "Best haircut" beats `John D.` 5★ "good"). Skill output (D-08/D-09) ranks; executor commits.

### Reviews Page Header

Above the grid: H1 article-header pattern (per Article Header section above) → BLUF capsule (`Joe's Barbershop is rated 4.9★ across 124 Google + Yelp reviews…`) → review grid → ClosingCTA. No FAQ component on reviews page.

---

## About Page Portrait Placeholder (NEW — about only)

Until Joe + Alex headshots arrive (D-07), placeholders are CSS-only — NO bitmap, NO stock photo, NO SVG fetched from external. Inline CSS gradient + initials.

| Property | Value |
|----------|-------|
| Container | `<div class="portrait-placeholder" data-pending-photo="joe">` (or `"alex"`) |
| Aspect ratio | `4 / 5` (matches `.heritage-photo img` aspect) |
| Width | 100% of column slot (column slot is half-width in 2-col layout, full at ≤980px) |
| Background | Solid `var(--fg)` — deep dark; NOT a gradient, NOT a checkerboard motif |
| Border | `1px solid var(--border)` |
| Initials | Centered, IM Fell English, `clamp(60px, 8vw, 96px)`, weight 600, color `var(--bg)` (cream on dark — high contrast). Format: "JD" for Joe Denesowicz, "A" for Alex |
| Tag | Below initials, Oswald uppercase `0.18em` tracking, `font-size: 11px`, weight 600, color `oklch(72% 0.04 80)` (footer-link color), text "PORTRAIT TO COME" |
| `data-pending-photo` attr | Required — used by post-Phase-3 photo-swap pass |

CSS pattern:

```css
.portrait-placeholder {
  aspect-ratio: 4 / 5;
  background: var(--fg);
  border: 1px solid var(--border);
  display: flex; flex-direction: column;
  align-items: center; justify-content: center;
  gap: 18px;
}
.portrait-placeholder .initials {
  font-family: var(--font-display);
  font-size: clamp(60px, 8vw, 96px);
  font-weight: 600;
  color: var(--bg);
  line-height: 1;
}
.portrait-placeholder .pending {
  font-family: var(--font-board);
  text-transform: uppercase;
  letter-spacing: 0.18em;
  font-size: 11px;
  font-weight: 600;
  color: oklch(72% 0.04 80);
}
```

When real headshots ship, the swap is mechanical: replace the `<div class="portrait-placeholder">` with `<Image src={joePhoto} … />` and remove the `data-pending-photo` marker. Layout, aspect ratio, and column-slot width stay identical.

### About Page Layout

| Section | Composition |
|---------|-------------|
| Article header | H1 "About Joe's Barbershop" + date stamp |
| BLUF capsule | "Joe's Barbershop is owned by Joe Denesowicz, who opened the shop in 2020 in Bostonia, El Cajon. Lead barber Alex…" (~100 words) |
| Joe section | 2-col grid: portrait placeholder (left) + bio prose (right). Desktop `grid-template-columns: 1fr 1.4fr; gap: clamp(28px, 4vw, 56px);` Stack at ≤980px |
| Alex section | Same 2-col grid, mirrored: bio (left) + portrait placeholder (right). Stack at ≤980px |
| Visit component | Existing `Visit.astro` (already imports storefront photo + NAP) |
| ClosingCTA | Existing component |

---

## FAQ Master Page Layout (NEW scaling — `/faq` only)

The existing `FAQ.astro` component renders 5 hard-coded Q&As. The master FAQ scales to 10+ Q&As. Approach: **single column, flat list, optional topic-group H2 headings every 3–4 questions.**

| Property | Value |
|----------|-------|
| Layout | Single column, max-width `980px` (matches `.faq-list` max-width) |
| Topic groups | Group 10+ Q&As under H2 headings: Hours & Days, Walk-ins & Booking, Payment & Cash, Kids & Family, Parking & Location |
| Topic H2 styling | `font-family: var(--font-display); font-size: clamp(28px, 3vw, 36px); font-weight: 600; margin: 56px 0 24px;` First H2 has `margin-top: 0` |
| Question H3 + answer | Reuse `.faq-q` pattern from existing FAQ component verbatim — same numbered grid, same H3 size, same answer styling |
| Question numbering | Continuous "01" through "10+" across all topic groups (NOT reset per group) |
| Question gap | `gap: 32px` between questions (matches existing `.faq-list`) |

Decision: Phase 3 does NOT modify `FAQ.astro` to accept dynamic items. The master FAQ page (`/faq`) writes its own scoped markup repeating the `.faq-q` pattern with topic-group H2 headings inserted between question clusters. (This avoids forcing a component-API change for a single use case.)

Below the FAQ stack: ClosingCTA. No See-Also block on FAQ master.

---

## Cross-Link Treatment

Two patterns:

### Inline links (in body prose)

Per the Color section above:

```css
.prose a, article p a {
  color: var(--fg);
  text-decoration: underline;
  text-decoration-color: var(--accent);
  text-decoration-thickness: 2px;
  text-underline-offset: 3px;
}
.prose a:hover, article p a:hover { color: var(--accent); }
```

### Pill / list links (areaServed, see-also)

Defined in their respective sections above. Outline-pill on areaServed; plain underlined-text in see-also lists.

### Masthead nav links

Already defined in `Masthead.astro` — accent border-bottom on hover. Phase 3 does not modify.

### Footer links

Already defined in `Footer.astro` — accent border-bottom on hover. Phase 3 does not modify.

---

## Section Spacing Rhythm (prose-heavy pages)

For the niche-landing and cost guide where existing components don't dictate the rhythm, follow this stack:

```
Article header → BLUF capsule → Prose section → AreaServed (niche only) / Listicle (cost only)
→ FAQ → See-Also (cost only) → ClosingCTA
```

Vertical padding rule:

| Block | Top padding | Bottom padding |
|-------|-------------|----------------|
| Article header | `clamp(56px, 7vw, 96px)` | `clamp(32px, 4vw, 48px)` (tighter to lead into BLUF) |
| BLUF capsule | `clamp(40px, 5vw, 64px)` | `clamp(40px, 5vw, 64px)` (`.tight` pattern) |
| Prose section / Listicle / AreaServed | `clamp(56px, 7vw, 96px)` | `clamp(56px, 7vw, 96px)` (standard `<section>`) |
| FAQ | inherits from `FAQ.astro` |
| See-Also | `clamp(40px, 5vw, 64px)` both sides |
| ClosingCTA | `clamp(64px, 8vw, 112px)` (existing component) |

NO `CheckDivider` between BLUF and prose section (they're meant to read as one continuous answer block). `CheckDivider` is reserved for the homepage's section transitions per mockup.

---

## Mobile (≤600px) Prose Readability

| Element | Desktop | ≤980px | ≤600px |
|---------|---------|--------|--------|
| Body root font | 17px | 17px | 17px (no step-down — Newsreader at 17px is already mobile-tuned) |
| BLUF capsule | 18px | 18px | 17px (single step-down so it doesn't dominate) |
| H1 article | clamp scales naturally to 40px floor | — | — |
| Article gutter | 56px max | scales | 20px (`--gutter` clamp floor) |
| Listicle entry padding | 32px | 24px | 20px |
| Review card padding | 28px | 24px | 20px |
| About 2-col grid | 1fr 1.4fr | stack 1fr | stack 1fr |
| AreaServed pills | wrap | wrap | stack column |
| Inline link tap target | text-only | text-only | min `font-size: 17px` ensures ~44px tap height with 1.55 line-height |
| FAQ-q grid columns | `60px 1fr` (number + answer) | same | same — number column stays 60px so the visual rhythm is preserved |

---

## Copywriting Contract

Phase 3 ships skill-generated copy (D-01..05); the executor commits without manual review (D-02). The contract below sets the ELEMENT-LEVEL copy slots — skill output must fill them; executor verifies the slot is filled before commit.

| Element | Copy / Pattern |
|---------|----------------|
| Primary CTA (sitewide, in `.btn` and ClosingCTA + Hero) | "Book a chair" (locked from Phase 2; matches existing button text) |
| Secondary CTA | "Get directions" (locked from Phase 2) |
| Article header eyebrow — niche-landing | "East County · traditional barbering" |
| Article header eyebrow — cost guide | "2026 cost guide · East County" |
| Article header eyebrow — about | "The shop · the barbers" |
| Article header eyebrow — reviews | "Reviews · Google + Yelp" |
| Article header eyebrow — FAQ master | "Frequently asked · what people ask" |
| Date stamp format | `UPDATED MAY 2026` (Oswald uppercase; updated whenever copy changes — Phase 3 commit date) |
| BLUF first sentence pattern | Entity-first declarative: "Joe's Barbershop is a traditional men's barbershop in Bostonia, El Cajon CA…" — NOT "We" / "our shop" / "you'll find" |
| BLUF first sentence emphasis | Wrap first sentence (or its critical NAP/answer phrase) in `<strong>` for AI-citation salience |
| Empty state — reviews fallback (D-10) | If Firecrawl extraction fails: render placeholder cards with reviewer-name `[Reviewer name pending]` and quote `[Quote pending — extracted at showcase]`. NO empty card slots; placeholder content fills the layout. |
| Empty state — cost guide fallback (D-14) | If <4 competitors scrape: ship 2–3 real entries + 2–3 archetype entries ("The chain shop", "The men's grooming lounge", "The hole-in-the-wall"). Same entry-card layout; archetype entries omit address/phone, keep price-range + differentiator. |
| Error state | None — Phase 3 has no forms, no client-side state, no error boundaries. Static pages do not render error states. |
| Destructive confirmations | None — no destructive actions in Phase 3. |
| Banned phrases (skill output post-check) | "We're more than a barbershop, we're a community" / "experience the difference" / "discover" / "click here to learn more" / "we might" / "could" — per `inputs/02-aeo-constraints.md` § Anti-patterns. Executor scans skill output; flags + asks user before commit if found. |
| Voice anchor (skill input) | Working-class East County, heritage barbershop, no-frills, family-friendly, walk-ins-welcome, cash-only-as-positioning. Anti-prompts: no Brooklyn-grooming-bro, no luxury-spa, no SaaS-coded language. Source: `.agents/product-marketing-context.md` (D-01 step 1 output) + `.agents/aeo-frame.md` (D-01 step 2 output). |

### Per-Page Primary Query Anchor (for BLUF generation)

| Page | Primary query (BLUF must answer this) |
|------|---------------------------------------|
| `/` | "barbershop in Bostonia / El Cajon / East County" |
| `/east-county-traditional-barbershop` | "traditional barbershop East County" |
| `/2026-east-county-barbershop-cost-guide` | "how much does a barbershop cost in East County / El Cajon 2026" |
| `/about` | "who owns Joe's Barbershop in El Cajon" |
| `/reviews` | "Joe's Barbershop reviews / ratings" |
| `/faq` | "Joe's Barbershop hours, payment, walk-ins, kids cuts" |

(Source: D-01 step 2.)

---

## Registry Safety

| Registry | Blocks Used | Safety Gate |
|----------|-------------|-------------|
| n/a — no shadcn / no third-party component registry | none | not applicable |

Phase 3 reuses 12 components hand-ported from a locked OD-5 mockup in Phase 2. No external component registry, no `npx shadcn`-style import. Registry vetting gate not required.

---

## AEO Compliance Checks (built into the contract)

These are not optional — they flow from `inputs/02-aeo-constraints.md` and ROADMAP success criteria. Listed here so the checker / auditor can verify each.

| Rule | How this contract satisfies it |
|------|-------------------------------|
| BLUF first 100 words | Article-header → BLUF section is first under `<main>` on every non-homepage page. Homepage uses Hero `.hero-bluf` (already 100-word BLUF in mockup). |
| 130–160 word answer capsules per H2/H3 | Skill chain produces; planner specifies word-count target per section. No visual contract enforcement, but section spacing and max-width 70ch keep capsules readable. |
| No tabs / accordions | FAQ component is flat H3+`<p>`. No `details` / `summary`. No JS toggles. Verified by zero `client:*` directives in any Phase 3 page. |
| FAQ flat HTML | `FAQ.astro` and FAQ master page both render `<article class="faq-q"><h3>Q?</h3><p>A.</p></article>` — no collapse state. |
| No text-as-image | All H1/H2/H3, all service / hours / FAQ question text in real DOM nodes. Photos carry alt text describing the photo, not the answer. |
| Visible `areaServed` list | New AreaServed component-pattern on niche-landing renders 5 plain-text neighborhood links — visible in DOM. |
| `dateModified` visible on article pages | Date stamp in article header (cost guide, niche-landing) renders `UPDATED MAY 2026` in real DOM text. |
| All cross-links real text | Inline link rule + pill / see-also styles use anchor text content, never images, never text-replaced glyphs. |

---

## Checker Sign-Off

- [ ] Dimension 1 Copywriting: PASS
- [ ] Dimension 2 Visuals: PASS
- [ ] Dimension 3 Color: PASS
- [ ] Dimension 4 Typography: PASS
- [ ] Dimension 5 Spacing: PASS
- [ ] Dimension 6 Registry Safety: PASS

**Approval:** pending
