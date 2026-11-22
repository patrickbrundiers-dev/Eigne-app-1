import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/online_search.dart';

void main() {
  group('Wann online gesucht wird', () {
    test('Nur ab drei Zeichen und wenn die eigene Datenbank kaum etwas findet', () {
      expect(shouldSearchOnline(query: 'Sk', localHits: 0), isFalse);
      expect(shouldSearchOnline(query: 'Sky', localHits: 0), isTrue);
      expect(shouldSearchOnline(query: 'Skyr Vanille', localHits: 2), isTrue);
      expect(shouldSearchOnline(query: 'Skyr', localHits: liveSearchLocalBelow), isFalse);
      expect(shouldSearchOnline(query: '   ', localHits: 0), isFalse);
    });

    test('Abgeschaltet: nie', () {
      expect(shouldSearchOnline(query: 'Skyr Vanille', localHits: 0, enabled: false), isFalse);
    });

    test('Barcodes und ganze Mahlzeiten gehen nicht an die Textsuche', () {
      expect(shouldSearchOnline(query: '4006381333931', localHits: 0), isFalse);
      expect(shouldSearchOnline(query: '200 g Reis', localHits: 0), isFalse);
      expect(shouldSearchOnline(query: 'Reis, Hähnchen', localHits: 0), isFalse);
      expect(shouldSearchOnline(query: 'Müsli + Milch', localHits: 0), isFalse);
      // Zahlen im Produktnamen sind erlaubt.
      expect(shouldSearchOnline(query: 'Protein Pudding 200', localHits: 0), isTrue);
    });

    test('Gleicher Suchbegriff, gleicher Schlüssel', () {
      expect(liveSearchKey(' Müsli '), liveSearchKey('muesli'));
      expect(liveSearchKey('Skyr VANILLE'), liveSearchKey('skyr vanille'));
    });
  });

  group('Online-Treffer ohne Bekanntes', () {
    test('Barcode oder Name schon in der eigenen Datenbank, doppelte Treffer', () {
      final online = [
        ('111', 'skyr'),
        ('222', 'skyr vanille'),
        ('333', 'joghurt'),
        ('333', 'joghurt'),
        ('', 'quark'),
        ('', 'quark'),
      ];
      final r = withoutKnown(
        online,
        barcode: (p) => p.$1,
        nameKey: (p) => p.$2,
        localBarcodes: {'111'},
        localNameKeys: {'skyr vanille'},
      );
      expect(r, [('333', 'joghurt'), ('', 'quark')]);
    });
  });

  group('Zwischenspeicher', () {
    test('Hält die zuletzt genutzten Einträge', () {
      final c = RecentCache<int>(capacity: 2);
      c['a'] = 1;
      c['b'] = 2;
      expect(c['a'], 1); // a ist jetzt zuletzt genutzt
      c['c'] = 3;
      expect(c['b'], isNull);
      expect(c['a'], 1);
      expect(c['c'], 3);
      expect(c.length, 2);
    });
  });
}
