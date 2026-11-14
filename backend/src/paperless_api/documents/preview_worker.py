"""Preview renderer, run as a separate process by preview.py. Not imported by the API.

Usage: python -I -m paperless_api.documents.preview_worker MIME IN_PATH OUT_PATH MAX_PX

Renders the first page of a PDF (pdfium via pypdfium2; no JavaScript, no forms) or an image
(Pillow) to a PNG. Re-encoding drops all metadata (e.g. EXIF GPS positions).
"""

from __future__ import annotations

import sys


def main(argv: list[str]) -> int:
    mime, in_path, out_path, max_px_s = argv
    max_px = int(max_px_s)

    from PIL import Image

    Image.MAX_IMAGE_PIXELS = 80_000_000

    if mime == "application/pdf":
        import pypdfium2 as pdfium

        pdf = pdfium.PdfDocument(in_path)
        try:
            page = pdf[0]
            w, h = page.get_size()  # PDF points
            scale = max_px / max(w, h, 1)
            image = page.render(scale=min(scale, 4.0)).to_pil()
            page.close()
        finally:
            pdf.close()
    else:
        with Image.open(in_path) as src:
            src.seek(0)
            src.thumbnail((max_px, max_px))
            image = src.convert("RGB") if src.mode not in ("RGB", "RGBA", "L") else src.copy()

    image.thumbnail((max_px, max_px))
    image.save(out_path, format="PNG", optimize=True)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
