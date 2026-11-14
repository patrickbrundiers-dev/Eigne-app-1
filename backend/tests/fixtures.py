"""Synthetic test files. Never use real documents in tests."""

from __future__ import annotations

import io

from PIL import Image
from pypdf import PdfWriter
from pypdf.generic import DictionaryObject, NameObject, TextStringObject


def _write(writer: PdfWriter) -> bytes:
    buf = io.BytesIO()
    writer.write(buf)
    return buf.getvalue()


def _with_open_action(action: dict[str, object]) -> bytes:
    writer = PdfWriter()
    writer.add_blank_page(width=200, height=200)
    obj = DictionaryObject({NameObject(k): v for k, v in action.items()})
    writer._root_object[NameObject("/OpenAction")] = writer._add_object(obj)  # noqa: SLF001
    return _write(writer)


def make_pdf(
    pages: int = 1,
    *,
    javascript: bool = False,
    password: str | None = None,
    attachment: bool = False,
) -> bytes:
    if javascript:
        return _with_open_action(
            {"/S": NameObject("/JavaScript"), "/JS": TextStringObject("app.alert('test');")}
        )
    writer = PdfWriter()
    for _ in range(pages):
        writer.add_blank_page(width=595, height=842)  # A4 in points
    if attachment:
        writer.add_attachment("factur-x.xml", b"<Invoice>synthetic</Invoice>")
    if password:
        writer.encrypt(password)
    return _write(writer)


def make_pdf_with_launch_action() -> bytes:
    return _with_open_action({"/S": NameObject("/Launch"), "/F": TextStringObject("calc.exe")})


def make_image(fmt: str = "PNG", size: tuple[int, int] = (64, 48), exif_gps: bool = False) -> bytes:
    img = Image.new("RGB", size, (200, 30, 30))
    buf = io.BytesIO()
    kwargs = {}
    if exif_gps:
        exif = Image.Exif()
        exif[0x010F] = "SyntheticCam"  # Make
        kwargs["exif"] = exif.tobytes()
    img.save(buf, format=fmt, **kwargs)
    return buf.getvalue()
