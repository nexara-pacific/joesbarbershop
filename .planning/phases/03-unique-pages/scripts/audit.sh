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
  count=$(grep -c '<article class="faq-q"' "$page" 2>/dev/null || echo 0)
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
  count=$(grep -c '<article class="faq-q"' "$page" 2>/dev/null || echo 0)
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
  count=$(grep -c '<article class="entry"' "$page" 2>/dev/null || echo 0)
  if [ "$count" -ge 4 ]; then
    pass
  else
    fail "cost-guide-entries" "expected >= 4 entry articles in cost guide, got ${count}"
  fi
}

check_about_staff_names() {
  local page="${DIST_DIR}/about/index.html"
  if [ ! -f "$page" ]; then skip "about-staff-names" "page not built yet"; return; fi
  local joe_ok=0 alex_ok=0
  grep -qE '<h2[^>]*>Joe Denesowicz</h2>' "$page" 2>/dev/null && joe_ok=1
  grep -qE '<h2[^>]*>Alex</h2>' "$page" 2>/dev/null && alex_ok=1
  if [ "$joe_ok" -eq 1 ] && [ "$alex_ok" -eq 1 ]; then
    pass
  else
    local missing=""
    [ "$joe_ok" -eq 0 ] && missing="Joe Denesowicz"
    [ "$alex_ok" -eq 0 ] && missing="${missing:+${missing}, }Alex"
    fail "about-staff-names" "missing h2 bio heading(s) in about/index.html: ${missing}"
  fi
}

check_about_pending_photos() {
  local page="${DIST_DIR}/about/index.html"
  if [ ! -f "$page" ]; then skip "about-pending-photos" "page not built yet"; return; fi
  local count
  count=$(grep -c 'data-pending-photo' "$page" 2>/dev/null || echo 0)
  if [ "$count" -eq 2 ]; then
    pass
  else
    fail "about-pending-photos" "expected 2 data-pending-photo markers in about/index.html, got ${count}"
  fi
}

check_reviews_cards() {
  local page="${DIST_DIR}/reviews/index.html"
  if [ ! -f "$page" ]; then skip "reviews-cards" "page not built yet"; return; fi
  local count
  count=$(grep -c '<article class="review-card"' "$page" 2>/dev/null || echo 0)
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
  count=$(grep -c '<article class="faq-q"' "$page" 2>/dev/null || echo 0)
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
    *)
      echo "ERROR: unknown check '${name}'"
      echo "Valid names: bluf-position cost-guide-slugs no-client-directives no-anti-patterns no-accordions homepage-faq niche-faq niche-areaserved cost-guide-entries about-staff-names about-pending-photos reviews-cards reviews-sources faq-master-count"
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
  *)
    echo "Usage: $0 [--self-test | --check <name>]"
    exit 1
    ;;
esac
