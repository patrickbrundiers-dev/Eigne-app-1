/// App lock rules (Phase 5, queue 7.2 without database encryption – Patrick's decision 2026-11-22).
/// Pure Dart, unit tested; storage is in `data/app_lock_store.dart`, the screen in `features/lock/`.
///
/// - PIN: 4–8 digits, stored only as salted PBKDF2-HMAC-SHA256 hash (never the PIN itself).
/// - Wrong PINs: from the 5th failed try a waiting time (30 s, doubling, at most 15 min).
/// - Locking: at start and after the app was in the background longer than the chosen time.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

const pinMinLength = 4;
const pinMaxLength = 8;
const pbkdf2Iterations = 20000;
const freeAttempts = 4;

/// Background time after which the app locks again; 0 = immediately.
const lockAfterChoices = <int, String>{
  0: 'sofort',
  60: 'nach 1 Minute',
  300: 'nach 5 Minuten',
  1800: 'nach 30 Minuten',
};

/// Null if the PIN is acceptable, otherwise the reason.
String? pinProblem(String pin) {
  if (!RegExp(r'^\d+$').hasMatch(pin)) return 'Nur Ziffern';
  if (pin.length < pinMinLength || pin.length > pinMaxLength) return '$pinMinLength bis $pinMaxLength Ziffern';
  if (RegExp(r'^(\d)\1+$').hasMatch(pin)) return 'Nicht nur dieselbe Ziffer';
  const up = '0123456789012';
  const down = '9876543210987';
  if (up.contains(pin) || down.contains(pin)) return 'Keine einfache Zahlenfolge';
  return null;
}

/// PBKDF2-HMAC-SHA256 with one 32-byte block.
List<int> pbkdf2(List<int> password, List<int> salt, int iterations) {
  final hmac = Hmac(sha256, password);
  var u = hmac.convert([...salt, 0, 0, 0, 1]).bytes;
  final out = Uint8List.fromList(u);
  for (var i = 1; i < iterations; i++) {
    u = hmac.convert(u).bytes;
    for (var j = 0; j < out.length; j++) {
      out[j] ^= u[j];
    }
  }
  return out;
}

class PinHash {
  const PinHash({required this.salt, required this.hash, this.iterations = pbkdf2Iterations});
  final String salt; // base64
  final String hash; // base64
  final int iterations;

  static PinHash create(String pin, {Random? random}) {
    final r = random ?? Random.secure();
    final salt = List<int>.generate(16, (_) => r.nextInt(256));
    return PinHash(salt: base64Encode(salt), hash: base64Encode(pbkdf2(utf8.encode(pin), salt, pbkdf2Iterations)));
  }

  bool verify(String pin) {
    final expected = base64Decode(hash);
    final got = pbkdf2(utf8.encode(pin), base64Decode(salt), iterations);
    // Constant time compare.
    var diff = expected.length ^ got.length;
    for (var i = 0; i < min(expected.length, got.length); i++) {
      diff |= expected[i] ^ got[i];
    }
    return diff == 0;
  }

  Map<String, Object> toJson() => {'salt': salt, 'hash': hash, 'iterations': iterations};

  static PinHash? fromJson(Object? m) {
    if (m is! Map) return null;
    final s = m['salt'], h = m['hash'], i = m['iterations'];
    if (s is! String || h is! String || i is! int || i < 1) return null;
    return PinHash(salt: s, hash: h, iterations: i);
  }
}

/// Waiting time before the next try after [failed] wrong PINs in a row.
Duration lockoutFor(int failed) {
  if (failed <= freeAttempts) return Duration.zero;
  final seconds = 30 * pow(2, failed - freeAttempts - 1);
  return Duration(seconds: min(seconds.toInt(), 15 * 60));
}

/// Whether the app has to show the lock screen when it comes back.
bool shouldLockOnResume({required DateTime? backgroundSince, required DateTime now, required int lockAfterSeconds}) {
  if (backgroundSince == null) return false;
  return now.difference(backgroundSince).inSeconds >= lockAfterSeconds;
}

/// Stored lock settings (a small file outside the database, so backups and restores never change the PIN).
class LockConfig {
  const LockConfig({this.pin, this.biometrics = false, this.lockAfterSeconds = 60, this.failed = 0, this.blockedUntil});
  final PinHash? pin;
  final bool biometrics;
  final int lockAfterSeconds;
  final int failed;
  final DateTime? blockedUntil;

  bool get enabled => pin != null;

  LockConfig copyWith({
    PinHash? pin,
    bool clearPin = false,
    bool? biometrics,
    int? lockAfterSeconds,
    int? failed,
    DateTime? blockedUntil,
    bool clearBlocked = false,
  }) => LockConfig(
    pin: clearPin ? null : (pin ?? this.pin),
    biometrics: biometrics ?? this.biometrics,
    lockAfterSeconds: lockAfterSeconds ?? this.lockAfterSeconds,
    failed: failed ?? this.failed,
    blockedUntil: clearBlocked ? null : (blockedUntil ?? this.blockedUntil),
  );

  String toJsonString() => jsonEncode({
    'pin': ?pin?.toJson(),
    'biometrics': biometrics,
    'lockAfterSeconds': lockAfterSeconds,
    'failed': failed,
    'blockedUntil': ?blockedUntil?.toIso8601String(),
  });

  static LockConfig parse(String? s) {
    if (s == null || s.isEmpty) return const LockConfig();
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      final after = m['lockAfterSeconds'];
      return LockConfig(
        pin: PinHash.fromJson(m['pin']),
        biometrics: m['biometrics'] == true,
        lockAfterSeconds: after is int && lockAfterChoices.containsKey(after) ? after : 60,
        failed: (m['failed'] as int?)?.clamp(0, 1000) ?? 0,
        blockedUntil: DateTime.tryParse(m['blockedUntil'] as String? ?? ''),
      );
    } catch (_) {
      return const LockConfig();
    }
  }
}

/// Result of entering a PIN: new state and whether it unlocked.
({LockConfig config, bool unlocked, Duration wait}) tryPin(LockConfig c, String pin, DateTime now) {
  final until = c.blockedUntil;
  if (until != null && now.isBefore(until)) return (config: c, unlocked: false, wait: until.difference(now));
  final p = c.pin;
  if (p == null) return (config: c, unlocked: true, wait: Duration.zero);
  if (p.verify(pin)) return (config: c.copyWith(failed: 0, clearBlocked: true), unlocked: true, wait: Duration.zero);
  final failed = c.failed + 1;
  final wait = lockoutFor(failed);
  return (
    config: c.copyWith(
      failed: failed,
      blockedUntil: wait > Duration.zero ? now.add(wait) : null,
      clearBlocked: wait == Duration.zero,
    ),
    unlocked: false,
    wait: wait,
  );
}
