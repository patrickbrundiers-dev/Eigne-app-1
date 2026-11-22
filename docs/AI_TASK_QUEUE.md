# Aufgaben-Warteschlange (gemeinsam für alle Entwicklungs-Threads)

Stand: 22.11.2026. Die eine gemeinsame, priorisierte Liste. [ROADMAP.md](ROADMAP.md) bleibt die Sicht für
Nutzer (Phasen), [ARBEITSPLAN-WETTBEWERB.md](ARBEITSPLAN-WETTBEWERB.md) die Begründung der W-Pakete.
Wer eine Aufgabe beginnt, trägt sich unter „Wer“ ein; wer sie abschließt, verschiebt sie nach
[AI_PROGRESS.md](AI_PROGRESS.md).

Bewertung: **Nutzen** (H/M/N), **Aufwand** S ≤ 1 Tag · M 2–4 Tage · L ≥ 1 Woche, **Risiko** (H/M/N),
**Schema** = braucht Drift-Migration (Version vorher beim Phase-2-Thread reservieren), **Test** = wie prüfbar.

## In Arbeit

| Aufgabe | Wer | Schema | PR |
|---|---|---|---|
| 2.3 Barrierefreiheit | Thread „Sattly auf Niveau führender Apps“ | nein | folgt |

## Priorität 1 – Fehler und technische Grundlagen

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 1.3 | Gewichtsliste: mehr als 120 Einträge nachladen statt still abschneiden | N | S | N | – | Widget-Test |
| 1.4 ✅ | `AppDatabase` je Bereich aufteilen (rein strukturell; als Extensions in `data/dao/*.dart`) | M (für Entwicklung) | M | M (Konflikte) | nach W5 | bestehende Tests unverändert grün |
| 1.5 | Dashboard-Kacheln in eigene Dateien | N | S | N | nach W5 (neue Kachel) | bestehende Tests |

## Priorität 2 – Kernfunktionen und Bedienbarkeit

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 2.1 | ✅ Dashboard „Heute“ entschlacken: eine Hauptzahl (übrig), Makro-Ringe, ein „+“ mit Eintragen/Scannen/Schnell/Vorlage | H | M | M | W5-Kachel | Widget-Test: Eintrag in ≤ 3 Taps |
| 2.2 | ✅ Gewichts-Fortschritt auch als Dashboard-Kachel (kompakt) | M | S | N | dieser PR, W5 (Enum-Ende) | Widget-Test |
| 2.3 | ✅ Barrierefreiheit: Semantics-Labels für Ringe/Diagramme, Schriftgröße 200 % ohne Überlauf | M | M | N | – | Widget-Test mit `textScaler` 2.0 |
| 2.4 | ✅ Tastenkürzel unter Windows (Eintragen, Bereiche, Tag/Woche vor/zurück, F1) – W8, siehe AI_PROGRESS | M | S | N | – | Widget-Test mit Tastenereignissen |
| 2.5 | Tabellen mit wählbaren Spalten am PC (Tagebuch, Lebensmittel) – Rest von W8 | N | M | N | – | Widget-Test |

## Priorität 3 – Lebensmittelerfassung und Datenqualität

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 3.1 | **Texteingabe ohne KI**: „200 g Hähnchen, 2 Eier, 1 Banane“ → lokaler Parser (Mengen, Einheiten, Stück-Gewichte, Synonyme) → Treffer aus eigener DB, unsichere markiert, Speichern erst nach Bestätigung | H | M | N | – | Unit-Tests Parser, Widget-Test Bestätigung |
| 3.2 | ✅ Portionen lernen: zuletzt genutzte Menge je Lebensmittel als Vorschlag auch in Suche/Mengendialog (in der Texteingabe schon umgesetzt) | H | S | N | – | Unit-Test |
| 3.3 | ✅ Tippfehlertolerante Suche (Umlaute, ß, Trigramme) und Sortierung nach eigener Nutzung | H | M | N | – | Unit-Tests |
| 3.4 | Open-Food-Facts-Textsuche (nicht nur Barcode), nur Suchbegriff senden, Ergebnis prüfen | M | M | N | – | Test mit Mock-Client |
| 3.5 | Rezept-Import aus Webseite (schema.org Recipe), Zutaten zuordnen – W9 (Phase-2-Thread) | M | M | M | 3.1: `parseLine()`/`matchMealText()` für Zutatenzeilen wiederverwenden | Unit-Tests mit HTML-Beispielen |
| 3.6 | Basisdatenbank erweitern (USDA FDC gemeinfrei, Lizenz prüfen), FTS5-Suche | M | L | M (Schema) | W5, Schema v7+ | Datenbanktests |

