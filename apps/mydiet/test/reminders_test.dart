import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/reminders.dart';

void main() {
  test('settings round-trip and fall back on bad values', () {
    const s = ReminderSettings(meals: true, mealLeadMinutes: 15, water: true, weigh: true, weighDays: {1, 4});
    final back = ReminderSettings.parse(s.toJson());
    expect(back.meals, isTrue);
    expect(back.mealLeadMinutes, 15);
    expect(back.weighDays, {1, 4});
    final bad = ReminderSettings.parse('{"mealLead":999,"waterEvery":5,"weighDays":[0,9],"meals":"ja"}');
    expect(bad.mealLeadMinutes, 0);
    expect(bad.waterEveryMinutes, 120);
    expect(bad.weighDays.length, 7);
    expect(bad.meals, isFalse);
    expect(ReminderSettings.parse('kaputt').any, isFalse);
    expect(ReminderSettings.parse(null).any, isFalse);
  });

  test('nothing is planned when everything is off', () {
    expect(planReminders(const ReminderSettings(), mealSlots: [(name: 'Frühstück', minute: 480)]), isEmpty);
  });

  test('meals: only slots with a time, lead time wraps over midnight', () {
    final r = planReminders(
      const ReminderSettings(meals: true, mealLeadMinutes: 30),
      mealSlots: [(name: 'Frühstück', minute: 15), (name: 'Snack', minute: null), (name: 'Abendessen', minute: 1110)],
    );
    expect(r.map((e) => e.minute), [1425, 1080]);
    expect(r.first.body, contains('In 30 Minuten: Frühstück (00:15)'));
    expect(r.map((e) => e.id).toSet().length, 2);
  });

  test('water from start to end in steps, invalid range gives none', () {
    final r = planReminders(
      const ReminderSettings(water: true, waterStart: 540, waterEnd: 1200, waterEveryMinutes: 120),
    );
    expect(r.map((e) => e.minute), [540, 660, 780, 900, 1020, 1140]);
    expect(planReminders(const ReminderSettings(water: true, waterStart: 1200, waterEnd: 600)), isEmpty);
  });

  test('supplements at the same time are combined', () {
    final r = planReminders(
      const ReminderSettings(supplements: true),
      supplementSlots: [
        (name: 'Vitamin D3', minute: 480),
        (name: 'Omega 3', minute: 480),
        (name: 'Magnesium', minute: 1260),
      ],
    );
    expect(r, hasLength(2));
    expect(r.first.title, 'Supplemente 08:00');
    expect(r.first.body, 'Omega 3, Vitamin D3');
    expect(r.last.minute, 1260);
  });

  test('weighing daily or on chosen weekdays', () {
    expect(planReminders(const ReminderSettings(weigh: true)).single.weekday, isNull);
    final r = planReminders(const ReminderSettings(weigh: true, weighDays: {1, 4}));
    expect(r.map((e) => e.weekday), [1, 4]);
  });

  test('nextFire: later today, tomorrow, or next matching weekday', () {
    final now = DateTime(2026, 11, 22, 12, 0); // Sunday
    const daily = PlannedReminder(id: 1, kind: ReminderKind.water, title: '', body: '', minute: 13 * 60);
    expect(nextFire(daily, now), DateTime(2026, 11, 22, 13));
    const morning = PlannedReminder(id: 1, kind: ReminderKind.water, title: '', body: '', minute: 7 * 60);
    expect(nextFire(morning, now), DateTime(2026, 11, 23, 7));
    const thursday = PlannedReminder(id: 1, kind: ReminderKind.weigh, title: '', body: '', minute: 7 * 60, weekday: 4);
    expect(nextFire(thursday, now), DateTime(2026, 11, 26, 7));
  });
}
