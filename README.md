# MyDiet AI

Persönliche Ernährungs-, Kalorien- und Abnehm-App für Android und Windows (iOS später).
Eine Codebasis in Flutter, Daten offline-first in einer lokalen SQLite-Datenbank.

> Dieses Repository enthielt bis November 2026 die App „Paperless AI“. Der letzte Stand ist über die
> Git-Historie (Commit `a262499`) und die Releases `v0.7.0`/`v0.8.0` erreichbar.

## Stand

**Phase 1 (Grundsystem) ist fertig:** Profil mit automatischer Kalorien- und Makroberechnung,
anpassbares Dashboard, Lebensmitteldatenbank mit 100 Basis-Lebensmitteln und eigenen Produkten,
Ernährungstagebuch, Gewichtstracking mit Trend, Prognose und Plateau-Erkennung, Wasser, Aktivität,
Export/Import, Hell/Dunkel-Modus. Alles läuft lokal ohne Internet.

Noch nicht enthalten (siehe [Roadmap](docs/ROADMAP.md)): Barcode, Rezepte, Ernährungspläne,
Supplemente (Phase 2), KI (Phase 3), Sync und Smartwatch (Phase 4).

## Dokumentation

| Dokument | Inhalt |
|---|---|
| [docs/ANALYSE.md](docs/ANALYSE.md) | Technische Analyse und Technologievergleich |
| [docs/ROADMAP.md](docs/ROADMAP.md) | Phasen und Fortschritt |
| [docs/ARCHITEKTUR.md](docs/ARCHITEKTUR.md) | Aufbau der App |
| [docs/DATENMODELL.md](docs/DATENMODELL.md) | Tabellen, Sync-Vorbereitung, Export |
| [docs/BERECHNUNGEN.md](docs/BERECHNUNGEN.md) | Alle Formeln und Annahmen |
| [docs/SICHERHEIT.md](docs/SICHERHEIT.md) | Sicherheits- und Datenschutzkonzept |
| [CHANGELOG.md](CHANGELOG.md) | Änderungen je Version |

## Installation

Fertige Dateien entstehen in GitHub Actions („Build apps“): Windows-Installer (`MyDietAI-Setup-*.exe`),
portable ZIP und Android-APK (`MyDietAI-Android-*.apk`). Ein Release entsteht über
Actions → Build apps → Run workflow mit `release_tag`, z. B. `mydiet-v0.1.0`.

## Entwicklung

Voraussetzung: Flutter stable (getestet mit 3.50.1, Dart 3.14).

```bash
cd apps/mydiet
flutter pub get
flutter test                 # alle Tests
flutter run -d windows       # oder: -d <android-gerät>
```

Nach Änderungen an `lib/src/data/tables.dart` oder `database.dart` den Datenbankcode neu erzeugen:

```bash
dart run build_runner build
```

Die CI prüft generierten Code, Formatierung (`dart format`, Zeilenlänge 120), `flutter analyze` und alle Tests.

Web-Vorschau (nur für Entwicklung und Oberflächentests): `flutter build web --no-web-resources-cdn`.
`web/sqlite3.wasm` und `web/drift_worker.js` müssen zu den Versionen von `sqlite3` und `drift` in
`pubspec.lock` passen (GitHub-Releases von simolus3/sqlite3.dart und simolus3/drift).
