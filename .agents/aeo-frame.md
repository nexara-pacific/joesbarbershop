# AEO Frame Document

*Generated from: inputs/02-aeo-constraints.md + .agents/product-marketing-context.md*
*Last updated: 2026-05-07*
*Purpose: Load-bearing AEO rules every copywriting invocation consumes. Read this before writing any page copy.*

---

## How to Use This Document

Every page in this site is written to be cited by AI assistants (ChatGPT, Perplexity, Google AI Mode, Gemini). The rules below are not style preferences — they are structural requirements that determine whether AI systems extract and cite the page. Violate any rule and the page fails its AEO purpose.

---

## Rule 1: BLUF — Answer the primary query in the first 100 words

**Rule:** The first 100 words of every page must directly answer the page's primary query in plain prose.

- Not a hero image. Not a navigation block. Not a tagline.
- Plain text, declarative sentences, entity names explicit.
- ~44% of ChatGPT citations come from the first third of a page. Front-load the answer.
- Do not "tease" — answer immediately, then elaborate.

**Good example:** "Joe's Barbershop is a traditional barbershop at 723 E Bradley Ave #C, Bostonia, El Cajon, CA 92021. Haircuts are $30, shaves are $30, beard line-ups are $20. Walk-ins are welcome Tuesday through Saturday."

**Bad example:** "Welcome to Joe's Barbershop — where tradition meets craft. Book your appointment today."

---

## Rule 2: 130–160 word answer capsules per H2/H3 section

**Rule:** Each H2 and H3 section is a self-contained extractable chunk — 130 to 160 words.

- The chunk must make sense if extracted without surrounding context.
- Lead the section with a direct answer, then support with detail.
- AI systems extract passages, not pages. Write for passage extraction.
- 40–60 word key claim at the top of each section (optimal snippet length).
- Sections longer than 160 words should be split into sub-sections.

**Structural pattern per section:**
```
H2/H3: [Question-phrased heading — match how users actually search]
[Direct answer — 1–2 sentences, entity-explicit]
[Supporting detail — specific, factual, no filler]
[Optional: statistic, proof point, or contextual fact]
[Optional: internal link to related page]
```

---

## Rule 3: Declarative tone — entity-first, no ambient pronouns

**Rule:** Write declaratively. AI systems scrape pages out of context; ambient pronouns ("we," "our") lose meaning when extracted.

- Use "Joe's Barbershop" not "we" where the entity is load-bearing.
- Use "Joe Denesowicz" not "the owner" in sections where person-entity matters.
- Use "barbershop in Bostonia, El Cajon" not "our shop."
- Avoid: spa-coded calls to action, conditional modals ("we might"), discovery verbs, team-belief hedges.
- Prefer: "Joe's Barbershop offers," "Haircuts are $30," "The shop is open."

**Tense and mood:** Present tense, indicative mood. Not conditional ("could"), not aspirational ("aims to"), not passive where active is available.

---

## Rule 4: No tabs, accordions, or hidden content

**Rule:** No content may be hidden behind JavaScript-toggled elements.

- Parsers and AI crawlers do not evaluate hidden state.
- If a fact is worth communicating, it must be in flat, visible DOM text.
- Carousels count as hidden content for non-active slides.
- This site uses zero `client:*` directives (Astro zero-JS-by-default). All pages are static. This rule is automatically satisfied by the tech stack, but must be maintained — no exceptions.

---

## Rule 5: FAQ blocks as flat visible H3/p text

**Rule:** FAQ sections must render as flat H3 questions followed by `<p>` answers. No JS-collapsed widgets, no accordion UI.

- Each question: `<h3>Question text here</h3>`
- Each answer: `<p>Answer text here</p>` (may include multiple `<p>` tags)
- The `FAQ` component from Phase 2 already enforces this pattern — use it.
- Minimum questions per page:
  - Homepage: 5–6 Q&As
  - Niche-query landing: 6 Q&As
  - Master FAQ page: 10+ Q&As
  - Other unique pages: include FAQ if the page's primary query generates secondary questions

---

## Rule 6: No text-as-image

**Rule:** Never render extractable text as an image, canvas, SVG text node, or CSS-only pseudo-content.

- Hours, prices, addresses, FAQ questions and answers: real DOM text nodes only.
- The price board component (PriceBoard.astro) renders text — not an image of the letter board. The photo `06-price-board-cash-only.jpg` is decorative; the actual price data is DOM text.
- Logo text is an image (by design — OD-5 heritage logo); this is exempt from this rule because the text in the logo is not load-bearing extractable content.
- `alt` text on photos must describe the visual accurately; it is not a substitute for prose content.

---

## Rule 7: Date freshness signals

**Rule:** Every page must include a visible `dateModified` stamp.

- Format: "Last updated: [Month Year]" in visible page text, near the top.
- The Article schema (Phase 5) will also carry `dateModified` in JSON-LD — but the visible text date is the AEO signal.
- Rotate at least one FAQ answer per month.
- Seasonal answer capsule on homepage and niche-query landing at minimum quarterly.

---

