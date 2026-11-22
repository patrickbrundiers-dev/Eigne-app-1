# Roadmap

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

- ⬜ Rezeptverwaltung: Zutaten, Portionen, Nährwerte pro Portion, Einkaufsliste
- ⬜ Ernährungsplanung: Wochenplan, 1–6 Mahlzeiten, Intervallfasten, Low Carb/High Protein/vegetarisch/vegan,
  Familiengerichte, günstig, schnell, Meal Prep; Plan anpassen, ohne die Planung zu verlieren
- ⬜ Makro-Aufteilung nach Ernährungsweise (z. B. Low Carb) statt fester Prozentwerte
- ⬜ Supplement-Verwaltung: Produkte mit Inhaltsstoffen je Portion, Herstellerempfehlung, Einnahmezeiten,
  Summen über alle Produkte (z. B. Vitamin D aus Multi + D3/K2) mit Hinweis bei Überschreiten der
  tolerierbaren Höchstmenge (EFSA UL); keine eigenen Dosierungsempfehlungen
- ⬜ Barcode-Scanner (Kamera) + Open Food Facts
- ⬜ Erinnerungen (Mahlzeiten, Wasser, Supplemente, Wiegen)

## Phase 3 – KI

- ⬜ KI-Texteingabe („200 g Hähnchen, 250 g Kartoffeln …“) mit Zuordnung zur Datenbank,
  Schätzwerte gekennzeichnet, Speicherung erst nach Bestätigung
- ⬜ Fotoerkennung von Mahlzeiten (Schätzung, immer bestätigungspflichtig)
- ⬜ KI-Ernährungscoach: Tagesauswertung, Proteinlücken, nächste Mahlzeit, Muster
- ⬜ Wochenbericht mit Vorschlag zur Anpassung des Kalorienziels aus dem echten Gewichtsverlauf
  (transparent erklärt, nur nach Bestätigung)

## Phase 4 – Integrationen und Sync

- ⬜ Konto + Sync über gehostetes PostgreSQL (EU), offline-first, Row-Level-Security
- ⬜ Google Health Connect (Schritte, Aktivitätskalorien, Training, Herzfrequenz, Schlaf)
- ⬜ Garmin Connect, Apple Health (mit iOS-App)
- ⬜ Erweiterte Auswertungen und eigene Diagramme

## Phase 5 – Optimierung

- ⬜ Datenbank-Verschlüsselung auf dem Gerät (SQLCipher) und App-Sperre
- ⬜ Automatische Backups, Fehlerberichte ohne Gesundheitsdaten
- ⬜ Performance, Barrierefreiheit, weitere Tests (Integrationstests auf Geräten)
- ⬜ App-Icon, Store-Veröffentlichung
