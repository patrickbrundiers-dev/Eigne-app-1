"""Server-side metadata model: users, families, spaces, memberships, documents, file versions.

See docs/DATA_MODEL.md for the ER diagram and docs/AUTHORIZATION.md for the access rules.
No document content is stored here; file versions only reference encrypted blobs by key.
"""

from __future__ import annotations

import enum
import uuid
from datetime import datetime

from sqlalchemy import (
    BigInteger,
    CheckConstraint,
    Enum,
    ForeignKey,
    Integer,
    String,
    UniqueConstraint,
    Uuid,
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from paperless_api.db.base import Base, Timestamps, UTCDateTime, UuidPk, utcnow


class FamilyRole(enum.StrEnum):
    ADMIN = "admin"
    ADULT = "adult"
    CHILD = "child"


class SpaceType(enum.StrEnum):
    PRIVATE = "private"
    SHARED = "shared"
    CHILD_MANAGED = "child_managed"


class SpaceRole(enum.StrEnum):
    OWNER = "owner"
    EDITOR = "editor"
    VIEWER = "viewer"


def _enum(e: type[enum.Enum], name: str) -> Enum:
    # native_enum=False -> portable VARCHAR + CHECK constraint (SQLite and PostgreSQL).
    return Enum(
        e,
        name=name,
        native_enum=False,
        create_constraint=True,
        length=32,
        values_callable=lambda members: [m.value for m in members],
    )


class User(UuidPk, Timestamps, Base):
    __tablename__ = "users"

    email: Mapped[str] = mapped_column(String(320), nullable=False, unique=True)
    display_name: Mapped[str] = mapped_column(String(120), nullable=False)
    disabled_at: Mapped[datetime | None] = mapped_column(UTCDateTime)

    memberships: Mapped[list[FamilyMember]] = relationship(back_populates="user")


class Family(UuidPk, Timestamps, Base):
    __tablename__ = "families"

    name: Mapped[str] = mapped_column(String(120), nullable=False)

    members: Mapped[list[FamilyMember]] = relationship(
        back_populates="family", cascade="all, delete-orphan"
    )
    spaces: Mapped[list[Space]] = relationship(
        back_populates="family", cascade="all, delete-orphan"
    )


class FamilyMember(UuidPk, Timestamps, Base):
    __tablename__ = "family_members"
    __table_args__ = (UniqueConstraint("family_id", "user_id"),)

    family_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("families.id", ondelete="CASCADE"), nullable=False, index=True
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True
    )
    role: Mapped[FamilyRole] = mapped_column(_enum(FamilyRole, "family_role"), nullable=False)

    family: Mapped[Family] = relationship(back_populates="members")
    user: Mapped[User] = relationship(back_populates="memberships")


class Space(UuidPk, Timestamps, Base):
    __tablename__ = "spaces"

    family_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("families.id", ondelete="CASCADE"), nullable=False, index=True
    )
    name: Mapped[str] = mapped_column(String(120), nullable=False)
    type: Mapped[SpaceType] = mapped_column(_enum(SpaceType, "space_type"), nullable=False)
    # For child-managed spaces: the child the space is about. NULL for other types.
    child_user_id: Mapped[uuid.UUID | None] = mapped_column(
        Uuid, ForeignKey("users.id", ondelete="SET NULL")
    )

    family: Mapped[Family] = relationship(back_populates="spaces")
    memberships: Mapped[list[SpaceMembership]] = relationship(
        back_populates="space", cascade="all, delete-orphan"
    )
    documents: Mapped[list[Document]] = relationship(back_populates="space")


class SpaceMembership(UuidPk, Timestamps, Base):
    """Explicit ACL entry. Access to a space is only ever granted through these rows
    (plus the narrow guardian rule for child-managed spaces, see authz.py)."""

    __tablename__ = "space_memberships"
    __table_args__ = (UniqueConstraint("space_id", "user_id"),)

    space_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("spaces.id", ondelete="CASCADE"), nullable=False, index=True
    )
    user_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("users.id", ondelete="CASCADE"), nullable=False, index=True
    )
    role: Mapped[SpaceRole] = mapped_column(_enum(SpaceRole, "space_role"), nullable=False)

    space: Mapped[Space] = relationship(back_populates="memberships")


class Document(UuidPk, Timestamps, Base):
    __tablename__ = "documents"
    __table_args__ = (CheckConstraint("revision >= 1", name="revision_positive"),)

    space_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("spaces.id", ondelete="RESTRICT"), nullable=False, index=True
    )
    title: Mapped[str] = mapped_column(String(300), nullable=False)
    created_by: Mapped[uuid.UUID | None] = mapped_column(
        Uuid, ForeignKey("users.id", ondelete="SET NULL")
    )
    # Optimistic concurrency for metadata updates (sync conflict detection).
    revision: Mapped[int] = mapped_column(Integer, nullable=False, default=1, server_default="1")
    # Tombstone: deletes are soft until the retention policy purges them.
    deleted_at: Mapped[datetime | None] = mapped_column(UTCDateTime)

    space: Mapped[Space] = relationship(back_populates="documents")
    versions: Mapped[list[FileVersion]] = relationship(
        back_populates="document", order_by="FileVersion.version_no"
    )


class FileVersion(UuidPk, Base):
    """Immutable version of a document's file. Never updated after insert."""

    __tablename__ = "file_versions"
    __table_args__ = (
        UniqueConstraint("document_id", "version_no"),
        CheckConstraint("version_no >= 1", name="version_no_positive"),
        CheckConstraint("size_bytes >= 0", name="size_non_negative"),
        CheckConstraint("length(sha256) = 64", name="sha256_length"),
    )

    document_id: Mapped[uuid.UUID] = mapped_column(
        Uuid, ForeignKey("documents.id", ondelete="RESTRICT"), nullable=False, index=True
    )
    version_no: Mapped[int] = mapped_column(Integer, nullable=False)
    # Hex SHA-256 of the *plaintext* original, for duplicate detection within a space.
    sha256: Mapped[str] = mapped_column(String(64), nullable=False, index=True)
    size_bytes: Mapped[int] = mapped_column(BigInteger, nullable=False)
    # MIME type detected from content (not filename), see DEVELOPMENT_TASKS T5.
    mime_type: Mapped[str] = mapped_column(String(127), nullable=False)
    # Opaque key into encrypted blob storage. Never a user-supplied path.
    storage_key: Mapped[str] = mapped_column(String(255), nullable=False, unique=True)
    created_by: Mapped[uuid.UUID | None] = mapped_column(
        Uuid, ForeignKey("users.id", ondelete="SET NULL")
    )
    created_at: Mapped[datetime] = mapped_column(UTCDateTime, nullable=False, default=utcnow)

    document: Mapped[Document] = relationship(back_populates="versions")
