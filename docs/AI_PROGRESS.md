# Entwicklungsstand (für die nächste Sitzung)

Neueste Einträge oben. Jede Sitzung: zuerst diese Datei, [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md),
[AI_DECISIONS.md](AI_DECISIONS.md) und `git status` / offene PRs lesen, dann an der nächsten offenen Aufgabe
weiterarbeiten.

## 2026-11-22 – Dashboard „Eintragen“ und Gewichtstempo (Aufgaben 2.1 + 2.2)

Erledigt:
- `features/dashboard/quick_log_sheet.dart`: Knopf „Eintragen“ auf dem Dashboard, Mahlzeit per Uhrzeit
  vorausgewählt (`currentMealIndex`), Wege Suchen/Barcode/Text/Nur Kalorien/Gewicht.
- `FoodPickerPage(start: PickerStart.…)` startet direkt mit Scanner, Text-Eintrag oder Schnell-Eintrag.
- Gewichtskachel: „30 Tage: −x kg/Woche · Aussagekraft“ aus `trendWindow` (vorhandene Rechnung).
- Bewusst nicht umgebaut: Kalorienring und Makros waren schon die Hauptzahlen; keine neue Kachel, kein
  Eingriff in die Kachel-Reihenfolge (vermeidet Konflikte mit dem Wochenbericht des Phase-2-Threads).

Tests: Widget-Test „Dashboard: Eintragen in drei Taps“, gesamte Suite grün.
Nächster Schritt: 3.2 Portionen lernen.

## 2026-11-22 – Tippfehlertolerante Suche (Aufgabe 3.3)

