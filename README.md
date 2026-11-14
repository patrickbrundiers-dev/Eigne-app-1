# Paperless AI

Local-first document management for Android and Windows, with optional self-hosted sync and local AI.

## Status
**Phase 1, in progress.** Done: backend baseline (`/api/v1`, settings, redacting JSON logs),
data model with migrations, authorization policy, authentication with device sessions,
document import with safe preview and a documents API, responsive Flutter shell.
Not implemented yet: encrypted storage, OCR, AI and synchronization. See `CHANGELOG.md`.

## Stack
- Flutter/Dart: Android + Windows clients
- Python/FastAPI: optional backend
- PostgreSQL: server metadata
- SQLite: local device metadata (planned)
- Docker Compose: local backend development
- GitHub Actions: CI

## Quick start

### Backend
1. Install Python 3.12+.
2. Copy `backend/.env.example` to `backend/.env`.
3. From the repository root:
   ```bash
   python -m venv .venv
   # Windows: .venv\\Scripts\\activate
   # Linux/macOS: source .venv/bin/activate
   pip install -e ./backend[dev]
   cd backend
   alembic upgrade head        # creates the schema (SQLite file by default)
   paperless-admin create-user --email you@example.org --name You   # see docs/AUTHENTICATION.md
   uvicorn paperless_api.main:app --reload --app-dir src
   ```
4. Open `http://127.0.0.1:8000/docs` (health: `/api/v1/health`).
5. Tests and lint: `pytest` and `ruff check . && ruff format --check .` in `backend/`.
   Set `TEST_POSTGRES_URL` to an empty, disposable database to also test migrations on PostgreSQL.

### Docker services
```bash
docker compose up -d db
```
The database is for development only. Do not expose it to the internet.

### Flutter
Install Flutter and enable the Windows desktop target if developing on Windows:
```bash
flutter doctor
cd apps/client
flutter pub get
flutter test
flutter run -d windows
```
Android and Windows platform folders are already generated.

## Development rules
- Never commit `.env`, credentials, real personal documents or encryption keys.
- Keep private family spaces private by default.
- Enforce authorization in the backend, not only in the UI.
- Do not claim production-ready encryption until key lifecycle, recovery, threat model and tests are reviewed.
- All schema changes require migrations.
- Every feature needs tests and documentation.

## Roadmap
See `docs/ROADMAP.md`, `docs/ARCHITECTURE.md`, `docs/AUTHENTICATION.md`, `docs/DOCUMENT_IMPORT.md`, `docs/DATA_MODEL.md`, `docs/AUTHORIZATION.md` and `docs/SECURITY.md`.
