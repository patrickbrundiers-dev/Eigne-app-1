from fastapi import FastAPI

app = FastAPI(
    title="Paperless AI API",
    version="0.1.0",
    description="Development scaffold. Authentication and document APIs are not implemented yet.",
)


@app.get("/health", tags=["system"])
async def health() -> dict[str, str]:
    return {"status": "ok", "service": "paperless-ai-api"}
