from dataclasses import dataclass
import os


@dataclass(frozen=True)
class Settings:
    oracle_user: str = os.getenv("ORACLE_APP_USER", "lecture_app")
    oracle_password: str = os.getenv("ORACLE_APP_PASSWORD", "")
    oracle_dsn: str = os.getenv("ORACLE_DSN", "db:1521/FREEPDB1")


settings = Settings()
