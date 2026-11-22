# Entwicklungsstand (für die nächste Sitzung)

Neueste Einträge oben. Jede Sitzung: zuerst diese Datei, [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md),
[AI_DECISIONS.md](AI_DECISIONS.md) und `git status` / offene PRs lesen, dann an der nächsten offenen Aufgabe
weiterarbeiten.

## 2026-11-22 – App-Sperre (Aufgabe 7.2 ohne Verschlüsselung)

Phase-2-Thread, nach Patricks Entscheidung „Nur App-Sperre“. `core/app_lock.dart` (PIN-Regeln, PBKDF2, Wartezeiten,
Sperrzeitpunkt, `LockConfig`), `data/app_lock_store.dart` (Datei `applock.json`, `local_auth`), `features/lock/`
(Sperrbildschirm mit Ziffernblock und Tastatur, `LockGate` über dem Navigator in `app.dart`, Einstellungsseite).
Neue Abhängigkeiten `local_auth`, `crypto`; Android AppCompat-Theme beim Start (D-18). Windows: `_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS` für das local_auth-Plugin in `windows/CMakeLists.txt`, weil der neue MSVC dessen `<experimental/coroutine>` sonst ablehnt. Kein Schema.

Tests: `test/app_lock_test.dart` (5, u. a. RFC-Testvektor), Widget-Test „App-Sperre“. Fingerabdruck auf dem Gerät
ungeprüft.

## 2026-11-22 – Gewichtsliste nachladen (Aufgabe 1.3)

`weight_page.dart`: Knopf „Ältere anzeigen (noch n)“ lädt jeweils 120 weitere. Widget-Test mit 131 Einträgen.

## 2026-11-22 – Open-Food-Facts-Textsuche (Aufgabe 3.4)

`OffClient.search()` (nur Suchbegriff, Produkte ohne Namen oder Energie fallen weg, nur gültige Barcodes),
`features/foods/off_search_page.dart`, Eintrag „Bei Open Food Facts suchen“ in der Auswahl beim Eintragen.
Entscheidung D-17. Tests: `test/off_search_test.dart` (3, Mock-Client), Widget-Test Suche → Formular → Eintrag.
Nächster Schritt: 6.1 Health Connect (mit Phase-2-Thread abstimmen), sonst 1.4/1.5.

## 2026-11-22 – Barrierefreiheit (Aufgabe 2.3)

`RingGauge(semanticLabel:)` + Prozentwert, `MacroBar` als ein Screenreader-Text, Gewichtskurve mit Zusammenfassung.
Überläufe bei 200 % behoben (Kalorienring skaliert den Innentext, Filter-Chips bei Lebensmitteln umbrechen).
Tests: zwei Widget-Tests (200 % auf Dashboard, Tagebuch, Gewicht, Essen, Profil; Semantics-Labels), Suite grün.
Offen: Unterseiten (Rezepte, Wochenplan, Einstellungen) bei 200 % noch nicht automatisch geprüft.
Nächster Schritt: 3.4 Open-Food-Facts-Textsuche.

## 2026-11-22 – Homescreen-Widget Android (Aufgabe 6.4, W13)

Phase-2-Thread. `core/widget_summary.dart` (Texte, Tausenderpunkte, freundlicher Status – `gentleStatus` nutzt ihn
jetzt mit), `data/home_widget_sync.dart` (gleiche Budget-Rechnung wie das Dashboard, sendet nur bei Änderung,
neu nach Mitternacht; auf Windows nichts), Start in `home_shell.dart`. Android: `SattlyWidgetProvider.kt`,
Layout, Widget-Info, Receiver im Manifest. Neue Abhängigkeit `home_widget` (D-16). dashboard_page.dart und
database.dart unverändert.

Tests: `test/home_widget_test.dart` (5). Android-Build im CI; Aussehen auf dem Gerät noch ungeprüft.

Nächster Schritt: App-Sperre (PIN/Fingerabdruck, ohne Verschlüsselung – Patricks Entscheidung 2026-11-22).

## 2026-11-22 – Stillstand erklären (Aufgabe 5.2)

`core/stall.dart` (`analyzeStall`), Abschnitt „Stillstand: woran es liegen kann“ in der Fortschritt-Karte
(Gewicht), Tagessummen dort jetzt 21 statt 7 Tage geladen. Bei „Zahlen ausblenden“ nicht angezeigt.
Tests: `test/stall_test.dart` (7), Suite grün. Nächster Schritt: 2.3 Barrierefreiheit.

