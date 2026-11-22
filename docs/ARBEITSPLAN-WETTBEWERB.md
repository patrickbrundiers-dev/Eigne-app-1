# Arbeitsplan: MyDiet AI besser als YAZIO, MyFitnessPal & Co.

Stand: 22.11.2026. Baut auf [ANALYSE.md](ANALYSE.md) und [ROADMAP.md](ROADMAP.md) auf und ersetzt sie nicht.
Dieses Dokument sagt, **welche** Funktionen MyDiet AI gegenüber bekannten Apps abheben, **in welcher
Reihenfolge** sie kommen und **woran** wir messen, dass sie besser sind.
Ergänzung mit Lifesum und Vergleichsmatrix (Stand 22.11.2026): [WETTBEWERB-MATRIX.md](WETTBEWERB-MATRIX.md).

Grundlage sind ausschließlich öffentlich sichtbare Funktionen, Store-Beschreibungen, Testberichte und
Nutzerbewertungen (Quellen am Ende). Es wird kein Code, kein Design und keine Datenbank fremder Apps
übernommen, keine App dekompiliert. Lebensmitteldaten kommen aus freien Quellen (Open Food Facts u. a.).

---

## 1. Wettbewerb in Kürze

| App | Stärken (öffentlich sichtbar) | Häufigste Kritik von Nutzern |
|---|---|---|
| **YAZIO** | sehr gute Oberfläche, Intervallfasten integriert, Rezepte, in DACH verbreitet | viele Funktionen nur mit Pro-Abo, Werbung und Upsell (z. B. Fasten-Pläne), automatische Abo-Verlängerung, Datenbank außerhalb DACH dünn |
| **MyFitnessPal** | riesige Lebensmitteldatenbank, viele Integrationen | Barcode-Scanner seit 2022 nur noch mit Premium, Werbung, viele falsche Nutzereinträge, Redesign mit mehr Klicks, Sync-Probleme (Google Health/Fitbit), Abmeldungen |
| **Lose It!** | einfache, schnelle Erfassung, Lebenszeit-Lizenz | Barcode und Makros hinter Paywall, Kündigung schwierig, Werbung |
| **Cronometer** | geprüfte Daten, sehr viele Mikronährstoffe, Barcode auch gratis | Video-Werbung in der Gratis-Version, Suche, Update brach Apple-Health-Anbindung, keine adaptiven Ziele, mehr Taps pro Eintrag |
| **MacroFactor** | adaptiver Energieverbrauch aus Gewicht + Aufnahme, wöchentlich angepasste Ziele, schnelle Erfassung, keine Werbung | nur Abo, keine Gratis-Version; wenig Mikronährstoff-Tiefe |
| **FDDB** | große deutsche Produktdatenbank, PC-Webversion | altmodische Oberfläche, Werbung, Kernfunktionen im Abo |

**Muster über alle Apps:** Die Kritik richtet sich fast nie gegen fehlende Funktionen, sondern gegen
(1) Paywalls für Grundfunktionen, (2) Werbung und Dark Patterns, (3) ungenaue Daten, (4) zu viele Taps
pro Eintrag, (5) unzuverlässige Integrationen, (6) starre Ziele, die nicht zum echten Verlauf passen.

## 2. Unsere Versprechen (Leitplanken für jede Funktion)

1. **Keine Paywall, keine Werbung, keine Dark Patterns.** Barcode, Makros, Mikros, Export, Fasten:
   alles ist enthalten. Kein Streak-Druck, keine Schuld-Formulierungen.
2. **Jede Zahl ist erklärbar.** Jede Zielgröße und jede Summe hat einen „Wie berechnet?“-Rechenweg
   (gibt es schon für das Kalorienziel, wird auf alles ausgeweitet).
3. **Datenqualität sichtbar.** Jeder Lebensmittelwert trägt Quelle und Qualitätsstufe.
4. **Schneller als die anderen.** Ziel: häufige Einträge in ≤ 3 Taps, neues Lebensmittel per Barcode ≤ 5 s.
5. **Daten gehören Patrick.** Offline-first, vollständiger Export jederzeit, kein Lock-in.
6. **Gleichwertig auf Handy und PC.** Der PC ist kein Anhängsel, sondern der Ort für Planung und Auswertung.

## 3. Lücken-Matrix

Wettbewerber nach öffentlichem Kenntnisstand (Store-Seiten, Tests, Bewertungen); Angebote ändern sich häufig.

