"""Encryption at rest for document blobs (envelope encryption, AES-256-GCM).

Each blob gets its own random 256-bit data key (DEK). The DEK is wrapped with the storage
master key (KEK). Only the `cryptography` library's AESGCM primitive is used; nothing here
implements a cipher.

Blob format (all integers fixed length, no parsing ambiguity):

    MAGIC        8  b"PAIENC1\\0"
    kek_id       8  first 8 bytes of SHA-256(KEK), selects the master key
    wrap_nonce  12
    wrapped_dek 48  AESGCM(KEK).encrypt(wrap_nonce, DEK, aad=b"dek|" + context)
    data_nonce  12
    ciphertext   *  AESGCM(DEK).encrypt(data_nonce, plaintext, aad=header + context)

`context` binds a ciphertext to its storage key, so blobs can't be swapped on disk without
detection. Nonces are random; with a fresh DEK per blob a nonce is never reused under a key.

Threat model (see docs/STORAGE_ENCRYPTION.md): this protects stolen disks, backups and
snapshots. It does NOT protect against someone who controls the running server, which holds
the master key in memory to render previews (and later OCR). End-to-end encryption is a
separate, later decision.
"""

from __future__ import annotations

import base64
import binascii
import hashlib
import os
from dataclasses import dataclass

from cryptography.exceptions import InvalidTag
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

MAGIC = b"PAIENC1\x00"
KEY_BYTES = 32
NONCE_BYTES = 12
WRAPPED_DEK_BYTES = KEY_BYTES + 16
HEADER_BYTES = len(MAGIC) + 8 + NONCE_BYTES + WRAPPED_DEK_BYTES + NONCE_BYTES


class DecryptionFailed(Exception):
    """Wrong key, tampered or truncated blob. Never includes key material."""


class InvalidMasterKey(ValueError):
    pass


def generate_master_key() -> str:
    """New master key, base64 encoded (for STORAGE_MASTER_KEY or a key file)."""
    return base64.urlsafe_b64encode(os.urandom(KEY_BYTES)).decode()


@dataclass(frozen=True, slots=True)
class MasterKey:
    key: bytes

    def __post_init__(self) -> None:
        if len(self.key) != KEY_BYTES:
            raise InvalidMasterKey("master key must be 32 bytes")

    @classmethod
    def from_b64(cls, value: str) -> MasterKey:
        value = value.strip()
        try:
            raw = base64.urlsafe_b64decode(value + "=" * (-len(value) % 4))
        except (binascii.Error, ValueError) as exc:
            raise InvalidMasterKey("master key is not valid base64") from exc
        return cls(raw)

    @property
    def key_id(self) -> bytes:
        return hashlib.sha256(self.key).digest()[:8]

    def __repr__(self) -> str:  # never print key material
        return f"MasterKey(id={self.key_id.hex()})"


class KeyRing:
    """The current master key plus older keys that can still decrypt (rotation)."""

    def __init__(self, current: MasterKey, old: list[MasterKey] | None = None) -> None:
        self.current = current
        self._by_id = {k.key_id: k for k in [*(old or []), current]}

    def get(self, key_id: bytes) -> MasterKey:
        try:
            return self._by_id[key_id]
        except KeyError:
            raise DecryptionFailed("blob was encrypted with an unknown master key") from None


def is_encrypted(data_or_head: bytes) -> bool:
    return data_or_head.startswith(MAGIC)


def encrypt(plaintext: bytes, keyring: KeyRing, context: bytes) -> bytes:
    kek = keyring.current
    dek = AESGCM.generate_key(bit_length=256)
    wrap_nonce = os.urandom(NONCE_BYTES)
    wrapped = AESGCM(kek.key).encrypt(wrap_nonce, dek, b"dek|" + context)
    data_nonce = os.urandom(NONCE_BYTES)
    header = MAGIC + kek.key_id + wrap_nonce + wrapped + data_nonce
    return header + AESGCM(dek).encrypt(data_nonce, plaintext, header + context)


def _split(blob: bytes) -> tuple[bytes, bytes, bytes, bytes, bytes, bytes]:
    if len(blob) < HEADER_BYTES + 16 or not blob.startswith(MAGIC):
        raise DecryptionFailed("not an encrypted blob or truncated")
    o = len(MAGIC)
    key_id = blob[o : o + 8]
    o += 8
    wrap_nonce = blob[o : o + NONCE_BYTES]
    o += NONCE_BYTES
    wrapped = blob[o : o + WRAPPED_DEK_BYTES]
    o += WRAPPED_DEK_BYTES
    data_nonce = blob[o : o + NONCE_BYTES]
    o += NONCE_BYTES
    return blob[:o], key_id, wrap_nonce, wrapped, data_nonce, blob[o:]


def decrypt(blob: bytes, keyring: KeyRing, context: bytes) -> bytes:
    header, key_id, wrap_nonce, wrapped, data_nonce, ciphertext = _split(blob)
    kek = keyring.get(key_id)
    try:
        dek = AESGCM(kek.key).decrypt(wrap_nonce, wrapped, b"dek|" + context)
        return AESGCM(dek).decrypt(data_nonce, ciphertext, header + context)
    except InvalidTag:
        raise DecryptionFailed("blob is corrupted, tampered with or bound to another key") from None


def reencrypt(blob: bytes, keyring: KeyRing, context: bytes) -> bytes:
    """Key rotation: decrypt with whichever key sealed the blob, encrypt again with a fresh
    data key under the current master key. Returns the blob unchanged if already current.
    (Re-sealing with a fresh DEK and nonce avoids any nonce reuse under an old DEK.)"""
    _, key_id, *_ = _split(blob)
    if key_id == keyring.current.key_id:
        return blob
    return encrypt(decrypt(blob, keyring, context), keyring, context)
