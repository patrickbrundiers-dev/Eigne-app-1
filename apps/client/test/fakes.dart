import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:paperless_ai/src/api/api_client.dart';
import 'package:paperless_ai/src/app_state.dart';
import 'package:paperless_ai/src/auth/token_store.dart';
import 'package:paperless_ai/src/import/document_picker.dart';

const pdfBytes = [0x25, 0x50, 0x44, 0x46, 0x2d, 0x31, 0x2e, 0x37]; // %PDF-1.7

/// In-memory fake of the backend, enough for the client flows.
class FakeBackend {
  final requests = <http.BaseRequest>[];
  final uploads = <String>[]; // filenames
  String password = 'correct horse battery';
  bool rejectNextUploadWith401 = false;
  String? nextUploadErrorCode;
  List<Map<String, dynamic>> spaces = [
    {
      'id': 's1',
      'family_id': 'f1',
      'name': 'Haushalt',
      'type': 'shared',
      'permissions': ['read', 'write', 'delete_document'],
    },
  ];
  final docs = <Map<String, dynamic>>[];

  late final MockClient client = MockClient.streaming((request, body) async {
    requests.add(request);
    final path = request.url.path;
    final auth = request.headers['authorization'];
    http.StreamedResponse json(int status, Object data) =>
        http.StreamedResponse(
          Stream.value(utf8.encode(jsonEncode(data))),
          status,
          headers: {'content-type': 'application/json'},
        );

    if (path.endsWith('/auth/login')) {
      final payload = jsonDecode(await body.bytesToString()) as Map;
      if (payload['password'] != password) {
        return json(401, {'detail': 'invalid credentials'});
      }
      return json(200, {
        'access_token': 'pai_test',
        'session_id': 'x',
        'expires_at': '2027-01-01T00:00:00Z'
      });
    }
    if (auth != 'Bearer pai_test') {
      return json(401, {'detail': 'authentication required'});
    }
    if (path.endsWith('/auth/me')) {
      return json(200, {
        'id': 'u1',
        'email': 'anna@example.test',
        'display_name': 'Anna',
        'families': []
      });
    }
    if (path.endsWith('/auth/logout')) {
      return http.StreamedResponse(const Stream.empty(), 204);
    }
    if (path.endsWith('/spaces')) {
      return json(200, spaces);
    }
    if (path.endsWith('/documents') && request.method == 'GET') {
      return json(200, docs);
    }
    if (path.endsWith('/documents') && request.method == 'POST') {
      await body.drain<void>();
      if (nextUploadErrorCode != null) {
        final code = nextUploadErrorCode!;
        nextUploadErrorCode = null;
        return json(code == 'duplicate' ? 409 : 422, {
          'detail': {'code': code, 'message': 'x'}
        });
      }
      final filename = RegExp(r'filename="([^"]+)"')
              .firstMatch(
                  (request as http.MultipartRequest).files.first.filename ?? '')
              ?.group(1) ??
          request.files.first.filename!;
      uploads.add(filename);
      final doc = {
        'id': 'd${docs.length + 1}',
        'space_id': 's1',
        'title': filename.replaceAll('.pdf', ''),
        'revision': 1,
        'created_at': '2026-11-14T08:00:00Z',
        'updated_at': '2026-11-14T08:00:00Z',
        'mime_type': 'application/pdf',
        'size_bytes': 8,
        'page_count': 1,
        'original_filename': filename,
        'version_no': 1,
      };
      docs.insert(0, doc);
      return json(201, doc);
    }
    return json(404, {'detail': 'not found'});
  });

  AppState state({TokenStore? store, DocumentPicker? picker}) => AppState(
        tokenStore: store ?? MemoryTokenStore(),
        clientFactory: (base, token) =>
            ApiClient(baseUrl: base, token: token, httpClient: client),
        picker: picker ?? FakePicker(),
      );
}

class FakePicker implements DocumentPicker {
  FakePicker({this.name = 'Rechnung.pdf'});
  String? name;

  @override
  Future<PickedDocument?> pick() async => name == null
      ? null
      : PickedDocument(
          name: name!,
          length: pdfBytes.length,
          open: () => Stream.value(pdfBytes),
        );
}
