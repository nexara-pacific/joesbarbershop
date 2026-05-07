# Phase 2: Data + Design System — Pattern Map

**Mapped:** 2026-05-07
**Files analyzed:** 33 (14 new components/config/data + 11 content stubs + 6 photos + 4 modified)
**Analogs found:** 5 with existing analogs / 33 total (most files are net-new patterns from mockup + research)

---

## File Classification

| New/Modified File | Role | Data Flow | Closest Analog | Match Quality |
|-------------------|------|-----------|----------------|---------------|
| `site/src/data/business.json` | data | static | none — new pattern | no analog |
| `site/src/data/business.ts` | data/config | static import re-export | none — new pattern | no analog |
| `site/src/content.config.ts` | config | static (build-time schema) | none — new pattern | no analog |
| `site/src/content/services/{slug}.md` ×6 | content entry | static | none — new pattern | no analog |
| `site/src/content/neighborhoods/{slug}.md` ×5 | content entry | static | none — new pattern | no analog |
| `site/src/styles/tokens.css` | config/style | static (cascade) | none — new pattern | no analog |
| `site/src/styles/utilities.css` | utility/style | static (cascade) | none — new pattern | no analog |
| `site/src/components/Hero.astro` | component | request-response (static render) | `site/src/components/Masthead.astro` | role-match |
| `site/src/components/FactStrip.astro` | component | request-response | `site/src/components/UtilBar.astro` | role-match |
| `site/src/components/PriceBoard.astro` | component | request-response | `site/src/components/Masthead.astro` | role-match |
| `site/src/components/Heritage.astro` | component | request-response | `site/src/components/Masthead.astro` | role-match |
| `site/src/components/Visit.astro` | component | request-response | `site/src/components/Masthead.astro` | role-match |
| `site/src/components/FAQ.astro` | component | request-response | `site/src/components/Masthead.astro` | role-match |
| `site/src/components/ClosingCTA.astro` | component | request-response | `site/src/components/UtilBar.astro` | role-match |
| `site/src/components/CheckDivider.astro` | component | static | `site/src/components/UtilBar.astro` | role-match |
| `site/src/components/SectionMark.astro` | component | static | `site/src/components/UtilBar.astro` | role-match |
| `site/src/components/UtilBar.astro` (modify) | component | request-response | itself (stub) | exact |
| `site/src/components/Masthead.astro` (modify) | component | request-response | itself (stub) | exact |
| `site/src/components/Footer.astro` (modify) | component | request-response | itself (stub) | exact |
| `site/src/layouts/Base.astro` (modify) | layout | request-response | itself | exact |
| `site/src/pages/_dev-mockup-parity.astro` | page | request-response | `site/src/pages/index.astro` | role-match |
| `site/src/assets/photos/` ×6 | asset | file-I/O | none — copy operation | n/a |

---

## Pattern Assignments

### Universal: Astro Component Shell

**All 12 `.astro` component files share this shell structure.** The Phase 1 stubs are the reference.

**Analog:** `site/src/components/UtilBar.astro` (lines 1–5) and `site/src/components/Masthead.astro` (lines 1–6)

```astro
---
// [imports go here — astro:assets, ../data/business, etc.]
---
<[root-element] class="[component-class]">
  <!-- markup from mockup -->
</[root-element]>
<style>
  /* component-specific CSS from mockup */
</style>
```

**Rules:**
- Frontmatter fence (`---`) always present even when empty (UtilBar stub pattern, line 1–2)
- Root element carries the component's CSS class (`.util-bar`, `.masthead`, `.hero`, etc.)
- NO `data-phase1-stub` attribute on any new component — that marker is for Phase 1 stubs only
- On modified stubs: remove `data-phase1-stub="..."` attribute when replacing body
- Zero `client:` directives — all components are static

---

### `site/src/layouts/Base.astro` (layout, modify)

**Analog:** `site/src/layouts/Base.astro` (current file, lines 1–28)

**Current state** (lines 1–28):
```astro
---
import UtilBar from '../components/UtilBar.astro';
import Masthead from '../components/Masthead.astro';
import Footer from '../components/Footer.astro';

interface Props {
  title: string;
  description?: string;
}

const { title, description } = Astro.props;
---
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>{title}</title>
    {description && <meta name="description" content={description} />}
    <slot name="head" />
  </head>
  <body>
    <UtilBar />
    <Masthead />
    <main><slot /></main>
    <Footer />
  </body>
</html>
```

**Phase 2 diff — add these imports in frontmatter (after Footer import, before interface):**
```astro
import '../styles/tokens.css';
import '../styles/utilities.css';
```

**Phase 2 diff — add these three `<link>` tags in `<head>` before `<slot name="head" />`:**
```html
<link rel="preconnect" href="https://fonts.googleapis.com" />
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=IM+Fell+English:ital@0;1&family=Playfair+Display:wght@600;800;900&family=DM+Serif+Display:ital@0;1&family=Newsreader:opsz,wght@6..72,400;6..72,500;6..72,600&family=Oswald:wght@500;600;700&family=JetBrains+Mono:wght@500&display=swap" />
```

**WARNING (Pitfall 8):** CSS imports MUST go in the frontmatter `---` block, NOT inside a `<style>` tag. Inside `<style>` would scope and hash-mangle the tokens.

**Section order locked (do not change):** `<UtilBar />` → `<Masthead />` → `<main><slot /></main>` → `<Footer />`

---

### `site/src/styles/tokens.css` (config/style, new)

**No codebase analog — new file. Copy-paste from mockup `<style>` block.**

**Source:** `mockups/home-v5/index.html` lines 37–66, 135–136, 137–142

**Complete content to port (strip `[data-font]` and `[data-checker]` variants — dead code after tweaks removal):**

```css
/* Lines 37–61: CSS custom properties */
:root {
  --bg:        oklch(95% 0.022 80);
  --surface:   oklch(99% 0.008 80);
  --fg:        oklch(15% 0.02 60);
  --muted:     oklch(45% 0.025 50);
  --border:    oklch(86% 0.025 80);
  --hairline:  oklch(80% 0.030 75);
  --accent:    oklch(56% 0.17 28);
  --accent-2:  oklch(36% 0.10 260);
  --gold:      oklch(68% 0.10 80);
  --board-bg:  oklch(13% 0.005 60);
  --board-fg:  oklch(96% 0.005 80);
  --check-fg:  oklch(15% 0.005 60);
  --check-bg:  oklch(96% 0.005 80);
  --font-display-fell:     'IM Fell English', 'Iowan Old Style', Georgia, serif;
  --font-display-playfair: 'Playfair Display', 'Iowan Old Style', Georgia, serif;
  --font-display-dm:       'DM Serif Display', 'Tiempos Headline', Georgia, serif;
  --font-display:          var(--font-display-fell);
  --font-body:  'Newsreader', 'Iowan Old Style', Georgia, serif;
  --font-board: 'Oswald', 'Bebas Neue', 'Arial Narrow', sans-serif;
  --font-mono:  'JetBrains Mono', ui-monospace, Menlo, monospace;
  --maxw: 1240px;
  --gutter: clamp(20px, 4vw, 56px);
}

/* Lines 61–65: Reset and base rules */
*, *::before, *::after { box-sizing: border-box; }
html, body { margin: 0; padding: 0; }
body { background: var(--bg); color: var(--fg); font-family: var(--font-body); font-size: 17px; line-height: 1.55; text-rendering: optimizeLegibility; -webkit-font-smoothing: antialiased; }
img { display: block; max-width: 100%; height: auto; }
a { color: inherit; }

/* Lines 135–136: Global section spacing */
section { padding-block: clamp(56px, 7vw, 96px); position: relative; }
section.tight { padding-block: clamp(40px, 5vw, 64px); }
```

