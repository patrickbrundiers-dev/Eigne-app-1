"""Authorization policy for family spaces.

The policy is a pure function over an `AccessContext`, so it can be tested exhaustively
without a database (see tests/test_authz_matrix.py). `load_access_context` builds the context
from the database. The full rule set is documented in docs/AUTHORIZATION.md; keep both in sync.

Default is deny. Access is only granted by
  1. an explicit SpaceMembership, or
  2. the guardian rule: family *admins and adults* act as owners of *child-managed* spaces.
Neither admins nor adults have implicit access to private or shared spaces.
"""

from __future__ import annotations

import enum
import uuid
from dataclasses import dataclass

from sqlalchemy import select
from sqlalchemy.orm import Session

from paperless_api.db.models import (
    FamilyMember,
    FamilyRole,
    Space,
    SpaceMembership,
    SpaceRole,
    SpaceType,
    User,
)


class Action(enum.StrEnum):
    READ = "read"  # list/view documents and their metadata
    WRITE = "write"  # import documents, edit metadata, add file versions
    DELETE_DOCUMENT = "delete_document"  # tombstone a document
    MANAGE_MEMBERS = "manage_members"  # add/remove/change space memberships
    DELETE_SPACE = "delete_space"


ROLE_ACTIONS: dict[SpaceRole, frozenset[Action]] = {
    SpaceRole.VIEWER: frozenset({Action.READ}),
    SpaceRole.EDITOR: frozenset({Action.READ, Action.WRITE, Action.DELETE_DOCUMENT}),
    SpaceRole.OWNER: frozenset(Action),
}

# Children never manage memberships or delete spaces, whatever their space role says.
CHILD_FORBIDDEN: frozenset[Action] = frozenset({Action.MANAGE_MEMBERS, Action.DELETE_SPACE})

# Family roles that act as guardians (owner) of every child-managed space in the family.
GUARDIAN_ROLES: frozenset[FamilyRole] = frozenset({FamilyRole.ADMIN, FamilyRole.ADULT})

# Private spaces cannot be shared; convert to a shared space instead.
PRIVATE_FORBIDDEN: frozenset[Action] = frozenset({Action.MANAGE_MEMBERS})


@dataclass(frozen=True, slots=True)
class AccessContext:
    space_type: SpaceType
    family_role: FamilyRole | None  # None -> actor is not in the space's family
    space_role: SpaceRole | None  # explicit membership, if any
    actor_active: bool = True


def allowed_actions(ctx: AccessContext) -> frozenset[Action]:
    if not ctx.actor_active or ctx.family_role is None:
        return frozenset()

    role = ctx.space_role
    if ctx.space_type is SpaceType.PRIVATE and role is not SpaceRole.OWNER:
        # Only the owner may ever access a private space; stray memberships are ignored.
        role = None
    if (
        role is None
        and ctx.space_type is SpaceType.CHILD_MANAGED
        and ctx.family_role in GUARDIAN_ROLES
    ):
        role = SpaceRole.OWNER  # guardian rule

    if role is None:
        return frozenset()

    actions = ROLE_ACTIONS[role]
    if ctx.family_role is FamilyRole.CHILD:
        actions = actions - CHILD_FORBIDDEN
    if ctx.space_type is SpaceType.PRIVATE:
        actions = actions - PRIVATE_FORBIDDEN
    return actions


def is_allowed(ctx: AccessContext, action: Action) -> bool:
    return action in allowed_actions(ctx)


class PermissionDenied(Exception):
    """Raised when an action is not allowed. Map to HTTP 404 for READ (do not reveal
    existence of spaces the actor cannot see) and 403 otherwise."""


def require(ctx: AccessContext, action: Action) -> None:
    if not is_allowed(ctx, action):
        raise PermissionDenied(action.value)


def load_access_context(session: Session, user_id: uuid.UUID, space: Space) -> AccessContext:
    user = session.get(User, user_id)
    family_role = session.scalar(
        select(FamilyMember.role).where(
            FamilyMember.family_id == space.family_id, FamilyMember.user_id == user_id
        )
    )
    space_role = session.scalar(
        select(SpaceMembership.role).where(
            SpaceMembership.space_id == space.id, SpaceMembership.user_id == user_id
        )
    )
    return AccessContext(
        space_type=space.type,
        family_role=family_role,
        space_role=space_role,
        actor_active=user is not None and user.disabled_at is None,
    )