✅ vorhanden · 🔜 in ROADMAP geplant · ➕ neu durch diesen Plan · 💰 nur im Bezahl-Abo

| Funktion | YAZIO | MFP | Cronometer | MacroFactor | **MyDiet AI** |
|---|---|---|---|---|---|
| Barcode-Scanner | ✅ | 💰 | ✅ | ✅ | ✅ |
| Makro-Ziele frei einstellbar | 💰 | 💰 | ✅ | ✅ | ✅ |
| Mikronährstoffe mit Zielen | teilweise | wenige | ✅ | wenige | ➕ (P1) |
| Supplemente **mit Summen über Nahrung + Präparate** | – | – | teilweise | – | 🔜 + ➕ |
| Adaptiver Verbrauch aus echtem Gewichtsverlauf | – | – | – | ✅ 💰 | ➕ (P0, vorgezogen) |
| Wochenbudget statt starrem Tagesziel | – | – | – | teilweise | ➕ (P1) |
| Intervallfasten | ✅ (Pläne 💰) | 💰 | ✅ | – | ➕ (P1) |
| Konfigurierbares Dashboard | wenig | wenig | ✅ | wenig | ✅ |
| Rechenweg für jede Zahl | – | – | – | teilweise | ✅ teilweise → ➕ überall |
| Quelle/Qualität je Lebensmittel sichtbar | – | – | ✅ | teilweise | ➕ (P0) |
| Vollständige PC-Version | Web | Web | Web | – | ✅ (Windows) |
| Vollständiger Export | 💰 | 💰 | ✅ | ✅ | ✅ JSON → ➕ CSV |
| Doppelzählung Aktivität verhindert | unklar | häufige Kritik | ✅ | ✅ | ✅ |
| KI-Texteingabe / Foto | ✅ 💰 | ✅ 💰 | teilweise | ✅ | 🔜 Phase 3 |
| Garmin lesen **und** schreiben | lesen | lesen | lesen | – | 🔜 Phase 4 |

## 4. Arbeitspakete

Priorität: **P0** = macht den Unterschied sofort spürbar, direkt nach dem laufenden Phase-2-Teil;
**P1** = nächste Ausbaustufe; **P2** = später. Aufwand: S (≤ 1 Tag), M (2–4 Tage), L (≥ 1 Woche).
Jedes Paket ist ein eigener PR mit Tests im Rechenkern (`core/`).

### P0 – Das Fundament, das die anderen nicht haben

**W1 · Schnell-Erfassung (M)** – Einordnung: Erweiterung Phase 1/2
- „Zuletzt & häufig“ je Mahlzeit **und Uhrzeit** (morgens andere Vorschläge als abends) ganz oben.
- Gespeicherte Mahlzeiten-Vorlagen („Mein Frühstück“) mit einem Tap eintragen, Mengen anpassbar.
- Schnell-Kalorien (nur kcal + optional Makros) für Restaurant/Unterwegs, als Schätzung gekennzeichnet.
- Suche tippfehlertolerant und lokal (kein Netz nötig), Treffer nach eigener Nutzung sortiert.
- Ganzen Tag oder Mahlzeit kopieren auf beliebiges Datum (heute nur „vom Vortag“).
- Akzeptanz: Wiederholtes Frühstück in ≤ 2 Taps; Messung per Widget-Test (Anzahl Taps).

**W2 · Datenqualität sichtbar machen (M)** – Einordnung: Phase 2 (Barcode/Open Food Facts) – ✅ umgesetzt (Quelle + Stufe Richtwert / vom Etikett / vollständig / prüfen / Schätzung, Atwater-Check)
- Jedes Lebensmittel bekommt `quelle` (Basis, Open Food Facts, eigen, KI-Schätzung) und eine
  Qualitätsstufe (geprüft / vollständig / unvollständig / Schätzung), als Symbol in Liste und Tagebuch.
- Energie-Plausibilitätscheck (Atwater: kcal ≈ 4·Protein + 4·KH + 9·Fett + 7·Alkohol, ±15 %) für
  importierte Produkte; Abweichung wird markiert statt stillschweigend übernommen.
- Open-Food-Facts-Produkte werden lokal gecacht und können korrigiert werden (eigene Korrektur hat Vorrang,
  Original bleibt erhalten).
