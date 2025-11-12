from pathlib import Path
from typing import Optional

from pydantic import BaseSettings, Field, validator


class Settings(BaseSettings):
    """Runtime configuration for the backend service."""

    database_url: Optional[str] = Field(
        default=None,
        description=(
            "SQLAlchemy connection string. Overrides the Supabase settings when provided."
        ),
    )
    supabase_project_ref: Optional[str] = Field(
        default=None,
        description="Identificador do projeto Supabase (ex.: abcdefghijklmno).",
    )
    supabase_db_password: Optional[str] = Field(
        default=None,
        description="Senha do banco Postgres do Supabase (role `postgres`).",
    )
    supabase_db_user: str = Field(
        default="postgres",
        description="Usuário do banco Postgres do Supabase.",
    )
    supabase_db_name: str = Field(
        default="postgres",
        description="Nome do banco Postgres do Supabase.",
    )
    supabase_db_port: int = Field(
        default=5432,
        description="Porta de conexão com o Postgres do Supabase.",
    )
    supabase_url: Optional[str] = Field(
        default=None,
        description="URL do projeto Supabase (https://<ref>.supabase.co).",
    )
    supabase_service_role_key: Optional[str] = Field(
        default=None,
        description="Chave service role do Supabase para chamadas administrativas.",
    )

    @validator("database_url", pre=True, always=True)
    def build_database_url(cls, v: Optional[str], values: dict) -> str:
        if v:
            return v

        project_ref = values.get("supabase_project_ref")
        password = values.get("supabase_db_password")

        if project_ref and password:
            user = values.get("supabase_db_user")
            port = values.get("supabase_db_port")
            db_name = values.get("supabase_db_name")
            host = f"db.{project_ref}.supabase.co"
            return (
                f"postgresql+psycopg2://{user}:{password}@{host}:{port}/{db_name}"
                "?sslmode=require"
            )

        return f"sqlite:///{Path('data/orbit.db').absolute()}"

    class Config:
        env_prefix = "ORBIT_"
        env_file = ".env"


def get_settings() -> Settings:
    return Settings()
