# Berechnungen

Alle Formeln stehen in `apps/mydiet/lib/src/core/` (reines Dart, ohne Oberfläche) und sind in
`apps/mydiet/test/` mit Rechenbeispielen getestet. Die App zeigt unter Profil → „Rechenweg anzeigen“
jeden Schritt mit den eingesetzten Werten.

## Grundumsatz

- Standard: **Mifflin-St Jeor**: 10 × kg + 6,25 × cm − 5 × Alter + 5 (Männer) bzw. − 161 (Frauen)
- Mit Körperfettangabe: **Katch-McArdle**: 370 + 21,6 × Magermasse (kg)
- Gewicht: 7-Tage-Trendgewicht, nicht die letzte Einzelmessung.

## Gesamtumsatz

Gesamtumsatz = Grundumsatz × PAL. PAL = Alltagsaktivität + Sport.

| Alltag | PAL |
|---|---|
| Kaum Bewegung | 1,25 |
| Sitzend | 1,40 |
| Sitzend mit Bewegung | 1,55 |
| Überwiegend stehend/gehend | 1,75 |
| Körperlich schwer | 2,00 |

Sport: + 0,09 je Stunde pro Woche (DGE: 4–5 × 30–60 min ≈ + 0,3), höchstens + 0,6.
Die Werte liegen am unteren Rand der DGE-Spannen, weil Formeln den Bedarf bei höherem Gewicht eher
überschätzen.

## Kalorienziel

- Bilanz pro Tag = (aktuelles Gewicht − Zielgewicht) × 7.700 kcal ÷ Tage bis zum Zieldatum
- Ohne Zieldatum: 0,5 % des Körpergewichts pro Woche (Zunahme: 0,25 %)
- Grenzen: höchstens 1 % Abnahme bzw. 0,5 % Zunahme pro Woche; nie unter 1.500 kcal (Männer) bzw.
  1.200 kcal (Frauen). Jede Begrenzung erscheint als Hinweis.
- Ein eigenes Kalorienziel ersetzt das berechnete; das berechnete bleibt sichtbar.

## Makronährstoffe

- Protein: 1,8 g × Zielgewicht beim Abnehmen, sonst × aktuelles Gewicht (Faktor 0,8–3,0 einstellbar,
  oder festes eigenes Ziel)
- Fett: 30 % der Kalorien ÷ 9 (15–60 % einstellbar)
- Kohlenhydrate: Rest ÷ 4
- Ballaststoffe: 30 g (DGE), einstellbar
- Wasser: 30 ml × kg, 1,5–3,5 l, einstellbar

### Makro-Vorlagen

| Vorlage | Protein g/kg | Fett % | Kohlenhydrate |
|---|---|---|---|
| Ausgewogen | 1,6 | 30 | Rest |
| High Protein | 2,0 | 30 | Rest |
| Low Carb | 1,8 | 40 | höchstens 100 g |
| Ketogen | 1,6 | 70 | höchstens 30 g |
| Ausdauersport | 1,6 | 25 | Rest |

Mit Kohlenhydrat-Grenze: Liegt der Rest über der Grenze, gilt die Grenze und die übrige Energie geht in
Fett: (Kalorienziel − Protein × 4 − KH × 4) ÷ 9. Die Energie bleibt gleich (getestet).

## Lebensmittel und Tagebuch

- Nährwert eines Eintrags = Wert pro 100 g/ml × Menge ÷ 100. Gerundet wird nur in der Anzeige.
- Plausibilitätsprüfung pro 100 g: keine negativen Werte, ≤ 900 kcal, Eiweiß + Kohlenhydrate + Fett +
  Ballaststoffe + Salz ≤ 100 g, Zucker ≤ Kohlenhydrate, gesättigt ≤ Fett (Fehler); Abweichung der kcal von
  4 × E + 4 × KH + 9 × F + 2 × Ballaststoffe um mehr als 15 % + 20 kcal (Warnung).

### Basis-Lebensmittel aus USDA FoodData Central (`data/seed_usda.dart`, erzeugt von `tool/usda/generate.py`)