**Strip from tokens.css (tweaks dead code):**
- Lines 67–68: `:root[data-font="playfair"] .display` and `:root[data-font="dm"] .display`
- Lines 74: `:root[data-checker="off"] .check-divider` and `:root[data-checker="subtle"] .check-divider`
- Lines 76: `:root[data-checker="heavy"] .check-divider`
- All other `[data-font]` and `[data-checker]` variant rules

**NOTE:** Google Fonts `<link>` tags go in `Base.astro` `<head>`, NOT as `@import` here (serial round-trip penalty).

---

### `site/src/styles/utilities.css` (utility/style, new)

**No codebase analog — new file. Copy-paste from mockup `<style>` block.**

**Source:** `mockups/home-v5/index.html` lines 66–79, 104–107, 137–142

```css
/* Line 66: display typography */
.display { font-family: var(--font-display); font-weight: 600; line-height: 1.02; letter-spacing: -0.005em; }

/* Lines 69–71: eyebrow and kicker rule */
.eyebrow { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.18em; font-size: 12px; font-weight: 600; color: var(--muted); }
.kicker-rule { display: inline-flex; align-items: center; gap: 12px; }
.kicker-rule::before { content: ""; width: 28px; height: 2px; background: var(--accent); }

/* Line 72: layout wrapper */
.wrap { width: 100%; max-width: var(--maxw); margin: 0 auto; padding-inline: var(--gutter); }

/* Lines 73–77: check-divider (standard mode only — tweaks variants stripped) */
.check-divider { height: 22px; width: 100%; background-image: conic-gradient(from 90deg at 50% 50%, var(--check-fg) 25%, var(--check-bg) 0 50%, var(--check-fg) 0 75%, var(--check-bg) 0); background-size: 22px 22px; }

/* Lines 77–78: section-mark */
.section-mark { width: 22px; height: 22px; border-radius: 999px; background: radial-gradient(circle at 50% 50%, var(--gold) 0 5px, transparent 6px), conic-gradient(from 0deg, var(--check-fg) 0 90deg, var(--check-bg) 0 180deg, var(--check-fg) 0 270deg, var(--check-bg) 0); border: 2px solid var(--check-fg); flex: 0 0 auto; }

/* Lines 104–107: button atom */
.btn { display: inline-flex; align-items: center; gap: 10px; padding: 12px 20px; background: var(--fg); color: var(--bg); font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 12.5px; font-weight: 600; text-decoration: none; border-radius: 0; border: 1px solid var(--fg); transition: background .15s, color .15s; }
.btn:hover { background: var(--accent); border-color: var(--accent); }
.btn.outline { background: transparent; color: var(--fg); }
.btn.outline:hover { background: var(--fg); color: var(--bg); }

/* Lines 137–142: section head layout */
.section-head { display: flex; align-items: center; gap: 14px; margin-bottom: 28px; }
.section-head h2 { font-family: var(--font-display); font-size: clamp(34px, 4vw, 52px); font-weight: 600; line-height: 1.05; letter-spacing: -0.005em; margin: 0; }
.section-head .eyebrow { margin-bottom: 6px; }
.section-head-text { display: flex; flex-direction: column; }
```

**Strip from utilities.css (tweaks dead code):**
- Lines 74: `:root[data-checker="off"]` and `:root[data-checker="subtle"]` variants for `.check-divider`
- Lines 78: `:root[data-checker="off"]` and `:root[data-checker="subtle"]` variants for `.section-mark`
- Lines 139–140: `:root[data-font]` variants for `.section-head h2`

---

### `site/src/components/UtilBar.astro` (component, modify stub)

**Current stub** (`site/src/components/UtilBar.astro` lines 1–5):
```astro
---
---
<div class="util-bar" data-phase1-stub="util-bar">
  <span>(Phase 2: util-bar — phone, hours, walk-ins welcome)</span>
</div>
```

**Replace with (mockup lines 294–305 + CSS from mockup lines 88–91):**
```astro
---
import { business } from '../data/business';
---
<div class="util-bar">
  <div class="wrap">
    <span>Walk-ins welcome</span>
    <span class="util-dot">●</span>
    <span>Family-friendly</span>
    <span class="util-dot">●</span>
    <span>ATM on site</span>
    <span class="util-dot">●</span>
    <span>Tue–Sat · open at 10am</span>
    <span class="util-phone">{business.phone}</span>
  </div>
</div>
<style>
  .util-bar { background: var(--fg); color: var(--bg); font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 12px; font-weight: 500; }
  .util-bar .wrap { display: flex; align-items: center; gap: 28px; padding-block: 9px; flex-wrap: wrap; }
  .util-bar .util-dot { color: var(--accent); font-size: 14px; line-height: 1; }
  .util-bar .util-phone { margin-left: auto; font-weight: 600; letter-spacing: 0.08em; }
  @media (max-width: 600px) {
    .util-bar .wrap { gap: 14px; }
    .util-bar .util-phone { margin-left: 0; }
  }
</style>
```

**Verify:** `data-phase1-stub` attribute removed. `business.phone` renders from data layer.

---

### `site/src/components/Masthead.astro` (component, modify stub)

**Current stub** (`site/src/components/Masthead.astro` lines 1–6):
```astro
---
---
<header class="masthead" data-phase1-stub="masthead">
  <strong>Joe's Barbershop</strong>
  <nav><a href="/">Home</a> <a href="/about">About</a></nav>
</header>
```

