# Supabase setup (not deployed)

1. Create a Supabase project, enable anonymous sign-ins under Authentication settings, and apply `migrations/202611020001_veera_opportunities.sql`.
2. Add `GEMINI_API_KEY`, optional `GEMINI_MODEL`, and `SARVAM_API_KEY` as Edge Function secrets. Do not put these in Flutter, a checked-in `.env`, or the web build.
3. Deploy `veera-agent` and `sarvam-transcribe` using the Supabase CLI. `config.toml` requires a Supabase JWT at the function gateway.
4. Run Flutter with the project's client URL and publishable key. The app creates an anonymous Auth session only after the athlete opts into AI chat or confirms voice input:

   `flutter run --dart-define=SUPABASE_URL=https://PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY`

The athlete's raw typed text stays on the device. When **Allow this chat to use AI** is enabled, the client maps the message to a small allowlisted intent such as `funding`, `competitions`, or `applications`; only that generic task plus public catalogue rows reaches Gemini. An anonymous Supabase Auth session is created after opt-in to satisfy the function JWT gate; this creates a pseudonymous Auth user record. The app and functions do not write chat, transcripts, recordings, health check-ins, or cycle data to Postgres or Storage. Local keyword screening is an additional safety response, not a guaranteed classifier. Do not use free-text AI for medical or safeguarding workflows. High-risk actions need a human support route.

The microphone prompt discloses that a clip is sent to Sarvam for transcription. Clips are held in memory by the app and are not put in Supabase storage; Sarvam's provider-side processing/retention terms still apply. Voice is disabled until project configuration exists. Keep cycle, symptom, injury, or safety details out of voice prompts.

The opportunity table contains public, non-personal listings only and is readable under RLS only when `status='verified'` and the deadline is current. The prototype has no user profile or permanent sign-in. Anonymous sessions still create pseudonymous Supabase Auth rows, so enable CAPTCHA/rate controls and define a cleanup period. The prototype is not ready for real minors or production deployment. Before a pilot: add verified publisher workflows, deletion/retention review, safeguarding escalation, and an adult/athlete consent design.
