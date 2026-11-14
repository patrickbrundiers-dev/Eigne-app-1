import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_ai/src/app.dart';
import 'package:paperless_ai/src/auth/token_store.dart';

import 'fakes.dart';

Future<void> pumpApp(WidgetTester tester, FakeBackend backend,
    {MemoryTokenStore? store, FakePicker? picker}) async {
  tester.view.physicalSize = const Size(1440, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final state = backend.state(store: store, picker: picker);
  await tester.pumpWidget(PaperlessAiApp(state: state));
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester,
    {String password = 'correct horse battery'}) async {
  await tester.tap(find.byKey(const Key('dashboard.connect')));
  await tester.pumpAndSettle();
  await tester.enterText(
      find.byKey(const Key('login.server')), 'paperless.example.org');
  await tester.enterText(
      find.byKey(const Key('login.email')), 'anna@example.test');
  await tester.enterText(find.byKey(const Key('login.password')), password);
  await tester.tap(find.byKey(const Key('login.submit')));
  await tester.pumpAndSettle();
}

FilledButton importButton(WidgetTester tester) =>
    tester.widget<FilledButton>(find.byKey(const Key('dashboard.import')));

void main() {
  testWidgets('import is disabled until signed in', (tester) async {
    await pumpApp(tester, FakeBackend());
    expect(importButton(tester).onPressed, isNull);
    expect(find.byKey(const Key('dashboard.connect')), findsOneWidget);
  });

  testWidgets('wrong password shows an error and stays on the login page',
      (tester) async {
    await pumpApp(tester, FakeBackend());
    await login(tester, password: 'wrong password!');
    expect(find.text('E-Mail oder Passwort ist falsch.'), findsOneWidget);
    expect(find.byKey(const Key('login.submit')), findsOneWidget);
  });

  testWidgets('http to a LAN address is refused before any request',
      (tester) async {
    final backend = FakeBackend();
    await pumpApp(tester, backend);
    await tester.tap(find.byKey(const Key('dashboard.connect')));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const Key('login.server')), 'http://192.168.1.5');
    await tester.enterText(
        find.byKey(const Key('login.email')), 'anna@example.test');
    await tester.enterText(find.byKey(const Key('login.password')), 'x');
    await tester.tap(find.byKey(const Key('login.submit')));
    await tester.pumpAndSettle();
    expect(find.textContaining('https://'), findsWidgets);
    expect(backend.requests, isEmpty);
  });

  testWidgets('login stores the token and enables import; upload succeeds',
      (tester) async {
    final backend = FakeBackend();
    final store = MemoryTokenStore();
    await pumpApp(tester, backend, store: store);
    await login(tester);

    expect(store.token, 'pai_test');
    expect(store.server, 'https://paperless.example.org');
    expect(importButton(tester).onPressed, isNotNull);

    await tester.tap(find.byKey(const Key('dashboard.import')));
    await tester.pumpAndSettle();
    expect(backend.uploads, ['Rechnung.pdf']);
    expect(find.textContaining('in Haushalt gespeichert'), findsOneWidget);

    // The new document shows up in the documents list.
    await tester.tap(find.text('Dokumente').first);
    await tester.pumpAndSettle();
    expect(find.text('Rechnung'), findsOneWidget);
  });

  testWidgets('server rejection is shown in German', (tester) async {
    final backend = FakeBackend()..nextUploadErrorCode = 'encrypted_pdf';
    await pumpApp(tester, backend);
    await login(tester);
    await tester.tap(find.byKey(const Key('dashboard.import')));
    await tester.pumpAndSettle();
    expect(find.textContaining('passwortgeschützt'), findsOneWidget);
  });

  testWidgets('with several writable spaces the user picks one',
      (tester) async {
    final backend = FakeBackend();
    backend.spaces.add({
      'id': 's2',
      'family_id': 'f1',
      'name': 'Schule',
      'type': 'child_managed',
      'permissions': ['read', 'write'],
    });
    await pumpApp(tester, backend);
    await login(tester);
    await tester.tap(find.byKey(const Key('dashboard.import')));
    await tester.pumpAndSettle();
    expect(find.text('In welchen Bereich?'), findsOneWidget);
    await tester.tap(find.text('Schule'));
    await tester.pumpAndSettle();
    final upload = backend.requests.lastWhere((r) => r.method == 'POST');
    expect(upload.url.path, '/api/v1/spaces/s2/documents');
  });

  testWidgets('cancelled file dialog uploads nothing', (tester) async {
    final backend = FakeBackend();
    await pumpApp(tester, backend, picker: FakePicker(name: null)..name = null);
    await login(tester);
    await tester.tap(find.byKey(const Key('dashboard.import')));
    await tester.pumpAndSettle();
    expect(backend.uploads, isEmpty);
  });

  testWidgets('logout clears the token and disables import', (tester) async {
    final backend = FakeBackend();
    final store = MemoryTokenStore();
    await pumpApp(tester, backend, store: store);
    await login(tester);
    await tester.tap(find.text('Einstellungen').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('settings.logout')));
    await tester.pumpAndSettle();
    expect(store.token, isNull);
    expect(backend.requests.last.url.path, '/api/v1/auth/logout');
    await tester.tap(find.text('Übersicht').first);
    await tester.pumpAndSettle();
    expect(importButton(tester).onPressed, isNull);
  });

  testWidgets('saved session is restored on start', (tester) async {
    final backend = FakeBackend();
    final store = MemoryTokenStore()
      ..server = 'https://paperless.example.org'
      ..token = 'pai_test';
    final state = backend.state(store: store);
    await state.restore();
    expect(state.isSignedIn, isTrue);
    expect(state.writableSpaces.single.name, 'Haushalt');

    final expired = MemoryTokenStore()
      ..server = 'https://paperless.example.org'
      ..token = 'pai_revoked';
    final s2 = backend.state(store: expired);
    await s2.restore();
    expect(s2.isSignedIn, isFalse);
    expect(expired.token, isNull); // dropped after 401
  });
}
