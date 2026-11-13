# Architecture

## Principles
- Local-first: core document access must remain usable without a server.
- Server optional: sync and shared-family coordination are separate services.
- Cloud optional: no mandatory external storage or AI provider.
- Least privilege: every document belongs to a family space and has explicit access policy.
- Encryption by design: approve a threat model and key lifecycle before storing real documents.

## Components
- Flutter client: Android and Windows UI, local database, encrypted local file store, sync outbox.
- FastAPI service: identity, family membership, authorization, sync protocol and metadata APIs.
- PostgreSQL: server-side metadata and synchronization state.
- Object/file storage: encrypted document blobs.
- Local AI worker: OCR, classification, extraction and retrieval on an explicitly trusted device/server.

## Important design constraint
Do not directly replicate SQLite into PostgreSQL. Use versioned API operations with stable UUIDs, idempotency keys, per-device cursors and explicit conflict handling.

## Family model
A family contains users and spaces. Suggested space types: private, shared, child-managed. Access is granted through membership/ACL records. Admin role does not imply automatic read access to private adult spaces.

## Sync conflict policy
- Immutable document blob versions.
- Metadata updates carry revision numbers.
- Conflicting metadata changes create a conflict record; never silently overwrite.
- Deletes use tombstones and retention policy.
- All sync operations are idempotent.
