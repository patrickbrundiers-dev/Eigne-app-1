import 'dart:io';

import 'package:local_auth/local_auth.dart';
import 'package:path_provider/path_provider.dart';

import '../core/app_lock.dart';

/// Where the lock settings live: a file in the app's private folder, outside the database,
/// so exports, backups and restores never carry or change the PIN.
abstract class LockStore {
  Future<LockConfig> read();
  Future<void> write(LockConfig c);
}

class FileLockStore implements LockStore {
  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}${Platform.pathSeparator}applock.json');
  }

  @override
  Future<LockConfig> read() async {
    final f = await _file();
    if (!await f.exists()) return const LockConfig();
    return LockConfig.parse(await f.readAsString());
  }

  @override
  Future<void> write(LockConfig c) async {
    final f = await _file();
    await f.parent.create(recursive: true);
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(c.toJsonString(), flush: true);
    await tmp.rename(f.path);
  }
}

class MemoryLockStore implements LockStore {
  MemoryLockStore([this.config = const LockConfig()]);
  LockConfig config;
  @override
  Future<LockConfig> read() async => config;
  @override
  Future<void> write(LockConfig c) async => config = c;
}

/// Fingerprint / face / Windows Hello. Replaceable in tests.
abstract class Biometrics {
  Future<bool> available();
  Future<bool> authenticate();
}

class DeviceBiometrics implements Biometrics {
  final _auth = LocalAuthentication();

  @override
  Future<bool> available() async {
    try {
      return await _auth.isDeviceSupported() && await _auth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(localizedReason: 'Sattly entsperren', biometricOnly: true);
    } catch (_) {
      return false;
    }
  }
}

LockStore Function() lockStoreFactory = FileLockStore.new;
Biometrics Function() biometricsFactory = DeviceBiometrics.new;
