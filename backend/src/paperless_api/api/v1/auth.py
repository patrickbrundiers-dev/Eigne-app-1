from __future__ import annotations

import uuid
from datetime import datetime

from fastapi import APIRouter, HTTPException, Response, status
from pydantic import BaseModel, Field
from sqlalchemy import select

from paperless_api.api.deps import AppSettings, CurrentSession, CurrentUser, DbSession
from paperless_api.auth.service import InvalidCredentials, login, revoke_session
from paperless_api.db.models import DeviceSession, Family, FamilyMember

router = APIRouter(prefix="/auth", tags=["auth"])


class LoginRequest(BaseModel):
    email: str = Field(max_length=320)
    password: str = Field(max_length=1024)
    device_name: str = Field(default="", max_length=120)


class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    session_id: uuid.UUID
    expires_at: datetime


class FamilyOut(BaseModel):
    id: uuid.UUID
    name: str
    role: str


class MeResponse(BaseModel):
    id: uuid.UUID
    email: str
    display_name: str
    families: list[FamilyOut]


class SessionOut(BaseModel):
    id: uuid.UUID
    device_name: str
    created_at: datetime
    last_used_at: datetime
    expires_at: datetime
    current: bool


@router.post("/login", response_model=LoginResponse)
def post_login(body: LoginRequest, db: DbSession, settings: AppSettings) -> LoginResponse:
    try:
        result = login(
            db, settings, email=body.email, password=body.password, device_name=body.device_name
        )
    except InvalidCredentials:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "invalid credentials") from None
    return LoginResponse(
        access_token=result.token,
        session_id=result.session.id,
        expires_at=result.session.expires_at,
    )


@router.post("/logout", status_code=status.HTTP_204_NO_CONTENT)
def post_logout(device: CurrentSession, db: DbSession) -> Response:
    revoke_session(db, device.user_id, device.id)
    return Response(status_code=status.HTTP_204_NO_CONTENT)


@router.get("/me", response_model=MeResponse)
def get_me(user: CurrentUser, db: DbSession) -> MeResponse:
    rows = db.execute(
        select(Family.id, Family.name, FamilyMember.role)
        .join(FamilyMember, FamilyMember.family_id == Family.id)
        .where(FamilyMember.user_id == user.id)
        .order_by(Family.name)
    ).all()
    return MeResponse(
        id=user.id,
        email=user.email,
        display_name=user.display_name,
        families=[FamilyOut(id=r.id, name=r.name, role=r.role.value) for r in rows],
    )


@router.get("/sessions", response_model=list[SessionOut])
def list_sessions(device: CurrentSession, db: DbSession) -> list[SessionOut]:
    sessions = db.scalars(
        select(DeviceSession)
        .where(DeviceSession.user_id == device.user_id, DeviceSession.revoked_at.is_(None))
        .order_by(DeviceSession.last_used_at.desc())
    ).all()
    return [
        SessionOut(
            id=s.id,
            device_name=s.device_name,
            created_at=s.created_at,
            last_used_at=s.last_used_at,
            expires_at=s.expires_at,
            current=s.id == device.id,
        )
        for s in sessions
    ]


@router.delete("/sessions/{session_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_session(session_id: uuid.UUID, device: CurrentSession, db: DbSession) -> Response:
    if not revoke_session(db, device.user_id, session_id):
        raise HTTPException(status.HTTP_404_NOT_FOUND, "session not found")
    return Response(status_code=status.HTTP_204_NO_CONTENT)
