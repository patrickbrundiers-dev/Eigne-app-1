# Entwicklungsstand (für die nächste Sitzung)

Neueste Einträge oben. Jede Sitzung: zuerst diese Datei, [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md),
[AI_DECISIONS.md](AI_DECISIONS.md) und `git status` / offene PRs lesen, dann an der nächsten offenen Aufgabe
weiterarbeiten.

## 2026-11-22 – Android-Emulator-Tests in der CI (Aufgabe 7.4)

Phase-2-Thread, Patrick: „Android auch testen“. `integration_test/app_android_test.dart` (4 Tests: Datenbank als
Datei schreiben/wieder öffnen, App-Sperre-Datei, Widget-Daten an Android, App-Start Einrichtung → Dashboard →
Tagebuch). Job `android-emulator` in `.github/workflows/mydiet-ci.yml` (Android 14, x86_64, KVM). Lokal nur
`flutter analyze`, ausgeführt werden die Tests erst in der CI. Format-Prüfung umfasst jetzt auch `integration_test/`.

## 2026-11-22 – Datenbank verschlüsselt (7.2)

Patrick (19:10): „Datenbank verschlüsseln“. Umgesetzt nach D-24: `lib/src/data/db_encryption.dart`
(`prepareEncryptedDatabase`, ohne Flutter-Import), `lib/src/data/app_database_open.dart` (`openAppDatabase`,
Schlüssel in `flutter_secure_storage`), `AppDatabase.openEncrypted/openPlain`, `main.dart` öffnet darüber.
Hinweisdialog nach beiseitegelegter Datei, Fehlerseite `StartupErrorApp`, Status unter Einstellungen →
App-Sperre. Android `allowBackup="false"`. Keine Schemaänderung (v8 nicht reserviert).
Tests: `db_encryption_test.dart` (Neuinstallation, Umstellung mit Datenvergleich und Schemaversion, WAL-Reste,
Schlüssel verloren/falsch, Speicher nicht lesbar/beschreibbar, abgebrochene Umstellung) und zwei Widget-Tests in
`app_test.dart`. Offen: auf Android und Windows ungeprüft (Windows-Build braucht ATL, auf GitHub-Runnern
vorhanden); Android-Emulator-Test aus #57 kann Schlüssel und Umstellung echt prüfen; 7.2b Sicherungen verschlüsseln.

## 2026-11-22 – Redesign Schritt 6: Profil & Einstellungen (Design 2)

`profile_page.dart`: Profilkarte mit Avatar (Anfangsbuchstabe), Name groß, „Bearbeiten“ und Fakten-Chips;
„Deine Tagesziele“: Makros, Ballaststoffe und Wasser als `StatStrip` in Makrofarben (kcal-Werte bleiben
`StatValue`). `settings_page.dart`: Erinnerungen, Health Connect, App-Sperre und Fehlerprotokoll als eine Liste
in einer Karte; Farbfeld „Frisch (Grün)“ zeigt den echten Design-Akzent (dunkel Limette). Die Seite baut ihre
Karten jetzt in einer `SingleChildScrollView` statt `ListView`: beim Lazy-Neuaufbau einer Karte wurde derselbe
im build erzeugte Stream ein zweites Mal abonnieren („Stream has already been listened to“), sichtbar nach der
Umgruppierung im Test „Alle Daten löschen“. Tests: alle grün, `app_test.dart` prüft die Makro-Leiste im Profil.
Damit sind alle Bereiche aus REDESIGN.md Abschnitt 5 umgestellt. Offen (nicht Teil der Freigabe): eigene
Lebensmittel-Bilder statt Anfangsbuchstaben, Unterseiten (Essen, Rezepte, Wochenplan) erben das Design über
das Theme.

## 2026-11-22 – Redesign Schritt 5: Gewicht & Fortschritt (Design 2)

