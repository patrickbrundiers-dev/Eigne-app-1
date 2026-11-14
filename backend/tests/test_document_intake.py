"""Unit tests for detection, staging, inspection, blob store and preview."""

import io
import os
import stat
from pathlib import Path

import pytest
from PIL import Image

from paperless_api.documents import detection
from paperless_api.documents.blobstore import LocalBlobStore, UnencryptedStorageNotAllowed
from paperless_api.documents.errors import (
    ActiveContent,
    EmptyFile,
    EncryptedPdf,
    FileTooLarge,
    ImageTooLarge,
    MalformedFile,
    PreviewFailed,
    TooManyPages,
    UnsupportedFileType,
)
from paperless_api.documents.inspection import Limits, inspect_file
from paperless_api.documents.preview import render_preview
from paperless_api.documents.service import sanitize_filename
from paperless_api.documents.staging import StagingArea
from tests.fixtures import make_image, make_pdf, make_pdf_with_launch_action

# --- detection -----------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("data", "mime"),
    [
        (make_pdf(), "application/pdf"),
        (make_image("PNG"), "image/png"),
        (make_image("JPEG"), "image/jpeg"),
        (make_image("TIFF"), "image/tiff"),
        (make_image("WEBP"), "image/webp"),
    ],
)
def test_detects_allowed_types_by_content(data: bytes, mime: str) -> None:
    assert detection.detect_kind(data[: detection.SNIFF_BYTES]).mime_type == mime


@pytest.mark.parametrize(
    "data",
    [
        b"MZ\x90\x00 windows executable",
        b"\x7fELF linux executable",
        b"PK\x03\x04 zip or docx",
        b"<html><script>alert(1)</script>",
        b"<?xml version='1.0'?><svg/>",
        b"   %PDF-1.7 leading junk polyglot",
        b"plain text",
    ],
)
def test_rejects_everything_else(data: bytes) -> None:
    with pytest.raises(UnsupportedFileType):
        detection.detect_kind(data[: detection.SNIFF_BYTES])


# --- staging -------------------------------------------------------------------------------


def test_staging_hashes_and_cleans_up(tmp_path: Path) -> None:
    import hashlib

    staging = StagingArea(tmp_path / "staging")
    data = b"%PDF-" + os.urandom(3 * 1024 * 1024)
    with staging.receive(io.BytesIO(data), max_bytes=10 * 1024 * 1024) as staged:
        assert staged.sha256 == hashlib.sha256(data).hexdigest()
        assert staged.size_bytes == len(data)
        assert staged.head.startswith(b"%PDF-")
        assert staged.path.exists()
    assert list((tmp_path / "staging").iterdir()) == []


def test_staging_enforces_size_limit_while_streaming(tmp_path: Path) -> None:
    staging = StagingArea(tmp_path / "staging")
    with pytest.raises(FileTooLarge):
        with staging.receive(io.BytesIO(b"x" * 2_000_000), max_bytes=1_000_000):
            pass
    assert list((tmp_path / "staging").iterdir()) == []


def test_staging_rejects_empty_file(tmp_path: Path) -> None:
    with pytest.raises(EmptyFile):
        with StagingArea(tmp_path).receive(io.BytesIO(b""), max_bytes=10):
            pass


# --- inspection ----------------------------------------------------------------------------


DEFAULT_LIMITS = Limits()


def _inspect(tmp_path: Path, data: bytes, limits: Limits = DEFAULT_LIMITS):
    p = tmp_path / "f"
    p.write_bytes(data)
    return inspect_file(p, detection.detect_kind(data[:16]), limits)


def test_pdf_page_count(tmp_path: Path) -> None:
    assert _inspect(tmp_path, make_pdf(3)).page_count == 3


def test_pdf_page_limit(tmp_path: Path) -> None:
    with pytest.raises(TooManyPages):
        _inspect(tmp_path, make_pdf(5), Limits(max_pdf_pages=4))


def test_encrypted_pdf_rejected(tmp_path: Path) -> None:
    with pytest.raises(EncryptedPdf):
        _inspect(tmp_path, make_pdf(password="pw"))


def test_pdf_javascript_rejected(tmp_path: Path) -> None:
    with pytest.raises(ActiveContent):
        _inspect(tmp_path, make_pdf(javascript=True))


def test_pdf_launch_action_rejected(tmp_path: Path) -> None:
    with pytest.raises(ActiveContent):
        _inspect(tmp_path, make_pdf_with_launch_action())


