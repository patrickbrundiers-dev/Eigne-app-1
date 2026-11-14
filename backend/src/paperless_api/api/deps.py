"""Shared FastAPI dependencies."""

from __future__ import annotations

from typing import Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from paperless_api.auth.service import resolve_token
from paperless_api.config import Settings, get_settings
from paperless_api.db.models import DeviceSession, User
from paperless_api.db.session import get_session

_bearer = HTTPBearer(auto_error=False, description="Device session token (pai_...)")

DbSession = Annotated[Session, Depends(get_session)]
AppSettings = Annotated[Settings, Depends(get_settings)]


def current_device_session(
    db: DbSession,
    settings: AppSettings,
    credentials: Annotated[HTTPAuthorizationCredentials | None, Depends(_bearer)],
) -> DeviceSession:
    if credentials is None or credentials.scheme.lower() != "bearer":
        raise HTTPException(
            status.HTTP_401_UNAUTHORIZED,
            "authentication required",
            headers={"WWW-Authenticate": "Bearer"},
        )
    device = resolve_token(db, settings, credentials.credentials)
    if device is None:
        raise HTTPException(
            status.HTTP_401_UNAUTHORIZED,
            "invalid or expired token",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return device


CurrentSession = Annotated[DeviceSession, Depends(current_device_session)]


def current_user(device: CurrentSession) -> User:
    return device.user


CurrentUser = Annotated[User, Depends(current_user)]
