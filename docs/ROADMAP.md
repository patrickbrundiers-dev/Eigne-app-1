# Roadmap

## Phase 1 — Foundation
- [ ] Repository and CI (workflows exist; remote repo + branch protection pending)
- [x] Flutter Android/Windows shell with light/dark themes
- [x] Backend health endpoint
- [x] Database schema and migrations
- [x] Family, user, space and membership model
- [x] Authorization policy tests
- [ ] Local encrypted storage design and implementation review
- [ ] Document import and PDF preview
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

## Phase 4 — Sync and optional cloud
- [ ] Device enrollment
- [ ] Idempotent sync API
- [ ] Conflict handling
- [ ] Encrypted backup target adapters
- [ ] Offline queue and retry

## Phase 5 — Hardening
- [ ] Security review
- [ ] Performance and large-file tests
- [ ] Restore drills
- [ ] Android and Windows release packaging
