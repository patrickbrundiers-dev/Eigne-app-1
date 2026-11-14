# Sync between devices (G1)

Phone and PC show the same state because both pull the same change feed from the server.
The server stays the single source of truth and keeps enforcing authorization; the apps hold
an offline copy of the document list and a queue of files that wait for upload.

Plan and later steps (Google login, Drive storage, Drive import):
[Plan: Google Drive Sync und Google-Login](https://claude.ai/artifact/6TqmbhFEn9fMLsyeozxKrC).

## Server: `GET /api/v1/sync`

| Parameter | Meaning |
| --- | --- |
| `cursor` | Opaque cursor of the previous answer. Omit for the first sync. |
| `limit` | Page size, 1 to 500, default 200. |

Answer: `cursor`, `has_more`, `server_time`, `spaces` (every readable space with its
permissions) and `documents` (changed documents, each with `revision` and `deleted`).

- Only documents of spaces the user may **read** are returned, checked with the same policy
  as every other endpoint. Unreadable spaces are not mentioned at all.
- The first sync (no cursor) returns live documents only; later syncs include tombstones
  (`deleted: true`) so devices remove deleted documents.
- Paging is keyset over `(updated_at, id)`; index `ix_documents_space_id_updated_at`
  (migration 0004).
- The cursor of the last page points two minutes back (`OVERLAP`). A transaction that
  committed late with an older timestamp is therefore not missed. Repeated rows are
  harmless: clients keep the higher `revision`.
- An invalid cursor answers 400; the client then starts a full sync.

## App

- **Offline cache** (`lib/src/sync/`): document list, spaces, user and cursor are stored as
  JSON in the app's private support directory. Changes of a sync are applied only after all
  pages arrived, so an interrupted sync leaves the cache unchanged.
- **Start without network:** with a cache the app opens signed in, shows the cached list and
  an offline banner, and retries in the background. Without a cache it shows the login hint
  and keeps the saved token.
- **Upload queue:** if the server is unreachable during an import, the file is copied into the
  app's private directory and uploaded with the next successful sync. Duplicates (409) are
  dropped silently; files the server rejects stay in the list with the German reason until
  the user discards them.
- **When it syncs:** after sign-in and app start, when the app returns to the foreground,
  every 5 minutes while it runs, after each import, and on pull-to-refresh.
- **Access changes:** documents of spaces that disappear from `spaces` are removed from the
  device; a newly shared space is fetched in full once.
- **Sign-out** deletes the cache, the queue and the queued files from the device. Another
  account or another server never sees the previous cache.

## Reaching the server from outside: Tailscale

Recommended setup (decided 2026-11-14): the server runs on the PC at home and phone and PC
are connected through [Tailscale](https://tailscale.com/). Nothing is opened to the internet.
Step-by-step guide in German: [TAILSCALE.de.md](TAILSCALE.de.md).
