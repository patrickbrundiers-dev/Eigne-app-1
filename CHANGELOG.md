# Changelog

## Nächste Version (in Arbeit)

## 0.4.0 – Health Connect, Wochenbericht, schnelleres Eintragen (2026-11-22)

- Health Connect (Android, Einstellungen → Health Connect): Schritte, aktive Kalorien, Trainings und Gewicht
  aus Health Connect übernehmen, also auch von Garmin Connect, Samsung Health oder Google Fit. Jedes Training
  wird ein Aktivitätseintrag, dazu ein Eintrag „Alltag“ pro Tag ohne Doppelzählung; erneutes Übernehmen
  aktualisiert statt zu verdoppeln, eigene Gewichtseinträge haben Vorrang. Auf Wunsch automatisch beim Öffnen.
  Die App braucht jetzt mindestens Android 8
- Health Connect: Mahlzeiten schreiben (eigener Schalter). Kalorien und Nährwerte je Mahlzeit der letzten 7 Tage
  gehen nach Health Connect; Änderungen im Tagebuch werden beim nächsten Abgleich übernommen, nichts doppelt

- Wochenbericht (neue Dashboard-Kachel, Seite mit Wochenwechsel): wie viele Tage eingetragen, Ø Kalorien und
  Protein gegen das Ziel, Tage im Zielbereich, Wochenend-Muster, Ballaststoffe, eher niedrige Vitamine und
  Mineralstoffe, Gewicht im 7-Tage-Mittel gegen die Vorwoche; dazu höchstens drei Vorschläge für die nächste
  Woche. Jede Aussage nennt ihre Zahlen, alles lokal und regelbasiert, ohne KI

- Gewohnheiten: Isst du dieselbe Kombination mindestens dreimal in vier Wochen zur selben Mahlzeit, schlägt die
  App beim Eintragen vor, sie als Vorlage zu speichern (ablehnen möglich, dann nicht wieder)

- Portionen lernen: Beim Eintragen ist die Menge vorausgefüllt, die du für dieses Lebensmittel meistens nimmst
  (Chip „Wie üblich“), auch im Text-Eintrag

- Dashboard: Knopf „Eintragen“ unten rechts. Mahlzeit ist nach Uhrzeit vorausgewählt, dann Suchen, Barcode,
  Als Text, Nur Kalorien oder Gewicht – jeder Eintrag in höchstens drei Taps. Die Gewichtskachel zeigt das
  Tempo der letzten 30 Tage mit Aussagekraft

- Suche verzeiht Tippfehler: „Haferflokcen“, „Banae“ oder „Huhnerei“ finden trotzdem das Richtige. Was du oft
  isst, steht bei gleich guten Treffern vorne. Auch „Als Text eintragen“ bietet bei Tippfehlern ähnliche
  Lebensmittel an, markiert sie aber als unsicher

- Rezept übernehmen (Essen → Rezepte, Link-Knopf): Webadresse eingeben, die App liest Name, Portionen, Zutaten
  und Zubereitung aus den Rezeptdaten der Seite und ordnet jede Zutat deinen Lebensmitteln zu; unsichere
  Zuordnungen und Mengenannahmen sind markiert und lassen sich ändern, fehlende Lebensmittel direkt anlegen.
  Optional das Gewicht nach dem Kochen für Werte je 100 g. Ohne Webadresse geht auch eine eingefügte
  Zutatenliste (offline). Nährwerte kommen immer aus deinen Lebensmitteln, nie von der Seite

- Wochenplan „Mit Rezepten füllen“ beachtet das Profil: Rezepte mit Unverträglichkeiten (z. B. Laktose steht
  auch für Milch, Joghurt, Käse; Gluten für Weizen, Hafer, Nudeln …) oder abgelehnten Lebensmitteln bleiben
  weg, mit Grund in der Meldung; Rezepte mit bevorzugten Lebensmitteln kommen öfter vor

- Einstellungen → Daten → „Alle Daten löschen“: löscht alles endgültig vom Gerät (auch gelöschte Einträge,
  eigene Lebensmittel, Erinnerungen), wahlweise auch die automatischen Sicherungen; Bestätigung durch Eingabe
  von „LÖSCHEN“. Danach startet die App wie neu installiert

- Einstellungen → Fehlerprotokoll: technische Fehler werden lokal gespeichert (die letzten 50), ohne Zahlen,
  Texte in Anführungszeichen und Dateipfade, damit keine Gesundheitsdaten darin landen; kopieren und leeren
  möglich, nichts wird gesendet

