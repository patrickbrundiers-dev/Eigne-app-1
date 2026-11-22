import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/meal_time.dart';

void main() {
  test('Mahlzeit passend zur Uhrzeit', () {
    const m = [7 * 60, 12 * 60 + 30, 15 * 60, 19 * 60];
    expect(currentMealIndex(m, 6 * 60), 0, reason: 'vor der ersten Mahlzeit');
    expect(currentMealIndex(m, 9 * 60), 0);
    expect(currentMealIndex(m, 11 * 60 + 50), 1, reason: '40 Minuten vorher zählt schon');
    expect(currentMealIndex(m, 16 * 60), 2);
    expect(currentMealIndex(m, 23 * 60), 3);
  });

  test('Ohne Uhrzeiten, leer, ungeordnet', () {
    expect(currentMealIndex([], 600), -1);
    expect(currentMealIndex([null, null], 600), 0);
    expect(currentMealIndex([null, 18 * 60, 8 * 60], 7 * 60), 2);
    expect(currentMealIndex([null, 18 * 60, 8 * 60], 12 * 60), 2);
    expect(currentMealIndex([null, 18 * 60, 8 * 60], 20 * 60), 1);
  });
}
