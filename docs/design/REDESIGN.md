# Sattly-Redesign: Analyse, drei Designvorlagen, Empfehlung

Stand: 22.11.2026 (App 0.6.0, Commit `ce40e86`). Auftrag: Patricks Master-Prompt „Großes UI/UX-Redesign mit
3 Designvorlagen und Freigabeverfahren“. Dieses Dokument deckt **Phase 1 (Designkonzepte)** und **Phase 2
(interaktive Vorschau)** ab. **Phase 3 (Freigabe durch Patrick) steht aus. Bis dahin wird am Produktivcode
unter `apps/mydiet/lib` nichts geändert.**

- Interaktive Vorschau: [`vorschau.html`](vorschau.html) (eine Datei, im Browser öffnen, ohne Installation).
  Design, Bereich, Handy/PC/alle drei nebeneinander und Hell/Dunkel sind umschaltbar; Navigation, Plus-Menü
  und Zeitraum im Gewichtsdiagramm sind bedienbar. Nur Beispieldaten, kein Zugriff auf die App-Datenbank.
- Screenshots: Projektdateien `sattly/redesign/` (Vergleichsbilder je Bereich plus Einzelbilder je Design).

## 1. Analyse des Bestands

### Aufbau der Oberfläche

| Punkt | Befund |
|---|---|
| Technik | Flutter, Material 3, `ThemeData` aus einem Farbsamen (`buildTheme` in `lib/src/app.dart`), Schrift Inter, 6 wählbare Farbschemata, Hell/Dunkel/System |
| Navigation | `HomeShell`: 5 Ziele (Heute, Tagebuch, Gewicht, Essen, Profil). Unten auf dem Handy, Seitenleiste ab 840 px. Unterseiten per `Navigator.push`, kein Routing-Paket |
| Umfang | 25 Seiten (`…Page`), 35 Seitenwechsel per Route, 15 Dialoge, 11 Bottom-Sheets |
| Eigene Bausteine | `lib/src/ui/widgets.dart` (`SectionCard`, `StatValue`, Makrofarben), `format.dart`, `table_columns.dart` (PC-Tabellen) |
| Startseite | 14 Kacheln (`core/dashboard_layout.dart`), sortier- und ausblendbar, 9 standardmäßig sichtbar |
| „Essen“ | ein Tab mit 5 Unter-Tabs: Lebensmittel, Rezepte, Wochenplan, Einkauf, Supplemente |
| Profil | Profil und Ziele, Makros, Mikronährstoffziele, Einstellungen (Erinnerungen, App-Sperre, Health Connect, Sicherung, CSV, Fehlerprotokoll, Alle Daten löschen, Darstellung) |
| Responsive | Seitenleiste ab 840 px, `PageBody(maxWidth)` begrenzt die Breite, Tabellen mit wählbaren Spalten am PC, Wochenplan nutzt volle Breite |
| Barrierefreiheit | Semantics-Labels für Ringe/Diagramme, Test mit 200 % Schrift, Tastenkürzel unter Windows |
| Datenfluss | Seiten lesen reaktive Drift-Streams (`watch…`) per `StreamBuilder`; Rechenlogik in `lib/src/core/` ohne Flutter |

### Designprobleme (was ein Redesign lösen soll)

1. **Startseite überladen.** Viele gleich gewichtete Karten mit gleichem Rahmen und Radius. Die wichtigste Zahl
   („kcal übrig“) konkurriert mit Gewicht, BMI, Zielfortschritt, Wasser und Aktivität. Lange Scrollstrecke.
2. **Kein zentraler Eintragen-Knopf.** Eintragen geht über das Plus je Mahlzeit im Tagebuch oder Strg+E. Die
   häufigste Handlung der App braucht vom Start aus zwei bis drei Taps.
