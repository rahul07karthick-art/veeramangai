# VEERAMANGAI - Project Datasheet

_Last consolidated: 2 November 2026_

## Purpose

Reusable project reference for planning the VEERAMANGAI mobile app and ideathon frontend. Use this instead of re-reading the original ideathon PDF for routine product context. Update this sheet when decisions change.

## Source and certainty

- Source document: `C:\Ideathon\velunachiyar final.pdf` (one-page ideathon proposal).
- **Proposal facts below** are stated in that PDF; they are not independently verified research.
- **Planning recommendations below** are our working plan, not commitments already made by the team.
- The PDF's cited statistics should be verified against original sources before putting them on a public-facing screen or pitch slide.

## Product at a glance

| Field | Current understanding |
|---|---|
| Product name | VEERAMANGAI (Tamil name rendering in PDF appears corrupted in text extraction; confirm preferred spelling) |
| Meaning / identity | Named for Velu Nachiyar's title "Veeramangai"; intended meaning: brave woman |
| Product form | Mobile-first app; the concept also supports keypad phone/SMS, missed-call and paper-card access |
| Problem | Girls in grassroots sport may train on plans not tailored to them, lack confidential ways to raise health or wellbeing needs, have limited access to physio/checks and trial information, and face cost, travel and family barriers |
| Primary users | Girl athletes aged 12-22 in Tamil Nadu; coaches and parents are supporting users |
| Core promise | A private athlete check-in leads to a suitable session adjustment and access to support without disclosing the athlete's private reason to the coach |
| Concept model | SIGNAL (private green/yellow/red check-in) -> PLAN (coach adjusts session) -> SUPPORT (alerts, sponsors, safe travel, food guidance, woman mentor, parent updates) |
| Design principles | Dignity, equal opportunity, inclusion, safety, Tamil language access, leadership, education, health and wellbeing |
| Initial pilot stated in proposal | Six weeks with two girls' squads |
| Proposed partners | SRMIST women's teams, a district STAR academy, SDAT, local PHC, CSR sponsors, NSS mentors |
| Expected outcomes | Fewer missed sessions, earlier injury flags, more trial entries, fewer dropouts; measures include check-in rate, missed sessions, trials applied, funds raised, and continued participation at six months |

## Event context

- Ideathon date supplied by the team: **4 November 2026**.
- Near-term goal: a clear mobile frontend concept and demo flow for the ideathon, not a production backend or completed six-week pilot.
- Recommended demo flow: athlete check-in -> coach sees a session adjustment without the reason -> athlete uses the support assistant to find an approved trial notice or mentor contact.
- Use synthetic demo data. Do not collect real athlete health or sensitive information for the presentation prototype.

## Frontend scope for the ideathon

### Athlete experience

1. Welcome / choose Tamil or English.
2. Home screen with today's practice and a discreet check-in action.
3. Green / yellow / red check-in with a short privacy explanation.
4. Confirmation screen showing what happens next.
5. Support screen: trial alerts, approved wellbeing/travel information, contact a woman mentor.
6. AI support assistant UI with sample conversation, source/context card, and a clear human handoff.

### Coach experience

1. Coach sign-in / squad selector (demo-only).
2. Squad view with status and recommended session adjustment.
3. Session plan board showing who needs a modified plan.
4. Keep private reasons hidden from the coach view.

### Demo constraints

- Prototype screens and interactions only; backend can be designed later.
- Show one happy path and one sensitive-question handoff.
- Avoid realistic personal records; use fictional names/data.
- Make the privacy rule visible in the UI, not only in the pitch narration.
- Paper/SMS access can be shown as the inclusion roadmap, even if it is not interactive in the mobile demo.

## AI agent: frontend concept only for now

### Role

A friendly Tamil/English support guide inside the app. For the ideathon demo, it can answer from prepared sample information and help athletes locate support. It is not an autonomous coach or medical professional.

### Good demo intents

- "When is the next trial?" -> show a sample, clearly labeled trial notice.
- "How do I get travel support?" -> show the sample process and coordinator contact.
- "I want to talk to someone." -> offer the woman mentor / pilot coordinator handoff.
- "I feel pain / I am unsafe." -> show a calm response and direct human support route; do not diagnose or claim an alert was sent unless the prototype actually does so.

### UI elements

