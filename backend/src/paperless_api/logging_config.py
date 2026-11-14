"""Structured JSON logging with redaction of sensitive data.

Rule from docs/SECURITY.md: logs must never contain document text, tokens, passwords or keys.
Redaction is a safety net, not a licence to log sensitive objects: call sites should still
avoid passing document content or credentials to the logger at all.
"""

from __future__ import annotations

import json
import logging
import re
import sys
from datetime import UTC, datetime
from typing import Any

REDACTED = "[REDACTED]"

# Field names (case-insensitive, substring match) whose values are always redacted.
SENSITIVE_KEY_PARTS: tuple[str, ...] = (
    "password",
    "passwd",
    "secret",
    "token",
    "authorization",
    "cookie",
    "api_key",
    "apikey",
    "private_key",
    "encryption_key",
    "content",
    "ocr_text",
    "document_text",
    "body",
)

_PATTERNS: tuple[re.Pattern[str], ...] = (
    # Authorization headers / bearer tokens
    re.compile(r"(?i)\b(bearer|basic)\s+[A-Za-z0-9._~+/=-]+"),
    # key=value or key: value for sensitive keys inside free text
    re.compile(
        r"(?i)\b(password|passwd|secret|token|api[_-]?key)\b(\s*[=:]\s*)(\"[^\"]*\"|'[^']*'|\S+)"
    ),
    # Credentials embedded in URLs, e.g. postgresql://user:pass@host
    re.compile(r"(?i)([a-z][a-z0-9+.-]*://[^:/\s@]+:)([^@\s]+)(@)"),
)

# Attributes every LogRecord has; anything else was passed via `extra=`.
_STANDARD_ATTRS = set(logging.makeLogRecord({}).__dict__) | {"message", "asctime", "taskName"}


def is_sensitive_key(key: str) -> bool:
    lowered = key.lower()
    return any(part in lowered for part in SENSITIVE_KEY_PARTS)


def redact_text(text: str) -> str:
    text = _PATTERNS[0].sub(lambda m: f"{m.group(1)} {REDACTED}", text)
    text = _PATTERNS[1].sub(lambda m: f"{m.group(1)}{m.group(2)}{REDACTED}", text)
    text = _PATTERNS[2].sub(lambda m: f"{m.group(1)}{REDACTED}{m.group(3)}", text)
    return text


def redact(value: Any, key: str | None = None) -> Any:
    """Recursively redact a value. `key` is the field name the value is stored under."""
    if key is not None and is_sensitive_key(key):
        return REDACTED
    if isinstance(value, dict):
        return {k: redact(v, str(k)) for k, v in value.items()}
    if isinstance(value, (list, tuple, set)):
        return [redact(v) for v in value]
    if isinstance(value, str):
        return redact_text(value)
    return value


class JsonFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        payload: dict[str, Any] = {
            "ts": datetime.fromtimestamp(record.created, tz=UTC).isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "msg": redact_text(record.getMessage()),
        }
        for attr, val in record.__dict__.items():
            if attr not in _STANDARD_ATTRS and not attr.startswith("_"):
                payload[attr] = redact(val, attr)
        if record.exc_info:
            payload["exc"] = redact_text(self.formatException(record.exc_info))
        return json.dumps(payload, default=str, ensure_ascii=False)


class RedactingTextFormatter(logging.Formatter):
    def format(self, record: logging.LogRecord) -> str:
        return redact_text(super().format(record))


def configure_logging(level: str = "INFO", json_output: bool = True) -> None:
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(
        JsonFormatter()
        if json_output
        else RedactingTextFormatter("%(asctime)s %(levelname)s %(name)s: %(message)s")
    )
    root = logging.getLogger()
    root.handlers[:] = [handler]
    root.setLevel(level.upper())
    # Uvicorn installs its own handlers; route them through ours instead.
    for name in ("uvicorn", "uvicorn.error", "uvicorn.access"):
        logger = logging.getLogger(name)
        logger.handlers[:] = []
        logger.propagate = True
