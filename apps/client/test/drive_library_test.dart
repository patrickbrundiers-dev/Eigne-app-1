import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:paperless_ai/src/api/models.dart';
import 'package:paperless_ai/src/drive/drive_library.dart';
import 'package:paperless_ai/src/drive/drive_store.dart';
import 'package:paperless_ai/src/import/document_picker.dart';
import 'package:paperless_ai/src/sync/local_store.dart';
import 'package:paperless_ai/src/sync/sync_engine.dart';
import 'package:paperless_ai/src/vault/vault.dart';

final _pdf = utf8.encode('%PDF-1.7\nsynthetic Stromrechnung 2026 test\n%%EOF');
final _png = [0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a, 1, 2, 3];

/// Clock that moves one second per call, so log order is deterministic.
DateTime Function() _ticker([int start = 0]) {
  var t = DateTime.utc(2026, 11, 14, 12).add(Duration(seconds: start));
  return () => t = t.add(const Duration(seconds: 1));
}

Future<DocumentInfo> _upload(DriveLibrary lib, String space, List<int> bytes,
        {String name = 'Stromrechnung.pdf'}) =>
    lib.upload(
        spaceId: space,
        filename: name,
        length: bytes.length,
        content: Stream.value(bytes));

class _Setup {
  _Setup(this.drive, this.keys, this.pc);
  final FakeDrive drive;
  final PersonalKeys keys;
  final DriveLibrary pc;

  String space(String name) => pc.spaces.firstWhere((s) => s.name == name).id;

  Future<DriveLibrary> phone({DateTime Function()? clock}) => DriveLibrary.open(
        drive: drive,
        me: keys,
        memberId: pc.memberId,
        deviceId: 'phone',
        local: MemoryLocalStore(),
        trustedAdminSignPub: keys.signPublic,
        clock: clock ?? _ticker(1000),
      );
}

Future<_Setup> _family() async {
  final drive = FakeDrive();
  final keys = await PersonalKeys.generate();
  final pc = await DriveLibrary.createFamily(
    drive: drive,
    me: keys,
    displayName: 'Patrick',
    deviceId: 'pc',
    local: MemoryLocalStore(),
    clock: _ticker(),
  );
  return _Setup(drive, keys, pc);
}

