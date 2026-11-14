"""End-to-end import service tests: authorization, duplicates, immutability, rollback."""

import io
import logging
from pathlib import Path

import pytest
from sqlalchemy import func, select
from sqlalchemy.orm import Session

from paperless_api.authz import PermissionDenied
from paperless_api.db.base import Base
from paperless_api.db.models import (
    Document,
    Family,
    FamilyMember,
    FamilyRole,
    FileVersion,
    Space,
    SpaceMembership,
    SpaceRole,
    SpaceType,
    User,
)
from paperless_api.db.session import make_engine
from paperless_api.documents.blobstore import LocalBlobStore
from paperless_api.documents.errors import DuplicateDocument, UnsupportedFileType
from paperless_api.documents.inspection import Limits
from paperless_api.documents.service import import_document
from paperless_api.documents.staging import StagingArea
from tests.fixtures import make_image, make_pdf


@pytest.fixture
def env(tmp_path: Path):
    engine = make_engine(f"sqlite+pysqlite:///{tmp_path / 'db.sqlite'}")
    Base.metadata.create_all(engine)
    session = Session(engine, expire_on_commit=False)
    fam = Family(name="F")
    editor = User(email="e@example.test", display_name="E")
    viewer = User(email="v@example.test", display_name="V")
    session.add_all([fam, editor, viewer])
    session.flush()
    space = Space(family_id=fam.id, name="Haushalt", type=SpaceType.SHARED)
    other = Space(family_id=fam.id, name="Andere", type=SpaceType.SHARED)
    session.add_all([space, other])
    session.flush()
    session.add_all(
        [
            FamilyMember(family_id=fam.id, user_id=editor.id, role=FamilyRole.ADULT),
            FamilyMember(family_id=fam.id, user_id=viewer.id, role=FamilyRole.ADULT),
            SpaceMembership(space_id=space.id, user_id=editor.id, role=SpaceRole.EDITOR),
            SpaceMembership(space_id=other.id, user_id=editor.id, role=SpaceRole.EDITOR),
            SpaceMembership(space_id=space.id, user_id=viewer.id, role=SpaceRole.VIEWER),
        ]
    )
    session.commit()
    store = LocalBlobStore(tmp_path / "data", allow_unencrypted=True, app_env="test")
    staging = StagingArea(tmp_path / "data" / "staging")

    def run(data: bytes, *, actor=editor, target=space, filename="Rechnung.pdf", **kw):
        return import_document(
            session,
            store=store,
            staging=staging,
            limits=Limits(),
            actor_id=actor.id,
            space=target,
            stream=io.BytesIO(data),
            filename=filename,
            **kw,
        )

    yield {
        "session": session,
        "run": run,
        "store": store,
        "space": space,
        "other": other,
        "viewer": viewer,
        "tmp": tmp_path,
    }
    session.close()


def _count(session: Session, model) -> int:
    return session.scalar(select(func.count()).select_from(model))


def test_import_pdf_creates_document_and_first_version(env) -> None:
    data = make_pdf(2)
    result = env["run"](data, filename="C:\\scans\\Rechnung März.pdf")
    doc = env["session"].get(Document, result.document_id)
    version = env["session"].get(FileVersion, result.file_version_id)
    assert doc.title == "Rechnung März"
    assert version.version_no == 1
    assert version.page_count == 2
    assert version.mime_type == "application/pdf"
    assert version.original_filename == "Rechnung März.pdf"
    assert env["store"].read(version.storage_key) == data  # original unchanged


def test_explicit_title_wins(env) -> None:
    result = env["run"](make_pdf(), title="  Mietvertrag 2026 ")
    assert env["session"].get(Document, result.document_id).title == "Mietvertrag 2026"


def test_type_comes_from_content_not_filename(env) -> None:
    result = env["run"](make_image("PNG"), filename="looks-like.pdf")
    assert result.mime_type == "image/png"
    with pytest.raises(UnsupportedFileType):
        env["run"](b"MZ\x90\x00not really a pdf", filename="Rechnung.pdf")


def test_viewer_cannot_import(env) -> None:
    with pytest.raises(PermissionDenied):
        env["run"](make_pdf(), actor=env["viewer"])
    assert _count(env["session"], Document) == 0


def test_duplicate_in_same_space_rejected_other_space_allowed(env) -> None:
    data = make_pdf()
    first = env["run"](data)
    with pytest.raises(DuplicateDocument) as exc:
        env["run"](data)
    assert exc.value.existing_document_id == first.document_id
    env["run"](data, target=env["other"])  # no cross-space check (would leak)
    assert _count(env["session"], Document) == 2


def test_rejected_import_leaves_nothing_behind(env) -> None:
    with pytest.raises(UnsupportedFileType):
        env["run"](b"<html>")
    data_dir = env["tmp"] / "data"
    assert list((data_dir / "staging").iterdir()) == []
    assert not any(p.is_file() for p in (data_dir / "blobs").rglob("*"))
    assert _count(env["session"], Document) == 0


def test_db_failure_discards_blob(env, monkeypatch) -> None:
    session = env["session"]

    def boom() -> None:
        raise RuntimeError("db down")

    monkeypatch.setattr(session, "commit", boom)
    with pytest.raises(RuntimeError):
        env["run"](make_pdf())
    assert not any(p.is_file() for p in (env["tmp"] / "data" / "blobs").rglob("*"))


def test_import_log_contains_no_title_or_filename(env, caplog) -> None:
    caplog.set_level(logging.INFO, logger="paperless_api.documents")
    env["run"](make_pdf(), filename="Kontoauszug Geheim.pdf", title="Kontoauszug Geheim")
    text = " ".join(f"{r.getMessage()} {r.__dict__}" for r in caplog.records)
    assert "document imported" in text
    assert "Geheim" not in text
