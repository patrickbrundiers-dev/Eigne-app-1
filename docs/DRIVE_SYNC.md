# Document library on Google Drive (D2, without the Google connection yet)

Plan: [Plan: Paperless AI ohne Server über Google Drive](https://claude.ai/artifact/2T9qB6ZTYTXLBdgwjq74RB).
Code: `apps/client/lib/src/drive/`, tests: `apps/client/test/drive_library_test.dart`.
Keys and formats: [DRIVE_CRYPTO.md](DRIVE_CRYPTO.md).

The real Google Drive client follows once the Google Cloud project exists
([GOOGLE_SETUP.de.md](GOOGLE_SETUP.de.md)). Until then `FakeDrive` stands in for it.

## Layout in the family folder `Paperless AI`

```
manifest/<n>.json                   signed family manifest; highest valid n wins
spaces/<space>/files/<doc>-v1       encrypted document (context doc/<doc>/v1)
spaces/<space>/log/<device>-<seq>-<rand>   one encrypted change entry per file
```

- Devices only ever **create** files. Nothing is overwritten, so two devices cannot clobber
  each other, and Drive's own version history is not needed.
- **Manifest:** members (name, role, public keys), spaces (type, encrypted name, writers,
  space key wrapped per member). It is signed with the admin's Ed25519 key. Devices pin the
  admin key they saw first and ignore manifests with another key, so someone with write
  access to the folder cannot add themselves.
- **Log entries** (`add`, `rename`, `delete`) are encrypted with the space key and bound to
  their file name. Entries that do not decrypt are skipped for good.
- **State:** every device replays all entries of its readable spaces in one global order
  (time, then file name). All devices therefore reach the same titles and tombstones. For
  concurrent renames the later one wins.
- Decrypted entries are cached on the device; a sync downloads only new entries.

## Uploads

Checked on the device before anything is written: supported type by magic bytes (PDF, PNG,
JPEG, TIFF, WebP), not empty, at most 100 MB, no duplicate (SHA-256) in the same space. The
same German error messages as the server are used (`ApiException` codes).

## Sync engine

`SyncEngine` now talks to a `RemoteLibrary`: the server's `ApiClient` or the new
`DriveLibrary`. Offline cache and upload queue from v0.8.0 work unchanged on Drive.

## Not yet

Google sign-in and the real Drive client (D1/D2 with Google), family invitations and
per-member Drive permissions (D3), previews rendered on the device, streaming encryption for
very large files.
