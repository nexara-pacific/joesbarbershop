// site/src/data/business.ts
// Source of truth: business.json. Edit JSON to update data; this file is the typed view.
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
  geo: {                          // Phase 5 D-04 addition
    latitude: number;
    longitude: number;
  };
  priceRange: string;             // Phase 5 D-04 addition ("$$" per Schema.org convention)
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
  _showcase_review_pending?: string[];
}

export const business = businessData as BusinessRecord;

// ============================================================================
// Phase 5 D-04 helpers — schema-grade derivations of business data.
// ============================================================================

/**
 * Convert display phone to E.164 for Schema.org `telephone` field.
 * "(619) 891-2775" → "+16198912775"
 */
export function toE164(displayPhone: string): string {
  const digits = displayPhone.replace(/\D/g, '');
  return digits.startsWith('1') ? `+${digits}` : `+1${digits}`;
}

// Schema.org dayOfWeek values — title-case, not JS Date weekday strings.
const DAY_OF_WEEK_TITLE: Record<string, string> = {
  monday: 'Monday',
  tuesday: 'Tuesday',
  wednesday: 'Wednesday',
  thursday: 'Thursday',
  friday: 'Friday',
  saturday: 'Saturday',
  sunday: 'Sunday',
};

/**
 * Map business.hours to Schema.org OpeningHoursSpecification[].
 * Skips null days (Sunday + Monday per business.json).
 * Per D-04 — used by HairSalon schema component on every page.
 */
export function toOpeningHoursSpecification(
  hours: BusinessRecord['hours']
): Array<{
  '@type': 'OpeningHoursSpecification';
  dayOfWeek: string;
  opens: string;
  closes: string;
}> {
  return Object.entries(hours)
    .filter(([, h]) => h !== null)
    .map(([day, h]) => ({
      '@type': 'OpeningHoursSpecification' as const,
      dayOfWeek: DAY_OF_WEEK_TITLE[day],
      opens: h!.open,
      closes: h!.close,
    }));
}

/**
 * Combine multi-platform ratings into a single Schema.org AggregateRating shape.
 * Per D-04 + D-08 — weighted average by review count; emitted on homepage only.
 * Formula: (sum(value × count)) / sum(count), rounded to 2 decimals.
 * Yields: (5.0×114 + 4.9×33) / (114+33) = 4.98 across 147 reviews.
 * Throws Error if all sources have count===0 (prevents NaN in JSON-LD).
 */
export function aggregateRating(
  ratings: BusinessRecord['ratings']
): { ratingValue: number; reviewCount: number } {
  const sources = Object.values(ratings);
  const totalCount = sources.reduce((sum, r) => sum + r.count, 0);
  if (totalCount === 0) {
    throw new Error('aggregateRating: no rating sources with count > 0');
  }
  const weightedSum = sources.reduce((sum, r) => sum + r.value * r.count, 0);
  const ratingValue = Number((weightedSum / totalCount).toFixed(2));
  return { ratingValue, reviewCount: totalCount };
}

/**
 * Canonical site URL — single source for schema @id values per D-07.
 * Custom domain swap (v1.5 / Phase 7) is a one-line edit here.
 */
export const canonicalUrl = 'https://joes-barbershop.vercel.app';
