"""Spaces and documents API.

Every handler resolves the actor's permissions on the space with the policy in authz.py.
Spaces the actor cannot read answer 404 (existence is not revealed); readable spaces where
the action is not allowed answer 403.
"""

from __future__ import annotations

import uuid
from datetime import datetime
from functools import lru_cache
from pathlib import Path
from typing import Annotated
from urllib.parse import quote

from fastapi import (
    APIRouter,
    Depends,
    File,
    Form,
    HTTPException,
    Response,
    UploadFile,
    status,
)
from pydantic import BaseModel
from sqlalchemy import select
from sqlalchemy.orm import Session

from paperless_api.api.deps import AppSettings, CurrentUser, DbSession
from paperless_api.authz import Action, allowed_actions, load_access_context
from paperless_api.config import Settings
from paperless_api.db.base import utcnow
from paperless_api.db.models import Document, FamilyMember, FileVersion, Space, User
from paperless_api.documents.blobstore import (
    BlobStore,
)
from paperless_api.documents.errors import DuplicateDocument, ImportRejected, PreviewFailed
from paperless_api.documents.preview import render_preview
from paperless_api.documents.service import import_document, limits_from_settings
from paperless_api.documents.staging import StagingArea
from paperless_api.documents.storage_config import StorageNotConfigured, build_blob_store

router = APIRouter(tags=["documents"])

# --- storage dependencies ------------------------------------------------------------------


@lru_cache(maxsize=4)
def _store_for(settings_key: tuple) -> BlobStore:
    return build_blob_store(Settings(**dict(settings_key)))


def get_blob_store(settings: AppSettings) -> BlobStore:
    key = tuple(
        sorted(
            settings.model_dump(
                include={
                    "storage_dir",
                    "storage_master_key",
                    "storage_master_key_file",
                    "storage_old_master_keys",
                    "allow_unencrypted_storage",
                    "app_env",
                }
            ).items()
        )
    )
    try:
        return _store_for(key)
    except StorageNotConfigured:
        raise HTTPException(
            status.HTTP_503_SERVICE_UNAVAILABLE, "document storage is not configured"
        ) from None


def get_staging(settings: AppSettings) -> StagingArea:
    return StagingArea(Path(settings.storage_dir) / "staging")


Store = Annotated[BlobStore, Depends(get_blob_store)]
Staging = Annotated[StagingArea, Depends(get_staging)]


# --- schemas -------------------------------------------------------------------------------


class SpaceOut(BaseModel):
    id: uuid.UUID
    family_id: uuid.UUID
    name: str
    type: str
    permissions: list[str]


class DocumentOut(BaseModel):
    id: uuid.UUID
    space_id: uuid.UUID
    title: str
    revision: int
    created_at: datetime
    updated_at: datetime
    mime_type: str | None
    size_bytes: int | None
    page_count: int | None
    original_filename: str | None
    version_no: int | None


class ImportError_(BaseModel):
    code: str
    message: str
    existing_document_id: uuid.UUID | None = None


# --- helpers -------------------------------------------------------------------------------


def _actions(db: Session, user: User, space: Space) -> frozenset[Action]:
    return allowed_actions(load_access_context(db, user.id, space))


def _space_for(db: Session, user: User, space_id: uuid.UUID, action: Action) -> Space:
    space = db.get(Space, space_id)
    actions = _actions(db, user, space) if space is not None else frozenset()
    if Action.READ not in actions:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "space not found")
    if action not in actions:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "not allowed")
    return space


def _document_for(db: Session, user: User, document_id: uuid.UUID, action: Action) -> Document:
    doc = db.get(Document, document_id)
    if doc is None or doc.deleted_at is not None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "document not found")
    actions = _actions(db, user, doc.space)
    if Action.READ not in actions:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "document not found")
    if action not in actions:
        raise HTTPException(status.HTTP_403_FORBIDDEN, "not allowed")
    return doc


def _latest(doc: Document) -> FileVersion | None:
    return doc.versions[-1] if doc.versions else None


def _doc_out(doc: Document) -> DocumentOut:
    v = _latest(doc)
    return DocumentOut(
        id=doc.id,
        space_id=doc.space_id,
        title=doc.title,
        revision=doc.revision,
        created_at=doc.created_at,
        updated_at=doc.updated_at,
        mime_type=v.mime_type if v else None,
        size_bytes=v.size_bytes if v else None,
        page_count=v.page_count if v else None,
        original_filename=v.original_filename if v else None,
        version_no=v.version_no if v else None,
    )


# --- spaces --------------------------------------------------------------------------------


