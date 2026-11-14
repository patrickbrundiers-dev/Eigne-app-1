import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_ai/src/api/api_client.dart';
import 'package:paperless_ai/src/api/models.dart';
import 'package:paperless_ai/src/app.dart';
import 'package:paperless_ai/src/app_state.dart';
import 'package:paperless_ai/src/auth/token_store.dart';
import 'package:paperless_ai/src/import/document_picker.dart';
import 'package:paperless_ai/src/sync/local_store.dart';
import 'package:paperless_ai/src/sync/sync_engine.dart';

import 'fakes.dart';

const _server = 'https://paperless.example.org';
const _anna =
    UserInfo(id: 'u1', email: 'anna@example.test', displayName: 'Anna');

SpaceInfo _space(String id) =>
    SpaceInfo(id: id, name: id, type: 'shared', permissions: {'read', 'write'});

DocumentInfo _doc(String id,
        {String space = 's1', int revision = 1, bool deleted = false}) =>
    DocumentInfo(
      id: id,
      spaceId: space,
      title: 'Dokument $id',
      createdAt: DateTime.utc(2026, 11, 14),
      revision: revision,
      deleted: deleted,
    );

/// Scripted server: each sync call returns the next queued page.
class ScriptedClient extends ApiClient {
  ScriptedClient() : super(baseUrl: Uri.parse(_server), token: 'pai_test');

  final pages = <Object>[]; // SyncPage or an exception to throw
  final cursors = <String?>[];
  final fullFetches = <String>[];
  Map<String, List<DocumentInfo>> spaceDocs = {};
  final uploads = <String>[];
  Object? uploadResult; // null = success, else exception

  @override
  Future<SyncPage> sync({String? cursor, int limit = 200}) async {
    cursors.add(cursor);
    final next = pages.removeAt(0);
    if (next is SyncPage) return next;
    throw next;
  }

  @override
  Future<List<DocumentInfo>> documents(String spaceId) async {
    fullFetches.add(spaceId);
    return spaceDocs[spaceId] ?? const [];
  }

  @override
  Future<DocumentInfo> upload({
    required String spaceId,
    required String filename,
    required int length,
    required Stream<List<int>> content,
    String? title,
  }) async {
    await content.drain<void>();
    uploads.add(filename);
    if (uploadResult != null) throw uploadResult!;
    return _doc('up-$filename', space: spaceId);
  }
}

SyncPage _page(List<DocumentInfo> docs,
        {String cursor = 'c',
        bool more = false,
        List<String> spaces = const ['s1']}) =>
    SyncPage(
      cursor: cursor,
      hasMore: more,
      spaces: [for (final s in spaces) _space(s)],
      documents: docs,
    );

PickedDocument _picked(String name) => PickedDocument(
    name: name, length: pdfBytes.length, open: () => Stream.value(pdfBytes));

Future<SyncEngine> _engine([LocalStore? store]) async {
  final e = SyncEngine(store ?? MemoryLocalStore());
  await e.load(_server);
  e.adopt(_server, _anna);
  return e;
}

