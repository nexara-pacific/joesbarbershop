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
