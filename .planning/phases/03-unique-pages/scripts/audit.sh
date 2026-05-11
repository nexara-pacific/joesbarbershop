#!/usr/bin/env bash
set -euo pipefail

# Phase 3 audit suite — validates AEO compliance of built unique pages.
# Usage:
#   bash audit.sh                — run ALL checks (skip checks with missing HTML)
#   bash audit.sh --check <name> — run single named check
#   bash audit.sh --self-test    — sanity-check tools + paths

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"
SITE_DIR="${REPO_ROOT}/site"
DIST_DIR="${SITE_DIR}/dist"
SRC_PAGES="${SITE_DIR}/src/pages"
SLUGS_FILE="${SCRIPT_DIR}/canonical-slugs.txt"

PASS_COUNT=0
FAIL_COUNT=0
SKIP_COUNT=0

pass() {
  PASS_COUNT=$((PASS_COUNT + 1))
}

fail() {
  echo "FAIL: $1 — $2"
  FAIL_COUNT=$((FAIL_COUNT + 1))
}

skip() {
  echo "SKIP: $1 — $2"
  SKIP_COUNT=$((SKIP_COUNT + 1))
}

# ---------------------------------------------------------------------------
# Individual check functions
# ---------------------------------------------------------------------------

check_homepage_faq() {
  local page="${DIST_DIR}/index.html"
  if [ ! -f "$page" ]; then skip "homepage-faq" "page not built yet"; return; fi
  local count
  count=$(grep -o '<article class="faq-q"' "$page" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -ge 5 ] && [ "$count" -le 6 ]; then
    pass
  else
    fail "homepage-faq" "expected 5 or 6 faq-q articles in index.html, got ${count}"
  fi
}

check_niche_faq() {
  local page="${DIST_DIR}/east-county-traditional-barbershop/index.html"
  if [ ! -f "$page" ]; then skip "niche-faq" "page not built yet"; return; fi
  local count
  count=$(grep -o '<article class="faq-q"' "$page" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -eq 6 ]; then
    pass
  else
    fail "niche-faq" "expected 6 faq-q articles in east-county-traditional-barbershop/index.html, got ${count}"
  fi
}

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

check_cost_guide_slugs() {
  local page="${DIST_DIR}/2026-east-county-barbershop-cost-guide/index.html"
  if [ ! -f "$page" ]; then skip "cost-guide-slugs" "page not built yet"; return; fi
  if [ ! -f "$SLUGS_FILE" ]; then
    fail "cost-guide-slugs" "canonical-slugs.txt not found at ${SLUGS_FILE}"
    return
  fi
  local missing=()
  while IFS= read -r slug || [ -n "$slug" ]; do
    [ -z "$slug" ] && continue
    if ! grep -q "href=\"/${slug}\"" "$page" 2>/dev/null; then
      missing+=("$slug")
    fi
  done < "$SLUGS_FILE"
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "cost-guide-slugs" "missing slug links in cost guide: ${missing[*]}"
  fi
}

check_cost_guide_entries() {
  local page="${DIST_DIR}/2026-east-county-barbershop-cost-guide/index.html"
  if [ ! -f "$page" ]; then skip "cost-guide-entries" "page not built yet"; return; fi
  local count
  count=$(grep -o '<article class="entry"' "$page" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -ge 4 ]; then
    pass
  else
    fail "cost-guide-entries" "expected >= 4 entry articles in cost guide, got ${count}"
  fi
}

check_about_staff_names() {
  local page="${DIST_DIR}/about/index.html"
  if [ ! -f "$page" ]; then skip "about-staff-names" "page not built yet"; return; fi
  if grep -qE '<h2[^>]*>Joe Denesowicz</h2>' "$page" 2>/dev/null; then
    pass
  else
    fail "about-staff-names" "missing h2 bio heading in about/index.html: Joe Denesowicz"
  fi
}

check_about_pending_photos() {
  local page="${DIST_DIR}/about/index.html"
  if [ ! -f "$page" ]; then skip "about-pending-photos" "page not built yet"; return; fi
  local count
  count=$(grep -o 'data-pending-photo' "$page" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -ge 1 ]; then
    pass
  else
    fail "about-pending-photos" "expected >= 1 data-pending-photo markers in about/index.html, got ${count}"
  fi
}

