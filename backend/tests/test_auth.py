"""Authentication: passwords, device sessions, lockout, API endpoints, admin CLI."""

from datetime import timedelta

import pytest
from sqlalchemy import select

from paperless_api.auth import passwords
from paperless_api.auth.service import (
    EmailTaken,
    InvalidCredentials,
    create_user,
    hash_token,
    login,
    resolve_token,
    set_password,
)
from paperless_api.config import Settings
from paperless_api.db.base import utcnow
from paperless_api.db.models import DeviceSession, FamilyMember, FamilyRole, Space, User

PW = "correct horse battery"
SETTINGS = Settings(
    max_failed_logins=3, lockout_minutes=10, session_ttl_days=30, session_idle_days=7
)


@pytest.fixture
def user(db) -> User:
    u = create_user(db, email=" Anna@Example.TEST ", display_name="Anna", password=PW)
    db.commit()
    return u


# --- passwords -----------------------------------------------------------------------------


def test_password_hash_is_argon2id_and_verifies() -> None:
    h = passwords.hash_password(PW)
    assert h.startswith("$argon2id$")
    assert passwords.verify_password(h, PW)
    assert not passwords.verify_password(h, PW + "x")
    assert not passwords.verify_password(None, PW)
    assert not passwords.verify_password("not-a-hash", PW)


@pytest.mark.parametrize("bad", ["short", " leading space ok?", "x" * 1025, "            "])
def test_weak_passwords_rejected(bad: str) -> None:
    with pytest.raises(passwords.WeakPassword):
        passwords.hash_password(bad)


# --- service -------------------------------------------------------------------------------


def test_email_is_normalized_and_unique(db, user) -> None:
    assert user.email == "anna@example.test"
    with pytest.raises(EmailTaken):
        create_user(db, email="ANNA@example.test", display_name="x", password=PW)


def test_login_stores_only_token_hash(db, user) -> None:
    result = login(db, SETTINGS, email="anna@example.test", password=PW, device_name="Pixel")
    assert result.token.startswith("pai_") and len(result.token) > 40
    stored = db.scalar(select(DeviceSession.token_hash))
    assert stored == hash_token(result.token)
    assert result.token not in stored
    assert resolve_token(db, SETTINGS, result.token).user_id == user.id


@pytest.mark.parametrize(
    ("email", "password"),
    [("anna@example.test", "wrong password!"), ("nobody@example.test", PW), ("garbage", PW)],
)
def test_bad_credentials_give_one_generic_error(db, user, email, password) -> None:
    with pytest.raises(InvalidCredentials):
        login(db, SETTINGS, email=email, password=password, device_name="x")


def test_lockout_after_failures_even_with_right_password(db, user) -> None:
    now = utcnow()
    for _ in range(3):
        with pytest.raises(InvalidCredentials):
            login(
                db, SETTINGS, email=user.email, password="wrong password!", device_name="x", now=now
            )
    with pytest.raises(InvalidCredentials):
        login(db, SETTINGS, email=user.email, password=PW, device_name="x", now=now)
    later = now + timedelta(minutes=11)
    assert login(db, SETTINGS, email=user.email, password=PW, device_name="x", now=later)


def test_disabled_user_cannot_login_and_tokens_stop_working(db, user) -> None:
    token = login(db, SETTINGS, email=user.email, password=PW, device_name="x").token
    user.disabled_at = utcnow()
    db.commit()
    assert resolve_token(db, SETTINGS, token) is None
    with pytest.raises(InvalidCredentials):
        login(db, SETTINGS, email=user.email, password=PW, device_name="x")


def test_session_expiry_and_idle_timeout(db, user) -> None:
    now = utcnow()
    token = login(db, SETTINGS, email=user.email, password=PW, device_name="x", now=now).token
    assert resolve_token(db, SETTINGS, token, now=now + timedelta(days=6)) is not None
    # used on day 6 -> idle timer restarts; absolute limit still applies
    assert resolve_token(db, SETTINGS, token, now=now + timedelta(days=12)) is not None
    assert resolve_token(db, SETTINGS, token, now=now + timedelta(days=30)) is None
    token2 = login(db, SETTINGS, email=user.email, password=PW, device_name="y", now=now).token
    assert resolve_token(db, SETTINGS, token2, now=now + timedelta(days=8)) is None  # idle


def test_password_change_revokes_all_sessions(db, user) -> None:
    token = login(db, SETTINGS, email=user.email, password=PW, device_name="x").token
    set_password(db, user, "a brand new passphrase")
    db.commit()
    assert resolve_token(db, SETTINGS, token) is None


@pytest.mark.parametrize("token", ["", "pai_", "pai_unknown", "Bearer x", "pai_" + "a" * 200])
def test_unknown_tokens_rejected(db, user, token) -> None:
    assert resolve_token(db, SETTINGS, token) is None


