# Phase 3: Unique Pages — Pattern Map

**Mapped:** 2026-05-07
**Files analyzed:** 10 (6 pages, 2 data files, 2 skill-output files)
**Analogs found:** 8 / 10 strong analogs in repo; 2 net-new layouts use UI-SPEC as their visual contract.
**Files deleted:** 1 (`dev-mockup-parity.astro`, post-verification per D-20).

> Phase 3 is a composition phase. Every new file slots into an existing scaffold (`Base.astro`) and wires together components that already shipped in Phase 2. The strongest patterns to copy from are concentrated in two files:
> - `site/src/pages/dev-mockup-parity.astro` — the Phase 2 scratch page is the canonical "page composes Base + components" demo.
> - `site/src/components/Hero.astro` — the canonical `import { Picture/Image } from 'astro:assets'` + `import { business }` + scoped `<style>` recipe.

---

## File Classification

| New / Modified File | Role | Data Flow | Closest Analog | Match Quality |
|---------------------|------|-----------|----------------|---------------|
| `site/src/pages/index.astro` (REWRITE) | route / page | file-I/O (compile-time JSON read via `business`) | `site/src/pages/dev-mockup-parity.astro` | **exact** (composition is identical except FAQ becomes populated; ROADMAP success #1 is pixel-parity) |
| `site/src/pages/east-county-traditional-barbershop.astro` (CREATE) | route / page | file-I/O (compile-time read of `business` + inline content) | `site/src/pages/dev-mockup-parity.astro` (composition shape) + `site/src/components/Heritage.astro` (prose section idiom) | **role-match** (article-shaped, no Hero — composition is Base+chrome but body is bespoke prose) |
| `site/src/pages/2026-east-county-barbershop-cost-guide.astro` (CREATE) | route / page | file-I/O (read `competitors.json` + `business`) | `site/src/components/Visit.astro` (NAP `<dl>` block) + `site/src/components/FAQ.astro` (numbered listicle entries) | **partial** (no full analog; body is net-new listicle layout, but card NAP and number-tag idioms are reused) |
| `site/src/pages/about.astro` (REWRITE) | route / page | file-I/O (read `business`) | `site/src/components/Heritage.astro` (2-col image+prose grid mirrors the Joe / Alex section structure) | **role-match** (Heritage's `.heritage-grid` is the exact 2-col idiom needed; portrait placeholder substitutes for `<Image>`) |
| `site/src/pages/reviews.astro` (CREATE) | route / page | file-I/O (read `reviews.json`) | `site/src/components/FAQ.astro` (grid-of-cards composition) + `site/src/components/PriceBoard.astro` (`.price-aside .quote` for the review-quote idiom) | **partial** (review card is net-new layout per UI-SPEC; star-glyph + Oswald-meta idioms exist in `Hero.astro` `.hero-meta` and `FactStrip`) |
| `site/src/pages/faq.astro` (CREATE) | route / page | file-I/O (inline FAQ content) | `site/src/components/FAQ.astro` (the entire `.faq-q` markup pattern) | **exact** (the page replicates `FAQ.astro`'s `.faq-q` block, adds topic-group H2s; UI-SPEC explicitly says do NOT modify `FAQ.astro` to accept dynamic items — replicate the markup) |
| `site/src/data/reviews.json` (CREATE) | config / data | file-I/O (compile-time JSON consumed by reviews page) | `site/src/data/business.json` | **exact** (same flat-JSON-imported-by-page idiom; `_showcase_review_pending` array marker pattern carries over for D-10 fallback) |
| `site/src/data/competitors.json` (CREATE) | config / data | file-I/O (compile-time JSON consumed by cost guide) | `site/src/data/business.json` | **exact** (same idiom; archetype-entry markers per D-14 carry the `_showcase_review_pending` semantic) |
| `.agents/product-marketing-context.md` (CREATE — skill output) | config / artifact | event-driven (skill writes once at phase start) | none in repo (`.agents/` directory does not exist yet) | **no analog** (planner: skill-creator writes this; executor verifies file lands at this path per D-01 + Pitfall 1) |
| `.agents/aeo-frame.md` (CREATE — skill output) | config / artifact | event-driven (skill writes once at phase start) | none in repo | **no analog** (same as above; `marketing-skills:ai-seo` output) |

**File deleted (post-verification, per D-20):**
| File | When | Verification gate |
|------|------|-------------------|
| `site/src/pages/dev-mockup-parity.astro` | After `index.astro` is parity-verified at desktop / 980px / 600px | `npm run dev` + visual check |

---

## Pattern Assignments

### `site/src/pages/index.astro` (route, file-I/O) — REWRITE

**Analog:** `site/src/pages/dev-mockup-parity.astro` (entire file is the template)

**Composition pattern** (entire file `dev-mockup-parity.astro` lines 1-26):

```astro
---
// DEV-ONLY SCRATCH PAGE — Phase 2 parity check. Not a production page.
// Phase 3 replaces index.astro with the real homepage; this page can be deleted then.
import Base from '../layouts/Base.astro';
import CheckDivider from '../components/CheckDivider.astro';
import Hero from '../components/Hero.astro';
import FactStrip from '../components/FactStrip.astro';
import PriceBoard from '../components/PriceBoard.astro';
import Heritage from '../components/Heritage.astro';
import Visit from '../components/Visit.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
---
<Base title="[DEV] Mockup Parity — Joe's Barbershop" description="Development scratch page for Phase 2 OD-5 visual parity verification.">
  <CheckDivider />
  <Hero />
  <FactStrip />
  <CheckDivider />
  <PriceBoard />
  <Heritage />
  <CheckDivider />
  <Visit />
  <FAQ />
  <CheckDivider />
  <ClosingCTA />
</Base>
```

**Phase 3 deltas vs analog:**
- Replace dev-only `<Base>` title/description with prod copy: `title="Joe's Barbershop — Traditional Barbering in Bostonia, El Cajon"`, `description=` short factual NAP-anchored sentence (Phase 5 owns the full meta suite per Pitfall 4 — keep this minimal).
- The `<FAQ />` block is currently hard-coded in `FAQ.astro` (5 Qs, lines 13-47). Per D-19, the homepage shows a 5–6 Q&A subset. **The current `FAQ.astro` already contains 5 Q&As that match the homepage subset topics** (appointment, cards/cash, time, kids, location). **No modification of `FAQ.astro` needed for the homepage**; if a 6th is added, the planner can either modify `FAQ.astro` or replicate the `.faq-q` block inline (per UI-SPEC § FAQ Master Page Layout decision: do NOT make `FAQ.astro` dynamic for a single use).
- File header comment removed (no longer dev-only).

---

### `site/src/pages/east-county-traditional-barbershop.astro` (route, file-I/O) — CREATE

**Analog:** Composition shape from `dev-mockup-parity.astro`; prose section idiom from `Heritage.astro`.

**Frontmatter pattern** (mirror `Heritage.astro` lines 1-4 for imports + `dev-mockup-parity.astro` lines 4-12 for component imports):

```astro
---
import Base from '../layouts/Base.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';
---
```

> Note: NO `Hero` import (D-21: article-shape, no Hero photo). NO `Picture`/`Image` import (no photos on this page).

**Body composition pattern** (per D-21 + UI-SPEC § Article Header + § BLUF Capsule + § AreaServed List):

```astro
<Base title="Traditional Barbershop in East County · Joe's Barbershop" description="Joe's Barbershop is a traditional men's barbershop in Bostonia, El Cajon — walk-ins welcome, cash only, $30 cuts.">
  <header class="article-head">
    <div class="wrap">
      <span class="eyebrow kicker-rule">East County · traditional barbering</span>
      <h1>Traditional barbershop in East County, San Diego.</h1>
      <p class="date-stamp">Updated May 2026</p>
    </div>
  </header>
  <section class="bluf" aria-label="Answer capsule">
    <div class="wrap">
      <p class="bluf-lead"><strong>Joe's Barbershop is a traditional men's barbershop in Bostonia, El Cajon</strong> ...[skill output, ~100 words]</p>
    </div>
  </section>
  <section class="prose">
    <div class="wrap">
      <h2>What East County traditional barbering means</h2>
      <p>...[skill output, 130-160 word capsule]</p>
    </div>
  </section>
  <section class="area-served">
    <div class="wrap">
      <div class="section-head">
        <span class="section-mark" aria-hidden="true"></span>
        <div class="section-head-text">
          <span class="eyebrow">Where Joe serves</span>
          <h2>East County neighborhoods.</h2>
        </div>
      </div>
      <ul>
        <li><a href="/bostonia-barber">Bostonia</a></li>
        <li><a href="/el-cajon-barber">El Cajon</a></li>
        <li><a href="/santee-barber">Santee</a></li>
        <li><a href="/lakeside-barber">Lakeside</a></li>
        <li><a href="/la-mesa-barber">La Mesa</a></li>
      </ul>
    </div>
  </section>
  <FAQ />
  <ClosingCTA />
</Base>
```

**Scoped CSS pattern to copy** (mirror `Heritage.astro` lines 35-49 for `.heritage-copy p` max-width discipline; UI-SPEC § BLUF Capsule + § AreaServed List for new selectors):

```css
.article-head { padding: clamp(56px, 7vw, 96px) 0 clamp(32px, 4vw, 48px); background: var(--bg); }
.article-head .wrap { max-width: 820px; }
.article-head h1 { font-family: var(--font-display); font-size: clamp(40px, 5vw, 68px); font-weight: 600; line-height: 1.02; letter-spacing: -0.008em; margin: 0 0 18px; }
.article-head .date-stamp { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11.5px; font-weight: 600; color: var(--muted); margin: 0; }
.bluf { background: var(--surface); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); border-left: 3px solid var(--accent); padding-block: clamp(40px, 5vw, 64px); }
.bluf .bluf-lead { font-size: 18px; line-height: 1.6; max-width: 66ch; margin: 0; }
.prose { background: var(--bg); }
.prose p { font-size: 17.5px; line-height: 1.65; max-width: 70ch; }
.prose a { color: var(--fg); text-decoration: underline; text-decoration-color: var(--accent); text-decoration-thickness: 2px; text-underline-offset: 3px; }
.prose a:hover { color: var(--accent); }
.area-served { background: var(--surface); }
.area-served ul { list-style: none; padding: 0; margin: 0; display: flex; flex-wrap: wrap; gap: 12px 18px; }
.area-served li a { display: inline-block; padding: 10px 18px; border: 1px solid var(--border); background: var(--bg); font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 12px; font-weight: 600; text-decoration: none; color: var(--fg); }
.area-served li a:hover { border-color: var(--accent); color: var(--accent); }
@media (max-width: 600px) { .area-served ul { flex-direction: column; gap: 8px; } }
```

---

### `site/src/pages/2026-east-county-barbershop-cost-guide.astro` (route, file-I/O) — CREATE

**Analog:** `Visit.astro` for the NAP `<dl>` markup (lines 21-41); `FAQ.astro` for the numbered-entry idiom (`.faq-q .num` pattern, lines 13-19); `PriceBoard.astro` lines 28-30 for the accent-bordered pull-quote.

**NAP `<dl>` excerpt to mirror per entry** (`Visit.astro` lines 21-41):

```astro
<div class="nap">
  <dl>
    <dt>Address</dt>
    <dd>
      {business.address.street}, {business.address.suite}<br />
      {business.address.city}, {business.address.state} {business.address.zip}
    </dd>
    <dt>Phone</dt>
    <dd>{business.phone}</dd>
    <dt>Hours</dt>
    <dd>...</dd>
  </dl>
</div>
```

CSS to mirror (`Visit.astro` lines 55-59):

```css
.nap dl { margin: 0; display: grid; grid-template-columns: 130px 1fr; gap: 14px 20px; }
.nap dt { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11px; font-weight: 600; color: var(--muted); align-self: start; padding-top: 4px; }
.nap dd { margin: 0; font-size: 16px; line-height: 1.5; }
```

> UI-SPEC § Cost Guide Entry Card narrows the `<dt>` column to `110px` (vs Visit's `130px`) — minor delta.

**Numbered entry idiom** (`FAQ.astro` lines 13-19 + 51-57 — mirror this for cost guide entry numbers `01 / 02 / 03`):

```astro
<article class="faq-q">
  <span class="num" aria-hidden="true">01</span>
  <div>
    <h3>Do I need an appointment?</h3>
    <p>...</p>
  </div>
</article>
```

```css
.faq-q { padding-top: 22px; border-top: 1px solid var(--border); display: grid; grid-template-columns: 60px 1fr; gap: 32px; }
.faq-q .num { font-family: var(--font-display); font-size: 28px; font-weight: 600; color: var(--accent); line-height: 1; }
```

**Accent-bordered quote idiom** (`PriceBoard.astro` line 48):

```css
.price-aside .quote { border-left: 3px solid var(--accent); padding: 4px 0 4px 18px; margin: 24px 0 0; font-style: italic; color: var(--muted); font-size: 15.5px; }
```

> Apply the same `border-left: 3px solid var(--accent)` to the **Joe's Barbershop entry card** (UI-SPEC: "Joe's entry override") and to **`.entry-quote`** within each entry.

**Data-driven entries pattern** (mirror `Hero.astro` line 4 + `business` interpolation throughout — Pattern 1 + Pattern 4 from RESEARCH):

```astro
---
import Base from '../layouts/Base.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';
import competitors from '../data/competitors.json';
---
<!-- ... article-head + BLUF as above ... -->
<section class="entries-section">
  <div class="wrap">
    <ol class="entries">
      {competitors.map((c, i) => (
        <article class={`entry ${c.host ? 'entry-host' : ''}`}>
          <header class="entry-head">
            <span class="entry-num" aria-hidden="true">{String(i + 1).padStart(2, '0')}</span>
            <h3>{c.name}</h3>
          </header>
          <div class="nap">
            <dl>
              <dt>Address</dt><dd>{c.address}</dd>
              <dt>Phone</dt><dd>{c.phone}</dd>
              <dt>Hours</dt><dd>{c.hours}</dd>
              <dt>Price range</dt><dd>{c.priceRange}</dd>
              <dt>Rating</dt><dd>{c.rating}</dd>
            </dl>
          </div>
          {c.quote && <blockquote class="entry-quote">"{c.quote}"</blockquote>}
          <p class="entry-diff">{c.differentiator}</p>
        </article>
      ))}
    </ol>
  </div>
</section>
```

**See-Also block pattern** (UI-SPEC § See-Also Block — net-new but uses `Footer.astro` lines 19-39 as the anchor-list idiom — mirrors footer's `.foot-col ul` structure):

```astro
<aside class="see-also">
  <div class="wrap">
    <h2>See also: services & neighborhoods</h2>
    <div class="see-also-grid">
      <ul>
        <li><a href="/fades">Fades</a></li>
        <li><a href="/classic-cut">Classic Cut</a></li>
        <li><a href="/kids-cuts">Kids Cuts</a></li>
        <li><a href="/beard-trim">Beard Trim</a></li>
        <li><a href="/line-up">Line-Up</a></li>
        <li><a href="/hot-towel-shave">Hot-Towel Shave</a></li>
      </ul>
      <ul>
        <li><a href="/bostonia-barber">Bostonia</a></li>
        <li><a href="/el-cajon-barber">El Cajon</a></li>
        <li><a href="/santee-barber">Santee</a></li>
        <li><a href="/lakeside-barber">Lakeside</a></li>
        <li><a href="/la-mesa-barber">La Mesa</a></li>
      </ul>
    </div>
  </div>
</aside>
```

---

### `site/src/pages/about.astro` (route, file-I/O) — REWRITE

**Analog:** `Heritage.astro` — its `.heritage-grid` 2-column image+prose layout (lines 7-12, 35-44) is the exact composition pattern for the Joe section AND the Alex section.

**Heritage 2-col grid pattern to mirror** (`Heritage.astro` lines 7-12, 35-36):

```astro
<div class="heritage-grid">
  <div class="heritage-photo">
    <Image src={heritagePhoto} alt="..." loading="lazy" />
  </div>
  <div class="heritage-copy">
    <span class="eyebrow kicker-rule">Opened 2020</span>
    <h2>...</h2>
    <p>...</p>
  </div>
</div>
```

```css
.heritage-grid { display: grid; grid-template-columns: 1fr 1.05fr; gap: clamp(28px, 4vw, 72px); align-items: center; }
.heritage-photo img { width: 100%; aspect-ratio: 4 / 5; object-fit: cover; display: block; }
@media (max-width: 980px) { .heritage-grid { grid-template-columns: 1fr; } }
```

**Phase 3 delta:** Substitute `<Image>` for the **portrait placeholder div** per UI-SPEC § About Page Portrait Placeholder. Carry `data-pending-photo="joe"` / `="alex"` per D-07. The `aspect-ratio: 4 / 5` from `.heritage-photo img` is preserved on `.portrait-placeholder` (UI-SPEC explicit).

**Portrait placeholder CSS** (UI-SPEC § About Page Portrait Placeholder — net-new):

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

**Frontmatter** (mirror Hero.astro line 4 minus Picture import):

```astro
---
import Base from '../layouts/Base.astro';
import Visit from '../components/Visit.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';
---
```

**Composition** (per D-22 + UI-SPEC § About Page Layout):

```
article-head → BLUF → Joe section (placeholder L + bio R)
→ Alex section (bio L + placeholder R, mirrored) → Visit → ClosingCTA
```

> `Visit.astro` is reused as-is — it already imports its own storefront photo and `business` data (lines 1-5).

---

### `site/src/pages/reviews.astro` (route, file-I/O) — CREATE

**Analog:** `FAQ.astro` (grid-of-articles layout, lines 12-48); `PriceBoard.astro` line 48 for accent-bordered quote idiom; `Hero.astro` `.hero-meta` lines 50-51 for Oswald-meta idiom.

**Grid-of-articles pattern to mirror** (`FAQ.astro` lines 12-48):

```astro
<div class="faq-list">
  <article class="faq-q">...</article>
  <article class="faq-q">...</article>
</div>
```

```css
.faq-list { display: grid; grid-template-columns: 1fr; gap: 32px; max-width: 980px; }
```

**Phase 3 delta:** Reviews use a **2-column grid** (UI-SPEC § Review Card: `repeat(2, 1fr)` desktop, stacks at ≤600px). Otherwise the `<article>`-per-card idiom is identical.

**Star + meta-line idiom** (Oswald uppercase tracked — mirror `Hero.astro` line 51 + `FactStrip.astro` line 38):

```css
/* Hero.astro hero-meta strong — Oswald source */
.hero-meta strong { display: block; font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 11px; color: var(--fg); font-weight: 600; margin-bottom: 4px; }
/* FactStrip .label — same idiom */
.fact .label { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 10.5px; color: var(--muted); font-weight: 600; }
/* FactStrip .star — accent star */
.fact .value .star { color: var(--accent); }
```

**Apply to review-card source-line:**

```css
.review-source { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 11px; font-weight: 600; color: var(--muted); margin: 0; }
.review-card .stars { font-size: 18px; color: var(--accent); letter-spacing: 2px; margin-bottom: 14px; }
```

**Data-driven cards pattern** (mirror Hero.astro frontmatter line 4; reviews data is JSON-imported):

```astro
---
import Base from '../layouts/Base.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { business } from '../data/business';
import reviews from '../data/reviews.json';
---
<Base title="Reviews — Joe's Barbershop" description="...">
  <header class="article-head">...</header>
  <section class="bluf">
    <div class="wrap">
      <p class="bluf-lead">
        <strong>Joe's Barbershop is rated {business.ratings.google.value}★ across {business.ratings.google.count} Google + {business.ratings.yelp.count} Yelp reviews.</strong>
        ...
      </p>
    </div>
  </section>
  <section class="reviews-section">
    <div class="wrap">
      <div class="review-grid">
        {reviews.map(r => (
          <article class="review-card">
            <div class="stars" aria-label={`${r.rating} out of 5 stars`}>{'★'.repeat(r.rating)}</div>
            <p class="review-quote">"{r.quote}"</p>
            <h3 class="reviewer">{r.name}</h3>
            <p class="review-source">{r.source} · {r.date}</p>
          </article>
        ))}
      </div>
    </div>
  </section>
  <ClosingCTA />
</Base>
```

> **NO** `<FAQ />` component on this page (UI-SPEC § Review Card explicit: "No FAQ component on reviews page").

---

### `site/src/pages/faq.astro` (route, file-I/O) — CREATE

**Analog:** `site/src/components/FAQ.astro` — the entire `.faq-q` markup (lines 13-19) and `.faq-list` styling (line 53) is replicated **inline in the page**, not by importing the component.

**Why replicate, not import:** UI-SPEC § FAQ Master Page Layout: *"Phase 3 does NOT modify `FAQ.astro` to accept dynamic items. The master FAQ page (`/faq`) writes its own scoped markup repeating the `.faq-q` pattern with topic-group H2 headings inserted between question clusters."*

**Markup to copy verbatim per Q&A** (`FAQ.astro` lines 13-19):

```astro
<article class="faq-q">
  <span class="num" aria-hidden="true">01</span>
  <div>
    <h3>Do I need an appointment?</h3>
    <p>No appointment needed. Walk-ins are always welcome Tuesday through Saturday...</p>
  </div>
</article>
```

**CSS to copy verbatim** (`FAQ.astro` lines 51-57):

```css
.faq-list { display: grid; grid-template-columns: 1fr; gap: 32px; max-width: 980px; }
.faq-q { padding-top: 22px; border-top: 1px solid var(--border); display: grid; grid-template-columns: 60px 1fr; gap: 32px; }
.faq-q .num { font-family: var(--font-display); font-size: 28px; font-weight: 600; color: var(--accent); line-height: 1; }
.faq-q h3 { font-family: var(--font-display); font-size: clamp(22px, 2.2vw, 28px); font-weight: 600; line-height: 1.2; letter-spacing: -0.005em; margin: 0 0 12px; }
.faq-q p { margin: 0; font-size: 16.5px; line-height: 1.6; color: var(--fg); max-width: 70ch; }
```

**Phase 3 deltas:**
- Drop the `.faq` `section` wrapper (UI-SPEC § FAQ Master Page Layout: single column max-width 980px).
- Insert topic-group H2s (UI-SPEC: Hours & Days, Walk-ins & Booking, Payment & Cash, Kids & Family, Parking & Location).
- Continuous numbering "01" through "10+" — do NOT reset per group.

```css
/* Topic-group H2 (UI-SPEC additive) */
.faq-master h2 { font-family: var(--font-display); font-size: clamp(28px, 3vw, 36px); font-weight: 600; margin: 56px 0 24px; }
.faq-master h2:first-of-type { margin-top: 0; }
```

---

### `site/src/data/reviews.json` (config / data, file-I/O) — CREATE

**Analog:** `site/src/data/business.json` (entire shape pattern, lines 1-55).

**Shape pattern to mirror** (flat JSON object with `_showcase_review_pending` array marker for fallback per D-10):

```json
[
  {
    "name": "Sarah M.",
    "rating": 5,
    "quote": "Best $30 haircut in East County. Every time.",
    "source": "Google",
    "date": "Apr 2026"
  },
  {
    "name": "[Reviewer name pending]",
    "rating": 5,
    "quote": "[Quote pending — extracted at showcase]",
    "source": "Google",
    "date": ""
  }
]
```

> **D-10 fallback path:** If Firecrawl fails, ship 6-8 placeholder records with `[Reviewer name pending]` / `[Quote pending]` strings AND add a string to `business.json._showcase_review_pending` array marking the swap need (mirrors how Phase 2 handled `prices.kidsCut` and `sameAs.gbp`).

**Optional: TypeScript view to mirror `business.ts`** — if the planner wants type safety, mirror `business.ts` lines 1-37 by creating `site/src/data/reviews.ts`:

```typescript
import reviewsData from './reviews.json';

interface Review {
  name: string;
  rating: number;
  quote: string;
  source: 'Google' | 'Yelp';
  date: string;
}

export const reviews = reviewsData as Review[];
```

---

### `site/src/data/competitors.json` (config / data, file-I/O) — CREATE

**Analog:** `site/src/data/business.json` (same flat-JSON-array idiom; archetype entries per D-14 carry placeholder values for omitted fields).

**Shape pattern:**

```json
[
  {
    "name": "Joe's Barbershop",
    "host": true,
    "address": "723 E Bradley Ave, Suite C, El Cajon CA 92021",
    "phone": "(619) 891-2775",
    "hours": "Tue–Sat 10am–7:30pm",
    "priceRange": "$15–$50 (haircut $30, shave $30, beard line-up $20)",
    "rating": "4.9★ · 91 Google reviews",
    "quote": "Best $30 haircut in East County. Every time.",
    "differentiator": "No-frills traditional barbershop. Walk-ins only, cash only, ATM on site. Family-friendly. The $30 base price is the East County value anchor."
  },
  {
    "name": "[Real competitor 2]",
    "host": false,
    "address": "...",
    "phone": "...",
    "hours": "...",
    "priceRange": "...",
    "rating": "...",
    "quote": "...",
    "differentiator": "..."
  },
  {
    "name": "The chain shop",
    "host": false,
    "archetype": true,
    "address": "",
    "phone": "",
    "hours": "Daily, walk-in",
    "priceRange": "$25–$40 base + paid add-ons",
    "rating": "—",
    "quote": "",
    "differentiator": "Familiar national-brand chain. Convenient hours, app booking, but every add-on is à la carte. Volume operation, not heritage."
  }
]
```

> **D-14 fallback:** If <4 real competitors scrape, mix 2-3 real + 2-3 archetype entries (`"archetype": true` flag; `"host": true` only for Joe's entry). Cost guide entry-loop checks `c.host` to apply the accent left-border per UI-SPEC.

---

### `.agents/product-marketing-context.md` (config / artifact, event-driven) — CREATE

**Analog:** None in repo. The `.agents/` directory does not exist yet.

**Contract:** Skill `marketing-skills:product-marketing-context` writes to this exact path (D-01 step 1 + Pitfall 1). Inputs per D-03:
1. `inputs/00-brief.md`
2. `~/Documents/DT Vault/1-projects/dt-consulting-llc/joes-barbershop-sandbox.md`

**Verification:** Executor confirms the file lands at `.agents/product-marketing-context.md` (NOT `.claude/agents/`, NOT `inputs/`, NOT vault). Without this verification step, downstream `marketing-skills:copywriting` invocations cannot find the context file (Pitfall 1).

**Output shape (planner reference, not copied from a file):** positioning, audience, tone, anti-prompts, brand context — per Phase 3 D-01 step 1.

---

### `.agents/aeo-frame.md` (config / artifact, event-driven) — CREATE

**Analog:** None in repo. Inputs locked from `inputs/02-aeo-constraints.md`.

**Contract:** Skill `marketing-skills:ai-seo` writes to this path (D-04 — planner picks exact path; this is the recommended location). Encodes:
- BLUF first 100 words
- 130–160 word answer capsules per H2/H3
- Declarative tone (no "we" without entity context)
- No tabs/accordions
- FAQ flat H3/p
- No text-as-image

Plus per-page primary-query injection (D-01 step 2 — six queries).

---

## Shared Patterns

### Pattern A: Page Frontmatter Imports (every page)

**Source:** `site/src/components/Hero.astro` lines 1-4 + `site/src/pages/dev-mockup-parity.astro` lines 4-12

**Apply to:** All 6 page files.

```astro
---
import Base from '../layouts/Base.astro';
import { business } from '../data/business';
// component imports as needed:
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import Visit from '../components/Visit.astro'; // about + homepage only
// asset imports (homepage only, since other pages have no photos):
import { Picture } from 'astro:assets'; // hero only
import { Image } from 'astro:assets';   // everywhere else
import heroPhoto from '../assets/photos/03-interior-hero.jpg';
---
```

> **Picture vs Image rule** (locked from Phase 2; verified in `Hero.astro` line 28-34 vs `Visit.astro` line 17, `Heritage.astro` line 9, `Footer.astro` line 11): `<Picture>` is used **only on the homepage Hero** (because that photo is `loading="eager"` + `fetchpriority="high"` and benefits from `formats={['avif', 'webp']}`); every other photo uses `<Image>` with `loading="lazy"`. Phase 3 introduces no new photos (D-21, D-07), so **only the homepage uses `<Picture>`** in Phase 3.

---

### Pattern B: `<Base>` Wrapping (every page)

**Source:** `site/src/pages/dev-mockup-parity.astro` line 14 + `site/src/layouts/Base.astro` lines 8-13

**Apply to:** All 6 page files.

```astro
<Base title="..." description="...">
  <!-- page body -->
</Base>
```

> Phase 3 sets `title` + `description` for dev visibility ONLY (D-17, Phase 3 Pitfall 4). Phase 5 owns `META-01..04` and will rewrite. Do NOT pass other props (`<slot name="head" />` is reserved for Phase 5 schema injection per Phase 2 D-26).

> Section ordering inside Base is locked: `UtilBar → Masthead → main(slot) → Footer`. Pages slot only into `<main>`. The chrome (UtilBar / Masthead / Footer) comes from `Base.astro`, NEVER from individual pages.

---

### Pattern C: `business` Data Interpolation (every page that shows NAP)

**Source:** `site/src/components/Hero.astro` lines 22-24, `site/src/components/Visit.astro` lines 25-30, `site/src/components/FactStrip.astro` lines 13-14

**Apply to:** All pages that render address / phone / hours / prices / ratings.

```astro
{business.address.street}, {business.address.suite}
{business.address.city}, {business.address.state} {business.address.zip}
{business.phone}
{business.ratings.google.value}★ · {business.ratings.google.count} Google reviews
${business.prices.haircut}
```

---

### Pattern D: Scoped `<style>` Block per File (every page + every component)

**Source:** `site/src/components/Hero.astro` lines 40-61, `Heritage.astro` lines 34-49, `FAQ.astro` lines 51-58, etc.

**Apply to:** Every Phase 3 page file.

```astro
<style>
  /* Page-scoped CSS lives here. Astro auto-scopes to this file's elements. */
  .my-page-section { ... }
</style>
```

> Tokens (`var(--fg)`, `var(--accent)`, etc.) are globally available because `Base.astro` imports `tokens.css` and `utilities.css` (Base lines 5-6). Pages MUST consume tokens, NOT hardcode color/size values (UI-SPEC § Color "Phase 3 introduces NO new color values").

---

### Pattern E: Section-Head + Section-Mark Composition (every page with section heads)

**Source:** `Visit.astro` lines 7-14, `Heritage.astro` (section-head idiom is in `utilities.css` lines 19-23 — already global)

**Apply to:** Niche-landing, cost guide, FAQ master (where section heads are wanted).

```astro
<div class="section-head">
  <span class="section-mark" aria-hidden="true"></span>
  <div class="section-head-text">
    <span class="eyebrow">Where Joe serves</span>
    <h2>East County neighborhoods.</h2>
  </div>
</div>
```

> `.section-head`, `.section-mark`, `.eyebrow` are utilities — globally available. Don't redefine.

---

### Pattern F: AEO-Compliance Discipline (every prose page)

**Source:** `inputs/02-aeo-constraints.md` (encoded via `.agents/aeo-frame.md` per D-04) + UI-SPEC § AEO Compliance Checks.

**Apply to:** All 6 pages (homepage already enforces these via `Hero.hero-bluf`).

| Rule | Implementation |
|------|----------------|
| BLUF first 100 words | Article-header → BLUF section is first under `<main>` on niche-landing, cost guide, about, reviews, FAQ master. Homepage uses Hero `.hero-bluf` already (line 15). |
| No tabs / accordions | Zero `client:*` directives. No `<details>` / `<summary>`. FAQ is flat `<article><h3><p>`. |
| FAQ flat HTML | Verified by `FAQ.astro` lines 13-19. Replicated verbatim on `/faq` master page. |
| No text-as-image | Every cross-link is real text. Photos carry alt-text describing the photo, not the answer. |
| Visible `areaServed` list | New section on niche-landing — 5 plain-text neighborhood links visible in DOM. |
| `dateModified` visible | Date stamp `UPDATED MAY 2026` rendered as real text in article-header on cost guide + niche-landing. |
| Banned phrases | Skill output post-check rejects: "we're more than a barbershop", "experience the difference", "discover", "click here to learn more", "we might", "could". UI-SPEC § Copywriting Contract. |

---

### Pattern G: `data-pending-photo` + `_showcase_review_pending` Marker Pattern (cross-cutting)

**Source:** `business.json` lines 47-54 (`_showcase_review_pending` array). New pattern (D-07): `data-pending-photo` HTML attribute on portrait placeholders.

**Apply to:**
- `/about` portrait placeholders → `data-pending-photo="joe"` / `data-pending-photo="alex"` HTML attribute on the `<div class="portrait-placeholder">`
- `business.json._showcase_review_pending` array → append entries describing each Phase 3 swap need (Joe + Alex bios pending Joe confirmation; portraits pending photo capture; reviews fallback if D-10 triggers; cost guide archetype entries if D-14 triggers)

**Existing markers in `business.json` to mirror** (lines 47-54):

```json
"_showcase_review_pending": [
  "hours.saturday.close — vault says 19:30, mockup shows 18:30; using vault baseline pending Joe's GBP confirmation",
  "sameAs.gbp — placeholder URL pending GBP login + canonical maps.google.com URL",
  "prices.kidsCut — null pending Joe's confirmation at showcase"
]
```

**Phase 3 additions to append:**

```json
"_showcase_review_pending": [
  "...existing entries...",
  "/about portraits — placeholder div with data-pending-photo='joe' / 'alex' pending in-shop photo capture",
  "/about Alex bio — minimal/conservative until Joe confirms specifics at showcase",
  "/reviews quotes — [if D-10 fallback] placeholder cards pending Firecrawl extraction success",
  "/cost-guide entries — [if D-14 fallback] N archetype entries pending Firecrawl extraction success"
]
```

---

### Pattern H: Inline Cross-Link Color Treatment (prose-heavy pages)

**Source:** UI-SPEC § Cross-Link Treatment (net-new — `tokens.css` line 31 defines base `a { color: inherit }`).

**Apply to:** Niche-landing prose, cost guide prose, FAQ master prose.

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

> Mirrors `Masthead.astro` `nav.primary a:hover` accent-on-hover idiom (line 34) and `Footer.astro` `a:hover` accent border-bottom (line 65). Honors Color § Accent Reserved For — accent-at-rest budget is not extended.

---

## Phase 4 Slug Discipline (cross-cutting reference)

**Source:** `Footer.astro` lines 22-27 (services) + lines 33-37 (neighborhoods) — these slugs are ALREADY canonical.

The footer is the single source of truth for canonical Phase 4 slugs. Phase 3 cross-links MUST match the strings already in `Footer.astro`:

```
/fades, /classic-cut, /kids-cuts, /beard-trim, /line-up, /hot-towel-shave
/bostonia-barber, /el-cajon-barber, /santee-barber, /lakeside-barber, /la-mesa-barber
```

> `Masthead.astro` line 17 also uses `/east-county-traditional-barbershop` — Phase 3 ships that exact route. The masthead's `/services` link (line 16) is a Phase 4 dependency that will 404 in Phase 3 builds. Acceptable per D-16.

---

## No Analog Found

Files with no close match in the codebase (planner uses RESEARCH.md and UI-SPEC patterns directly):

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `.agents/product-marketing-context.md` | config / artifact | event-driven | `.agents/` directory does not exist yet; output is structured but skill-generated, not authored from a template. Planner instructs executor to invoke `marketing-skills:product-marketing-context` and verify file lands at this path. |
| `.agents/aeo-frame.md` | config / artifact | event-driven | Same reason. Skill `marketing-skills:ai-seo` writes; executor verifies. |
| Cost guide listicle entry layout | route fragment | render-time | Net-new layout per UI-SPEC § Cost Guide Entry Card. Composes `Visit.astro` NAP-`<dl>` + `FAQ.astro` numbered-tag idioms but the entry-card-as-listicle-row is new. UI-SPEC is the contract. |
| Review card layout | route fragment | render-time | Net-new per UI-SPEC § Review Card. UI-SPEC is the contract. |
| BLUF capsule + Article header | route fragment | render-time | Net-new per UI-SPEC § BLUF Capsule + § Article Header. UI-SPEC is the contract. The accent left-border idiom is borrowed from `PriceBoard.astro` `.price-aside .quote` line 48 — that's the closest visual analog. |

---

## Metadata

**Analog search scope:**
- `site/src/pages/` (3 existing files)
- `site/src/components/` (12 existing files — all read)
- `site/src/layouts/` (1 existing file)
- `site/src/data/` (2 existing files)
- `site/src/styles/` (2 existing files)
- `site/src/content/` (services + neighborhoods stubs — listed only; not consumed by Phase 3)

**Files scanned:** 21 source files in `site/src/` + 4 phase artifacts (CONTEXT, RESEARCH, UI-SPEC, ROADMAP refs).

**Pattern extraction date:** 2026-05-07
