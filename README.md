# REST API Flask 🚀

Uma API REST completa e robusta desenvolvida em Python com o ecossistema Flask, utilizando **MongoEngine** para persistência de dados no MongoDB, conteinização com **Docker / Docker Compose**, e uma esteira automatizada de CI/CD via **GitHub Actions** integrada ao **Heroku Container Registry**.

O projeto foi desenhado seguindo as melhores práticas de desenvolvimento de software (Twelve-Factor App), isolando variáveis de ambiente e permitindo 
que a stack mude de banco local (Docker) para nuvem (MongoDB Atlas) de forma totalmente transparente.

---

## 🛠️ Tecnologias Utilizadas

- **Python 3.14+**
- **Flask** & **Flask-RESTful** (Arquitetura baseada em Recursos para endpoints limpos)
- **MongoEngine** (ODM para mapeamento de objetos e schemas do MongoDB)
- **Docker** & **Docker Compose** (Padronização e isolamento do ambiente de desenvolvimento)
- **GitHub Actions** (Automação de testes e Deploy Contínuo)
- **Heroku Container Registry** (Hospedagem baseada em containers na nuvem)

---

## 🗂️ Estrutura do Projeto

```text
.
├── application/            # Módulo principal da aplicação Flask
│   ├── __init__.py         # Inicialização do App, API e Banco de Dados
│   ├── app.py              # Definição das rotas e lógica dos Recursos (Resources)
│   ├── db.py               # Configuração e inicialização do ODM MongoEngine
│   └── models.py           # Modelos de dados / Schemas do MongoDB
├── .github/
│   └── workflows/
│       └── python-app.yml  # Esteira de CI/CD (GitHub Actions)
├── config.py               # Gerenciamento de ambientes (DevConfig, ProdConfig)
├── Dockerfile              # Instruções de build da imagem Docker (Alpine Linux)
├── docker-compose.yml      # Orquestração do container da API + Banco de Dados local
├── Makefile                # Atalhos de comandos para produtividade no terminal
├── requirements.txt        # Dependências do projeto Python
└── wsgi.py                 # Ponto de entrada para servidores WSGI (Gunicorn)
