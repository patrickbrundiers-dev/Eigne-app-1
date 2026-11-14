"""Password hashing with argon2id (argon2-cffi, OWASP-recommended parameters by default)."""

from __future__ import annotations

from argon2 import PasswordHasher
from argon2.exceptions import InvalidHashError, VerificationError, VerifyMismatchError

MIN_LENGTH = 12
# Upper bound so a multi-megabyte "password" can't be used to burn CPU.
MAX_LENGTH = 1024

_hasher = PasswordHasher()

# Verified against when the account doesn't exist, so the response time doesn't reveal
# whether an e-mail address is registered.
_DUMMY_HASH = _hasher.hash("dummy-password-for-timing-only")


class WeakPassword(ValueError):
    pass


def validate_password(password: str) -> None:
    if len(password) < MIN_LENGTH:
        raise WeakPassword(f"password must be at least {MIN_LENGTH} characters")
    if len(password) > MAX_LENGTH:
        raise WeakPassword(f"password must be at most {MAX_LENGTH} characters")
    if password.strip() != password or not password.strip():
        raise WeakPassword("password must not start or end with whitespace")


def hash_password(password: str) -> str:
    validate_password(password)
    return _hasher.hash(password)


def verify_password(password_hash: str | None, password: str) -> bool:
    if len(password) > MAX_LENGTH:
        return False
    try:
        return _hasher.verify(password_hash or _DUMMY_HASH, password) and password_hash is not None
    except (VerifyMismatchError, VerificationError, InvalidHashError):
        return False


def needs_rehash(password_hash: str) -> bool:
    return _hasher.check_needs_rehash(password_hash)