**Replace with (mockup lines 307–325 + CSS from mockup lines 92–103):**
```astro
---
import { Image } from 'astro:assets';
import logo from '../assets/photos/01-logo.jpg';
---
<header class="masthead">
  <div class="wrap">
    <a class="brand-lockup" href="/">
      <Image src={logo} width={76} height={76} class="brand-logo" alt="Joe's Barbershop logo — round Western-Victorian wordmark with twin barber poles" />
      <div class="brand-text">
        <div class="name">Joe's Barbershop</div>
        <div class="tag">Bostonia · El Cajon · Estd. 2020</div>
      </div>
    </a>
    <nav class="primary" aria-label="Primary">
      <a href="/about">About</a>
      <a href="/services">Services</a>
      <a href="/east-county-traditional-barbershop">East County</a>
      <a href="/reviews">Reviews</a>
      <a href="/faq">FAQ</a>
    </nav>
    <a href="https://joe-104613.square.site/" target="_blank" rel="noopener" class="btn">Book a chair</a>
  </div>
</header>
<style>
  .masthead { border-bottom: 1px solid var(--border); background: var(--bg); position: relative; z-index: 5; }
  .masthead .wrap { display: grid; grid-template-columns: auto 1fr auto; align-items: center; gap: 28px; padding-block: 18px; }
  .brand-lockup { display: flex; align-items: center; gap: 16px; text-decoration: none; color: inherit; }
  .brand-lockup img { width: 76px; height: 76px; border-radius: 999px; object-fit: cover; }
  .brand-text { line-height: 1.05; }
  .brand-text .name { font-family: var(--font-display); font-size: 24px; font-weight: 700; }
  .brand-text .tag { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.22em; font-size: 10.5px; color: var(--muted); margin-top: 4px; }
  nav.primary { display: flex; justify-content: center; gap: 28px; font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 12.5px; font-weight: 500; }
  nav.primary a { color: var(--fg); text-decoration: none; padding-block: 8px; border-bottom: 2px solid transparent; transition: border-color .15s ease; }
  nav.primary a:hover { border-bottom-color: var(--accent); }
  @media (max-width: 980px) {
    .masthead .wrap { grid-template-columns: 1fr auto; }
    nav.primary { display: none; }
  }
</style>
```

**Pitfall:** `<Image src={logo} />` — `src` must be the imported image object, NOT a string path. `src="../assets/photos/01-logo.jpg"` will throw `ExpectedImage` error.

---

### `site/src/components/Footer.astro` (component, modify stub)

**Current stub** (`site/src/components/Footer.astro` lines 1–4):
```astro
---
---
<footer class="footer" data-phase1-stub="footer">
  <small>(Phase 2: footer — NAP, social, hours)</small>
</footer>
```

**Replace with (mockup lines 655–716 + CSS from mockup lines 205–220, 85–87):**
```astro
---
import { Image } from 'astro:assets';
import logo from '../assets/photos/01-logo.jpg';
import { business } from '../data/business';
---
<div class="footer-checker" aria-hidden="true"></div>
<footer>
  <div class="wrap foot-grid">
    <div class="foot-brand">
      <div class="lockup">
        <Image src={logo} width={56} height={56} class="foot-logo" alt="Joe's Barbershop logo" />
        <div>
          <div class="name">Joe's Barbershop</div>
          <div style="font-family:var(--font-board);text-transform:uppercase;letter-spacing:0.18em;font-size:11px;color:oklch(72% 0.04 80);margin-top:6px;">Estd. 2020 · Bostonia</div>
        </div>
      </div>
      <p>A traditional men's barbershop in Bostonia, El Cajon. Open Tue–Sat. Book a chair online or walk on in. ATM on site.</p>
    </div>
    <!-- Services, East County, Shop columns from mockup lines 672–706 -->
  </div>
  <div class="legal">
    <div class="wrap">
      <span>© 2026 Joe's Barbershop, LLC</span>
      <span>{business.address.street}, {business.address.suite}, {business.address.city} {business.address.state} {business.address.zip}</span>
      <span class="right">{business.phone} · Tue–Sat</span>
    </div>
  </div>
</footer>
<style>
  .footer-checker { height: 60px; width: 100%; background-image: conic-gradient(from 90deg at 50% 50%, var(--check-fg) 25%, var(--check-bg) 0 50%, var(--check-fg) 0 75%, var(--check-bg) 0); background-size: 30px 30px; }
  footer { background: var(--fg); color: var(--bg); padding-top: 0; }
  footer .wrap.foot-grid { display: grid; grid-template-columns: 1.4fr 1fr 1fr 1fr; gap: 40px; padding-block: 56px; }
  footer h4 { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.18em; font-size: 12px; font-weight: 600; color: oklch(72% 0.04 80); margin: 0 0 14px; }
  footer ul { list-style: none; margin: 0; padding: 0; display: flex; flex-direction: column; gap: 10px; font-size: 14.5px; }
  footer a { color: var(--bg); text-decoration: none; border-bottom: 1px solid transparent; transition: border-color .15s; }
  footer a:hover { border-bottom-color: var(--accent); }
  footer .foot-brand { display: flex; flex-direction: column; gap: 16px; }
  footer .foot-brand .lockup { display: flex; align-items: center; gap: 14px; }
  footer .foot-brand .lockup img { width: 56px; height: 56px; border-radius: 999px; object-fit: cover; }
  footer .foot-brand .lockup .name { font-family: var(--font-display); font-size: 20px; font-weight: 700; }
  footer .foot-brand p { margin: 0; color: oklch(78% 0.025 80); font-size: 14.5px; line-height: 1.6; max-width: 38ch; }
  footer .legal { border-top: 1px solid oklch(28% 0.02 60); padding-block: 18px; font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11px; color: oklch(64% 0.025 80); }
  footer .legal .wrap { display: flex; gap: 20px; flex-wrap: wrap; align-items: center; }
  footer .legal .right { margin-left: auto; }
  @media (max-width: 980px) { footer .wrap.foot-grid { grid-template-columns: 1fr 1fr; } }
  @media (max-width: 600px) { footer .wrap.foot-grid { grid-template-columns: 1fr; } }
</style>
```

**Note:** `.footer-checker` div rendered as first child of Footer component (before `<footer>`) per RESEARCH.md §Derived Extras recommendation (never appears elsewhere, no standalone component needed). The `data-phase1-stub` outer class was `.footer` — the real element is `<footer>` (HTML element, no class needed).

---

### `site/src/components/CheckDivider.astro` (component, new)

**Analog:** `site/src/components/UtilBar.astro` (shell pattern)

**Source:** `mockups/home-v5/index.html` line 327 (and lines 414, 502, 635 — same markup)

```astro
---
---
<div class="check-divider" aria-hidden="true"></div>
```

**No scoped `<style>` needed.** `.check-divider` rules live in `utilities.css` (already imported globally via `Base.astro`). This component is a zero-props, zero-JS, one-line render. Used 4 times in the parity page composition.

---

### `site/src/components/SectionMark.astro` (component, new)

**Analog:** `site/src/components/UtilBar.astro` (shell pattern)

