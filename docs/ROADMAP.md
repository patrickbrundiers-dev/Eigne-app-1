# Roadmap

Priorisierte Aufgaben für die Entwicklung: [AI_TASK_QUEUE.md](AI_TASK_QUEUE.md). Stand am Code:
[BESTANDSAUFNAHME.md](BESTANDSAUFNAHME.md). Wettbewerb: [WETTBEWERB-MATRIX.md](WETTBEWERB-MATRIX.md).

Legende: ✅ fertig und getestet · 🔜 als Nächstes · ⬜ geplant

## Phase 1 – Grundsystem ✅ (v0.1.0)

- ✅ Projektarchitektur: Flutter-App `apps/mydiet`, Rechenkern, lokale SQLite-Datenbank, CI
- ✅ Benutzerprofil: Geschlecht, Geburtsdatum, Größe, Gewicht, Zielgewicht, Zieldatum, Körperfett,
  Beruf, Alltagsaktivität, Sport, Schlaf, Ernährungsweise, Gewohnheiten, Unverträglichkeiten,
  Vorlieben, Abneigungen, Mahlzeiten (1–6, Uhrzeiten), eigenes Kalorienziel
- ✅ Kalorienberechnung: Grundumsatz (Mifflin-St Jeor oder Katch-McArdle), Gesamtumsatz (PAL),
  Kalorienziel mit Sicherheitsgrenzen, Protein/Fett/Kohlenhydrate/Ballaststoffe/Wasser,
  alles manuell überschreibbar, Rechenweg sichtbar
- ✅ Dashboard: Kalorien, Makros, Gewicht, Zielfortschritt, Wasser, Aktivität, Gewichtskurve,
  Tageshinweise; Kacheln sortier-, aus- und einblendbar
- ✅ Lebensmittelverwaltung: 100 Basis-Lebensmittel, eigene Lebensmittel, Favoriten,
  Plausibilitätsprüfung, Duplikat-Schutz (Name + Marke, Barcode)
- ✅ Manuelle Mahlzeitenerfassung: Suche, zuletzt verwendet, Menge in g/ml, Portionen,
  Bearbeiten, Löschen mit Rückgängig, Mahlzeit vom Vortag übernehmen
- ✅ Gewichtstracking: ein Wert pro Tag, Körperfett, Bauchumfang, Trend (7 Tage), Tempo,
  Prognose, Plateau-Erkennung, Wochen- und Monatsmittel, BMI
- ✅ Wasser- und manuelle Aktivitätserfassung, JSON-Export/-Import, Hell/Dunkel, 6 Farbschemata

Bewusst noch nicht in Phase 1: Barcode-Scanner, Fotoerkennung, KI-Texteingabe, Rezepte,
Supplemente, Sync. Diese Funktionen sind in der App nirgends als fertig dargestellt.

## Phase 2 – Ernährung 🔜

- ✅ Rezeptverwaltung: Zutaten, Portionen, Nährwerte pro Portion, Endgewicht nach dem Kochen, ins Tagebuch
  (Portionen oder Gramm), Einkaufsliste mit Zusammenfassen gleicher Zutaten
- ✅ Rezept übernehmen (W9): von Webseiten mit schema.org-Rezeptdaten oder aus eingefügter Zutatenliste,
  Zutaten den eigenen Lebensmitteln zugeordnet, Unsicheres markiert, Gewicht nach dem Kochen optional
- ✅ Ernährungsplanung: Wochenplan für alle Mahlzeiten, automatisch mit eigenen Rezepten füllen (Filter über
  Rezept-Stichworte wie vegetarisch, günstig, schnell, Meal Prep, Familie), Portionen passend zum Kalorienziel,
  Einträge ändern/entfernen mit Rückgängig, Woche kopieren, Tag oder Woche ins Tagebuch (ohne Doppelzählung),
  Einkaufsliste aus dem Plan; beim Füllen bleiben Rezepte mit Unverträglichkeiten oder abgelehnten Lebensmitteln
  aus dem Profil weg, bevorzugte kommen öfter vor
- ✅ Intervallfasten (14:10 bis 36 h): Timer, Start nachträglich, Verlauf, Dashboard-Kachel
- ✅ Makro-Aufteilung nach Ernährungsweise: Vorlagen Ausgewogen, High Protein, Low Carb, Ketogen, Ausdauer;
  Kohlenhydrat-Obergrenze mit Rechenweg
