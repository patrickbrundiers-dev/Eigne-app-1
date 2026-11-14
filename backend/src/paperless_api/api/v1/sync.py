"""Change feed so every device (phone, PC) converges on the same state.

``GET /api/v1/sync`` returns the documents that changed since the client's cursor, across
all spaces the user may read, including tombstones of deleted documents. It also returns the
current list of readable spaces, so a client drops documents of spaces it lost access to and
does a full fetch for spaces it newly sees.

Cursor design: keyset over ``(updated_at, id)``. Within one sync the client pages with the
returned cursor. The cursor of the last page points ``OVERLAP`` back in time, so changes
whose transaction committed late (with an older ``updated_at``) are still picked up on the
next sync. Clients deduplicate by ``(id, revision)``, so repeated rows are harmless.
"""

from __future__ import annotations

import base64
import binascii
import json
import uuid
from datetime import datetime, timedelta

from fastapi import APIRouter, HTTPException, Query, status
from pydantic import BaseModel
from sqlalchemy import and_, or_, select

from paperless_api.api.deps import CurrentUser, DbSession
from paperless_api.api.v1.documents import DocumentOut, SpaceOut, _doc_out, readable_spaces
from paperless_api.db.base import utcnow
from paperless_api.db.models import Document

router = APIRouter(tags=["sync"])

OVERLAP = timedelta(minutes=2)
MAX_LIMIT = 500


class SyncDocument(DocumentOut):
    deleted: bool


class SyncOut(BaseModel):
    server_time: datetime
    cursor: str
    has_more: bool
    spaces: list[SpaceOut]
    documents: list[SyncDocument]


def encode_cursor(at: datetime, after_id: uuid.UUID | None) -> str:
    raw = json.dumps({"t": at.isoformat(), "id": after_id.hex if after_id else None})
    return base64.urlsafe_b64encode(raw.encode()).decode().rstrip("=")


def decode_cursor(cursor: str) -> tuple[datetime, uuid.UUID | None]:
    try:
        raw = base64.urlsafe_b64decode(cursor + "=" * (-len(cursor) % 4))
        data = json.loads(raw)
        at = datetime.fromisoformat(data["t"])
        if at.tzinfo is None:
            raise ValueError("naive timestamp")
        after_id = uuid.UUID(hex=data["id"]) if data.get("id") else None
    except (binascii.Error, ValueError, KeyError, TypeError, json.JSONDecodeError):
        raise HTTPException(status.HTTP_400_BAD_REQUEST, "invalid cursor") from None
    return at, after_id


@router.get("/sync", response_model=SyncOut)
def sync(
    user: CurrentUser,
    db: DbSession,
    cursor: str | None = Query(default=None, max_length=512),
    limit: int = Query(default=200, ge=1, le=MAX_LIMIT),
) -> SyncOut:
    now = utcnow()
    spaces = readable_spaces(db, user)
    space_ids = [s.id for s in spaces]

    query = select(Document).where(Document.space_id.in_(space_ids))
    if cursor is None:
        # first sync: live documents only, tombstones are irrelevant for an empty client
        query = query.where(Document.deleted_at.is_(None))
    else:
        at, after_id = decode_cursor(cursor)
        if after_id is None:
            query = query.where(Document.updated_at >= at)
        else:
            query = query.where(
                or_(
                    Document.updated_at > at,
                    and_(Document.updated_at == at, Document.id > after_id),
                )
            )
    rows = (
        db.scalars(query.order_by(Document.updated_at, Document.id).limit(limit + 1)).all()
        if space_ids
        else []
    )

    has_more = len(rows) > limit
    rows = rows[:limit]
    if has_more:
        last = rows[-1]
        next_cursor = encode_cursor(last.updated_at, last.id)
    else:
        next_cursor = encode_cursor(now - OVERLAP, None)

    return SyncOut(
        server_time=now,
        cursor=next_cursor,
        has_more=has_more,
        spaces=spaces,
        documents=[
            SyncDocument(**_doc_out(d).model_dump(), deleted=d.deleted_at is not None) for d in rows
        ],
    )