check_reviews_cards() {
  local page="${DIST_DIR}/reviews/index.html"
  if [ ! -f "$page" ]; then skip "reviews-cards" "page not built yet"; return; fi
  local count
  count=$(grep -o '<article class="review-card"' "$page" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -ge 6 ] && [ "$count" -le 8 ]; then
    pass
  else
    fail "reviews-cards" "expected 6-8 review-card articles in reviews/index.html, got ${count}"
  fi
}

check_reviews_sources() {
  local page="${DIST_DIR}/reviews/index.html"
  if [ ! -f "$page" ]; then skip "reviews-sources" "page not built yet"; return; fi
  local count
  count=$(grep -oE '(Google|Yelp)' "$page" 2>/dev/null | sort -u | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -eq 2 ]; then
    pass
  else
    fail "reviews-sources" "expected both Google and Yelp sources in reviews/index.html, got ${count} distinct source(s)"
  fi
}

check_faq_master_count() {
  local page="${DIST_DIR}/faq/index.html"
  if [ ! -f "$page" ]; then skip "faq-master-count" "page not built yet"; return; fi
  local count
  count=$(grep -o '<article class="faq-q"' "$page" 2>/dev/null | wc -l | tr -d ' ' || echo 0)
  if [ "$count" -ge 10 ]; then
    pass
  else
    fail "faq-master-count" "expected >= 10 faq-q articles in faq/index.html, got ${count}"
  fi
}

check_no_client_directives() {
  if [ ! -d "$SRC_PAGES" ]; then
    fail "no-client-directives" "src/pages/ directory not found at ${SRC_PAGES}"
    return
  fi
  local count
  count=$(grep -rE 'client:(load|idle|visible|only)' "$SRC_PAGES" 2>/dev/null || true)
  local n
  n=$(echo "$count" | grep -c '.' 2>/dev/null || echo 0)
  if [ -z "$count" ] || [ "$n" -eq 0 ]; then
    pass
  else
    echo "  Matching lines:"
    echo "$count" | head -20 | sed 's/^/    /'
    fail "no-client-directives" "found ${n} client:* directive(s) in src/pages/ (zero-JS AEO requirement)"
  fi
}

check_no_anti_patterns() {
  if [ ! -d "$SRC_PAGES" ]; then
    fail "no-anti-patterns" "src/pages/ directory not found at ${SRC_PAGES}"
    return
  fi
  local matches
  matches=$(grep -irE "(we're more than a barbershop|experience the difference|click here|innovate|streamline|we might|could potentially)" "$SRC_PAGES" 2>/dev/null || true)
  local n
  n=$(echo "$matches" | grep -c '.' 2>/dev/null || echo 0)
  if [ -z "$matches" ] || [ "$n" -eq 0 ]; then
    pass
  else
    echo "  Matching lines:"
    echo "$matches" | head -20 | sed 's/^/    /'
    fail "no-anti-patterns" "found ${n} banned anti-pattern phrase(s) in src/pages/"
  fi
}

check_no_accordions() {
  if [ ! -d "$SRC_PAGES" ]; then
    fail "no-accordions" "src/pages/ directory not found at ${SRC_PAGES}"
    return
  fi
  local matches
  matches=$(grep -rE "(<details>|aria-expanded|tab-panel|tabpanel)" "$SRC_PAGES" 2>/dev/null || true)
  local n
  n=$(echo "$matches" | grep -c '.' 2>/dev/null || echo 0)
  if [ -z "$matches" ] || [ "$n" -eq 0 ]; then
    pass
  else
    echo "  Matching lines:"
    echo "$matches" | head -20 | sed 's/^/    /'
    fail "no-accordions" "found ${n} accordion/tab-panel pattern(s) in src/pages/ (AEO no-hidden-content rule)"
  fi
}

