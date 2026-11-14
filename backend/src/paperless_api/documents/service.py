"""Document import: staging -> type detection -> inspection -> duplicate check -> blob store
-> metadata. The only entry point that creates documents and file versions."""

from __future__ import annotations

import logging
import unicodedata
import uuid
from dataclasses import dataclass
from pathlib import PurePosixPath, PureWindowsPath
from typing import BinaryIO

from sqlalchemy import select
from sqlalchemy.orm import Session

from paperless_api.authz import Action, PermissionDenied, is_allowed, load_access_context
from paperless_api.config import Settings
from paperless_api.db.models import Document, FileVersion, Space
from paperless_api.documents.blobstore import BlobStore
from paperless_api.documents.detection import detect_kind
from paperless_api.documents.errors import DuplicateDocument
from paperless_api.documents.inspection import Limits, inspect_file
from paperless_api.documents.staging import StagingArea

logger = logging.getLogger("paperless_api.documents")


def limits_from_settings(settings: Settings) -> Limits:
    return Limits(
        max_bytes=settings.max_upload_bytes,
        max_pdf_pages=settings.max_pdf_pages,
        max_image_pixels=settings.max_image_pixels,
        reject_pdf_active_content=settings.reject_pdf_active_content,
    )


def sanitize_filename(name: str | None) -> str | None:
    """Keep only the last path component, drop control characters, cap the length."""
    if not name:
        return None
    name = PureWindowsPath(PurePosixPath(name).name).name
    name = unicodedata.normalize("NFC", name)
    name = "".join(ch for ch in name if unicodedata.category(ch)[0] != "C").strip(" .")
    return name[:255] or None


def default_title(filename: str | None) -> str:
    if filename and "." in filename:
        stem = filename.rsplit(".", 1)[0].strip()
        if stem:
            return stem[:300]
    return (filename or "Unbenanntes Dokument")[:300]


@dataclass(frozen=True, slots=True)
class ImportResult:
    document_id: uuid.UUID
    file_version_id: uuid.UUID
    mime_type: str
    size_bytes: int
    sha256: str
    page_count: int | None
    findings: frozenset[str]


def import_document(
    session: Session,
    *,
    store: BlobStore,
    staging: StagingArea,
    limits: Limits,
    actor_id: uuid.UUID,
    space: Space,
    stream: BinaryIO,
    filename: str | None = None,
    title: str | None = None,
) -> ImportResult:
    ctx = load_access_context(session, actor_id, space)
    if not is_allowed(ctx, Action.WRITE):
        raise PermissionDenied(Action.WRITE.value)

    original_filename = sanitize_filename(filename)
    with staging.receive(stream, limits.max_bytes) as staged:
        kind = detect_kind(staged.head)
        inspection = inspect_file(staged.path, kind, limits)

        # Duplicates are only checked inside the same space. Checking across spaces would
        # reveal that someone else holds the same file.
        existing = session.scalar(
            select(Document.id)
            .join(FileVersion, FileVersion.document_id == Document.id)
            .where(
                Document.space_id == space.id,
                Document.deleted_at.is_(None),
                FileVersion.sha256 == staged.sha256,
            )
            .limit(1)
        )
        if existing is not None:
            raise DuplicateDocument(existing)

        key = store.put(staged.path)

    try:
        doc = Document(
            space_id=space.id,
            title=(title or "").strip()[:300] or default_title(original_filename),
            created_by=actor_id,
        )
        session.add(doc)
        session.flush()
        version = FileVersion(
            document_id=doc.id,
            version_no=1,
            sha256=staged.sha256,
            size_bytes=staged.size_bytes,
            mime_type=kind.mime_type,
            storage_key=key,
            page_count=inspection.page_count,
            original_filename=original_filename,
            created_by=actor_id,
        )
        session.add(version)
        session.commit()
    except Exception:
        session.rollback()
        store.discard(key)  # never leave an orphaned blob behind
        raise

    # IDs and sizes only: no titles, filenames or content in logs.
    logger.info(
        "document imported",
        extra={
            "document_id": str(doc.id),
            "space_id": str(space.id),
            "mime_type": kind.mime_type,
            "size_bytes": staged.size_bytes,
            "page_count": inspection.page_count,
        },
    )
    return ImportResult(
        document_id=doc.id,
        file_version_id=version.id,
        mime_type=kind.mime_type,
        size_bytes=staged.size_bytes,
        sha256=staged.sha256,
        page_count=inspection.page_count,
        findings=frozenset(inspection.findings),
    )
