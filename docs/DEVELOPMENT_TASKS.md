# First development tasks

## T0 — Toolchain verification
- [ ] `flutter doctor` passes for Android and Windows development.
- [ ] Python 3.12+ and Docker Compose available.
- [ ] Record tested tool versions in `docs/TOOLCHAIN.md`.

## T1 — Repository baseline
- [x] Initialize Git and create `main` plus feature branches.
- [ ] Add branch protection when remote hosting is configured.
- [ ] Require CI checks on pull requests.
- [ ] Add issue templates and pull request template.

## T2 — Flutter shell
- [x] Run `flutter create . --platforms=android,windows` in `apps/client`.
- [x] Verify light/dark system theme (widget test `themes`).
- [x] Add navigation shell and responsive layout tests (`test/app_shell_test.dart`).

## T3 — Backend baseline
- [x] Install backend package.
- [x] Verify `/health`.
- [x] Add structured logging with sensitive-data redaction (`logging_config.py`).
- [x] Add API version prefix `/api/v1`.

## T4 — Data model design
- [x] ER diagram for users, families, spaces, memberships, documents and file versions (`docs/DATA_MODEL.md`).
- [x] Define UUID strategy and timestamps.
- [x] Define migrations and test migration rollback (Alembic, SQLite + PostgreSQL).
- [x] Add authorization matrix and tests (`docs/AUTHORIZATION.md`).

## T5 — Document lifecycle
- [ ] Define import staging area.
- [ ] Validate file type by content, not filename alone.
- [ ] Set file size and page-count limits.
- [ ] Calculate content hash for duplicate detection.
- [ ] Add safe PDF preview.
- [ ] Keep original file immutable.

## Definition of Done
A task is complete only when code, tests, documentation and acceptance evidence are included. Never use real family documents in development tests.
