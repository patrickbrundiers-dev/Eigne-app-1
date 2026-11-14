"""Import staging area.

Uploads are streamed into a private staging directory while the SHA-256 and size are
computed. Nothing in staging is trusted or visible to users; a staged file is either
promoted into the blob store or deleted.
"""

from __future__ import annotations

import hashlib
import os
import uuid
from collections.abc import Iterator
from contextlib import contextmanager
from dataclasses import dataclass
from pathlib import Path
from typing import BinaryIO

from paperless_api.documents.detection import SNIFF_BYTES
from paperless_api.documents.errors import EmptyFile, FileTooLarge

CHUNK = 1024 * 1024


@dataclass(frozen=True, slots=True)
class StagedFile:
    path: Path
    sha256: str
    size_bytes: int
    head: bytes  # first bytes, for type detection


class StagingArea:
    def __init__(self, root: Path) -> None:
        self.root = Path(root)
        self.root.mkdir(parents=True, exist_ok=True, mode=0o700)

    @contextmanager
    def receive(self, stream: BinaryIO, max_bytes: int) -> Iterator[StagedFile]:
        """Stream `stream` into staging. The staged file is deleted when the context exits,
        unless it was moved away (promoted) in the meantime."""
        path = self.root / f"{uuid.uuid4().hex}.part"
        digest = hashlib.sha256()
        size = 0
        head = b""
        fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL | getattr(os, "O_BINARY", 0), 0o600)
        try:
            with os.fdopen(fd, "wb") as out:
                while chunk := stream.read(CHUNK):
                    size += len(chunk)
                    if size > max_bytes:
                        raise FileTooLarge(f"file exceeds the limit of {max_bytes} bytes")
                    if len(head) < SNIFF_BYTES:
                        head += chunk[: SNIFF_BYTES - len(head)]
                    digest.update(chunk)
                    out.write(chunk)
                out.flush()
                os.fsync(out.fileno())
            if size == 0:
                raise EmptyFile("file is empty")
            yield StagedFile(path=path, sha256=digest.hexdigest(), size_bytes=size, head=head)
        finally:
            path.unlink(missing_ok=True)
