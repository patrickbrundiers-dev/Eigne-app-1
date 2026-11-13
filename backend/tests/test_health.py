from fastapi.testclient import TestClient

from paperless_api.main import app

client = TestClient(app)


def test_health_returns_ok() -> None:
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_versioned_health_returns_ok_and_version() -> None:
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "ok"
    assert body["version"]


def test_request_id_is_echoed_and_bounded() -> None:
    response = client.get("/api/v1/health", headers={"x-request-id": "a" * 500})
    assert response.headers["x-request-id"] == "a" * 64


def test_request_id_generated_when_missing() -> None:
    response = client.get("/api/v1/health")
    assert len(response.headers["x-request-id"]) == 36
