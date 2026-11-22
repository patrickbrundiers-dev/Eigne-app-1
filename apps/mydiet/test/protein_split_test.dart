import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/protein_split.dart';

void main() {
  test('Drei Hauptmahlzeiten und Snacks', () {
    final r = proteinPerMeal(150, [true, true, true, false]);
    expect(r[0], closeTo(42.86, 0.01));
    expect(r[3], closeTo(21.43, 0.01));
    expect(r.reduce((a, b) => a + b), closeTo(150, 1e-9));
  });

  test('Nur Hauptmahlzeiten: gleichmäßig', () {
    expect(proteinPerMeal(120, [true, true, true, true]), [30, 30, 30, 30]);
  });

  test('Ohne Ziel oder ohne Mahlzeiten nichts', () {
    expect(proteinPerMeal(0, [true, false]), [0, 0]);
    expect(proteinPerMeal(100, const []), isEmpty);
  });
}
