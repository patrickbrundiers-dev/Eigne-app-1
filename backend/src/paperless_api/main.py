import logging
import time
import uuid

from fastapi import FastAPI, Request, Response
from fastapi.responses import JSONResponse

from paperless_api import __version__
from paperless_api.api.v1 import router as api_v1_router
from paperless_api.config import get_settings
from paperless_api.logging_config import configure_logging

logger = logging.getLogger("paperless_api.request")

# Multipart framing on top of the file itself.
MULTIPART_OVERHEAD = 64 * 1024


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging(settings.log_level, settings.log_json)

    app = FastAPI(
        title=settings.app_name,
        version=__version__,
        description=("Development build. Not production-ready: blob storage is not encrypted yet."),
        # Interactive docs only outside production.
        docs_url=None if settings.app_env == "production" else "/docs",
        redoc_url=None,
    )

    max_body = settings.max_upload_bytes + MULTIPART_OVERHEAD

    @app.middleware("http")
    async def limit_body_size(request: Request, call_next) -> Response:
        """Reject oversized bodies before they are read. Chunked bodies without
        Content-Length are still capped by the import pipeline; set a body limit in the
        reverse proxy too (see docs/DOCUMENT_IMPORT.md)."""
        length = request.headers.get("content-length")
        if length and length.isdigit() and int(length) > max_body:
            return JSONResponse(
                status_code=413,
                content={"detail": {"code": "too_large", "message": "request body is too large"}},
            )
        return await call_next(request)

    @app.middleware("http")
    async def request_log(request: Request, call_next) -> Response:
        request_id = (request.headers.get("x-request-id") or str(uuid.uuid4()))[:64]
        start = time.perf_counter()
        response = await call_next(request)
        # Log method, path and status only: never query strings, headers or bodies.
        logger.info(
            "request",
            extra={
                "request_id": request_id,
                "method": request.method,
                "path": request.url.path,
                "status": response.status_code,
                "duration_ms": round((time.perf_counter() - start) * 1000, 1),
            },
        )
        response.headers["x-request-id"] = request_id
        response.headers.setdefault("x-content-type-options", "nosniff")
        response.headers.setdefault("referrer-policy", "no-referrer")
        return response

    @app.get("/health", tags=["system"])
    async def health() -> dict[str, str]:
        """Unversioned liveness probe for container orchestration."""
        return {"status": "ok", "service": "paperless-ai-api"}

    app.include_router(api_v1_router)
    return app


app = create_app()