- Quelle: SR Legacy (April 2018), gemeinfrei (CC0). Auswahl und deutsche Namen: `tool/usda/auswahl.csv`
  (FDC-Nummer je Eintrag, im erzeugten Code als Kommentar mit der englischen Bezeichnung).
- Übernommen je 100 g: Energie (kcal), Eiweiß, Fett, gesättigte Fettsäuren, Zucker, Ballaststoffe.
- Kohlenhydrate (EU) = „Carbohydrate, by difference“ − Ballaststoffe; liegt das unter dem gemessenen Zucker
  (Rundung der Differenzmethode), gilt Kohlenhydrate = Zucker.
- Salz = Natrium (mg) × 2,5 ÷ 1000. Omega-3 = EPA + DHA (g × 1000 = mg).
- Vitamine/Mineralstoffe: Vitamin D, B12, Folat (gesamt), C, Calcium, Magnesium, Eisen, Zink, Kalium.
  Bei in den USA üblicherweise angereicherten Produkten (Brot, Mehlprodukte, Pflanzendrinks) werden keine
  Mikronährstoffe übernommen; bei Milch und Mehl die nicht angereicherten Varianten.
- Nicht übernommen: Einträge ohne einen der Hauptwerte (das Skript meldet sie), alkoholische Getränke (die
  App kennt keinen Alkohol-Wert, Energie wäre nicht erklärbar) und Einträge, die die Plausibilitätsprüfung
  oben nicht bestehen (z. B. Kakaopulver, Haferkleie: USDA rechnet mit stoffspezifischen Atwater-Faktoren).
- Werte gelten für US-Produkte; Abweichungen zu deutschen Produkten sind möglich (Anzeige „Richtwert“).

## Rezepte

- Gesamtwerte = Summe aller Zutaten (Wert pro 100 × Menge ÷ 100)
- Pro Portion = Gesamt ÷ Portionen
- Gewicht des Gerichts = gewogenes Endgewicht nach dem Kochen, sonst Summe der Zutatenmengen (ml wie g)
- Pro 100 g = Gesamt × 100 ÷ Gewicht des Gerichts. Kochen verändert das Gewicht (Wasser), nicht die Nährwerte.
- Ins Tagebuch wird eine Menge in Gramm eingetragen; 1 Portion = Gewicht ÷ Portionen. So ergeben
  „1 Portion“ und „Gramm einer Portion“ genau dieselben Werte (getestet).
- Einkaufsliste: Menge × gewünschte Portionen ÷ Rezeptportionen; gleiche Zutat mit gleicher Einheit wird addiert.
- Import (`core/recipe_import.dart`): von einer Webseite werden aus den schema.org-Daten nur Name, Portionen
  (erste Zahl aus `recipeYield`), Zutatenzeilen, Zubereitung, Zeit (ISO-Dauer, sonst Vorbereitung + Kochen)
  und Stichworte übernommen; Nährwertangaben der Seite werden ignoriert. Jede Zutatenzeile wird ohne
  Zubereitungshinweis („, fein gewürfelt“, Klammern) wie bei „Als Text eintragen“ gelesen und der eigenen
  Datenbank zugeordnet (EL 15 ml, TL 5 ml, Stück über die Portionsgröße, jeweils als Annahme markiert).
  „Salz“, „Pfeffer“, „etwas …“ und Zwischenüberschriften zählen ohne Nährwerte. Gespeichert werden nur
  angehakte, zugeordnete Zutaten; die Werte rechnet die App wie oben aus.

## Supplemente

Die App empfiehlt keine Dosierungen. Sie addiert, was eingetragen ist, und vergleicht mit Referenzwerten:

- Summe je Inhaltsstoff über alle aktiven Produkte: Menge pro Portion × Portionen; Einheiten µg/mg/g werden
  umgerechnet, Vitamin D in IE ÷ 40 = µg. „Geplant“ = Portionen pro Tag, „heute“ = abgehakte Einnahmen.