check_bluf_position() {
  local pages=(
    "east-county-traditional-barbershop"
    "2026-east-county-barbershop-cost-guide"
    "about"
    "reviews"
    "faq"
  )
  local any_fail=0
  for page_slug in "${pages[@]}"; do
    local page="${DIST_DIR}/${page_slug}/index.html"
    if [ ! -f "$page" ]; then
      skip "bluf-position:${page_slug}" "page not built yet"
      continue
    fi
    # Find line number of BLUF section
    local bluf_line
    bluf_line=$(grep -n '<section class="bluf"' "$page" 2>/dev/null | head -1 | cut -d: -f1 || true)
    if [ -z "$bluf_line" ]; then
      fail "bluf-position" "${page_slug}/index.html has no <section class=\"bluf\"> element"
      any_fail=1
      continue
    fi
    # Find line number of first subsequent content block
    local content_line
    content_line=$(grep -n -E '<section class="prose"|<section class="entries-section"|<section class="reviews-section"|<div class="review-grid"|<article class="faq-q"' "$page" 2>/dev/null \
      | awk -F: -v bluf="$bluf_line" '$1 > bluf {print $1; exit}' || true)
    if [ -z "$content_line" ]; then
      # No subsequent content block found — BLUF present but no following prose section
      # This could be valid for a minimal page; treat as pass
      pass
      continue
    fi
    if [ "$bluf_line" -lt "$content_line" ]; then
      pass
    else
      fail "bluf-position" "${page_slug}/index.html: BLUF section (line ${bluf_line}) appears AFTER content block (line ${content_line})"
      any_fail=1
    fi
  done
}

# ---------------------------------------------------------------------------
# Phase 4 — Templated Pages checks
# ---------------------------------------------------------------------------

check_service_pages_built() {
  local services=(fades classic-cut kids-cuts beard-trim line-up hot-towel-shave)
  local missing=()
  for slug in "${services[@]}"; do
    local page="${DIST_DIR}/${slug}/index.html"
    if [ ! -f "$page" ]; then
      missing+=("$slug")
    fi
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "service-pages-built" "missing dist/<slug>/index.html for: ${missing[*]}"
  fi
}

check_neighborhood_pages_built() {
  local hoods=(bostonia-barber el-cajon-barber santee-barber lakeside-barber la-mesa-barber)
  local missing=()
  for slug in "${hoods[@]}"; do
    local page="${DIST_DIR}/${slug}/index.html"
    if [ ! -f "$page" ]; then
      missing+=("$slug")
    fi
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "neighborhood-pages-built" "missing dist/<slug>/index.html for: ${missing[*]}"
  fi
}

check_no_stub_content() {
  local content_dir="${SITE_DIR}/src/content"
  if [ ! -d "$content_dir" ]; then
    fail "no-stub-content" "src/content/ not found at ${content_dir}"
    return
  fi
  local matches
  matches=$(grep -rl "Stub content — Phase" "$content_dir" 2>/dev/null || true)
  local n
  if [ -z "$matches" ]; then
    n=0
  else
    n=$(echo "$matches" | wc -l | tr -d ' ')
  fi
  if [ "$n" -eq 0 ]; then
    pass
  else
    echo "  Files still containing stub markers:"
    echo "$matches" | sed 's/^/    /'
    fail "no-stub-content" "found ${n} collection file(s) still containing 'Stub content — Phase' markers"
  fi
}

check_templated_bluf() {
  local pages=(fades classic-cut kids-cuts beard-trim line-up hot-towel-shave \
               bostonia-barber el-cajon-barber santee-barber lakeside-barber la-mesa-barber)
  local missing=()
  for slug in "${pages[@]}"; do
    local page="${DIST_DIR}/${slug}/index.html"
    if [ ! -f "$page" ]; then
      # if page not built, the *-pages-built check covers it; skip here
      continue
    fi
    if ! grep -q '<section class="bluf"' "$page" 2>/dev/null; then
      missing+=("$slug")
    fi
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "templated-bluf" "pages missing <section class=\"bluf\">: ${missing[*]}"
  fi
}

