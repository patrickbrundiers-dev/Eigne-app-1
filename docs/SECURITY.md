# Security plan

This document is a design checklist, not a security certification.

## Before real documents are used
1. Write a threat model and data-flow diagram.
2. Define family/space/document authorization rules.
3. Define key hierarchy, device enrollment, rotation and recovery.
4. Choose and review vetted cryptographic libraries; do not implement cryptography manually.
5. Encrypt local database and document blobs. (Server blobs: done, see STORAGE_ENCRYPTION.md;
   server DB and client storage: open.)
6. Use TLS for all network communication.
7. Ensure logs never contain document text, tokens, passwords or keys.
8. Test backup restore and key recovery.
9. Perform dependency and static security scans.

## Key architecture questions
- Who can decrypt a private adult space?
- Can a server operator read document contents? Default answer should be no.
  Current state: files are encrypted at rest, but the running server can read them
  (previews/OCR). E2E encryption is to be decided with the sync design.
- Where does local AI run, and where are plaintext documents available?
- What happens when a device is lost or removed?
- How can a user recover access without weakening encryption?

## Non-goals for Phase 1
No production authentication, E2E sync, or production-ready cryptographic implementation is included in the initial scaffold.
