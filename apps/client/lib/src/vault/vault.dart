/// Client-side keys for the serverless Drive mode.
///
/// Every person has a vault: two random 32-byte seeds, one for an X25519 key pair (space keys
/// are wrapped to it) and one for an Ed25519 key pair (signs the family list). The seeds are
/// encrypted twice: with a key derived from the person's vault password (Argon2id) and with
/// a key derived from a printed recovery code. The encrypted vault is stored in the person's
/// own Drive app-data folder; nobody else can read it, and Google only sees ciphertext.
///
/// Each space has a random AES-256 key. It is wrapped for every member with an ephemeral
/// X25519 exchange + HKDF-SHA256 + AES-256-GCM ("sealed box"), bound to space id and member
/// id so a wrapped key cannot be replayed for another space or person.
library;

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class VaultLocked implements Exception {
  const VaultLocked(this.reason);
  final String reason;

  /// German message for the user.
  String get userMessage => switch (reason) {
        'password' => 'Das Tresor-Passwort ist falsch.',
        'recovery' => 'Der Wiederherstellungscode ist falsch.',
        _ => 'Der Tresor ist beschädigt oder wurde verändert.',
      };

  @override
  String toString() => 'VaultLocked($reason)';
}

class CryptoFailure implements Exception {
  const CryptoFailure(this.what);
  final String what;
  @override
  String toString() => 'CryptoFailure($what)';
}

/// Argon2id cost. The defaults follow the OWASP recommendation (19 MiB, 2 passes).
class KdfParams {
  const KdfParams(
      {this.memoryKiB = 19456, this.iterations = 2, this.parallelism = 1});

  /// Cheap parameters for tests only.
  static const testing = KdfParams(memoryKiB: 64, iterations: 1);

  final int memoryKiB;
  final int iterations;
  final int parallelism;

  Map<String, dynamic> toJson() =>
      {'m': memoryKiB, 't': iterations, 'p': parallelism};

  factory KdfParams.fromJson(Map<String, dynamic> j) => KdfParams(
      memoryKiB: j['m'] as int,
      iterations: j['t'] as int,
      parallelism: j['p'] as int);
}

final _aes = AesGcm.with256bits();
final _x25519 = X25519();
final _ed25519 = Ed25519();
final _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);
final _rng = Random.secure();

Uint8List randomBytes(int n) =>
    Uint8List.fromList(List<int>.generate(n, (_) => _rng.nextInt(256)));

String _b64(List<int> b) => base64Url.encode(b).replaceAll('=', '');
Uint8List _unb64(String s) =>
    Uint8List.fromList(base64Url.decode(s + '=' * ((4 - s.length % 4) % 4)));

/// The unlocked secrets of one person.
class PersonalKeys {
  PersonalKeys._(this._boxSeed, this._signSeed, this.boxKeyPair,
      this.signKeyPair, this.boxPublic, this.signPublic);

  static Future<PersonalKeys> fromSeeds(
      List<int> boxSeed, List<int> signSeed) async {
    final box = await _x25519.newKeyPairFromSeed(boxSeed);
    final sign = await _ed25519.newKeyPairFromSeed(signSeed);
    return PersonalKeys._(
        Uint8List.fromList(boxSeed),
        Uint8List.fromList(signSeed),
        box,
        sign,
        (await box.extractPublicKey()).bytes,
        (await sign.extractPublicKey()).bytes);
  }

  static Future<PersonalKeys> generate() =>
      fromSeeds(randomBytes(32), randomBytes(32));

  final Uint8List _boxSeed;
  final Uint8List _signSeed;
  final SimpleKeyPair boxKeyPair;
  final SimpleKeyPair signKeyPair;

  /// Public halves, safe to share with the family.
  final List<int> boxPublic;
  final List<int> signPublic;

  Uint8List _seeds() => Uint8List.fromList([..._boxSeed, ..._signSeed]);

  Future<List<int>> sign(List<int> message) async =>
      (await _ed25519.sign(message, keyPair: signKeyPair)).bytes;
}

Future<bool> verifySignature(
        List<int> message, List<int> signature, List<int> signerPublic) =>
    _ed25519.verify(message,
        signature: Signature(signature,
            publicKey:
                SimplePublicKey(signerPublic, type: KeyPairType.ed25519)));

// --- recovery code --------------------------------------------------------------------------

const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no 0/O, 1/I

/// 25 random characters from a 32-letter alphabet = 125 bits, printed as 5 groups of 5.
String newRecoveryCode() {
  final chars =
      List.generate(25, (_) => _alphabet[_rng.nextInt(_alphabet.length)]);
  return [for (var i = 0; i < 25; i += 5) chars.sublist(i, i + 5).join()]
      .join('-');
}

/// Accepts lower case, spaces and missing dashes; returns null if it cannot be a code.
String? normalizeRecoveryCode(String input) {
  final s = input.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
  if (s.length != 25 || s.split('').any((c) => !_alphabet.contains(c))) {
    return null;
  }
  return s;
}

