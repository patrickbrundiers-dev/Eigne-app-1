"""Database tests: migrations up/down, model/migration drift, constraints and authz loading."""

import hashlib
import os
import uuid
from datetime import UTC, datetime
from pathlib import Path

import pytest
from alembic import command
from alembic.autogenerate import compare_metadata
from alembic.config import Config
from alembic.migration import MigrationContext
from sqlalchemy import inspect
from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

from paperless_api.authz import Action, allowed_actions, load_access_context
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

BACKEND = Path(__file__).resolve().parents[1]
TABLES = {
    "users",
    "families",
    "family_members",
    "spaces",
    "space_memberships",
    "documents",
    "file_versions",
}


def _alembic(url: str) -> Config:
    cfg = Config(str(BACKEND / "alembic.ini"))
    cfg.attributes["database_url"] = url
    cfg.attributes["configure_logger"] = False
    return cfg


# Set TEST_POSTGRES_URL (CI does) to also run the migration tests against PostgreSQL.
# The database must be empty and disposable: the tests drop everything they create.
MIGRATION_BACKENDS = ["sqlite"] + (["postgres"] if os.environ.get("TEST_POSTGRES_URL") else [])


@pytest.fixture
def db_url(tmp_path: Path) -> str:
    return f"sqlite+pysqlite:///{tmp_path / 'test.db'}"


@pytest.fixture(params=MIGRATION_BACKENDS)
def migration_url(request, tmp_path: Path):
    if request.param == "sqlite":
        yield f"sqlite+pysqlite:///{tmp_path / 'migrate.db'}"
        return
    url = os.environ["TEST_POSTGRES_URL"]
    yield url
    command.downgrade(_alembic(url), "base")


def test_migration_upgrade_and_rollback(migration_url: str) -> None:
    db_url = migration_url
    cfg = _alembic(db_url)
    command.upgrade(cfg, "head")
    engine = make_engine(db_url)
    assert TABLES <= set(inspect(engine).get_table_names())

    command.downgrade(cfg, "base")
    assert set(inspect(engine).get_table_names()) <= {"alembic_version"}

    command.upgrade(cfg, "head")  # upgrade again after rollback must work
    assert TABLES <= set(inspect(engine).get_table_names())


def test_models_match_migrations(migration_url: str) -> None:
    """Fails if a model changed without a matching Alembic migration."""
    db_url = migration_url
    command.upgrade(_alembic(db_url), "head")
    with make_engine(db_url).connect() as conn:
        diff = compare_metadata(MigrationContext.configure(conn), Base.metadata)
    assert diff == []


@pytest.fixture
def session(db_url: str):
    engine = make_engine(db_url)
    Base.metadata.create_all(engine)
    with Session(engine) as s:
        yield s


def _family(session: Session):
    fam = Family(name="Test family")
    admin = User(email="admin@example.test", display_name="Admin")
    adult = User(email="adult@example.test", display_name="Adult")
    child = User(email="child@example.test", display_name="Child")
    outsider = User(email="out@example.test", display_name="Outsider")
    session.add_all([fam, admin, adult, child, outsider])
    session.flush()
    session.add_all(
        [
            FamilyMember(family_id=fam.id, user_id=admin.id, role=FamilyRole.ADMIN),
            FamilyMember(family_id=fam.id, user_id=adult.id, role=FamilyRole.ADULT),
            FamilyMember(family_id=fam.id, user_id=child.id, role=FamilyRole.CHILD),
        ]
    )
    session.flush()
    return fam, admin, adult, child, outsider


def test_uuid_ids_and_utc_timestamps(session: Session) -> None:
    fam, admin, *_ = _family(session)
    session.commit()
    assert isinstance(fam.id, uuid.UUID)
    assert admin.created_at.tzinfo is not None


def test_duplicate_family_membership_rejected(session: Session) -> None:
    fam, admin, *_ = _family(session)
    session.add(FamilyMember(family_id=fam.id, user_id=admin.id, role=FamilyRole.ADULT))
    with pytest.raises(IntegrityError):
        session.flush()


def test_invalid_enum_value_rejected_by_database(session: Session) -> None:
    fam, *_ = _family(session)
    session.commit()
    with pytest.raises(IntegrityError):
        session.connection().exec_driver_sql(
            "INSERT INTO spaces (id, family_id, name, type, created_at, updated_at) "
            "VALUES (?, ?, 'x', 'public', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)",
            (uuid.uuid4().hex, fam.id.hex),
        )


def test_file_versions_are_unique_per_document_and_hash_checked(session: Session) -> None:
    fam, admin, *_ = _family(session)
    space = Space(family_id=fam.id, name="Haushalt", type=SpaceType.SHARED)
    session.add(space)
    session.flush()
    doc = Document(space_id=space.id, title="Mietvertrag", created_by=admin.id)
    session.add(doc)
    session.flush()
    digest = hashlib.sha256(b"synthetic test bytes").hexdigest()

    def version(no: int, sha: str = digest) -> FileVersion:
        return FileVersion(
            document_id=doc.id,
            version_no=no,
            sha256=sha,
            size_bytes=20,
            mime_type="application/pdf",
            storage_key=f"blob/{uuid.uuid4()}",
        )

    session.add(version(1))
    session.flush()
    assert doc.revision == 1

    session.add(version(1))
    with pytest.raises(IntegrityError):
        session.flush()
    session.rollback()

    session.add(version(2, sha="abc"))
    with pytest.raises(IntegrityError):
        session.flush()


def test_space_with_documents_cannot_be_hard_deleted(session: Session) -> None:
    fam, *_ = _family(session)
    space = Space(family_id=fam.id, name="Archiv", type=SpaceType.SHARED)
    session.add(space)
    session.flush()
    session.add(Document(space_id=space.id, title="x"))
    session.commit()
    with pytest.raises(IntegrityError):
        session.connection().exec_driver_sql("DELETE FROM spaces WHERE id = ?", (space.id.hex,))


def test_load_access_context_end_to_end(session: Session) -> None:
    fam, admin, adult, child, outsider = _family(session)
    private = Space(family_id=fam.id, name="Privat Adult", type=SpaceType.PRIVATE)
    kid = Space(
        family_id=fam.id, name="Schule", type=SpaceType.CHILD_MANAGED, child_user_id=child.id
    )
    session.add_all([private, kid])
    session.flush()
    session.add_all(
        [
            SpaceMembership(space_id=private.id, user_id=adult.id, role=SpaceRole.OWNER),
            SpaceMembership(space_id=kid.id, user_id=child.id, role=SpaceRole.VIEWER),
        ]
    )
    session.commit()

    def acts(user: User, space: Space) -> frozenset[Action]:
        return allowed_actions(load_access_context(session, user.id, space))

    assert Action.READ in acts(adult, private)
    assert acts(admin, private) == frozenset()  # admin is not a backdoor to private spaces
    assert acts(outsider, private) == frozenset()
    assert Action.MANAGE_MEMBERS in acts(admin, kid)  # guardian rule
    assert acts(child, kid) == {Action.READ}
    assert Action.READ in acts(adult, kid)  # second parent is guardian too
    assert acts(outsider, kid) == frozenset()

    adult.disabled_at = datetime.now(UTC)
    session.commit()
    assert acts(adult, private) == frozenset()
    assert acts(User(id=uuid.uuid4(), email="x", display_name="x"), private) == frozenset()