**Source:** `mockups/home-v5/index.html` lines 419, 508, 563 (inside `.section-head`)

```astro
---
---
<span class="section-mark" aria-hidden="true"></span>
```

**No scoped `<style>` needed.** `.section-mark` rules live in `utilities.css`. Zero props. Used inside `.section-head` in PriceBoard, Visit, and FAQ components.

---

### `site/src/components/Hero.astro` (component, new)

**Analog:** `site/src/components/Masthead.astro` (component shell + Image import pattern)

**Source markup:** `mockups/home-v5/index.html` lines 329–382
**Source CSS:** `mockups/home-v5/index.html` lines 108–124 (+ responsive at lines 239–240)

**Frontmatter pattern** (from RESEARCH.md §Hero Component Skeleton):
```astro
---
import { Picture } from 'astro:assets';
import heroPhoto from '../assets/photos/03-interior-hero.jpg';
import { business } from '../data/business';
---
```

**Markup core** (mockup lines 329–382, condensed):
```html
<section class="hero" aria-label="Joe's Barbershop in Bostonia">
  <div class="hero-grid">
    <div class="hero-copy">
      <span class="eyebrow kicker-rule">Traditional barbering · since 2020</span>
      <h1 class="display">
        A real cut.<br />
        A real <span class="accent-word">shave.</span><br />
        Walk on in.
      </h1>
      <p class="hero-bluf">...</p>
      <div class="hero-ctas">
        <a class="btn" href="https://joe-104613.square.site/" target="_blank" rel="noopener">Book a chair</a>
        <a class="btn outline" href="#visit">Get directions</a>
      </div>
      <div class="hero-meta">
        <div><strong>Hours</strong> ...</div>
        <div><strong>Address</strong> {business.address.street}, {business.address.suite} / {business.address.city}, {business.address.state} {business.address.zip}</div>
        <div><strong>Payment</strong> Cash · ATM on site</div>
        <div><strong>Rating</strong> {business.ratings.google.value} ★ · {business.ratings.google.count} Google reviews</div>
      </div>
    </div>
    <div class="hero-photo">
      <Picture
        src={heroPhoto}
        formats={['avif', 'webp']}
        alt="Inside Joe's Barbershop — black and white checkerboard tile floor stretching across the shop, three barber chairs along the right wall, mix of vintage black-leather barber chair and modern silver/black quilted chairs, mirrors and counters under bright lighting"
        loading="eager"
        fetchpriority="high"
      />
      <span class="photo-credit">Bostonia · interior of Joe's, three stations.</span>
      <div class="hero-checker-ribbon" aria-hidden="true"></div>
    </div>
  </div>
</section>
```

**Scoped CSS** (mockup lines 108–124 + responsive; strip `[data-font]` variants):
```css
.hero { position: relative; overflow: hidden; border-bottom: 1px solid var(--border); }
.hero-grid { display: grid; grid-template-columns: 1.05fr 1fr; gap: 0; align-items: stretch; }
.hero-copy { padding: clamp(40px, 6vw, 88px) clamp(24px, 4vw, 64px); display: flex; flex-direction: column; justify-content: center; background: var(--bg); position: relative; }
.hero-copy .eyebrow { margin-bottom: 22px; }
.hero-copy h1 { font-family: var(--font-display); font-size: clamp(48px, 6.6vw, 96px); font-weight: 600; line-height: 0.96; letter-spacing: -0.012em; margin: 0 0 22px; color: var(--fg); }
.hero-copy h1 .accent-word { color: var(--accent); }
.hero-bluf { font-size: 18px; line-height: 1.55; color: var(--fg); max-width: 56ch; margin: 0 0 28px; }
.hero-bluf strong { font-weight: 600; }
.hero-ctas { display: flex; flex-wrap: wrap; gap: 14px; margin-bottom: 28px; }
.hero-meta { border-top: 1px solid var(--border); padding-top: 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 16px 28px; font-size: 14px; color: var(--muted); }
.hero-meta strong { display: block; font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.14em; font-size: 11px; color: var(--fg); font-weight: 600; margin-bottom: 4px; }
.hero-photo { position: relative; background: #0e0d0b; min-height: 520px; }
.hero-photo img { width: 100%; height: 100%; object-fit: cover; object-position: center 60%; position: absolute; inset: 0; }
.hero-photo::after { content: ""; position: absolute; inset: 0; background: linear-gradient(180deg, transparent 0%, transparent 60%, rgba(14,13,11,0.35) 100%); pointer-events: none; }
.hero-photo .photo-credit { position: absolute; left: 16px; bottom: 16px; font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.18em; font-size: 11px; color: var(--bg); opacity: 0.78; z-index: 2; font-weight: 500; }
/* hero-checker-ribbon: port standard mode as unconditional (tweaks stripped) */
.hero-checker-ribbon { position: absolute; inset: auto 0 0 auto; width: 220px; height: 28px; background-image: conic-gradient(from 90deg at 50% 50%, var(--check-fg) 25%, var(--check-bg) 0 50%, var(--check-fg) 0 75%, var(--check-bg) 0); background-size: 28px 28px; pointer-events: none; }
@media (max-width: 980px) {
  .hero-grid { grid-template-columns: 1fr; }
  .hero-photo { min-height: 380px; }
}
```

**`fetchpriority` note:** This is a plain HTML attribute, not an Astro prop. Pass it directly on the `<Picture>` element as shown above.

---

### `site/src/components/FactStrip.astro` (component, new)

**Analog:** `site/src/components/UtilBar.astro` (shell pattern — no imports needed)

**Source markup:** `mockups/home-v5/index.html` lines 384–412
**Source CSS:** `mockups/home-v5/index.html` lines 125–134 (+ responsive at lines 241–243)

