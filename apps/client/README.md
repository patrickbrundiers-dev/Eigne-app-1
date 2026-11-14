# Flutter client

Target platforms: Android and Windows.

Prerequisites:
- Flutter stable SDK
- Android SDK for Android builds
- Windows 10/11 with Visual Studio C++ desktop workload for Windows builds

Platform folders (`android/`, `windows/`) are generated. To run:
```bash
flutter pub get
flutter test
flutter run -d windows
```

Connecting to a server: Einstellungen → Anmelden. The server address must use `https://`;
plain `http://` is accepted only for `localhost` / `127.0.0.1` and `10.0.2.2` (Android
emulator → host machine). The device token is kept in secure storage (Android Keystore,
Windows Credential Manager), never in plain preferences.

Structure:
- `lib/src/app.dart` – MaterialApp, light/dark themes (follow the OS)
- `lib/src/shell/` – responsive navigation shell (bottom bar < 600 px, rail < 1200 px,
  extended rail above) and the list of top-level destinations
- `lib/src/pages/` – dashboard, documents (list + preview), login, settings
- `lib/src/api/` – HTTP client for `/api/v1`, server URL validation, error messages
- `lib/src/auth/` – token storage; `lib/src/app_state.dart` – session and spaces
- `lib/src/import/` – file picker and import flow

Do not add real document storage or authentication until the data ownership, encryption and family authorization designs are approved.