- NRV (Referenzmenge, VO (EU) 1169/2011 Anhang XIII) als Prozentangabe pro Inhaltsstoff.
- UL (tolerierbare Höchstmenge für Erwachsene, EFSA): Hinweis ab 80 %, Warnung über 100 %.
  Werte: Vitamin A 3.000 µg, D 100 µg, E 300 mg, B6 12 mg, Folsäure 1.000 µg*, Niacin (Nicotinamid) 900 mg*,
  Calcium 2.500 mg, Magnesium 250 mg*, Zink 25 mg, Kupfer 5 mg, Selen 255 µg, Jod 600 µg, Molybdän 600 µg;
  Eisen 40 mg (EFSA-Sicherheitswert 2024); Omega-3 (EPA+DHA) 5 g und Koffein 400 mg (EFSA-Einschätzungen).
  \* gilt nur für Nahrungsergänzung/zugesetzte Formen.
- Die Supplement-Ansicht zeigt nur Supplemente. Essen und Supplemente zusammen zeigt die Übersicht
  „Vitamine und Mineralstoffe“ (siehe unten).

## Vitamine und Mineralstoffe (Essen + Supplemente)

- Je Tagebucheintrag: Menge × Wert pro 100 ÷ 100; Rezepte: Summe der Zutaten ÷ Gewicht des fertigen Gerichts.
  Supplemente zählen mit den abgehakten Portionen. Einträge ohne Werte zählen nicht mit; die App zeigt, für
  wie viele Einträge Werte vorhanden sind.
- Ziel: D-A-CH-Referenzwerte für Erwachsene (DGE, gerundet; Mann/Frau): Vitamin D 20 µg, B12 4 µg, Folat
  300 µg, Vitamin C 110/95 mg, Calcium 1.000 mg, Magnesium 350/300 mg, Eisen 11/16 mg (Frauen ab 51: 14 mg),
  Zink 14/8 mg (mittlere Phytatzufuhr), Jod 200 µg, Kalium 4.000 mg.
- Ampel: unter dem Ziel / Ziel erreicht / nahe (ab 80 %) oder über der Höchstmenge. Für Magnesium, Folsäure
  und Niacin gilt die Höchstmenge nur für Supplemente; es zählt dann nur deren Anteil.
- Beim Anlegen eines Supplements zeigt die App, welche anderen aktiven Produkte denselben Stoff enthalten und
  wie viel es zusammen pro Tag sind („enthält ebenfalls Zink, zusammen 38 mg“).
- Richtwerte der Basis-Lebensmittel: gerundete Mittelwerte aus BLS und USDA FoodData Central für nicht
  angereicherte Produkte. Werte vom Etikett oder von Open Food Facts lassen sich je Lebensmittel eintragen.

## Wochenplan

- Anteil je Mahlzeit: Snacks je 10 % (zusammen höchstens 40 %), die übrigen Mahlzeiten teilen sich den Rest.
- Automatisch füllen: für jede leere Mahlzeit das nächste passende Rezept (rotierend, am selben Tag kein
  Rezept doppelt); Menge = Kalorienziel × Anteil ÷ kcal pro 100 g × 100, begrenzt auf 0,5–2,5 Portionen,
  auf 10 g gerundet.
- Profil (`core/meal_plan.dart`: `excludedBy`, `preferenceScore`): Rezepte, deren Name oder eine Zutat einen
  Eintrag aus „Unverträglichkeiten & Allergien“ oder „Abgelehnte Lebensmittel“ enthält, werden nicht
  verwendet. Vergleich ohne Groß-/Kleinschreibung, Umlaute und ß vereinheitlicht; Begriffe ab 4 Buchstaben
  auch in zusammengesetzten Wörtern („Vollmilch“), kürzere nur als ganzes Wort („Ei“, nicht „Weizen“).
  Häufige Einträge stehen für Gruppen (Laktose → Milch, Joghurt, Käse, Quark, Sahne, Butter …; Gluten →
  Weizen, Dinkel, Roggen, Gerste, Hafer, Nudeln, Brot, Mehl …; Nüsse, Erdnüsse, Ei, Fisch, Meeresfrüchte,
  Soja, Sesam, Sellerie, Senf; Liste `avoidSynonyms`). Im Zweifel wird ausgelassen. Ausgelassene Rezepte
  stehen mit Grund in der Meldung. Rezepte mit bevorzugten Lebensmitteln kommen in der Reihenfolge zuerst und
  damit öfter vor. Das ist eine Planungshilfe, keine Allergen-Garantie: Zutaten fertiger Produkte prüft die
  App nicht.