## 2026-11-22 – Gewohnheiten erkennen (Aufgabe 5.1)

`core/habits.dart` (`findHabits`), `data/habits_data.dart` (Vorschläge aus 28 Tagen, Ablehnen per Setting
`habitsDismissed`, Speichern über `saveTemplateFromMeal`). Karte „Wiederkehrend: …“ oben in der Auswahl beim
Eintragen. Kein Schema. Tests: `test/habits_test.dart` (6), Suite grün. Nächster Schritt: 5.2.

## 2026-11-22 – Datenbank aufgeteilt (Aufgabe 1.4)

Rein strukturell. `lib/src/data/database.dart` (2076 Zeilen) behält Tabellen, Migration, Einstellungen, Seed,
Profil, Mahlzeiten-Slots, Hilfsfunktionen (`_tombstone`, `_restore`) und die Konstanten. Die Bereiche liegen als
`extension XxxDao on AppDatabase` in `part`-Dateien unter `lib/src/data/dao/` (foods, diary, templates, body =
Gewicht/Wasser/Aktivität, recipes, shopping, supplements, meal_plan, fasting, micros, export). Aufrufer bleiben
gleich (`db.addFood(...)`), nur Dateien, die `AppDatabase` bisher ohne Import von `database.dart` nutzten, importieren
es jetzt (Extensions brauchen den Import). Kein Schema, generierte Dateien unverändert.

Statt Drift-`DatabaseAccessor` gewählt, weil das alle Aufrufer (`db.dao.methode`) und Tests geändert hätte.
Neue Methoden gehören in die passende `dao/`-Datei; statische Konstanten bleiben in der Klasse.

Tests: alle 281 unverändert grün, `flutter analyze` ohne Befund.

## 2026-11-22 – Health Connect: Mahlzeiten schreiben (Aufgabe 6.1, Teil 2)

Phase-2-Thread. `core/health_export.dart` (Mahlzeit je Tag und Slot, Art aus Name/Uhrzeit), `HealthSource.writeDay`
(eigene Aufzeichnungen des Tages löschen, dann `writeMeal` mit `clientRecordId`), `exportNutrition` in
`data/health_sync.dart` (läuft mit jedem Abgleich, wenn eingeschaltet und freigegeben), Schalter auf der Health-Seite,
Berechtigung WRITE_NUTRITION. Kein Schema, keine Änderung an database.dart.

Tests: `health_import_test.dart` +3, Widget-Test „Health Connect“ erweitert. Auf Gerät noch ungeprüft.

Offen: Garmin Connect liest Ernährung nicht aus Health Connect; direktes Schreiben zu Garmin braucht die Garmin-API
(6.2, Entwicklerzugang durch Patrick). Nächster Schritt: Phase 5 App-Sperre.

## 2026-11-22 – Health Connect lesen (Aufgabe 6.1, Teil 1)

Phase-2-Thread, Branch `claude/project-thread-k8k628`.

Erledigt:
- `core/health_import.dart` (Zuordnung, ohne Flutter), `data/health_source.dart` (Paket `health`, austauschbar über
  `healthSourceFactory`), `data/health_sync.dart` (Übernehmen, Automatik alle 3 h), `AppDatabase.upsertExternalActivity`
  (Kennung, Tombstones respektiert, kein Schema)
- `features/settings/health_page.dart` + Kachel in den Einstellungen; Automatik beim Start in `home_shell.dart`
- Android: Health-Berechtigungen, Rationale-Intent, `FlutterFragmentActivity`, minSdk 26 (D-15)

Tests: `test/health_import_test.dart` (5) und Widget-Test „Health Connect“ in `app_test.dart`. Auf echtem Gerät
noch nicht geprüft (kein Android-Gerät in der Cloud), der Android-Build läuft im CI.

Nächster Schritt: Ernährung nach Health Connect schreiben (6.1 Teil 2), dann Phase 5 (App-Sperre, W13).

## 2026-11-22 – Portionen lernen (Aufgabe 3.2)

`core/portion_memory.dart` (`usualAmount`), `recentAmounts`/`usualLoggedAmount` in `data/meal_text_match.dart`.
Mengendialog: Vorbelegung + Chip „Wie üblich“; Text-Eintrag nutzt die übliche statt der letzten Menge.
Tests: `test/portion_memory_test.dart` (7), Suite grün. Nächster Schritt: 5.1 Gewohnheiten erkennen.

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
