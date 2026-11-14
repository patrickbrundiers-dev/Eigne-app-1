"""File type detection from content (magic bytes), never from the filename.

Only an explicit allowlist is accepted. Everything else is rejected, including types that
browsers or viewers would happily open (HTML, SVG, Office files, archives, executables).
"""

from __future__ import annotations

from dataclasses import dataclass

from paperless_api.documents.errors import UnsupportedFileType

# Bytes needed to identify every allowed type.
SNIFF_BYTES = 16


@dataclass(frozen=True, slots=True)
class FileKind:
    mime_type: str
    extension: str
    is_pdf: bool = False
    is_image: bool = False


PDF = FileKind("application/pdf", "pdf", is_pdf=True)
PNG = FileKind("image/png", "png", is_image=True)
JPEG = FileKind("image/jpeg", "jpg", is_image=True)
TIFF = FileKind("image/tiff", "tif", is_image=True)
WEBP = FileKind("image/webp", "webp", is_image=True)

ALLOWED: tuple[FileKind, ...] = (PDF, PNG, JPEG, TIFF, WEBP)


def detect_kind(head: bytes) -> FileKind:
    """Return the file kind for the first bytes of a file or raise UnsupportedFileType."""
    # PDF: the spec allows the header within the first 1024 bytes, but leading junk is a
    # classic polyglot trick. We require it at offset 0.
    if head.startswith(b"%PDF-"):
        return PDF
    if head.startswith(b"\x89PNG\r\n\x1a\n"):
        return PNG
    if head.startswith(b"\xff\xd8\xff"):
        return JPEG
    if head.startswith((b"II*\x00", b"MM\x00*")):
        return TIFF
    if len(head) >= 12 and head[:4] == b"RIFF" and head[8:12] == b"WEBP":
        return WEBP
    raise UnsupportedFileType("file type is not supported (allowed: PDF, PNG, JPEG, TIFF, WebP)")
