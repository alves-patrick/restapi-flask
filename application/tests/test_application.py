import pytest
import json
from application import create_app
from config import MockConfig


class TestApplication:

    @pytest.fixture
    def client(self):
        app = create_app(MockConfig)
        return app.test_client()

    @pytest.fixture
    def valid_user(self):
        return {
            "first_name": "Patrick",
            "last_name": "Alves",
            "cpf": "959.571.430-57",
            "email": "contatopatrick@alves.com",
            "birth_date": "1998-09-10",
        }

    def test_get_users(self, client):
        response = client.get("/users")
        assert response.status_code == 200

    def test_post_user(self, client, valid_user):
        response = client.post("/user", json=valid_user)
        assert response.status_code == 200
        assert b"successfully" in response.data

    def test_post_user_invalid_cpf(self, client, valid_user):
        invalid_user = valid_user.copy()
        invalid_user["cpf"] = "111.111.111-11"

        response = client.post("/user", json=invalid_user)
        assert response.status_code == 400
        assert b"CPF is invalid!" in response.data

    def test_get_user_by_cpf(self, client, valid_user):
        client.post("/user", json=valid_user)

        response = client.get(f"/user/{valid_user['cpf']}")
        assert response.status_code == 200

        data = json.loads(response.data)
        assert data["cpf"] == valid_user["cpf"]
        assert data["first_name"] == valid_user["first_name"]

    def test_get_user_not_found(self, client):
        response = client.get("/user/000.000.000-00")
        assert response.status_code == 400
        assert b"User does not exist in database!" in response.data

    def test_patch_user(self, client, valid_user):
        client.post("/user", json=valid_user)

        updated_data = valid_user.copy()
        updated_data["first_name"] = "Patrick Editado"

        response = client.patch("/user", json=updated_data)
        assert response.status_code == 200
        assert b"User updated successfully!" in response.data

    def test_delete_user(self, client, valid_user):
        client.post("/user", json=valid_user)

        response = client.delete(f"/user/{valid_user['cpf']}")
        assert response.status_code == 200
        assert b"User deleted!" in response.data

    def test_delete_user_not_found(self, client):
        response = client.delete("/user/000.000.000-00")
        assert response.status_code == 400
        assert b"User does not exist in database!" in response.data
