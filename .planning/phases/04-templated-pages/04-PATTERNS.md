# Phase 4: Templated Pages - Pattern Map

**Mapped:** 2026-05-09
**Files analyzed:** 14 (2 NEW route files, 11 MODIFY collection markdown files, 1 MODIFY audit script)
**Analogs found:** 14 / 14 (all files have a strong analog in-tree)

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `site/src/pages/[service].astro` (NEW) | dynamic-route page | request-response (build-time SSG via `getStaticPaths`) | `site/src/pages/east-county-traditional-barbershop.astro` | role-match (article archetype, no dynamic-route analog exists yet) |
| `site/src/pages/[neighborhood]-barber.astro` (NEW) | dynamic-route page | request-response (build-time SSG via `getStaticPaths`) | `site/src/pages/east-county-traditional-barbershop.astro` + `site/src/pages/about.astro` (Visit pattern) | role-match (article + Visit composition) |
| `site/src/content/services/{6 files}.md` (MODIFY) | content-collection entry | static data + markdown body | `site/src/content/services/fades.md` (existing stub frontmatter) | exact (same schema, body swap-in) |
| `site/src/content/neighborhoods/{5 files}.md` (MODIFY) | content-collection entry | static data + markdown body | `site/src/content/neighborhoods/el-cajon.md` (most-populated stub) | exact (same schema, body + landmarks/distance swap-in) |
| `.planning/phases/03-unique-pages/scripts/audit.sh` (MODIFY) | bash test/validation | file-I/O (grep over `dist/`) | existing `check_niche_areaserved` + `check_cost_guide_slugs` functions inside the same file | exact (extend with same idiom) |

---

## Pattern Assignments

### `site/src/pages/[service].astro` (NEW dynamic-route page)

**Primary analog:** `site/src/pages/east-county-traditional-barbershop.astro` (article archetype Phase 4 mirrors per CONTEXT D-04)

**No existing dynamic-route file in repo.** Astro `getStaticPaths` pattern documented per CONTEXT D-01; planner writes the frontmatter shape from scratch using Astro 6 docs. The composition pattern (Header → BLUF → photo → price callout → prose → see-also → areaServed → FAQ → ClosingCTA) is copied from the niche-landing analog.

**Imports pattern** (copy from `east-county-traditional-barbershop.astro` lines 1-13, plus add Image + getCollection):

```astro
---
import Base from '../layouts/Base.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { Image } from 'astro:assets';
import { getCollection } from 'astro:content';
import { business } from '../data/business';

export async function getStaticPaths() {
  const services = await getCollection('services');
  return services.map((entry) => ({
    params: { service: entry.id },   // entry.id is the slug-from-filename per Astro 6 glob loader
    props: { entry },
  }));
}

const { entry } = Astro.props;
const { Content } = await entry.render();
---
```

**Base wrapper pattern** (copy from `east-county-traditional-barbershop.astro` lines 16-20):

```astro
<Base
  title={`${entry.data.title} · Joe's Barbershop`}
  description={entry.data.bluf}
  variant="article"
>
```

**Article header pattern** (copy from `east-county-traditional-barbershop.astro` lines 21-27):

```astro
<header class="article-head">
  <div class="wrap">
    <span class="eyebrow kicker-rule">East County · {entry.data.title.toLowerCase()}</span>
    <h1>{/* page-specific H1 from skill output, or default phrasing */}</h1>
    <p class="date-stamp">UPDATED {lastUpdated.toUpperCase()}</p>
  </div>
</header>
```

**BLUF capsule pattern** (copy from `east-county-traditional-barbershop.astro` lines 29-36):

```astro
<section class="bluf" aria-label="Answer capsule">
  <div class="wrap">
    <p class="bluf-lead">
      <strong>{entry.data.bluf}</strong>
      {/* secondary BLUF sentence — skill-generated */}
    </p>
  </div>
</section>
```

**Hero photo pattern** (NEW — derived from `Visit.astro` lines 1-4 import + lines 16-18 render, but `loading="lazy"` per CONTEXT D-05):

```astro
---
// at top of frontmatter, alongside other imports
import midCut from '../assets/photos/05-mid-cut.jpg';
import interiorHero from '../assets/photos/03-interior-hero.jpg';
import priceBoard from '../assets/photos/06-price-board-cash-only.jpg';

