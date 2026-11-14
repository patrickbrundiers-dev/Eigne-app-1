import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'models.dart';

/// Thin client for the Paperless AI backend. One instance per server + token.
class ApiClient {
  ApiClient({required this.baseUrl, this.token, http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  final Uri baseUrl;
  final String? token;
  final http.Client _http;

  static const _timeout = Duration(seconds: 30);
  static const _uploadTimeout = Duration(minutes: 5);

  ApiClient withToken(String? newToken) =>
      ApiClient(baseUrl: baseUrl, token: newToken, httpClient: _http);

  Uri _u(String path) => baseUrl.replace(path: '${baseUrl.path}/api/v1$path');

  Map<String, String> get _headers => {
        'accept': 'application/json',
        if (token != null) 'authorization': 'Bearer $token',
      };

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    final http.Response response;
    try {
      response = await call().timeout(_timeout);
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ConnectionFailed();
    }
    if (response.statusCode >= 400) throw _error(response);
    return response;
  }

  ApiException _error(http.Response r) {
    String? code;
    String? message;
    try {
      final detail = (jsonDecode(r.body) as Map<String, dynamic>)['detail'];
      if (detail is Map) {
        code = detail['code'] as String?;
        message = detail['message'] as String?;
      } else if (detail is String) {
        message = detail;
      }
    } catch (_) {}
    return ApiException(r.statusCode, code: code, message: message);
  }

  dynamic _json(http.Response r) => jsonDecode(utf8.decode(r.bodyBytes));

  /// Returns the new bearer token.
  Future<String> login(String email, String password, String deviceName) async {
    final r = await _send(() => _http.post(
          _u('/auth/login'),
          headers: {..._headers, 'content-type': 'application/json'},
          body: jsonEncode({
            'email': email,
            'password': password,
            'device_name': deviceName
          }),
        ));
    return (_json(r) as Map<String, dynamic>)['access_token'] as String;
  }

  Future<void> logout() async {
    await _send(() => _http.post(_u('/auth/logout'), headers: _headers));
  }

  Future<UserInfo> me() async {
    final r = await _send(() => _http.get(_u('/auth/me'), headers: _headers));
    return UserInfo.fromJson(_json(r) as Map<String, dynamic>);
  }

  Future<List<SpaceInfo>> spaces() async {
    final r = await _send(() => _http.get(_u('/spaces'), headers: _headers));
    return [
      for (final s in _json(r) as List)
        SpaceInfo.fromJson(s as Map<String, dynamic>)
    ];
  }

  Future<List<DocumentInfo>> documents(String spaceId) async {
    final r = await _send(
        () => _http.get(_u('/spaces/$spaceId/documents'), headers: _headers));
    return [
      for (final d in _json(r) as List)
        DocumentInfo.fromJson(d as Map<String, dynamic>)
    ];
  }

  /// One page of the change feed. Pass the cursor of the previous page or sync.
  Future<SyncPage> sync({String? cursor, int limit = 200}) async {
    final uri = _u('/sync').replace(queryParameters: {
      if (cursor != null) 'cursor': cursor,
      'limit': '$limit',
    });
    final r = await _send(() => _http.get(uri, headers: _headers));
    return SyncPage.fromJson(_json(r) as Map<String, dynamic>);
  }

  Future<DocumentInfo> upload({
    required String spaceId,
    required String filename,
    required int length,
    required Stream<List<int>> content,
    String? title,
  }) async {
    final request = http.MultipartRequest(
        'POST', _u('/spaces/$spaceId/documents'))
      ..headers.addAll(_headers)
      ..files
          .add(http.MultipartFile('file', content, length, filename: filename));
    if (title != null && title.isNotEmpty) request.fields['title'] = title;
    final http.Response response;
    try {
      response = await http.Response.fromStream(
          await _http.send(request).timeout(_uploadTimeout));
    } catch (_) {
      throw const ConnectionFailed();
    }
    if (response.statusCode >= 400) throw _error(response);
    return DocumentInfo.fromJson(_json(response) as Map<String, dynamic>);
  }

  Future<Uint8List> preview(String documentId) async {
    final r = await _send(() => _http.get(_u('/documents/$documentId/preview'),
        headers: {..._headers, 'accept': 'image/png'}));
    return r.bodyBytes;
  }
}
