from logging.config import fileConfig

from alembic import context
from sqlalchemy import pool

from paperless_api.config import get_settings
from paperless_api.db import models  # noqa: F401  (registers tables on Base.metadata)
from paperless_api.db.base import Base
from paperless_api.db.session import make_engine

config = context.config
if config.config_file_name is not None and config.attributes.get("configure_logger", True):
    fileConfig(config.config_file_name)

target_metadata = Base.metadata


def _url() -> str:
    # Tests may inject a URL via config attributes; otherwise use DATABASE_URL.
    return config.attributes.get("database_url") or get_settings().database_url


def run_migrations_offline() -> None:
    context.configure(
        url=_url(),
        target_metadata=target_metadata,
        literal_binds=True,
        render_as_batch=True,
        compare_type=True,
    )
    with context.begin_transaction():
        context.run_migrations()


def run_migrations_online() -> None:
    connection = config.attributes.get("connection")
    if connection is not None:
        _run(connection)
        return
    engine = make_engine(_url(), poolclass=pool.NullPool)
    with engine.connect() as conn:
        _run(conn)


def _run(connection) -> None:
    context.configure(
        connection=connection,
        target_metadata=target_metadata,
        render_as_batch=True,  # SQLite needs batch mode for ALTER TABLE
        compare_type=True,
    )
    with context.begin_transaction():
        context.run_migrations()


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
