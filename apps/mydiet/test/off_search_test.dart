import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mydiet_ai/src/data/off_client.dart';

void main() {
  const body =
      '{"count":3,"products":['
      '{"code":"40011234","product_name":"Testmüsli","brands":"Marke, Andere","nutriments":{"energy-kcal_100g":380,'
      '"proteins_100g":10,"carbohydrates_100g":60,"sugars_100g":12,"fat_100g":10,"saturated-fat_100g":2,'
      '"fiber_100g":8,"salt_100g":0.1}},'
      '{"code":"222","product_name":"Ohne Energie","nutriments":{"proteins_100g":3}},'
      '{"code":"x-1","product_name":"Müsliriegel","nutriments":{"energy-kj_100g":1674}}'
      ',{"code":"444","nutriments":{"energy-kcal_100g":100}}'
      ']}';

  test('Textsuche sendet nur den Suchbegriff und liest brauchbare Produkte', () async {
    Uri? sent;
    Map<String, String>? headers;
    final c = OffClient(
      client: MockClient((req) async {
        sent = req.url;
        headers = req.headers;
        return http.Response(body, 200, headers: {'content-type': 'application/json; charset=utf-8'});
      }),
    );
    final r = await c.search('  Müsli  ');
    expect(sent!.path, '/cgi/search.pl');
    expect(sent!.queryParameters['search_terms'], 'Müsli');
    expect(sent!.queryParameters.keys.toSet(), {
      'search_terms',
      'search_simple',
      'action',
      'json',
      'page_size',
      'fields',
    });
    expect(headers!['User-Agent'], OffClient.userAgent);
    expect(r.map((p) => p.name), ['Testmüsli', 'Müsliriegel']);
    expect(r.first.barcode, '40011234');
    expect(r.last.barcode, '', reason: 'kein gültiger Barcode');
    expect(r.first.brand, 'Marke');
    expect(r.last.per100.kcal, closeTo(400, 0.5)); // 1674 kJ ÷ 4,184
    expect(r.last.missing, isNotEmpty);
  });

  test('Leerer Begriff sendet nichts', () async {
    var calls = 0;
    final c = OffClient(
      client: MockClient((_) async {
        calls++;
        return http.Response('', 200);
      }),
    );
    expect(await c.search('   '), isEmpty);
    expect(calls, 0);
  });

  test('Fehler werden verständlich gemeldet', () async {
    final c = OffClient(client: MockClient((_) async => http.Response('nope', 503)));
    expect(() => c.search('x'), throwsA(isA<OffException>()));
    final bad = OffClient(client: MockClient((_) async => http.Response('kein json', 200)));
    expect(() => bad.search('x'), throwsA(isA<OffException>()));
  });
}
