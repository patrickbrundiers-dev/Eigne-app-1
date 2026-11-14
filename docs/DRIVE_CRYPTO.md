# Client-side keys for the serverless Drive mode (D1, part 1)

Plan: [Plan: Paperless AI ohne Server über Google Drive](https://claude.ai/artifact/2T9qB6ZTYTXLBdgwjq74RB).
Code: `apps/client/lib/src/vault/vault.dart`, tests: `apps/client/test/vault_test.dart`.
Library: [`cryptography`](https://pub.dev/packages/cryptography) (Dart).

## Personal keys and vault

| Item | Algorithm | Where it lives |
| --- | --- | --- |
| Encryption key pair | X25519 from a random 32-byte seed | Seed only inside the vault |
| Signing key pair | Ed25519 from a random 32-byte seed | Seed only inside the vault |
| Vault | Both seeds encrypted twice with AES-256-GCM | The person's own Drive `appDataFolder` |
| Password key | Argon2id, 19 MiB, 2 passes, 16-byte salt (OWASP minimum) | Derived on unlock, never stored |
| Recovery key | HKDF-SHA256 of a 25-character code (125 bits) | Code printed once, never stored |

- The AAD of each sealed copy binds it to the vault version, its kind (`pw`/`rc`) and both
  public keys. After unlocking, the public keys are re-derived and compared, so a vault
  with a swapped public key is rejected.
- Passwords need at least 10 characters. `rekeyVault` sets a new password and a new
  recovery code for the same keys (after the code was used, or to change the password).
- Measured on the CI-class Linux VM: create about 0.5 s, unlock about 0.2 s.

## Space keys

- Each space has a random AES-256 key.
- It is wrapped per member as a sealed box: an ephemeral X25519 key, HKDF-SHA256 with
  info `paperless-spacekey-v1|<space>|<member>|<generation>`, then AES-256-GCM with the same
  info as AAD. A wrapped key therefore cannot be reused for another space, member or key
  generation.
- When a member is removed, the space gets a new key with a higher generation for future
  documents (D3).

## Documents

`encryptForSpace(key, bytes, context)` produces `PAIDRV1\0 | nonce(12) | ciphertext | tag(16)`.
`context` (for example `doc/<id>/v1`, `meta/<id>`) is the AAD, so files cannot be swapped
between documents unnoticed. Files are encrypted in memory; streaming for very large files
follows with D2 if needed.

## Signatures

The family list (members, roles, public keys) is signed with the admin's Ed25519 key, so
nobody with write access to the shared folder can add themselves or change roles (D3).
