# Changelog

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
