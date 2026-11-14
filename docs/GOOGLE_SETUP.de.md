# Google einrichten (für Sync ohne Server)

Diese Anleitung brauchst du einmal. Danach können die Android-App und die Windows-App direkt
mit Google Drive arbeiten. Plan dazu:
[Plan: Paperless AI ohne Server über Google Drive](https://claude.ai/artifact/2T9qB6ZTYTXLBdgwjq74RB).

Dauer: etwa 30 Minuten. Kosten: keine.

> Google benennt Menüs gelegentlich um. Wenn ein Punkt anders heißt, such im Suchfeld oben in
> der Cloud Console nach dem fett gedruckten Begriff.

## Teil 1: Fester Android-Signaturschlüssel (etwa 10 Minuten)

Google erkennt die Android-App an ihrem Signatur-Fingerabdruck. Bisher bekommt jede APK aus
GitHub einen neuen Test-Schlüssel. Ab jetzt braucht sie einen festen Schlüssel.

Der Schlüssel ist geheim: Wer ihn hat, kann Updates bauen, die sich über deine App
installieren lassen. Er kommt deshalb nur in die GitHub-Secrets und auf deinen PC, nie ins Repo
und nie in einen Chat.

1. [Eclipse Temurin JDK 17](https://adoptium.net/temurin/releases/?version=17&os=windows)
   für Windows als `.msi` installieren. Darin ist das Werkzeug `keytool` enthalten.
2. PowerShell öffnen und in einen sicheren Ordner wechseln, zum Beispiel `cd $HOME\Documents`.
3. Schlüssel erzeugen. Denk dir ein langes Passwort aus und gib es zweimal ein, wenn du gefragt
   wirst. Die Fragen nach Name und Organisation darfst du mit Enter überspringen; am Ende `ja`.

   ```powershell
   keytool -genkeypair -v -keystore paperless-release.jks -alias paperless -keyalg RSA -keysize 4096 -validity 10000
   ```

4. Fingerabdruck anzeigen (Passwort eingeben). Notiere den Wert hinter **SHA1:**, den brauchst
   du in Teil 2.

   ```powershell
   keytool -list -v -keystore paperless-release.jks -alias paperless
   ```

5. Den Schlüssel als Text für GitHub umwandeln. Danach liegt der Text in der Zwischenablage.

   ```powershell
   [Convert]::ToBase64String([IO.File]::ReadAllBytes("$PWD\paperless-release.jks")) | Set-Clipboard
   ```

6. Im Repo auf GitHub: **Settings → Secrets and variables → Actions → New repository secret**.
   Lege vier Secrets an:

   | Name | Wert |
   | --- | --- |
   | `ANDROID_KEYSTORE_BASE64` | Inhalt der Zwischenablage aus Schritt 5 |
   | `ANDROID_KEYSTORE_PASSWORD` | dein Passwort aus Schritt 3 |
   | `ANDROID_KEY_ALIAS` | `paperless` |
   | `ANDROID_KEY_PASSWORD` | dasselbe Passwort wie oben |

7. Die Datei `paperless-release.jks` und das Passwort sicher aufbewahren (z. B. Passwortmanager
   und USB-Stick). Ohne sie kannst du keine Updates mehr bauen, die sich über die installierte
   App installieren lassen.

Hinweis: Eine mit dem neuen Schlüssel gebaute APK lässt sich **nicht** über die bisher
installierte Test-Version installieren. Deinstalliere die alte App einmal vorher.

## Teil 2: Google-Cloud-Projekt (etwa 20 Minuten)

1. [Google Cloud Console](https://console.cloud.google.com/) öffnen und mit deinem
   Google-Konto anmelden.
2. Oben links auf die Projektauswahl → **Neues Projekt** → Name `Paperless AI` → Erstellen.
   Danach sicherstellen, dass das neue Projekt oben ausgewählt ist.
3. **APIs aktivieren:** Im Suchfeld nach **Google Drive API** suchen → Aktivieren. Dasselbe
   für **Google Picker API**.
4. **Google Auth Platform → Branding:** App-Name `Paperless AI`, deine E-Mail als
   Support-Adresse und als Entwickler-Kontakt. Speichern.
5. **Zielgruppe (Audience):** Nutzertyp **Extern**. Danach **App veröffentlichen** bzw.
   **In Produktion** stellen. Im Status „Testen“ würde Google die Anmeldung alle 7 Tage
   verfallen lassen.
6. **Datenzugriff (Data Access) → Bereiche hinzufügen:** diese beiden auswählen:
   - `.../auth/drive.file`
   - `.../auth/drive.appdata`

   Google fragt eventuell nach einer Prüfung. Die ist für diese beiden Bereiche nicht nötig.
7. **Clients → Client erstellen → Android:**
   - Paketname: `dev.paperlessai.paperless_ai`
   - SHA-1-Fingerabdruck: der Wert aus Teil 1, Schritt 4
8. **Clients → Client erstellen → Desktop-App:** Name `Paperless AI Windows`.
   Google zeigt eine **Client-ID** und ein **Client-Secret**.

## Teil 3: Mir Bescheid geben

Schick mir im Chat:

- die **Client-ID des Android-Clients** (endet auf `.apps.googleusercontent.com`)
- die **Client-ID des Desktop-Clients**

Beide sind nicht geheim. Das **Client-Secret** des Desktop-Clients trägst du bitte als
weiteres GitHub-Secret `GOOGLE_DESKTOP_CLIENT_SECRET` ein (gleicher Weg wie in Teil 1,
Schritt 6). Google stuft es bei Desktop-Apps zwar nicht als geheim ein, ins Repo kommt es
trotzdem nicht.

Für den ersten Test (D0) brauche ich außerdem ein **zweites Google-Konto**, zum Beispiel das
deines Partners oder ein extra angelegtes Testkonto. Der Test zeigt, ob die App mit der
schmalen Berechtigung Dateien in einem geteilten Ordner lesen darf.