const heroPhotoMap: Record<string, ImageMetadata> = {
  '05-mid-cut.jpg': midCut,
  '03-interior-hero.jpg': interiorHero,
  '06-price-board-cash-only.jpg': priceBoard,
};
const heroPhoto = entry.data.heroPhoto ? heroPhotoMap[entry.data.heroPhoto] : interiorHero;
---
<section class="service-hero">
  <div class="wrap">
    <Image src={heroPhoto} alt={`${entry.data.title} at Joe's Barbershop`} loading="lazy" />
  </div>
</section>
```

**Price callout pattern** (NEW — derived from `PriceBoard.astro` lines 14-23 visual heritage but scoped to a single service):

```astro
<section class="price-callout" aria-label="Service price">
  <div class="wrap">
    <div class="price-callout-card">
      <span class="eyebrow">Posted price · cash only</span>
      <p class="price-amount">${entry.data.price}</p>
      <p class="price-meta">{entry.data.duration} · ATM on site</p>
    </div>
  </div>
</section>
```

Scoped CSS for `.price-callout` echoes `PriceBoard.astro` style block lines 37-45 (board-bg, board-fg, font-board, letter-spacing 0.14em) without reusing the component.

**Prose section pattern** (copy from `east-county-traditional-barbershop.astro` lines 38-44, body swapped for `<Content />`):

```astro
<section class="prose">
  <div class="wrap">
    <Content />
  </div>
</section>
```

**See-also (related services + cost guide) pattern** (copy from `2026-east-county-barbershop-cost-guide.astro` lines 132-148 see-also block, simplified):

```astro
<aside class="see-also">
  <div class="wrap">
    <h2>See also</h2>
    <ul>
      {relatedServiceSlugs.map(({ name, slug }) => (
        <li><a href={`/${slug}`}>{name}</a></li>
      ))}
      <li><a href="/2026-east-county-barbershop-cost-guide">2026 East County cost guide</a></li>
    </ul>
  </div>
</aside>
```

`relatedServiceSlugs` is planner discretion per CONTEXT (e.g., `/fades` → `/classic-cut` + `/line-up`).

**areaServed pattern** (copy directly from `east-county-traditional-barbershop.astro` lines 46-62 — same `neighborhoods` array, same JSX, same scoped CSS classes `.area-served`, `.section-head`):

```astro
const neighborhoods = [
  { name: 'Bostonia',  slug: 'bostonia-barber'  },
  { name: 'El Cajon',  slug: 'el-cajon-barber'  },
  { name: 'Santee',    slug: 'santee-barber'    },
  { name: 'Lakeside',  slug: 'lakeside-barber'  },
  { name: 'La Mesa',   slug: 'la-mesa-barber'   },
];
// ... template renders <ul> of <a href={`/${slug}`}>
```

**FAQ pattern** (variable count per CONTEXT D-07; copy from `east-county-traditional-barbershop.astro` lines 64-118 inline `.faq-q` markup, render via `entry.data.faqs.map`):

```astro
<section class="faq" aria-label="Frequently asked questions">
  <div class="wrap">
    <div class="section-head">{/* same as niche-landing */}</div>
    <div class="faq-list">
      {entry.data.faqs.map((faq, i) => (
        <article class="faq-q">
          <span class="num" aria-hidden="true">{String(i + 1).padStart(2, '0')}</span>
          <div>
            <h3>{faq.q}</h3>
            <p set:html={faq.a} />
          </div>
        </article>
      ))}
    </div>
  </div>
</section>
```

Note `set:html` on the `<p>` is required if FAQ answers can carry inline `<a>` tags (recommended for the inline-link mesh per D-08); use `{faq.a}` directly if frontmatter answers stay plain-text.

**ClosingCTA pattern** (copy from `east-county-traditional-barbershop.astro` line 120):

```astro
<ClosingCTA />
```

**Scoped CSS pattern** (copy `<style>` block from `east-county-traditional-barbershop.astro` lines 123-282 verbatim — `.article-head`, `.bluf`, `.prose`, `.area-served`, `.faq`, `.faq-q` rules — then add new rules for `.service-hero`, `.price-callout`, `.see-also`).

---

### `site/src/pages/[neighborhood]-barber.astro` (NEW dynamic-route page)

**Primary analog:** `site/src/pages/east-county-traditional-barbershop.astro` (article archetype) + `site/src/pages/about.astro` (Visit composition pattern)

**Mixed-segment route filename note:** Astro 6 supports `[neighborhood]-barber.astro` filenames. The dynamic param matches the slug *without* the `-barber` suffix (e.g., URL `/bostonia-barber` → `params.neighborhood === 'bostonia'`). Per CONTEXT D-01, `getStaticPaths` returns the 5 neighborhood slugs without the suffix.

**Imports pattern** (mirrors `[service].astro` plus shared storefront photo per CONTEXT D-10):

```astro
---
import Base from '../layouts/Base.astro';
import Visit from '../components/Visit.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
import { Image } from 'astro:assets';
import { getCollection } from 'astro:content';
import { business } from '../data/business';
import storefront from '../assets/photos/02-storefront.jpg';

