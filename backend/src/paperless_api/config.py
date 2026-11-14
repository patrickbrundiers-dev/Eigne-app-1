"""Application settings loaded from environment variables / `.env`."""

from functools import lru_cache
from typing import Literal

from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8", extra="ignore")

    app_env: Literal["development", "test", "production"] = "development"
    app_name: str = "Paperless AI API"
    # SQLite keeps local development possible without Docker. Use PostgreSQL for anything shared.
    database_url: str = "sqlite+pysqlite:///./paperless-dev.db"
    log_level: str = "INFO"
    log_json: bool = True

    # Document storage. Staging lives below storage_dir so promotion is an atomic rename.
    storage_dir: str = "./data"
    # LocalBlobStore keeps PLAINTEXT. Only for synthetic test documents; refused in production.
    allow_unencrypted_storage: bool = False
    max_upload_bytes: int = 50 * 1024 * 1024
    max_pdf_pages: int = 500
    max_image_pixels: int = 80_000_000
    reject_pdf_active_content: bool = True


@lru_cache
def get_settings() -> Settings:
    return Settings()
