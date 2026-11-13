from fastapi import APIRouter

from paperless_api import __version__

router = APIRouter(prefix="/api/v1")


@router.get("/health", tags=["system"])
async def health_v1() -> dict[str, str]:
    return {"status": "ok", "service": "paperless-ai-api", "version": __version__}