export async function getStaticPaths() {
  const neighborhoods = await getCollection('neighborhoods');
  // collection ids are 'bostonia', 'el-cajon', 'santee', 'lakeside', 'la-mesa' (no -barber suffix)
  return neighborhoods.map((entry) => ({
    params: { neighborhood: entry.id },
    props: { entry },
  }));
}

const { entry } = Astro.props;
const { Content } = await entry.render();

const services = [
  { name: 'Fades',           slug: 'fades' },
  { name: 'Classic Cut',     slug: 'classic-cut' },
  { name: 'Kids Cuts',       slug: 'kids-cuts' },
  { name: 'Beard Trim',      slug: 'beard-trim' },
  { name: 'Line-Up',         slug: 'line-up' },
  { name: 'Hot-Towel Shave', slug: 'hot-towel-shave' },
];
---
```

**Storefront photo pattern** (copy from `Visit.astro` lines 2-3 import + lines 16-18 render):

```astro
<section class="neighborhood-photo">
  <div class="wrap">
    <Image src={storefront} alt="Joe's Barbershop storefront in Bostonia" loading="lazy" />
  </div>
</section>
```

**"Getting here from {neighborhood}" pattern** (NEW per CONTEXT D-11 — structured distance + landmarks list, NOT prose):

```astro
<section class="getting-here">
  <div class="wrap">
    <div class="section-head">
      <span class="section-mark" aria-hidden="true"></span>
      <div class="section-head-text">
        <span class="eyebrow">Getting here from {entry.data.title.replace(' Barber', '')}</span>
        <h2>The drive.</h2>
      </div>
    </div>
    <p class="distance"><strong>{entry.data.distance}</strong></p>
    <ul class="landmarks">
      {entry.data.landmarks.map((landmark) => (
        <li>{landmark}</li>
      ))}
    </ul>
  </div>
</section>
```

CSS for `.distance` and `.landmarks` echoes the `.area-served ul li a` letter-board style from `east-county-traditional-barbershop.astro` lines 218-230 (`font-board`, uppercase, letter-spacing 0.14em, border 1px var(--border)).

**Prose section pattern** — same as service template: `<section class="prose"><div class="wrap"><Content /></div></section>`.

**Visit (NAP) pattern** (copy from `about.astro` line 50 — direct component drop-in, per CONTEXT D-12):

```astro
<Visit />
```

**Services block pattern** ("What we cut for {neighborhood} customers" per CONTEXT D-13 — full 6-service mesh):

```astro
<section class="services-mesh">
  <div class="wrap">
    <div class="section-head">{/* same pattern as niche-landing */}</div>
    <h2>What we cut for {entry.data.title.replace(' Barber', '')} customers.</h2>
    <ul>
      {services.map(({ name, slug }) => (
        <li><a href={`/${slug}`}>{name}</a></li>
      ))}
    </ul>
  </div>
</section>
```

Visual treatment copies `.area-served` styles from `east-county-traditional-barbershop.astro` lines 200-234.

**Cross-link pattern** (niche-landing + cost guide per CONTEXT D-13):

```astro
<aside class="see-also">
  <div class="wrap">
    <ul>
      <li><a href="/east-county-traditional-barbershop">East County traditional barbershop</a></li>
      <li><a href="/2026-east-county-barbershop-cost-guide">2026 East County cost guide</a></li>
    </ul>
  </div>
