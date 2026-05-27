  Flask REST API: User Management & DevOps Ecosystem 🚀

  Esta é uma API REST robusta para gerenciamento de usuários, desenvolvida em Python/Flask e integrada a um ecossistema moderno de DevOps. O
  projeto demonstra um ciclo de vida completo, desde o desenvolvimento local com Docker até o deploy escalonável em Kubernetes na AWS.

  🏗️ Arquitetura e Stack Tecnológica

  Core da Aplicação
   * Python 3.14+: Linguagem base.
   * Flask & Flask-RESTful: Framework leve para APIs escalonáveis.
   * MongoEngine: ODM para modelagem e interação com MongoDB.
   * MongoDB: Banco de dados NoSQL para persistência flexível.

  Infraestrutura & DevOps (Roadmap de Deploy)
   * AWS (Amazon Web Services): Cloud provider alvo para produção.
   * Kubernetes (EKS) & Helm: Orquestração de containers e gerenciamento de pacotes.
   * Terraform: Infraestrutura como Código (IaC) para provisionamento de recursos AWS (VPC, EKS, etc).
   * Ansible: Automação de configuração e provisionamento de instâncias.
   * DNS (Route 53 & External DNS): Gerenciamento automatizado de domínios dentro do cluster K8s.
   * GitHub Actions: Pipeline de CI/CD para testes automatizados e deploy contínuo.
   * Docker & Docker Compose: Padronização do ambiente de desenvolvimento.

  ---

  🗂️ Estrutura do Projeto

    1 .
    2 ├── application/            # Código fonte da API
    3 │   ├── app.py              # Definição de rotas e lógica de recursos (CRUD)
    4 │   ├── model.py            # Schemas de dados (MongoEngine)
    5 │   ├── db.py               # Inicialização da conexão com o banco
    6 │   └── tests/              # Testes unitários e de integração
    7 ├── kubernetes/             # Manifestos K8s e Helm Charts
    8 │   ├── charts/mongodb/     # Chart Helm customizado para o MongoDB
    9 │   └── config/             # Configurações do Cluster Kind (Local)
   10 ├── .github/workflows/      # Automação de CI/CD (GitHub Actions)
   11 ├── terraform/              # [Em breve] Módulos de Infraestrutura AWS
   12 ├── ansible/                # [Em breve] Playbooks de configuração
   13 ├── Dockerfile              # Definição da imagem da aplicação
   14 └── docker-compose.yml      # Orquestração local API + DB

  ---

  🚀 Como Executar

  1. Desenvolvimento Local (Docker Compose)
  A maneira mais rápida de subir o ambiente completo (API + MongoDB):

   1 docker-compose up --build
  A API estará disponível em http://localhost:5000.

  2. Kubernetes Local (Kind + Helm)
  O projeto inclui um Makefile para automatizar a criação de um ambiente K8s local idêntico ao de produção:

   1 # Cria o cluster Kind, instala Ingress Nginx e o Helm Chart do MongoDB
   2 make setup-dev

  ---

  🛣️ Endpoints da API

  ┌────────┬──────────────┬──────────────────────────────────────────────────┐
  │ Método │ Endpoint     │ Descrição                                        │
  ├────────┼──────────────┼──────────────────────────────────────────────────┤
  │ GET    │ /users       │ Lista todos os usuários cadastrados.             │
  │ GET    │ /user/<cpf>  │ Busca um usuário específico pelo CPF.            │
  │ POST   │ /user        │ Cria um novo usuário (Validação de CPF inclusa). │
  │ PATCH  │ /user        │ Atualiza dados de um usuário existente.          │
  │ DELETE │ /user/<cpf>  │ Remove um usuário do sistema.                    │
  │ GET    │ /healthcheck │ Verifica o status de saúde da API e Banco.       │
  └────────┴──────────────┴──────────────────────────────────────────────────┘
  ---

  ⚙️ Pipeline de CI/CD
  Atualmente, o projeto utiliza GitHub Actions para:
   1. Linting: Verificação de estilo com flake8.
   2. Testes: Execução de testes automatizados com pytest e mongomock.
   3. Build & Push: (Em transição para AWS ECR) Preparação da imagem Docker.
   4. Deploy: (Em transição para AWS EKS via Helm).

  ---

  🛠️ Próximos Passos (Roadmap)
   - [ ] Finalizar módulos Terraform para provisionamento do cluster EKS e VPC.
   - [ ] Implementar playbooks Ansible para hardening e configuração de nodes.
   - [ ] Integrar External DNS com Route 53 para exposição automática de serviços.
   - [ ] Configurar Secrets Management (AWS Secrets Manager ou HashiCorp Vault).
   - [ ] Implementar monitoramento com Prometheus/Grafana via Helm Charts.

  ---
  Este projeto é mantido como um laboratório de engenharia de software e DevOps de alta performance.

