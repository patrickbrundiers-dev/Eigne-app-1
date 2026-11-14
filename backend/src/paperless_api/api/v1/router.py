from fastapi import APIRouter

from paperless_api import __version__
from paperless_api.api.v1 import auth, documents

router = APIRouter(prefix="/api/v1")
router.include_router(auth.router)
router.include_router(documents.router)


@router.get("/health", tags=["system"])
async def health_v1() -> dict[str, str]:
    return {"status": "ok", "service": "paperless-ai-api", "version": __version__}