</aside>
```

**FAQ pattern** — identical to service template, from `entry.data.faqs`.

**ClosingCTA + scoped CSS** — identical idiom to service template; add bespoke rules for `.neighborhood-photo`, `.getting-here`, `.services-mesh`.

---

### `site/src/content/services/{slug}.md` × 6 (MODIFY)

**Analog:** `site/src/content/services/fades.md` (existing stub) — schema-passing frontmatter shape that Phase 4 populates with real values.

**Existing stub (replace body, populate `faqs` array):**

```markdown
---
title: "Fades"
price: 30
duration: "30 min"
bluf: "Joe's Barbershop offers fade haircuts in Bostonia, El Cajon. Haircut $30. Walk-ins welcome, Tue–Sat."
faqs: []
heroPhoto: "05-mid-cut.jpg"
---

Stub content — Phase 3/4 replaces with AEO-optimized prose and FAQs.
```

**Phase 4 populated frontmatter shape** (per CONTEXT D-15 + content.config.ts schema lines 8-18):

```markdown
---
title: "Fades"
price: 30
duration: "30 min"
bluf: "{Skill-generated 100-word BLUF answering the page's primary query 'fade haircut El Cajon / East County'}"
faqs:
  - q: "How much does a fade cost at Joe's Barbershop?"
    a: "A fade haircut at Joe's is $30, cash only. The price is on the board before you sit down — no hidden fees, no card processing surcharge. ATM on site."
  - q: "Does Joe's Barbershop do skin fades?"
    a: "Yes — skin fades, low fades, mid fades, and high fades are all part of the standard $30 haircut. The fade is the most-requested style at Joe's; both Joe and the team cut them daily."
  # ... variable count per service per D-07
heroPhoto: "05-mid-cut.jpg"
---

{Skill-generated prose section — H2 "What this service is" + H2 "What's different at Joe's" — answers the primary query and surfaces inline links to related services and neighborhoods per D-08}
```

**FAQ q/a schema** (locked at `content.config.ts` line 15: `faqs: z.array(z.object({ q: z.string(), a: z.string() }))`). Skill output must match exactly.

**Files to populate:** `fades.md`, `classic-cut.md`, `kids-cuts.md`, `beard-trim.md`, `line-up.md`, `hot-towel-shave.md`. Existing `heroPhoto` field present on `fades.md` and `classic-cut.md`; planner adds for the others per CONTEXT discretion (likely `03-interior-hero.jpg` or `06-price-board-cash-only.jpg`).

**Verification gate:** zero matches for `"Stub content — Phase 3/4 replaces"` under `site/src/content/` after Phase 4 ships (per CONTEXT specifics).

---

### `site/src/content/neighborhoods/{slug}.md` × 5 (MODIFY)

**Analog:** `site/src/content/neighborhoods/el-cajon.md` (most-populated stub — has real `distance` value `"0.5 mi from shop"`) for the format target; `site/src/content/neighborhoods/bostonia.md` for the placeholder shape that needs replacing.

**Existing stub (placeholder landmarks + distance):**

```markdown
---
title: "Bostonia Barber"
landmarks: ["Bostonia area", "East County San Diego"]
distance: "local"
bluf: "Joe's Barbershop is the traditional barbershop serving Bostonia in El Cajon, East County San Diego. Walk-ins welcome."
faqs: []
---

Stub content — Phase 4 replaces with AEO-optimized neighborhood-specific prose.
```

**Phase 4 populated frontmatter shape** (per CONTEXT D-11 — real landmarks, real distance string):

```markdown
---
title: "Bostonia Barber"
landmarks: ["Sycuan Casino", "Parkway Plaza", "Bostonia Park"]
distance: "0.0 mi — in Bostonia"
bluf: "{Skill-generated 100-word BLUF answering 'barber in Bostonia / Bostonia barbershop'}"
faqs:
  - q: "Is Joe's Barbershop located in Bostonia?"
    a: "Yes — Joe's Barbershop is at 723 E Bradley Ave, Suite C, in the Bostonia neighborhood of El Cajon. Walk-in friendly, Tue–Sat 10am–7:30pm."
  # ... 3-4 Q&As per inputs/01-page-list.md neighborhood target
---