check_neighborhood_data_populated() {
  local content_dir="${SITE_DIR}/src/content/neighborhoods"
  if [ ! -d "$content_dir" ]; then
    fail "neighborhood-data-populated" "neighborhoods content dir not found at ${content_dir}"
    return
  fi
  local issues=()

  # Placeholder landmarks pairs from Phase 2 stubs (single-line inline-array form)
  if grep -lE '"Bostonia area"' "$content_dir"/*.md >/dev/null 2>&1; then
    issues+=("placeholder landmarks 'Bostonia area' present")
  fi
  # Pair pattern: ["X", "East County (San Diego)?"] specifically used in stubs
  for f in "$content_dir"/santee.md "$content_dir"/lakeside.md "$content_dir"/la-mesa.md; do
    [ -f "$f" ] || continue
    if grep -qE '^landmarks: \[".+", "East County( San Diego)?"\][[:space:]]*$' "$f"; then
      issues+=("$(basename "$f"): stub landmarks pair (only neighborhood + East County)")
    fi
  done
  if grep -lE '^landmarks: \["El Cajon", "East County"\]' "$content_dir"/el-cajon.md >/dev/null 2>&1; then
    issues+=("el-cajon.md: stub landmarks pair")
  fi

  # Placeholder distance
  if grep -lE '^distance: "local"' "$content_dir"/*.md >/dev/null 2>&1; then
    issues+=("placeholder distance 'local' present")
  fi

  if [ "${#issues[@]}" -eq 0 ]; then
    pass
  else
    echo "  Placeholder issues:"
    for issue in "${issues[@]}"; do
      echo "    $issue"
    done
    fail "neighborhood-data-populated" "${#issues[@]} placeholder issue(s) in neighborhoods collection"
  fi
}

# ---------------------------------------------------------------------------
# Phase 5 — AEO Performance & Meta checks (stubs)
#
# All bodies are stubs that call `pass`. Plan 07 (Wave 6) replaces stub
# bodies with real implementations. Stubs ensure audit.sh keeps passing
# while later plans land. Function names are the canonical contract —
# downstream plans match by name.
# ---------------------------------------------------------------------------

check_jsonld() {
  local script="${REPO_ROOT}/site/scripts/validate-schema.mjs"
  if [ ! -f "$script" ]; then
    fail "jsonld" "missing site/scripts/validate-schema.mjs"
    return
  fi
  if (cd "$REPO_ROOT" && node "$script" 2>&1); then
    pass
  else
    fail "jsonld" "validate-schema.mjs reported errors (see output above)"
  fi
}

check_sitemap_links() {
  local sitemap="${DIST_DIR}/sitemap-0.xml"
  if [ ! -f "$sitemap" ]; then
    fail "sitemap-links" "missing dist/sitemap-0.xml (run npm run build first?)"
    return
  fi
  local missing=()
  # 11 templated slugs from canonical-slugs.txt
  while IFS= read -r slug || [ -n "$slug" ]; do
    [ -z "$slug" ] && continue
    if ! grep -qE "<loc>https://[^<]*/${slug}/?</loc>" "$sitemap"; then
      missing+=("$slug")
    fi
  done < "$SLUGS_FILE"
  # 6 unique pages (homepage + 5 named uniques)
  local unique_pages=("/" "about" "reviews" "faq" "east-county-traditional-barbershop" "2026-east-county-barbershop-cost-guide")
  for page in "${unique_pages[@]}"; do
    if [ "$page" = "/" ]; then
      grep -qE "<loc>https://[^<]+/</loc>" "$sitemap" || missing+=("/")
    else
      grep -qE "<loc>https://[^<]*/${page}/?</loc>" "$sitemap" || missing+=("$page")
    fi
  done
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    fail "sitemap-links" "missing in sitemap-0.xml: ${missing[*]}"
  fi
}

check_robots() {
  local file="${DIST_DIR}/robots.txt"
  if [ ! -f "$file" ]; then
    fail "robots" "missing dist/robots.txt — confirm site/public/robots.txt exists (Plan 01)"
    return
  fi
  if ! grep -qE '^User-agent:' "$file"; then
    fail "robots" "robots.txt missing 'User-agent:' line"
    return
  fi
  # Showcase mode (PUBLIC_SHOWCASE_MODE != 'false'): Disallow: / is valid — no Sitemap required.
  # Go-live mode (PUBLIC_SHOWCASE_MODE=false): Allow: / + Sitemap: required.
  if grep -qE '^Disallow: /$' "$file"; then
    pass
    return
  fi
  if ! grep -qE '^Sitemap: https?://' "$file"; then
    fail "robots" "robots.txt missing 'Sitemap:' line (go-live mode requires Sitemap)"
    return
  fi
  pass
}