- Basisdatenbank erweitern mit freien Quellen; Lizenz vorher prüfen: Open Food Facts (ODbL),
  USDA FoodData Central (gemeinfrei, gute Mikronährstoffe), Bundeslebensmittelschlüssel (Lizenzlage prüfen).
- Akzeptanz: Kein Produkt ohne Quelle; Tests für Plausibilitätscheck und Vorrang der eigenen Korrektur.

**W3 · Adaptives Kalorienziel aus echtem Verlauf (L)** – Einordnung: in ROADMAP als Phase-3-Wochenbericht
geplant, wird **vorgezogen**, weil es kein KI-Modell braucht, sondern reine Rechnung.
- Tatsächlicher Verbrauch = Ø Aufnahme − (Trendgewicht-Änderung × ca. 7700 kcal/kg) / Tage,
  über gleitende 2–4 Wochen, geglättet; Trendgewicht gibt es schon (`weight_trend.dart`).
- Unvollständige Tage (deutlich unter Erfassungsgewohnheit) werden erkannt und ausgeschlossen, statt das
  Ergebnis zu verfälschen; die App sagt, wie viele Tage gezählt haben.
- Wöchentlicher Vorschlag „Ziel von X auf Y kcal“ mit vollständigem Rechenweg; gilt erst nach Bestätigung.
  Untergrenze (Grundumsatz bzw. Mindestwert) wird nie unterschritten.
- Akzeptanz: Unit-Tests mit synthetischen Verläufen (Defizit, Plateau, Wassereinlagerung, Lücken).

**W4 · Zuverlässigkeit vor Funktionen (S)** – Einordnung: aus Phase 5 vorgezogen
- Automatisches lokales Backup (täglich, letzte 14 Stände) und Wiederherstellen in den Einstellungen.
- CSV-Export (Tagebuch, Gewicht, Supplemente) zusätzlich zum JSON.
- Akzeptanz: Wiederherstellungstest in der Testsuite.

### P1 – Bereiche, in denen MyDiet AI klar führt

**W5 · Mikronährstoffe und Supplemente als Einheit (L)** – Einordnung: Phase 2 Supplemente + Erweiterung – ✅ umgesetzt
- Ziele nach D-A-CH-Referenzwerten (Alter, Geschlecht), tolerierbare Höchstmengen nach EFSA.
- Tagessumme **aus Lebensmitteln + allen Präparaten** je Nährstoff (z. B. Vitamin D aus Multi, D3/K2 und
  Lebensmitteln) mit Ampel: unter Ziel / im Ziel / über Höchstmenge. Keine eigenen Dosierungsempfehlungen.
- Einnahme abhaken (Erinnerung aus Phase 2), Vorrat zählen, Hinweis „reicht noch 9 Tage“.
- Überschneidungserkennung beim Anlegen eines neuen Präparats („enthält ebenfalls Zink, zusammen 38 mg“).
- Akzeptanz: Tests für Einheitenumrechnung (µg/IE, mg) und Summenbildung.

**W6 · Flexibles Wochenbudget (M)**
- Wahlweise Tages- oder Wochenziel; höhere Tage (Wochenende, Feier) werden auf die restlichen Tage
  verteilt, mit Grenze nach unten. Wochenansicht zeigt Soll/Ist je Tag.

**W7 · Intervallfasten ohne Upsell (M)**
- Fastenfenster frei (16:8, 18:6, 5:2, eigene), Timer, Verlauf; Fastenfenster aus den Tagebuchzeiten
  automatisch erkannt. Optionale Erinnerung.

**W8 · PC als Planungs-Arbeitsplatz (M)** – Einordnung: Phase 2 Ernährungspläne – ✅ Wochenplan nebeneinander, Ziehen, Tastenkürzel (Tabellen mit wählbaren Spalten noch offen)
- Wochenplan per Tastatur und Ziehen, Tabellen mit Spalten nach Wahl, Auswertungen breiter darstellen,
  Tastenkürzel für Eintragen und Suche.

**W9 · Rezepte schnell übernehmen (M)** – Einordnung: Phase 2 Rezepte – ✅
- Rezept aus Webseite übernehmen (schema.org-Recipe-Daten), Zutaten der Datenbank zuordnen,
  unsichere Zuordnungen markieren; gekochtes Gesamtgewicht eingeben → Nährwerte je 100 g / Portion.

**W10 · Freundlicher Umgang (S)**
- Optionaler Modus „Zahlen ausblenden“ (nur Ampel/Trend), keine Schuldsprache, Rückfall-Tage ohne Warnton.
  Texte nach diesem Grundsatz prüfen.

