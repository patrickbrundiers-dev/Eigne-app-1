import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mydiet_ai/src/core/app_lock.dart';

void main() {
  test('PBKDF2 entspricht dem RFC-7914-Testvektor', () {
    // RFC 7914, Abschnitt 11: P="passwd", S="salt", c=1, dkLen 64 – erster Block.
    final out = pbkdf2('passwd'.codeUnits, 'salt'.codeUnits, 1);
    expect(
      out.map((b) => b.toRadixString(16).padLeft(2, '0')).join(),
      '55ac046e56e3089fec1691c22544b605f94185216dde0465e68b9d57c20dacbc',
    );
    expect(sha256, isNotNull);
  });

  test('PIN-Regeln', () {
    expect(pinProblem('4711'), isNull);
    expect(pinProblem('12a4'), 'Nur Ziffern');
    expect(pinProblem('123'), isNotNull);
    expect(pinProblem('123456789'), isNotNull);
    expect(pinProblem('0000'), isNotNull);
    expect(pinProblem('1234'), isNotNull);
    expect(pinProblem('9876'), isNotNull);
  });

  test('Hash prüft richtig und speichert die PIN nicht', () {
    final h = PinHash.create('4711', random: Random(1));
    expect(h.verify('4711'), isTrue);
    expect(h.verify('4712'), isFalse);
    final c = LockConfig(pin: h, biometrics: true, lockAfterSeconds: 300);
    final json = c.toJsonString();
    expect(json, isNot(contains('4711')));
    final back = LockConfig.parse(json);
    expect(back.enabled, isTrue);
    expect(back.biometrics, isTrue);
    expect(back.lockAfterSeconds, 300);
    expect(back.pin!.verify('4711'), isTrue);
    expect(LockConfig.parse('kaputt').enabled, isFalse);
  });

  test('Wartezeit nach Fehlversuchen', () {
    expect(lockoutFor(4), Duration.zero);
    expect(lockoutFor(5), const Duration(seconds: 30));
    expect(lockoutFor(6), const Duration(seconds: 60));
    expect(lockoutFor(20), const Duration(minutes: 15));

    var c = LockConfig(pin: PinHash.create('4711', random: Random(2)));
    final t = DateTime(2026, 11, 22, 12);
    for (var i = 0; i < 4; i++) {
      final r = tryPin(c, '0000', t);
      expect(r.unlocked, isFalse);
      expect(r.wait, Duration.zero);
      c = r.config;
    }
    var r = tryPin(c, '0000', t);
    expect(r.wait, const Duration(seconds: 30));
    c = r.config;
    r = tryPin(c, '4711', t.add(const Duration(seconds: 10)));
    expect(r.unlocked, isFalse, reason: 'während der Wartezeit zählt auch die richtige PIN nicht');
    r = tryPin(c, '4711', t.add(const Duration(seconds: 31)));
    expect(r.unlocked, isTrue);
    expect(r.config.failed, 0);
    expect(r.config.blockedUntil, isNull);
  });

  test('Sperren nach Hintergrundzeit', () {
    final t = DateTime(2026, 11, 22, 12);
    expect(shouldLockOnResume(backgroundSince: null, now: t, lockAfterSeconds: 0), isFalse);
    expect(shouldLockOnResume(backgroundSince: t, now: t, lockAfterSeconds: 0), isTrue);
    expect(
      shouldLockOnResume(backgroundSince: t, now: t.add(const Duration(seconds: 59)), lockAfterSeconds: 60),
      isFalse,
    );
    expect(
      shouldLockOnResume(backgroundSince: t, now: t.add(const Duration(minutes: 1)), lockAfterSeconds: 60),
      isTrue,
    );
  });
}
