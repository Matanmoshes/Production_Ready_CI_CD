import pytest
from unittest.mock import patch
import os

from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

mock_weather_data = {
    "timezone": 3600,
    "main": {
        "temp": 15,
        "feels_like": 14,
        "temp_min": 10,
        "temp_max": 20,
    },
    "weather": [{"description": "clear sky"}],
    "wind": {"speed": 5},
    "name": "London"
}

@patch("app.requests.get")
def test_index_get(mock_get, client):
    mock_get.return_value.json.return_value = mock_weather_data
    response = client.get("/")
    assert response.status_code == 200
    assert b"Get Weather" in response.data

@patch("app.requests.get")
def test_index_post(mock_get, client):
    mock_get.return_value.json.return_value = mock_weather_data
    response = client.post("/", data={"city": "London"})
    assert response.status_code == 200
    assert b"London" in response.data
    assert b"clear sky" in response.data

def test_api_key():
    assert os.getenv("OPENWEATHER_API_KEY") is not None