- Übernehmen ins Tagebuch kopiert die geplanten Werte; ein schon übernommener Eintrag wird nicht noch einmal
  eingetragen (erst wieder, wenn er im Tagebuch gelöscht wurde).

## Intervallfasten

Dauer = jetzt − Beginn; verbleibend = Ziel − Dauer; Durchschnitt über abgeschlossene Fastenzeiten.

## Aktivität

- Tagesbudget = Kalorienziel + Aktivitätskalorien × Anrechnung (0/25/50/100 %, Standard 0 %).
- Standard 0 %, weil der geplante Sport schon im PAL steckt; sonst würde er doppelt gezählt.
- Dieselbe Aktivität aus derselben Quelle (Quelle + externe ID) zählt nur einmal.

## Gewicht

- Trend: Durchschnitt der Messungen der letzten 7 Tage.
- Tempo: Ausgleichsgerade (kleinste Quadrate) über bis zu 28 Tage; mindestens 4 Messungen über 10 Tage.
- Prognose: verbleibende kg ÷ Tempo, nur wenn der Trend in Zielrichtung zeigt.
- Plateau: Ziel noch > 1 kg entfernt und Ausgleichsgerade über 21 Tage (≥ 6 Messungen, ≥ 14 Tage)
  zeigt weniger als 0,1 kg pro Woche.
- BMI = kg ÷ m² mit WHO-Kategorien.

## Gewichts-Dashboard „Fortschritt“ (`core/weight_progress.dart`)

- Aktuell = 7-Tage-Mittel (sonst letzte Messung, sonst Startgewicht aus dem Profil).
- Bisher = aktuell − Startgewicht; noch bis Ziel = Abstand zum Zielgewicht in Zielrichtung, nie negativ.
- Vorwoche = 7-Tage-Mittel der Tage 8–14 vor der letzten Messung.
- 30-Tage-Trend: Ausgleichsgerade über alle Messungen der letzten 30 Tage (mind. 4 über 10 Tage);
  Veränderung = Steigung × abgedeckte Tage (nicht letzter minus erster Wert);
  Streuung = Standardabweichung der Messungen um die Gerade.
- Aussagekraft: < 4 Messungen oder < 10 Tage → keine Anzeige; < 8 oder < 14 Tage gering;
  < 14 oder < 21 Tage mittel; sonst gut. Die Prognose (Gerade über 28 Tage) wird nur mit mindestens
  „gering“ gezeigt.
- Ernährung: die 7 Tage vor heute (heute zählt nie), nur Tage ≥ 800 kcal. Bilanz = Ø Aufnahme −
  geschätzter Verbrauch (Grundumsatz × PAL); erwartete Veränderung = Bilanz × 7 ÷ 7.700 kcal/kg.
  Proteinziel gilt ab 90 % als erreicht.
- Vergleich Bilanz ↔ Waage nur ab 4 gezählten Tagen und vorhandenem Trend; Abweichung < 0,3 kg/Woche
  gilt als passend. Bei größerer Abweichung nennt die App mögliche Ursachen, keine Diagnose.

## Als Text eintragen (`core/meal_text.dart`, keine KI)

- Zerlegen an Komma, Semikolon, Zeilenumbruch, „+“, „und“, „sowie“. Zahlen mit Komma oder Punkt, Brüche
  (1/2, ½), Zahlwörter (ein … zehn, halbe, paar). Einheit darf am Wert kleben („200g“).
- Umrechnung in die Einheit des Lebensmittels: kg × 1000, l × 1000, cl × 10; 1 EL = 15, 1 TL = 5 (immer als
  Annahme markiert); g ↔ ml 1:1 nur als Annahme.
