"""initial family space document schema

Revision ID: 0001
Revises:
Create Date: 2026-11-13 17:48:06.753649
"""

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0001"
down_revision: str | None = None
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:

    op.create_table(
        "families",
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_families")),
    )
    op.create_table(
        "users",
        sa.Column("email", sa.String(length=320), nullable=False),
        sa.Column("display_name", sa.String(length=120), nullable=False),
        sa.Column("disabled_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_users")),
        sa.UniqueConstraint("email", name=op.f("uq_users_email")),
    )
    op.create_table(
        "family_members",
        sa.Column("family_id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column(
            "role",
            sa.Enum(
                "admin",
                "adult",
                "child",
                name="family_role",
                native_enum=False,
                create_constraint=True,
                length=32,
            ),
            nullable=False,
        ),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["family_id"],
            ["families.id"],
            name=op.f("fk_family_members_family_id_families"),
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            ["users.id"],
            name=op.f("fk_family_members_user_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_family_members")),
        sa.UniqueConstraint(
            "family_id", "user_id", name=op.f("uq_family_members_family_id_user_id")
        ),
    )
    with op.batch_alter_table("family_members", schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f("ix_family_members_family_id"), ["family_id"], unique=False
        )
        batch_op.create_index(batch_op.f("ix_family_members_user_id"), ["user_id"], unique=False)

    op.create_table(
        "spaces",
        sa.Column("family_id", sa.Uuid(), nullable=False),
        sa.Column("name", sa.String(length=120), nullable=False),
        sa.Column(
            "type",
            sa.Enum(
                "private",
                "shared",
                "child_managed",
                name="space_type",
                native_enum=False,
                create_constraint=True,
                length=32,
            ),
            nullable=False,
        ),
        sa.Column("child_user_id", sa.Uuid(), nullable=True),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["child_user_id"],
            ["users.id"],
            name=op.f("fk_spaces_child_user_id_users"),
            ondelete="SET NULL",
        ),
        sa.ForeignKeyConstraint(
            ["family_id"],
            ["families.id"],
            name=op.f("fk_spaces_family_id_families"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_spaces")),
    )
    with op.batch_alter_table("spaces", schema=None) as batch_op:
        batch_op.create_index(batch_op.f("ix_spaces_family_id"), ["family_id"], unique=False)

    op.create_table(
        "documents",
        sa.Column("space_id", sa.Uuid(), nullable=False),
        sa.Column("title", sa.String(length=300), nullable=False),
        sa.Column("created_by", sa.Uuid(), nullable=True),
        sa.Column("revision", sa.Integer(), server_default="1", nullable=False),
        sa.Column("deleted_at", sa.DateTime(timezone=True), nullable=True),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.CheckConstraint("revision >= 1", name=op.f("ck_documents_revision_positive")),
        sa.ForeignKeyConstraint(
            ["created_by"],
            ["users.id"],
            name=op.f("fk_documents_created_by_users"),
            ondelete="SET NULL",
        ),
        sa.ForeignKeyConstraint(
            ["space_id"],
            ["spaces.id"],
            name=op.f("fk_documents_space_id_spaces"),
            ondelete="RESTRICT",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_documents")),
    )
    with op.batch_alter_table("documents", schema=None) as batch_op:
        batch_op.create_index(batch_op.f("ix_documents_space_id"), ["space_id"], unique=False)

    op.create_table(
        "space_memberships",
        sa.Column("space_id", sa.Uuid(), nullable=False),
        sa.Column("user_id", sa.Uuid(), nullable=False),
        sa.Column(
            "role",
            sa.Enum(
                "owner",
                "editor",
                "viewer",
                name="space_role",
                native_enum=False,
                create_constraint=True,
                length=32,
            ),
            nullable=False,
        ),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.Column(
            "created_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.Column(
            "updated_at", sa.DateTime(timezone=True), server_default=sa.func.now(), nullable=False
        ),
        sa.ForeignKeyConstraint(
            ["space_id"],
            ["spaces.id"],
            name=op.f("fk_space_memberships_space_id_spaces"),
            ondelete="CASCADE",
        ),
        sa.ForeignKeyConstraint(
            ["user_id"],
            ["users.id"],
            name=op.f("fk_space_memberships_user_id_users"),
            ondelete="CASCADE",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_space_memberships")),
        sa.UniqueConstraint(
            "space_id", "user_id", name=op.f("uq_space_memberships_space_id_user_id")
        ),
    )
    with op.batch_alter_table("space_memberships", schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f("ix_space_memberships_space_id"), ["space_id"], unique=False
        )
        batch_op.create_index(batch_op.f("ix_space_memberships_user_id"), ["user_id"], unique=False)

    op.create_table(
        "file_versions",
        sa.Column("document_id", sa.Uuid(), nullable=False),
        sa.Column("version_no", sa.Integer(), nullable=False),
        sa.Column("sha256", sa.String(length=64), nullable=False),
        sa.Column("size_bytes", sa.BigInteger(), nullable=False),
        sa.Column("mime_type", sa.String(length=127), nullable=False),
        sa.Column("storage_key", sa.String(length=255), nullable=False),
        sa.Column("created_by", sa.Uuid(), nullable=True),
        sa.Column("created_at", sa.DateTime(timezone=True), nullable=False),
        sa.Column("id", sa.Uuid(), nullable=False),
        sa.CheckConstraint("length(sha256) = 64", name=op.f("ck_file_versions_sha256_length")),
        sa.CheckConstraint("size_bytes >= 0", name=op.f("ck_file_versions_size_non_negative")),
        sa.CheckConstraint("version_no >= 1", name=op.f("ck_file_versions_version_no_positive")),
        sa.ForeignKeyConstraint(
            ["created_by"],
            ["users.id"],
            name=op.f("fk_file_versions_created_by_users"),
            ondelete="SET NULL",
        ),
        sa.ForeignKeyConstraint(
            ["document_id"],
            ["documents.id"],
            name=op.f("fk_file_versions_document_id_documents"),
            ondelete="RESTRICT",
        ),
        sa.PrimaryKeyConstraint("id", name=op.f("pk_file_versions")),
        sa.UniqueConstraint(
            "document_id", "version_no", name=op.f("uq_file_versions_document_id_version_no")
        ),
        sa.UniqueConstraint("storage_key", name=op.f("uq_file_versions_storage_key")),
    )
    with op.batch_alter_table("file_versions", schema=None) as batch_op:
        batch_op.create_index(
            batch_op.f("ix_file_versions_document_id"), ["document_id"], unique=False
        )
        batch_op.create_index(batch_op.f("ix_file_versions_sha256"), ["sha256"], unique=False)


def downgrade() -> None:

    with op.batch_alter_table("file_versions", schema=None) as batch_op:
        batch_op.drop_index(batch_op.f("ix_file_versions_sha256"))
        batch_op.drop_index(batch_op.f("ix_file_versions_document_id"))

    op.drop_table("file_versions")
    with op.batch_alter_table("space_memberships", schema=None) as batch_op:
        batch_op.drop_index(batch_op.f("ix_space_memberships_user_id"))
        batch_op.drop_index(batch_op.f("ix_space_memberships_space_id"))

    op.drop_table("space_memberships")
    with op.batch_alter_table("documents", schema=None) as batch_op:
        batch_op.drop_index(batch_op.f("ix_documents_space_id"))

    op.drop_table("documents")
    with op.batch_alter_table("spaces", schema=None) as batch_op:
        batch_op.drop_index(batch_op.f("ix_spaces_family_id"))

    op.drop_table("spaces")
    with op.batch_alter_table("family_members", schema=None) as batch_op:
        batch_op.drop_index(batch_op.f("ix_family_members_user_id"))
        batch_op.drop_index(batch_op.f("ix_family_members_family_id"))

    op.drop_table("family_members")
    op.drop_table("users")
    op.drop_table("families")
