"""file version page count and filename

Revision ID: 0002
Revises: 0001
Create Date: 2026-11-14 07:07:55.586740
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0002"
down_revision: str | None = "0001"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    with op.batch_alter_table("file_versions", schema=None) as batch_op:
        batch_op.add_column(sa.Column("page_count", sa.Integer(), nullable=True))
        batch_op.add_column(sa.Column("original_filename", sa.String(length=255), nullable=True))


def downgrade() -> None:
    with op.batch_alter_table("file_versions", schema=None) as batch_op:
        batch_op.drop_column("original_filename")
        batch_op.drop_column("page_count")
