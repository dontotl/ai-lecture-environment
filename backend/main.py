from fastapi import FastAPI, status
from fastapi.responses import JSONResponse

from backend.database import database_is_available


app = FastAPI(title="Lecture Environment API")


@app.get("/api/health")
def health() -> JSONResponse:
    if database_is_available():
        return JSONResponse({"status": "ok", "database": "connected"})
    return JSONResponse(
        {"status": "degraded", "database": "unavailable"},
        status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
    )
