# App builds (Windows .exe, Android .apk)

Built by GitHub Actions: `.github/workflows/build-apps.yml`.

## Getting a build
- **Latest from main:** GitHub → Actions → "Build apps" → newest green run → *Artifacts*:
  `windows` (installer `PaperlessAI-Setup-<version>.exe` + portable ZIP) and `android`
  (`PaperlessAI-Android-<version>.apk`). Artifacts are kept for 90 days.
- **On demand:** Actions → "Build apps" → *Run workflow*.
- **Release:** Actions tab -> "Build apps" -> "Run workflow", enter a version such as `v0.7.0`
  under `release_tag`. The workflow builds, creates the tag on the built commit and publishes a
  GitHub Release with the installer, the portable ZIP and the APK.

## Installing
- **Windows:** run `PaperlessAI-Setup-<version>.exe` (installs per user, no admin rights).
  The installer is not code-signed yet, so SmartScreen shows "Unbekannter Herausgeber":
  *Weitere Informationen → Trotzdem ausführen*. Alternatively unzip the portable ZIP and start
  `paperless_ai.exe`.
- **Android:** open the APK on the phone and allow installing from this source.

## Android signing
Without secrets the APK is signed with a debug key: fine for testing, but a later APK signed
with a real key can't be installed over it (uninstall first). To sign properly, create a key
once and add four repository secrets (Settings → Secrets and variables → Actions):

```bash
keytool -genkey -v -keystore release.jks -keyalg RSA -keysize 4096 -validity 10000 -alias paperless
base64 -w0 release.jks   # -> ANDROID_KEYSTORE_BASE64
```
`ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS` (`paperless`), `ANDROID_KEY_PASSWORD`.
Keep `release.jks` and the passwords safe: losing them means users must reinstall.

## Version
Taken from `apps/client/pubspec.yaml` (`version: 0.7.0+7`; the part after `+` is the Android
version code and must increase with every release).
