part of '../database.dart';

extension SupplementsDao on AppDatabase {
  // ---------------------------------------------------------------- supplements

  /// Products with their ingredients, ordered by name.
  Stream<List<SupplementWithDoses>> watchSupplements({bool activeOnly = false}) {
    final q = select(supplements)..where((s) => s.deletedAt.isNull());
    if (activeOnly) q.where((s) => s.active.equals(true));
    q.orderBy([(s) => OrderingTerm.asc(s.name.collate(Collate.noCase))]);
    return q.watch().asyncMap((rows) async {
      if (rows.isEmpty) return const <SupplementWithDoses>[];
      final ings =
          await (select(supplementIngredients)
                ..where((i) => i.supplementId.isIn(rows.map((r) => r.id)) & i.deletedAt.isNull())
                ..orderBy([(i) => OrderingTerm.asc(i.sortOrder)]))
              .get();
      return [
        for (final r in rows) SupplementWithDoses(r, [for (final i in ings.where((i) => i.supplementId == r.id)) i]),
      ];
    });
  }

  Future<Supplement?> getSupplement(String id) =>
      (select(supplements)..where((s) => s.id.equals(id))).getSingleOrNull();

  /// Creates or updates a product with all ingredients. Returns the id.
  Future<String> saveSupplement({
    String? id,
    required String name,
    String? brand,
    String? form,
    String servingLabel = 'Portion',
    String? manufacturerDose,
    double servingsPerDay = 1,
    List<int> times = const [],
    bool active = true,
    double? stockServings,
    String? note,
    required List<SupplementDose> doses,
  }) async {
    final n = name.trim();
    final b = (brand?.trim().isEmpty ?? true) ? null : brand!.trim();
    final errors = <String>[
      if (n.isEmpty) 'Bitte einen Namen eingeben.',
      if (!(servingsPerDay >= 0 && servingsPerDay <= 50)) 'Portionen pro Tag: 0 bis 50.',
      if (doses.any((d) => !(d.amount > 0 && d.amount < 1e7))) 'Jeder Inhaltsstoff braucht eine Menge größer 0.',
      if (times.any((t) => t < 0 || t >= 24 * 60)) 'Ungültige Uhrzeit.',
      if (stockServings != null && stockServings < 0) 'Der Vorrat kann nicht negativ sein.',
    ];
    final ids = [
      for (final d in doses) nutrientById(d.nutrientId)?.id ?? 'custom:${d.displayName.trim().toLowerCase()}',
    ];
    if (ids.toSet().length != ids.length) errors.add('Jeder Inhaltsstoff darf nur einmal vorkommen.');
    if (errors.isNotEmpty) throw InvalidFoodException(errors);
    final key = foodKey(n, b);
    return transaction(() async {
      final dup = await (select(
        supplements,
      )..where((s) => s.nameKey.equals(key) & s.deletedAt.isNull())).getSingleOrNull();
      if (dup != null && dup.id != id) {
        throw ArgumentError('„${dup.name}“${dup.brand != null ? ' (${dup.brand})' : ''} gibt es schon.');
      }
      final now = DateTime.now();
      final supId = id ?? newId();
      final sortedTimes = times.toSet().toList()..sort();
      final data = SupplementsCompanion(
        name: Value(n),
        brand: Value(b),
        nameKey: Value(key),
        form: Value(form?.trim().isEmpty ?? true ? null : form!.trim()),
        servingLabel: Value(servingLabel.trim().isEmpty ? 'Portion' : servingLabel.trim()),
        manufacturerDose: Value(manufacturerDose?.trim().isEmpty ?? true ? null : manufacturerDose!.trim()),
        servingsPerDay: Value(servingsPerDay),
        timesJson: Value(jsonEncode(sortedTimes)),
        active: Value(active),
        stockServings: Value(stockServings),
        note: Value(note?.trim().isEmpty ?? true ? null : note!.trim()),
        updatedAt: Value(now),
      );
      if (id == null) {
        await into(supplements).insert(data.copyWith(id: Value(supId), createdAt: Value(now)));
      } else {
        await (update(supplements)..where((s) => s.id.equals(id))).write(data);
        await (update(supplementIngredients)..where((i) => i.supplementId.equals(id) & i.deletedAt.isNull())).write(
          SupplementIngredientsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
      }
      for (var i = 0; i < doses.length; i++) {
        final d = doses[i];
        final custom = nutrientById(d.nutrientId) == null;
        await into(supplementIngredients).insert(
          SupplementIngredientsCompanion.insert(
            supplementId: supId,
            nutrientId: custom ? 'custom:${d.displayName.trim()}' : d.nutrientId,
            name: Value(custom ? d.displayName.trim() : null),
            amount: d.amount,
            unit: d.unit,
            sortOrder: i,
          ),
        );
      }
      return supId;
    });
  }

  Future<void> deleteSupplement(String id) async {
    final now = DateTime.now();
    await transaction(() async {
      await customUpdate(
        "UPDATE supplements SET deleted_at = ?, updated_at = ?, name_key = name_key || '#deleted:' || id "
        'WHERE id = ? AND deleted_at IS NULL',
        variables: [Variable(now), Variable(now), Variable(id)],
        updates: {supplements},
      );
      await (update(supplementIngredients)..where((i) => i.supplementId.equals(id) & i.deletedAt.isNull())).write(
        SupplementIngredientsCompanion(deletedAt: Value(now), updatedAt: Value(now)),
      );
    });
  }

  Stream<List<SupplementIntake>> watchIntakes(String day) =>
      (select(supplementIntakes)..where((i) => i.dayKey.equals(day) & i.deletedAt.isNull())).watch();

  /// Marks a planned intake as taken or not taken. The stock (if tracked) goes
  /// down or back up by the servings. Toggling twice never counts twice.
  Future<void> setIntake({
    required String supplementId,
    required String day,
    required int plannedMinute,
    required double servings,
    required bool taken,
  }) async {
    if (!(servings > 0 && servings <= 50)) throw ArgumentError('Ungültige Menge.');
    await transaction(() async {
      final now = DateTime.now();
      final existing =
          await (select(supplementIntakes)..where(
                (i) =>
                    i.supplementId.equals(supplementId) & i.dayKey.equals(day) & i.plannedMinute.equals(plannedMinute),
              ))
              .getSingleOrNull();
      final wasTaken = existing != null && existing.deletedAt == null;
      if (wasTaken == taken) return;
      double delta;
      if (taken) {
        if (existing == null) {
          await into(supplementIntakes).insert(
            SupplementIntakesCompanion.insert(
              supplementId: supplementId,
              dayKey: day,
              plannedMinute: plannedMinute,
              servings: servings,
            ),
          );
        } else {
          await (update(supplementIntakes)..where((i) => i.id.equals(existing.id))).write(
            SupplementIntakesCompanion(servings: Value(servings), deletedAt: const Value(null), updatedAt: Value(now)),
          );
        }
        delta = -servings;
      } else {
        await (update(supplementIntakes)..where((i) => i.id.equals(existing!.id))).write(
          SupplementIntakesCompanion(deletedAt: Value(now), updatedAt: Value(now)),
        );
        delta = existing!.servings;
      }
      await customUpdate(
        'UPDATE supplements SET stock_servings = MAX(0, stock_servings + ?), updated_at = ? '
        'WHERE id = ? AND stock_servings IS NOT NULL',
        variables: [Variable(delta), Variable(now), Variable(supplementId)],
        updates: {supplements},
      );
    });
  }
}
