"""Encryption at rest: format, tamper detection, key rotation, plaintext migration."""

import base64
from pathlib import Path

import pytest

from paperless_api.config import Settings
from paperless_api.documents import crypto
from paperless_api.documents.blobstore import EncryptedBlobStore, LocalBlobStore
from paperless_api.documents.maintenance import encrypt_and_rotate
from paperless_api.documents.storage_config import (
    StorageNotConfigured,
    build_blob_store,
    load_keyring,
)


def _ring(*old: crypto.MasterKey) -> crypto.KeyRing:
    return crypto.KeyRing(crypto.MasterKey.from_b64(crypto.generate_master_key()), list(old))


def test_roundtrip_and_fresh_randomness() -> None:
    ring = _ring()
    a = crypto.encrypt(b"secret letter", ring, b"ctx")
    b = crypto.encrypt(b"secret letter", ring, b"ctx")
    assert a != b  # new data key and nonce every time
    assert b"secret" not in a
    assert crypto.decrypt(a, ring, b"ctx") == b"secret letter"


def test_context_binding_detects_swapped_blobs() -> None:
    ring = _ring()
    blob = crypto.encrypt(b"x", ring, b"blob|aaaa")
    with pytest.raises(crypto.DecryptionFailed):
        crypto.decrypt(blob, ring, b"blob|bbbb")


@pytest.mark.parametrize("position", [0, 10, 30, 80, -1])
def test_any_flipped_byte_is_detected(position: int) -> None:
    ring = _ring()
    blob = bytearray(crypto.encrypt(b"some document bytes", ring, b"ctx"))
    blob[position] ^= 0x01
    with pytest.raises(crypto.DecryptionFailed):
        crypto.decrypt(bytes(blob), ring, b"ctx")


def test_truncated_and_wrong_key() -> None:
    ring = _ring()
    blob = crypto.encrypt(b"abc", ring, b"ctx")
    with pytest.raises(crypto.DecryptionFailed):
        crypto.decrypt(blob[:40], ring, b"ctx")
    with pytest.raises(crypto.DecryptionFailed):
        crypto.decrypt(blob, _ring(), b"ctx")


def test_master_key_validation_and_repr() -> None:
    key = crypto.MasterKey.from_b64(crypto.generate_master_key())
    assert key.key.hex() not in repr(key)
    with pytest.raises(crypto.InvalidMasterKey):
        crypto.MasterKey.from_b64(base64.b64encode(b"short").decode())
    with pytest.raises(crypto.InvalidMasterKey):
        crypto.MasterKey.from_b64("not base64 !!!")


def test_reencrypt_moves_to_current_key() -> None:
    old = crypto.MasterKey.from_b64(crypto.generate_master_key())
    blob = crypto.encrypt(b"doc", crypto.KeyRing(old), b"ctx")
    ring = _ring(old)
    new_blob = crypto.reencrypt(blob, ring, b"ctx")
    assert new_blob[8:16] == ring.current.key_id
    assert crypto.decrypt(new_blob, crypto.KeyRing(ring.current), b"ctx") == b"doc"
    assert crypto.reencrypt(new_blob, ring, b"ctx") is new_blob


def test_build_blob_store_from_settings(tmp_path: Path) -> None:
    key = crypto.generate_master_key()
    keyfile = tmp_path / "key"
    keyfile.write_text(key + "\n")
    s = Settings(storage_dir=str(tmp_path / "a"), storage_master_key_file=str(keyfile))
    assert isinstance(build_blob_store(s), EncryptedBlobStore)
    assert load_keyring(s).current == crypto.MasterKey.from_b64(key)
    dev = Settings(storage_dir=str(tmp_path / "b"), allow_unencrypted_storage=True, app_env="test")
    assert isinstance(build_blob_store(dev), LocalBlobStore)
    with pytest.raises(StorageNotConfigured):
        build_blob_store(
            Settings(
                storage_dir=str(tmp_path / "c"),
                app_env="production",
                allow_unencrypted_storage=True,
            )
        )


def test_plaintext_store_refuses_encrypted_blob(tmp_path: Path) -> None:
    ring = _ring()
    enc = EncryptedBlobStore(tmp_path, ring)
    staged = tmp_path / "s"
    staged.write_bytes(b"data")
    key = enc.put(staged)
    plain = LocalBlobStore(tmp_path, allow_unencrypted=True, app_env="test")
    with pytest.raises(crypto.DecryptionFailed):
        plain.read(key)


def test_encrypt_existing_plaintext_then_rotate(tmp_path: Path) -> None:
    plain = LocalBlobStore(tmp_path, allow_unencrypted=True, app_env="test")
    keys = []
    for i in range(3):
        staged = tmp_path / f"s{i}"
        staged.write_bytes(f"document {i}".encode())
        keys.append(plain.put(staged))
    plain.put_derived("preview-x.png", b"\x89PNG fake")

    first = crypto.MasterKey.from_b64(crypto.generate_master_key())
    store1 = EncryptedBlobStore(tmp_path, crypto.KeyRing(first))
    report = encrypt_and_rotate(store1)
    assert report == {"encrypted": 4, "rotated": 0, "unchanged": 0}
    assert [store1.read(k) for k in keys] == [b"document 0", b"document 1", b"document 2"]
    assert encrypt_and_rotate(store1) == {"encrypted": 0, "rotated": 0, "unchanged": 4}

    second = crypto.MasterKey.from_b64(crypto.generate_master_key())
    store2 = EncryptedBlobStore(tmp_path, crypto.KeyRing(second, [first]))
    assert encrypt_and_rotate(store2)["rotated"] == 4
    only_new = EncryptedBlobStore(tmp_path, crypto.KeyRing(second))
    assert only_new.read(keys[0]) == b"document 0"
    assert only_new.get_derived("preview-x.png") == b"\x89PNG fake"