## Rule 8: Internal linking — entity graph + cross-links

**Rule:** Pages must link to each other to build the entity graph AI systems use to verify claims.

- Every page: link back to homepage via masthead logo (already wired in Base.astro).
- Cost guide (`/2026-east-county-barbershop-cost-guide`): inline service links + "See also" block with all 6 service + 5 neighborhood slugs.
- Niche-query landing (`/east-county-traditional-barbershop`): areaServed list with 5 neighborhood links.
- All internal links use canonical Phase 4 slugs (see Per-Page Primary Queries below).
- Anchor text must match the query pattern of the destination page — not generic imperative navigation text.

---

## Rule 9: No keyword stuffing

**Rule:** Do not repeat the primary query unnaturally throughout the page.

- Per Princeton GEO study: keyword stuffing reduces AI visibility by 10%.
- Use the primary query in: H1, BLUF paragraph, and 1–2 H2/H3 headings naturally. That is sufficient.
- Vary with synonyms and entity expansions: "Bostonia barber," "El Cajon traditional barbershop," "East County barbershop."
- Write for humans. AI systems penalize algorithmic-sounding copy.

---

## Per-Page Primary Queries

These are the specific queries each page is built to answer. Every page's BLUF must answer its primary query directly in the first 100 words.

| Page | URL | Primary Query |
|------|-----|---------------|
| Homepage | `/` | "barbershop in Bostonia / El Cajon / East County" |
| Niche-query landing | `/east-county-traditional-barbershop` | "traditional barbershop East County" |
| Cost guide | `/2026-east-county-barbershop-cost-guide` | "how much does a barbershop cost in East County / El Cajon 2026" |
| About | `/about` | "who owns Joe's Barbershop in El Cajon" |
| Reviews | `/reviews` | "Joe's Barbershop reviews / ratings" |
| FAQ | `/faq` | "Joe's Barbershop hours, payment, walk-ins, kids cuts" |

---

## Canonical Slug Reference (Phase 4 links — write these now, resolve at Phase 4)

| Page type | Slug | Note |
|-----------|------|-------|
| Fades | `/fades` | 404 until Phase 4 |
| Kids cuts | `/kids-cuts` | 404 until Phase 4 |
| Beard trim | `/beard-trim` | 404 until Phase 4 |
| Hot towel shave | `/hot-towel-shave` | 404 until Phase 4 |
| Line-up | `/line-up` | 404 until Phase 4 |
| Classic cut | `/classic-cut` | 404 until Phase 4 |
| Bostonia | `/bostonia-barber` | 404 until Phase 4 |
| El Cajon | `/el-cajon-barber` | 404 until Phase 4 |
| Santee | `/santee-barber` | 404 until Phase 4 |
| Lakeside | `/lakeside-barber` | 404 until Phase 4 |
| La Mesa | `/la-mesa-barber` | 404 until Phase 4 |

---

## Voice Rules (from product-marketing-context.md)

Quick reference for copywriting invocations. See `.agents/product-marketing-context.md` § Brand Voice for full detail.

**Do:**
- Declarative entity-first sentences
- Specific, factual claims with numbers ("4.9★ across 91 Google reviews")
- Working-class Americana register — honest, direct, no fluff
- Heritage framing: traditional, craft, neighborhood, no-frills
- Walk-ins, cash-only, family-friendly stated plainly above the fold

**Do not:**
- Generic community opener (the "more than a barbershop" trope)
- Spa-coded calls-to-action or discovery verbs
- SaaS-transformation verbs (optimize, automate, transform, scale)
- "Premium" / "elevated" / "curated" / "luxurious"
- Weak modal voice: "we might / could"
- Brooklyn-grooming-bro register
- Luxury-spa framing
- SaaS design-system register

---

## Schema Notes (Phase 5 owns implementation — Phase 3 writes copy ready for it)

Phase 3 does NOT inject JSON-LD. Phase 5 wraps pages with `<script type="application/ld+json">` via `Base.astro`'s `<slot name="head" />`. Phase 3 must write copy that maps cleanly to these schema types:

| Page | Schema types Phase 5 will add |
|------|-------------------------------|
| `/` | HairSalon, LocalBusiness, AggregateRating, sameAs |
| `/east-county-traditional-barbershop` | Article, LocalBusiness, FAQPage |
| `/2026-east-county-barbershop-cost-guide` | Article, ItemList, FAQPage |
| `/about` | Person (Joe Denesowicz), Person (Alex) |
| `/reviews` | Review (×6–8), AggregateRating |
| `/faq` | FAQPage |

**Phase 3 copy requirements for schema readiness:**
- About page: include full name "Joe Denesowicz" and first name "Alex" in visible text. `data-pending-photo="joe"` and `data-pending-photo="alex"` on portrait placeholders.
- Reviews page: each review card renders: reviewer first name + last initial, star rating (as visible text), platform source (Google or Yelp), date if available.
- FAQ blocks: each Q rendered as H3, each A rendered as visible `<p>` — FAQPage schema maps directly from this structure.
- Homepage and niche-query landing: `dateModified` visible in page text.
