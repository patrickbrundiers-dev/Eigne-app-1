# Technische Analyse

Stand: 22.11.2026, vor Beginn von Phase 1.

## 1. Ausgangslage

- Das Repository enthielt bis zu diesem Stand die App „Paperless AI“ (Flutter-Client, FastAPI-Backend,
  PostgreSQL). Auf Wunsch wurde sie entfernt; MyDiet AI wird komplett neu entwickelt.
  Der alte Stand bleibt über die Git-Historie erreichbar: letzter Commit `a262499` auf `main`,
  Releases `v0.7.0` und `v0.8.0`.
- Ziel: eigenständige Ernährungs-, Kalorien- und Abnehm-App für Android und PC (Windows), später iOS,
  mit geräteübergreifender Synchronisierung, Supplement-Verwaltung und KI-Unterstützung.
- Wichtigste Qualitätsziele (aus dem Auftrag): korrekte und nachvollziehbare Berechnungen,
  keine doppelten Lebensmittel oder Aktivitätskalorien, keine Datenverluste, offline nutzbar,
  besonderer Schutz der Gesundheitsdaten, keine Platzhalter als fertige Funktion.

## 2. Anforderungen, die die Architektur bestimmen

| Anforderung | Folge für die Architektur |
|---|---|
| Android + PC aus einer Codebasis, iOS später | plattformübergreifendes UI-Framework mit nativen Builds |
| Tracking muss offline funktionieren | lokale Datenbank auf dem Gerät ist die primäre Datenquelle (offline-first) |
| Zentrale Datenbank, Sync bei Verbindung | Server-Datenbank als Replikat, Sync über Änderungsprotokoll |
| Gesundheitsdaten besonders schützen | Daten bleiben lokal bis zum Sync; TLS; Zugriffsschutz pro Benutzer; Datensparsamkeit |
| Nachvollziehbare Berechnungen | Rechenkern ohne UI-Abhängigkeit, vollständig unit-getestet, mit Rechenweg |
| Langfristig wartbar, modular | klare Schichten: Rechenkern / Daten / Oberfläche; spätere Module (KI, Integrationen) als eigene Pakete |
| Integrationen (Health Connect, Garmin, Apple Health) | native Plattform-Plugins nötig; Datenmodell mit Quelle + externer ID |

## 3. Technologievergleich

### Client

| Kriterium | **Flutter** | React Native | Web-App (PWA) + Capacitor/Tauri | Kotlin Multiplatform |
|---|---|---|---|---|
| Android + Windows aus einer Codebasis | ja, beide offiziell | Windows nur über Microsoft-Fork | ja, aber zwei Hüllen (Capacitor, Tauri/Electron) | UI für Windows nur über Compose Desktop |
| iOS später | ja | ja | ja | ja |
| Offline-Datenbank | SQLite über drift (typisiert, reaktiv, Migrationen) | SQLite-Bindings | IndexedDB/SQLite-WASM, eingeschränkt | SQLDelight |
| Health Connect / Apple Health / Garmin | Plugins vorhanden (`health`), Garmin per REST | Plugins vorhanden | nur über native Brücken | nativ |
| Diagramme, moderne UI | sehr gut (Material 3, fl_chart) | gut | sehr gut | gut |
| Vorhandene Infrastruktur im Repo | CI-Builds für exe + apk existierten bereits | – | – | – |
| Einschätzung | **gewählt** | Windows-Support zu schwach | zu viele Laufzeitumgebungen, schwächerer Offline-/Sensorzugriff | kleineres Ökosystem für Desktop-UI |

**Entscheidung:** Flutter (Dart). Eine Codebasis für Android, Windows, später iOS; die Web-Version
dient nur als Vorschau und für automatisierte Oberflächentests.

### Lokale Datenbank