**Shell pattern:**
```astro
---
import { business } from '../data/business';
---
<section class="fact-strip tight" aria-label="Quick facts">
  <div class="wrap">
    <div class="fact">
      <span class="label">Established</span>
      <span class="value">2020</span>
      <span class="sub">Five years on Bradley Ave.</span>
    </div>
    <div class="fact">
      <span class="label">Google rating</span>
      <span class="value"><span class="star">★</span> {business.ratings.google.value}</span>
      <span class="sub">{business.ratings.google.count} reviews · Yelp {business.ratings.yelp.value}</span>
    </div>
    <div class="fact">
      <span class="label">Neighborhood</span>
      <span class="value">Bostonia</span>
      <span class="sub">East County · El Cajon CA</span>
    </div>
    <div class="fact">
      <span class="label">Walk-ins</span>
      <span class="value">Always</span>
      <span class="sub">No appointment required.</span>
    </div>
    <div class="fact">
      <span class="label">Barbers</span>
      <span class="value">Joe + Alex</span>
      <span class="sub">Three chairs, two cutters.</span>
    </div>
  </div>
</section>
<style>
  .fact-strip { background: var(--surface); border-bottom: 1px solid var(--border); }
  .fact-strip .wrap { display: grid; grid-template-columns: repeat(5, 1fr); gap: 0; padding-block: 0; }
  .fact { padding: 22px 18px; border-right: 1px solid var(--border); display: flex; flex-direction: column; gap: 6px; }
  .fact:last-child { border-right: 0; }
  .fact .label { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 10.5px; color: var(--muted); font-weight: 600; }
  .fact .value { font-family: var(--font-display); font-size: 22px; font-weight: 600; line-height: 1.1; }
  .fact .value .star { color: var(--accent); }
  .fact .sub { font-size: 13.5px; color: var(--muted); }
  @media (max-width: 980px) {
    .fact-strip .wrap { grid-template-columns: repeat(2, 1fr); }
    .fact { border-right: 0; border-top: 1px solid var(--border); }
    .fact:nth-child(odd) { border-right: 1px solid var(--border); }
  }
</style>
```

---

### `site/src/components/PriceBoard.astro` (component, new)

**Analog:** `site/src/components/Masthead.astro` (shell with `.wrap` inner div + `<style>` block)

**Source markup:** `mockups/home-v5/index.html` lines 416–458
**Source CSS:** `mockups/home-v5/index.html` lines 143–158 (+ responsive at line 244, 252–253)

**Frontmatter:**
```astro
---
import { business } from '../data/business';
---
```

**Markup pattern** (uses `<SectionMark />` component, `.section-head` from utilities.css):
```html
<section class="price-section" id="prices" aria-label="Service prices">
  <div class="wrap">
    <div class="section-head">
      <span class="section-mark" aria-hidden="true"></span>
      <div class="section-head-text">
        <span class="eyebrow">The board · what it costs</span>
        <h2>Posted prices.<br />Same as the wall.</h2>
      </div>
    </div>
    <div class="price-grid">
      <div class="price-board" aria-label="Service prices — letter board">
        <div class="head">Joe's Barbershop</div>
        <ul>
          <li><span>Haircut</span><span class="dots"></span><span class="num">{business.prices.haircut}</span></li>
          <li><span>Shave</span><span class="dots"></span><span class="num">{business.prices.shave}</span></li>
          <li><span>Beard line-up</span><span class="dots"></span><span class="num">{business.prices.beardLineUp}</span></li>
          <li><span>Clean up</span><span class="dots"></span><span class="num">{business.prices.cleanUp}</span></li>
          <li><span>Haircut + beard</span><span class="dots"></span><span class="num">{business.prices.haircutBeard}</span></li>
        </ul>
        <div class="foot"><span class="red">Cash only</span> · ATM on site</div>
      </div>
      <div class="price-aside">
        <!-- aside copy from mockup lines 439–455 -->
      </div>
    </div>
  </div>
</section>
```

**Scoped CSS** (mockup lines 143–158; strip `[data-font]` variants):
```css
.price-section { background: var(--bg); }
.price-grid { display: grid; grid-template-columns: 1.1fr 1fr; gap: clamp(28px, 4vw, 64px); align-items: start; }
.price-board { background: var(--board-bg); color: var(--board-fg); padding: 36px 32px 40px; border: 8px solid #2a2418; box-shadow: inset 0 0 0 2px rgba(255,255,255,0.04), 0 24px 40px -24px rgba(0,0,0,0.35); background-image: repeating-linear-gradient(0deg, rgba(255,255,255,0.012) 0 1px, transparent 1px 6px), repeating-linear-gradient(90deg, rgba(255,255,255,0.012) 0 1px, transparent 1px 6px); font-family: var(--font-board); font-weight: 600; text-transform: uppercase; letter-spacing: 0.10em; }
.price-board .head { text-align: center; border-bottom: 1px solid rgba(255,255,255,0.16); padding-bottom: 16px; margin-bottom: 16px; font-size: 22px; letter-spacing: 0.22em; }
.price-board ul { list-style: none; margin: 0; padding: 0; }
.price-board li { display: flex; align-items: baseline; justify-content: space-between; padding-block: 10px; font-size: 26px; letter-spacing: 0.14em; border-bottom: 1px dashed rgba(255,255,255,0.08); }
.price-board li:last-child { border-bottom: 0; }
.price-board li .dots { flex: 1; margin-inline: 14px; border-bottom: 2px dotted rgba(255,255,255,0.18); transform: translateY(-6px); }
.price-board li .num { font-family: var(--font-board); font-weight: 600; color: var(--board-fg); }
.price-board .foot { margin-top: 22px; padding-top: 18px; border-top: 1px solid rgba(255,255,255,0.16); text-align: center; font-size: 16px; letter-spacing: 0.28em; color: oklch(80% 0.04 80); }
.price-board .foot .red { color: oklch(72% 0.18 28); font-weight: 700; }
.price-aside h3 { font-family: var(--font-display); font-size: 32px; font-weight: 600; line-height: 1.1; margin: 0 0 14px; letter-spacing: -0.005em; }
.price-aside p { margin: 0 0 14px; color: var(--fg); font-size: 17px; line-height: 1.6; }
.price-aside .quote { border-left: 3px solid var(--accent); padding: 4px 0 4px 18px; margin: 24px 0 0; font-style: italic; color: var(--muted); font-size: 15.5px; }
@media (max-width: 980px) { .price-grid { grid-template-columns: 1fr; } }
@media (max-width: 600px) {
  .price-board li { font-size: 20px; }
  .price-board .head { font-size: 18px; letter-spacing: 0.18em; }
}
```

---

### `site/src/components/Heritage.astro` (component, new)

**Source markup:** `mockups/home-v5/index.html` lines 460–500
**Source CSS:** `mockups/home-v5/index.html` lines 159–171 (+ responsive line 245, 254–256)

**Frontmatter:**
```astro
---
import { Image } from 'astro:assets';
import heritagePhoto from '../assets/photos/04-heritage-chair.jpg';
---
```

**Cross-component CSS note (D-09 Case 1):** `.heritage-frame` has a `[data-checker="heavy"]` rule at mockup line 84. Since tweaks panel is stripped (D-10), this rule is dead code — omit entirely. Port `.heritage-frame` as a plain `<div>` wrapper with no special CSS needed.