### P2 – Später, auf dem Fundament aufbauend

**W11 · KI, aber kontrolliert (L)** – Phase 3: Texteingabe, Foto, Coach. Jede KI-Schätzung trägt Qualitätsstufe
„Schätzung“ (W2) und wird erst nach Bestätigung gespeichert. Coach nutzt W3 und W5 als Datengrundlage.

**W12 · Integrationen mit Statusanzeige (L)** – Phase 4: Health Connect, Garmin (lesen/schreiben).
Zusätzlich sichtbare Sync-Übersicht (letzter Abgleich, Fehler, erneut versuchen), weil Sync-Abbrüche bei
MyFitnessPal und Cronometer häufig kritisiert werden.

**W13 · Homescreen-Widgets Android (M)** – Kalorien übrig, Wasser +1, Schnell-Eintrag.

**W14 · Import aus anderen Apps (M)** – CSV-Exporte anderer Apps einlesen, soweit der Nutzer sie dort
selbst exportieren kann (Tagebuch und Gewicht), damit ein Umstieg ohne Datenverlust möglich ist.

## 5. Reihenfolge

| Schritt | Pakete | Hängt ab von |
|---|---|---|
| 1 | laufende Phase 2 (Rezepte, Pläne, Supplemente, Barcode) zu Ende | – |
| 2 | W2 Datenqualität, W1 Schnell-Erfassung, W4 Backup/CSV | Barcode aus Phase 2 |
| 3 | W3 adaptives Ziel | Gewichtstrend (vorhanden) |
| 4 | W5 Mikros + Supplemente, W7 Fasten, W6 Wochenbudget | Supplemente aus Phase 2 |
| 5 | W8 PC-Planung, W9 Rezept-Import, W10 Ton | Pläne/Rezepte aus Phase 2 |
| 6 | Phase 3/4 der ROADMAP mit W11, W12 | W2, W3 |
| 7 | W13, W14 | – |

## 6. Woran wir „besser“ messen

| Kennzahl | Ziel |
|---|---|
| Taps für wiederholte Mahlzeit | ≤ 2 |
| Zeit für neues Produkt per Barcode | ≤ 5 s (bei Netz), offline aus Cache sofort |
| Lebensmittel ohne Quelle/Qualitätsstufe | 0 |
| Funktionen hinter Paywall / Werbung | 0 |
| Angezeigte Zahlen ohne Rechenweg | 0 |
| Datenverlust nach Neuinstallation mit Backup | 0 |
| Abweichung adaptiver Verbrauch in Testverläufen | ≤ 5 % nach 3 Wochen |

## 7. Bewusst nicht

- Keine Übernahme fremder Datenbanken, Texte, Icons oder Designs; keine Dekompilierung fremder Apps.
- Keine Community-/Social-Funktionen (Hauptquelle falscher Einträge und Druck bei anderen Apps).
- Keine medizinischen Diagnosen oder Dosierungsempfehlungen; nur Referenzwerte und Höchstmengen mit Quelle.

## 8. Quellen

Öffentliche Seiten, gelesen am 22.11.2026. Mehrere Quellen stammen von Konkurrenz-Anbietern und sind
entsprechend vorsichtig gewichtet.

- MyNetDiary, Diet App Scorecard Oktober 2026 (Anbieter-eigene Auswertung von App-Store-Bewertungen):
  https://www.mynetdiary.com/diet-app-scorecard-october-2026.html
- Unstar, Calorie tracking apps ranked by 1-star reviews (2026, Werbeseite eines Analyse-Dienstes):
  https://unstar.app/blog/calorie-tracking-apps-ranked-1-star-reviews-2026
- MacroFactor vs Cronometer (Herstellerseite MacroFactor): https://macrofactor.com/macrofactor-vs-cronometer/
- FeastGood, MyFitnessPal-Kritik (enthält Werbung für MacroFactor): https://feastgood.com/?p=41873
- Bericht zur Barcode-Paywall bei MyFitnessPal (2022): https://news.slashdot.org/story/22/08/25/1955238/myfitnesspal-paywalls-barcode-scanner-that-made-counting-calories-easy
- Store-Seite FDDB: https://apps.apple.com/de/app/fddb-kalorien-z%C3%A4hler-fasten/id1105332761
- Trustpilot-Bewertungen YAZIO: https://www.trustpilot.com/review/yazio.com
