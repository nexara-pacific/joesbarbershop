// site/src/content.config.ts
// NOTE: This file is at src/content.config.ts (root of src/) — NOT src/content/config.ts
// Astro 6 Content Layer API requires this path + explicit loader on every defineCollection call.
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
