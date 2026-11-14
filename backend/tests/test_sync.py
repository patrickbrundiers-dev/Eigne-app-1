"""Change feed: cursor paging, tombstones, permission filtering, overlap, bad cursors."""

import io
from datetime import timedelta

from paperless_api.api.v1.sync import OVERLAP, decode_cursor, encode_cursor
from paperless_api.db.base import utcnow
from paperless_api.db.models import Document, SpaceMembership
from tests.fixtures import make_pdf
from tests.test_documents_api import world  # noqa: F401  (fixture)


def _upload(client, headers, space, n: int):
    r = client.post(
        f"/api/v1/spaces/{space.id}/documents",
        headers=headers,
        files={"file": (f"doc{n}.pdf", io.BytesIO(make_pdf(pages=n + 1)), "x/y")},
    )
    assert r.status_code == 201, r.text
    return r.json()["id"]


def _sync(client, headers, cursor=None, limit=None):
    params = {}
    if cursor:
        params["cursor"] = cursor
    if limit:
        params["limit"] = limit
    r = client.get("/api/v1/sync", headers=headers, params=params)
    assert r.status_code == 200, r.text
    return r.json()


def _sync_all(client, headers, cursor=None, limit=None):
    docs, pages = {}, 0
    while True:
        body = _sync(client, headers, cursor, limit)
        pages += 1
        for d in body["documents"]:
            docs[d["id"]] = d
        cursor = body["cursor"]
        if not body["has_more"]:
            return docs, cursor, body, pages


def test_sync_requires_login(client, world) -> None:  # noqa: F811
    assert client.get("/api/v1/sync").status_code == 401


def test_first_sync_returns_readable_documents_and_spaces(client, world) -> None:  # noqa: F811
    shared_doc = _upload(client, world["anna"], world["shared"], 1)
    private_doc = _upload(client, world["anna"], world["private"], 2)

    docs, _, body, _ = _sync_all(client, world["anna"])
    assert set(docs) == {shared_doc, private_doc}
    assert {s["name"] for s in body["spaces"]} == {"Haushalt", "Anna privat"}

    # Ben (viewer on the shared space) never sees Anna's private space or its documents
    docs, _, body, _ = _sync_all(client, world["ben"])
    assert set(docs) == {shared_doc}
    assert [s["name"] for s in body["spaces"]] == ["Haushalt"]
    assert body["spaces"][0]["permissions"] == ["read"]

    # Eve is in no family
    docs, _, body, _ = _sync_all(client, world["eve"])
    assert docs == {} and body["spaces"] == []


def test_paging_returns_every_document_once(client, world) -> None:  # noqa: F811
    ids = {_upload(client, world["anna"], world["shared"], n) for n in range(5)}
    docs, _, _, pages = _sync_all(client, world["anna"], limit=2)
    assert set(docs) == ids
    assert pages == 3


def test_incremental_sync_sees_new_and_deleted(client, world, db) -> None:  # noqa: F811
    first = _upload(client, world["anna"], world["shared"], 1)
    _, cursor, _, _ = _sync_all(client, world["ben"])

    second = _upload(client, world["anna"], world["shared"], 2)
    assert client.delete(f"/api/v1/documents/{first}", headers=world["anna"]).status_code == 204

    docs, _, _, _ = _sync_all(client, world["ben"], cursor)
    assert docs[second]["deleted"] is False
    assert docs[first]["deleted"] is True
    assert docs[first]["revision"] == 2


def test_first_sync_skips_tombstones(client, world) -> None:  # noqa: F811
    gone = _upload(client, world["anna"], world["shared"], 1)
    client.delete(f"/api/v1/documents/{gone}", headers=world["anna"])
    docs, _, _, _ = _sync_all(client, world["anna"])
    assert gone not in docs


def test_late_commit_within_overlap_is_not_missed(client, world, db) -> None:  # noqa: F811
    _, cursor, _, _ = _sync_all(client, world["anna"])
    late = _upload(client, world["anna"], world["shared"], 1)
    # simulate a transaction that committed after the sync but carries an older timestamp
    doc = db.get(Document, __import__("uuid").UUID(late))
    db.expire(doc)
    doc = db.get(Document, doc.id)
    at, _ = decode_cursor(cursor)
    doc.updated_at = at + timedelta(seconds=1)
    db.commit()
    docs, _, _, _ = _sync_all(client, world["anna"], cursor)
    assert late in docs


def test_final_cursor_points_overlap_back(client, world) -> None:  # noqa: F811
    body = _sync(client, world["anna"])
    at, after_id = decode_cursor(body["cursor"])
    assert after_id is None
    assert abs((utcnow() - OVERLAP) - at) < timedelta(seconds=30)


def test_lost_access_drops_space_from_list(client, world, db) -> None:  # noqa: F811
    doc = _upload(client, world["anna"], world["shared"], 1)
    _, cursor, body, _ = _sync_all(client, world["ben"])
    assert body["spaces"]
    db.query(SpaceMembership).filter_by(space_id=world["shared"].id).filter(
        SpaceMembership.role == "viewer"
    ).delete()
    db.commit()
    docs, _, body, _ = _sync_all(client, world["ben"], cursor)
    assert body["spaces"] == []
    assert doc not in docs


def test_invalid_cursor_is_400(client, world) -> None:  # noqa: F811
    for bad in ["nope", "e30", encode_cursor(utcnow(), None)[:-3] + "!!!"]:
        r = client.get("/api/v1/sync", headers=world["anna"], params={"cursor": bad})
        assert r.status_code == 400, bad


def test_limit_is_bounded(client, world) -> None:  # noqa: F811
    r = client.get("/api/v1/sync", headers=world["anna"], params={"limit": 10_000})
    assert r.status_code == 422
