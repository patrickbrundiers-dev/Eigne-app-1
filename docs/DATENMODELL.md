# Datenmodell (Schema-Version 1)

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
`MigrationStrategy.onUpgrade` und einen Test mit einer Datenbank der Vorversion.