## 0.3.0 – Barcode, Erinnerungen, Text-Eingabe, Vitamine und Mineralstoffe (2026-11-22)

- PC als Planungs-Arbeitsplatz: der Wochenplan zeigt im breiten Fenster die Tage nebeneinander; Einträge lassen
  sich mit der Maus (am Handy lange drücken) auf einen anderen Tag ziehen, mit Strg kopieren, oder über das Menü
  „Auf anderen Tag verschieben/kopieren“, jeweils mit Rückgängig. Tastenkürzel: Strg+E Eintragen für die
  aktuelle Mahlzeit, Strg+1–5 Bereiche, Alt+←/→ Tag bzw. Woche wechseln, Alt+Pos1 heute, F1 Übersicht

- Vitamine und Mineralstoffe: Tagessumme aus Essen und Supplementen zusammen (Vitamin D, B12, Folat, C,
  Calcium, Magnesium, Eisen, Zink, Jod, Kalium, Omega-3) mit Ziel nach D-A-CH, Ampel und EFSA-Höchstmengen;
  Richtwerte für 100 Basis-Lebensmittel, eigene Werte im Lebensmittel-Formular, Werte aus Open Food Facts;
  beim Anlegen eines Supplements Hinweis, wenn andere Produkte denselben Stoff enthalten; neue
  Dashboard-Kachel; Datenbank Schema 6

- Erinnerungen (Einstellungen → Erinnerungen): an Mahlzeiten (zur Uhrzeit oder 10–60 Minuten vorher), ans
  Trinken (Zeitraum und Abstand wählbar), an Supplement-Einnahmen (aus den eingetragenen Uhrzeiten, gleiche
  Uhrzeit wird zusammengefasst) und ans Wiegen (Uhrzeit, Wochentage); alles lokal auf dem Gerät, Änderungen an
  Mahlzeiten oder Supplementen werden automatisch übernommen. Android fragt einmal nach der Erlaubnis für
  Benachrichtigungen

- Barcode-Scanner: Kamera auf Android, Eingabefeld oder USB-Scanner unter Windows; bekannte Produkte kommen
  offline aus der eigenen Datenbank, neue von Open Food Facts (nur der Barcode wird gesendet) und werden vor
  dem Speichern zur Prüfung vorausgefüllt; Prüfziffer wird kontrolliert
- Datenqualität sichtbar: Quelle (Basis, eigen, Open Food Facts, KI) und Stufe (Richtwert, vom Etikett,
  vollständig, prüfen, Schätzung) als Symbol in Liste und Suche; Open-Food-Facts-Werte mit Energie-Check
- Android: Internet-Berechtigung ergänzt (nötig für Open Food Facts)
- Gewicht: neue Karte „Fortschritt“ mit Start, bisher abgenommen, noch bis Ziel, 7-Tage-Durchschnitt gegen
  Vorwoche, 30-Tage-Trend mit Aussagekraft und typischer Tagesschwankung, geschätzter Zielerreichung sowie
  Kalorienbilanz und Proteinziel der letzten 7 Tage; erklärt, wenn Bilanz und Waage nicht zusammenpassen
- Als Text eintragen: ganze Mahlzeit in einem Satz („200 g Haferflocken, 300 ml Milch, 1 Banane, 2 EL
  Erdnussbutter“), auch direkt aus der Suche. Erkennt Mengen, Einheiten (g, kg, ml, l, EL, TL, Stück, Scheibe,
  Becher …), Zahlwörter und Brüche, ordnet nur eigene Lebensmittel zu (offline, nichts wird gesendet).
  Annahmen und unsichere Treffer sind markiert und werden erst nach Häkchen eingetragen; Lebensmittel und
  Menge lassen sich vorher ändern, fehlende Lebensmittel direkt anlegen. Ohne Mengenangabe wird die zuletzt
  eingetragene Menge vorgeschlagen

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
- Mahlzeiten-Vorlagen: Mahlzeit im Tagebuch „Als Vorlage speichern“, in der Lebensmittelauswahl mit einem Tipp
  komplett eintragen (Vorlagen der gleichen Mahlzeit zuerst), gleicher Name ersetzt, lange drücken löscht
- Datenbank Schema 5 (Vorlagen) mit getesteter Migration

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