check_text_as_image() {
  if [ ! -d "$SRC_PAGES" ]; then
    fail "text-as-image" "src/pages/ not found"
    return
  fi
  # Forbidden: alt attrs containing price markers or service words (AEO-07).
  # Filter out grep failure (no matches → exit 1 is desired success here).
  local matches
  matches=$(grep -rEn 'alt="[^"]*\$[0-9]|alt="[^"]*(haircut|fade|shave|hours)"' "$SRC_PAGES" "${SITE_DIR}/src/components" 2>/dev/null || true)
  if [ -z "$matches" ]; then
    pass
  else
    echo "  Matching lines:"
    echo "$matches" | head -20 | sed 's/^/    /'
    local n
    n=$(echo "$matches" | grep -c .)
    fail "text-as-image" "found ${n} alt-text(s) with price/service words (AEO-07 — text belongs in DOM)"
  fi
}

check_bluf() {
  local pages=(
    "index"
    "fades"
    "bostonia-barber"
    "east-county-traditional-barbershop"
    "2026-east-county-barbershop-cost-guide"
  )
  local any_fail=0
  for page_slug in "${pages[@]}"; do
    local file
    if [ "$page_slug" = "index" ]; then
      file="${DIST_DIR}/index.html"
    else
      file="${DIST_DIR}/${page_slug}/index.html"
    fi
    if [ ! -f "$file" ]; then
      skip "bluf:${page_slug}" "page not built"
      continue
    fi
    # Extract <main>...</main> text, strip HTML, take first ~600 chars (~100 words).
    local body
    body=$(awk '/<main/,/<\/main>/' "$file" | sed 's/<[^>]*>//g' | tr '\n' ' ' | head -c 600)
    if ! echo "$body" | grep -qi "Joe's Barbershop"; then
      fail "bluf:${page_slug}" "first ~100 words missing 'Joe's Barbershop'"
      any_fail=1
      continue
    fi
    if ! echo "$body" | grep -qiE "(El Cajon|Bostonia|East County)"; then
      fail "bluf:${page_slug}" "first ~100 words missing location term"
      any_fail=1
      continue
    fi
    if ! echo "$body" | grep -qiE "(barber|barbershop|haircut|fade|shave)"; then
      fail "bluf:${page_slug}" "first ~100 words missing service term"
      any_fail=1
      continue
    fi
    pass
  done
}

