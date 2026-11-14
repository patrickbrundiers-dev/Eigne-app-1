"""Exhaustive authorization matrix. Every combination of space type, family role and space
role is listed explicitly, so a policy change shows up as a reviewable diff here.
Keep docs/AUTHORIZATION.md in sync with this table."""

import itertools

import pytest

from paperless_api.authz import (
    AccessContext,
    Action,
    PermissionDenied,
    allowed_actions,
    require,
)
from paperless_api.db.models import FamilyRole, SpaceRole, SpaceType

R, W, D, M, X = (
    Action.READ,
    Action.WRITE,
    Action.DELETE_DOCUMENT,
    Action.MANAGE_MEMBERS,
    Action.DELETE_SPACE,
)
NONE: set[Action] = set()
VIEW = {R}
EDIT = {R, W, D}
OWN = {R, W, D, M, X}

P, S, C = SpaceType.PRIVATE, SpaceType.SHARED, SpaceType.CHILD_MANAGED
ADMIN, ADULT, CHILD = FamilyRole.ADMIN, FamilyRole.ADULT, FamilyRole.CHILD
OWNER, EDITOR, VIEWER = SpaceRole.OWNER, SpaceRole.EDITOR, SpaceRole.VIEWER

# (space type, family role, explicit space role) -> allowed actions
MATRIX: dict[tuple[SpaceType, FamilyRole | None, SpaceRole | None], set[Action]] = {
    # Private: only the owner, and nobody can be added. Admin gets nothing.
    (P, ADMIN, OWNER): {R, W, D, X},
    (P, ADMIN, EDITOR): NONE,
    (P, ADMIN, VIEWER): NONE,
    (P, ADMIN, None): NONE,
    (P, ADULT, OWNER): {R, W, D, X},
    (P, ADULT, EDITOR): NONE,
    (P, ADULT, VIEWER): NONE,
    (P, ADULT, None): NONE,
    (P, CHILD, OWNER): {R, W, D},
    (P, CHILD, EDITOR): NONE,
    (P, CHILD, VIEWER): NONE,
    (P, CHILD, None): NONE,
    # Shared: explicit membership only. Admin without membership gets nothing.
    (S, ADMIN, OWNER): OWN,
    (S, ADMIN, EDITOR): EDIT,
    (S, ADMIN, VIEWER): VIEW,
    (S, ADMIN, None): NONE,
    (S, ADULT, OWNER): OWN,
    (S, ADULT, EDITOR): EDIT,
    (S, ADULT, VIEWER): VIEW,
    (S, ADULT, None): NONE,
    (S, CHILD, OWNER): EDIT,
    (S, CHILD, EDITOR): EDIT,
    (S, CHILD, VIEWER): VIEW,
    (S, CHILD, None): NONE,
    # Child-managed: admins and adults are guardians (owner-equivalent); children need membership.
    (C, ADMIN, OWNER): OWN,
    (C, ADMIN, EDITOR): EDIT,
    (C, ADMIN, VIEWER): VIEW,
    (C, ADMIN, None): OWN,
    (C, ADULT, OWNER): OWN,
    (C, ADULT, EDITOR): EDIT,
    (C, ADULT, VIEWER): VIEW,
    (C, ADULT, None): OWN,
    (C, CHILD, OWNER): EDIT,
    (C, CHILD, EDITOR): EDIT,
    (C, CHILD, VIEWER): VIEW,
    (C, CHILD, None): NONE,
}
# Outside the family: never any access, whatever stray membership rows exist.
for st, sr in itertools.product(SpaceType, [*SpaceRole, None]):
    MATRIX[(st, None, sr)] = NONE


def test_matrix_is_complete() -> None:
    expected = set(itertools.product(SpaceType, [*FamilyRole, None], [*SpaceRole, None]))
    assert set(MATRIX) == expected


@pytest.mark.parametrize(("key", "expected"), sorted(MATRIX.items(), key=str), ids=str)
def test_policy_matches_matrix(key, expected) -> None:
    space_type, family_role, space_role = key
    ctx = AccessContext(space_type=space_type, family_role=family_role, space_role=space_role)
    assert allowed_actions(ctx) == expected


@pytest.mark.parametrize("key", list(MATRIX), ids=str)
def test_disabled_user_gets_nothing(key) -> None:
    space_type, family_role, space_role = key
    ctx = AccessContext(space_type, family_role, space_role, actor_active=False)
    assert allowed_actions(ctx) == frozenset()


def test_require_raises_for_denied_action() -> None:
    ctx = AccessContext(SpaceType.PRIVATE, FamilyRole.ADMIN, None)
    with pytest.raises(PermissionDenied):
        require(ctx, Action.READ)
    require(AccessContext(SpaceType.SHARED, FamilyRole.ADULT, SpaceRole.VIEWER), Action.READ)
