# Architektur

```
apps/mydiet/
  lib/
    main.dart                  Start: Datumsformate laden, Datenbank öffnen
    src/
      core/                    Rechenkern, reines Dart, ohne Flutter und ohne Datenbank
        energy.dart            Grundumsatz, PAL, Kalorienziel, Makros, Rechenweg
        nutrition.dart         Nährwert-Arithmetik, Plausibilität, Duplikat-Schlüssel
        weight_trend.dart      Trend, Tempo, Prognose, Plateau, Wochen-/Monatsmittel
        day_budget.dart        Tagesbudget, Aktivitätsanrechnung, Doppelzählungs-Schutz
        daily_hints.dart       regelbasierte Tageshinweise
        dashboard_layout.dart  Kachel-Konfiguration (Reihenfolge, Sichtbarkeit)
        dates.dart             Tagesschlüssel yyyy-MM-dd
      data/                    Datenhaltung
        tables.dart            drift-Tabellen (Sync-Spalten, eindeutige Indizes)
        database.dart          AppDatabase: alle Lese-/Schreiboperationen, Export/Import
        database.g.dart        generiert (build_runner)
        seed_foods.dart        100 Basis-Lebensmittel
        targets.dart           verbindet Profil + Gewichte mit dem Rechenkern
      ui/                      gemeinsame Widgets, Formatierung (de_DE)
      features/                Seiten: dashboard, diary, foods, weight, profile, settings
  test/                        Unit-, Datenbank- und Widget-Tests
```

## Prinzipien

- **Rechenkern getrennt:** Jede Zahl, die die App anzeigt, entsteht in `core/` und ist dort getestet.
  Die Oberfläche rechnet nicht selbst.
- **Offline-first:** Die lokale Datenbank ist die Quelle der Wahrheit. Die Oberfläche hört auf
  reaktive Abfragen (`watch…`) und aktualisiert sich nach jeder Änderung automatisch.
- **Integrität in der Datenbank:** Eindeutige Indizes (Lebensmittel-Schlüssel, Barcode, Gewicht pro Tag,
  Aktivität pro Quelle) statt nur Prüfungen in der Oberfläche; zusammenhängende Änderungen in Transaktionen.
- **Sync-fähig:** UUIDs, Zeitstempel in Millisekunden, Tombstones (siehe DATENMODELL.md).
- **Responsive:** Unter 840 px Breite Navigation unten, darüber Seitenleiste; Dashboard mit 2/3/4 Spalten.

## Erweiterung in späteren Phasen

- Phase 2: neue Tabellen (`recipes`, `recipe_items`, `meal_plans`, `supplements`, `supplement_nutrients`)
  mit Migration auf Schema 2; Supplement-Summen als neues Modul in `core/`.
- Phase 3: KI-Anbindung als eigener Dienst hinter einer Schnittstelle (`NutritionAi`), damit Anbieter
  austauschbar bleiben und Tests ohne Netz laufen.
- Phase 4: Sync-Dienst (Supabase/PostgreSQL) liest geänderte Zeilen anhand `updated_at`; Integrationen
  schreiben Aktivitäten mit `source` + `external_id`.
