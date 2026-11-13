# Flutter client

Target platforms: Android and Windows.

Prerequisites:
- Flutter stable SDK
- Android SDK for Android builds
- Windows 10/11 with Visual Studio C++ desktop workload for Windows builds

Initialize platform folders (once):
```bash
flutter create . --platforms=android,windows
flutter pub get
flutter run -d windows
```

Do not add real document storage or authentication until the data ownership, encryption and family authorization designs are approved.
