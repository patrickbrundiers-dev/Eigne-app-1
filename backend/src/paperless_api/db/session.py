from collections.abc import Iterator

from sqlalchemy import Engine, create_engine, event
from sqlalchemy.orm import Session, sessionmaker

from paperless_api.config import get_settings


def make_engine(url: str | None = None, **kwargs) -> Engine:
    url = url or get_settings().database_url
    kwargs.setdefault("pool_pre_ping", True)
    engine = create_engine(url, **kwargs)
    if engine.dialect.name == "sqlite":
        # SQLite ignores foreign keys unless enabled per connection.
        @event.listens_for(engine, "connect")
        def _fk_on(dbapi_conn, _record) -> None:  # pragma: no cover - trivial
            cur = dbapi_conn.cursor()
            cur.execute("PRAGMA foreign_keys=ON")
            cur.close()

    return engine


_engine: Engine | None = None
_SessionLocal: sessionmaker[Session] | None = None


def get_session() -> Iterator[Session]:
    """FastAPI dependency yielding a session bound to the configured database."""
    global _engine, _SessionLocal
    if _SessionLocal is None:
        _engine = make_engine()
        _SessionLocal = sessionmaker(_engine, expire_on_commit=False)
    with _SessionLocal() as session:
        yield session
