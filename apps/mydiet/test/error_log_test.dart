import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/error_report.dart';
import 'package:mydiet_ai/src/data/error_log.dart';

void main() {
  group('Bereinigen', () {
    test('Zahlen, Zitate, Pfade und E-Mails verschwinden', () {
      final s = sanitizeErrorMessage(
        'Invalid argument: Die Menge muss zwischen 0 und 5000 g liegen, Gewicht 98,4 kg '
        'für "Omas Kuchen" in /data/user/0/de.mydietai.mydiet_ai/files/mydiet.sqlite von max@example.com',
      );
      expect(s, isNot(contains('98')));
      expect(s, isNot(contains('5000')));
      expect(s, isNot(contains('Omas Kuchen')));
      expect(s, isNot(contains('/data/user')));
      expect(s, isNot(contains('max@example.com')));
      expect(s, contains('Die Menge muss zwischen # und # g liegen'));
      expect(s, contains('<Pfad>'));
    });

    test('Lange Meldungen werden gekürzt', () {
      expect(sanitizeErrorMessage('x' * 1000).length, maxMessageLength + 1);
    });

    test('Nur eigene Stack-Frames, höchstens 8', () {
      final stack = [
        '#0 Foo.bar (package:flutter/src/widgets/framework.dart:12:3)',
        '#1 _State.build (package:mydiet_ai/src/features/weight/weight_page.dart:42:7)',
        '#2 dart:async',
        for (var i = 0; i < 20; i++) '#${i + 3} x (package:mydiet_ai/src/core/energy.dart:$i:1)',
      ].join('\n');
      final f = appFrames(stack);
      expect(f.first, 'src/features/weight/weight_page.dart:42');
      expect(f, hasLength(maxFrames));
      expect(f.any((x) => x.contains('flutter/')), isFalse);
    });
  });

  group('Protokolldatei', () {
    late Directory tmp;
    setUp(() async => tmp = await Directory.systemTemp.createTemp('sattly-errlog'));
    tearDown(() => tmp.delete(recursive: true));

    test('Schreiben, Lesen, nur die neuesten behalten, Leeren', () async {
      final log = ErrorLog(File('${tmp.path}/log.jsonl'), keep: 3);
      for (var i = 0; i < 5; i++) {
        await log.record(StateError('Fehler $i bei 72,5 kg'), StackTrace.current, now: DateTime(2026, 3, 1, 10, i));
      }
      final r = await log.read();
      expect(r, hasLength(3));
      expect(r.first.time.minute, 2);
      expect(r.last.type, 'StateError');
      expect(r.last.message, isNot(contains('72')));
      expect(r.last.toText(), contains('StateError'));
      await log.clear();
      expect(await log.read(), isEmpty);
    });

    test('Kaputte Zeilen werden übersprungen', () async {
      final f = File('${tmp.path}/log.jsonl');
      await f.writeAsString('kein json\n{"t":"2026-03-01T10:00:00Z","type":"X","msg":"m","at":[]}\n');
      final r = await ErrorLog(f).read();
      expect(r.single.type, 'X');
    });
  });
}
