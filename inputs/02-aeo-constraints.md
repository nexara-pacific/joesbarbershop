# AEO Structural Constraints

Load-bearing rules for every page. Violating any of these breaks AI citation eligibility, which is the entire point of the build. These supersede visual preferences when in conflict.

## Content structure

- **BLUF (Bottom Line Up Front):** First 100 words of every page must answer the page's primary query in plain prose. Not a hero image with a button. Not a fancy carousel. Plain text the AI can extract.
- **44.2% rule:** ~44% of ChatGPT citations come from the first third of the page. Front-load the answer. Skimmable, not "discoverable."
- **130–160 word answer capsules:** Each H2/H3 section is a self-contained chunk that can be extracted independently.
- **Declarative tone:** "Joe's Barbershop is a traditional barbershop in Bostonia." Not "we might" / "could" / "discover" / "experience." AI favors deterministic, factual language.
- **No "we" without context:** AI scrapes pages out of context. Replace ambient pronouns with explicit entity references where it matters.

## Markup rules

- **No content hidden in tabs/accordions** — parsers don't see the hidden state. Plain folded-out text.
- **FAQ blocks must be visible flat text** with H3 questions and `<p>` answers. No JS-collapsed FAQ widgets.
- **No text-as-image** for headlines, services, hours, FAQ questions. Real text in real DOM nodes.
- **Markdown-first rendering:** anything that should be extractable should be in plain HTML/markdown, not rendered into a canvas or image.

## Schema (JSON-LD)

Every page ships with schema. Priority order:

1. **FAQPage** (highest citation lift — comparative listicles + FAQ are the strongest formats)
2. **HairSalon** (more specific than LocalBusiness — use on shop-level pages)
3. **LocalBusiness** (with `areaServed`, `geo`, `priceRange`)
4. **Service** (one per service page; with `offers` + `priceSpecification`)
5. **Person** (Joe Denesowicz on /about; provides E-E-A-T signal)
6. **Article** (on cost guide + niche-query landing + blog posts; with `author`, `datePublished`, `dateModified`)
7. **Review** / **AggregateRating** (on /reviews and homepage)
8. **sameAs** in JSON-LD: link to GBP, Yelp, IG, FB, Booksy (when added), Wikidata Q-number (when registered)

## Off-site / NAP

- **NAP exact match** across GBP, Yelp, Foursquare, Bing Places, Apple Maps, Booksy, Fresha, IG, FB, and the new website. Character-identical including suite "#C".
- **Foursquare and Bing Places must be claimed** — ChatGPT pulls >70% of its local data signal from Foursquare's Places API + Bing, not Google.
- **Wikidata Q-number** registered for the LLC. State registry + license + GBP + Yelp listings = sufficient verifiability. Then `sameAs` link to the Q-number from on-site schema.

## Freshness

- Date stamps on every page (`dateModified`).
- Rotate at least one FAQ answer per month.
- Quarterly seasonal answer capsule on homepage and niche-query landing.

## Anti-patterns to actively reject

- "We're more than a barbershop, we're a community" generic open
- Carousels for content that should be flat text
- "Click here to learn more" CTAs hiding content behind clicks
- Decorative-only schema (e.g., Organization with no useful fields)
- Auto-generated FAQ from product DB without curated answers
