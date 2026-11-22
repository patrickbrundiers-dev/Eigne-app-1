import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../core/app_update.dart';

class UpdateException implements Exception {
  UpdateException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Asks GitHub Releases for new versions. Only a plain HTTPS request without any
/// personal data; the repository is public.
class UpdateClient {
  UpdateClient({http.Client? client, this.repo = 'patrickbrundiers-dev/Eigne-app-1'})
    : _client = client ?? http.Client();

  final http.Client _client;
  final String repo;

  static const userAgent = 'MyDietAI-Updater (Flutter app)';

  Future<UpdateInfo?> fetchLatest() async {
    final uri = Uri.https('api.github.com', '/repos/$repo/releases', {'per_page': '20'});
    http.Response res;
    try {
      res = await _client
          .get(uri, headers: {'User-Agent': userAgent, 'Accept': 'application/vnd.github+json'})
          .timeout(const Duration(seconds: 15));
    } on TimeoutException {
      throw UpdateException('GitHub antwortet nicht. Bitte später erneut versuchen.');
    } catch (_) {
      throw UpdateException('Keine Internetverbindung für die Update-Prüfung.');
    }
    if (res.statusCode == 403 || res.statusCode == 429) {
      throw UpdateException('Zu viele Anfragen an GitHub. Bitte in einer Stunde erneut versuchen.');
    }
    if (res.statusCode != 200) throw UpdateException('GitHub meldet Fehler ${res.statusCode}.');
    try {
      final json = jsonDecode(utf8.decode(res.bodyBytes));
      if (json is! List) throw const FormatException();
      return latestRelease(json);
    } on FormatException {
      throw UpdateException('Antwort von GitHub nicht lesbar.');
    }
  }

  /// Downloads [asset] into [target] and checks size and SHA-256 (when GitHub provides it).
  /// Reports progress from 0 to 1.
  Future<File> download(UpdateAsset asset, File target, {void Function(double)? onProgress}) async {
    final req = http.Request('GET', asset.url)..headers['User-Agent'] = userAgent;
    http.StreamedResponse res;
    try {
      res = await _client.send(req).timeout(const Duration(seconds: 30));
    } catch (_) {
      throw UpdateException('Download konnte nicht gestartet werden.');
    }
    if (res.statusCode != 200) throw UpdateException('Download fehlgeschlagen (${res.statusCode}).');
    final total = res.contentLength ?? asset.size;
    final sink = target.openWrite();
    final digestOut = _DigestSink();
    final hasher = sha256.startChunkedConversion(digestOut);
    var received = 0;
    try {
      await for (final chunk in res.stream.timeout(const Duration(seconds: 60))) {
        sink.add(chunk);
        hasher.add(chunk);
        received += chunk.length;
        if (total > 0) onProgress?.call((received / total).clamp(0, 1).toDouble());
      }
    } catch (_) {
      await sink.close();
      if (await target.exists()) await target.delete();
      throw UpdateException('Download abgebrochen. Bitte erneut versuchen.');
    }
    await sink.close();
    hasher.close();
    final bad =
        (asset.size > 0 && received != asset.size) ||
        (asset.sha256 != null && digestOut.value.toString() != asset.sha256);
    if (bad) {
      if (await target.exists()) await target.delete();
      throw UpdateException('Die heruntergeladene Datei ist beschädigt und wurde gelöscht.');
    }
    return target;
  }
}

class _DigestSink implements Sink<Digest> {
  late Digest value;
  @override
  void add(Digest data) => value = data;
  @override
  void close() {}
}
