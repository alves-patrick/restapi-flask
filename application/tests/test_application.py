import pytest
from application import create_app
from config import MockConfig  # Importa direto da raiz do projeto

class TestApplication():

    @pytest.fixture
    def client(self):
        # Aqui é a mágica: Passamos a classe direto, SEM NENHUMA ASPAS!
        app = create_app(MockConfig)
        return app.test_client()
    
    @pytest.fixture
    def valid_user(self):
        return {
            "first_name": "Patrick",
            "last_name": "Alves",
            "cpf": "959.571.430-57",
            "email": "contatopatrick@alves.com",
            "birth_date": "1998-09-10"
        }
    
    def test_get_users(self, client):
        response = client.get('/users')
        assert response.status_code == 200

    def test_post_user(self, client, valid_user):
        response = client.post('/user', json=valid_user)
        assert response.status_code == 200
        assert b"successfully" in response.data
