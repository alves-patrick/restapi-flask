# 🚀 Full-Cycle DevOps: Flask REST API & Cloud Infrastructure

Este projeto é um laboratório de engenharia de software e DevOps de alta performance. Ele demonstra o ciclo de vida completo de uma aplicação, desde o desenvolvimento local padronizado com **Docker** até a orquestração escalonável em **Kubernetes**, visando um ambiente de produção resiliente na **AWS**.

---

## 🛠️ Stack Tecnológica

| Camada | Tecnologia |
| :--- | :--- |
| **Backend** | Python 3.14+, Flask, Flask-RESTful |
| **Banco de Dados** | MongoDB, MongoEngine (ODM) |
| **Containerização** | Docker, Docker Compose |
| **Orquestração** | Kubernetes (Kind), Helm |
| **Qualidade** | Pytest, Flake8, GitHub Actions |
| **Roadmap Cloud** | Terraform, Ansible, AWS (EKS, Route 53) |

---

## ✨ Funcionalidades Principais

- **CRUD Completo de Usuários:** Gerenciamento eficiente com persistência em NoSQL.
- **Validação de Negócio:** Algoritmo robusto para validação de CPF.
- **Healthcheck Dinâmico:** Monitoramento de saúde da API e conectividade com o banco.
- **Arquitetura Escalável:** Preparado para rodar em clusters de alta disponibilidade.
- **Infra-as-Code (IaC):** Manifestos Kubernetes prontos para Ingress e Service.

---

## 🚀 Como Executar o Projeto

### 1. Desenvolvimento Local (Docker Compose)
Ideal para desenvolvimento rápido e debug da API.
```bash
# Sobe a API e o MongoDB automaticamente
make compose
```
📍 Acesse em: `http://localhost:5000`

### 2. Ambiente Kubernetes Local (Kind + Ingress)
Simula um ambiente de produção com roteamento via Ingress.
```bash
# Cria o cluster, instala o Ingress Nginx e o Helm Chart do MongoDB
make setup-dev

# Aplica os manifestos da aplicação
kubectl apply -f kubernetes/manifests/
```
📍 Teste o roteamento (Ingress):
```bash
curl localhost/users -H "Host: api.localhost.com"
```

---

## 🧪 Qualidade e Testes

O projeto segue práticas rigorosas de testes para garantir a estabilidade.
```bash
# Executa a suíte de testes (Pytest + Mongomock)
make test
```

---

## 🗺️ Roadmap de Evolução (Próximos Passos)

O projeto está em constante evolução. Os próximos módulos incluem:

- [ ] **Produção com Helm:** Criação de Charts customizados para deploy simplificado.
- [ ] **IaC com Terraform:** Provisionamento automatizado de VPC e Cluster EKS na AWS.
- [ ] **Automação com Ansible:** Hardening de instâncias e configuração de workers.
- [ ] **Cloud Networking:** Integração de **Route 53** com **External DNS** para automação de domínios.
- [ ] **Observabilidade:** Implementação de stack Prometheus & Grafana.

---

## 📖 Endpoints da API

| Método | Rota | Descrição |
| :--- | :--- | :--- |
| `GET` | `/users` | Lista todos os usuários. |
| `GET` | `/user/<cpf>` | Detalhes de um usuário específico. |
| `POST` | `/user` | Cadastro de novo usuário. |
| `PATCH` | `/user` | Atualização de dados cadastrais. |
| `DELETE` | `/user/<cpf>` | Remoção de usuário do sistema. |
| `GET` | `/health` | Status de saúde da aplicação. |

---

## 🤝 Contato

Desenvolvido por **Patrick Alves** - *Focado em soluções escalonáveis e cultura DevOps.*