**Scoped CSS** (mockup lines 159–171; strip `[data-font]` variants and `[data-checker]` heritage-frame variant):
```css
.heritage { background: var(--surface); border-top: 1px solid var(--border); border-bottom: 1px solid var(--border); }
.heritage-grid { display: grid; grid-template-columns: 1fr 1.05fr; gap: clamp(28px, 4vw, 72px); align-items: center; }
.heritage-photo { position: relative; }
.heritage-photo img { width: 100%; aspect-ratio: 4 / 5; object-fit: cover; display: block; }
.heritage-copy h2 { font-family: var(--font-display); font-size: clamp(38px, 4.4vw, 60px); font-weight: 600; line-height: 1.02; letter-spacing: -0.006em; margin: 14px 0 22px; }
.heritage-copy p { font-size: 17.5px; line-height: 1.65; margin: 0 0 14px; max-width: 60ch; }
.heritage-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top: 32px; border-top: 1px solid var(--border); padding-top: 24px; }
.heritage-stats .stat .num { font-family: var(--font-display); font-size: 40px; font-weight: 600; line-height: 1; letter-spacing: -0.01em; color: var(--accent); }
.heritage-stats .stat .label { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11px; color: var(--muted); font-weight: 600; margin-top: 6px; }
@media (max-width: 980px) { .heritage-grid { grid-template-columns: 1fr; } }
@media (max-width: 600px) {
  .heritage-stats { grid-template-columns: 1fr 1fr; }
  .heritage-stats .stat:last-child { grid-column: span 2; }
}
```

---

### `site/src/components/Visit.astro` (component, new)

**Source markup:** `mockups/home-v5/index.html` lines 504–557
**Source CSS:** `mockups/home-v5/index.html` lines 172–184 (+ responsive line 245)

**Frontmatter:**
```astro
---
import { Image } from 'astro:assets';
import storefront from '../assets/photos/02-storefront.jpg';
import { business } from '../data/business';
---
```

**Scoped CSS** (mockup lines 172–184):
```css
.visit { background: var(--bg); }
.visit-grid { display: grid; grid-template-columns: 1fr 1fr; gap: clamp(28px, 4vw, 64px); align-items: stretch; }
.visit-photo { position: relative; overflow: hidden; }
.visit-photo img { width: 100%; aspect-ratio: 4 / 3; object-fit: cover; object-position: center 50%; }
.visit-card { padding: 32px 36px; border: 1px solid var(--border); background: var(--surface); display: flex; flex-direction: column; gap: 22px; }
.visit-card h3 { font-family: var(--font-display); font-size: 38px; font-weight: 600; line-height: 1.05; letter-spacing: -0.005em; margin: 0; }
.nap dl { margin: 0; display: grid; grid-template-columns: 130px 1fr; gap: 14px 20px; }
.nap dt { font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.16em; font-size: 11px; font-weight: 600; color: var(--muted); align-self: start; padding-top: 4px; }
.nap dd { margin: 0; font-size: 16px; line-height: 1.5; }
.nap dd strong { font-weight: 600; }
.nap dd .mono { font-family: var(--font-mono); font-size: 14px; color: var(--muted); display: block; margin-top: 2px; letter-spacing: 0.04em; }
@media (max-width: 980px) { .visit-grid { grid-template-columns: 1fr; } }
```

---

### `site/src/components/FAQ.astro` (component, new)

**Source markup:** `mockups/home-v5/index.html` lines 559–633
**Source CSS:** `mockups/home-v5/index.html` lines 185–194

**Frontmatter:** No imports needed (static content, no photos, no business data).

```astro
---
---
```

**Scoped CSS** (mockup lines 185–194; strip `[data-font]` variants):
```css
.faq { background: var(--surface); border-top: 1px solid var(--border); }
.faq-list { display: grid; grid-template-columns: 1fr; gap: 32px; max-width: 980px; }
.faq-q { padding-top: 22px; border-top: 1px solid var(--border); display: grid; grid-template-columns: 60px 1fr; gap: 32px; }
.faq-q .num { font-family: var(--font-display); font-size: 28px; font-weight: 600; color: var(--accent); line-height: 1; }
.faq-q h3 { font-family: var(--font-display); font-size: clamp(22px, 2.2vw, 28px); font-weight: 600; line-height: 1.2; letter-spacing: -0.005em; margin: 0 0 12px; }
.faq-q p { margin: 0; font-size: 16.5px; line-height: 1.6; color: var(--fg); max-width: 70ch; }
```

---

### `site/src/components/ClosingCTA.astro` (component, new)

**Source markup:** `mockups/home-v5/index.html` lines 637–653
**Source CSS:** `mockups/home-v5/index.html` lines 195–204

**Frontmatter:**
```astro
---
import { business } from '../data/business';
---
```

**Scoped CSS** (mockup lines 195–204; strip `[data-font]` variants):
```css
.closing-cta { background: var(--bg); border-top: 1px solid var(--border); text-align: center; padding-block: clamp(64px, 8vw, 112px); }
.closing-cta .eyebrow.kicker-rule { margin-bottom: 22px; justify-content: center; }
.closing-cta .eyebrow.kicker-rule::before { display: none; }
.closing-cta .eyebrow.kicker-rule::after { content: ""; width: 28px; height: 2px; background: var(--accent); display: inline-block; margin-left: 4px; }
.closing-heading { font-family: var(--font-display); font-size: clamp(40px, 5vw, 68px); font-weight: 600; line-height: 1.02; letter-spacing: -0.008em; margin: 0 auto 22px; max-width: 18ch; }
.closing-sub { font-size: 18px; line-height: 1.6; color: var(--fg); max-width: 56ch; margin: 0 auto 32px; }
.closing-ctas { display: flex; gap: 14px; justify-content: center; flex-wrap: wrap; margin-bottom: 22px; }
.closing-trust { margin: 0; font-family: var(--font-board); text-transform: uppercase; letter-spacing: 0.18em; font-size: 11.5px; font-weight: 600; color: var(--muted); }
```

---

### `site/src/content.config.ts` (config, new)

**No codebase analog — new file. Use RESEARCH.md §Code Examples verbatim.**

**CRITICAL:** File path is `site/src/content.config.ts` — NOT `site/src/content/config.ts`. The latter throws `LegacyContentConfigError` in Astro 6.3.0.

```typescript
// site/src/content.config.ts
// NOTE: This file is at src/content.config.ts — NOT src/content/config.ts (Astro 6 requirement)
import { defineCollection } from 'astro:content';
import { z } from 'astro/zod';
import { glob } from 'astro/loaders';

const services = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/services' }),
  schema: z.object({
    title: z.string(),
    price: z.number(),
    duration: z.string(),
    bluf: z.string(),
    faqs: z.array(z.object({ q: z.string(), a: z.string() })),
    heroPhoto: z.string().optional(),
  }),
});

const neighborhoods = defineCollection({
  loader: glob({ pattern: '**/*.md', base: './src/content/neighborhoods' }),
  schema: z.object({
    title: z.string(),
    landmarks: z.array(z.string()),
    distance: z.string(),
    bluf: z.string(),
    faqs: z.array(z.object({ q: z.string(), a: z.string() })),
  }),
});

export const collections = { services, neighborhoods };
```

