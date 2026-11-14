"""Content blob storage.

`LocalBlobStore` keeps blobs as read-only files under opaque, server-generated keys.
It stores PLAINTEXT and therefore refuses to start unless explicitly allowed, and never in
production. Encrypted storage replaces it once the key design in docs/SECURITY.md is approved;
the interface (put / open / discard) is meant to stay the same.
"""

from __future__ import annotations

import os
import re
import stat
import uuid
from pathlib import Path
from typing import BinaryIO

_KEY_RE = re.compile(r"^[0-9a-f]{32}$")


class UnencryptedStorageNotAllowed(RuntimeError):
    pass


class BlobStore:
    def put(self, staged_path: Path) -> str:  # pragma: no cover - interface
        raise NotImplementedError

    def open(self, key: str) -> BinaryIO:  # pragma: no cover - interface
        raise NotImplementedError

    def local_path(self, key: str) -> Path:  # pragma: no cover - interface
        raise NotImplementedError

    def discard(self, key: str) -> None:  # pragma: no cover - interface
        raise NotImplementedError


class LocalBlobStore(BlobStore):
    def __init__(self, root: Path, *, allow_unencrypted: bool, app_env: str) -> None:
        if app_env == "production" or not allow_unencrypted:
            raise UnencryptedStorageNotAllowed(
                "LocalBlobStore stores plaintext; set ALLOW_UNENCRYPTED_STORAGE=true for "
                "development with synthetic documents only. Never in production."
            )
        self.root = Path(root)
        (self.root / "blobs").mkdir(parents=True, exist_ok=True, mode=0o700)

    def _path(self, key: str) -> Path:
        if not _KEY_RE.fullmatch(key):
            raise ValueError("invalid storage key")
        return self.root / "blobs" / key[:2] / key

    def put(self, staged_path: Path) -> str:
        """Promote a staged file. Blobs are write-once: an existing key is never replaced."""
        key = uuid.uuid4().hex
        target = self._path(key)
        target.parent.mkdir(exist_ok=True, mode=0o700)
        # link() fails if the target exists -> no silent overwrite, then drop the staging name.
        os.link(staged_path, target)
        os.unlink(staged_path)
        os.chmod(target, stat.S_IRUSR | stat.S_IRGRP)
        return key

    def open(self, key: str) -> BinaryIO:
        return self._path(key).open("rb")

    def local_path(self, key: str) -> Path:
        return self._path(key)

    def discard(self, key: str) -> None:
        """Only for blobs whose database transaction failed. Committed versions are immutable."""
        path = self._path(key)
        if path.exists():
            os.chmod(path, stat.S_IRUSR | stat.S_IWUSR)
            path.unlink()
