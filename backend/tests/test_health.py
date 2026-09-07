from fastapi.testclient import TestClient


def test_health_returns_connected_when_database_query_succeeds(monkeypatch):
    from backend import main

    monkeypatch.setattr(main, "database_is_available", lambda: True)

    response = TestClient(main.app).get("/api/health")

    assert response.status_code == 200
    assert response.json() == {"status": "ok", "database": "connected"}


def test_health_returns_degraded_when_database_query_fails(monkeypatch):
    from backend import main

    monkeypatch.setattr(main, "database_is_available", lambda: False)

    response = TestClient(main.app).get("/api/health")

    assert response.status_code == 503
    assert response.json() == {"status": "degraded", "database": "unavailable"}