`weight_page.dart`: Seite heißt „Fortschritt“ (wie die Navigation). Oben großes Trendgewicht (Zahlenschrift 52)
mit „zuletzt …“, daneben eckige Plus-Taste „Gewicht eintragen“ (ersetzt den schwebenden Knopf, der Inhalte
verdeckte; Eintragen geht außerdem über das zentrale Plus). Darunter `StatStrip` Pro Woche · BMI · Ziel mit
Erläuterungszeile (`StatStrip(notes:)` neu). Karte „Fortschritt“ heißt jetzt „Zielfortschritt“ wie die
Startseiten-Kachel. Plateau-Hinweis und Ziellinie im Diagramm in Warnfarbe aus den Tokens, Listenwerte in
Zahlenschrift. Rechenwerte unverändert. Tests: `app_test.dart` an neuen Kartentitel angepasst. Nächster Schritt:
Profil & Einstellungen.

## 2026-11-22 – Redesign Schritt 4: Tagebuch (Design 2)

`diary_page.dart`: Tageskopf als `StatStrip` (Gegessen · Ziel/Ziel (Woche) · Übrig/Zu viel), Kalorienbalken mit
Screenreader-Text, Makro-Balken in Makrofarbe. Mahlzeitenkarten: Plus als eckige Taste, Einträge mit
Anfangsbuchstabe (`_FoodInitial`, Platzhalter bis eigene Bilder kommen), zweite Zeile mit farbigen Makropunkten
(`_EntryLine`, Punkte als Widget, weil Barlow kein „●“ hat), kcal in Zahlenschrift. PC-Tabellen: Kopfzeile über
`dataTableTheme` (gilt für alle Tabellen). Wischen zum Löschen, Menü, Tabellen-Spalten unverändert. Tests: alle
grün, `app_test.dart` prüft Kennzahl-Leiste und Makrozeile. Nächster Schritt: Gewicht & Fortschritt.

## 2026-11-22 – Redesign Schritt 3: Startseite (Design 2)

Neue Bausteine `lib/src/ui/design/components.dart`: `ConcentricRings` (Kalorien außen, Protein, Wasser),
`StatStrip` (Kennzahlen mit farbiger Kante, Beschriftung groß), `LegendRow`. Kachel „Kalorien heute“: Ringe,
große Zahl „kcal übrig“, Legende in Prozent, Leiste Gegessen · Tagesbudget · Bewegt. Makros untereinander mit
Prozent (`MacroBar(showPercent:)`). Zahlen ausblenden und Wochenbudget wie bisher. Tests: Komponenten-Test in
`design_tokens_test.dart`, `app_test.dart` an große Beschriftung angepasst. Nächster Schritt: Tagebuch.

## 2026-11-22 – Redesign Schritt 2: Navigation mit zentralem Plus

Handy: eigene untere Leiste (`_BottomBar` in `home_shell.dart`) Heute · Tagebuch · **+** · Fortschritt · Essen;
das Plus öffnet `showQuickLogSheet` (Suchen, Barcode, Text, Nur kcal, Gewicht). Profil über den Avatar oben auf
„Heute“ (Key `profile-avatar`), am PC weiter in der Seitenleiste, dort oben eine Plus-Taste. „Gewicht“ heißt
in der Navigation jetzt „Fortschritt“ (Seite unverändert). Der Dashboard-Knopf „Eintragen“ entfällt (ersetzt
durch das Plus). Seitenindizes und Strg+1 … 5 unverändert. Tests angepasst (Avatar, Plus, „Fortschritt“),
alle 344 grün. Nächster Schritt: Startseite.

## 2026-11-22 – Redesign Schritt 1: Designsystem Design 2 (D-22)

