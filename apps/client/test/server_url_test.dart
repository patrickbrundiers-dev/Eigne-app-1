import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_ai/src/api/models.dart';
import 'package:paperless_ai/src/api/server_url.dart';

void main() {
  group('normalizeServerUrl', () {
    test('adds https and strips trailing slash, query and fragment', () {
      expect(normalizeServerUrl(' paperless.example.org/ ').toString(),
          'https://paperless.example.org');
      expect(
          normalizeServerUrl('https://x.example.org:8443/api/?a=1#f')
              .toString(),
          'https://x.example.org:8443/api');
    });

    test('allows http only for loopback and the Android emulator', () {
      expect(normalizeServerUrl('http://localhost:8000').port, 8000);
      expect(normalizeServerUrl('http://127.0.0.1:8000').host, '127.0.0.1');
      expect(normalizeServerUrl('http://10.0.2.2:8000').host, '10.0.2.2');
      expect(() => normalizeServerUrl('http://192.168.1.10:8000'),
          throwsA(isA<InvalidServerUrl>()));
      expect(() => normalizeServerUrl('http://paperless.example.org'),
          throwsA(isA<InvalidServerUrl>()));
    });

    test('rejects other schemes, empty input and credentials in the URL', () {
      for (final bad in [
        '',
        'ftp://x.org',
        'https://user:pw@x.org',
        'https://'
      ]) {
        expect(() => normalizeServerUrl(bad), throwsA(isA<InvalidServerUrl>()),
            reason: bad);
      }
    });
  });

  test('every backend error code has a German message', () {
    for (final code in [
      'unsupported_type',
      'too_large',
      'empty_file',
      'too_many_pages',
      'encrypted_pdf',
      'active_content',
      'malformed',
      'image_too_large',
      'duplicate',
    ]) {
      final msg = ApiException(422, code: code).userMessage;
      expect(msg, isNot(startsWith('Unerwarteter')), reason: code);
    }
    expect(const ApiException(403).userMessage, contains('Berechtigung'));
  });
}