- Stück/Scheibe/Becher …: Anzahl × hinterlegte Portion; passt das Wort nicht zur Portionsbezeichnung, ist es
  eine Annahme. Ohne hinterlegte Portion bleibt die Menge offen (nie geraten).
- Zahl ohne Einheit: ≤ 10 = Stück (Portion), > 10 = g bzw. ml. Ohne Zahl: 1 Portion bzw. die zuletzt
  eingetragene Menge dieses Lebensmittels, jeweils als Annahme.
- Suche nur in der eigenen Datenbank: Synonym (z. B. „Eier“ → Hühnerei), ganzer Text, Einzahl, längstes Wort.
  Treffer gilt als sicher, wenn der Name mit dem Suchbegriff beginnt und kein Ausweichbegriff nötig war.
- Vorausgewählt sind nur Zeilen ohne jede Annahme; alles andere braucht ein Häkchen. Nicht gefundene
  Lebensmittel bekommen keine Werte.

## Wochenbericht (`core/weekly_report.dart`)

- Woche = Montag bis Sonntag; Standard ist die letzte abgeschlossene Woche, sonntags die laufende.
- Es zählen nur Tage ab 800 kcal (sonst „nicht vollständig eingetragen“). Unter 4 Tagen wird darauf hingewiesen,
  dass die Durchschnitte unsicher sind.
- Kalorien: Ø gegen das Ziel; „im Zielbereich“ bei ±10 %; Tage im Bereich ±10 % gezählt; Vergleich zur Vorwoche.
  Unter 80 % des Ziels zusätzlich der Hinweis, nicht zu knapp zu essen (keine Empfehlung unter das Ziel).
- Wochenende: Ø Sa/So minus Ø Mo–Fr; ab 300 kcal ein Hinweis mit Vorschlag zum Einplanen.
- Protein: „meistens erreicht“, wenn an ≥ 70 % der Tage ≥ 90 % des Ziels; sonst Vorschlag mit Eiweißquellen, die
  Ernährungsweise, Unverträglichkeiten und Abneigungen beachten (`proteinIdeas`).
- Ballaststoffe: Hinweis unter 70 % des Ziels.
- Vitamine/Mineralstoffe: Ø Prozent des D-A-CH-Ziels über die Tage mit Werten (mind. 2 Tage); unter 70 % werden
  die drei niedrigsten genannt, ohne Diagnose.
- Gewicht: 7-Tage-Mittel am Sonntag gegen das 7-Tage-Mittel eine Woche davor.
- Höchstens drei Vorschläge; ohne Auffälligkeiten „So weitermachen“ mit Verweis auf das adaptive Ziel.

## Stillstand erklären (`core/stall.dart`)

Stillstand, wenn der Trend der letzten 21 Tage (Ausgleichsgerade, mindestens geringe Aussagekraft) weniger als
0,1 kg/Woche in Zielrichtung zeigt; nicht beim Ziel „halten“ (Ziel ±0,5 kg um den Start). Mögliche Ursachen:
- Lücken: weniger als 70 % der 21 Tage mit ≥ 800 kcal.
- Über dem Ziel: Ø eingetragener Tage mehr als 5 % über dem Kalorienziel (beim Zunehmen: darunter).
- Wochenende: Ø Sa/So mindestens 300 kcal über Ø Mo–Fr (nur beim Abnehmen).
- Bilanz passt nicht: bei vollständigem Tagebuch Ø mindestens 250 kcal/Tag unter dem geschätzten Verbrauch,
  erwartet Bilanz × 7 ÷ 7700 kg/Woche, die Waage zeigt das aber nicht. Verweis auf den Wochen-Check.
- Wenige Messungen: Aussagekraft des Trends nur gering.
Immer dazu der Hinweis auf Wasserschwankungen. Ziel wird hier nie geändert.

## Gewohnheiten (`core/habits.dart`)

