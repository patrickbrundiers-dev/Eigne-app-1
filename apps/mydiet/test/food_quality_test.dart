import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mydiet_ai/src/core/food_quality.dart';
import 'package:mydiet_ai/src/core/nutrition.dart';
import 'package:mydiet_ai/src/data/database.dart';
import 'package:mydiet_ai/src/data/off_client.dart';

Map<String, dynamic> _off(Map<String, dynamic> nutriments, {Map<String, dynamic> extra = const {}}) => {
  'status': 1,
  'product': {'product_name': 'Haferdrink', 'brands': 'Marke A, Marke B', 'nutriments': nutriments, ...extra},
};

void main() {
  group('isValidGtin', () {
    test('accepts valid codes', () {
      expect(isValidGtin('4006381333931'), isTrue);
      expect(isValidGtin('96385074'), isTrue);
      expect(isValidGtin('036000291452'), isTrue);
      expect(isValidGtin(' 4006381 333931 '), isTrue);
    });
    test('rejects wrong check digit or length', () {
      expect(isValidGtin('4006381333932'), isFalse);
      expect(isValidGtin('12345'), isFalse);
      expect(isValidGtin('abcdefghijklm'), isFalse);
      expect(isValidGtin(''), isFalse);
    });
  });

  group('parseOffProduct', () {
    test('reads kcal, macros and brand', () {
      final p = parseOffProduct(
        _off(
          {
            'energy-kcal_100g': 370,
            'proteins_100g': 13.5,
            'carbohydrates_100g': 58.7,
            'sugars_100g': 0.7,
            'fat_100g': 7,
            'saturated-fat_100g': 1.3,
            'fiber_100g': 10,
            'salt_100g': 0.02,
          },
          extra: {'product_name_de': 'Haferflocken', 'serving_quantity': 40, 'serving_size': '40 g'},
        ),
        '4006381333931',
      )!;
      expect(p.name, 'Haferflocken');
      expect(p.brand, 'Marke A');
      expect(p.unit, 'g');
      expect(p.per100.kcal, 370);
      expect(p.per100.protein, 13.5);
      expect(p.servingAmount, 40);
      expect(p.servingLabel, '40 g');
      expect(p.missing, isEmpty);
      expect(p.quality, FoodQuality.complete);
    });

    test('converts kJ, sodium and detects ml', () {
      final p = parseOffProduct(
        _off(
          {
            'energy-kj_100ml': 188,
            'proteins_100ml': 0.3,
            'carbohydrates_100ml': 7,
            'sugars_100ml': 4,
            'fat_100ml': 1.5,
            'saturated-fat_100ml': 0.2,
            'fiber_100ml': 0.8,
            'sodium_100ml': 0.04,
          },
          extra: {'quantity': '1 l'},
        ),
        '96385074',
      )!;
      expect(p.unit, 'ml');
      expect(p.per100.kcal, closeTo(44.9, 0.1));
      expect(p.per100.salt, closeTo(0.1, 1e-9));
    });

    test('marks missing values as incomplete', () {
      final p = parseOffProduct(_off({'energy-kcal_100g': '250,5', 'fat_100g': 10}), '1')!;
      expect(p.per100.kcal, 250.5);
      expect(p.missing, containsAll(['Eiweiß', 'Kohlenhydrate', 'Salz']));
      expect(p.quality, FoodQuality.incomplete);
    });

    test('returns null for unknown products or no energy', () {
      expect(parseOffProduct({'status': 0}, '1'), isNull);
      expect(parseOffProduct(_off({'fat_100g': 3}), '1'), isNull);
    });
  });

  test('assessQuality by source and Atwater check', () {
    const ok = Nutrients(kcal: 100, protein: 10, carbs: 10, fat: 2.2);
    const off = Nutrients(kcal: 400, protein: 10, carbs: 10, fat: 2.2);
    expect(assessQuality(FoodSource.base, ok), FoodQuality.reference);
    expect(assessQuality(FoodSource.user, ok), FoodQuality.fromLabel);
    expect(assessQuality(FoodSource.ai, ok), FoodQuality.estimate);
    expect(assessQuality(FoodSource.off, ok), FoodQuality.complete);
    expect(assessQuality(FoodSource.off, off), FoodQuality.incomplete);
    expect(FoodSource.parse('off'), FoodSource.off);
    expect(FoodSource.parse('???'), FoodSource.user);
  });

  group('OffClient', () {
    test('sends only the barcode with a generic user agent', () async {
      late http.Request seen;
      final c = OffClient(
        client: MockClient((r) async {
          seen = r;
          return http.Response(jsonEncode(_off({'energy-kcal_100g': 50})), 200);
        }),
      );
      final p = await c.fetch('4006381333931');
      expect(p, isNotNull);
      expect(seen.url.path, '/api/v2/product/4006381333931.json');
      expect(seen.headers['User-Agent'], OffClient.userAgent);
    });

    test('404 means unknown', () async {
      final c = OffClient(client: MockClient((_) async => http.Response('{}', 404)));
      expect(await c.fetch('1'), isNull);
    });

    test('errors become German messages', () async {
      final down = OffClient(client: MockClient((_) async => http.Response('x', 503)));
      expect(down.fetch('1'), throwsA(isA<OffException>()));
      final offline = OffClient(client: MockClient((_) async => throw const SocketLikeException()));
      await expectLater(
        offline.fetch('1'),
        throwsA(isA<OffException>().having((e) => e.message, 'message', contains('Keine Verbindung'))),
      );
      final garbage = OffClient(client: MockClient((_) async => http.Response('not json', 200)));
      expect(garbage.fetch('1'), throwsA(isA<OffException>()));
    });
  });

  group('database source', () {
    late AppDatabase db;
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('saves OFF source and quality, rejects base', () async {
      final id = await db.saveFood(
        name: 'Testprodukt',
        barcode: '4006381333931',
        per100: const Nutrients(kcal: 100, protein: 10, carbs: 10, fat: 2.2),
        source: 'off',
      );
      final f = (await db.getFood(id))!;
      expect(f.sourceKind, FoodSource.off);
      expect(f.quality, FoodQuality.complete);
      expect(f.isUserFood, isTrue);
      expect((await db.findFoodByBarcode('4006381333931'))?.id, id);
      expect(() => db.saveFood(name: 'X', per100: const Nutrients(kcal: 1), source: 'base'), throwsA(anything));
    });
  });
}

class SocketLikeException implements Exception {
  const SocketLikeException();
}
