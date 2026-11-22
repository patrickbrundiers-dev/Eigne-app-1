# Online-Update

Die App holt neue Versionen direkt aus den GitHub Releases dieses Repositorys. Es gibt keinen eigenen Server.

## Ablauf in der App

1. Nach dem Start prüft die App höchstens einmal am Tag `GET https://api.github.com/repos/patrickbrundiers-dev/Eigne-app-1/releases`.
   Abschalten geht unter Einstellungen → Updates. Dort gibt es auch „Nach Updates suchen“.
   Gesendet wird nur eine normale HTTPS-Anfrage mit dem User-Agent `MyDietAI-Updater (Flutter app)`, ohne persönliche Daten.
2. Gezählt werden nur veröffentlichte Releases mit dem Tag `mydiet-vX.Y.Z`. Entwürfe, Vorabversionen und die alten
   `v0.x`-Tags von Paperless AI zählen nicht. Ist die Version höher als die installierte, erscheint ein Hinweis mit den
   Release-Notizen. Optionen: „Jetzt aktualisieren“, „Später“, „Überspringen“ (diese Version wird dann nicht mehr angeboten).
3. **Windows:** Die App lädt `MyDietAI-Setup-X.Y.Z.exe` in den Temp-Ordner. Größe und SHA-256 (aus dem `digest` der GitHub-API)
   werden geprüft. Danach startet sie das Setup mit `/SILENT /SUPPRESSMSGBOXES /NORESTART /CLOSEAPPLICATIONS` und beendet
   sich. Das Setup installiert ohne Admin-Rechte über die alte Version und startet die App neu.
   Die Datenbank liegt im App-Datenordner und bleibt erhalten.
4. **Android:** Die App öffnet die APK im Browser. Nach dem Download antippen und „Aktualisieren“ wählen. Die Daten bleiben erhalten.

## Wichtig für Android: fester Signaturschlüssel

Android installiert ein Update nur, wenn die neue APK mit **demselben Schlüssel** signiert ist wie die installierte.
Ohne die Secrets unten signiert die CI jede APK mit einem zufälligen Debug-Schlüssel. Dann schlägt jedes Update fehl
(„App nicht installiert“). Das galt auch für v0.1.0.

Einmalig einrichten (auf dem eigenen PC, Schlüssel gut aufheben, nie ins Repository):

```bash
keytool -genkeypair -v -keystore mydiet-release.jks -keyalg RSA -keysize 4096 -validity 10000 -alias mydiet
base64 -w0 mydiet-release.jks > mydiet-release.jks.b64   # Windows: certutil -encode, Kopfzeilen entfernen
```

Unter GitHub → Settings → Secrets and variables → Actions diese vier Secrets anlegen:

| Secret | Inhalt |
|---|---|
| `ANDROID_KEYSTORE_BASE64` | Inhalt von `mydiet-release.jks.b64` |
| `ANDROID_KEYSTORE_PASSWORD` | Keystore-Passwort |
| `ANDROID_KEY_ALIAS` | `mydiet` |
| `ANDROID_KEY_PASSWORD` | Schlüssel-Passwort |

Wer v0.1.0 (Debug-Schlüssel) installiert hat, muss einmal **exportieren → deinstallieren → neue APK installieren → importieren**.
Ab dann laufen Updates direkt.

## Release erstellen

Actions → „Build apps“ → Run workflow mit `release_tag` = `mydiet-vX.Y.Z` (passend zu `version:` in `pubspec.yaml`).
Der Text im Release erscheint in der App als Release-Notiz.