**Pitfalls:**
- Import `z` from `'astro/zod'` — NOT `'zod'` (may not be installed)
- Each `defineCollection` MUST include `loader:` — omitting it throws in Astro 6
- `slug` is NOT a schema field — it comes from `entry.id` (derived from filename)

---

### `site/src/content/services/{slug}.md` ×6 (content stubs, new)

**Files:** `fades.md`, `kids-cuts.md`, `beard-trim.md`, `hot-towel-shave.md`, `line-up.md`, `classic-cut.md`

**Pattern** (from RESEARCH.md §Stub Service Entry):
```markdown
---
title: "Fades"
price: 30
duration: "30 min"
bluf: "Joe's Barbershop offers fade haircuts in Bostonia, El Cajon. Haircut $30. Walk-ins welcome."
faqs: []
heroPhoto: "05-mid-cut.jpg"
---

Stub content — Phase 3 replaces with AEO-optimized prose and FAQs.
```

**All 6 service slugs and prices** (from RESEARCH.md DATA-03 + business.json):
| File | title | price | duration | heroPhoto |
|------|-------|-------|----------|-----------|
| `fades.md` | "Fades" | 30 | "30 min" | "05-mid-cut.jpg" |
| `classic-cut.md` | "Classic Cut" | 30 | "30 min" | "05-mid-cut.jpg" |
| `kids-cuts.md` | "Kids Cuts" | 30 | "30 min" | (omit — optional) |
| `beard-trim.md` | "Beard Trim" | 20 | "20 min" | (omit) |
| `line-up.md` | "Line-Up" | 20 | "20 min" | (omit) |
| `hot-towel-shave.md` | "Hot-Towel Shave" | 30 | "30 min" | (omit) |

`faqs: []` is valid — schema has no minimum. Phase 3/4 fills real FAQs. Schema enforces shape not quality (D-17).

---

### `site/src/content/neighborhoods/{slug}.md` ×5 (content stubs, new)

**Files:** `bostonia.md`, `el-cajon.md`, `santee.md`, `lakeside.md`, `la-mesa.md`

**Pattern** (from RESEARCH.md §Stub Neighborhood Entry):
```markdown
---
title: "Bostonia Barber"
landmarks: ["Bostonia area", "East County San Diego"]
distance: "local"
bluf: "Joe's Barbershop is the traditional barbershop serving Bostonia in El Cajon, East County San Diego."
faqs: []
---

Stub content — Phase 4 replaces with AEO-optimized neighborhood-specific prose.
```

**All 5 neighborhood slugs** (from RESEARCH.md DATA-04 + `inputs/01-page-list.md` context):
| File | title | distance |
|------|-------|----------|
| `bostonia.md` | "Bostonia Barber" | "local" |
| `el-cajon.md` | "El Cajon Barber" | "0.5 mi from shop" |
| `santee.md` | "Santee Barber" | "7 mi from shop" |
| `lakeside.md` | "Lakeside Barber" | "8 mi from shop" |
| `la-mesa.md` | "La Mesa Barber" | "9 mi from shop" |

Phase 4 fills real landmarks from `aeo-playbook-smb.md` and Joe's local knowledge.

---

### `site/src/data/business.json` (data, new)

**No codebase analog — new file. Use RESEARCH.md §Code Examples verbatim with executor-confirmed hours.**

**EXECUTOR ACTION REQUIRED before writing this file:** Read current GBP listing and confirm Saturday close time. Vault says 19:30; mockup shows 18:30. Do not commit until hours confirmed.

**Pattern** (RESEARCH.md lines 729–777 — copy verbatim, confirm hours first):
```json
{
  "name": "Joe's Barbershop",
  "address": {
    "street": "723 E Bradley Ave",
    "suite": "#C",
    "city": "El Cajon",
    "state": "CA",
    "zip": "92021"
  },
  "phone": "(619) 891-2775",
  "hours": {
    "tuesday":   { "open": "10:00", "close": "18:30" },
    "wednesday": { "open": "10:00", "close": "18:30" },
    "thursday":  { "open": "10:00", "close": "19:30" },
    "friday":    { "open": "10:00", "close": "19:30" },
    "saturday":  { "open": "10:00", "close": "??:??" },
    "sunday":    null,
    "monday":    null
  },
  "prices": {
    "haircut":      30,
    "shave":        30,
    "beardLineUp":  20,
    "cleanUp":      15,
    "haircutBeard": 50,
    "kidsCut":      null
  },
  "ratings": {
    "google": { "value": 4.9, "count": 91, "asOf": "2026-05-07" },
    "yelp":   { "value": 4.9, "count": 33, "asOf": "2026-05-07" }
  },
  "sameAs": {
    "gbp":       "https://www.google.com/maps/place/Joes-Barbershop-El-Cajon",
    "yelp":      "https://www.yelp.com/biz/joes-barbershop-el-cajon",
    "instagram": "https://www.instagram.com/joes_barbershop_el_cajon",
    "facebook":  ""
  },
  "photos": {
    "logo":       "01-logo.jpg",
    "storefront": "02-storefront.jpg",
    "hero":       "03-interior-hero.jpg",
    "heritage":   "04-heritage-chair.jpg",
    "midCut":     "05-mid-cut.jpg",
    "priceBoard": "06-price-board-cash-only.jpg"
  },
  "areaServed": ["El Cajon", "Bostonia", "Santee", "Lakeside", "La Mesa"]
}
```

---

### `site/src/data/business.ts` (data/config, new)

**No codebase analog — new file. Copy from RESEARCH.md §Business TypeScript Re-export.**

```typescript
// site/src/data/business.ts
// Source: https://docs.astro.build/en/guides/imports/#json
import businessData from './business.json';

interface HoursEntry {
  open: string;
  close: string;
}

interface BusinessRecord {
  name: string;
  address: {
    street: string;
    suite: string;
    city: string;
    state: string;
    zip: string;
  };
  phone: string;
  hours: Record<string, HoursEntry | null>;
  prices: {
    haircut: number;
    shave: number;
    beardLineUp: number;
    cleanUp: number;
    haircutBeard: number;
    kidsCut: number | null;
  };
  ratings: Record<string, { value: number; count: number; asOf: string }>;
  sameAs: Record<string, string>;
  photos: Record<string, string>;
  areaServed: string[];
}

export const business = businessData as BusinessRecord;
```

**Consumer pattern in any component:**
```astro
---
import { business } from '../data/business';
---
```
Access: `business.phone`, `business.address.city`, `business.prices.haircut`, `business.ratings.google.value`.

---

### `site/src/pages/_dev-mockup-parity.astro` (page, new)

**Analog:** `site/src/pages/index.astro` (layout import pattern, lines 1–7)

