# Authentication

Status: implemented (`backend/src/paperless_api/auth/`, `api/v1/auth.py`, `cli.py`).

## Model
- **Accounts** are created by the server operator with `paperless-admin`. There is no open
  self-registration (a family server should not accept strangers).
- **Passwords**: argon2id (argon2-cffi defaults), 12–1024 characters, no leading/trailing
  whitespace. Hashes are upgraded automatically on login when parameters change.
- **Device sessions**: every login creates one session for one device. The client gets an
  opaque bearer token (`pai_` + 256 random bits). The server stores only its SHA-256.
  Sessions end after 30 days, or after 14 days without use, and can be revoked one by one.
- **Lockout**: 5 wrong passwords lock the account for 15 minutes. All failures (unknown e-mail,
  wrong password, locked, disabled) return the same `401 invalid credentials`, and unknown
  e-mails cost the same hashing time as known ones.
- Changing a password ends all sessions of that user.
- Tokens, passwords and hashes never appear in logs (tested).

Settings: `SESSION_TTL_DAYS`, `SESSION_IDLE_DAYS`, `MAX_FAILED_LOGINS`, `LOCKOUT_MINUTES`.

## API
| Method | Path | |
|---|---|---|
| POST | `/api/v1/auth/login` | `{email, password, device_name}` → `{access_token, session_id, expires_at}` |
| POST | `/api/v1/auth/logout` | ends the current session |
| GET | `/api/v1/auth/me` | user and family memberships |
| GET | `/api/v1/auth/sessions` | own active sessions (devices) |
| DELETE | `/api/v1/auth/sessions/{id}` | log out another device |

Send the token as `Authorization: Bearer pai_...`.

## Bootstrapping a family
```bash
cd backend
alembic upgrade head
paperless-admin create-user --email anna@example.org --name Anna      # asks for the password
paperless-admin create-user --email ben@example.org --name Ben
paperless-admin create-family --name "Familie Muster" --admin anna@example.org   # prints family id
paperless-admin add-member --family <family-id> --email ben@example.org --role adult
paperless-admin create-space --family <family-id> --name Haushalt --type shared --owner anna@example.org
paperless-admin grant --space <space-id> --email ben@example.org --role editor
```
Use `--password-stdin` for scripts. Passwords are never accepted as command-line arguments.

## Known limits / next steps
- The lockout can be triggered by someone who knows an e-mail address (denial of service
  against that account). Acceptable for a family server; add IP-based rate limiting in front
  (reverse proxy) when exposed to the internet.
- No TOTP / passkeys yet. No password reset by e-mail (operator uses `set-password`).
- Always run behind TLS (`docs/SECURITY.md`); the API itself does not terminate TLS.