| | **SQLite + drift** | Isar | Hive | ObjectBox |
|---|---|---|---|---|
| Relationen, Abfragen, Summen | voll (SQL) | eingeschränkt | nein | eingeschränkt |
| Transaktionen, Migrationen | ja | ja | nein | ja |
| Wartungsstand | aktiv | Fork nötig | im Wartungsmodus | kommerziell |
| Verschlüsselung | SQLCipher möglich | ja | ja | ja |
| Passt zu PostgreSQL-Server | gleiche relationale Struktur | nein | nein | nein |

**Entscheidung:** SQLite mit drift. Gleiche relationale Struktur wie die spätere PostgreSQL-Datenbank,
echte Transaktionen (wichtig gegen Datenverluste), reaktive Abfragen für die Oberfläche.

### Zentrale Datenbank und Sync (entschieden von Patrick am 22.11.2026)

| Option | Vorteile | Nachteile |
|---|---|---|
| **Gehostetes PostgreSQL in der EU** (z. B. Supabase, Region Frankfurt) | echtes PostgreSQL, kein eigener Server, Benutzerverwaltung und Row-Level-Security eingebaut, automatische Backups | Daten liegen bei einem Anbieter (Auftragsverarbeitung, EU-Region), laufende Kosten ab größerer Nutzung |
| Eigener Server (FastAPI + PostgreSQL) auf dem PC über Tailscale | volle Kontrolle | PC muss laufen, eigene Wartung, eigene Backups |
| Google Drive ohne Datenbank | kein Server | kein PostgreSQL, Sync und Konflikte aufwendiger, keine Abfragen serverseitig |

**Entscheidung:** gehostetes PostgreSQL in der EU. Umsetzung in Phase 4. Bis dahin arbeitet die App
vollständig lokal; das Datenmodell ist bereits sync-fähig (siehe [DATENMODELL.md](DATENMODELL.md)).

Geplantes Sync-Verfahren (Phase 4):
- jede Tabelle hat UUID, `created_at`, `updated_at` (Millisekunden) und `deleted_at` (Tombstone statt Löschen),
- Gerät schickt alle Zeilen mit `updated_at` > letztem Sync-Zeitpunkt, Server antwortet mit seinen Änderungen,
- Konflikte: „letzte Änderung gewinnt“ pro Zeile; Tagebuch-Einträge sind unabhängige Zeilen und kollidieren
  dadurch praktisch nie,
- Row-Level-Security: jede Zeile gehört genau einem Benutzer.

### Weitere Bausteine

- Diagramme: `fl_chart`. Datei-Export/-Import: `file_picker`. Datumsformate: `intl` (de_DE).
- Schrift: Inter (OFL-Lizenz, im App-Paket enthalten, damit Android und Windows gleich aussehen).
- KI (Phase 3): Anbieter offen. Anforderungen: EU-Verarbeitung oder lokales Modell, keine Speicherung der
  Daten beim Anbieter, strukturierte Ausgabe (JSON) mit Konfidenz. Jede KI-Schätzung wird in der App als
  Schätzwert gekennzeichnet und erst nach Bestätigung gespeichert.
- Barcode (Phase 2): Kamera-Scanner + Open Food Facts als Produktdatenbank (freie Lizenz, ODbL).

## 4. Risiken

| Risiko | Gegenmaßnahme |
|---|---|
| Formeln überschätzen den Bedarf (besonders bei hohem Körpergewicht) | konservative PAL-Werte, Sicherheitsgrenzen, später Anpassung aus echtem Gewichtsverlauf (Wochenanalyse) |
| Falsche Nährwerte in der Datenbank | Plausibilitätsprüfung bei jeder Eingabe; Basiswerte als Richtwerte markiert |
| Doppelte Aktivitätskalorien | Sport steckt im PAL; Anrechnung standardmäßig 0 %; Quelle + externe ID eindeutig |
| Datenverlust vor dem Sync | Transaktionen, Tombstones, JSON-Export/-Import; Sync in Phase 4 |
| Medizinische Aussagen | regelbasierte Hinweise ohne Diagnose; Supplement-Dosierungen nur aus Herstellerangaben (Phase 2) |
