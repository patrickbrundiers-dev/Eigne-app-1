# Roadmap

## Phase 1 — Foundation
- [ ] Repository and CI (workflows exist; remote repo + branch protection pending)
- [x] Flutter Android/Windows shell with light/dark themes
- [x] Backend health endpoint
- [x] Database schema and migrations
- [x] Family, user, space and membership model
- [x] Authorization policy tests
- [ ] Local encrypted storage design and implementation review
- [ ] Document import and PDF preview (backend pipeline done; endpoint + UI pending auth)
- [ ] Search and categories
- [ ] Backup and restore proof

## Phase 2 — Document intelligence
- [ ] OCR pipeline
- [ ] Classification
- [ ] Structured extraction with confidence values
- [ ] Human review and correction
- [ ] Local model adapter (Ollama)
- [ ] Source-grounded document Q&A

## Phase 3 — Workflow
- [ ] Contracts and invoices
- [ ] Deadlines and reminders
- [ ] Recurring payment detection
- [ ] Document comparison

## Serverless family sync over Google Drive (decided 2026-11-14)
Plan: https://claude.ai/artifact/2T9qB6ZTYTXLBdgwjq74RB. Setup for the owner: docs/GOOGLE_SETUP.de.md.
- [ ] D0 Verify whether `drive.file` can read files in a shared folder (else full `drive` scope)
- [ ] D1 Google sign-in (Android, Windows), personal key pair, vault password, recovery code
- [ ] D2 Encrypted documents in Drive, per-device change logs, Drive Changes API sync, on-device previews
- [ ] D3 Family: invite, roles, private and child spaces, read/write via folder permissions, key rotation on removal
- [ ] D4 Import from Drive, one-time move from the optional server

## Phase 4 — Sync and optional cloud
- [ ] Device enrollment
- [x] Sync change feed (`/api/v1/sync`, see docs/SYNC.md)
- [ ] Conflict handling
- [ ] Encrypted backup target adapters
- [x] Offline cache, upload queue and retry in the app

## Phase 5 — Hardening
- [ ] Security review
- [ ] Performance and large-file tests
- [ ] Restore drills
- [ ] Android and Windows release packaging