check_lighthouse() {
  if ! command -v jq >/dev/null 2>&1; then skip "lighthouse" "jq not installed"; return; fi
  if ! command -v npx >/dev/null 2>&1; then skip "lighthouse" "npx not installed"; return; fi
  # Start astro preview in background if not already running on :4321
  local url="${LIGHTHOUSE_URL:-http://localhost:4321/}"
  local preview_pid=""
  if ! curl -sf "$url" >/dev/null 2>&1; then
    (cd "$SITE_DIR" && npx astro preview --port 4321 >/dev/null 2>&1) &
    preview_pid=$!
    # Wait up to 15s for the preview to come up
    for _ in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15; do
      sleep 1
      if curl -sf "$url" >/dev/null 2>&1; then break; fi
    done
  fi
  local tmpdir
  tmpdir=$(mktemp -d)
  local perf=() a11y=() seo=() lcp=() cls=()
  for i in 1 2 3; do
    # Lighthouse 13.x removed --preset=mobile (mobile is the default form-factor for
    # performance audits). Use --form-factor=mobile explicitly to preserve intent.
    npx --yes lighthouse "$url" --form-factor=mobile --output=json \
      --output-path="${tmpdir}/run-${i}.json" --quiet \
      --chrome-flags="--headless --no-sandbox --disable-gpu" >/dev/null 2>&1 || {
      [ -n "$preview_pid" ] && kill "$preview_pid" 2>/dev/null
      fail "lighthouse" "lighthouse run $i failed (check Chrome availability)"
      return
    }
    perf+=("$(jq '.categories.performance.score' "${tmpdir}/run-${i}.json")")
    a11y+=("$(jq '.categories.accessibility.score' "${tmpdir}/run-${i}.json")")
    seo+=("$(jq '.categories.seo.score' "${tmpdir}/run-${i}.json")")
    lcp+=("$(jq '.audits["largest-contentful-paint"].numericValue' "${tmpdir}/run-${i}.json")")
    cls+=("$(jq '.audits["cumulative-layout-shift"].numericValue' "${tmpdir}/run-${i}.json")")
  done
  [ -n "$preview_pid" ] && kill "$preview_pid" 2>/dev/null
  # Median of 3 (sort + pick middle)
  local p_med a_med s_med l_med c_med
  p_med=$(printf '%s\n' "${perf[@]}" | sort -n | sed -n '2p')
  a_med=$(printf '%s\n' "${a11y[@]}" | sort -n | sed -n '2p')
  s_med=$(printf '%s\n' "${seo[@]}" | sort -n | sed -n '2p')
  l_med=$(printf '%s\n' "${lcp[@]}" | sort -n | sed -n '2p')
  c_med=$(printf '%s\n' "${cls[@]}" | sort -n | sed -n '2p')
  # Thresholds per PERF-02 + PERF-04
  # Showcase mode (noindex) legitimately lowers Lighthouse SEO — relax to 0.65 when dist/robots.txt has Disallow: /
  local seo_threshold=0.95
  if [ -f "${DIST_DIR}/robots.txt" ] && grep -q "^Disallow: /$" "${DIST_DIR}/robots.txt"; then
    seo_threshold=0.65
  fi
  awk -v v="$p_med" 'BEGIN { exit (v>=0.90)?0:1 }' || { fail "lighthouse:perf" "median performance ${p_med} < 0.90"; return; }
  awk -v v="$a_med" 'BEGIN { exit (v>=0.95)?0:1 }' || { fail "lighthouse:a11y" "median accessibility ${a_med} < 0.95"; return; }
  awk -v v="$s_med" -v t="$seo_threshold" 'BEGIN { exit (v>=t)?0:1 }' || { fail "lighthouse:seo" "median seo ${s_med} < ${seo_threshold}"; return; }
  awk -v v="$l_med" 'BEGIN { exit (v<2500)?0:1 }' || { fail "lighthouse:lcp" "median LCP ${l_med}ms >= 2500ms"; return; }
  awk -v v="$c_med" 'BEGIN { exit (v<0.1)?0:1 }' || { fail "lighthouse:cls" "median CLS ${c_med} >= 0.1"; return; }
  pass
  echo "  perf=$p_med  a11y=$a_med  seo=$s_med  LCP=${l_med}ms  CLS=$c_med"
}

check_meta_unique_titles() {
  if [ ! -d "$DIST_DIR" ]; then
    fail "meta-unique-titles" "dist/ not found — run npm run build first"
    return
  fi
  local titles_file desc_file
  titles_file=$(mktemp)
  desc_file=$(mktemp)
  local missing=()
  while IFS= read -r f; do
    local t d
    t=$(grep -oE '<title[^>]*>[^<]+</title>' "$f" | head -1 | sed 's/<[^>]*>//g')
    d=$(grep -oE '<meta[^>]*name="description"[^>]*>' "$f" | head -1 | grep -oE 'content="[^"]*"' | sed 's/content="//; s/"$//')
    if [ -z "$t" ]; then missing+=("$f: missing <title>"); fi
    if [ -z "$d" ]; then missing+=("$f: missing <meta description>"); fi
    echo "$t" >> "$titles_file"
    echo "$d" >> "$desc_file"
  done < <(find "$DIST_DIR" -name "*.html" -type f)
  if [ "${#missing[@]}" -ne 0 ]; then
    fail "meta-unique-titles" "missing fields: ${missing[*]}"
    rm "$titles_file" "$desc_file" 2>/dev/null
    return
  fi
  local dup_titles dup_descs
  dup_titles=$(sort "$titles_file" | uniq -d)
  dup_descs=$(sort "$desc_file" | uniq -d)
  rm "$titles_file" "$desc_file" 2>/dev/null
  if [ -n "$dup_titles" ]; then
    fail "meta-unique-titles" "duplicate <title> values: $(echo "$dup_titles" | tr '\n' '|')"
    return
  fi
  if [ -n "$dup_descs" ]; then
    fail "meta-unique-titles" "duplicate <meta description> values: $(echo "$dup_descs" | tr '\n' '|')"
    return
  fi
  pass
}

