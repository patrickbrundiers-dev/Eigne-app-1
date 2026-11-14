"""HTTP tests for spaces and documents: auth, 404 vs 403, upload errors, preview, download."""

import io

import pytest
from PIL import Image

from paperless_api.auth.service import create_user
from paperless_api.config import Settings, get_settings
from paperless_api.db.models import (
    Family,
    FamilyMember,
    FamilyRole,
    Space,
    SpaceMembership,
    SpaceRole,
    SpaceType,
)
from paperless_api.documents.crypto import MAGIC, generate_master_key
from paperless_api.main import app
from tests.fixtures import make_image, make_pdf

PW = "correct horse battery"
MASTER_KEY = generate_master_key()


@pytest.fixture
def world(db, client, tmp_path):
    settings = Settings(
        storage_dir=str(tmp_path / "data"), storage_master_key=MASTER_KEY, app_env="test"
    )
    app.dependency_overrides[get_settings] = lambda: settings
    anna = create_user(db, email="anna@example.test", display_name="Anna", password=PW)
    ben = create_user(db, email="ben@example.test", display_name="Ben", password=PW)
    create_user(db, email="eve@example.test", display_name="Eve", password=PW)
    fam = Family(name="Muster")
    db.add(fam)
    db.flush()
    shared = Space(family_id=fam.id, name="Haushalt", type=SpaceType.SHARED)
    private = Space(family_id=fam.id, name="Anna privat", type=SpaceType.PRIVATE)
    db.add_all([shared, private])
    db.flush()
    db.add_all(
        [
            FamilyMember(family_id=fam.id, user_id=anna.id, role=FamilyRole.ADMIN),
            FamilyMember(family_id=fam.id, user_id=ben.id, role=FamilyRole.ADULT),
            SpaceMembership(space_id=shared.id, user_id=anna.id, role=SpaceRole.OWNER),
            SpaceMembership(space_id=shared.id, user_id=ben.id, role=SpaceRole.VIEWER),
            SpaceMembership(space_id=private.id, user_id=anna.id, role=SpaceRole.OWNER),
        ]
    )
    db.commit()

    def auth(email: str) -> dict[str, str]:
        r = client.post("/api/v1/auth/login", json={"email": email, "password": PW})
        return {"Authorization": f"Bearer {r.json()['access_token']}"}

    yield {
        "anna": auth("anna@example.test"),
        "ben": auth("ben@example.test"),
        "eve": auth("eve@example.test"),
        "shared": shared,
        "private": private,
        "settings": settings,
    }


def _upload(client, headers, space, data: bytes, name="Rechnung.pdf", title=None):
    form = {"title": title} if title else {}
    return client.post(
        f"/api/v1/spaces/{space.id}/documents",
        headers=headers,
        files={"file": (name, io.BytesIO(data), "application/octet-stream")},
        data=form,
    )


def test_endpoints_require_login(client, world) -> None:
    space = world["shared"]
    assert client.get("/api/v1/spaces").status_code == 401
    assert client.get(f"/api/v1/spaces/{space.id}/documents").status_code == 401
    assert _upload(client, {}, space, make_pdf()).status_code == 401


def test_list_spaces_shows_only_readable_with_permissions(client, world) -> None:
    anna = {s["name"]: s for s in client.get("/api/v1/spaces", headers=world["anna"]).json()}
    assert set(anna) == {"Haushalt", "Anna privat"}
    assert "manage_members" in anna["Haushalt"]["permissions"]
    ben = client.get("/api/v1/spaces", headers=world["ben"]).json()
    assert [(s["name"], s["permissions"]) for s in ben] == [("Haushalt", ["read"])]
    assert client.get("/api/v1/spaces", headers=world["eve"]).json() == []


def test_upload_list_get_preview_download(client, world) -> None:
    data = make_pdf(3)
    r = _upload(client, world["anna"], world["shared"], data, name="Strom 2026.pdf")
    assert r.status_code == 201, r.text
    doc = r.json()
    assert doc["title"] == "Strom 2026"
    assert doc["page_count"] == 3
    assert doc["mime_type"] == "application/pdf"

    listed = client.get(f"/api/v1/spaces/{world['shared'].id}/documents", headers=world["ben"])
    assert [d["id"] for d in listed.json()] == [doc["id"]]

    preview = client.get(f"/api/v1/documents/{doc['id']}/preview", headers=world["ben"])
    assert preview.status_code == 200
    assert preview.headers["content-type"] == "image/png"
    with Image.open(io.BytesIO(preview.content)) as img:
        assert max(img.size) <= 1024
    again = client.get(f"/api/v1/documents/{doc['id']}/preview", headers=world["ben"])
    assert again.content == preview.content  # served from cache

    file = client.get(f"/api/v1/documents/{doc['id']}/file", headers=world["ben"])
    assert file.status_code == 200
    assert file.content == data
    assert file.headers["content-disposition"].startswith("attachment")
    assert "sandbox" in file.headers["content-security-policy"]
    assert file.headers["x-content-type-options"] == "nosniff"