// --- vault ----------------------------------------------------------------------------------

class VaultSetup {
  const VaultSetup(this.vault, this.keys, this.recoveryCode);
  final Map<String, dynamic> vault;
  final PersonalKeys keys;

  /// Shown once to print or write down; never stored by the app.
  final String recoveryCode;
}

const _vaultVersion = 1;

List<int> _vaultAad(String kind, Map<String, dynamic> vault) => utf8.encode(
    'paperless-vault-v$_vaultVersion|$kind|${vault['box_pub']}|${vault['sign_pub']}');

Future<SecretKey> _passwordKey(String password, List<int> salt, KdfParams p) =>
    Argon2id(
      parallelism: p.parallelism,
      memory: p.memoryKiB,
      iterations: p.iterations,
      hashLength: 32,
    ).deriveKey(secretKey: SecretKey(utf8.encode(password)), nonce: salt);

Future<SecretKey> _recoveryKey(String normalizedCode, List<int> salt) =>
    _hkdf.deriveKey(
        secretKey: SecretKey(utf8.encode(normalizedCode)),
        nonce: salt,
        info: utf8.encode('paperless-recovery-v1'));

Future<Map<String, dynamic>> _seal(
    SecretKey key, List<int> clear, List<int> aad) async {
  final box = await _aes.encrypt(clear,
      secretKey: key, nonce: randomBytes(12), aad: aad);
  return {
    'n': _b64(box.nonce),
    'c': _b64(box.cipherText),
    't': _b64(box.mac.bytes)
  };
}

Future<List<int>> _open(
        SecretKey key, Map<String, dynamic> sealed, List<int> aad) =>
    _aes.decrypt(
        SecretBox(_unb64(sealed['c'] as String),
            nonce: _unb64(sealed['n'] as String),
            mac: Mac(_unb64(sealed['t'] as String))),
        secretKey: key,
        aad: aad);

const minPasswordLength = 10;

/// Creates new personal keys and their vault.
Future<VaultSetup> createVault(String password,
    {KdfParams kdf = const KdfParams()}) async {
  if (password.length < minPasswordLength) {
    throw ArgumentError('password shorter than $minPasswordLength characters');
  }
  final keys = await PersonalKeys.generate();
  final code = newRecoveryCode();
  final vault = await _buildVault(keys, password, code, kdf);
  return VaultSetup(vault, keys, code);
}

Future<Map<String, dynamic>> _buildVault(
    PersonalKeys keys, String password, String code, KdfParams kdf) async {
  final pwSalt = randomBytes(16);
  final rcSalt = randomBytes(16);
  final vault = <String, dynamic>{
    'v': _vaultVersion,
    'box_pub': _b64(keys.boxPublic),
    'sign_pub': _b64(keys.signPublic),
    'kdf': {'alg': 'argon2id', 'salt': _b64(pwSalt), ...kdf.toJson()},
    'recovery': {'alg': 'hkdf-sha256', 'salt': _b64(rcSalt)},
  };
  vault['by_password'] = await _seal(await _passwordKey(password, pwSalt, kdf),
      keys._seeds(), _vaultAad('pw', vault));
  vault['by_recovery'] = await _seal(
      await _recoveryKey(normalizeRecoveryCode(code)!, rcSalt),
      keys._seeds(),
      _vaultAad('rc', vault));
  return vault;
}

Future<PersonalKeys> _keysFrom(
    List<int> seeds, Map<String, dynamic> vault) async {
  if (seeds.length != 64) throw const VaultLocked('damaged');
  final keys =
      await PersonalKeys.fromSeeds(seeds.sublist(0, 32), seeds.sublist(32));
  if (_b64(keys.boxPublic) != vault['box_pub'] ||
      _b64(keys.signPublic) != vault['sign_pub']) {
    throw const VaultLocked('damaged');
  }
  return keys;
}

void _checkVersion(Map<String, dynamic> vault) {
  if (vault['v'] != _vaultVersion) throw const VaultLocked('damaged');
}

Future<PersonalKeys> unlockWithPassword(
    Map<String, dynamic> vault, String password) async {
  _checkVersion(vault);
  final kdf = vault['kdf'] as Map<String, dynamic>;
  final key = await _passwordKey(
      password, _unb64(kdf['salt'] as String), KdfParams.fromJson(kdf));
  try {
    final seeds = await _open(key, vault['by_password'] as Map<String, dynamic>,
        _vaultAad('pw', vault));
    return await _keysFrom(seeds, vault);
  } on SecretBoxAuthenticationError {
    throw const VaultLocked('password');
  }
}

