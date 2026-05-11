import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import vercel from '@astrojs/vercel';

export default defineConfig({
  // REQUIRED by @astrojs/sitemap. Resolved in Phase 6 to actual deployed URL.
  // Sitemap uses this for absolute <loc> entries.
  site: 'https://joes-barbershop.vercel.app',
  integrations: [sitemap()],
  adapter: vercel(),       // No-op for static; unlocks Phase 5 Vercel features
  image: {
    layout: 'constrained', // Stable since 5.10 — auto-srcset + sizes
    responsiveStyles: true,
  },
});
