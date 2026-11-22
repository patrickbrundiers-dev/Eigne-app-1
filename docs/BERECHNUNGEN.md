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

## Lebensmittel und Tagebuch

- Nährwert eines Eintrags = Wert pro 100 g/ml × Menge ÷ 100. Gerundet wird nur in der Anzeige.
- Plausibilitätsprüfung pro 100 g: keine negativen Werte, ≤ 900 kcal, Eiweiß + Kohlenhydrate + Fett +
  Ballaststoffe + Salz ≤ 100 g, Zucker ≤ Kohlenhydrate, gesättigt ≤ Fett (Fehler); Abweichung der kcal von
  4 × E + 4 × KH + 9 × F + 2 × Ballaststoffe um mehr als 15 % + 20 kcal (Warnung).

## Rezepte

- Gesamtwerte = Summe aller Zutaten (Wert pro 100 × Menge ÷ 100)
- Pro Portion = Gesamt ÷ Portionen
- Gewicht des Gerichts = gewogenes Endgewicht nach dem Kochen, sonst Summe der Zutatenmengen (ml wie g)
- Pro 100 g = Gesamt × 100 ÷ Gewicht des Gerichts. Kochen verändert das Gewicht (Wasser), nicht die Nährwerte.
- Ins Tagebuch wird eine Menge in Gramm eingetragen; 1 Portion = Gewicht ÷ Portionen. So ergeben
  „1 Portion“ und „Gramm einer Portion“ genau dieselben Werte (getestet).
- Einkaufsliste: Menge × gewünschte Portionen ÷ Rezeptportionen; gleiche Zutat mit gleicher Einheit wird addiert.

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
- Lebensmittel sind nicht enthalten, weil die Lebensmitteldatenbank keine Mikronährstoffe führt; die App
  weist darauf hin.

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

## Tageshinweise (regelbasiert, keine KI)

- Proteinlücke > 15 g ab 12 Uhr, mit Vorschlägen passend zu Ernährungsweise, Unverträglichkeiten
  und Abneigungen
- mehr als 100 kcal über dem Budget; abends mehr als 600 kcal offen
- Ballaststoffe ab 17 Uhr unter der Hälfte des Ziels
- Wasser ab 14 Uhr deutlich unter dem zeitanteiligen Ziel