void main() {
  test('new family has the default spaces with write access', () async {
    final f = await _family();
    expect(f.pc.spaces.map((s) => s.name), ['Haushalt', 'Privat']);
    expect(f.pc.spaces.every((s) => s.canWrite), isTrue);
  });

  test('a second device of the same person sees uploads after sync', () async {
    final f = await _family();
    final doc = await _upload(f.pc, f.space('Haushalt'), _pdf);
    expect(doc.title, 'Stromrechnung');
    expect(doc.mimeType, 'application/pdf');

    final phone = await f.phone();
    final page = await phone.sync();
    expect(page.spaces.map((s) => s.name), ['Haushalt', 'Privat']);
    expect(page.documents.single.title, 'Stromrechnung');
    expect(await phone.download(doc.id), _pdf);
  });

  test('renames and deletes travel between devices, later change wins',
      () async {
    final f = await _family();
    final doc = await _upload(f.pc, f.space('Haushalt'), _pdf);
    final phone = await f.phone(clock: _ticker(5000)); // phone acts later
    await phone.sync();

    await f.pc.rename(doc.id, 'Strom PC');
    await phone.rename(doc.id, 'Strom Handy');
    final onPc = (await f.pc.sync()).documents.single;
    final onPhone = (await phone.sync()).documents.single;
    expect(onPc.title, 'Strom Handy');
    expect(onPhone.title, 'Strom Handy');
    expect(onPc.revision, onPhone.revision);

    await f.pc.delete(doc.id);
    final after = (await phone.sync()).documents.single;
    expect(after.deleted, isTrue);
  });

  test('only new log entries are downloaded on the next sync', () async {
    final f = await _family();
    await _upload(f.pc, f.space('Haushalt'), _pdf);
    final phone = await f.phone();
    await phone.sync();
    final before = f.drive.reads;
    await phone.sync();
    expect(
        f.drive.reads - before, 1); // only the manifest, no log entries again
  });

  test('nothing readable is stored in Drive', () async {
    final f = await _family();
    await _upload(f.pc, f.space('Privat'), _pdf, name: 'Gehaltsabrechnung.pdf');
    for (final bytes in f.drive.allContent) {
      final text = latin1.decode(bytes);
      expect(text, isNot(contains('Stromrechnung')));
      expect(text, isNot(contains('Gehaltsabrechnung')));
      expect(text, isNot(contains('Privat')));
      expect(text, isNot(contains('Haushalt')));
    }
    for (final file in f.drive.allFiles) {
      expect(file.name, isNot(contains('Gehalt')));
    }
  });

  test('a manifest forged by another folder writer is ignored', () async {
    final f = await _family();
    final eve = await PersonalKeys.generate();
    final manifests = (await f.drive.find(
        (await f.drive.find(DriveStore.root, familyFolderName))!.id,
        'manifest'))!;
    final forged = {
      'v': 1,
      'n': 99,
      'admin': 'eve',
      'admin_sign_pub': base64Url.encode(eve.signPublic).replaceAll('=', ''),
      'members': {},
      'spaces': {},
    };
    final sig = await eve.sign(utf8.encode(canonicalJson(forged)));
    await f.drive.createFile(manifests.id, '00000099.json',
        utf8.encode(jsonEncode({...forged, 'sig': base64Url.encode(sig)})));

    final phone = await f.phone();
    final page = await phone.sync();
    expect(page.spaces.map((s) => s.name), ['Haushalt', 'Privat']);
  });

  test('a tampered log entry is skipped, the rest still syncs', () async {
    final f = await _family();
    final good = await _upload(f.pc, f.space('Haushalt'), _pdf);
    final root = (await f.drive.find(DriveStore.root, familyFolderName))!;
    final spaces = (await f.drive.find(root.id, 'spaces'))!;
    final space = (await f.drive.find(spaces.id, f.space('Haushalt')))!;
    final log = (await f.drive.find(space.id, 'log'))!;
    await f.drive.createFile(
        log.id, 'evil-0000000001-xxxxxx', [...magic, ...List.filled(40, 7)]);

    final page = await (await f.phone()).sync();
    expect(page.documents.map((d) => d.id), [good.id]);
  });

  test('uploads are checked: type, empty, duplicates', () async {
    final f = await _family();
    final space = f.space('Haushalt');
    await expectLater(
        _upload(f.pc, space, utf8.encode('MZ executable')),
        throwsA(isA<ApiException>()
            .having((e) => e.code, 'code', 'unsupported_type')));
    await expectLater(
        _upload(f.pc, space, []),
        throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'empty_file')));
    await _upload(f.pc, space, _png, name: 'Foto.png');
    await expectLater(
        _upload(f.pc, space, _png, name: 'nochmal.png'),
        throwsA(
            isA<ApiException>().having((e) => e.code, 'code', 'duplicate')));
    // the same file in another space is fine
    await _upload(f.pc, f.space('Privat'), _png, name: 'Foto.png');
  });

  test('the family folder can only be created once', () async {
    final f = await _family();
    await expectLater(
        DriveLibrary.createFamily(
            drive: f.drive,
            me: f.keys,
            displayName: 'X',
            deviceId: 'x',
            local: MemoryLocalStore()),
        throwsStateError);
  });

  test('sync engine works on top of Drive, including the offline queue',
      () async {
    final f = await _family();
    final phone = await f.phone();
    final engine = SyncEngine(MemoryLocalStore());
    await engine.load('drive');
    engine.adopt('drive',
        const UserInfo(id: 'p', email: 'p@example.test', displayName: 'P'));

    f.drive.offline = true;
    await engine.enqueue(
        PickedDocument(
            name: 'Scan.pdf',
            length: _pdf.length,
            open: () => Stream.value(_pdf)),
        f.space('Haushalt'));
    await expectLater(engine.sync(phone), throwsA(isA<ConnectionFailed>()));
    expect(engine.queue, hasLength(1));

    f.drive.offline = false;
    await engine.sync(phone);
    expect(engine.queue, isEmpty);
    expect(engine.documentsIn(f.space('Haushalt')).single.title, 'Scan');

    final onPc = await f.pc.sync();
    expect(onPc.documents.single.title, 'Scan');
  });
}
