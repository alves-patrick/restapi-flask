# 🚀 Cloud Native & Hybrid Infrastructure: Flask REST API

Este projeto é um laboratório avançado de engenharia de software e infraestrutura moderna.

---

## 🏗️ Arquitetura Híbrida

O grande diferencial deste projeto é a flexibilidade de execução. Através de um **Makefile inteligente**, o desenvolvedor pode alternar entre ambientes com um único comando:

| Ambiente | Orquestração | Banco de Dados | Segurança |
| :--- | :--- | :--- | :--- |
| **Local** | Kubernetes (Kind) | MongoDB (Helm) | Secrets Manuais |
| **Cloud** | AWS EKS | MongoDB (Helm) | Sealed Secrets (GitOps) |

---

## 🛠️ Stack Tecnológica

- **Backend:** Python 3.14+, Flask, Flask-RESTful
- **Banco de Dados:** MongoDB, MongoEngine (ODM)
- **Containerização:** Docker (Multi-stage builds planejado)
- **Orquestração:** Kubernetes, Helm v3
- **Infra-as-Code:** Terraform (Módulos Locais)
- **Segurança:** Bitnami Sealed Secrets (GitOps Ready)
- **CI/CD:** GitHub Actions (Linter & Testes)

---

## ✨ Funcionalidades Profissionais

- **Segurança GitOps:** Credenciais sensíveis são criptografadas com **Sealed Secrets**, permitindo que segredos selados fiquem versionados no GitHub sem riscos.
- **Helm Charts Customizados:** Refatoração completa para modularização via `values.yaml`, facilitando deploys em múltiplos clusters.
- **Infraestrutura Otimizada:** Cluster EKS utilizando instâncias `t3.small` e NAT Gateway único, focando em custo/benefício sem perder performance.
- **Automação via Makefile:** Comandos simplificados para build, push, deploy e manutenção do cluster.

---

## 🚀 Como Executar

### 1. Desenvolvimento Local (Kind)
O ambiente local simula 100% o ambiente de produção, incluindo Ingress Nginx e o banco de dados via Helm.
```bash
# Sobe o cluster local, Ingress, MongoDB e API automaticamente
make dev
```

### 2. Deploy na Nuvem (AWS EKS)
Após o provisionamento via Terraform, o deploy é automatizado:
```bash
# 1. Faz o push da imagem para o ECR
make aws-push

# 2. Realiza o deploy no cluster EKS
make aws-deploy
```

---

## 🧪 Qualidade e Segurança

- **Testes Automatizados:** Suíte de testes com `Pytest` e `Mongomock`.
- **Análise Estática:** Linter `Flake8` integrado ao workflow.
- **GitOps:** Uso de `kubeseal` para gerenciamento de chaves mestras e restauração de desastres.

---

## 🤝 Contato

Desenvolvido por **Patrick Alves** - *Focado em soluções Cloud Native e Automação.*