{Skill-generated prose — "How Joe's serves {neighborhood}" — answers primary query, references local landmarks naturally, links to related services}
```

**Per-neighborhood landmark research (from CONTEXT specifics):**
- Bostonia → Sycuan Casino, Parkway Plaza
- El Cajon → Westfield Parkway
- Santee → Santee Town Center, Santee Lakes
- Lakeside → Lakeside Rodeo Grounds
- La Mesa → La Mesa Village, Grossmont Center

**Distance string format** (CONTEXT discretion — recommend keeping `"X.X mi from shop"` style for AI-parser-friendly number prefix; existing `el-cajon.md` `"0.5 mi from shop"` is the model).

**Files to populate:** `bostonia.md`, `el-cajon.md`, `santee.md`, `lakeside.md`, `la-mesa.md`. Same verification gate as services.

---

### `.planning/phases/03-unique-pages/scripts/audit.sh` (MODIFY)

**Analog:** existing `check_niche_areaserved` (lines 63-77) and `check_cost_guide_slugs` (lines 79-98) functions inside the same file — exact-match idiom for adding 11 new slug checks.

**Existing function pattern (the idiom Phase 4 extends):**

```bash
check_niche_areaserved() {
  local page="${DIST_DIR}/east-county-traditional-barbershop/index.html"
  if [ ! -f "$page" ]; then skip "niche-areaserved" "page not built yet"; return; fi
  local count
  count=$(awk '/<section[^>]*class="[^"]*area-served/,/<\/section>/' "$page" \
    | grep -oE 'href="/[a-z-]+-barber"' \
    | sort -u \
    | wc -l \
    | tr -d ' ' || echo 0)
  if [ "$count" -eq 5 ]; then
    pass
  else
    fail "niche-areaserved" "expected 5 neighborhood links in areaServed section, got ${count}"
  fi
}
```

**New checks Phase 4 adds** (per CONTEXT integration points — verify all 11 Phase 4 slugs return 200 + each entry populates non-empty BLUF + FAQs):

```bash
# Verify each of the 6 service slugs builds to dist/{slug}/index.html
check_service_pages_built() {
  local services=(fades classic-cut kids-cuts beard-trim line-up hot-towel-shave)
  for slug in "${services[@]}"; do
    local page="${DIST_DIR}/${slug}/index.html"
    if [ ! -f "$page" ]; then
      fail "service-pages-built" "${slug}/index.html not built"
      return
    fi
  done
  pass
}

# Verify each of the 5 neighborhood slugs builds
check_neighborhood_pages_built() {
  local hoods=(bostonia-barber el-cajon-barber santee-barber lakeside-barber la-mesa-barber)
  for slug in "${hoods[@]}"; do
    local page="${DIST_DIR}/${slug}/index.html"
    if [ ! -f "$page" ]; then
      fail "neighborhood-pages-built" "${slug}/index.html not built"
      return
    fi
  done
  pass
}

# Verify no stub content remains in collection markdown (CONTEXT specifics)
check_no_stub_content() {
  local count
  count=$(grep -rl "Stub content — Phase 3/4 replaces\|Stub content — Phase 4 replaces" "${SITE_DIR}/src/content/" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -eq 0 ]; then
    pass
  else
    fail "no-stub-content" "found ${count} collection files still containing stub markers"
  fi
}

# Verify each templated page has the BLUF + FAQ structure
check_templated_bluf() {
  local pages=(fades classic-cut kids-cuts beard-trim line-up hot-towel-shave \
               bostonia-barber el-cajon-barber santee-barber lakeside-barber la-mesa-barber)
  for slug in "${pages[@]}"; do
    local page="${DIST_DIR}/${slug}/index.html"
    if [ ! -f "$page" ]; then continue; fi
    if ! grep -q '<section class="bluf"' "$page" 2>/dev/null; then
      fail "templated-bluf" "${slug}/index.html missing <section class=\"bluf\">"
      return
    fi
  done
  pass
}
```

**Registry update pattern** (copy from `run_check` lines 315-337 + `run_all_checks` lines 340-355): add the new check names to the case statement and to `run_all_checks`. Mirrors the existing structure exactly.

---

## Shared Patterns

### Base layout wrapper

**Source:** `site/src/layouts/Base.astro` lines 1-34, especially the `variant="article"` prop wired at line 31 (`<main class={variant === 'article' ? 'article-page' : undefined}>`).

**Apply to:** Both new dynamic-route templates (`[service].astro`, `[neighborhood]-barber.astro`).

```astro
<Base title={...} description={...} variant="article">
  ...