3. **Funktionen versteckt.** Wochenplan, Einkauf und Supplemente liegen im 4. und 5. Unter-Tab von „Essen“.
4. **Tagebuch textlastig.** Zeilen wie „250 g · P 28 g · K 10 g · F 0,5 g“ ohne Bild, alle Mahlzeiten gleich laut.
5. **Wenig Eigenständigkeit.** Das Aussehen entsteht aus `ColorScheme.fromSeed`. Es wirkt sauber, aber wie viele
   Material-Apps; Logo und Name „Sattly“ (Teller-Ring, Blatt) finden sich im Design kaum wieder.
6. **Kein Designsystem.** Makrofarben stehen fest in `widgets.dart`, Abstände und Schriftgrößen direkt in den
   Seiten (25 feste `fontSize`-Angaben). Ein neues Design müsste heute Seite für Seite angefasst werden.
7. **Begriffe uneinheitlich.** Navigation „Gewicht“, Kachel „Zielfortschritt“, Karte „Fortschritt“; Tab „Essen“
   neben Seite „Lebensmittel“.

### Technische Schwachstellen mit Bezug zum Design

- Keine Design-Tokens (Farben, Abstände, Radien, Schatten) an einer Stelle; Erweiterung um Varianten aufwendig.
- Viele `StreamBuilder` je Kachel: bei der Umsetzung Kacheln mit eigenem Stream beibehalten, nicht bündeln
  (sonst baut die ganze Startseite bei jeder Änderung neu).
- Keine Golden-Tests: Darstellungsfehler fallen nur über Widget-Tests oder von Hand auf.

## 2. Die drei Designvorlagen

| | 1 · Premium Wellness | 2 · Fitness & Performance | 3 · Klar & minimalistisch |
|---|---|---|---|
| Idee | warm, natürlich, motivierend | Kennzahlen-Cockpit, sportlich | eine Hauptzahl, viel Weißraum |
| Hintergrund | Creme `#F5F0E6`, dunkel `#141A16` | Hellgrau `#F1F3F5`, dunkel `#0C0F12` | Weiß, dunkel Schwarz |
| Hauptfarbe | Salbeigrün `#2F7A55` (dunkel `#8CCB9F`) | Grün `#1E9E57`, dunkel Limette `#C6F05A` (Logo-Akzent) | Logo-Grün `#1F6B4A` (dunkel `#6FCF97`) |
| Makrofarben | Grün / Aprikose / Terrakotta | Violett / Bernstein / Pink | Grüntöne (eine Farbfamilie) |
| Schrift | Fraunces (Zahlen, Überschriften) + Plus Jakarta Sans | Barlow Condensed (Zahlen) + Barlow | Inter, große Zahlen eng gesetzt |
| Formen | Radius 26, weiche Schatten, Verläufe | Radius 14, feine Rahmen, farbige Kennzahl-Kanten | Radius 18, Flächen ohne Rahmen und Schatten |
| Startseite | Ring „kcal übrig“, Makro-Balken, Schnell-Eintragen-Chips, Wasser-Gläser, Gewicht-Kurve, Motivationskarte, Mahlzeiten | konzentrische Ringe (kcal, Protein, Wasser), Kennzahl-Leiste, Makros mit %, Kachel-Raster, 7-Tage-Balken | „865 kcal übrig“ groß, ein Balken, Makros, Mahlzeitenliste, Wasser/Gewicht |
| Navigation | Heute · Tagebuch · **+** · Fortschritt · Coach, Profil über Avatar | wie 1, Plus als eckige Taste | Heute · Tagebuch · + · Fortschritt · Ich, Assistent über ✦ oben |
| PC | Seitenleiste mit „Eintragen“ oben, Inhalte in 2–3 Spalten (alle drei Designs) | | |

Gemeinsam in allen drei: ein zentrales **Plus** (Suchen, Barcode, Als Text, Wie gestern, Nur kcal, Wasser),
Touch-Flächen ab 44 px, Hell und Dunkel, Bilder je Lebensmittel (in der Vorschau Emojis als Platzhalter;
für die App eigene, einheitliche Illustrationen), Rezepte/Wochenplan/Einkauf/Supplemente als Einträge im
Tagebuch-Bereich statt versteckter Unter-Tabs.

