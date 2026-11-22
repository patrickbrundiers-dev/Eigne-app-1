import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mydiet_ai/src/core/app_update.dart';
import 'package:mydiet_ai/src/data/update_client.dart';

Map<String, dynamic> _rel(String tag, {bool draft = false, bool pre = false, List<Map<String, dynamic>>? assets}) => {
  'tag_name': tag,
  'draft': draft,
  'prerelease': pre,
  'body': 'Notizen $tag',
  'html_url': 'https://github.com/x/y/releases/tag/$tag',
  'published_at': '2026-11-22T11:05:13Z',
  'assets':
      assets ??
      [
        {'name': 'MyDietAI-Android-x.apk', 'browser_download_url': 'https://h/a.apk', 'size': 3},
        {'name': 'MyDietAI-Setup-x.exe', 'browser_download_url': 'https://h/s.exe', 'size': 3},
        {'name': 'MyDietAI-Windows-x.zip', 'browser_download_url': 'https://h/w.zip', 'size': 3},
      ],
};

void main() {
  test('AppVersion parses and compares', () {
    expect(AppVersion.tryParse('0.2.0+5'), const AppVersion(0, 2, 0));
    expect(AppVersion.tryParse('mydiet-v1.10'), const AppVersion(1, 10, 0));
    expect(AppVersion.tryParse('abc'), isNull);
    expect(const AppVersion(0, 10, 0) > const AppVersion(0, 9, 9), isTrue);
    expect(const AppVersion(1, 0, 0) > const AppVersion(1, 0, 0), isFalse);
  });

  test('latestRelease picks the newest app release and skips others', () {
    final r = latestRelease([
      _rel('v0.8.0'),
      _rel('mydiet-v0.1.0'),
      _rel('mydiet-v0.3.0', draft: true),
      _rel('mydiet-v0.4.0', pre: true),
      _rel('mydiet-v0.2.1'),
      'kaputt',
    ])!;
    expect(r.version, const AppVersion(0, 2, 1));
    expect(r.notes, 'Notizen mydiet-v0.2.1');
    expect(r.assetFor(UpdatePlatform.android)!.url.toString(), 'https://h/a.apk');
    expect(r.assetFor(UpdatePlatform.windows)!.name, 'MyDietAI-Setup-x.exe');
    expect(r.assetFor(UpdatePlatform.other), isNull);
    expect(latestRelease([_rel('v0.8.0')]), isNull);
  });

  test('only https assets, digest is read', () {
    final r = latestRelease([
      _rel(
        'mydiet-v1.0.0',
        assets: [
          {'name': 'a.apk', 'browser_download_url': 'http://h/a.apk', 'size': 1},
          {'name': 'MyDietAI-Setup.exe', 'browser_download_url': 'https://h/s.exe', 'size': 1, 'digest': 'sha256:AB'},
        ],
      ),
    ])!;
    expect(r.assetFor(UpdatePlatform.android), isNull);
    expect(r.assetFor(UpdatePlatform.windows)!.sha256, 'ab');
  });

  test('offeredUpdate and autoCheckDue', () {
    final r = latestRelease([_rel('mydiet-v0.3.0')]);
    expect(offeredUpdate(r, const AppVersion(0, 2, 0))?.tag, 'mydiet-v0.3.0');
    expect(offeredUpdate(r, const AppVersion(0, 3, 0)), isNull);
    expect(offeredUpdate(r, const AppVersion(0, 2, 0), skippedTag: 'mydiet-v0.3.0'), isNull);
    expect(offeredUpdate(null, const AppVersion(0, 2, 0)), isNull);
    final now = DateTime(2026, 11, 22, 12);
    expect(autoCheckDue(null, now), isTrue);
    expect(autoCheckDue(now.subtract(const Duration(hours: 2)), now), isFalse);
    expect(autoCheckDue(now.subtract(const Duration(hours: 21)), now), isTrue);
    expect(autoCheckDue(now.add(const Duration(days: 1)), now), isTrue); // clock was changed
  });

  group('UpdateClient', () {
    test('reads releases with a generic user agent', () async {
      late http.Request seen;
      final c = UpdateClient(
        client: MockClient((r) async {
          seen = r;
          return http.Response(jsonEncode([_rel('mydiet-v0.5.0')]), 200);
        }),
      );
      expect((await c.fetchLatest())!.version, const AppVersion(0, 5, 0));
      expect(seen.url.host, 'api.github.com');
      expect(seen.headers['User-Agent'], UpdateClient.userAgent);
    });

    test('errors are German messages', () async {
      final limited = UpdateClient(client: MockClient((_) async => http.Response('{}', 403)));
      await expectLater(
        limited.fetchLatest(),
        throwsA(isA<UpdateException>().having((e) => e.message, 'm', contains('Zu viele'))),
      );
      final garbage = UpdateClient(client: MockClient((_) async => http.Response('{"a":1}', 200)));
      expect(garbage.fetchLatest(), throwsA(isA<UpdateException>()));
    });

    test('download checks size and sha256', () async {
      final bytes = utf8.encode('setup');
      final good = sha256.convert(bytes).toString();
      final c = UpdateClient(client: MockClient((_) async => http.Response.bytes(bytes, 200)));
      final dir = await Directory.systemTemp.createTemp('upd');
      addTearDown(() => dir.delete(recursive: true));
      final f = File('${dir.path}/s.exe');
      final progress = <double>[];
      await c.download(
        UpdateAsset(name: 's.exe', url: Uri.parse('https://h/s.exe'), size: bytes.length, sha256: good),
        f,
        onProgress: progress.add,
      );
      expect(await f.readAsBytes(), bytes);
      expect(progress.last, 1);

      final bad = File('${dir.path}/b.exe');
      await expectLater(
        c.download(UpdateAsset(name: 'b.exe', url: Uri.parse('https://h/b.exe'), size: 5, sha256: 'ff'), bad),
        throwsA(isA<UpdateException>()),
      );
      expect(await bad.exists(), isFalse);
    });
  });
}
