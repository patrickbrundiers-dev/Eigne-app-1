"""Builds the blob store from settings."""

from __future__ import annotations

from pathlib import Path

from paperless_api.config import Settings
from paperless_api.documents import crypto
from paperless_api.documents.blobstore import (
    BlobStore,
    EncryptedBlobStore,
    LocalBlobStore,
    UnencryptedStorageNotAllowed,
)


class StorageNotConfigured(RuntimeError):
    pass


def load_keyring(settings: Settings) -> crypto.KeyRing | None:
    current = settings.storage_master_key
    if settings.storage_master_key_file:
        current = Path(settings.storage_master_key_file).read_text(encoding="utf-8").strip()
    if not current:
        return None
    old = [
        crypto.MasterKey.from_b64(k)
        for k in (settings.storage_old_master_keys or "").split(",")
        if k.strip()
    ]
    return crypto.KeyRing(crypto.MasterKey.from_b64(current), old)


def build_blob_store(settings: Settings) -> BlobStore:
    keyring = load_keyring(settings)
    root = Path(settings.storage_dir)
    if keyring is not None:
        return EncryptedBlobStore(root, keyring)
    try:
        return LocalBlobStore(
            root,
            allow_unencrypted=settings.allow_unencrypted_storage,
            app_env=settings.app_env,
        )
    except UnencryptedStorageNotAllowed as exc:
        raise StorageNotConfigured(str(exc)) from exc