Mahlzeit = alle Lebensmittel/Rezepte eines Tages in einer Mahlzeit (Schnell-Einträge zählen nicht). Kandidat ist
jede Mahlzeit der letzten 28 Tage mit mindestens 2 Bestandteilen. Vorschlag, wenn mindestens 3 Mahlzeiten derselben
Mahlzeit-Art alle Bestandteile enthalten (Extras erlaubt). Eine Teilmenge entfällt, wenn eine größere Kombination
gleich oft vorkommt. Schon gespeicherte Vorlagen und abgelehnte Vorschläge entfallen. Höchstens 3, häufigste zuerst.
Die Vorlage wird erst nach Bestätigung vom letzten Tag mit genau dieser Mahlzeit kopiert (Mengen von dort).

## Health Connect (`core/health_import.dart`)

- Gelesen werden Schritte (Tagessumme von Health Connect, ohne Doppelzählung mehrerer Quellen), aktive
  Kalorien, Trainings und Gewicht. Garmin Connect, Samsung Health, Google Fit u. a. schreiben dorthin.
- Jedes Training wird ein Aktivitätseintrag „<Art> (Health Connect)“ mit Dauer (Ende − Beginn, höchstens 24 h)
  und den Kalorien des Trainings (0, wenn die Quelle keine liefert).
- Pro Tag ein Eintrag „Alltag (Health Connect)“: Schritte und aktive Kalorien minus Trainingskalorien des Tages
  (nicht unter 0), damit nichts doppelt zählt. Ein Wert, der über Mitternacht reicht, zählt für den Starttag.
- Gewicht: der letzte Wert des Tages, nur 25–400 kg, auf 0,1 kg gerundet, und nur für Tage ohne eigenen Eintrag.
- Erneutes Übernehmen aktualisiert Einträge über ihre Kennung (`hc:<id>`, `hc-day:<Tag>`); selbst gelöschte
  Einträge kommen nicht wieder. Wie stark Aktivität das Tagesbudget erhöht, regelt weiterhin das Profil.
- Automatisch beim Öffnen nur wenn eingeschaltet, höchstens alle 3 Stunden, die letzten 7 Tage (beim ersten
  Verbinden 30 Tage).
- Schreiben (`core/health_export.dart`, eigener Schalter und eigene Freigabe): je Tag und Mahlzeit eine
  Ernährungs-Aufzeichnung mit der Summe der Einträge (kcal, Eiweiß, Kohlenhydrate, Zucker, Fett, gesättigte
  Fettsäuren, Ballaststoffe, Natrium = Salz ÷ 2,5). Mahlzeiten unter 1 kcal entfallen. Zeit = eingestellte Uhrzeit
  der Mahlzeit, sonst typisch (Frühstück 8:00, Mittag 12:30, Abend 18:30, Snack 15:30), Dauer 30 Minuten. Die Art
  (Frühstück/Mittag/Abend/Snack) folgt dem Namen, sonst der Uhrzeit. Bei jedem Abgleich werden die letzten 7 Tage
  neu geschrieben: zuerst wird gelöscht, was Sattly für den Tag geschrieben hat (Health Connect erlaubt nur das
  Löschen eigener Daten), dann neu geschrieben. So kommen Änderungen und Löschungen an, nichts doppelt.

## Protein je Mahlzeit (`core/protein_split.dart`)

Tagesziel ÷ Summe der Gewichte; Mahlzeiten mit Uhrzeit zählen 1, ohne Uhrzeit (Snacks) 0,5. Beispiel 150 g bei
Frühstück, Mittag, Abend, Snacks: 150 ÷ 3,5 = 43 g je Hauptmahlzeit, 21 g für Snacks. Nur Orientierung.

## Übliche Portion (`core/portion_memory.dart`)

Von den letzten 10 Einträgen eines Lebensmittels (auf ganze g/ml gerundet) die häufigste Menge, bei Gleichstand
die neuere; ein Eintrag genügt. Nur ein Vorschlag im Mengendialog und im Text-Eintrag, nie ohne Bestätigung.

## Tippfehlertolerante Suche (`core/fuzzy_search.dart`, `data/food_search.dart`)

