import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/week_budget.dart';

void main() {
  final monday = DateTime(2026, 3, 2);
  DateTime d(int i) => DateTime(monday.year, monday.month, monday.day + i);

  WeekBudget run(DateTime today, Map<DateTime, double> c, {int target = 2000, double floor = 1500}) =>
      weekBudget(today: today, dailyTargetKcal: target, consumedByDay: c, floorKcal: floor);

  test('Montag: Tagesziel unverändert', () {
    final w = run(monday, {});
    expect(w.daysLeft, 7);
    expect(w.todayTargetKcal, 2000);
    expect(w.weekKcal, 14000);
  });

  test('Mehr gegessen wird auf die restlichen Tage verteilt', () {
    // Mo 2000, Di 3000 -> Rest 9000 auf 5 Tage = 1800.
    final w = run(d(2), {d(0): 2000, d(1): 3000});
    expect(w.todayTargetKcal, 1800);
    expect(w.shiftKcal, -200);
  });

  test('Weniger gegessen gibt mehr, höchstens +20 %', () {
    final w = run(d(6), {for (var i = 0; i < 6; i++) d(i): 1500});
    // Rest 14000 - 9000 = 5000 -> begrenzt auf 2400.
    expect(w.todayTargetKcal, 2400);
    expect(w.isClamped, isTrue);
  });

  test('Tage ohne Einträge zählen als Tagesziel', () {
    final w = run(d(3), {d(0): 2000});
    expect(w.consumedBeforeToday, 6000);
    expect(w.todayTargetKcal, 2000);
  });

  test('Nie unter dem Mindestwert', () {
    final w = run(d(6), {for (var i = 0; i < 6; i++) d(i): 2600});
    // Rest 14000 - 15600 < 0 -> Mindestwert 1500.
    expect(w.todayTargetKcal, 1500);
  });

  test('Eigenes Ziel unter dem Mindestwert wird nicht angehoben', () {
    final w = run(monday, {}, target: 1300, floor: 1500);
    expect(w.todayTargetKcal, 1300);
  });

  test('Wochenbeginn ist Montag', () {
    expect(mondayOf(DateTime(2026, 3, 8)), monday); // Sonntag
  });
}