Patrick hat Design 2 „Fitness & Performance“ gewählt. `lib/src/ui/design/tokens.dart` (`SattlyTokens` als
ThemeExtension: Farben hell/dunkel, Makro- und Statusfarben, `SattlySpace`, `SattlyRadius`, `SattlyFonts`,
`numberStyle`) und `theme.dart` (`sattlyTheme`, zwischengespeichert). `buildTheme` in `app.dart` delegiert,
`MacroColors` und `StatValue` nutzen die Tokens. Schrift Barlow + Barlow Condensed statt Inter.
Wichtig: Das Theme muss zwischengespeichert bleiben, sonst blendet MaterialApp bei jedem Neuaufbau über und
alle Seiten abonnieren ihre Streams neu (zeigte sich als langsame Widget-Tests). Tests:
`design_tokens_test.dart` (Kontraste WCAG AA, Tokens im Theme, Theme-Identität, Akzent), alle 344 Tests grün,
Testlauf dadurch rund doppelt so schnell. Nächster Schritt: Navigation mit zentralem Plus.

## 2026-11-22 – Redesign: Analyse und drei Designvorlagen (Phase 1+2, wartet auf Freigabe)

Thread „Sattly-Design mit drei Vorlagen erneuern“. `docs/design/REDESIGN.md` (Analyse, Vergleich, Empfehlung
Design 1 „Premium Wellness“) und `docs/design/vorschau.html` (interaktive Vorschau, nur Beispieldaten,
getrennt vom App-Code). Screenshots in den Projektdateien `sattly/redesign/`. **Kein produktiver Code
geändert.** Phase 4 (Designsystem als ThemeExtension, dann Bereiche einzeln) erst nach Patricks Freigabe.

## 2026-11-22 – Mehr Lebensmittel und Open Food Facts beim Tippen (3.6, 3.7)

Thread „Lebensmittel-Datenbank vergrößern mit Live-Suche“, Branch `claude/project-thread-nlurk1`. Kein Schema-Eingriff.

- 3.6: 470 weitere USDA-Lebensmittel in `tool/usda/auswahl.csv` (deutsche Namen, Kategorien inkl. neu
  „Gewürze & Kräuter“, „Fertiggerichte“), `seed_usda.dart` neu erzeugt (689 USDA + rund 100 eigene Richtwerte).
  `seedVersion` 3 und `microSeedVersion` 3 liefern sie beim Update nach. Ausgelassen: Schmalz/Talg (> 900 kcal),
  Fleisch ohne Zuckerwert, Einträge mit kcal-Abweichung (Spirulina, Haferkleie, Kakao, Backpulver).
- 3.7: `core/online_search.dart` (`shouldSearchOnline`, `withoutKnown`, `RecentCache`), `smartSearch()` in
  `data/food_search.dart` liefert die Zahl exakter Treffer, `knownFoods()` im Foods-DAO, Controller und Liste
  `features/foods/off_live_section.dart`, eingebaut in Hinzufügen-Suche und Zutatensuche, `openOffProduct()`
  aus der OFF-Suchseite wiederverwendet, Schalter in den Einstellungen (`offLiveSearchKey`, Standard an).

Tests: `flutter analyze` ohne Befund, Format sauber, neue Unit-Tests `test/online_search_test.dart`, Datenbanktest
„Update von Version 2“, Widget-Tests „Open Food Facts beim Tippen“ (Treffer, Tipp-Pause, Speichern, Eintragen)
und „ohne Internet“; bestehender OFF-Test prüft jetzt den abgeschalteten Zustand.

Offen: echte Abfrage gegen Open Food Facts konnte in der Cloud nicht laufen (Server dort gesperrt), Antwortformat
wie bei der bestehenden Textsuche. FTS5 erst, wenn die Datenbank deutlich wächst.

## 2026-11-22 – Impressum und Verantwortlicher (7.3)

Patrick hat Name, Anschrift und E-Mail geliefert: eingetragen in `docs/DATENSCHUTZERKLAERUNG.md` (Abschnitt 1) und
neues `docs/IMPRESSUM.md`. Offen bei 7.3: Store-Screenshots, rechtliche Prüfung vor Veröffentlichung.

## 2026-11-22 – Widget: Schnell-Eintrag „+ Essen“ (W13 fertig)

