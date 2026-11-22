# Datenschutzerklärung Sattly (Entwurf)

Stand: 22.11.2026. **Entwurf, keine Rechtsberatung.** Vor einer Veröffentlichung im Play Store müssen die Angaben
in eckigen Klammern ergänzt und der Text geprüft werden. Der Text beschreibt den Stand des Codes; bei neuen
Funktionen mit Datenübertragung (Sync, KI) muss er angepasst werden.

## 1. Verantwortlicher

[Name, Anschrift, E-Mail des Anbieters]

## 2. Grundsatz

Sattly speichert alle Eingaben (Profil, Tagebuch, Gewicht, Rezepte, Pläne, Supplemente, Erinnerungen) nur auf
deinem Gerät. Es gibt kein Benutzerkonto, keinen Server des Anbieters, keine Werbung, keine Analyse- oder
Tracking-Dienste. Der Anbieter erhält keine deiner Daten.

## 3. Welche Daten die App verarbeitet

| Daten | Zweck | Ort |
|---|---|---|
| Profil (Geschlecht, Geburtsdatum, Größe, Gewicht, Ziel, Aktivität, Ernährungsweise, Unverträglichkeiten) | Berechnung von Kalorien-, Makro- und Mikronährstoffzielen | nur auf dem Gerät |
| Tagebuch, Gewicht, Körpermaße, Wasser, Aktivität, Fasten, Supplemente | Anzeige, Auswertungen, Hinweise | nur auf dem Gerät |
| Automatische Sicherungen (letzte 14) | Wiederherstellung | privater App-Speicher |
| App-Sperre: nur ein Prüfwert der PIN (PBKDF2, nicht die PIN selbst) und die Einstellungen der Sperre | Schutz vor fremdem Zugriff auf dem Gerät | eigene Datei im privaten App-Speicher, nicht in Sicherungen oder Exporten |
| Homescreen-Widget (Android): Kalorien übrig, gegessen/Budget, Protein, Wasser von heute | Anzeige auf dem Startbildschirm, wenn du das Widget hinzufügst | Widget-Speicher der App auf dem Gerät; sichtbar für alle, die den Startbildschirm sehen |
| Fehlerprotokoll (letzte 50 technische Fehler, ohne Zahlen, Texte und Pfade) | Fehlersuche; nur auf deinen Wunsch kopierbar | privater App-Speicher |

Gesundheitsdaten im Sinne von Art. 9 DSGVO verarbeitest du damit selbst auf deinem Gerät; eine Übermittlung an
den Anbieter findet nicht statt.

## 4. Verbindungen ins Internet

Die App baut nur auf deine Aktion hin Verbindungen auf:

| Aktion | Empfänger | Gesendet |
|---|---|---|
| Unbekannten Barcode scannen | Open Food Facts (openfoodfacts.org, Frankreich) | nur die Barcode-Nummer |
| „Bei Open Food Facts suchen“ | Open Food Facts | nur der Suchbegriff |
| Rezept von Webseite übernehmen | die von dir eingegebene Webseite | Abruf dieser einen Adresse |

Dabei werden technisch bedingt deine IP-Adresse und ein allgemeiner App-Name (ohne Gerätekennung) übertragen.
Für die Verarbeitung beim Empfänger gilt dessen Datenschutzerklärung. Es werden keine Profil- oder
Tagebuchdaten mitgesendet.

## 4a. Health Connect (Android, nur wenn du es einschaltest)

Health Connect ist ein Datenspeicher von Android auf deinem Gerät. Sattly fragt die Berechtigungen erst, wenn du
in Einstellungen → Health Connect auf „Verbinden“ tippst, und du kannst sie dort oder in Health Connect jederzeit
entziehen.

- **Lesen:** Schritte, aktive und gesamte verbrannte Kalorien, Trainings und Gewicht der letzten Tage. Diese
  Werte können von anderen Apps stammen, zum Beispiel Garmin Connect, Samsung Health oder Google Fit. Sattly
  speichert sie als Aktivitäts- und Gewichtseinträge in der eigenen Datenbank auf dem Gerät.
- **Schreiben (eigener Schalter, standardmäßig aus):** Kalorien und Nährwerte je Mahlzeit der letzten 7 Tage.
  Andere Apps, denen du in Health Connect Lesezugriff gibst, können diese Werte dann sehen.
- Die Daten werden nur zwischen Sattly und Health Connect auf deinem Gerät ausgetauscht, nicht an den Anbieter.
  Sie werden nicht für Werbung verwendet und nicht verkauft.

## 5. Berechtigungen (Android)

- Internet: nur für die Aktionen in Abschnitt 4.
- Kamera: nur zum Scannen von Barcodes, Bilder werden nicht gespeichert.
- Benachrichtigungen: nur für die Erinnerungen, die du einschaltest; Start nach dem Neustart, damit
  Erinnerungen erhalten bleiben.
- Health Connect (Schritte, Kalorien, Training, Gewicht lesen; Ernährung schreiben): nur nach deiner Freigabe,
  siehe Abschnitt 4a.
- Fingerabdruck/Gesichtserkennung: nur wenn du die App-Sperre damit einschaltest; die Prüfung macht das
  Betriebssystem, Sattly erhält keine biometrischen Daten.

## 6. Speicherdauer und Löschung

Daten bleiben gespeichert, bis du sie löschst. Einstellungen → Daten → „Alle Daten löschen“ entfernt alle
Einträge endgültig, wahlweise auch die automatischen Sicherungen. Beim Deinstallieren der App löscht das
Betriebssystem den privaten App-Speicher. Exporte, die du selbst gespeichert hast, musst du selbst löschen.

## 7. Deine Rechte

Da der Anbieter keine Daten von dir erhält, kannst du Auskunft, Berichtigung, Löschung und Datenübertragbarkeit
direkt in der App ausüben (Ansehen, Bearbeiten, „Alle Daten löschen“, Export als JSON/CSV). Du hast das Recht auf
Beschwerde bei einer Datenschutz-Aufsichtsbehörde.

## 8. Keine medizinische Beratung

Berechnungen und Hinweise sind allgemeine Orientierung für gesunde Erwachsene und ersetzen keine ärztliche oder
ernährungstherapeutische Beratung.