Future<PersonalKeys> unlockWithRecoveryCode(
    Map<String, dynamic> vault, String code) async {
  _checkVersion(vault);
  final normalized = normalizeRecoveryCode(code);
  if (normalized == null) throw const VaultLocked('recovery');
  final rc = vault['recovery'] as Map<String, dynamic>;
  final key = await _recoveryKey(normalized, _unb64(rc['salt'] as String));
  try {
    final seeds = await _open(key, vault['by_recovery'] as Map<String, dynamic>,
        _vaultAad('rc', vault));
    return await _keysFrom(seeds, vault);
  } on SecretBoxAuthenticationError {
    throw const VaultLocked('recovery');
  }
}

/// New password (and a new recovery code) for the same keys, e.g. after using the code.
Future<VaultSetup> rekeyVault(PersonalKeys keys, String newPassword,
    {KdfParams kdf = const KdfParams()}) async {
  if (newPassword.length < minPasswordLength) {
    throw ArgumentError('password shorter than $minPasswordLength characters');
  }
  final code = newRecoveryCode();
  return VaultSetup(
      await _buildVault(keys, newPassword, code, kdf), keys, code);
}

// --- space keys -----------------------------------------------------------------------------

/// A space's AES-256 key.
class SpaceKey {
  SpaceKey(List<int> bytes) : bytes = Uint8List.fromList(bytes) {
    if (bytes.length != 32) throw ArgumentError('space key must be 32 bytes');
  }
  factory SpaceKey.generate() => SpaceKey(randomBytes(32));
  final Uint8List bytes;
}

List<int> _wrapInfo(String spaceId, String memberId, int generation) =>
    utf8.encode('paperless-spacekey-v1|$spaceId|$memberId|$generation');

/// Wraps [key] so only the holder of [memberBoxPublic] can open it.
Future<Map<String, dynamic>> wrapSpaceKey(
    SpaceKey key, List<int> memberBoxPublic,
    {required String spaceId,
    required String memberId,
    int generation = 1}) async {
  final eph = await _x25519.newKeyPair();
  final ephPub = (await eph.extractPublicKey()).bytes;
  final shared = await _x25519.sharedSecretKey(
      keyPair: eph,
      remotePublicKey:
          SimplePublicKey(memberBoxPublic, type: KeyPairType.x25519));
  final info = _wrapInfo(spaceId, memberId, generation);
  final kek =
      await _hkdf.deriveKey(secretKey: shared, nonce: ephPub, info: info);
  return {
    'g': generation,
    'e': _b64(ephPub),
    ...await _seal(kek, key.bytes, info)
  };
}

Future<SpaceKey> unwrapSpaceKey(Map<String, dynamic> wrapped, PersonalKeys me,
    {required String spaceId, required String memberId}) async {
  final ephPub = _unb64(wrapped['e'] as String);
  final shared = await _x25519.sharedSecretKey(
      keyPair: me.boxKeyPair,
      remotePublicKey: SimplePublicKey(ephPub, type: KeyPairType.x25519));
  final info = _wrapInfo(spaceId, memberId, wrapped['g'] as int);
  final kek =
      await _hkdf.deriveKey(secretKey: shared, nonce: ephPub, info: info);
  try {
    return SpaceKey(await _open(kek, wrapped, info));
  } on SecretBoxAuthenticationError {
    throw const CryptoFailure('space key');
  }
}

// --- documents ------------------------------------------------------------------------------

/// Encrypts a file or metadata record of a space. [context] binds the ciphertext to its
/// place (e.g. `doc/<id>/v1`), so files cannot be swapped between documents unnoticed.
Future<Uint8List> encryptForSpace(
    SpaceKey key, List<int> clear, String context) async {
  final box = await _aes.encrypt(clear,
      secretKey: SecretKey(key.bytes),
      nonce: randomBytes(12),
      aad: utf8.encode(context));
  return Uint8List.fromList(
      [...magic, ...box.nonce, ...box.cipherText, ...box.mac.bytes]);
}

Future<Uint8List> decryptForSpace(
    SpaceKey key, List<int> data, String context) async {
  if (data.length < magic.length + 12 + 16 || !_startsWith(data, magic)) {
    throw const CryptoFailure('format');
  }
  final body = data.sublist(magic.length);
  try {
    return Uint8List.fromList(await _aes.decrypt(
        SecretBox(body.sublist(12, body.length - 16),
            nonce: body.sublist(0, 12),
            mac: Mac(body.sublist(body.length - 16))),
        secretKey: SecretKey(key.bytes),
        aad: utf8.encode(context)));
  } on SecretBoxAuthenticationError {
    throw const CryptoFailure('document');
  }
}

/// File header of encrypted Drive objects ("PAIDRV1" + NUL).
const magic = [0x50, 0x41, 0x49, 0x44, 0x52, 0x56, 0x31, 0x00];

bool _startsWith(List<int> data, List<int> prefix) {
  for (var i = 0; i < prefix.length; i++) {
    if (data[i] != prefix[i]) {
      return false;
    }
  }
  return true;
}
