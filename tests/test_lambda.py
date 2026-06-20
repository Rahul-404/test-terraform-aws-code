import json
import pytest
from unittest.mock import patch
import sys
import os

# Add the lambda directory to the sys.path so pytest can find the module
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../lambda')))

from lambda_function import lambda_handler
import lambda_function

# -----------------------------
# Helper to parse response body
# -----------------------------
def get_body(response):
    return json.loads(response['body'])


# -----------------------------
# 1. Test Default Behavior
# -----------------------------
def test_default_values():
    event = {}

    response = lambda_handler(event, None)

    assert response['statusCode'] == 200
    body = get_body(response)

    assert body['min'] == 1
    assert body['max'] == 100
    assert 1 <= body['random_value'] <= 100


# -----------------------------
# 2. Test GET Query Parameters
# -----------------------------
def test_get_query_params():
    event = {
        "queryStringParameters": {
            "min": "10",
            "max": "20"
        }
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 200
    body = get_body(response)

    assert body['min'] == 10
    assert body['max'] == 20
    assert 10 <= body['random_value'] <= 20


# -----------------------------
# 3. Test POST Body
# -----------------------------
def test_post_body():
    event = {
        "body": json.dumps({
            "min": 5,
            "max": 15
        })
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 200
    body = get_body(response)

    assert body['min'] == 5
    assert body['max'] == 15
    assert 5 <= body['random_value'] <= 15


# -----------------------------
# 4. Test POST Overrides GET
# -----------------------------
def test_post_overrides_get():
    event = {
        "queryStringParameters": {
            "min": "1",
            "max": "10"
        },
        "body": json.dumps({
            "min": 20,
            "max": 30
        })
    }

    response = lambda_handler(event, None)

    body = get_body(response)

    assert body['min'] == 20
    assert body['max'] == 30
    assert 20 <= body['random_value'] <= 30


# -----------------------------
# 5. Test Invalid Range
# -----------------------------
def test_invalid_range():
    event = {
        "queryStringParameters": {
            "min": "50",
            "max": "10"
        }
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 400
    body = get_body(response)

    assert body['error'] == "Invalid Input"


# -----------------------------
# 6. Test Invalid JSON Body (Fallback)
# -----------------------------
def test_invalid_json_body():
    event = {
        "body": "invalid-json"
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 200
    body = get_body(response)

    # Should fallback to defaults
    assert body['min'] == 1
    assert body['max'] == 100


# -----------------------------
# 7. Test Non-Integer Input
# -----------------------------
def test_non_integer_input():
    event = {
        "queryStringParameters": {
            "min": "abc",
            "max": "10"
        }
    }

    response = lambda_handler(event, None)

    assert response['statusCode'] == 400


# -----------------------------
# 8. Mock Random for Deterministic Testing
# -----------------------------
@patch("lambda_function.random.randint")
def test_mocked_random(mock_randint):
    mock_randint.return_value = 42

    event = {
        "queryStringParameters": {
            "min": "1",
            "max": "100"
        }
    }

    response = lambda_handler(event, None)

    body = get_body(response)

    assert body['random_value'] == 42