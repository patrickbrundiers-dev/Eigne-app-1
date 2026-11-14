import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_ai/src/vault/vault.dart';

const _pw = 'korrekt pferd batterie';
const _kdf = KdfParams.testing;

Map<String, dynamic> _roundTripJson(Map<String, dynamic> v) =>
    jsonDecode(jsonEncode(v)) as Map<String, dynamic>;

void main() {
  group('vault', () {
    test('password and recovery code both unlock the same keys', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      final stored =
          _roundTripJson(setup.vault); // as it would come back from Drive

      final a = await unlockWithPassword(stored, _pw);
      final b = await unlockWithRecoveryCode(stored, setup.recoveryCode);
      expect(a.boxPublic, setup.keys.boxPublic);
      expect(b.signPublic, setup.keys.signPublic);
    });

    test('vault contains no secret in clear', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      final text = jsonEncode(setup.vault);
      expect(text, isNot(contains(_pw)));
      expect(text, isNot(contains(setup.recoveryCode)));
      expect(
          setup.vault.keys,
          containsAll(
              ['box_pub', 'sign_pub', 'kdf', 'by_password', 'by_recovery']));
    });

    test('wrong password and wrong code are refused', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      await expectLater(
          unlockWithPassword(setup.vault, 'falsches passwort'),
          throwsA(isA<VaultLocked>()
              .having((e) => e.reason, 'reason', 'password')));
      await expectLater(
          unlockWithRecoveryCode(setup.vault, newRecoveryCode()),
          throwsA(isA<VaultLocked>()
              .having((e) => e.reason, 'reason', 'recovery')));
      await expectLater(unlockWithRecoveryCode(setup.vault, 'zu kurz'),
          throwsA(isA<VaultLocked>()));
    });

    test('recovery code is forgiving about case, spaces and dashes', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      final sloppy = setup.recoveryCode.toLowerCase().replaceAll('-', ' ');
      final keys = await unlockWithRecoveryCode(setup.vault, sloppy);
      expect(keys.boxPublic, setup.keys.boxPublic);
    });

    test('recovery code format: 5 groups of 5, no ambiguous letters', () {
      final code = newRecoveryCode();
      expect(
          code, matches(RegExp(r'^([A-HJ-NP-Z2-9]{5}-){4}[A-HJ-NP-Z2-9]{5}$')));
      expect(normalizeRecoveryCode('O0O0O-11111-AAAAA-AAAAA-AAAAA'), isNull);
    });

    test('swapping the public key in the vault is detected', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      final other = await createVault(_pw, kdf: _kdf);
      final forged = _roundTripJson(setup.vault)
        ..['box_pub'] = other.vault['box_pub'];
      await expectLater(
          unlockWithPassword(forged, _pw), throwsA(isA<VaultLocked>()));
    });

    test('tampered ciphertext is detected', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      final v = _roundTripJson(setup.vault);
      final sealed = v['by_password'] as Map<String, dynamic>;
      final c = sealed['c'] as String;
      sealed['c'] = (c[0] == 'A' ? 'B' : 'A') + c.substring(1);
      await expectLater(
          unlockWithPassword(v, _pw), throwsA(isA<VaultLocked>()));
    });

    test('short passwords are refused', () async {
      expect(() => createVault('kurz', kdf: _kdf), throwsArgumentError);
    });

    test('rekey gives a new password and code for the same keys', () async {
      final setup = await createVault(_pw, kdf: _kdf);
      final again =
          await rekeyVault(setup.keys, 'ein ganz neues passwort', kdf: _kdf);
      expect(again.recoveryCode, isNot(setup.recoveryCode));
      final keys =
          await unlockWithPassword(again.vault, 'ein ganz neues passwort');
      expect(keys.boxPublic, setup.keys.boxPublic);
      await expectLater(
          unlockWithPassword(again.vault, _pw), throwsA(isA<VaultLocked>()));
    });
  });

  group('space keys', () {
    test('only the addressed member can unwrap', () async {
      final anna = await PersonalKeys.generate();
      final ben = await PersonalKeys.generate();
      final key = SpaceKey.generate();
      final wrapped = await wrapSpaceKey(key, anna.boxPublic,
          spaceId: 's1', memberId: 'anna');

      final opened = await unwrapSpaceKey(_roundTripJson(wrapped), anna,
          spaceId: 's1', memberId: 'anna');
      expect(opened.bytes, key.bytes);
      await expectLater(
          unwrapSpaceKey(wrapped, ben, spaceId: 's1', memberId: 'anna'),
          throwsA(isA<CryptoFailure>()));
    });

    test('a wrapped key is bound to its space and member', () async {
      final anna = await PersonalKeys.generate();
      final wrapped = await wrapSpaceKey(SpaceKey.generate(), anna.boxPublic,
          spaceId: 'haushalt', memberId: 'anna');
      await expectLater(
          unwrapSpaceKey(wrapped, anna, spaceId: 'privat', memberId: 'anna'),
          throwsA(isA<CryptoFailure>()));
      await expectLater(
          unwrapSpaceKey(wrapped, anna, spaceId: 'haushalt', memberId: 'ben'),
          throwsA(isA<CryptoFailure>()));
      final bumped = _roundTripJson(wrapped)..['g'] = 2;
      await expectLater(
          unwrapSpaceKey(bumped, anna, spaceId: 'haushalt', memberId: 'anna'),
          throwsA(isA<CryptoFailure>()));
    });
  });

  group('documents', () {
    test('round trip, context binding and tamper detection', () async {
      final key = SpaceKey.generate();
      final clear = utf8.encode('%PDF-1.7 synthetic test document');
      final enc = await encryptForSpace(key, clear, 'doc/d1/v1');
      expect(enc.sublist(0, magic.length), magic);
      expect(
          utf8.decode(enc, allowMalformed: true), isNot(contains('synthetic')));

      expect(await decryptForSpace(key, enc, 'doc/d1/v1'), clear);
      await expectLater(decryptForSpace(key, enc, 'doc/d2/v1'),
          throwsA(isA<CryptoFailure>()));
      await expectLater(decryptForSpace(SpaceKey.generate(), enc, 'doc/d1/v1'),
          throwsA(isA<CryptoFailure>()));
      final flipped = [...enc]..[enc.length - 20] ^= 1;
      await expectLater(decryptForSpace(key, flipped, 'doc/d1/v1'),
          throwsA(isA<CryptoFailure>()));
      await expectLater(decryptForSpace(key, clear, 'doc/d1/v1'),
          throwsA(isA<CryptoFailure>()));
    });

    test('same content encrypts differently each time', () async {
      final key = SpaceKey.generate();
      final a = await encryptForSpace(key, [1, 2, 3], 'x');
      final b = await encryptForSpace(key, [1, 2, 3], 'x');
      expect(a, isNot(b));
    });
  });

  group('signatures', () {
    test('family list signed by the admin verifies, changes do not', () async {
      final admin = await PersonalKeys.generate();
      final other = await PersonalKeys.generate();
      final list = utf8.encode('{"members":["anna","ben"]}');
      final sig = await admin.sign(list);
      expect(await verifySignature(list, sig, admin.signPublic), isTrue);
      expect(
          await verifySignature(
              utf8.encode('{"members":["anna","eve"]}'), sig, admin.signPublic),
          isFalse);
      expect(await verifySignature(list, sig, other.signPublic), isFalse);
    });
  });
}
