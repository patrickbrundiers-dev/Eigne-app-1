# Changelog

## Nächste Version (in Arbeit)

## 0.2.0 – Phase 2: Ernährung (2026-11-22)

- Neuer Name: Die App heißt jetzt **Sattly**, mit neuem Logo (grünes „S“ im Teller-Fortschrittsring mit Blatt) als
  App-Icon auf Android und Windows und in der Oberfläche. Updates von MyDiet AI 0.1.0 behalten alle Daten;
  der Windows-Installer ersetzt die alten Verknüpfungen
- Rezepte: Zutaten aus der Lebensmitteldatenbank, Portionen, optional Gewicht nach dem Kochen,
  Nährwerte pro Portion und pro 100 g mit Rechenweg, Stichworte, Zubereitung, Favoriten
- Rezepte im Tagebuch: über die Suche oder „Heute eintragen“, als Portion oder in Gramm; die Werte werden
  wie bei Lebensmitteln eingefroren
- Einkaufsliste: Zutaten eines Rezepts für beliebig viele Portionen, gleiche Zutaten werden zusammengefasst,
  eigene Einträge („500 g Hackfleisch“), abhaken, erledigte entfernen, Wischen zum Löschen mit Rückgängig
- Navigation: „Lebensmittel“ heißt jetzt „Essen“ mit den Reitern Lebensmittel, Rezepte, Einkauf
- Datenbank Schema 2 mit getesteter Migration; Export/Import enthält Rezepte und Einkaufsliste
- Supplemente: Produkte mit Inhaltsstoffen vom Etikett (28 Stoffe im Katalog plus eigene), Verzehrempfehlung
  des Herstellers, Portionen pro Tag, Uhrzeiten, Vorrat in Tagen, Abhaken pro Uhrzeit (auch auf dem Dashboard)
- Tagessumme je Inhaltsstoff über alle Produkte (z. B. Vitamin D aus Multi + D3/K2) mit % der Referenzmenge
  und der tolerierbaren Höchstmenge (EFSA): Hinweis ab 80 %, Warnung darüber; keine Dosierungsempfehlungen
- Datenbank Schema 3
- Wochenplan (Essen → Wochenplan): Rezepte und Lebensmittel pro Tag und Mahlzeit planen, Woche mit Rezepten
  automatisch füllen (passend zum Kalorienziel, Filter über Stichworte), kopieren, leeren, ins Tagebuch
  übernehmen (ohne Doppelzählung), Einkaufsliste aus dem Plan
- Makro-Vorlagen je Ernährungsweise und Kohlenhydrat-Obergrenze (Low Carb, Ketogen) im Profil
- Intervallfasten mit Timer, nachträglichem Start und Verlauf als Dashboard-Kachel
- Datenbank Schema 4; Migrationen laufen jetzt schrittweise über die gespeicherten Schemata
- Wochen-Check auf der Gewichtsseite: echter Verbrauch aus Aufnahme und Gewichtsverlauf der letzten 28 Tage,
  unvollständige Tage werden ausgelassen, Vorschlag für das Kalorienziel mit Rechenweg (höchstens 300 kcal
  Änderung auf einmal, nie unter dem Mindestwert), gilt erst nach Bestätigung
- Schnell-Erfassung: „Oft zum Frühstück/Abendessen …“ schlägt je Mahlzeit die Lebensmittel vor, die dort in den
  letzten 60 Tagen am häufigsten eingetragen wurden; Schnelleintrag nur mit Kalorien (Makros optional), als
  Schätzung gekennzeichnet; Mahlzeit auf ein beliebiges Datum kopieren
- Wochenbudget (Einstellungen): 7 × Tagesziel pro Woche; mehr oder weniger an einem Tag wird auf die restlichen
  Tage verteilt (höchstens +20 %, nie unter dem Mindestwert, Tage ohne Einträge zählen als Tagesziel)
- Zahlen ausblenden (Einstellungen): Dashboard und Tagebuch zeigen nur Fortschritt und freundliche Hinweise
  statt Kalorien und Gramm
- Sicherungen: täglich automatisch eine lokale Sicherung (die letzten 14 bleiben), „Jetzt sichern“ und
  Wiederherstellen in den Einstellungen; vor jeder Wiederherstellung wird der aktuelle Stand gesichert
- CSV-Export für Tagebuch und Gewicht (Semikolon, Dezimalkomma, öffnet direkt in Excel)

## 0.1.0 – Phase 1: Grundsystem (2026-11-22)

Neuentwicklung als MyDiet AI. Die vorherige App „Paperless AI“ wurde aus dem Repository entfernt
(letzter Stand: Commit `a262499`, Releases `v0.7.0`/`v0.8.0`).

- Flutter-App `apps/mydiet` für Android und Windows mit lokaler SQLite-Datenbank (drift)
- Einrichtung und Profil mit allen Angaben aus dem Auftrag
- Grundumsatz (Mifflin-St Jeor / Katch-McArdle), Gesamtumsatz, Kalorienziel mit Sicherheitsgrenzen,
  Makro-, Ballaststoff- und Wasserziel, alles manuell überschreibbar, Rechenweg in der App
- Dashboard mit 10 Kacheln, sortier- und ausblendbar
- 100 Basis-Lebensmittel, eigene Lebensmittel mit Plausibilitätsprüfung, Duplikat-Schutz, Favoriten
- Tagebuch mit 1–6 Mahlzeiten, Suche, zuletzt verwendet, Portionen, Rückgängig, Vortag übernehmen
- Gewicht mit Trend, Tempo, Prognose, Plateau-Erkennung, Wochen-/Monatsmitteln, BMI
- Wasser, manuelle Aktivität ohne Doppelzählung, regelbasierte Tageshinweise
- JSON-Export und -Import, Hell/Dunkel-Modus, 6 Farbschemata
- 75 automatische Tests; CI für Tests sowie Windows-Installer und Android-APK