Phase-2-Thread. Knopf `widget_add` öffnet `sattly://add` (`isAddFoodWidgetLink`), `startHomeWidgetSync(onAddFood:)`
ruft in `home_shell.dart` `addNow` auf (wie Strg+E: Suche für die fällige Mahlzeit heute). Kein Schema, keine
Abhängigkeit. Tests: `home_widget_test.dart` (Link, Rückruf). Auf dem Gerät ungeprüft.

## 2026-11-22 – Basisdatenbank aus USDA erweitert (Aufgabe 3.6, Teil Daten)

Patrick hat den Download von `fdc.nal.usda.gov` freigegeben (Entscheidungskarte), Host in der Cloud-Umgebung
erlaubt. `tool/usda/auswahl.csv` (FDC-Nummer, deutscher Name, Kategorie, Mikros ja/nein) und
`tool/usda/generate.py` erzeugen `lib/src/data/seed_usda.dart` (219 Lebensmittel, Mikronährstoffe für die
meisten). Danach `dart format lib/src/data/seed_usda.dart`. `baseFoods` = Referenz + USDA; `seedVersion` 2
fügt nur fehlende ein und berücksichtigt jetzt auch Namen gelöschter Lebensmittel (kein Wiederauftauchen);
`microSeedVersion` 2 ergänzt Mikros über `baseMicros()`. Kein Schema, D-19, Rechenweg in BERECHNUNGEN.

Tests: Plausibilität aller Basis-Lebensmittel (jetzt inkl. USDA), keine Duplikate, USDA-Mikros plausibel,
Datenbanktest „Neue Basis-Lebensmittel kommen dazu, gelöschte nicht zurück“.

Offen: FTS5-Suche (Schema v7 war reserviert) zurückgestellt, bis die Datenbank deutlich wächst; alkoholische
Getränke brauchen ein Alkohol-Feld; weitere Lebensmittel einfach in `auswahl.csv` ergänzen und neu erzeugen.

## 2026-11-22 – Tagebuch als Tabelle am PC (Aufgabe 2.5 fertig)

Phase-2-Thread. `features/diary/diary_table.dart` (`DiaryColumn`, `DiaryTable`, Setting `diaryTableColumns`),
ab 900 px je Mahlzeitkarte statt der Liste; „Zahlen ausblenden“ lässt nur Menge/Marke. Spaltenwahl jetzt
generisch in `ui/table_columns.dart` (`parseColumns`, `encodeColumns`, `chooseColumns`), die Lebensmittel-Tabelle
nutzt sie mit. Datenschutzerklärung um Health Connect, Widget, App-Sperre und Berechtigungen ergänzt (7.3).
Tests: `test/diary_table_test.dart` (3), Widget-Test „PC: Tagebuch als Tabelle“.

## 2026-11-22 – Widget: Wasser +250 ml (W13, Teil 2)

Phase-2-Thread. `widgetSummary` bekommt Wasser (`waterText`), `waterFromWidgetLink` prüft den Link
`sattly://water?ml=…` (50–1000 ml). `HomeWidgetBridge.launches()` liefert Start- und Klick-Links des Widgets,
`startHomeWidgetSync` trägt das Wasser für heute ein. Android: Knopf und Wasserzeile im Layout, Launch-Intent-Filter
im Manifest, Widget zwei Zellen hoch. Kein Schema, keine neue Abhängigkeit.

Tests: `home_widget_test.dart` +1 und Klick-Test im Datentest. Auf dem Gerät ungeprüft.

## 2026-11-22 – Lebensmittel-Tabelle am PC (Aufgabe 2.5, Teil Lebensmittel)

`features/foods/food_table.dart` (`FoodColumn`, `FoodTable`, Spaltenwahl im Setting `foodTableColumns`), ab 900 px
in der Lebensmittelliste. Tests: `test/food_table_test.dart` (2), Widget-Test am PC. Offen: Tagebuch als Tabelle;
bei sehr vielen Lebensmitteln (Phase 4) DataTable durch eine virtualisierte Tabelle ersetzen.

