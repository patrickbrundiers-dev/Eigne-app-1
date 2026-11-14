"""Import errors. `code` is stable and safe to show to clients; messages never contain
document content."""

from __future__ import annotations

import uuid


class ImportRejected(Exception):
    code = "rejected"

    def __init__(self, message: str) -> None:
        super().__init__(message)
        self.message = message


class UnsupportedFileType(ImportRejected):
    code = "unsupported_type"


class FileTooLarge(ImportRejected):
    code = "too_large"


class EmptyFile(ImportRejected):
    code = "empty_file"


class TooManyPages(ImportRejected):
    code = "too_many_pages"


class EncryptedPdf(ImportRejected):
    code = "encrypted_pdf"


class ActiveContent(ImportRejected):
    code = "active_content"


class MalformedFile(ImportRejected):
    code = "malformed"


class ImageTooLarge(ImportRejected):
    code = "image_too_large"


class DuplicateDocument(ImportRejected):
    code = "duplicate"

    def __init__(self, existing_document_id: uuid.UUID) -> None:
        super().__init__("an identical file already exists in this space")
        self.existing_document_id = existing_document_id


class PreviewFailed(Exception):
    """Rendering a preview failed or exceeded its resource limits."""
