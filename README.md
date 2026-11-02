# VEERAMANGAI Flutter mobile app prototype

A Flutter mobile prototype for VEERAMANGAI's athlete opportunity and pathway app. The sample athlete is Priyadharsini. The app includes Home, Explore, Veera, and Team tabs, light/dark themes, a teal/blue glass visual direction with soft pink accents, and a cinematic opening animation. A single source of truth serves Android/iOS and the Flutter web preview.

The website and Flutter app now share bundled Raleway interface text and Merriweather editorial headings, with the font licenses included under `assets/licenses/`.

## Flutter SDK in this workspace

Flutter 3.47.9 (Dart 3.13.7) is installed at:

`C:\Users\karth\Documents\Codex\2026-11-01\rea\work\flutter-sdk\flutter`

From PowerShell, run these commands in this app folder:

```powershell
$flutter = 'C:\Users\karth\Documents\Codex\2026-11-01\rea\work\flutter-sdk\flutter\bin\flutter.bat'
& $flutter pub get
& $flutter run
```

Select an available Android device/emulator when prompted. The installed Flutter SDK does not itself install Android Studio or an Android emulator.

## Browser preview

A compiled browser preview of this Flutter app is available at `../VEERAMANGAI-mobile-prototype/mobile-preview/`. The Flutter project itself supports Android, iOS, and web. To rebuild the same app for browser use:

```powershell
$flutter = 'C:\Users\karth\Documents\Codex\2026-11-01\rea\work\flutter-sdk\flutter\bin\flutter.bat'
& $flutter build web --release --base-href /mobile-preview/
Copy-Item .\build\web\* ..\VEERAMANGAI-mobile-prototype\mobile-preview\ -Recurse -Force
```

## Prototype boundary

The opening animation uses rising particles, flowing wave lines, and staggered blur-up lettering, with a skip control. Veera has a Supabase Edge Function integration path for Gemini, local fallback answers, and Sarvam speech transcription. The model is an API call; **no model was trained and no training dataset was used**. Opportunity catalogue schema, empty ingestion template, privacy notes, and Edge Functions live under `supabase/` and `datasets/`.

Cloud features need a Supabase project, anonymous sign-in enabled, deployed Edge Functions, and Edge Function secrets. With no project config, the app stays in offline mode. To configure the client, run from this folder:

```powershell
$flutter = 'C:\Users\karth\Documents\Codex\2026-11-01\rea\work\flutter-sdk\flutter\bin\flutter.bat'
& $flutter run --dart-define=SUPABASE_URL=https://PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

The athlete must opt in to cloud chat. Raw typed messages stay on device; only a bounded intent and public, verified catalogue records go to Gemini. Chat and voice clips are not saved by the app; only public, verified opportunity listings belong in the Supabase database. Voice capture has a separate consent step and is sent to Sarvam for transcription. Local health/safety phrase screening is best-effort; the app also avoids sending raw chat text to Gemini. Read `supabase/README.md` and `datasets/README.md` before configuring a real provider.
