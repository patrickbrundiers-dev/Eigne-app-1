# Changelog

## 0.2.0 — Phase 1: backend baseline, data model, authorization, navigation shell

### Backend
- Settings via `pydantic-settings` (`APP_ENV`, `DATABASE_URL`, `LOG_LEVEL`, `LOG_JSON`).
- Structured JSON logging with redaction of passwords, tokens, keys, URL credentials and
  document text; request log with request id (method/path/status only).
- API version prefix: `GET /api/v1/health`. `/health` stays as unversioned liveness probe.
  Swagger UI disabled when `APP_ENV=production`.
- SQLAlchemy 2 models: users, families, family members, spaces, space memberships,
  documents (revision + tombstone), immutable file versions. UUID keys, UTC timestamps.
- Alembic setup with first migration `0001`; tested upgrade/rollback on SQLite and PostgreSQL,
  plus a drift check between models and migrations.
- Authorization policy (`authz.py`) with exhaustive test matrix (48 combinations, plus disabled users).
- CI: PostgreSQL 16 service for migration tests, `ruff format --check`.

### Flutter client
- Android and Windows platform folders generated.
- Code split into `app.dart`, `shell/`, `pages/`.
- Responsive navigation shell: Übersicht, Posteingang, Dokumente, Fristen, Einstellungen.
- Widget tests for phone/tablet/desktop layouts, navigation and light/dark theme.
- Import button disabled until encrypted local storage is approved (T5).

### Docs
- New: `docs/DATA_MODEL.md` (ER diagram, decisions), `docs/AUTHORIZATION.md` (matrix).
- Updated task list, roadmap, toolchain versions, READMEs.