</Base>
```

`<slot name="head" />` is reserved for Phase 5 schema injection (CONTEXT D-26 carry-forward) — Phase 4 does NOT pass anything into it.

---

### Article-page typography (BLUF + prose)

**Source:** `site/src/pages/east-county-traditional-barbershop.astro` style block lines 123-282 — the full set of `.article-head`, `.bluf`, `.prose`, `.area-served`, `.faq`, `.faq-q` scoped CSS rules.

**Apply to:** Both new templates. The `.bluf` rule (lines 149-166) with `border-left: 3px solid var(--accent)` and `surface` background is the load-bearing AEO BLUF visual signal — copy verbatim.

```css
.bluf {
  background: var(--surface);
  border-top: 1px solid var(--border);
  border-bottom: 1px solid var(--border);
  border-left: 3px solid var(--accent);
  padding-block: clamp(40px, 5vw, 64px);
}
.bluf .bluf-lead {
  font-size: 18px;
  line-height: 1.6;
  max-width: 66ch;
  margin: 0;
}
```

**Article column width:** `.article-head .wrap { max-width: 820px; }` (line 128-130) — matches CLAUDE.md's "unify inner-page sections to 820px column" recent commit.

---

### Content collection consumption

**Source:** `site/src/content.config.ts` lines 8-31 (schema definitions) + Phase 2 D-24 flat-path convention.

**Apply to:** Both new templates.

```astro
import { getCollection } from 'astro:content';

export async function getStaticPaths() {
  const entries = await getCollection('services'); // or 'neighborhoods'
  return entries.map((entry) => ({
    params: { service: entry.id },  // entry.id maps to slug from glob loader
    props: { entry },
  }));
}

const { entry } = Astro.props;
const { Content } = await entry.render();
// then in template:
// {entry.data.bluf}, {entry.data.title}, {entry.data.price}, etc.
// <Content /> for markdown body
```

The `entry.id` value is derived by the glob loader from filename (e.g., `services/fades.md` → `entry.id === 'fades'`). For the neighborhood route, filenames are `bostonia.md`/`el-cajon.md`/etc. (no `-barber` suffix in filename — the suffix lives in the route filename per CONTEXT D-01).

---

### Photo import + lazy-load pattern

**Source:** `site/src/components/Visit.astro` lines 1-4 (import) + line 17 (render with `loading="lazy"`).

**Apply to:** Both new templates.

```astro
---
import { Image } from 'astro:assets';
import storefront from '../assets/photos/02-storefront.jpg';
---
<Image src={storefront} alt="..." loading="lazy" />
```

For service hero photos (variable per service via `entry.data.heroPhoto` string), build a static map at the top of frontmatter (Astro requires static imports for the asset pipeline). All 6 photos in `site/src/assets/photos/` are byte-stable per Phase 2 D-13 / Phase 3 carry-forward.

---

### Business data import (NAP / prices / ratings)

**Source:** `site/src/data/business.ts` line 36 typed export + usage examples in `east-county-traditional-barbershop.astro` line 4 + lines 33, 86, 99.

**Apply to:** Both new templates (services use `business.prices.*` + `business.ratings.*`; neighborhoods use `business.address.*` + `business.phone` + `business.hours.*` via the `Visit` component drop-in).

```astro
import { business } from '../data/business';
// then: {business.prices.haircut}, {business.address.street}, {business.phone}, etc.
```

---

### Section-head + section-mark idiom

**Source:** `site/src/pages/east-county-traditional-barbershop.astro` lines 47-54 (and repeated lines 65-72) — the canonical `<section-head>` block used throughout the niche-landing's section transitions.

**Apply to:** Every section in both new templates (areaServed/services-mesh, getting-here, FAQ).

```astro
<div class="section-head">
  <span class="section-mark" aria-hidden="true"></span>
  <div class="section-head-text">
    <span class="eyebrow">{eyebrow text}</span>
    <h2>{Section heading.}</h2>
  </div>
