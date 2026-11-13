# Toolchain

Record exact tested versions here before the first release.

- Flutter: 3.50.0 stable (Dart 3.14.0), verified in CI-like Linux env on 2026-11-13
  (`flutter analyze`, `flutter test`). Android/Windows builds still need local verification.
  Note: Flutter 3.47+ deprecates `package:flutter/material.dart` in favour of `material_ui`;
  the deprecation is silenced in `analysis_options.yaml` until we raise the minimum SDK.
- Dart: bundled with Flutter
- Python: 3.12+ (CI: 3.12; also tested locally with 3.13)
- Backend libs tested: FastAPI 0.162, SQLAlchemy 2.1, Alembic 1.20, psycopg 3.3, pytest 8.4, ruff 0.17
- PostgreSQL: 16 (migrations tested against 16.15)
- Docker Compose: v2
- Ollama: later phase
- OCR engine: later phase

Do not assume CI and developer machines use identical versions until pinned and verified.