void main() {
  group('SyncEngine', () {
    test('pages through the feed and keeps the last cursor', () async {
      final e = await _engine();
      final c = ScriptedClient()
        ..pages.addAll([
          _page([_doc('a'), _doc('b')], cursor: 'p1', more: true),
          _page([_doc('c')], cursor: 'p2'),
        ]);
      await e.sync(c);
      expect(c.cursors, [null, 'p1']);
      expect(e.cursor, 'p2');
      expect(
          e.documentsIn('s1').map((d) => d.id), containsAll(['a', 'b', 'c']));
      expect(e.lastSyncedAt, isNotNull);
    });

    test('applies deletions and ignores older revisions', () async {
      final e = await _engine();
      final c = ScriptedClient()
        ..pages.addAll([
          _page([_doc('a', revision: 2), _doc('b')]),
          _page(
              [_doc('a', revision: 1), _doc('b', revision: 2, deleted: true)]),
        ]);
      await e.sync(c);
      await e.sync(c);
      expect(e.documentsIn('s1').map((d) => d.id), ['a']);
      expect(e.documentsIn('s1').single.revision, 2);
    });

    test('drops documents of spaces the user lost access to', () async {
      final e = await _engine();
      final c = ScriptedClient()
        ..pages.addAll([
          _page([_doc('a'), _doc('p', space: 's2')], spaces: ['s1', 's2']),
          _page([], spaces: ['s1']),
        ]);
      await e.sync(c);
      expect(e.documentsIn('s2'), hasLength(1));
      await e.sync(c);
      expect(e.documentsIn('s2'), isEmpty);
      expect(e.spaces.map((s) => s.id), ['s1']);
    });

    test('a newly shared space is fetched in full', () async {
      final e = await _engine();
      final c = ScriptedClient()
        ..spaceDocs = {
          's2': [_doc('old', space: 's2')]
        }
        ..pages.addAll([
          _page([_doc('a')]),
          _page([], spaces: ['s1', 's2']),
        ]);
      await e.sync(c);
      await e.sync(c);
      expect(c.fullFetches, ['s2']);
      expect(e.documentsIn('s2').single.id, 'old');
    });

    test('an interrupted sync leaves the cache unchanged', () async {
      final e = await _engine();
      final c = ScriptedClient()
        ..pages.addAll([
          _page([_doc('a')], cursor: 'ok'),
          _page([_doc('b')], cursor: 'half', more: true),
          const ConnectionFailed(),
        ]);
      await e.sync(c);
      await expectLater(e.sync(c), throwsA(isA<ConnectionFailed>()));
      expect(e.cursor, 'ok');
      expect(e.documentsIn('s1').map((d) => d.id), ['a']);
    });

    test('cache survives a restart and is dropped for another server',
        () async {
      final store = MemoryLocalStore();
      final e = await _engine(store);
      await e
          .sync(ScriptedClient()..pages.add(_page([_doc('a')], cursor: 'k')));

      final again = SyncEngine(store);
      await again.load(_server);
      expect(again.user?.id, 'u1');
      expect(again.cursor, 'k');
      expect(again.documentsIn('s1').single.id, 'a');

      final other = SyncEngine(store);
      await other.load('https://other.example.org');
      expect(other.hasCache, isFalse);
      expect(other.documentCount, 0);
    });

    test('another account on the same server starts empty', () async {
      final e = await _engine();
      await e.sync(ScriptedClient()..pages.add(_page([_doc('a')])));
      e.adopt(
          _server,
          const UserInfo(
              id: 'u2', email: 'ben@example.test', displayName: 'Ben'));
      expect(e.documentCount, 0);
      expect(e.cursor, isNull);
    });

    test('queued uploads go out before the feed is pulled', () async {
      final store = MemoryLocalStore();
      final e = await _engine(store);
      await e.enqueue(_picked('Scan.pdf'), 's1');
      expect(store.blobs, hasLength(1));
      final c = ScriptedClient()..pages.add(_page([]));
      await e.sync(c);
      expect(c.uploads, ['Scan.pdf']);
      expect(e.queue, isEmpty);
      expect(store.blobs, isEmpty);
      expect(e.documentsIn('s1').single.id, 'up-Scan.pdf');
    });

    test('queue keeps files while offline and survives a restart', () async {
      final store = MemoryLocalStore();
      final e = await _engine(store);
      await e.enqueue(_picked('Scan.pdf'), 's1');
      final c = ScriptedClient()..uploadResult = const ConnectionFailed();
      await expectLater(e.sync(c), throwsA(isA<ConnectionFailed>()));
      final again = SyncEngine(store);
      await again.load(_server);
      expect(again.queue.single.filename, 'Scan.pdf');
    });

    test('duplicates are dropped, rejected files wait for the user', () async {
      final e = await _engine();
      await e.enqueue(_picked('Doppelt.pdf'), 's1');
      final c = ScriptedClient()
        ..uploadResult = const ApiException(409, code: 'duplicate')
        ..pages.add(_page([]));
      await e.sync(c);
      expect(e.queue, isEmpty);

      await e.enqueue(_picked('Kaputt.pdf'), 's1');
      c
        ..uploadResult = const ApiException(422, code: 'malformed')
        ..pages.addAll([_page([]), _page([])]);
      await e.sync(c);
      expect(e.queue.single.error, contains('beschädigt'));
      await e.sync(c); // not retried
      expect(c.uploads.where((u) => u == 'Kaputt.pdf'), hasLength(1));
      await e.discard(e.queue.single.id);
      expect(e.queue, isEmpty);
    });

    test('clear wipes cache, queue and files', () async {
      final store = MemoryLocalStore();
      final e = await _engine(store);
      await e.enqueue(_picked('Scan.pdf'), 's1');
      await e.sync(ScriptedClient()
        ..uploadResult = const ApiException(422, code: 'malformed')
        ..pages.add(_page([_doc('a')])));
      await e.clear();
      expect(store.records, isEmpty);
      expect(store.blobs, isEmpty);
      expect(e.hasCache, isFalse);
    });
  });

  group('offline app', () {
    Future<void> pump(WidgetTester tester, AppState state) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(PaperlessAiApp(key: UniqueKey(), state: state));
      await state.restore();
      await tester.pumpAndSettle();
    }

    Future<void> openDocuments(WidgetTester tester) async {
      await tester.tap(find.text('Dokumente').first);
      await tester.pumpAndSettle();
    }

    testWidgets('starts offline from the cache and catches up when back online',
        (tester) async {
      final backend = FakeBackend();
      backend.docs.add({
        'id': 'd1',
        'space_id': 's1',
        'title': 'Stromrechnung',
        'revision': 1,
        'created_at': '2026-11-14T08:00:00Z',
        'updated_at': '2026-11-14T08:00:00Z',
        'mime_type': 'application/pdf',
      });
      final tokens = MemoryTokenStore();
      await tokens.save(server: _server, token: 'pai_test');
      final local = MemoryLocalStore();

      // first start online fills the cache
      final online = backend.state(store: tokens, local: local);
      await pump(tester, online);
      await openDocuments(tester);
      expect(find.text('Stromrechnung'), findsOneWidget);

      // next start without network: same list, offline banner
      backend.offline = true;
      final state = backend.state(store: tokens, local: local);
      await pump(tester, state);
      await openDocuments(tester);
      expect(state.isSignedIn, isTrue);
      expect(find.byKey(const Key('documents.offline')), findsOneWidget);
      expect(find.text('Stromrechnung'), findsOneWidget);

      // a scan while offline waits in the queue
      await tester.tap(find.text('Übersicht').first);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('dashboard.import')));
      await tester.pumpAndSettle();
      expect(find.textContaining('automatisch hochgeladen'), findsOneWidget);
      expect(state.sync.queue, hasLength(1));
      expect(backend.uploads, isEmpty);

      // network is back: the next sync uploads and clears the banner
      backend.offline = false;
      await state.syncNow();
      await tester.pumpAndSettle();
      expect(backend.uploads, ['Rechnung.pdf']);
      expect(state.sync.queue, isEmpty);
      expect(state.offline, isFalse);
      await openDocuments(tester);
      expect(find.byKey(const Key('documents.offline')), findsNothing);
      expect(find.text('Rechnung'), findsOneWidget);
    });

    testWidgets('without a cache an offline start shows the login hint',
        (tester) async {
      final backend = FakeBackend()..offline = true;
      final tokens = MemoryTokenStore();
      await tokens.save(server: _server, token: 'pai_test');
      final state = backend.state(store: tokens);
      await pump(tester, state);
      expect(state.isSignedIn, isFalse);
      expect(await tokens.load().then((t) => t.token), 'pai_test');
    });
  });
}
