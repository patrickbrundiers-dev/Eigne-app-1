import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the server address and device token are kept between app starts.
abstract class TokenStore {
  Future<({String? server, String? token})> load();
  Future<void> save({required String server, required String token});
  Future<void> clear();
}

/// Android Keystore / Windows Credential Manager (DPAPI) via flutter_secure_storage.
class SecureTokenStore implements TokenStore {
  SecureTokenStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _serverKey = 'paperless.server';
  static const _tokenKey = 'paperless.token';

  @override
  Future<({String? server, String? token})> load() async => (
        server: await _storage.read(key: _serverKey),
        token: await _storage.read(key: _tokenKey),
      );

  @override
  Future<void> save({required String server, required String token}) async {
    await _storage.write(key: _serverKey, value: server);
    await _storage.write(key: _tokenKey, value: token);
  }

  @override
  Future<void> clear() => _storage.delete(key: _tokenKey);
}

class MemoryTokenStore implements TokenStore {
  String? server;
  String? token;

  @override
  Future<({String? server, String? token})> load() async =>
      (server: server, token: token);

  @override
  Future<void> save({required String server, required String token}) async {
    this.server = server;
    this.token = token;
  }

  @override
  Future<void> clear() async => token = null;
}
