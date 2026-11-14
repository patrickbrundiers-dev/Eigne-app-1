"""Structural checks on PDFs and images before they are accepted.

Uses vetted parsers (pypdf, Pillow) and only reads structure: no rendering, no JavaScript,
no form handling. Rendering happens in a separate, resource-limited process (preview.py).
"""

from __future__ import annotations

import logging
import warnings
from dataclasses import dataclass, field
from pathlib import Path

from PIL import Image
from pypdf import PdfReader
from pypdf.errors import PdfReadError
from pypdf.generic import ArrayObject, DictionaryObject, IndirectObject

from paperless_api.documents.detection import FileKind
from paperless_api.documents.errors import (
    ActiveContent,
    EncryptedPdf,
    ImageTooLarge,
    MalformedFile,
    TooManyPages,
)

# Keys that make a PDF execute something or talk to the outside world.
EXECUTABLE_KEYS = frozenset({"/JavaScript", "/JS", "/Launch", "/SubmitForm", "/ImportData"})
# Notable but legitimate: e-invoices (ZUGFeRD / Factur-X) embed XML as attachment.
NOTABLE_KEYS = frozenset({"/EmbeddedFile", "/EmbeddedFiles", "/RichMedia", "/XFA", "/URI"})

# Walking the object graph is bounded so hostile files cannot make us loop for ages.
MAX_PDF_NODES = 500_000


@dataclass(frozen=True, slots=True)
class Limits:
    max_bytes: int = 50 * 1024 * 1024
    max_pdf_pages: int = 500
    max_image_pixels: int = 80_000_000  # ~ A4 at 1200 dpi
    reject_pdf_active_content: bool = True


@dataclass(slots=True)
class InspectionResult:
    page_count: int | None = None
    width: int | None = None
    height: int | None = None
    findings: set[str] = field(default_factory=set)


def inspect_file(path: Path, kind: FileKind, limits: Limits) -> InspectionResult:
    if kind.is_pdf:
        return inspect_pdf(path, limits)
    if kind.is_image:
        return inspect_image(path, limits)
    raise AssertionError(f"no inspector for {kind.mime_type}")  # pragma: no cover


def _scan_pdf_objects(reader: PdfReader) -> set[str]:
    found: set[str] = set()
    seen: set[tuple[int, int]] = set()
    stack: list[object] = [reader.trailer]
    nodes = 0
    while stack:
        obj = stack.pop()
        nodes += 1
        if nodes > MAX_PDF_NODES:
            raise MalformedFile("PDF structure is too complex")
        if isinstance(obj, IndirectObject):
            ref = (obj.idnum, obj.generation)
            if ref in seen:
                continue
            seen.add(ref)
            try:
                obj = obj.get_object()
            except Exception:  # broken reference: ignore, pypdf tolerates these too
                continue
        if isinstance(obj, DictionaryObject):
            for key, value in obj.items():
                if key in EXECUTABLE_KEYS or key in NOTABLE_KEYS:
                    found.add(key)
                # /S /JavaScript or /S /Launch inside action dictionaries
                if key == "/S" and value in EXECUTABLE_KEYS:
                    found.add(str(value))
                stack.append(value)
        elif isinstance(obj, ArrayObject):
            stack.extend(obj)
    return found


def inspect_pdf(path: Path, limits: Limits) -> InspectionResult:
    # pypdf logs and warns about broken-but-readable files; keep that out of our logs
    # (messages can contain fragments of the file).
    pypdf_logger = logging.getLogger("pypdf")
    previous = pypdf_logger.level
    pypdf_logger.setLevel(logging.ERROR)
    try:
        with warnings.catch_warnings():
            warnings.simplefilter("ignore")
            try:
                reader = PdfReader(path, strict=False)
                if reader.is_encrypted:
                    raise EncryptedPdf(
                        "password-protected PDFs are not supported; remove the password first"
                    )
                pages = len(reader.pages)
                findings = _scan_pdf_objects(reader)
            except (EncryptedPdf, MalformedFile):
                raise
            except (PdfReadError, ValueError, KeyError, TypeError, RecursionError) as exc:
                raise MalformedFile("PDF could not be parsed") from exc
    finally:
        pypdf_logger.setLevel(previous)

    if pages == 0:
        raise MalformedFile("PDF has no pages")
    if pages > limits.max_pdf_pages:
        raise TooManyPages(f"PDF has {pages} pages; the limit is {limits.max_pdf_pages}")
    executable = findings & EXECUTABLE_KEYS
    if executable and limits.reject_pdf_active_content:
        raise ActiveContent(
            "PDF contains executable content (" + ", ".join(sorted(executable)) + ")"
        )
    return InspectionResult(page_count=pages, findings=findings)


def inspect_image(path: Path, limits: Limits) -> InspectionResult:
    try:
        with Image.open(path) as img:  # lazy: reads the header only
            width, height = img.size
            frames = getattr(img, "n_frames", 1)
            if width * height > limits.max_image_pixels:
                raise ImageTooLarge(
                    f"image has {width}x{height} pixels; the limit is {limits.max_image_pixels}"
                )
            img.verify()  # structural check without full decode
    except ImageTooLarge:
        raise
    except (OSError, SyntaxError, ValueError, Image.DecompressionBombError) as exc:
        raise MalformedFile("image could not be parsed") from exc
    if frames > limits.max_pdf_pages:
        raise TooManyPages(f"image has {frames} frames; the limit is {limits.max_pdf_pages}")
    return InspectionResult(page_count=frames, width=width, height=height)
