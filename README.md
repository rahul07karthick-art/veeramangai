# VEERAMANGAI

Flutter app prototype for a girl-athlete opportunity and pathway guide. The sample athlete is Priyadharsini. The same Flutter UI runs as a native Android/iOS app and as a web app. A separate `website/` folder contains the VEERAMANGAI landing-page prototype.

## Run both previews from the ZIP

1. Download `release/VEERAMANGAI-ideathon-package.zip` from the repository and extract it.
2. Install Node.js if it is not already installed.
3. Open a terminal in the extracted `VEERAMANGAI-flutter` folder and run:

   ```sh
   node tools/preview-server.mjs
   ```

4. Open the URLs printed by the server:

   - Website: `http://127.0.0.1:4173/`
   - Flutter app preview: `http://127.0.0.1:4173/mobile-preview/`

The bundled Flutter browser preview is ready to open. Stop the local server with `Ctrl+C`.

## Run the native Flutter mobile app

Install Flutter and Android Studio, create/start an Android emulator (or connect an Android phone with USB debugging), then run these commands from this project folder:

```sh
flutter doctor
flutter pub get
flutter run
```

Choose the Android device when Flutter prompts you. To create a release APK:

```sh
flutter build apk --release
```

The APK is created at `build/app/outputs/flutter-apk/app-release.apk`. iOS builds require macOS and Xcode.

## Run the Flutter app in Chrome from source

```sh
flutter pub get
flutter run -d chrome
```

## VEERA, Supabase, Gemini, and Sarvam

Without Supabase configuration, VEERA uses local fallback responses. No model was trained or fine-tuned, and no model-training dataset was used. The `datasets/opportunity_catalog_template.csv` file is an empty template for public, verified opportunity listings.

To enable cloud features, follow `supabase/README.md`: create a Supabase project, enable anonymous sign-in, apply the migration, deploy the Edge Functions, and add Gemini/Sarvam API keys as Supabase secrets. Never place provider secrets in this Flutter app or commit them. The athlete opts in before cloud chat; only a bounded intent, not raw typed text, is sent to Gemini. Voice input requires a separate consent and sends a short audio clip to Sarvam for transcription.

For a configured Flutter run, pass only the Supabase client URL and publishable key:

```sh
flutter run --dart-define=SUPABASE_URL=https://PROJECT.supabase.co --dart-define=SUPABASE_PUBLISHABLE_KEY=YOUR_PUBLISHABLE_KEY
```

See `datasets/README.md` for source and verification rules. The prototype does not store chats, recordings, menstrual data, or athlete health check-ins.
