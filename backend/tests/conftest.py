import os

import pytest
from fastapi.testclient import TestClient
from sqlalchemy.orm import Session, sessionmaker

# Tests must never touch a developer database or emit pretty logs.
os.environ.setdefault("APP_ENV", "test")
os.environ.setdefault("DATABASE_URL", "sqlite+pysqlite:///:memory:")


@pytest.fixture
def db_engine(tmp_path):
    from paperless_api.db.base import Base
    from paperless_api.db.session import make_engine

    engine = make_engine(f"sqlite+pysqlite:///{tmp_path / 'api.sqlite'}")
    Base.metadata.create_all(engine)
    yield engine
    engine.dispose()


@pytest.fixture
def db(db_engine) -> Session:
    with Session(db_engine, expire_on_commit=False) as s:
        yield s


@pytest.fixture
def client(db_engine):
    """API client whose requests use the per-test database."""
    from paperless_api.db.session import get_session
    from paperless_api.main import app

    factory = sessionmaker(db_engine, expire_on_commit=False)

    def _session():
        with factory() as s:
            yield s

    app.dependency_overrides[get_session] = _session
    with TestClient(app) as c:
        yield c
    app.dependency_overrides.clear()