check_meta_og_twitter() {
  if [ ! -d "$DIST_DIR" ]; then
    fail "meta-og-twitter" "dist/ not found — run npm run build first"
    return
  fi
  local required=('og:title' 'og:url' 'og:type' 'og:site_name' 'twitter:card' 'twitter:title')
  local missing=()
  while IFS= read -r f; do
    for tag in "${required[@]}"; do
      if ! grep -qE "(property|name)=\"${tag}\"" "$f"; then
        missing+=("$f: missing ${tag}")
      fi
    done
  done < <(find "$DIST_DIR" -name "*.html" -type f)
  if [ "${#missing[@]}" -eq 0 ]; then
    pass
  else
    echo "  Missing tags (first 10):"
    printf '    %s\n' "${missing[@]:0:10}"
    fail "meta-og-twitter" "${#missing[@]} pages missing required OG/Twitter tags"
  fi
}

check_responsive_breakpoints() {
  local css_dir="${SITE_DIR}/src/styles"
  local pages_dir="${SITE_DIR}/src/pages"
  local components_dir="${SITE_DIR}/src/components"
  local layouts_dir="${SITE_DIR}/src/layouts"
  if [ ! -d "$css_dir" ]; then
    fail "responsive-breakpoints" "site/src/styles/ not found"
    return
  fi
  # Phase 1 DESN-01 + Phase 4 responsive templates port the OD-5 CSS.
  # Spot-check: both breakpoints must appear at least once across src/ CSS surfaces.
  local found_980=0 found_600=0
  for d in "$css_dir" "$pages_dir" "$components_dir" "$layouts_dir"; do
    [ ! -d "$d" ] && continue
    if grep -rqE '@media[^{]*\(\s*max-width:\s*980px\s*\)' "$d" 2>/dev/null; then
      found_980=1
    fi
    if grep -rqE '@media[^{]*\(\s*max-width:\s*600px\s*\)' "$d" 2>/dev/null; then
      found_600=1
    fi
  done
  if [ "$found_980" -eq 1 ] && [ "$found_600" -eq 1 ]; then
    pass
    echo "  OD-5 breakpoints 980px + 600px preserved in src/ (PERF-01)"
  else
    local why=""
    [ "$found_980" -eq 0 ] && why="no @media (max-width: 980px) found"
    [ "$found_600" -eq 0 ] && why="${why:+$why; }no @media (max-width: 600px) found"
    fail "responsive-breakpoints" "$why — confirm Phase 1 DESN-01 OD-5 CSS port still intact"
  fi
}

# ---------------------------------------------------------------------------
# Self-test
# ---------------------------------------------------------------------------

run_self_test() {
  echo "Running audit.sh self-test..."
  local ok=1

  for tool in grep sort wc head awk; do
    if ! command -v "$tool" >/dev/null 2>&1; then
      echo "SELF-TEST FAIL: required tool '$tool' not found"
      ok=0
    fi
  done

  if [ ! -d "$SITE_DIR" ]; then
    echo "SELF-TEST FAIL: site/ directory not found at ${SITE_DIR}"
    ok=0
  fi

  if [ ! -d "$DIST_DIR" ]; then
    echo "BUILD FIRST: cd site && npm run build"
    exit 1
  fi

  if [ ! -f "$SLUGS_FILE" ]; then
    echo "SELF-TEST FAIL: canonical-slugs.txt not found at ${SLUGS_FILE}"
    ok=0
  else
    local slug_count
    slug_count=$(wc -l < "$SLUGS_FILE" | tr -d ' ')
    if [ "$slug_count" -ne 11 ]; then
      echo "SELF-TEST FAIL: canonical-slugs.txt has ${slug_count} lines, expected 11"
      ok=0
    fi
  fi

  if [ "$ok" -eq 1 ]; then
    echo "self-test passed"
    exit 0
  else
    exit 1
  fi
}

# ---------------------------------------------------------------------------
# Check registry
# ---------------------------------------------------------------------------