- Chat-style conversation with suggested prompts.
- Short answer cards with a visible "From team-approved info" label and source/date where practical.
- "Talk to a person" action available from every agent state.
- Clear unavailable / unsure response.
- Privacy note: chat details are not shown to the coach in this concept.

### Out of scope until backend planning

- Model/provider selection, retrieval architecture, tools/actions, integrations, accounts, databases, monitoring, and deployment.
- Automatic medical, injury, eligibility, training, or safeguarding decisions.
- Inferring periods, diagnoses, or other sensitive conditions from check-ins or chat.
- Exposing an athlete's private reason to coaches, parents, or other athletes.

## Visual direction supplied by the team

Use the reference's structural principles, not its brand or content:

- Dark navy base; near-white text; muted lavender-gray secondary text.
- Restrained blue, indigo, violet, and pale-pink accents.
- Spacious hierarchy, thin low-contrast borders, rounded panels, compact chips/status dots, subtle glows.
- Calm, modern and technical; original VEERAMANGAI content, marks, and screen design.
- For a mobile app, adapt the reference's hierarchy and palette to narrow screens and thumb-friendly controls. Do not copy its desktop landing-page sections, branding, screenshots, diagram, or pricing content literally.

## Decisions now confirmed

- The requested build is both a web concept and a Flutter mobile concept for the ideathon.
- Use VEERAMANGAI as the working name and Priyadharsini as the sample athlete.
- No brand assets were supplied. Use an original identity and propose a direction rather than waiting on a logo.
- Use the new Laocoön recreation prompt only as a motion and visual-language reference: cinematic opening, flowing lines, rising particles, and blurred text reveal. Do not use its horse, brand, text, or assets.
- The ideathon date is 4 November 2026. Keep this as the near-term demo milestone.

## Current build status - 2 November 2026

- Brand direction: original dark navy, lavender, and soft pink visual system; Tamil letter mark and calm, supportive tone. No supplied logo or formal brand guide.
- A responsive, single-file web prototype is available at `outputs/VEERAMANGAI-mobile-prototype/index.html`.
- The support assistant is a scripted frontend demonstration, not a connected AI service. Its answers are sample content; no backend, real messaging, persistent storage, or real mentor notification is configured.
- The web prototype contains a fictional district trial dated 16 November 2026 with a 12 November application deadline. Treat these as synthetic demo details and replace or clearly label them before presenting as factual.

## Current product and frontend direction - 2 November 2026

- Confirmed product/audience: VEERAMANGAI for girl athletes in Tamil Nadu, ages 12-22, with athlete, coach, and Veera support-guide experiences.
- Example athlete name: Priyadharsini.
- Brand assets: none provided; use original dark navy / lavender / soft-pink identity and adapt it to a light theme as well.
- Veera's product role is now an **athlete pathway coordinator**: help pursue an opportunity, organize application steps, plan travel and funding requests, prepare drafts/reminders, and connect to the support circle. Athlete reviews any draft before it is shared; no real sending or scheduling in the current prototype.
- Web concept at `outputs/VEERAMANGAI-mobile-prototype/index.html` is a responsive, cinematic story experience covering introduction, opportunity discovery, pathway planning, and Veera.
- Flutter mobile concept at `outputs/VEERAMANGAI-flutter/` includes `lib/main.dart` and `pubspec.yaml`; four-tab mobile experience, dark/light toggle, sample opportunity planning, and review interactions.
- Both frontends remain frontend-only demonstrations with fictional/sample opportunity content; model/API, persistent storage, real notices, notifications, requests, and messaging are not connected.


## Current cinematic UI and motion direction - 2 November 2026

