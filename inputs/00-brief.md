# Open Design — Lock the Brief

Paste this into Open Design's brief stage. Companion files: `01-page-list.md`, `02-aeo-constraints.md`, `03-photo-notes.md`. Photos in `./photos/` (numbered 01–06).

---

## Surface
Web (mobile-first). 17–19 pages. See `01-page-list.md`.

## Audience
**Primary:** East County San Diego men 25–65 wanting a no-frills traditional cut at a fair price (~$30 base). Working class to middle class. Latino, Anglo, mixed. Bostonia / El Cajon / Santee / Lakeside / La Mesa.
**Secondary:** parents bringing kids (kids cuts are a service line).
**NOT:** bearded Brooklyn lifestyle bros, luxury grooming buyers, San Diego "scene" demographic.

## Tone
Heritage barbershop. Working class. Neighborhood. Family-friendly. Honest. No-frills. Western/Victorian typography lineage matching the existing logo. Established craft (since 2020). Not pretentious, not luxury, not trendy.

## Brand context
- Joe's Barbershop, Bostonia neighborhood, El Cajon CA
- 723 E Bradley Ave #C, 92021 — strip-mall storefront (embrace it, don't hide it)
- Owner: Joe Denesowicz, with barber Alex (3+ stations confirmed; possibly 1–2 more barbers)
- Established 2020
- 4.9★ / ~91 Google reviews; 4.9★ / 33 reviews / 102 photos on Yelp
- Existing logo asset (see `photos/01-logo.jpg`): ornate Western/Victorian serif "Joe's BARBERSHOP / HAIRCUTS & SHAVES" with two barber poles flanking the wordmark; cream/tan + black + barber-pole red + navy
- Service menu (in-shop letter board — authoritative): Haircut $30, Shave $30, Beard Line-up $20, Clean Up $15. Square Site adds Haircut + Beard $50. **CASH ONLY in-shop. ATM on premises.** Square booking widget likely takes card for online reservation.
- Interior visual signature: black-and-white checkerboard tile floor across the whole shop; mix of vintage black-leather/mahogany barber chair + modern silver/black quilted chairs; round Joe's logo decals used as wall art on mirrors; Mexican Lotería poster; sticker culture (US flag, automotive, branded); decorative "Ice Cold Beer Served Here" sign (NOT actual service); bright fluorescent + sunlight; wall-mounted TV (automotive/sports content)

## Visual positive cues
- **Black-and-white checkerboard motif** as a recurring design element — section dividers, hero overlays, footer pattern. Echoes the actual floor.
- Heritage barber typography — display headings should echo the logo's Western/Victorian serif (Playfair Display, IM Fell English, Baskerville, or similar). Letter-board condensed sans (Helvetica/Bebas/News Gothic Condensed) for service prices echoing the in-shop board.
- Color palette: cream/tan base, black structural elements, barber-pole red and navy as accents. Pull directly from the logo.
- Honest documentary photography — storefront, cuts in progress, Joe and Alex working, signage, the actual checkerboard floor. NOT staged photoshoots.
- Bright, well-lit imagery (not mood-lit, not vintage filter).
- **"Cash only — ATM on site" surfaced prominently and unapologetically.** Positioning, not a limitation.
- Visible price list (echo letter-board format), hours, walk-ins-welcome — surface them, don't hide behind contact form.
- Family-friendly cues: "kids cuts" as a service line, not "men only".
- Logo decal-as-wall-art motif: round logo can repeat as a graphic element, not just header lockup.
- Working-class Latino + Anglo Americana cues are honest and specific to East County. Don't sanitize.

## Visual negative cues (anti-prompts)
- NO whiskey, leather club chairs, Edison bulbs, exposed brick, "speakeasy" mood lighting
- NO modern minimalist concrete-and-steel
- NO luxury spa cues — no white marble, aromatherapy, "experience"
- NO "men's grooming lifestyle" Brooklyn-coded styling
- NO mood lighting, dim shots, vintage Instagram-filter photography
- NO SaaS-style design systems (Linear, Stripe, Vercel) — those will fight the logo
- NO sanitizing the working-class cultural cues (Lotería poster, sticker culture, ATM, cash-only)

## Design system pick (from Open Design's library)
- **Avoid:** Linear, Stripe, Vercel, Notion (SaaS-coded)
- **Lean into:** anything heritage / editorial / americana / letterpress / magazine. Apple's clean editorial typography could work IF the heritage logo stays dominant.
- If none cleanly fit, derive from `photos/01-logo.jpg` + `photos/03-interior-hero.jpg`.

## Layout guidance
- Logo gets prominent header placement on every page (do not rebrand)
- **Homepage hero: `photos/03-interior-hero.jpg`** — wide interior with checkerboard floor + chairs + stations
- Secondary "Visit Us" image: `photos/02-storefront.jpg`
- BLUF answer capsule first 100 words on every page in clean editorial serif body font
- Service prices visible inline as a letter-board-styled block (white-on-black, condensed sans) echoing `photos/06-price-board-cash-only.jpg` — NOT gated
- "Walk-ins welcome" + "Family-friendly" + "Cash only — ATM on site" all stated above the fold on the homepage
- Strip-mall context owned, not hidden
- Use the round logo decal as a recurring graphic element — section markers, hover states, footer ornament

## AEO structural constraints (load-bearing — do not violate)
See `02-aeo-constraints.md`. Quick version: BLUF in first 100 words; no tabs/accordions hiding content; FAQ blocks visible flat text; H2/H3 sections self-contained 130–160 word answer capsules; declarative tone; JSON-LD schema on every page; no text-as-image.

## Scale
17–19 pages MVP. Most are template variants. Generate visuals for these 5–7 unique templates first:
1. Homepage (unique)
2. Niche-query landing — `/east-county-traditional-barbershop` (unique, AEO-critical)
3. Service template (applies to fades, kids-cuts, beard-trim, hot-towel-shave, line-up, classic-cut)
4. Neighborhood template (applies to Bostonia, El Cajon, Santee, Lakeside, La Mesa)
5. Cost guide / long-form article template
6. FAQ page
7. About / reviews