## Priorität 4 – Persönliche Ernährungsplanung

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 4.1 | ✅ Wochenplan berücksichtigt Unverträglichkeiten, Abneigungen und Vorlieben aus dem Profil (Essenszeiten: Snacks wie bisher) | H | M | N | – | Unit-Tests `meal_plan` |
| 4.2 | Mikronährstoffziele (D-A-CH) im Profil sichtbar | M | S | N | W5 | Unit-Tests |
| 4.3 | Proteinziel über den Tag verteilen (Hinweis je Mahlzeit) | M | S | N | – | Unit-Test |

## Priorität 5 – KI und Lernfunktionen

Grundsatz (siehe AI_DECISIONS D-07): erst lokal und regelbasiert, externe KI nur optional.

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 5.1 | ✅ Gewohnheiten erkennen: wiederkehrende Mahlzeiten → Vorlage vorschlagen | H | M | N | – | Unit-Tests mit synthetischem Tagebuch |
| 5.2 | ✅ Stagnations-Analyse: Plateau + Bilanz + Lücken + Wochenendmuster → erklärte Ursachen | H | M | N | dieser PR | Unit-Tests |
| 5.3 | Optionale Cloud-KI für Text/Foto (Anbieter wählbar, Schlüssel im sicheren Speicher, Datenvorschau vor dem Senden) | H | L | H (Kosten, Datenschutz → **Freigabe nötig**) | 3.1 | Tests mit Mock |
| 5.4 | ✅ Wochenbericht mit Begründung (nutzt Wochen-Check, Fortschritt, Mikros) | M | M | N | W5 | Unit-Tests |

## Priorität 6 – Integrationen

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 6.1 | ✅ Health Connect: Schritte, Training, Gewicht lesen; Mahlzeiten schreiben | H | L | M | – | Unit-Tests Zuordnung, manuell auf Gerät |
| 6.2 | Garmin Connect lesen und schreiben (Phase-2-Thread) | H | L | H (API-Zugang) | 6.1 | Mock-Tests |
| 6.3 | Sync über PostgreSQL EU + gemeinsamer Katalog (Phase-2-Thread) | H | L | H (**Freigabe** für Anbieter/Konto) | – | Konflikt-Tests |
| 6.4 | Homescreen-Widget Android (W13) | M | M | N | – | manuell |

## Priorität 7 – Veröffentlichung

| # | Aufgabe | Nutzen | Aufwand | Risiko | Abhängig | Test |
|---|---|---|---|---|---|---|
| 7.1 | Android-Signatur-Secrets (Patrick) → Online-Update aktivieren | H | S | N | Patrick | Release-Lauf |
| 7.2 | Datenbank-Verschlüsselung (SQLCipher) + App-Sperre | M | M | H (Migration bestehender Daten → **Freigabe**) | – | Migrationstest |
| 7.3 | Datenschutzerklärung, Impressum, Store-Texte, Screenshots | M | S | N | – | – |
| 7.4 | Integrationstests auf Android-Emulator in CI | M | M | N | – | CI |

## Nächster konkreter Schritt

Reihenfolge (Plan vom 22.11.2026, Thread „Sattly auf Niveau führender Apps“): **2.1 + 2.2** Heute-Seite mit
Gewichts-Kachel, dann **3.2** Portionen lernen, **5.1** Gewohnheiten, **5.2** Stagnations-Analyse, **2.3**
Barrierefreiheit, **3.4** OFF-Textsuche. Phase-2-Thread: 5.4, dann 6.1/6.2. Freigabe nötig: 5.3, 6.3, 7.2.
