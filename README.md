# Paperless AI

Local-first document management for Android and Windows, with optional self-hosted sync and local AI.

## Status
**Phase 1 scaffold** — repository structure and development foundations only. Authentication, production encryption, OCR, AI and synchronization are not implemented yet.

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
   uvicorn paperless_api.main:app --reload --app-dir backend/src
   ```
4. Open `http://127.0.0.1:8000/docs`.

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
flutter create . --platforms=android,windows
flutter run -d windows
```
The `lib/` directory contains the initial application entry point. Run `flutter create .` only after installing Flutter.

## Development rules
- Never commit `.env`, credentials, real personal documents or encryption keys.
- Keep private family spaces private by default.
- Enforce authorization in the backend, not only in the UI.
- Do not claim production-ready encryption until key lifecycle, recovery, threat model and tests are reviewed.
- All schema changes require migrations.
- Every feature needs tests and documentation.

## Roadmap
See `docs/ROADMAP.md`, `docs/ARCHITECTURE.md` and `docs/SECURITY.md`.