def readable_spaces(db: Session, user: User) -> list[SpaceOut]:
    """All spaces of the user's families that the user may read, with their permissions."""
    family_ids = select(FamilyMember.family_id).where(FamilyMember.user_id == user.id)
    spaces = db.scalars(
        select(Space).where(Space.family_id.in_(family_ids)).order_by(Space.name)
    ).all()
    out = []
    for space in spaces:
        actions = _actions(db, user, space)
        if Action.READ in actions:
            out.append(
                SpaceOut(
                    id=space.id,
                    family_id=space.family_id,
                    name=space.name,
                    type=space.type.value,
                    permissions=sorted(a.value for a in actions),
                )
            )
    return out


@router.get("/spaces", response_model=list[SpaceOut])
def list_spaces(user: CurrentUser, db: DbSession) -> list[SpaceOut]:
    return readable_spaces(db, user)


@router.get("/spaces/{space_id}/documents", response_model=list[DocumentOut])
def list_documents(space_id: uuid.UUID, user: CurrentUser, db: DbSession) -> list[DocumentOut]:
    space = _space_for(db, user, space_id, Action.READ)
    docs = db.scalars(
        select(Document)
        .where(Document.space_id == space.id, Document.deleted_at.is_(None))
        .order_by(Document.created_at.desc())
    ).all()
    return [_doc_out(d) for d in docs]


@router.post(
    "/spaces/{space_id}/documents",
    response_model=DocumentOut,
    status_code=status.HTTP_201_CREATED,
    responses={
        409: {"model": ImportError_},
        413: {"model": ImportError_},
        422: {"model": ImportError_},
    },
)
def upload_document(
    space_id: uuid.UUID,
    user: CurrentUser,
    db: DbSession,
    settings: AppSettings,
    store: Store,
    staging: Staging,
    file: Annotated[UploadFile, File()],
    title: Annotated[str | None, Form(max_length=300)] = None,
) -> DocumentOut:
    space = _space_for(db, user, space_id, Action.WRITE)
    try:
        result = import_document(
            db,
            store=store,
            staging=staging,
            limits=limits_from_settings(settings),
            actor_id=user.id,
            space=space,
            stream=file.file,
            filename=file.filename,
            title=title,
        )
    except DuplicateDocument as exc:
        raise HTTPException(
            status.HTTP_409_CONFLICT,
            ImportError_(
                code=exc.code, message=exc.message, existing_document_id=exc.existing_document_id
            ).model_dump(mode="json"),
        ) from None
    except ImportRejected as exc:
        code = 413 if exc.code == "too_large" else 422
        raise HTTPException(
            code, ImportError_(code=exc.code, message=exc.message).model_dump(mode="json")
        ) from None
    finally:
        file.file.close()
    return _doc_out(db.get(Document, result.document_id))


# --- documents -----------------------------------------------------------------------------


@router.get("/documents/{document_id}", response_model=DocumentOut)
def get_document(document_id: uuid.UUID, user: CurrentUser, db: DbSession) -> DocumentOut:
    return _doc_out(_document_for(db, user, document_id, Action.READ))


@router.delete("/documents/{document_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_document(document_id: uuid.UUID, user: CurrentUser, db: DbSession) -> Response:
    doc = _document_for(db, user, document_id, Action.DELETE_DOCUMENT)
    doc.deleted_at = utcnow()  # tombstone; blobs stay until the retention job purges them
    doc.revision += 1
    db.commit()
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get(
    "/documents/{document_id}/preview",
    response_class=Response,
    responses={200: {"content": {"image/png": {}}}},
)
def get_preview(document_id: uuid.UUID, user: CurrentUser, db: DbSession, store: Store) -> Response:
    doc = _document_for(db, user, document_id, Action.READ)
    version = _latest(doc)
    if version is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "document has no file")
    name = f"preview-{version.id.hex}.png"
    data = store.get_derived(name)
    if data is None:
        try:
            with store.materialize(version.storage_key) as plain:
                data = render_preview(plain, version.mime_type)
        except PreviewFailed:
            raise HTTPException(422, "preview could not be generated") from None
        store.put_derived(name, data)  # versions are immutable, so the cache never goes stale
    return Response(
        content=data,
        media_type="image/png",
        headers={"cache-control": "private, max-age=86400"},
    )


@router.get("/documents/{document_id}/file", response_class=Response)
def download_file(
    document_id: uuid.UUID, user: CurrentUser, db: DbSession, store: Store
) -> Response:
    doc = _document_for(db, user, document_id, Action.READ)
    version = _latest(doc)
    if version is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND, "document has no file")
    ext = {"application/pdf": "pdf", "image/png": "png", "image/jpeg": "jpg"}.get(
        version.mime_type, "bin"
    )
    name = version.original_filename or f"dokument.{ext}"
    return Response(
        content=store.read(version.storage_key),
        media_type=version.mime_type,
        headers={
            "content-disposition": f"attachment; filename*=UTF-8''{quote(name)}",
            "content-security-policy": "sandbox; default-src 'none'",
            "cache-control": "private, no-store",
        },
    )