def test_viewer_cannot_upload_or_delete(client, world) -> None:
    assert _upload(client, world["ben"], world["shared"], make_pdf()).status_code == 403
    doc = _upload(client, world["anna"], world["shared"], make_pdf()).json()
    assert client.delete(f"/api/v1/documents/{doc['id']}", headers=world["ben"]).status_code == 403


def test_unreadable_spaces_and_documents_are_404(client, world) -> None:
    private = world["private"]
    doc = _upload(client, world["anna"], private, make_pdf()).json()
    for who in ("ben", "eve"):
        h = world[who]
        assert client.get(f"/api/v1/spaces/{private.id}/documents", headers=h).status_code == 404
        assert _upload(client, h, private, make_pdf(2)).status_code == 404
        for suffix in ("", "/preview", "/file"):
            assert (
                client.get(f"/api/v1/documents/{doc['id']}{suffix}", headers=h).status_code == 404
            )
    unknown = "00000000-0000-0000-0000-000000000000"
    assert (
        client.get(f"/api/v1/spaces/{unknown}/documents", headers=world["anna"]).status_code == 404
    )


def test_upload_errors_have_codes(client, world) -> None:
    h, space = world["anna"], world["shared"]
    r = _upload(client, h, space, b"<html>not a pdf</html>", name="x.pdf")
    assert r.status_code == 422
    assert r.json()["detail"]["code"] == "unsupported_type"

    r = _upload(client, h, space, make_pdf(javascript=True))
    assert r.json()["detail"]["code"] == "active_content"

    first = _upload(client, h, space, make_pdf(4)).json()
    r = _upload(client, h, space, make_pdf(4), name="copy.pdf")
    assert r.status_code == 409
    assert r.json()["detail"]["existing_document_id"] == first["id"]


def test_upload_size_limit(client, world) -> None:
    world["settings"].max_upload_bytes = 1000
    r = _upload(client, world["anna"], world["shared"], make_pdf() + b"0" * 5000)
    assert r.status_code == 413
    assert r.json()["detail"]["code"] == "too_large"


def test_oversized_content_length_rejected_before_reading(client, world) -> None:
    r = client.post(
        f"/api/v1/spaces/{world['shared'].id}/documents",
        headers={
            **world["anna"],
            "content-length": str(10**12),
            "content-type": "multipart/form-data",
        },
        content=b"",
    )
    assert r.status_code == 413


def test_delete_is_tombstone(client, world, db) -> None:
    from paperless_api.db.models import Document

    doc = _upload(client, world["anna"], world["shared"], make_image("PNG")).json()
    assert client.delete(f"/api/v1/documents/{doc['id']}", headers=world["anna"]).status_code == 204
    assert client.get(f"/api/v1/documents/{doc['id']}", headers=world["anna"]).status_code == 404
    db.expire_all()
    row = db.get(Document, __import__("uuid").UUID(doc["id"]))
    assert row.deleted_at is not None and row.revision == 2
    # re-importing the same file after delete is allowed
    assert _upload(client, world["anna"], world["shared"], make_image("PNG")).status_code == 201


def test_files_and_previews_are_encrypted_on_disk(client, world) -> None:
    from pathlib import Path

    data = make_pdf(2)
    doc = _upload(client, world["anna"], world["shared"], data).json()
    assert (
        client.get(f"/api/v1/documents/{doc['id']}/preview", headers=world["anna"]).status_code
        == 200
    )
    root = Path(world["settings"].storage_dir)
    stored = [p for sub in ("blobs", "derived") for p in (root / sub).rglob("*") if p.is_file()]
    assert len(stored) == 2  # original + preview
    for p in stored:
        raw = p.read_bytes()
        assert raw.startswith(MAGIC)
        assert b"%PDF" not in raw and b"PNG" not in raw
    assert not any((root / "tmp").iterdir())  # plaintext temp copies are cleaned up
    file = client.get(f"/api/v1/documents/{doc['id']}/file", headers=world["anna"])
    assert file.content == data


def test_storage_not_configured_is_503(client, world) -> None:
    world["settings"].storage_master_key = None
    world["settings"].allow_unencrypted_storage = False
    world["settings"].storage_dir = world["settings"].storage_dir + "-other"
    r = _upload(client, world["anna"], world["shared"], make_pdf())
    assert r.status_code == 503
