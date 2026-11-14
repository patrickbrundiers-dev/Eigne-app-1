# Changelog

## 0.4.0 — Authentication

- Accounts with argon2id password hashes; lockout after repeated failures; one generic
  error for every failed login.
- Device sessions with opaque bearer tokens (only SHA-256 stored), absolute and idle expiry,
  per-device revoke. Password change ends all sessions.
- API: `/api/v1/auth/login`, `/logout`, `/me`, `/sessions`, `DELETE /sessions/{id}`.
- Admin CLI `paperless-admin` to create users, families, members, spaces and grants.
- Migration `0003`: `users.password_hash`, `failed_logins`, `locked_until`, table `device_sessions`.
- Alembic renders `UTCDateTime` as `sa.DateTime(timezone=True)` in generated migrations.
- Docs: `docs/AUTHENTICATION.md`. 26 new tests.

## 0.3.0 — T5: document import pipeline

- New `paperless_api.documents`: streaming staging area with SHA-256 and size limit,
  content-based type detection (PDF, PNG, JPEG, TIFF, WebP allowlist), PDF inspection
  (page limit, encrypted PDFs rejected, JavaScript/Launch actions rejected, attachments
  such as ZUGFeRD XML allowed), image pixel limit, duplicate check per space,
  write-once read-only blob store, import service with authorization and rollback.
- Safe preview: page 1 rendered to PNG in a separate, time- and memory-limited process;
  metadata (EXIF/GPS) dropped.
- Plaintext blob store must be enabled explicitly and is refused in production.
- Migration `0002`: `file_versions.page_count`, `file_versions.original_filename`.
- Docs: `docs/DOCUMENT_IMPORT.md`. 46 new tests (164 in total).

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
