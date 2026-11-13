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

Structure:
- `lib/src/app.dart` – MaterialApp, light/dark themes (follow the OS)
- `lib/src/shell/` – responsive navigation shell (bottom bar < 600 px, rail < 1200 px,
  extended rail above) and the list of top-level destinations
- `lib/src/pages/` – dashboard and placeholder pages

Do not add real document storage or authentication until the data ownership, encryption and family authorization designs are approved.
