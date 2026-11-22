# CLAUDE.md – Regeln für die Entwicklung von Sattly

Sattly ist eine Ernährungs-, Kalorien- und Abnehm-App (Flutter/Dart, Android + Windows, iOS später),
offline-first mit SQLite/Drift. Sprache mit dem Auftraggeber (Patrick) und in Doku, Commits und UI: **Deutsch**.

## Beim Start jeder Sitzung

1. `docs/AI_PROGRESS.md`, `docs/AI_TASK_QUEUE.md`, `docs/AI_DECISIONS.md` lesen.
2. `git status`, `git log --oneline -10`, offene Pull Requests prüfen.
3. Den Code prüfen, nicht nur die Doku – sie kann hinterherhinken.
4. An der nächsten offenen Aufgabe der Warteschlange weiterarbeiten.

## Grundregeln

- **Nicht neu schreiben.** Bestehende Architektur, Daten, Berechnungen und Funktionen erhalten und gezielt erweitern.
- Kleine, abgeschlossene Schritte; je Schritt ein PR mit Tests. Nur zusammenhängende Bereiche ändern.
- Keine neue Abhängigkeit ohne klaren Grund (in AI_DECISIONS festhalten).
- Nichts als fertig bezeichnen, was nicht implementiert **und** getestet ist.
- Berechnungen gehören in `apps/mydiet/lib/src/core/` (ohne Flutter-Import), mit Unit-Tests und Eintrag in
  `docs/BERECHNUNGEN.md`. Jede Zahl muss erklärbar sein (Rechenweg/Aussagekraft).
- KI erfindet keine Nährwerte; Schätzungen sind gekennzeichnet und bestätigungspflichtig. Keine Diagnosen,
  keine gefährlichen Empfehlungen (Kalorien-Untergrenzen in `core/energy.dart` beachten).
- Fremde Apps nicht dekompilieren oder kopieren; Lebensmitteldaten nur aus freien Quellen.
- Keine Geheimnisse im Repo, keine Gesundheitsdaten in Logs.

## Freigabe durch Patrick nötig

Destruktive Änderungen, Datenbankmigrationen mit möglichem Datenverlust, kostenpflichtige externe Dienste,
Änderungen an Sicherheitsmechanismen. Normale, risikoarme Entwicklung ohne Rückfrage.

## Zusammenarbeit mehrerer Threads

- Drift-Schema-Version **vorher** beim Thread „MyDiet AI Phase 2 entwickeln“ reservieren (v6 = W5 Mikronährstoffe).
- PRs als Entwurf öffnen, bei grüner CI als „Ready for review“ markieren, **nicht selbst mergen**. Merges,
  Versionsnummer (`pubspec.yaml`), CHANGELOG-Überschriften und Releases (`mydiet-vX.Y.Z`) macht der Thread
  „Threads überwachen und Updates veröffentlichen“. Während eines Release-Laufs nichts auf `main` mergen.
- CHANGELOG-Einträge nur unter „## Nächste Version (in Arbeit)“.
- Konflikte durch Merge von `main` in den Branch lösen, kein Force-Push. Generierte Dateien
  (`*.g.dart`, `test/drift/**`, `drift_schemas/**`) nie von Hand mergen, sondern neu erzeugen.

## Befehle (im Ordner `apps/mydiet`)

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # nach Änderungen an tables.dart/database.dart
dart run drift_dev make-migrations                         # nach Erhöhung von schemaVersion
dart format --output=none --set-exit-if-changed $(git ls-files 'lib/*.dart' 'test/*.dart' | grep -v '\.g\.dart$')
flutter analyze
flutter test                      # alles; einzelne Datei: flutter test test/<datei>_test.dart
```

Nie `dart format` auf `*.g.dart`. CI (`.github/workflows`) prüft Format, Analyse, Tests und generierte Dateien.

## Nicht ändern (Datenerhalt bei Updates)

applicationId `de.mydietai.mydiet_ai`, Paketname `mydiet_ai`, `mydiet_ai.exe`, DB-Name `mydiet`,
Exportformat `mydiet-export`, Inno-Setup-AppId, CompanyName/ProductName in `windows/runner/Runner.rc`,
Tag-Schema `mydiet-vX.Y.Z`, Release-Dateinamen `MyDietAI-*`. Nur Anzeigenamen (`lib/src/branding.dart`).

## Nach jedem abgeschlossenen Schritt

`docs/AI_PROGRESS.md` (was, Tests, offene Punkte, nächster Schritt), `docs/AI_TASK_QUEUE.md` und bei Bedarf
`docs/AI_DECISIONS.md` aktualisieren, CHANGELOG ergänzen, committen. Bei drohendem Kontextlimit zuerst einen
sauberen, getesteten Zwischenstand committen und pushen.
