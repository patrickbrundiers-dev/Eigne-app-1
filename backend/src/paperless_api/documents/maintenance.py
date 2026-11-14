"""Maintenance on stored blobs: encrypt old plaintext files and rotate master keys."""

from __future__ import annotations

from paperless_api.documents import crypto
from paperless_api.documents.blobstore import EncryptedBlobStore


def encrypt_and_rotate(store: EncryptedBlobStore) -> dict[str, int]:
    """Bring every stored file to the current master key.

    - plaintext files (from development with LocalBlobStore) are encrypted,
    - files under an old master key are re-encrypted with the current one,
    - each file is replaced atomically and verified before replacement.
    Safe to run repeatedly; returns counts per outcome.
    """
    report = {"encrypted": 0, "rotated": 0, "unchanged": 0}
    for _name, path, context in store.iter_blob_paths():
        raw = path.read_bytes()
        if not crypto.is_encrypted(raw):
            new = crypto.encrypt(raw, store.keyring, context)
            outcome = "encrypted"
        else:
            new = crypto.reencrypt(raw, store.keyring, context)
            outcome = "unchanged" if new is raw else "rotated"
        if new is not raw:
            # Verify before replacing: a failure here leaves the old file untouched.
            if crypto.decrypt(new, crypto.KeyRing(store.keyring.current), context) != (
                raw if outcome == "encrypted" else crypto.decrypt(raw, store.keyring, context)
            ):
                raise crypto.DecryptionFailed("verification failed")  # pragma: no cover
            store.replace_file(path, new)
        report[outcome] += 1
    return report
