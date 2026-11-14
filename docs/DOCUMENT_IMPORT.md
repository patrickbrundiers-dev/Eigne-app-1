# Document import (T5)

Status: implemented (`backend/src/paperless_api/documents/`, HTTP API in `api/v1/documents.py`).

## HTTP API (bearer token required, see AUTHENTICATION.md)

| Method | Path | Permission | |
|---|---|---|---|
| GET | `/api/v1/spaces` | read | spaces the user can see, with own permissions |
| GET | `/api/v1/spaces/{id}/documents` | read | non-deleted documents, newest first |
| POST | `/api/v1/spaces/{id}/documents` | write | multipart `file`, optional `title` → 201 |
| GET | `/api/v1/documents/{id}` | read | metadata of latest version |
| GET | `/api/v1/documents/{id}/preview` | read | PNG of page 1, cached per immutable version |
| GET | `/api/v1/documents/{id}/file` | read | original, always `attachment`, `CSP: sandbox` |
| DELETE | `/api/v1/documents/{id}` | delete_document | tombstone; same file can be imported again |

Status codes: 404 when the space/document is not readable (existence is hidden), 403 when
readable but the action is not allowed, 409 duplicate (with `existing_document_id`),
413 too large, 422 rejected file (`detail.code`), 503 storage not configured.
Requests with a `Content-Length` above the limit are refused before the body is read; also set
a body limit in the reverse proxy (e.g. nginx `client_max_body_size 51m`).

## Pipeline

```
upload stream
  -> staging      streamed to data/staging/<random>.part (0600), SHA-256 + size computed,
                  size limit enforced while streaming
  -> detection    type from magic bytes only (allowlist: PDF, PNG, JPEG, TIFF, WebP)
  -> inspection   PDF: parse with pypdf, page limit, reject encrypted, scan object graph
                  for executable actions; image: header-only size check + verify()
  -> authz        actor needs WRITE on the space (docs/AUTHORIZATION.md)
  -> duplicates   same SHA-256 in the same space (non-deleted) -> rejected with id of existing
  -> blob store   hard-link into data/blobs/<k[:2]>/<key>, read-only, opaque random key
  -> metadata     Document + FileVersion v1 in one transaction; blob discarded on failure
```

Authorization is checked first, before any bytes are read.

## Limits and settings (`backend/.env`)

| Setting | Default | Meaning |
|---|---|---|
| `MAX_UPLOAD_BYTES` | 52428800 (50 MiB) | Hard limit, enforced while streaming |
| `MAX_PDF_PAGES` | 500 | Also caps frames of multi-page TIFFs |
| `MAX_IMAGE_PIXELS` | 80000000 | About A4 at 1200 dpi; stops decompression bombs |
| `REJECT_PDF_ACTIVE_CONTENT` | true | Reject PDFs with JavaScript, Launch, SubmitForm, ImportData |
| `STORAGE_DIR` | `./data` | Staging and blobs |
| `ALLOW_UNENCRYPTED_STORAGE` | false | Must be `true` to use the plaintext local store; ignored in production |

## Rejection codes
`unsupported_type`, `too_large`, `empty_file`, `too_many_pages`, `encrypted_pdf`,
`active_content`, `malformed`, `image_too_large`, `duplicate`. Messages never contain content.

## Decisions
- **Embedded files are allowed** (recorded as finding). German e-invoices (ZUGFeRD / Factur-X,
  XRechnung in PDF) carry their XML as attachment; Phase 3 can extract it.
- **Leading bytes before `%PDF-` are rejected**, although readers tolerate them (polyglot trick).
- **Duplicates only within a space.** A cross-space check would tell a user that someone
  else owns the same file.
- **Originals are immutable**: write-once keys, read-only files, `file_versions` insert-only.
  A changed file becomes a new version (API for that follows with the endpoint).
- **Filenames are metadata only**: path parts and control characters stripped, max 255 chars,
  never used to build a path.

## Safe preview
`render_preview(path, mime)` renders page 1 (PDF via pdfium/pypdfium2, images via Pillow) to
a PNG of at most 1024 px. Rendering runs in a **separate Python process** (`-I`, empty
environment) with a 20 s timeout and, on Linux/macOS, 15 s CPU and 1 GiB memory limits. A crash
or hang in the renderer cannot affect the API. Output is freshly encoded, so EXIF data such as
GPS positions is dropped. pdfium is used without form/JavaScript support.

## Not done yet (next steps)
- Encrypted blob store (after the key design in SECURITY.md is approved).
- Staging cleanup job for files left behind by a crashed process.
- Malware scanning hook (e.g. ClamAV) if files are shared with other devices.
- Flutter: pick file, local import, preview with pdfium on the device.
