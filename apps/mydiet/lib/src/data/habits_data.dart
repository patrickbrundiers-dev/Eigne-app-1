import 'dart:convert';

import 'package:drift/drift.dart';

import '../core/dates.dart';
import '../core/habits.dart';
import 'database.dart';

const habitsDismissedKey = 'habitsDismissed';

/// Food or recipe of an entry; quick entries (neither) are no habit material.
String? _itemKey(String? foodId, String? recipeId) => foodId ?? (recipeId == null ? null : 'recipe:$recipeId');

/// Habit suggestions for [slotId] (or all slots) from the last four weeks of the diary.
Future<List<HabitSuggestion>> habitSuggestions(AppDatabase db, {String? slotId, DateTime? now}) async {
  final today = now ?? DateTime.now();
  final from = today.subtract(const Duration(days: 28));
  final rows = await (db.select(
    db.diaryEntries,
  )..where((e) => e.deletedAt.isNull() & e.dayKey.isBiggerOrEqualValue(dayKey(from)))).get();
  final foods = <String, Set<String>>{};
  final names = <String, Map<String, String>>{};
  final meta = <String, (String, String)>{};
  for (final r in rows) {
    if (slotId != null && r.mealSlotId != slotId) continue;
    final k = _itemKey(r.foodId, r.recipeId);
    if (k == null) continue;
    final id = '${r.dayKey}|${r.mealSlotId}';
    meta[id] = (r.dayKey, r.mealSlotId);
    (foods[id] ??= {}).add(k);
    (names[id] ??= {})[k] = r.foodName;
  }
  final meals = [
    for (final e in meta.entries)
      LoggedMeal(day: parseDayKey(e.value.$1), slotId: e.value.$2, foods: foods[e.key]!, names: names[e.key]!),
  ];
  final templates = <String, List<Set<String>>>{};
  for (final t in await db.watchTemplates().first) {
    final s = t.mealSlotId;
    if (s == null) continue;
    final items = await db.templateItemsOf(t.id);
    (templates[s] ??= []).add({for (final i in items) ?_itemKey(i.foodId, i.recipeId)});
  }
  return findHabits(meals: meals, today: today, templates: templates, dismissed: await dismissedHabits(db));
}

Future<Set<String>> dismissedHabits(AppDatabase db) async {
  final raw = await db.getSetting(habitsDismissedKey);
  if (raw == null) return {};
  try {
    return {for (final e in jsonDecode(raw) as List) e as String};
  } catch (_) {
    return {};
  }
}

Future<void> dismissHabit(AppDatabase db, HabitSuggestion s) async {
  final all = {...await dismissedHabits(db), s.key};
  await db.setSetting(habitsDismissedKey, jsonEncode(all.toList()));
}

/// Saves the suggestion as a meal template, copied from the latest day with exactly this meal.
Future<String> saveHabitAsTemplate(AppDatabase db, HabitSuggestion s, {required String name}) =>
    db.saveTemplateFromMeal(name: name, day: dayKey(s.lastDay), mealSlotId: s.slotId);
