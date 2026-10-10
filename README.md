# STORYNEX — writing workspace

React, Vite, TypeScript, Tailwind, Three.js, GSAP, Framer Motion, and Supabase starter.

## Run it
1. Install Node.js 20.19+ or 22.12+.
2. Copy `.env.example` to `.env.local`, then add your Supabase project URL and publishable/anon key.
3. Run `supabase/migrations/001_storynex.sql` in the Supabase SQL Editor.
4. Enable email/password auth in Supabase. Configure the site URL and allowed redirect URLs for local and production.
5. Run `npm install` then `npm run dev`.

Never expose a Supabase `service_role` key in frontend code.

## Current functionality
- Email/password signup, sign-in, sign-out, verification email flow, password reset.
- Private per-user cloud project and scene tables using row-level security.
- Debounced scene autosave, local browser drafts, offline/reconnect retry, and a conflict warning.
- Scene checkpoints/version restore; JSON full-project backup; TXT/Markdown scene/project exports; browser print-to-PDF.
- Responsive writer workspace, Three.js particle galaxy, animated dialogs and reduced-motion support.
- Local demo mode without Supabase credentials. It is browser-local and does not sync across devices.

## Important
This starter still requires a real Supabase project and deployment configuration. It has not been run against your account or verified in a production environment. Before public launch, test the workflow in TESTING.md, configure a reliable SMTP provider, enable suitable database backups/PITR, test restores, and keep independent downloads. Lifetime availability cannot be guaranteed; retention depends on provider, account, service limits, and backup policies.