1. Suchtext und Namen werden normalisiert (Kleinschrift, ä→ae, ö→oe, ü→ue, ß→ss, Satzzeichen weg).
2. Zuerst die exakte Suche: jedes Suchwort muss im Namen vorkommen.
3. Findet sie weniger als 5 Lebensmittel, werden alle Lebensmittel per Editierdistanz verglichen
   (Levenshtein mit Vertauschung zweier Nachbarbuchstaben = 1 Fehler). Erlaubt: 0 Fehler bis 3 Buchstaben,
   1 Fehler bis 6, sonst 2. Jedes Suchwort muss zu einem Wort des Namens passen.
4. Passung je Wort: exakt 1,0 · Wortanfang 0,9 · im Wort (ab 4 Buchstaben) 0,75 · ganzes Wort mit n Fehlern
   0,8 − 0,15·n · Wortanfang mit n Fehlern 0,7 − 0,15·n. Name = Mittel über die Suchwörter, +0,05 wenn das
   erste Suchwort zum ersten Namenswort passt. Unscharfe Treffer brauchen mindestens 0,5.
5. Sortierung: Passung; liegen zwei Treffer weniger als 0,05 auseinander, entscheidet, wie oft das
   Lebensmittel in den letzten 180 Tagen eingetragen wurde, dann Favorit, dann kürzerer Name.

Aussagekraft: reine Sortierhilfe, keine Nährwertberechnung. In „Als Text eintragen“ sind unscharfe Treffer immer
„unsicher“ und werden nicht vorausgewählt.

## Homescreen-Widget (`core/widget_summary.dart`, Android)

- Gleiche Rechnung wie das Dashboard: Budget = Tagesziel (im Wochenmodus das heutige Wochenbudget) plus
  Aktivitätsanteil aus dem Profil; „Noch X kcal“ = Budget − Gegessenes, sonst „X kcal über dem Ziel“.
- Zweite Zeile: gegessen / Budget und Protein gegessen / Ziel; Balken = Anteil des Budgets (0–100 %).
- „Zahlen ausblenden“ gilt auch hier: dann nur der freundliche Status wie im Tagebuch.
- Die App aktualisiert das Widget bei jeder Änderung, solange sie läuft. Ist der gespeicherte Tag nicht heute
  (z. B. nach Mitternacht), zeigt das Widget „Heute noch nichts eingetragen“ statt alter Zahlen.
- Wasser: Zeile „Wasser X“ (unter 1 l in ml, sonst in l mit bis zu zwei Nachkommastellen) und Knopf „+ 250 ml“.
  Der Knopf öffnet die App mit `sattly://water?ml=250`; nur 50–1000 ml werden angenommen und für heute eingetragen.

## App-Sperre (`core/app_lock.dart`)

- PIN 4–8 Ziffern; abgelehnt werden gleiche Ziffern (0000) und einfache Folgen (1234, 9876).
- Gespeichert wird nur ein Prüfwert: PBKDF2-HMAC-SHA256, 20.000 Runden, 16 Byte Zufalls-Salz, Vergleich in
  konstanter Zeit. Die Datei `applock.json` liegt im privaten App-Ordner, nicht in der Datenbank, also nicht in
  Sicherungen oder Exporten.
- Fehlversuche: die ersten 4 ohne Wartezeit, ab dem 5. 30 s, danach jeweils doppelt so lang, höchstens 15 min.
  Während der Wartezeit zählt auch die richtige PIN nicht. Ein Erfolg setzt den Zähler zurück.
- Sperren beim Start und nach der Rückkehr, wenn die App mindestens die gewählte Zeit (sofort, 1, 5 oder
  30 Minuten) im Hintergrund war.

## Tageshinweise (regelbasiert, keine KI)

- Proteinlücke > 15 g ab 12 Uhr, mit Vorschlägen passend zu Ernährungsweise, Unverträglichkeiten
  und Abneigungen
- mehr als 100 kcal über dem Budget; abends mehr als 600 kcal offen
- Ballaststoffe ab 17 Uhr unter der Hälfte des Ziels
- Wasser ab 14 Uhr deutlich unter dem zeitanteiligen Ziel
