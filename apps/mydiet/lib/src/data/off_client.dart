import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../core/food_quality.dart';

class OffException implements Exception {
  OffException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Reads products from Open Food Facts (open data, ODbL). Only the barcode, or for a text search
/// only the search term, is sent – and only when the user asks for it.
class OffClient {
  OffClient({http.Client? client, this.baseUrl = 'https://world.openfoodfacts.org'})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  static const userAgent = 'MyDietAI/0.2 (Flutter app)';

  /// The product or null if Open Food Facts does not know it.
  Future<OffProduct?> fetch(String barcode) async {
    final code = barcode.replaceAll(RegExp(r'\s'), '');
    final uri = Uri.parse('$baseUrl/api/v2/product/$code.json?fields=$offFields');
    http.Response res;
    try {
      res = await _client.get(uri, headers: {'User-Agent': userAgent}).timeout(const Duration(seconds: 10));
    } on TimeoutException {
      throw OffException('Open Food Facts antwortet nicht. Bitte später erneut versuchen oder Werte selbst eingeben.');
    } catch (_) {
      throw OffException('Keine Verbindung zu Open Food Facts. Ohne Internet bitte Werte vom Etikett eingeben.');
    }
    if (res.statusCode == 404) return null;
    if (res.statusCode != 200) throw OffException('Open Food Facts meldet Fehler ${res.statusCode}.');
    try {
      final json = jsonDecode(utf8.decode(res.bodyBytes)) as Map<String, dynamic>;
      return parseOffProduct(json, code);
    } on FormatException {
      throw OffException('Antwort von Open Food Facts nicht lesbar.');
    }
  }

  /// Text search (only on the user's request). Returns products with usable nutrition values,
  /// in Open Food Facts' order; empty when nothing fits.
  Future<List<OffProduct>> search(String query, {int pageSize = 20}) async {
    final q = query.trim();
    if (q.isEmpty) return const [];
    final uri = Uri.parse('$baseUrl/cgi/search.pl').replace(
      queryParameters: {
        'search_terms': q,
        'search_simple': '1',
        'action': 'process',
        'json': '1',
        'page_size': '$pageSize',
        'fields': offFields,
      },
    );
    http.Response res;
    try {
      res = await _client.get(uri, headers: {'User-Agent': userAgent}).timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw OffException('Open Food Facts antwortet nicht. Bitte später erneut versuchen.');
    } catch (_) {
      throw OffException('Keine Verbindung zu Open Food Facts.');
    }
    if (res.statusCode != 200) throw OffException('Open Food Facts meldet Fehler ${res.statusCode}.');
    try {
      final json = jsonDecode(utf8.decode(res.bodyBytes));
      final products = json is Map ? json['products'] : null;
      if (products is! List) return const [];
      bool named(Map p) => [p['product_name_de'], p['product_name']].any((v) => v is String && v.trim().isNotEmpty);
      String code(Map p) {
        final c = (p['code'] ?? '').toString().trim();
        // Only real EAN/UPC codes are kept; others would block saving in the form.
        return RegExp(r'^\d{8,14}$').hasMatch(c) ? c : '';
      }

      return [
        for (final p in products)
          if (p is Map && named(p)) ?parseOffProduct({'status': 1, 'product': p}, code(p)),
      ];
    } on FormatException {
      throw OffException('Antwort von Open Food Facts nicht lesbar.');
    }
  }
}
