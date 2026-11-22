# Technische Bestandsaufnahme Sattly

Stand: 22.11.2026, geprüft am Code auf `main` (Commit `85fd8fb`, App-Version 0.2.0+2, Drift-Schema 5),
nicht an README oder Roadmap. Grundlage: Quellcode unter `apps/mydiet/lib`, Tests unter `apps/mydiet/test`,
Workflows unter `.github/workflows`, lokaler Lauf von `flutter analyze` und `flutter test` (Flutter stable,
Dart 3.14). Ergebnis vor dieser Änderung: Analyse ohne Befund, 156 Tests grün.

## 1. Aufbau

| Bereich | Ort | Umfang |
|---|---|---|
| Rechenkern ohne UI | `lib/src/core/` (17 Dateien) | Energie, Makros, Gewichtstrend, adaptives Ziel, Wochenbudget, Rezepte, Wochenplan, Fasten, Supplemente, Datenqualität, Tageshinweise |
| Daten | `lib/src/data/` | Drift-Tabellen (`tables.dart`), `AppDatabase` (≈ 1.800 Zeilen), Backups, CSV, Open-Food-Facts-Client, Basis-Lebensmittel |
| Oberfläche | `lib/src/features/` (je Bereich ein Ordner), `lib/src/ui/` | Material 3, eigene Bausteine (`SectionCard`, `StatValue`, `combineLatest`) |
| Tests | `test/` (13 Dateien + Drift-Migrationstests) | Unit-Tests für jeden Rechenkern, Datenbanktests mit In-Memory-SQLite, Widget-Tests für App-Start, Navigation, Breitbild |
| CI | `.github/workflows/` | Format, Analyse, Tests, Prüfung der generierten Drift-Dateien; Builds für Windows (Installer + ZIP) und Android (APK); Release aus manuell gestartetem Lauf |

State-Management: bewusst ohne Zusatzpaket. Die Datenbank liefert reaktive Streams (`watch…`), die Seiten
bauen per `StreamBuilder` neu. Navigation: `HomeShell` mit 5 Zielen (unten auf dem Handy, Seitenleiste ab
840 px), Unterseiten per `Navigator.push`. Kein Routing-Paket, keine Deep Links.

## 2. Vollständig implementiert und getestet

- Profil mit Kalorienberechnung (Mifflin-St Jeor bzw. Katch-McArdle, PAL aus Beruf + Sport + Schlaf),
  Sicherheitsgrenzen, Rechenweg, Überschreiben einzelner Ziele
- Makro-Vorlagen (Ausgewogen, High Protein, Low Carb, Ketogen, Ausdauer) und Kohlenhydrat-Obergrenze
- Tagebuch: Suche, zuletzt/häufig je Mahlzeit, Mengen, Portionen, Bearbeiten, Löschen mit Rückgängig,
  Mahlzeit kopieren, Schnell-Eintrag (nur kcal), Mahlzeiten-Vorlagen
- Dashboard mit sortier- und ausblendbaren Kacheln, Tageshinweise (regelbasiert)
- Gewicht: 7-Tage-Trend, Tempo per Ausgleichsgerade, Prognose, Plateau, Wochen-/Monatsmittel, BMI
- Wochen-Check: adaptives Kalorienziel aus Aufnahme und Gewichtsverlauf, unvollständige Tage werden
  ausgeschlossen, gilt nur nach Bestätigung
- Wochenbudget, Modus „Zahlen ausblenden“
- Rezepte mit Endgewicht, Einkaufsliste mit Zusammenfassen, Wochenplan mit Auto-Füllen und Übernahme ins Tagebuch
- Supplemente mit Inhaltsstoffen, Summen über alle Präparate, Hinweise bis zur EFSA-Höchstmenge, Vorrat
- Intervallfasten mit Timer und Verlauf
- Barcode (Kamera Android, Eingabe/USB-Scanner Windows), Open Food Facts, Quelle und Qualitätsstufe je Lebensmittel
- JSON-Export/-Import, automatische tägliche Backups (14 Stände), CSV-Export
- Hell/Dunkel, 6 Farbschemata, Branding „Sattly“

## 3. Teilweise implementiert oder nur vorbereitet

