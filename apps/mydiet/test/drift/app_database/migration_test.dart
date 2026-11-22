import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift_dev/api/migrations_native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/data/database.dart';

import 'generated/schema.dart';

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() => verifier = SchemaVerifier(GeneratedHelper()));

  // Every pair of versions: the migrated schema must equal the freshly created one.
  const versions = GeneratedHelper.versions;
  for (final (i, from) in versions.indexed) {
    for (final to in versions.skip(i + 1)) {
      test('Schema $from → $to entspricht einer neuen Datenbank', () async {
        final schema = await verifier.schemaAt(from);
        final db = AppDatabase(schema.newConnection());
        await verifier.migrateAndValidate(db, to);
        await db.close();
      });
    }
  }

  test('1 → 2 behält Tagebuch, Lebensmittel und Gewicht', () async {
    final schema = await verifier.schemaAt(1);
    const t = '2026-11-01T08:00:00.000';
    schema.rawDatabase.execute(
      "INSERT INTO foods (id, created_at, updated_at, name, food_key, unit, kcal, protein, carbs, fat, source) "
      "VALUES ('f1', '$t', '$t', 'Mein Müsli', 'mein musli', 'g', 380, 10, 60, 8, 'user')",
    );
    schema.rawDatabase.execute(
      'INSERT INTO diary_entries (id, created_at, updated_at, day_key, meal_slot_id, food_id, food_name, unit, '
      'amount, kcal100, protein100, carbs100, sugar100, fat100, saturated_fat100, fiber100, salt100) '
      "VALUES ('d1', '$t', '$t', '2026-11-01', 's1', 'f1', 'Mein Müsli', 'g', 60, 380, 10, 60, 5, 8, 1, 7, 0)",
    );
    schema.rawDatabase.execute(
      "INSERT INTO weight_entries (id, created_at, updated_at, day_key, weight_kg) VALUES ('w1', '$t', '$t', '2026-11-01', 92.4)",
    );
    final db = AppDatabase(schema.newConnection());
    final entries = await db.diaryForDay('2026-11-01');
    expect(entries.single.foodName, 'Mein Müsli');
    expect(entries.single.recipeId, isNull);
    expect(entries.single.nutrients.kcal, closeTo(228, 1e-9));
    expect((await db.getFood('f1'))!.name, 'Mein Müsli');
    expect((await db.allWeights()).single.weightKg, 92.4);
    expect(await db.watchRecipes().first, isEmpty);
    await db.close();
  });
}