run_check() {
  local name="$1"
  case "$name" in
    bluf-position)         check_bluf_position ;;
    cost-guide-slugs)      check_cost_guide_slugs ;;
    no-client-directives)  check_no_client_directives ;;
    no-anti-patterns)      check_no_anti_patterns ;;
    no-accordions)         check_no_accordions ;;
    homepage-faq)          check_homepage_faq ;;
    niche-faq)             check_niche_faq ;;
    niche-areaserved)      check_niche_areaserved ;;
    cost-guide-entries)    check_cost_guide_entries ;;
    about-staff-names)     check_about_staff_names ;;
    about-pending-photos)  check_about_pending_photos ;;
    reviews-cards)         check_reviews_cards ;;
    reviews-sources)       check_reviews_sources ;;
    faq-master-count)      check_faq_master_count ;;
    service-pages-built)         check_service_pages_built ;;
    neighborhood-pages-built)    check_neighborhood_pages_built ;;
    no-stub-content)             check_no_stub_content ;;
    templated-bluf)              check_templated_bluf ;;
    neighborhood-data-populated) check_neighborhood_data_populated ;;
    jsonld)                      check_jsonld ;;
    sitemap-links)               check_sitemap_links ;;
    robots)                      check_robots ;;
    text-as-image)               check_text_as_image ;;
    bluf)                        check_bluf ;;
    lighthouse)                  check_lighthouse ;;
    meta-unique-titles)          check_meta_unique_titles ;;
    meta-og-twitter)             check_meta_og_twitter ;;
    responsive-breakpoints)      check_responsive_breakpoints ;;
    *)
      echo "ERROR: unknown check '${name}'"
      echo "Valid names: bluf-position cost-guide-slugs no-client-directives no-anti-patterns no-accordions homepage-faq niche-faq niche-areaserved cost-guide-entries about-staff-names about-pending-photos reviews-cards reviews-sources faq-master-count service-pages-built neighborhood-pages-built no-stub-content templated-bluf neighborhood-data-populated jsonld sitemap-links robots text-as-image bluf lighthouse meta-unique-titles meta-og-twitter responsive-breakpoints"
      exit 1
      ;;
  esac
}

run_all_checks() {
  check_bluf_position
  check_cost_guide_slugs
  check_no_client_directives
  check_no_anti_patterns
  check_no_accordions
  check_homepage_faq
  check_niche_faq
  check_niche_areaserved
  check_cost_guide_entries
  check_about_staff_names
  check_about_pending_photos
  check_reviews_cards
  check_reviews_sources
  check_faq_master_count
  check_service_pages_built
  check_neighborhood_pages_built
  check_no_stub_content
  check_templated_bluf
  check_neighborhood_data_populated
  # Phase 5 — stubs (real bodies land in Plan 07)
  check_jsonld
  check_sitemap_links
  check_robots
  check_text_as_image
  check_bluf
  check_lighthouse
  check_meta_unique_titles
  check_meta_og_twitter
  check_responsive_breakpoints
}

# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

case "${1:-}" in
  --self-test)
    run_self_test
    ;;
  --check)
    if [ -z "${2:-}" ]; then
      echo "ERROR: --check requires a check name"
      exit 1
    fi
    run_check "$2"
    if [ "$FAIL_COUNT" -gt 0 ]; then
      exit 1
    fi
    exit 0
    ;;
  "")
    run_all_checks
    echo ""
    echo "audit complete: ${PASS_COUNT} passed, ${FAIL_COUNT} failed, ${SKIP_COUNT} skipped"
    if [ "$FAIL_COUNT" -gt 0 ]; then
      exit 1
    fi
    exit 0
    ;;
  # Phase 5 — positional check names route directly through run_check.
  # Lets downstream plans invoke `bash audit.sh <check-name>` without --check.
  jsonld|sitemap-links|robots|text-as-image|bluf|lighthouse|meta-unique-titles|meta-og-twitter|responsive-breakpoints)
    run_check "$1"
    if [ "$FAIL_COUNT" -gt 0 ]; then
      exit 1
    fi
    exit 0
    ;;
  *)
    echo "Usage: $0 [--self-test | --check <name> | <phase-5-check-name>]"
    exit 1
    ;;
esac
