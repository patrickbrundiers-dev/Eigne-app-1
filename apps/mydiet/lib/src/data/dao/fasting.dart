part of '../database.dart';

extension FastingDao on AppDatabase {
  // ---------------------------------------------------------------- fasting

  Stream<List<FastingSession>> watchFasting({int limit = 30}) =>
      (select(fastingSessions)
            ..where((f) => f.deletedAt.isNull())
            ..orderBy([(f) => OrderingTerm.desc(f.startAt)])
            ..limit(limit))
          .watch();

  Future<FastingSession?> activeFast() =>
      (select(fastingSessions)
            ..where((f) => f.deletedAt.isNull() & f.endAt.isNull())
            ..orderBy([(f) => OrderingTerm.desc(f.startAt)])
            ..limit(1))
          .getSingleOrNull();

  /// Starts a fast. An already running fast is returned unchanged (never two at once).
  Future<String> startFast({required double targetHours, DateTime? at}) async {
    if (!(targetHours > 0 && targetHours <= 168)) throw ArgumentError('Fastendauer 1 bis 168 Stunden.');
    final start = at ?? DateTime.now();
    if (start.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
      throw ArgumentError('Der Beginn liegt in der Zukunft.');
    }
    return transaction(() async {
      final open = await activeFast();
      if (open != null) return open.id;
      final id = newId();
      await into(fastingSessions)
          .insert(FastingSessionsCompanion.insert(id: Value(id), startAt: start, targetHours: targetHours));
      return id;
    });
  }

  Future<void> endFast({DateTime? at}) async {
    final open = await activeFast();
    if (open == null) return;
    final end = at ?? DateTime.now();
    if (end.isBefore(open.startAt)) throw ArgumentError('Das Ende liegt vor dem Beginn.');
    await (update(fastingSessions)..where((f) => f.id.equals(open.id))).write(
      FastingSessionsCompanion(endAt: Value(end), updatedAt: Value(DateTime.now())),
    );
  }

  Future<void> deleteFast(String id) => _tombstone(fastingSessions, id);
}
