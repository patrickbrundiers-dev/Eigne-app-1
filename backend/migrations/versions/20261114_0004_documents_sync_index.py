"""index for the sync change feed

Revision ID: 0004
Revises: 0003
Create Date: 2026-11-14 09:40:00
"""

from collections.abc import Sequence

from alembic import op

revision: str = "0004"
down_revision: str | None = "0003"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    with op.batch_alter_table("documents", schema=None) as batch_op:
        batch_op.create_index(
            "ix_documents_space_id_updated_at", ["space_id", "updated_at"], unique=False
        )


def downgrade() -> None:
    with op.batch_alter_table("documents", schema=None) as batch_op:
        batch_op.drop_index("ix_documents_space_id_updated_at")