def test_pdf_javascript_can_be_allowed_but_is_flagged(tmp_path: Path) -> None:
    result = _inspect(tmp_path, make_pdf(javascript=True), Limits(reject_pdf_active_content=False))
    assert "/JavaScript" in result.findings


def test_pdf_attachment_allowed_and_flagged(tmp_path: Path) -> None:
    """E-invoices (ZUGFeRD / Factur-X) embed XML; they must be accepted."""
    result = _inspect(tmp_path, make_pdf(attachment=True))
    assert result.findings & {"/EmbeddedFile", "/EmbeddedFiles"}


def test_truncated_pdf_rejected(tmp_path: Path) -> None:
    with pytest.raises(MalformedFile):
        _inspect(tmp_path, b"%PDF-1.7\n1 0 obj << /Type /Catalog")


def test_image_dimensions_and_pixel_limit(tmp_path: Path) -> None:
    result = _inspect(tmp_path, make_image("PNG", (300, 200)))
    assert (result.width, result.height) == (300, 200)
    with pytest.raises(ImageTooLarge):
        _inspect(tmp_path, make_image("PNG", (300, 200)), Limits(max_image_pixels=10_000))


def test_corrupt_image_rejected(tmp_path: Path) -> None:
    data = make_image("PNG")[:40]
    with pytest.raises(MalformedFile):
        _inspect(tmp_path, data)


# --- blob store ----------------------------------------------------------------------------


def test_blob_store_refuses_plaintext_unless_allowed(tmp_path: Path) -> None:
    with pytest.raises(UnencryptedStorageNotAllowed):
        LocalBlobStore(tmp_path, allow_unencrypted=False, app_env="development")
    with pytest.raises(UnencryptedStorageNotAllowed):
        LocalBlobStore(tmp_path, allow_unencrypted=True, app_env="production")


def test_blob_store_put_is_read_only_and_rejects_bad_keys(tmp_path: Path) -> None:
    store = LocalBlobStore(tmp_path, allow_unencrypted=True, app_env="test")
    staged = tmp_path / "staged"
    staged.write_bytes(b"data")
    key = store.put(staged)
    assert not staged.exists()
    assert store.open(key).read() == b"data"
    mode = store.local_path(key).stat().st_mode
    assert not mode & (stat.S_IWUSR | stat.S_IWGRP | stat.S_IWOTH)
    for bad in ["../../etc/passwd", "ab", key.upper(), key + "/x"]:
        with pytest.raises(ValueError):
            store.open(bad)


# --- preview -------------------------------------------------------------------------------


def _png_size(data: bytes) -> tuple[int, int]:
    with Image.open(io.BytesIO(data)) as img:
        return img.size


def test_pdf_preview_renders_png(tmp_path: Path) -> None:
    p = tmp_path / "doc.pdf"
    p.write_bytes(make_pdf(2))
    png = render_preview(p, "application/pdf", max_px=400)
    w, h = _png_size(png)
    assert max(w, h) <= 400
    assert h > w  # A4 portrait


def test_image_preview_strips_metadata(tmp_path: Path) -> None:
    p = tmp_path / "photo.jpg"
    p.write_bytes(make_image("JPEG", (2000, 1000), exif_gps=True))
    with Image.open(p) as src:
        assert src.getexif()  # source has EXIF
    png = render_preview(p, "image/jpeg", max_px=256)
    with Image.open(io.BytesIO(png)) as out:
        assert max(out.size) <= 256
        assert not out.getexif()
        assert "exif" not in out.info


def test_preview_failure_is_contained(tmp_path: Path) -> None:
    p = tmp_path / "broken.pdf"
    p.write_bytes(b"%PDF-1.7 garbage")
    with pytest.raises(PreviewFailed):
        render_preview(p, "application/pdf")
    with pytest.raises(PreviewFailed):
        render_preview(p, "text/html")


# --- filenames -----------------------------------------------------------------------------


@pytest.mark.parametrize(
    ("raw", "clean"),
    [
        ("Rechnung März.pdf", "Rechnung März.pdf"),
        ("../../etc/passwd", "passwd"),
        ("C:\\Users\\x\\Desktop\\Vertrag.pdf", "Vertrag.pdf"),
        ("evil\x00name\r\n.pdf", "evilname.pdf"),
        ("...", None),
        ("", None),
        (None, None),
        ("a" * 400 + ".pdf", "a" * 255),
    ],
)
def test_sanitize_filename(raw, clean) -> None:
    assert sanitize_filename(raw) == clean