- The web prototype is now a scroll-led, four-part story: introduction, opportunity discovery, athlete pathway plan, and Veera support-coordinator interaction. The prior sidebar dashboard layout has been replaced.
- Motion adapted from the supplied Laocoön prompt: slow liquid-like bronze/blue atmospheric background, rising sparks, per-character blur-up headline reveal, scroll section reveals, parallax line/orbit detail, and segmented story progress. The Laocoön horse model, artwork, branding, and copy are not used.
- Type direction: bundled Raleway for interface copy and Merriweather for editorial headlines, shared by the website and Flutter app. Both font families are SIL Open Font licensed, with attribution/license text kept in the Flutter assets folder.
- Web light/dark mode is explicit and persisted in local storage, with alternate surface/text/accent tokens.
- Flutter app launch now opens a short cinematic intro with rising particles, flowing wave lines, and staggered blur-up VEERAMANGAI lettering; it auto-enters after about 3.4 seconds or can be skipped. Its mobile tab UI remains the athlete workflow.
- Performance pass: canvas is capped at 20 frames per second and device-pixel ratio 1.25; wave/particle counts were reduced, progress updates are scroll-driven, hidden tabs pause animation, and mobile/reduced-motion views use a static atmosphere. Large animated blur filters and backdrop blur were reduced.
- Reduced-motion preferences are respected on the web. The Flutter intro has an explicit skip action.
- Flutter SDK 3.47.9 (Dart 3.13.7) is installed in the project workspace at `work/flutter-sdk/flutter`. The release archive checksum was checked against official release metadata.
- Flutter dependencies resolve offline, and `flutter analyze --no-pub` reports no issues after the typography update.
- Web dark/light switching was visually checked; the control now names the mode it will switch to. The dark theme is selected on the preview.
- A browser build of the Flutter app is available under `outputs/VEERAMANGAI-mobile-prototype/mobile-preview/` for a phone-width second-tab preview. The Flutter source remains in `outputs/VEERAMANGAI-flutter/`.
- The Flutter Home tab now shares the website’s two-tone “Every goal has a team behind it” hero and Tamil sigil; Explore, Veera, and Team share the same serif section headings, bronze accents, thin borders, and translucent card surfaces while retaining mobile navigation and touch targets.

## Demo status and next steps

- Frontend concepts are ready for review; this is not a production app. Use synthetic content only in the ideathon demo.
- Veera currently demonstrates the intended agent workflow in scripted UI: interpret a goal, find a sample opportunity, create a checklist, estimate travel/support needs, prepare a draft, and ask the athlete before sharing. It does not call a model, access live opportunity feeds, send messages, make bookings, or schedule reminders.
- Next frontend work: review the flow and wording with the team, refine any demo screens, and prepare a short click-through for the 4 November ideathon.
- Later backend/agent planning: choose trusted data sources and model, define tool permissions and human review, privacy/consent and safeguarding behavior, then implement persistence, notifications, and evaluation.

## Agent integration and UI refresh - 2 November 2026

- The pasted Soda brief is treated as a visual reference only. VEERAMANGAI keeps its own name, copy, athlete-focused features, and marks. The refreshed direction uses teal-to-deep-green and blue atmosphere, glass panels, restrained pale-pink accents, and a short particle/wave intro.
- Flutter remains the mobile source of truth. Its web preview is compiled from the same Flutter app; the separate website has been recolored to the same palette and retains a reduced-motion-aware, low-cost atmosphere.
- `outputs/VEERAMANGAI-flutter/lib/veera_services.dart` is the client integration layer. Gemini requests are opt-in and carry only a bounded generic intent, never the raw typed message; without config or after a service error, Veera answers with local fallback checklists.
- Supabase setup files, Edge Functions, and the public opportunity catalogue schema are in `outputs/VEERAMANGAI-flutter/supabase/`. Only verified public opportunities are stored in the table. The agent uses Gemini Interactions stateless mode with `store:false` and uses catalogue records as retrieval context; it does not fine-tune or train a model.
- Sarvam speech transcription is wired as an explicit-consent voice flow. The Flutter client streams audio in memory, submits a short WAV clip to a Supabase Edge Function, and leaves the transcript for the athlete to review before sending it to Veera.
- Privacy by default: AI chat opt-in starts off; sensitive-health/safety keyword checks run locally and again in the function; chat, transcripts, voice clips, menstrual-cycle data, and check-ins are not written to Supabase tables or Storage. Auth is anonymous and created only after AI/voice opt-in. Keyword detection is not a guaranteed safety filter.
- No model was trained and no training dataset was used. The `datasets/` folder contains an empty opportunity-catalogue CSV template plus provenance guidance, not model training data.
- Cloud integration is code-complete as a scaffold but not live: there is no project URL, publishable key, Gemini key, Sarvam key, deployed Supabase function, or real verified listings in this workspace. Configure those before expecting live AI, event, scheme, funding, or voice results.
- The website and Flutter app remain prototypes. Before real athlete/minor use, complete auth/session review, provider retention review, rate limiting, trusted listing verification, consent/safeguarding review, and human escalation design.