## 2026-11-22 – Datenschutzerklärung und Store-Texte (Aufgabe 7.3, Entwurf)

`docs/DATENSCHUTZERKLAERUNG.md` und `docs/STORE-TEXTE.md` nach dem Stand des Codes. Offen: Verantwortlicher/
Impressum (Patrick), Health-Connect-Absatz sobald gemergt, Store-Screenshots.

## 2026-11-22 – Mikronährstoffziele im Profil (Aufgabe 4.2)

`features/profile/micro_targets_card.dart` nutzt `dachTargets` + `forPerson` (W5). Prüfung im Profil-Widget-Test.

## 2026-11-22 – App-Sperre (Aufgabe 7.2 ohne Verschlüsselung)

Phase-2-Thread, nach Patricks Entscheidung „Nur App-Sperre“. `core/app_lock.dart` (PIN-Regeln, PBKDF2, Wartezeiten,
Sperrzeitpunkt, `LockConfig`), `data/app_lock_store.dart` (Datei `applock.json`, `local_auth`), `features/lock/`
(Sperrbildschirm mit Ziffernblock und Tastatur, `LockGate` über dem Navigator in `app.dart`, Einstellungsseite).
Neue Abhängigkeiten `local_auth`, `crypto`; Android AppCompat-Theme beim Start (D-18). Windows: `_SILENCE_EXPERIMENTAL_COROUTINE_DEPRECATION_WARNINGS` für das local_auth-Plugin in `windows/CMakeLists.txt`, weil der neue MSVC dessen `<experimental/coroutine>` sonst ablehnt. Kein Schema.

Tests: `test/app_lock_test.dart` (5, u. a. RFC-Testvektor), Widget-Test „App-Sperre“. Fingerabdruck auf dem Gerät
ungeprüft.

## 2026-11-22 – Protein über den Tag (Aufgabe 4.3)

`core/protein_split.dart`, Anzeige „Protein x / y g“ je Mahlzeit im Tagebuch. Tests: `test/protein_split_test.dart`
(3) und Prüfung im Tagebuch-Widget-Test.

## 2026-11-22 – Gewichtsliste nachladen (Aufgabe 1.3)

`weight_page.dart`: Knopf „Ältere anzeigen (noch n)“ lädt jeweils 120 weitere. Widget-Test mit 131 Einträgen.

## 2026-11-22 – Open-Food-Facts-Textsuche (Aufgabe 3.4)

`OffClient.search()` (nur Suchbegriff, Produkte ohne Namen oder Energie fallen weg, nur gültige Barcodes),
`features/foods/off_search_page.dart`, Eintrag „Bei Open Food Facts suchen“ in der Auswahl beim Eintragen.
Entscheidung D-17. Tests: `test/off_search_test.dart` (3, Mock-Client), Widget-Test Suche → Formular → Eintrag.
Nächster Schritt: 6.1 Health Connect (mit Phase-2-Thread abstimmen), sonst 1.4/1.5.

## 2026-11-22 – Dashboard-Kacheln aufgeteilt (Aufgabe 1.5)

Rein strukturell. `features/dashboard/dashboard_page.dart` (897 Zeilen) behält `DashboardPage`, `DashData` und den
Rumpf. Die Kacheln liegen als `part`-Dateien in `features/dashboard/tiles/` (`nutrition_tiles.dart`: Kalorien, Makros,
Protein; `day_tiles.dart`: Wasser, Aktivität, Supplemente, Mahlzeiten, Hinweise; `weight_tiles.dart`: Gewicht, Ziel,
Gewichtskurve), der Anpassen-Dialog in `customize_sheet.dart`. Neue Kacheln in die passende Datei.

Tests: alle 301 unverändert grün, `flutter analyze` ohne Befund.

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
