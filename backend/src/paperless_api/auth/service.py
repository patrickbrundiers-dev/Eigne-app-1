"""Accounts and device sessions.

Tokens are opaque random strings (`pai_` + 43 url-safe chars, 256 bit). Only their SHA-256
is stored, so a database leak does not leak usable tokens. Each login creates one
DeviceSession, which can be listed and revoked individually ("log out this phone").
"""

from __future__ import annotations

import hashlib
import logging
import secrets
import uuid
from dataclasses import dataclass
from datetime import datetime, timedelta

from sqlalchemy import select
from sqlalchemy.orm import Session

from paperless_api.auth.passwords import hash_password, needs_rehash, verify_password
from paperless_api.config import Settings
from paperless_api.db.base import utcnow
from paperless_api.db.models import DeviceSession, User

logger = logging.getLogger("paperless_api.auth")

TOKEN_PREFIX = "pai_"
# Write last_used_at at most this often, to avoid a DB write on every request.
TOUCH_INTERVAL = timedelta(minutes=5)


class InvalidCredentials(Exception):
    """Wrong e-mail, wrong password, locked or disabled account. Deliberately one error,
    so clients can't tell which one it was."""


class EmailTaken(ValueError):
    pass


def normalize_email(email: str) -> str:
    email = email.strip().lower()
    if "@" not in email or len(email) > 320 or email.startswith("@") or email.endswith("@"):
        raise ValueError("invalid e-mail address")
    return email


def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()


def new_token() -> str:
    return TOKEN_PREFIX + secrets.token_urlsafe(32)


def create_user(session: Session, *, email: str, display_name: str, password: str) -> User:
    email = normalize_email(email)
    if session.scalar(select(User.id).where(User.email == email)) is not None:
        raise EmailTaken("e-mail address is already registered")
    user = User(
        email=email,
        display_name=display_name.strip()[:120] or email,
        password_hash=hash_password(password),
    )
    session.add(user)
    session.flush()
    return user


def set_password(session: Session, user: User, password: str) -> None:
    user.password_hash = hash_password(password)
    user.failed_logins = 0
    user.locked_until = None
    # Changing the password ends every existing session.
    now = utcnow()
    for s in user.sessions:
        if s.revoked_at is None:
            s.revoked_at = now


@dataclass(frozen=True, slots=True)
class LoginResult:
    token: str
    session: DeviceSession


def login(
    session: Session,
    settings: Settings,
    *,
    email: str,
    password: str,
    device_name: str,
    now: datetime | None = None,
) -> LoginResult:
    now = now or utcnow()
    try:
        email = normalize_email(email)
    except ValueError:
        verify_password(None, password)
        raise InvalidCredentials() from None
    user = session.scalar(select(User).where(User.email == email))

    if user is None:
        verify_password(None, password)  # same work as a real check
        raise InvalidCredentials()

    locked = user.locked_until is not None and user.locked_until > now
    ok = verify_password(user.password_hash, password)
    if locked or user.disabled_at is not None or not ok:
        if not ok and not locked:
            user.failed_logins += 1
            if user.failed_logins >= settings.max_failed_logins:
                user.locked_until = now + timedelta(minutes=settings.lockout_minutes)
                user.failed_logins = 0
                logger.warning("account locked", extra={"user_id": str(user.id)})
        session.commit()
        raise InvalidCredentials()

    user.failed_logins = 0
    user.locked_until = None
    if needs_rehash(user.password_hash):
        user.password_hash = hash_password(password)

    token = new_token()
    device = DeviceSession(
        user_id=user.id,
        token_hash=hash_token(token),
        device_name=(device_name.strip() or "Unbekanntes Gerät")[:120],
        created_at=now,
        last_used_at=now,
        expires_at=now + timedelta(days=settings.session_ttl_days),
    )
    session.add(device)
    session.commit()
    logger.info("login", extra={"user_id": str(user.id), "session_id": str(device.id)})
    return LoginResult(token=token, session=device)


def resolve_token(
    session: Session, settings: Settings, token: str, *, now: datetime | None = None
) -> DeviceSession | None:
    """Return the active session for a bearer token, or None."""
    if not token.startswith(TOKEN_PREFIX) or len(token) > 100:
        return None
    now = now or utcnow()
    device = session.scalar(
        select(DeviceSession).where(DeviceSession.token_hash == hash_token(token))
    )
    if device is None or device.revoked_at is not None or device.expires_at <= now:
        return None
    if device.last_used_at + timedelta(days=settings.session_idle_days) <= now:
        return None
    if device.user.disabled_at is not None:
        return None
    if now - device.last_used_at >= TOUCH_INTERVAL:
        device.last_used_at = now
        session.commit()
    return device


def revoke_session(session: Session, user_id: uuid.UUID, session_id: uuid.UUID) -> bool:
    device = session.get(DeviceSession, session_id)
    if device is None or device.user_id != user_id:
        return False
    if device.revoked_at is None:
        device.revoked_at = utcnow()
        session.commit()
    return True
