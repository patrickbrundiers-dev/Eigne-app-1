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


@lru_cache
def get_settings() -> Settings:
    return Settings()
