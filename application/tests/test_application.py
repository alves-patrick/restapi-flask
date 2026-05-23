import pytest
from application import create_app
from config import MockConfig  # Importa direto da raiz do projeto

class TestApplication():

    @pytest.fixture
    def client(self):
        # Aqui é a mágica: Passamos a classe direto, SEM NENHUMA ASPAS!
        app = create_app(MockConfig)
        return app.test_client()
    
    def test_get_users(self, client):
        response = client.get('/users')
        assert response.status_code == 200