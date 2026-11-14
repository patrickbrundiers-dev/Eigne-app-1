# Storage encryption (encryption at rest)

Status: implemented (`backend/src/paperless_api/documents/crypto.py`, `blobstore.py`).

## What is encrypted
Every stored original and every cached preview image. Metadata in the database (titles,
file names, sizes, SHA-256) is **not** encrypted yet; protect the database with disk or
volume encryption.

## How
Envelope encryption with AES-256-GCM from the `cryptography` library:
- each file gets a fresh random 256-bit data key and a random 96-bit nonce,
- the data key is wrapped with the **master key** (also AES-256-GCM),
- the ciphertext is bound to its storage key (AAD), so files can't be swapped on disk,
- any change to a file (one flipped bit) makes decryption fail instead of returning wrong data.

## What it protects / what not
| Scenario | Protected? |
|---|---|
| Stolen disk, NAS, backup or cloud snapshot of `STORAGE_DIR` | yes, without the master key the files are unreadable |
| Someone with a copy of `STORAGE_DIR` **and** the master key | no |
| Someone controlling the running server | no: the server needs plaintext for previews (and later OCR) |

End-to-end encryption (server can never read documents) is a separate decision for the
sync phase. Plaintext exists briefly in `STORAGE_DIR/staging` (upload checks) and
`STORAGE_DIR/tmp` (preview rendering) and is deleted right after; put these on `tmpfs` if
possible.

## Setup
```bash
paperless-admin generate-key > /etc/paperless/master.key   # keep a copy offline!
chmod 600 /etc/paperless/master.key
export STORAGE_MASTER_KEY_FILE=/etc/paperless/master.key    # or STORAGE_MASTER_KEY=<key>
```
**If the master key is lost, all documents are lost.** Store a copy separately from the
backups (e.g. printed in a safe, or in a password manager).

With a master key set, `ALLOW_UNENCRYPTED_STORAGE` is ignored. Without a key the server
refuses to store documents unless `ALLOW_UNENCRYPTED_STORAGE=true` in development.

## Encrypting existing plaintext files
After setting the master key on a server that was used without one:
```bash
paperless-admin encrypt-storage
```
Each file is encrypted, verified, and replaced atomically. Safe to run repeatedly.

## Key rotation
1. `paperless-admin generate-key` → new key.
2. Set the new key as `STORAGE_MASTER_KEY(_FILE)` and the old one in
   `STORAGE_OLD_MASTER_KEYS` (comma-separated). Both keys now decrypt.
3. `paperless-admin encrypt-storage` re-encrypts every file under the new key.
4. Remove the old key from `STORAGE_OLD_MASTER_KEYS`.