**Pattern** (RESEARCH.md §The Scratch Page):
```astro
---
// DEV-ONLY SCRATCH PAGE — Phase 2 parity check. Not a production page.
// Phase 3 replaces index.astro with the real homepage; this page can be deleted then.
import Base from '../layouts/Base.astro';
import UtilBar from '../components/UtilBar.astro';
import Masthead from '../components/Masthead.astro';
import CheckDivider from '../components/CheckDivider.astro';
import Hero from '../components/Hero.astro';
import FactStrip from '../components/FactStrip.astro';
import PriceBoard from '../components/PriceBoard.astro';
import Heritage from '../components/Heritage.astro';
import Visit from '../components/Visit.astro';
import FAQ from '../components/FAQ.astro';
import ClosingCTA from '../components/ClosingCTA.astro';
---
<Base title="[DEV] Mockup Parity — Joe's Barbershop">
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

**Note:** `UtilBar`, `Masthead`, and `Footer` render via `Base.astro` — do NOT re-import or re-render them inside the page slot. `CheckDivider` appears 4 times matching the mockup's 4 instances (lines 327, 414, 502, 635).

---

### `site/src/assets/photos/` ×6 (assets, copy)

**No analog — copy operation.**

**Source → Destination:**
```
inputs/photos/01-logo.jpg              → site/src/assets/photos/01-logo.jpg
inputs/photos/02-storefront.jpg        → site/src/assets/photos/02-storefront.jpg
inputs/photos/03-interior-hero.jpg     → site/src/assets/photos/03-interior-hero.jpg
inputs/photos/04-heritage-chair.jpg    → site/src/assets/photos/04-heritage-chair.jpg
inputs/photos/05-mid-cut.jpg           → site/src/assets/photos/05-mid-cut.jpg
inputs/photos/06-price-board-cash-only.jpg → site/src/assets/photos/06-price-board-cash-only.jpg
```

**Copy command:** `cp inputs/photos/* site/src/assets/photos/`

Do NOT use `site/public/photos/` — `<Image />` only processes `src/`-based assets. Files in `public/` are served verbatim and break Phase 5 AVIF/WebP targets.

---

## Shared Patterns

### Image Import Pattern
**Source:** RESEARCH.md §Import Pattern in Components (verified against Astro 6 docs)
**Apply to:** Masthead.astro, Hero.astro, Heritage.astro, Visit.astro, Footer.astro

```astro
---
import { Image, Picture } from 'astro:assets';
import heroPhoto from '../assets/photos/03-interior-hero.jpg';
---
```

`src` must always be the **imported image object** — never a string path. String paths throw `ExpectedImage` error.

| Component | Import | Component | Key Attributes |
|-----------|--------|-----------|----------------|
| Hero | `import heroPhoto from '../assets/photos/03-interior-hero.jpg'` | `<Picture>` | `formats={['avif','webp']}` `loading="eager"` `fetchpriority="high"` |
| Masthead | `import logo from '../assets/photos/01-logo.jpg'` | `<Image>` | `width={76}` `height={76}` `loading="eager"` |
| Heritage | `import heritagePhoto from '../assets/photos/04-heritage-chair.jpg'` | `<Image>` | `loading="lazy"` |
| Visit | `import storefront from '../assets/photos/02-storefront.jpg'` | `<Image>` | `loading="lazy"` |
| Footer | `import logo from '../assets/photos/01-logo.jpg'` | `<Image>` | `width={56}` `height={56}` `loading="lazy"` |

### Business Data Import Pattern
**Source:** `site/src/data/business.ts` (new — pattern defined above)
**Apply to:** UtilBar.astro, Hero.astro, FactStrip.astro, PriceBoard.astro, Visit.astro, ClosingCTA.astro, Footer.astro

```astro
---
import { business } from '../data/business';
---
```

### Tweaks Panel Strip — Three Layers
**Apply to:** Every file. No exceptions.
**Verification after all components written:**
```bash
grep -r "tweaks" site/src/           # expect 0 matches
grep -r 'data-font\|data-checker' site/src/   # expect 0 matches
grep -r 'applyFont\|applyCheck\|toggleTweaks' site/src/   # expect 0 matches
grep -r 'data-phase1-stub' site/src/    # expect 0 matches (D-05)
```

**Dead CSS rules to strip from every component's `<style>` during port:**
- Any selector containing `[data-font="playfair"]` or `[data-font="dm"]`
- Any selector containing `[data-checker="off"]`, `[data-checker="subtle"]`, `[data-checker="heavy"]`
- Exception: port `[data-checker="standard"]` patterns as the **unconditional** base rule (drop the selector wrapper, keep the CSS value)

### CSS Import Pattern (Base.astro only)
**Source:** RESEARCH.md §Base.astro with tokens.css + utilities.css imports
**Apply to:** `site/src/layouts/Base.astro` frontmatter ONLY

```astro
import '../styles/tokens.css';
import '../styles/utilities.css';
```

These must be in the `---` frontmatter block. NOT in a `<style>` tag (would scope/mangle them).

### Scoped Style in Astro
**Source:** Phase 1 SUMMARY (01-03-SUMMARY.md), RESEARCH.md Pitfall 6
**Apply to:** All 12 component `.astro` files

```astro
<style>
  /* Selectors here are auto-scoped to this component by Astro's hash */
  .component-class { ... }
</style>
```

Styles in parent components do NOT cross into child component elements (Astro hash boundary). Shared utilities MUST live in `utilities.css` (globally imported, bypasses scoping).

---

## No Analog Found

Files with no close match in the codebase (patterns come from RESEARCH.md and mockup directly):

| File | Role | Data Flow | Reason |
|------|------|-----------|--------|
| `site/src/data/business.json` | data | static | First JSON data file in project |
| `site/src/data/business.ts` | data | static | First typed re-export in project |
| `site/src/content.config.ts` | config | build-time | First content collection config |
| `site/src/content/services/*.md` | content | build-time | First content collection entries |
| `site/src/content/neighborhoods/*.md` | content | build-time | First content collection entries |
| `site/src/styles/tokens.css` | style | cascade | First CSS file in project |
| `site/src/styles/utilities.css` | style | cascade | First CSS file in project |

All seven are bootstrapping patterns. The planner should use the verbatim code excerpts from this document (sourced from RESEARCH.md §Code Examples) as the authoritative starting point.

---

## Metadata

**Analog search scope:** `site/src/components/`, `site/src/layouts/`, `site/src/pages/`
**Files scanned:** 6 (all Phase 1 artifacts: Base.astro, UtilBar.astro, Masthead.astro, Footer.astro, index.astro, about.astro)
**Mockup scanned:** `mockups/home-v5/index.html` (lines 37–716, skipping tweaks script 718–822)
**Pattern extraction date:** 2026-05-07
