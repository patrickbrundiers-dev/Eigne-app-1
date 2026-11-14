"""Safe preview generation.

Untrusted files are rendered in a child process with a wall-clock timeout and, on POSIX,
CPU and memory limits. A crash or hang in the renderer can't take the API down, and the
output is a freshly encoded PNG, never the original bytes.
"""

from __future__ import annotations

import os
import subprocess
import sys
import tempfile
from pathlib import Path

from paperless_api.documents.errors import PreviewFailed

DEFAULT_MAX_PX = 1024
TIMEOUT_S = 20
CPU_SECONDS = 15
MEMORY_BYTES = 1024 * 1024 * 1024  # 1 GiB address space

PREVIEWABLE = frozenset({"application/pdf", "image/png", "image/jpeg", "image/tiff", "image/webp"})


def _limit_resources() -> None:  # pragma: no cover - runs in the child process
    import resource

    resource.setrlimit(resource.RLIMIT_CPU, (CPU_SECONDS, CPU_SECONDS))
    resource.setrlimit(resource.RLIMIT_AS, (MEMORY_BYTES, MEMORY_BYTES))
    resource.setrlimit(resource.RLIMIT_CORE, (0, 0))


def render_preview(source: Path, mime_type: str, max_px: int = DEFAULT_MAX_PX) -> bytes:
    if mime_type not in PREVIEWABLE:
        raise PreviewFailed("no preview for this file type")
    with tempfile.TemporaryDirectory(prefix="pai-preview-") as tmp:
        out = Path(tmp) / "preview.png"
        cmd = [
            sys.executable,
            "-I",  # isolated: ignore env vars and the current directory
            "-m",
            "paperless_api.documents.preview_worker",
            mime_type,
            str(source),
            str(out),
            str(max_px),
        ]
        try:
            proc = subprocess.run(
                cmd,
                capture_output=True,
                timeout=TIMEOUT_S,
                cwd=tmp,
                # Empty environment; Windows needs SYSTEMROOT to start Python at all.
                env={"SYSTEMROOT": os.environ.get("SYSTEMROOT", "")}
                if sys.platform == "win32"
                else {},
                preexec_fn=_limit_resources if sys.platform != "win32" else None,
                check=False,
            )
        except subprocess.TimeoutExpired as exc:
            raise PreviewFailed("preview timed out") from exc
        if proc.returncode != 0 or not out.exists():
            # stderr is deliberately not logged: it may contain document fragments.
            raise PreviewFailed("preview could not be rendered")
        data = out.read_bytes()
    if not data.startswith(b"\x89PNG\r\n\x1a\n"):
        raise PreviewFailed("renderer produced invalid output")
    return data
