# Changelog

## Unreleased

- Direction: the apps will sync directly over Google Drive without a server (plan linked in
  `docs/ROADMAP.md`). The server stays as an optional variant.
- Docs: `docs/GOOGLE_SETUP.de.md`, setup of the Android signing key and the Google Cloud project.
- D1 part 1: client-side vault (X25519 + Ed25519 keys, Argon2id password, recovery code),
  space keys wrapped per member, document encryption with context binding, signatures.
  `docs/DRIVE_CRYPTO.md`, 14 new tests.

## 0.8.0 — Sync between phone and PC

- Change feed `GET /api/v1/sync`: changed and deleted documents of all readable spaces,
  cursor paging with a two-minute overlap, current space list; migration 0004 (index).
- App: offline cache of the document list, start without network from the cache with an
  offline banner, upload queue for imports without network, sync on start, on resume,
  every 5 minutes, after imports and on pull-to-refresh. Sign-out wipes the cache.
- Docs: `docs/SYNC.md`, Tailscale guide `docs/TAILSCALE.de.md`. 10 backend and 13 client tests.

## App builds

- GitHub Actions workflow "Build apps": Windows installer (Inno Setup) + portable ZIP and
  Android APK as downloadable artifacts; a manual run with `release_tag` publishes a
  GitHub Release.
- Android release signing from repository secrets (falls back to debug key).
- App name "Paperless AI" on Android and Windows; app version 0.7.0+7.
- Docs: `docs/BUILDS.md`.

## 0.7.0 — Encryption at rest

- Documents and preview images are encrypted with AES-256-GCM (envelope encryption, one
  data key per file, bound to its storage key, tamper-evident).
- Master key from `STORAGE_MASTER_KEY_FILE` or `STORAGE_MASTER_KEY`; rotation via
  `STORAGE_OLD_MASTER_KEYS`.
- `paperless-admin generate-key` and `paperless-admin encrypt-storage` (encrypts old plaintext
  files and rotates to the current key; idempotent, verified, atomic).
- Preview cache moved into the store (encrypted); downloads decrypt in memory.
- Docs: `docs/STORAGE_ENCRYPTION.md` incl. threat model. 14 new tests.

## 0.6.0 — Flutter: server login and document import

- Login page (server, e-mail, password); token in secure storage, restored on start,
  dropped automatically when the server rejects it.
- HTTPS required, plain HTTP only for localhost / Android emulator.
- "Dokument importieren" works: file dialog (PDF, PNG, JPEG, TIFF, WebP), choice of
  target space when several are writable, German messages for every server error code.
- Documents page: space selector, list, preview dialog. Settings: account and logout.
- Android: INTERNET permission. New packages: http, file_picker, flutter_secure_storage.
- 13 new Flutter tests (fake backend), 20 in total.

## 0.5.0 — Documents API

- `GET /api/v1/spaces`, `GET/POST /api/v1/spaces/{id}/documents`,
  `GET/DELETE /api/v1/documents/{id}`, `GET .../preview`, `GET .../file`.
- 404 for unreadable spaces/documents, 403 for readable but forbidden actions,
  error bodies with stable `code`.
- Preview cache per immutable file version; downloads always as attachment with
  `Content-Security-Policy: sandbox`; `nosniff` and `no-referrer` on all responses.
- Oversized requests rejected by `Content-Length` before the body is read.
- 10 new API tests.

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
