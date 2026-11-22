# Datenmodell (Schema-Version 4)

Lokale SQLite-Datenbank über drift. Definition: `apps/mydiet/lib/src/data/tables.dart`.

## Gemeinsame Sync-Spalten

Alle Tabellen außer `settings` haben:

| Spalte | Typ | Zweck |
|---|---|---|
| `id` | TEXT (UUID v4) | global eindeutig, auch über Geräte hinweg |
| `created_at` | ISO-8601 mit Millisekunden | Reihenfolge, Herkunft |
| `updated_at` | ISO-8601 mit Millisekunden | Sync: „letzte Änderung gewinnt“ |
| `deleted_at` | ISO-8601 oder NULL | Tombstone: gelöschte Zeilen bleiben für den Sync erhalten |

Tage werden als Text `yyyy-MM-dd` (lokales Datum) gespeichert, damit sich ein Eintrag nie durch
Zeitzonen oder Sommerzeit auf einen anderen Tag verschiebt.

## Tabellen

**profiles** – eine Zeile (`id = 'me'`). Stammdaten, Ziel, Aktivität, Ernährung (Listen als JSON),
manuelle Ziele (`calorie_override`, `protein_override_g`, `water_override_ml`), Einstellungen der
Makro-Berechnung (`protein_per_kg`, `fat_percent`, `fiber_target_g`) und `activity_credit_percent`.

**meal_slots** – 1 bis 6 Mahlzeiten mit Name, optionaler Uhrzeit, Reihenfolge. Entfernte Mahlzeiten
werden nur markiert; ihre Einträge bleiben sichtbar.

**foods** – Nährwerte pro 100 g oder 100 ml (`unit`): kcal, Eiweiß, Kohlenhydrate, Zucker, Fett,
gesättigte Fettsäuren, Ballaststoffe, Salz; Portionsgröße; `source` = `base` (Richtwert) oder `user`.
- `food_key` = normalisierter Name + Marke, **eindeutig** → keine doppelten Lebensmittel
- `barcode` **eindeutig**
- Beim Löschen werden Schlüssel und Barcode freigegeben, die Zeile bleibt als Tombstone.

**diary_entries** – ein gegessenes Lebensmittel: Tag, Mahlzeit, Menge, `food_id` und eine **Kopie**
von Name und Nährwerten pro 100. Spätere Änderungen an einem Lebensmittel verändern vergangene Tage nicht.

**weight_entries** – Gewicht, optional Körperfett, Bauchumfang, Notiz; `day_key` **eindeutig**
(ein Wert pro Tag, ein neuer Wert ersetzt den alten).

**water_entries** – Wassermengen je Tag (Summe = Tageswert, letzter Eintrag rücknehmbar).

**activity_entries** – Bezeichnung, Minuten, kcal, Schritte, `source` + `external_id`
(**eindeutig** pro Quelle) → eine importierte Aktivität kann nie doppelt gezählt werden.

**recipes** (ab Schema 2) – Name (`name_key` normalisiert, **eindeutig**), Portionen, optional Gewicht nach
dem Kochen, Zubereitungszeit, Zubereitung, Stichworte (JSON), Favorit.

**recipe_items** (ab Schema 2) – Zutaten eines Rezepts mit Menge und einer **Kopie** der Nährwerte pro 100.
Ein später geändertes oder gelöschtes Lebensmittel verändert das Rezept nicht. Beim Bearbeiten werden die
alten Zeilen als gelöscht markiert und neu geschrieben.

**shopping_items** (ab Schema 2) – Einkaufsliste. `item_key` (Lebensmittel-ID oder normalisierter Name) +
Einheit: Eine offene Zeile wird beim erneuten Hinzufügen erweitert statt verdoppelt.

`diary_entries.recipe_id` (ab Schema 2) markiert Einträge aus einem Rezept; die Werte pro 100 g des fertigen
Gerichts werden wie bei Lebensmitteln kopiert.

**supplements** (ab Schema 3) – Produkt, Marke (`name_key` **eindeutig**), Form, was eine Portion ist,
Verzehrempfehlung des Herstellers (Freitext), eigene Portionen pro Tag, Uhrzeiten (JSON), aktiv/pausiert, Vorrat.

**supplement_ingredients** (ab Schema 3) – Inhaltsstoffe pro Portion: Katalog-ID (`core/supplements.dart`)
oder `custom:Name`, Menge, Einheit (µg/mg/g).

**supplement_intakes** (ab Schema 3) – eingenommene Portionen; **eindeutig** pro Produkt, Tag und geplanter
Uhrzeit (−1 = ohne Uhrzeit). Zweimal Abhaken zählt einmal; Abhaken/Rücknehmen verändert den Vorrat.

**meal_plan_entries** (ab Schema 4) – geplante Lebensmittel/Rezepte je Tag und Mahlzeit mit Kopie der Werte
pro 100; `diary_entry_id` merkt, welcher Tagebucheintrag daraus entstand (verhindert doppeltes Übernehmen).

**fasting_sessions** (ab Schema 4) – Fastenzeiten mit Beginn, Ende (offen = läuft) und Zieldauer. Es läuft
nie mehr als eine gleichzeitig.

`profiles.carb_cap_g` (ab Schema 4) – optionale Obergrenze für Kohlenhydrate.

**settings** – Schlüssel/Wert: `themeMode`, `colorScheme`, `dashboardLayout` (JSON), `seedVersion`.

## Basis-Lebensmittel

`lib/src/data/seed_foods.dart`: 100 Lebensmittel, gerundete Richtwerte (BLS/USDA, EU-Konvention:
Kohlenhydrate ohne Ballaststoffe). Ein Test prüft jedes auf Plausibilität und Duplikate. Neue
Versionen werden über `seedVersion` ergänzt, ohne eigene Lebensmittel anzufassen.

## Export-Format

JSON mit `format: "mydiet-export"`, `version`, `schema` und je Tabelle allen Zeilen inklusive
Tombstones. Import ersetzt alle Daten in einer Transaktion; bei einem Fehler bleibt alles unverändert.

## Migrationen

`schemaVersion` in `database.dart`. Jede Änderung bekommt einen Migrationsschritt in
`MigrationStrategy.onUpgrade` (`stepByStep` aus `database.steps.dart`: jeder Schritt arbeitet mit dem
Schema seiner Zielversion, eine alte Datenbank wird Version für Version aktualisiert). Der Stand jeder Version liegt in `drift_schemas/` (erzeugt mit
`dart run drift_dev make-migrations`); `test/drift/` prüft jede Migration gegen eine neu angelegte
Datenbank und dass vorhandene Daten erhalten bleiben.

| Version | Änderung |
|---|---|
| 1 | Grundsystem (Phase 1) |
| 2 | `recipes`, `recipe_items`, `shopping_items`, `diary_entries.recipe_id` |
| 3 | `supplements`, `supplement_ingredients`, `supplement_intakes` |
| 4 | `meal_plan_entries`, `fasting_sessions`, `profiles.carb_cap_g` |
