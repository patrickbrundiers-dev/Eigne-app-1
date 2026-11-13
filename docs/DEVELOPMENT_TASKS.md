# First development tasks

## T0 — Toolchain verification
- [ ] `flutter doctor` passes for Android and Windows development.
- [ ] Python 3.12+ and Docker Compose available.
- [ ] Record tested tool versions in `docs/TOOLCHAIN.md`.

## T1 — Repository baseline
- [ ] Initialize Git and create `main` plus feature branches.
- [ ] Add branch protection when remote hosting is configured.
- [ ] Require CI checks on pull requests.
- [ ] Add issue templates and pull request template.

## T2 — Flutter shell
- [ ] Run `flutter create . --platforms=android,windows` in `apps/client`.
- [ ] Verify light/dark system theme.
- [ ] Add navigation shell and responsive layout tests.

## T3 — Backend baseline
- [ ] Install backend package.
- [ ] Verify `/health`.
- [ ] Add structured logging with sensitive-data redaction.
- [ ] Add API version prefix `/api/v1`.

## T4 — Data model design
- [ ] ER diagram for users, families, spaces, memberships, documents and file versions.
- [ ] Define UUID strategy and timestamps.
- [ ] Define migrations and test migration rollback.
- [ ] Add authorization matrix and tests.

## T5 — Document lifecycle
- [ ] Define import staging area.
- [ ] Validate file type by content, not filename alone.
- [ ] Set file size and page-count limits.
- [ ] Calculate content hash for duplicate detection.
- [ ] Add safe PDF preview.
- [ ] Keep original file immutable.

## Definition of Done
A task is complete only when code, tests, documentation and acceptance evidence are included. Never use real family documents in development tests.
