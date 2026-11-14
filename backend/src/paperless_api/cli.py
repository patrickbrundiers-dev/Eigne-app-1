"""Admin command line: `paperless-admin`.

There is no open self-registration. The first accounts, families and spaces are created
here by whoever runs the server. Passwords are read interactively (never as arguments, which
would end up in shell history and process lists) or from stdin with --password-stdin.
"""

from __future__ import annotations

import argparse
import getpass
import sys
import uuid

from sqlalchemy import select
from sqlalchemy.orm import Session

from paperless_api.auth.passwords import WeakPassword
from paperless_api.auth.service import EmailTaken, create_user, normalize_email, set_password
from paperless_api.config import get_settings
from paperless_api.db.models import (
    Family,
    FamilyMember,
    FamilyRole,
    Space,
    SpaceMembership,
    SpaceRole,
    SpaceType,
    User,
)
from paperless_api.db.session import make_engine
from paperless_api.documents.blobstore import EncryptedBlobStore
from paperless_api.documents.crypto import generate_master_key
from paperless_api.documents.maintenance import encrypt_and_rotate
from paperless_api.documents.storage_config import build_blob_store


def _read_password(args: argparse.Namespace) -> str:
    if args.password_stdin:
        return sys.stdin.readline().rstrip("\n")
    first = getpass.getpass("Passwort: ")
    if first != getpass.getpass("Passwort wiederholen: "):
        raise SystemExit("Die Passwörter stimmen nicht überein.")
    return first


def _user(db: Session, email: str) -> User:
    user = db.scalar(select(User).where(User.email == normalize_email(email)))
    if user is None:
        raise SystemExit(f"Kein Benutzer mit dieser E-Mail: {email}")
    return user


def cmd_create_user(db: Session, args: argparse.Namespace) -> None:
    try:
        user = create_user(
            db, email=args.email, display_name=args.name, password=_read_password(args)
        )
    except (EmailTaken, WeakPassword, ValueError) as exc:
        raise SystemExit(str(exc)) from None
    db.commit()
    print(user.id)


def cmd_set_password(db: Session, args: argparse.Namespace) -> None:
    user = _user(db, args.email)
    try:
        set_password(db, user, _read_password(args))
    except WeakPassword as exc:
        raise SystemExit(str(exc)) from None
    db.commit()
    print("Passwort geändert, alle Sitzungen beendet.")


def cmd_create_family(db: Session, args: argparse.Namespace) -> None:
    admin = _user(db, args.admin)
    family = Family(name=args.name)
    db.add(family)
    db.flush()
    db.add(FamilyMember(family_id=family.id, user_id=admin.id, role=FamilyRole.ADMIN))
    db.commit()
    print(family.id)


def cmd_add_member(db: Session, args: argparse.Namespace) -> None:
    user = _user(db, args.email)
    db.add(
        FamilyMember(family_id=uuid.UUID(args.family), user_id=user.id, role=FamilyRole(args.role))
    )
    db.commit()
    print("ok")


def cmd_create_space(db: Session, args: argparse.Namespace) -> None:
    owner = _user(db, args.owner)
    space_type = SpaceType(args.type)
    child = _user(db, args.child).id if args.child else None
    if space_type is SpaceType.CHILD_MANAGED and child is None:
        raise SystemExit("--child ist für Kinderbereiche erforderlich.")
    space = Space(
        family_id=uuid.UUID(args.family), name=args.name, type=space_type, child_user_id=child
    )
    db.add(space)
    db.flush()
    db.add(SpaceMembership(space_id=space.id, user_id=owner.id, role=SpaceRole.OWNER))
    db.commit()
    print(space.id)


def cmd_grant(db: Session, args: argparse.Namespace) -> None:
    user = _user(db, args.email)
    db.add(
        SpaceMembership(space_id=uuid.UUID(args.space), user_id=user.id, role=SpaceRole(args.role))
    )
    db.commit()
    print("ok")


def cmd_generate_key(_db: Session | None, _args: argparse.Namespace) -> None:
    print(generate_master_key())


def cmd_encrypt_storage(_db: Session | None, _args: argparse.Namespace) -> None:
    settings = get_settings()
    store = build_blob_store(settings)
    if not isinstance(store, EncryptedBlobStore):
        raise SystemExit("STORAGE_MASTER_KEY oder STORAGE_MASTER_KEY_FILE ist nicht gesetzt.")
    report = encrypt_and_rotate(store)
    print(
        f"verschlüsselt: {report['encrypted']}, neu verschlüsselt: {report['rotated']}, "
        f"unverändert: {report['unchanged']}"
    )


def build_parser() -> argparse.ArgumentParser:
    p = argparse.ArgumentParser(prog="paperless-admin", description="Paperless AI Verwaltung")
    sub = p.add_subparsers(dest="command", required=True)

    c = sub.add_parser("create-user", help="Benutzer anlegen")
    c.add_argument("--email", required=True)
    c.add_argument("--name", required=True)
    c.add_argument("--password-stdin", action="store_true")
    c.set_defaults(func=cmd_create_user)

    c = sub.add_parser("set-password", help="Passwort setzen (beendet alle Sitzungen)")
    c.add_argument("--email", required=True)
    c.add_argument("--password-stdin", action="store_true")
    c.set_defaults(func=cmd_set_password)

    c = sub.add_parser("create-family", help="Familie anlegen, Benutzer wird Admin")
    c.add_argument("--name", required=True)
    c.add_argument("--admin", required=True, help="E-Mail des Admins")
    c.set_defaults(func=cmd_create_family)

    c = sub.add_parser("add-member", help="Benutzer zur Familie hinzufügen")
    c.add_argument("--family", required=True)
    c.add_argument("--email", required=True)
    c.add_argument("--role", choices=[r.value for r in FamilyRole], required=True)
    c.set_defaults(func=cmd_add_member)

    c = sub.add_parser("create-space", help="Bereich anlegen")
    c.add_argument("--family", required=True)
    c.add_argument("--name", required=True)
    c.add_argument("--type", choices=[t.value for t in SpaceType], required=True)
    c.add_argument("--owner", required=True, help="E-Mail des Besitzers")
    c.add_argument("--child", help="E-Mail des Kindes (nur child_managed)")
    c.set_defaults(func=cmd_create_space)

    c = sub.add_parser("grant", help="Bereich für Benutzer freigeben")
    c.add_argument("--space", required=True)
    c.add_argument("--email", required=True)
    c.add_argument("--role", choices=[r.value for r in SpaceRole], required=True)
    c.set_defaults(func=cmd_grant)

    c = sub.add_parser("generate-key", help="Neuen Hauptschlüssel für die Ablage erzeugen")
    c.set_defaults(func=cmd_generate_key, needs_db=False)

    c = sub.add_parser(
        "encrypt-storage",
        help="Unverschlüsselte Dateien verschlüsseln und auf den aktuellen Schlüssel umstellen",
    )
    c.set_defaults(func=cmd_encrypt_storage, needs_db=False)
    return p


def main(argv: list[str] | None = None) -> None:
    args = build_parser().parse_args(argv)
    if not getattr(args, "needs_db", True):
        args.func(None, args)
        return
    engine = make_engine()
    with Session(engine) as db:
        args.func(db, args)


if __name__ == "__main__":
    main()