- ✅ Supplement-Verwaltung: Produkte mit Inhaltsstoffen je Portion, Herstellerempfehlung, Einnahmezeiten,
  Vorrat, Abhaken pro Uhrzeit, Summen über alle Produkte (z. B. Vitamin D aus Multi + D3/K2) mit Hinweis ab
  80 % und Warnung über der tolerierbaren Höchstmenge (EFSA UL); keine eigenen Dosierungsempfehlungen
- ✅ Vitamine und Mineralstoffe aus Essen und Supplementen zusammen (W5): Richtwerte für die Basis-Lebensmittel,
  eigene Werte vom Etikett oder aus Open Food Facts, Ziele nach D-A-CH, Ampel mit EFSA-Höchstmengen,
  Warnung bei Überschneidungen zwischen Präparaten, Dashboard-Kachel
- ✅ Barcode-Scanner (Kamera auf Android, Eingabe oder USB-Scanner unter Windows) + Open Food Facts:
  erst lokal suchen (offline), sonst Open Food Facts fragen (nur der Barcode wird gesendet), Werte prüfen,
  dann speichern; Quelle und Datenqualität (W2) sichtbar
- ✅ Erinnerungen (Einstellungen → Erinnerungen): Mahlzeiten zu ihren Uhrzeiten (optional früher), Wasser in
  festem Abstand, Supplemente zu ihren Einnahmezeiten (gleiche Uhrzeit = eine Meldung), Wiegen an gewählten
  Tagen; nur lokal geplant, passen sich automatisch an geänderte Mahlzeiten und Supplemente an
- ✅ PC als Planungs-Arbeitsplatz (W8): Wochenplan mit Tagen nebeneinander, Ziehen auf andere Tage (Strg =
  kopieren), Verschieben/Kopieren über das Menü, Tastenkürzel (F1 zeigt alle)

### Online-Update (vorbereitet, folgt sobald die Android-Signatur-Secrets angelegt sind)

- ⬜ Update-Prüfung über GitHub Releases (täglich, abschaltbar, manuell in den Einstellungen), Release-Notizen,
  Überspringen; Windows: Setup laden, Größe/SHA-256 prüfen, still installieren, Neustart; Android: APK über den
  Browser (fester Signaturschlüssel nötig; Code in Commit 1265bf6)

## Phase 3 – KI

- ⬜ KI-Texteingabe („200 g Hähnchen, 250 g Kartoffeln …“) mit Zuordnung zur Datenbank,
  Schätzwerte gekennzeichnet, Speicherung erst nach Bestätigung
- ⬜ Fotoerkennung von Mahlzeiten (Schätzung, immer bestätigungspflichtig)
- ⬜ KI-Ernährungscoach: Tagesauswertung, Proteinlücken, nächste Mahlzeit, Muster
- ⬜ Wochenbericht mit Vorschlag zur Anpassung des Kalorienziels aus dem echten Gewichtsverlauf
  (transparent erklärt, nur nach Bestätigung)

## Phase 4 – Integrationen und Sync

- ⬜ Konto + Sync über gehostetes PostgreSQL (EU), offline-first, Row-Level-Security
- ⬜ Gemeinsamer Katalog für alle Nutzer (Wunsch Patrick, 2026-11-22): Lebensmittel und Rezepte, die jemand
  freigibt, kann jeder finden und nutzen. Läuft auf derselben Datenbank im kostenlosen Tarif, also ohne
  Mehrkosten, solange die Nutzerzahl klein bleibt. Tagebuch, Gewicht, Profil und Supplemente bleiben privat.
  Einzelheiten in [DATENMODELL.md](DATENMODELL.md#gemeinsamer-katalog-phase-4)
- ⬜ Google Health Connect (Schritte, Aktivitätskalorien, Training, Herzfrequenz, Schlaf)
- ⬜ Garmin Connect, Apple Health (mit iOS-App)
- ⬜ Erweiterte Auswertungen und eigene Diagramme

## Phase 5 – Optimierung

- ⬜ Datenbank-Verschlüsselung auf dem Gerät (SQLCipher) und App-Sperre
- ⬜ Automatische Backups, Fehlerberichte ohne Gesundheitsdaten
- ⬜ Performance, Barrierefreiheit, weitere Tests (Integrationstests auf Geräten)
- ⬜ App-Icon, Store-Veröffentlichung
