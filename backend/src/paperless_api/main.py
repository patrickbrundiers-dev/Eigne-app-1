import logging
import time
import uuid

from fastapi import FastAPI, Request, Response

from paperless_api import __version__
from paperless_api.api.v1 import router as api_v1_router
from paperless_api.config import get_settings
from paperless_api.logging_config import configure_logging

logger = logging.getLogger("paperless_api.request")


def create_app() -> FastAPI:
    settings = get_settings()
    configure_logging(settings.log_level, settings.log_json)

    app = FastAPI(
        title=settings.app_name,
        version=__version__,
        description=(
            "Development build. Authentication and document APIs are not implemented yet."
        ),
        # Interactive docs only outside production.
        docs_url=None if settings.app_env == "production" else "/docs",
        redoc_url=None,
    )

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
        return response

    @app.get("/health", tags=["system"])
    async def health() -> dict[str, str]:
        """Unversioned liveness probe for container orchestration."""
        return {"status": "ok", "service": "paperless-ai-api"}

    app.include_router(api_v1_router)
    return app


app = create_app()
