import json
import logging

import pytest

from paperless_api.logging_config import REDACTED, JsonFormatter, redact, redact_text


def _format(msg: str, *args: object, **extra: object) -> dict:
    record = logging.LogRecord("t", logging.INFO, __file__, 1, msg, args, None)
    for k, v in extra.items():
        setattr(record, k, v)
    return json.loads(JsonFormatter().format(record))


@pytest.mark.parametrize(
    ("text", "leak"),
    [
        ("Authorization: Bearer eyJhbGciOi.abc.def", "eyJhbGciOi"),
        ("login failed password=hunter2", "hunter2"),
        ("token: 'abc123'", "abc123"),
        ("api_key=sk-test-123", "sk-test-123"),
        ("postgresql+psycopg://paperless:s3cret@db:5432/x", "s3cret"),
    ],
)
def test_redact_text_removes_secrets(text: str, leak: str) -> None:
    out = redact_text(text)
    assert leak not in out
    assert REDACTED in out


def test_redact_keeps_harmless_text() -> None:
    assert redact_text("imported 3 documents in 12 ms") == "imported 3 documents in 12 ms"


def test_redact_nested_structures_by_key() -> None:
    data = {
        "user": "u1",
        "headers": {"Authorization": "Bearer x", "accept": "json"},
        "ocr_text": "IBAN DE89 3704 0044 0532 0130 00",
        "items": [{"password": "p"}, {"name": "ok"}],
    }
    out = redact(data)
    assert out["user"] == "u1"
    assert out["headers"]["Authorization"] == REDACTED
    assert out["headers"]["accept"] == "json"
    assert out["ocr_text"] == REDACTED
    assert out["items"] == [{"password": REDACTED}, {"name": "ok"}]


def test_json_formatter_redacts_message_and_extra_fields() -> None:
    payload = _format(
        "user %s logged in with password=%s", "u1", "hunter2", document_text="secret letter"
    )
    assert "hunter2" not in json.dumps(payload)
    assert payload["document_text"] == REDACTED
    assert payload["level"] == "INFO"
    assert payload["msg"].startswith("user u1 logged in")