### Wo bestehende Funktionen landen (nichts fällt weg)

| Heute | Neu |
|---|---|
| Tab Heute (14 Kacheln, anpassbar) | Heute; Anpassen bleibt, weniger Kacheln standardmäßig sichtbar |
| Tab Tagebuch | Tagebuch |
| Tab Gewicht | Fortschritt (Gewicht, Ziel, Prognose, Wochen-/Monatsübersicht, Wochen-Check) |
| Tab Essen: Lebensmittel, Rezepte, Wochenplan, Einkauf, Supplemente | Lebensmittel über Plus → Suchen; Rezepte, Wochenplan, Einkauf, Supplemente als Einträge im Tagebuch-Bereich |
| Tab Profil mit Einstellungen | Profil über Avatar (Design 1/2) bzw. Tab „Ich“ (Design 3) |
| — | Coach/Assistent: Entwurf, erst mit der KI-Phase (5.3, Freigabe nötig) |
| Fasten, Aktivität, Wochenbericht, Mikros | bleiben als Kacheln und Unterseiten erreichbar |

## 3. Vergleich

Skala 1–5, bezogen auf Sattly und Menschen, die abnehmen wollen und mehrmals täglich kurz eintragen.

| Kriterium | Design 1 | Design 2 | Design 3 |
|---|---|---|---|
| Optik | 5 | 4 | 4 |
| Bedienbarkeit | 4 | 3 | 5 |
| Übersichtlichkeit | 4 | 3 | 5 |
| Mobile Nutzung | 5 | 4 | 5 |
| Wiedererkennbarkeit | 5 | 3 | 2 |
| Erweiterbarkeit | 4 | 5 | 3 |
| **Summe** | **27** | **22** | **24** |

Begründungen stehen in der Vorschau unter der Tabelle.

## 4. Empfehlung

**Design 1 „Premium Wellness“ als Grundlage**, ergänzt um die ruhige Tagebuch-Liste und die große
„Eintragen“-Schaltfläche aus Design 3 sowie den kräftigen Dunkelmodus für Kennzahlen aus Design 2.
Es trifft „motivieren ohne Druck“ am besten und macht Sattly über Logo-Farben und Zahlen-Schrift
unverwechselbar. Design 2 wirkt eher wie eine Trainings-App, Design 3 ist am einfachsten, aber am wenigsten
eigenständig.

## Entscheidung

Patrick hat am 22.11.2026 per Entscheidungskarte **Design 2 „Fitness & Performance“** gewählt. Umsetzung
schrittweise wie in Abschnitt 5, Stand in `docs/AI_PROGRESS.md`.

## 5. Vorschlag für Phase 4 (erst nach Freigabe)

1. **Designsystem** `lib/src/ui/design/`: `SattlyTokens` als `ThemeExtension` (Farben inkl. Makro- und
   Statusfarben, Abstände, Radien, Schatten, Schriftrollen), hell und dunkel; `buildTheme` liest daraus.
   Schriften als Assets (OFL-Lizenz, offline). Golden-Tests für Kernbausteine. Keine Datenbankänderung.
2. Bausteine: Karte, Kennzahl, Ring, Balken, Chip, Liste, Segment-Umschalter, Plus-Sheet, Navigation.
3. Bereiche einzeln, je ein PR: Navigation + Plus → Startseite → Tagebuch → Fortschritt → Profil.
   Jeder Schritt: `flutter analyze`, alle Tests, Widget-Tests für Navigation und 200 % Schrift, Screenshots
   Handy und PC. Berechnungen und Datenflüsse bleiben unverändert.
4. Die bisherigen 6 Farbschemata werden zu Akzentfarben innerhalb des gewählten Designs (Einstellung bleibt).