| Funktion | Stand |
|---|---|
| Erinnerungen | PR #27 offen (Phase-2-Thread), noch nicht auf `main` |
| Mikronährstoffe aus Lebensmitteln | nur Supplemente; Lebensmittel haben keine Mikros. Phase-2-Thread baut W5 (Schema 6) |
| Online-Update | Code liegt in Commit `1265bf6`, zurückgestellt bis zu den Android-Signatur-Secrets |
| Aktivität | nur manuell; Tabelle hat `source` + `externalId` für spätere Importe (Health Connect, Garmin) |
| Sync | Datenmodell vorbereitet (UUID, `updatedAt`, Tombstones), kein Sync-Code |
| KI | nur Qualitätsstufe „Schätzung“ und Quelle „KI“ im Datenmodell; keine KI-Funktion |
| Gewichts-Dashboard | Trend und Prognose vorhanden; Start/bisher/verbleibend, 30-Tage-Trend, Bilanz und Proteinziel fehlten → **mit diesem PR umgesetzt** |

## 4. Fehler und Instabilitäten

Keine reproduzierbaren Abstürze gefunden; alle Tests grün. Auffällig:

- `docs/SICHERHEIT.md` behauptet „Die App baut keine Netzwerkverbindungen auf“. Seit dem Barcode-Scanner
  stimmt das nicht mehr (Open Food Facts, nur Barcode). → in diesem PR korrigiert.
- Gewichtsliste zeigt höchstens 120 Einträge ohne Hinweis, dass ältere fehlen.

## 5. Fehlende Funktionen (gegenüber führenden Apps)

Natürlichsprachige Eingabe und Foto-Erkennung, Spracheingabe, Mikronährstoffe aus Lebensmitteln,
Health Connect/Garmin, Erinnerungen (in Arbeit), Rezept-Import aus Webseiten, Homescreen-Widget,
„Alle Daten löschen“, App-Sperre, Fortschrittsfotos/Körpermaße-Verlauf, Import aus anderen Apps.
Details und Priorität: [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md).

## 6. Technische Schulden

| Schuld | Folge | Vorschlag |
|---|---|---|
| `AppDatabase` mit ≈ 1.800 Zeilen in einer Klasse | Konflikte zwischen parallelen Threads, schwer überschaubar | in Drift-`DatabaseAccessor` je Bereich aufteilen (Foods, Diary, Weight, Recipes, Plan, Supplements). Erst nach W5, um Konflikte zu vermeiden |
| `dashboard_page.dart` ≈ 870 Zeilen | jede Kachel ändert dieselbe Datei | Kacheln in eigene Dateien |
| Paketname `mydiet_ai`, DB-Name `mydiet` | nur intern, aber verwirrend | **bewusst so lassen** (Datenerhalt, siehe AI_DECISIONS) |
| Kein zentrales Fehlerprotokoll | Fehler auf Geräten unsichtbar | lokales Fehlerprotokoll ohne Gesundheitsdaten (P1-Aufgabe) |
| Kein Integrationstest auf echten Geräten | Kamera, Dateiauswahl, Windows-Pfade nur manuell geprüft | `integration_test` für Android-Emulator in CI (P2) |

## 7. Performance

- Lebensmittelsuche nutzt `LIKE '%wort%'` ohne Volltextindex. Bei 100 Basis-Lebensmitteln plus eigenen
  Produkten unkritisch; bei einem großen Katalog (Phase 4, gemeinsamer Katalog) wird FTS5 nötig.
- Indizes für alle Tages-Abfragen vorhanden (`diary_day`, `weight_day`, `water_day`, `activity_day`, …).
- Datenbank-Streams: Seiten mit vielen `combineLatest`-Streams bauen bei jeder Änderung komplett neu.
  Für die jetzige Datenmenge messbar unkritisch; bei Profiling auf Geräten erneut prüfen.
- Start: Basis-Lebensmittel werden nur bei neuer Seed-Version geschrieben (eine Transaktion).

## 8. Datenschutz und Sicherheit

| Thema | Stand | Risiko / Maßnahme |
|---|---|---|
| Speicherung | SQLite im privaten App-Speicher | Datei nicht zusätzlich verschlüsselt (Phase 5: SQLCipher) |
| Backups | JSON im App-Speicher, 14 Stände | unverschlüsselt, aber nur für die App lesbar; Export-Dateien liegen dort, wo der Nutzer sie speichert |
| Netzwerk | nur Open Food Facts, nur Barcode, generischer User-Agent | gering |
| Löschen | einzelne Einträge (Tombstones) | **„Alle Daten löschen“ fehlt** (Art. 17 DSGVO, P1-Aufgabe) |
| Protokolle | keine | keine Gesundheitsdaten in Logs, weil es keine Logs gibt; beim Fehlerprotokoll beibehalten |
| Berechtigungen Android | Internet, Kamera (Scanner) | angemessen |
| Schlüssel | keine API-Schlüssel im Code; Android-Signatur über Secrets (noch nicht angelegt) | KI-Schlüssel später nur im sicheren Speicher des Geräts |