# --- API -----------------------------------------------------------------------------------


def _login(client, email="anna@example.test", password=PW, device="Laptop"):
    return client.post(
        "/api/v1/auth/login", json={"email": email, "password": password, "device_name": device}
    )


def test_api_login_me_logout(client, db, user) -> None:
    r = _login(client)
    assert r.status_code == 200
    token = r.json()["access_token"]
    h = {"Authorization": f"Bearer {token}"}

    me = client.get("/api/v1/auth/me", headers=h)
    assert me.status_code == 200
    assert me.json()["email"] == "anna@example.test"
    assert "password_hash" not in me.text

    assert client.post("/api/v1/auth/logout", headers=h).status_code == 204
    assert client.get("/api/v1/auth/me", headers=h).status_code == 401


def test_api_wrong_password_is_401_without_detail(client, user) -> None:
    r = _login(client, password="wrong password!")
    assert r.status_code == 401
    assert r.json() == {"detail": "invalid credentials"}
    r = _login(client, email="nobody@example.test")
    assert r.json() == {"detail": "invalid credentials"}


def test_api_requires_bearer_token(client) -> None:
    r = client.get("/api/v1/auth/me")
    assert r.status_code == 401
    assert r.headers["www-authenticate"] == "Bearer"
    assert (
        client.get("/api/v1/auth/me", headers={"Authorization": "Bearer pai_x"}).status_code == 401
    )


def test_api_list_and_revoke_other_device(client, user) -> None:
    phone = _login(client, device="Handy").json()
    laptop = _login(client, device="Laptop").json()
    h = {"Authorization": f"Bearer {laptop['access_token']}"}
    sessions = client.get("/api/v1/auth/sessions", headers=h).json()
    assert {s["device_name"] for s in sessions} == {"Handy", "Laptop"}
    assert [s["current"] for s in sessions if s["device_name"] == "Laptop"] == [True]

    assert (
        client.delete(f"/api/v1/auth/sessions/{phone['session_id']}", headers=h).status_code == 204
    )
    phone_h = {"Authorization": f"Bearer {phone['access_token']}"}
    assert client.get("/api/v1/auth/me", headers=phone_h).status_code == 401


def test_api_cannot_revoke_someone_elses_session(client, db, user) -> None:
    create_user(db, email="bob@example.test", display_name="Bob", password=PW)
    db.commit()
    bob = _login(client, email="bob@example.test").json()
    anna = _login(client).json()
    r = client.delete(
        f"/api/v1/auth/sessions/{bob['session_id']}",
        headers={"Authorization": f"Bearer {anna['access_token']}"},
    )
    assert r.status_code == 404


def test_token_never_logged(client, user, caplog) -> None:
    import logging

    caplog.set_level(logging.INFO)
    token = _login(client).json()["access_token"]
    client.get("/api/v1/auth/me", headers={"Authorization": f"Bearer {token}"})
    assert token not in caplog.text
    assert PW not in caplog.text


# --- CLI -----------------------------------------------------------------------------------


def test_cli_bootstrap(db_engine, monkeypatch, capsys, tmp_path) -> None:
    import io

    from sqlalchemy.orm import Session

    from paperless_api import cli

    monkeypatch.setattr(cli, "make_engine", lambda: db_engine)

    def run(*argv: str, stdin: str = "") -> str:
        monkeypatch.setattr("sys.stdin", io.StringIO(stdin))
        cli.main(list(argv))
        return capsys.readouterr().out.strip()

    run(
        "create-user",
        "--email",
        "p@example.test",
        "--name",
        "P",
        "--password-stdin",
        stdin=PW + "\n",
    )
    run(
        "create-user",
        "--email",
        "k@example.test",
        "--name",
        "K",
        "--password-stdin",
        stdin=PW + "\n",
    )
    family_id = run("create-family", "--name", "Familie", "--admin", "p@example.test")
    run("add-member", "--family", family_id, "--email", "k@example.test", "--role", "child")
    space_id = run(
        "create-space",
        "--family",
        family_id,
        "--name",
        "Schule",
        "--type",
        "child_managed",
        "--owner",
        "p@example.test",
        "--child",
        "k@example.test",
    )
    run("grant", "--space", space_id, "--email", "k@example.test", "--role", "viewer")

    with Session(db_engine) as s:
        roles = {m.role for m in s.scalars(select(FamilyMember))}
        assert roles == {FamilyRole.ADMIN, FamilyRole.CHILD}
        assert s.scalar(select(Space.name)) == "Schule"

    with pytest.raises(SystemExit):
        run(
            "create-user",
            "--email",
            "x@example.test",
            "--name",
            "X",
            "--password-stdin",
            stdin="short\n",
        )