Thread „Sattly auf Niveau führender Apps bringen“, Branch `claude/project-thread-58v9es` (nach PR #35).

Erledigt:
- `core/fuzzy_search.dart`: Editierdistanz (mit Vertauschung), Passung je Wort und Name, `rankCandidates`
  (Passung, dann eigene Nutzung, Favorit, Namenslänge). Rechenweg in BERECHNUNGEN.md.
- `data/food_search.dart`: `smartSearchFoods` (exakte Suche, bei < 5 Treffern unscharf ergänzt),
  `fuzzyFoods`, `foodUsage` (Einträge der letzten 180 Tage). `AppDatabase.searchFoods` unverändert.
- Lebensmittelsuche, Auswahl beim Eintragen und „Als Text eintragen“ nutzen die neue Suche; im Text-Eintrag
  sind unscharfe Treffer immer „unsicher“.
- Kein Schema, keine neue Abhängigkeit.

Tests: `test/fuzzy_search_test.dart` (13), gesamte Suite grün, Analyse und Format sauber.

Offen: Bei sehr großem Katalog (Phase 4) wird der unscharfe Durchlauf über alle Lebensmittel teuer → dann
FTS5/Trigramm-Index (3.6). Nächster Schritt: 2.1 + 2.2 Heute-Seite entschlacken mit Gewichts-Kachel.

## 2026-11-22 – Alle Daten löschen und Fehlerprotokoll (Aufgaben 1.1 + 1.2)

Thread „Sattly auf Niveau führender Apps bringen“, Branch `claude/project-thread-58v9es`.

Erledigt:
- `AppDatabase.deleteAllData()`: löscht alle Tabellen (`allTables`, also auch künftige) in einer Transaktion
  endgültig, danach Standard-Mahlzeiten, Basis-Lebensmittel und Mikronährstoff-Richtwerte wie bei Neuinstallation.
  `BackupService.deleteAll()`. UI `features/settings/delete_all.dart`: Dialog mit Eingabe „LÖSCHEN“, Wahl ob
  Sicherungen mitgelöscht werden, Erinnerungen werden abgemeldet, Fehlerprotokoll geleert
- Fehlerprotokoll: `core/error_report.dart` (Bereinigung: Zahlen, Zitate, Pfade, E-Mails raus; nur eigene
  Stack-Frames), `data/error_log.dart` (JSON-Zeilen im App-Speicher, letzte 50, Installation in `main.dart` für
  `FlutterError.onError` und `PlatformDispatcher.onError`), Seite `features/settings/error_log_page.dart`
- Doku: CHANGELOG, SICHERHEIT, AI_TASK_QUEUE

Tests: `flutter analyze` ohne Befund, `dart format` sauber, `flutter test` 235 grün; neu
`test/delete_all_test.dart` (3), `test/error_log_test.dart` (5), Widget-Test „Alle Daten löschen“.

Nächster Schritt: 3.3 tippfehlertolerante Suche.

## 2026-11-22 – Als Text eintragen (Aufgabe 3.1)

Thread „Sattly auf Niveau führender Apps bringen“, Branch `claude/project-thread-58v9es` (neu von `main` nach #28).

Erledigt:
- Rechenkern `core/meal_text.dart`: Zerlegen, Mengen/Einheiten/Zahlwörter/Brüche, Suchbegriffe mit Synonymen und
  Einzahl, Umrechnung in die Einheit des Lebensmittels mit Kennzeichnung jeder Annahme, Trefferqualität
- Daten `data/meal_text_match.dart`: Abgleich nur mit der eigenen Datenbank, zuletzt eingetragene Menge als
  Vorschlag (keine Änderung an `database.dart`, kein Schema)
- UI `features/diary/text_entry_page.dart`: Textfeld, erkannte Zeilen mit Häkchen (nur sichere vorausgewählt),
  Lebensmittel per Auswahl ändern, Menge per Mengendialog, fehlendes Lebensmittel anlegen, Summe, Eintragen.
  Einstieg im Hinzufügen-Dialog: Symbol „Als Text eintragen“ und Vorschlag „Ganze Mahlzeit erkennen“, wenn
  die Suche wie eine Mahlzeit aussieht
- Doku: BERECHNUNGEN (neuer Abschnitt), CHANGELOG, AI_TASK_QUEUE, AI_DECISIONS (D-13)

Tests: `flutter analyze` ohne Befund, `dart format` sauber, `flutter test` 200 grün; neu
`test/meal_text_test.dart` (18 Tests: Parser, Umrechnung, Datenbank-Abgleich) und ein Widget-Test in
`test/app_test.dart` (erkennen, Unsicheres bestätigen, eintragen, Mengen geprüft).

Offen / bekannt:
- Synonymliste ist klein und auf die Basis-Lebensmittel zugeschnitten; wächst mit 3.3 (tippfehlertolerante Suche).
- Rezept-Import (W9, Phase-2-Thread) kann `parseLine()` für Zutatenzeilen nutzen.

Nächster Schritt: 1.1 „Alle Daten löschen“.

## 2026-11-22 – Phase-2-Thread: Erinnerungen, W5 Mikronährstoffe, W8 PC-Planung, 4.1 Wochenplan + Profil, W9 Rezept-Import, 5.4 Wochenbericht

Thread „MyDiet AI Phase 2 entwickeln“, Branch `claude/project-thread-k8k628`.

Erledigt:
- Erinnerungen (#27) und W5 Mikronährstoffe mit Schema 6 (#29) sind auf main.
- W8 PC-Planung (#32):
  - `features/plan/plan_view.dart`: `planColumns` (ab ca. 550 px Tage nebeneinander, bis 7 Spalten), Einträge
    ziehbar (Maus sofort, Touch per langem Drücken), Ablegen auf einem Tag verschiebt, mit Strg kopiert,
    Menüpunkte „Auf anderen Tag verschieben/kopieren …“, Rückgängig. Einträge, die schon im Tagebuch stehen,
    werden nicht verschoben (nur kopiert).
  - `AppDatabase.copyPlanEntry`.
  - `features/home_shell.dart`: Tastenkürzel (`shortcutHelp`, F1/Strg+/ zeigt die Übersicht, Tastatur-Knopf
    in der Seitennavigation), `DateNav` für Seiten mit Datum (Tagebuch, Wochenplan).
  - `core/meal_time.dart`: `currentMealIndex` wählt für Strg+E die fällige Mahlzeit.
  - Essen-Bereich: Wochenplan bis 1800 px breit, die anderen Tabs bleiben bei 900 px.

Tests: `flutter analyze` ohne Befund, neue Unit-Tests `test/meal_time_test.dart`, Widget-Test
„PC: Wochenplan nebeneinander, Ziehen auf anderen Tag, Tastenkürzel“.

- 4.1 Wochenplan und Profil: `core/meal_plan.dart` (`foldText`, `avoidSynonyms`, `avoidTermsFor`, `mentions`,
  `excludedBy`, `preferenceScore`, `preferFirst`, `PlanFill`), `generatePlanFor` liefert jetzt `PlanFill`
  (geplant + ausgelassen mit Grund, Parameter `useProfile`). Tests `test/meal_plan_filter_test.dart` und
  ein Datenbanktest in `plan_fasting_test.dart`.
- W9 Rezept-Import: `core/recipe_import.dart` (JSON-LD finden auch in `@graph`/Listen/mehreren Typen,
  `parseYield`, `parseIsoMinutes`, `cleanText`, `ingredientCore`, `isNegligibleIngredient`),
  `data/recipe_import_client.dart` (`RecipePageClient` mit Größen- und Zeitlimit, `recipePageClientFactory`
  für Tests, `recipeFromPastedText`, `matchIngredients` auf Basis von `matchMealText`),
  `features/recipes/recipe_import_page.dart`, Link-Knopf in der Rezeptliste. Tests `test/recipe_import_test.dart`
  (7) und Widget-Test „Rezept von Webseite übernehmen“.
- 5.4 Wochenbericht: `core/weekly_report.dart` (`buildWeeklyReport`, `Finding`, `goalFrom`),
  `data/weekly_report_data.dart` (`loadWeeklyReport`, `defaultReportMonday`),
  `features/report/weekly_report_page.dart` (Seite + Kachel `DashTile.weeklyReport`, am Enum-Ende).
  Tests `test/weekly_report_test.dart` (7) und Widget-Test „Wochenbericht“.

Offen: Tabellen mit wählbaren Spalten (Aufgabe 2.5). Online-Update wartet auf die Android-Signatur-Secrets
(Code in Commit 1265bf6, Anleitung docs/UPDATES.md im Branch-Verlauf).

Nächster Schritt dieses Threads: Phase 4 Health Connect (6.1) und Sync-Konzept (6.3, Freigabe nötig). W10 gehört laut Aufteilung dem Thread „MyDiet AI besser machen“.

## 2026-11-22 – Bestandsaufnahme, Wettbewerb, Gewichts-Dashboard

Thread „Sattly auf Niveau führender Apps bringen“, Branch `claude/project-thread-58v9es`.

Erledigt:
- Technische Bestandsaufnahme am Code: [BESTANDSAUFNAHME.md](BESTANDSAUFNAHME.md)
- Wettbewerbsanalyse ergänzt um Lifesum und aktuellen Stand YAZIO/MFP, Vergleichsmatrix:
  [WETTBEWERB-MATRIX.md](WETTBEWERB-MATRIX.md)
- Priorisierte gemeinsame Aufgabenliste P1–P7: [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md)
- Umgesetzt: Gewichts-Dashboard „Fortschritt“ auf der Gewichtsseite
  - Rechenkern `apps/mydiet/lib/src/core/weight_progress.dart`: Start/bisher/verbleibend aus dem
    7-Tage-Mittel, Vergleich zur Vorwoche, 30-Tage-Trend (Ausgleichsgerade, Veränderung entlang der Geraden,
    Streuung der Einzelmessungen, Aussagekraft), Prognose nur bei ausreichender Datenlage, Ernährung der
    letzten 7 Tage (Ø kcal gegen Ziel, Bilanz gegen geschätzten Verbrauch, erwartete kg/Woche,
    Proteinziel an x von y Tagen)
  - UI `features/weight/progress_card.dart`, eingebunden in `weight_page.dart`; Modus „Zahlen ausblenden“
    wird bei Kalorien beachtet; Erklärung „Wie wird gerechnet?“
  - Vergleich „Bilanz erklärt X kg/Woche, Waage zeigt Y“ mit möglichen Ursachen (ohne Diagnose)
- Doku: `docs/BERECHNUNGEN.md` (Abschnitt Gewichts-Dashboard), `docs/SICHERHEIT.md` (Netzwerk-Aussage
  korrigiert), CHANGELOG, `CLAUDE.md`

Tests: `flutter analyze` ohne Befund, `dart format` sauber, `flutter test` 173 Tests grün (vorher 156)
(16 neue Unit-Tests in `test/weight_progress_test.dart`, 1 Widget-Test in `test/app_test.dart`, Handy- und
Breitbild).

Offen / bekannt:
- Kein Schema-Eingriff; Abstimmung mit Phase-2-Thread: der baut W5 mit Schema v6 und eine neue
  Dashboard-Kachel am Ende des `DashTile`-Enums. Eine Fortschritts-Kachel fürs Dashboard (Aufgabe 2.2)
  erst nach W5.
- Lokal installiertes Flutter: `git clone --depth 1 -b stable https://github.com/flutter/flutter.git /opt/flutter`.

Nächster Schritt: Aufgabe 3.1 „Texteingabe ohne KI“ (siehe Aufgabenliste).
