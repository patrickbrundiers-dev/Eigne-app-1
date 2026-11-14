"""Content blob storage.

Blobs are write-once files under opaque, server-generated keys:
`<root>/blobs/<k[:2]>/<key>`. Derived data (preview images) lives under `<root>/derived/`.

- `EncryptedBlobStore` (default): every blob and preview is encrypted with AES-256-GCM
  (see crypto.py and docs/STORAGE_ENCRYPTION.md).
- `LocalBlobStore`: PLAINTEXT, for development with synthetic documents only. It must be
  enabled explicitly and is refused in production.
"""

from __future__ import annotations

import os
import re
import stat
import tempfile
import uuid
from collections.abc import Iterator
from contextlib import contextmanager
from pathlib import Path

from paperless_api.documents import crypto

_KEY_RE = re.compile(r"^[0-9a-f]{32}$")
_DERIVED_RE = re.compile(r"^[0-9a-z_.-]{1,80}$")
_READ_ONLY = stat.S_IRUSR | stat.S_IRGRP


class UnencryptedStorageNotAllowed(RuntimeError):
    pass


class BlobStore:
    """Common file layout. Subclasses decide how bytes are sealed on disk."""

    def __init__(self, root: Path) -> None:
        self.root = Path(root)
        for sub in ("blobs", "derived", "tmp"):
            (self.root / sub).mkdir(parents=True, exist_ok=True, mode=0o700)

    # --- sealing (overridden) --------------------------------------------------------------

    def _seal(self, data: bytes, context: bytes) -> bytes:
        raise NotImplementedError  # pragma: no cover

    def _unseal(self, data: bytes, context: bytes) -> bytes:
        raise NotImplementedError  # pragma: no cover

    # --- paths -----------------------------------------------------------------------------

    def _path(self, key: str) -> Path:
        if not _KEY_RE.fullmatch(key):
            raise ValueError("invalid storage key")
        return self.root / "blobs" / key[:2] / key

    def _derived_path(self, name: str) -> Path:
        if not _DERIVED_RE.fullmatch(name) or ".." in name:
            raise ValueError("invalid derived name")
        return self.root / "derived" / name

    @staticmethod
    def _write_once(target: Path, data: bytes) -> None:
        target.parent.mkdir(exist_ok=True, mode=0o700)
        fd, tmp = tempfile.mkstemp(dir=target.parent, prefix=".tmp-")
        try:
            with os.fdopen(fd, "wb") as f:
                f.write(data)
                f.flush()
                os.fsync(f.fileno())
            os.link(tmp, target)  # fails if target exists -> never overwrites
        finally:
            os.unlink(tmp)
        os.chmod(target, _READ_ONLY)

    # --- public API ------------------------------------------------------------------------

    def put(self, staged_path: Path) -> str:
        """Store a staged file under a new key and delete the staged copy."""
        key = uuid.uuid4().hex
        data = Path(staged_path).read_bytes()
        self._write_once(self._path(key), self._seal(data, b"blob|" + key.encode()))
        os.unlink(staged_path)
        return key

    def read(self, key: str) -> bytes:
        return self._unseal(self._path(key).read_bytes(), b"blob|" + key.encode())

    @contextmanager
    def materialize(self, key: str) -> Iterator[Path]:
        """Plaintext copy in a private temp file, e.g. for the preview renderer.
        Deleted when the context exits."""
        fd, tmp = tempfile.mkstemp(dir=self.root / "tmp", prefix="m-")
        try:
            with os.fdopen(fd, "wb") as f:
                f.write(self.read(key))
            yield Path(tmp)
        finally:
            Path(tmp).unlink(missing_ok=True)

    def discard(self, key: str) -> None:
        """Only for blobs whose database transaction failed. Committed versions are immutable."""
        path = self._path(key)
        if path.exists():
            os.chmod(path, stat.S_IRUSR | stat.S_IWUSR)
            path.unlink()

    def put_derived(self, name: str, data: bytes) -> None:
        path = self._derived_path(name)
        if not path.exists():
            try:
                self._write_once(path, self._seal(data, b"derived|" + name.encode()))
            except FileExistsError:
                pass  # a concurrent request wrote the same derived data

    def get_derived(self, name: str) -> bytes | None:
        path = self._derived_path(name)
        if not path.exists():
            return None
        return self._unseal(path.read_bytes(), b"derived|" + name.encode())

    def iter_blob_paths(self) -> Iterator[tuple[str, Path, bytes]]:
        """(name, path, context) for every stored file, for maintenance commands."""
        for p in sorted((self.root / "blobs").glob("*/*")):
            if _KEY_RE.fullmatch(p.name):
                yield p.name, p, b"blob|" + p.name.encode()
        for p in sorted((self.root / "derived").iterdir()):
            if _DERIVED_RE.fullmatch(p.name):
                yield p.name, p, b"derived|" + p.name.encode()

    @staticmethod
    def replace_file(path: Path, data: bytes) -> None:
        """Atomically replace a stored file (maintenance only: encryption / key rotation)."""
        fd, tmp = tempfile.mkstemp(dir=path.parent, prefix=".tmp-")
        with os.fdopen(fd, "wb") as f:
            f.write(data)
            f.flush()
            os.fsync(f.fileno())
        os.chmod(tmp, _READ_ONLY)
        os.replace(tmp, path)


class EncryptedBlobStore(BlobStore):
    def __init__(self, root: Path, keyring: crypto.KeyRing) -> None:
        super().__init__(root)
        self.keyring = keyring

    def _seal(self, data: bytes, context: bytes) -> bytes:
        return crypto.encrypt(data, self.keyring, context)

    def _unseal(self, data: bytes, context: bytes) -> bytes:
        return crypto.decrypt(data, self.keyring, context)


class LocalBlobStore(BlobStore):
    def __init__(self, root: Path, *, allow_unencrypted: bool, app_env: str) -> None:
        if app_env == "production" or not allow_unencrypted:
            raise UnencryptedStorageNotAllowed(
                "LocalBlobStore stores plaintext; configure STORAGE_MASTER_KEY instead, or set "
                "ALLOW_UNENCRYPTED_STORAGE=true for development with synthetic documents only."
            )
        super().__init__(root)

    def _seal(self, data: bytes, context: bytes) -> bytes:
        return data

    def _unseal(self, data: bytes, context: bytes) -> bytes:
        if crypto.is_encrypted(data):
            raise crypto.DecryptionFailed("blob is encrypted; configure STORAGE_MASTER_KEY")
        return data