</div>
```

The `.section-head` and `.section-mark` styles live in `site/src/styles/utilities.css` (already imported in `Base.astro` at lines 5-6). No need to redefine in scoped styles.

---

### FAQ inline markup (NOT FAQ.astro component)

**Source:** `site/src/pages/east-county-traditional-barbershop.astro` lines 64-118 — inline `.faq-q` markup pattern that replicates `FAQ.astro` (Phase 3 D-19 inline pattern).

**Apply to:** Both new templates' FAQ sections. The `FAQ.astro` component itself is hardcoded with homepage Q&As — the templated pages render their own variable FAQ markup driven by `entry.data.faqs.map(...)`.

```astro
<section class="faq" aria-label="Frequently asked questions">
  <div class="wrap">
    <div class="section-head">...</div>
    <div class="faq-list">
      {entry.data.faqs.map((faq, i) => (
        <article class="faq-q">
          <span class="num" aria-hidden="true">{String(i + 1).padStart(2, '0')}</span>
          <div>
            <h3>{faq.q}</h3>
            <p>{faq.a}</p>
          </div>
        </article>
      ))}
    </div>
  </div>
</section>
```

Scoped CSS for `.faq-q`, `.num`, `.faq-list` copied from niche-landing lines 242-281.

---

### Closing CTA drop-in

**Source:** `site/src/components/ClosingCTA.astro` (full file) — single-component, no props.

**Apply to:** Both new templates as the last element before `</Base>`.

```astro
<ClosingCTA />
```

---

### Scoped CSS using design tokens

**Source:** All existing component/page `<style>` blocks reference `var(--bg)`, `var(--surface)`, `var(--accent)`, `var(--fg)`, `var(--muted)`, `var(--border)`, `var(--font-display)`, `var(--font-body)`, `var(--font-board)` from `site/src/styles/tokens.css` (imported once in `Base.astro`).

**Apply to:** All scoped `<style>` blocks in new templates and any new neighborhood/service-page bespoke sections (price callout, getting-here, services-mesh).

Do not redefine tokens. Do not add new utility classes — extend `utilities.css` only if a pattern recurs across 3+ pages (planner judgment per CONTEXT specifics).

---

## No Analog Found

| File | Reason |
|------|--------|
| (none) | All 14 files have a strong analog in-tree. The two NEW dynamic-route files have no `[param].astro` precedent in the project, but their composition pattern is fully copyable from `east-county-traditional-barbershop.astro` plus a thin `getStaticPaths` shell from Astro 6 docs (CONTEXT lists this under "Astro / Tooling Docs"). |

---

## Metadata

**Analog search scope:**
- `site/src/pages/` (6 existing pages — niche-landing + cost guide are primary analogs; about contributes Visit-composition pattern)
- `site/src/components/` (12 components — Visit, FAQ, ClosingCTA, CheckDivider, SectionMark are reusable atoms per Phase 3 D-17; PriceBoard provides visual heritage for the new price callout WITHOUT being reused)
- `site/src/content/services/` + `site/src/content/neighborhoods/` (11 stub markdown files — exact frontmatter shape Phase 4 modifies)
- `site/src/content.config.ts` (locked schemas)
- `site/src/layouts/Base.astro` (locked variant prop)
- `site/src/data/business.{ts,json}` (canonical NAP/price source)
- `.planning/phases/03-unique-pages/scripts/audit.sh` (extension target)
- `.planning/phases/03-unique-pages/scripts/canonical-slugs.txt` (verified — all 11 Phase 4 slugs already committed)

**Files scanned:** 14 (full read) + directory listings of `pages/`, `components/`, `content/services/`, `content/neighborhoods/`

**Pattern extraction date:** 2026-05-09

**Key cross-cutting observations for the planner:**
1. **The niche-landing is the single dominant analog.** Both new templates copy 80%+ of their structure (header, BLUF, prose, FAQ, ClosingCTA, scoped CSS) from `east-county-traditional-barbershop.astro`. The deltas are: dynamic-route shell, hero photo (services), price callout (services), getting-here block (neighborhoods), Visit drop-in (neighborhoods), services-mesh block (neighborhoods).
2. **No new component files needed.** Per Phase 3 D-17, all bespoke per-template sections (price callout, getting-here, services-mesh) live as scoped CSS inside the route file, not as new `.astro` components. CONTEXT D-04/D-09 confirm.
3. **`PriceBoard.astro` provides visual heritage but is NOT reused.** The new price callout's CSS echoes `PriceBoard.astro` style block (font-board, board-bg, letter-spacing 0.14em) — it does NOT import the component (homepage-only per Phase 3 D-17).
4. **`Visit.astro` IS reused on neighborhood pages** per CONTEXT D-12 — single drop-in, no props.
5. **The audit script extension is purely additive** — copy the existing `check_*` function idiom for the new 11-slug verification + stub-content check.
