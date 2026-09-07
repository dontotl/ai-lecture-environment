from backend.settings import settings


def database_is_available() -> bool:
    """Return whether the configured Oracle service accepts a simple query."""
    try:
        import oracledb

        with oracledb.connect(
            user=settings.oracle_user,
            password=settings.oracle_password,
            dsn=settings.oracle_dsn,
        ) as connection:
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1 FROM dual")
                return cursor.fetchone() == (1,)
    except Exception:
        return False
