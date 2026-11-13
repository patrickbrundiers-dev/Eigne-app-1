# Authorization

Status: policy implemented in `backend/src/paperless_api/authz.py`, verified by the exhaustive
matrix in `backend/tests/test_authz_matrix.py`. **Change both together.** No HTTP endpoints
use it yet, because authentication does not exist yet.

## Principles
- Default deny. Users outside the space's family, and disabled users, get nothing.
- Access comes from an explicit `space_memberships` row, with one exception (guardian rule).
- Family **admin is not a backdoor**: no implicit access to private or shared spaces.
- Children can never manage memberships or delete spaces, whatever their space role.
- Private spaces have exactly one effective user (the owner) and cannot be shared;
  to share, convert to a shared space (future feature). Stray memberships are ignored.
- Guardian rule: in a `child_managed` space a family admin acts as owner.
- Denied READ should be answered with HTTP 404, not 403, so space existence isn't leaked.

## Actions
`read` · `write` (import, edit metadata, add versions) · `delete_document` (tombstone) ·
`manage_members` · `delete_space`

Role bundles: viewer = read · editor = read, write, delete_document · owner = all.

## Matrix
R = read, W = write, D = delete_document, M = manage_members, X = delete_space, – = nothing

| Space type | Family role | owner | editor | viewer | no membership |
|---|---|---|---|---|---|
| private | admin | R W D X | – | – | – |
| private | adult | R W D X | – | – | – |
| private | child | R W D | – | – | – |
| shared | admin | all | R W D | R | – |
| shared | adult | all | R W D | R | – |
| shared | child | R W D | R W D | R | – |
| child_managed | admin | all | R W D | R | **all (guardian)** |
| child_managed | adult | all | R W D | R | – |
| child_managed | child | R W D | R W D | R | – |
| any | not in family | – | – | – | – |

## Open questions for review
- Should a second parent with family role `adult` also get the guardian rule? Currently no;
  they need an explicit membership.
- Who may create spaces and change family roles (family-level permissions) is not modelled yet.
- When a child turns 18: migrate the child-managed space into a private space of the child.
