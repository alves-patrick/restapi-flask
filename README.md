<div align="center">
  <img src="https://kubernetes.io/images/nav_logo.svg" alt="Kubernetes Logo" width="100"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="100"/>
  <img src="https://www.terraform.io/img/logo-hashicorp.svg" alt="Terraform Logo" width="100"/>
  
  # 🚀 Enterprise Cloud-Native Infrastructure
  **Flask REST API on AWS EKS with GitOps, CI/CD, and IaC**
  
  [![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/alves-patrick/restapi-flask/actions)
  [![Terraform](https://img.shields.io/badge/IaC-Terraform_v5.x-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](#)
  [![Kubernetes](https://img.shields.io/badge/Orchestration-EKS_v1.35-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](#)
  [![Security](https://img.shields.io/badge/Security-OIDC_%7C_SealedSecrets-success?style=for-the-badge)](#)
</div>

---

## 🎯 Visão Geral do Projeto

Este repositório não é apenas uma aplicação; é um **Laboratório de Engenharia de Confiabilidade (SRE)**. Ele simula uma arquitetura corporativa completa, desenhada para ser altamente disponível, segura (Zero-Trust) e 100% automatizada.

A aplicação (uma API RESTful em Flask) é provisionada em um cluster **AWS EKS**, roteada através de um **AWS Application Load Balancer (ALB)**, com comunicação criptografada por certificados gerados via **AWS ACM** e resolução de DNS automatizada via **Route 53**.

🌐 **Live Demo:** [https://api.restapi-flask.xyz/users](https://api.restapi-flask.xyz/users)

---

## 🏗️ Arquitetura e Decisões Técnicas (Architecture & Trade-offs)

### 1. Infraestrutura como Código (Terraform)
*   **Modularidade:** Módulos independentes para VPC, EKS Cluster, Node Groups e Add-ons.
*   **FinOps & Capacity Planning:** Uso inteligente de instâncias `t3.small`. O cluster foi escalado via Terraform para 2 nós a fim de superar as limitações de IPs/ENIs (`Max Pods per Node`) inerentes às instâncias menores da AWS.
*   **Modernização do EKS:** Implementação do **Amazon EBS CSI Driver** nativo via add-ons e adoção de **EKS Access Entries** (sem a fragilidade do ConfigMap `aws-auth`).

### 2. Entrega de Software (Helm & GitOps)
*   **In-Cluster Database:** MongoDB implementado via Helm com volumes persistentes (EBS). Esta escolha evita o alto custo inicial de serviços gerenciados (como o AWS DocumentDB), sendo ideal para arquiteturas de microsserviços em startups.
*   **Sealed Secrets:** Implementação do padrão GitOps para segurança. Credenciais do banco nunca tocam o repositório em plain-text; são criptografadas via `kubeseal` e descriptografadas apenas *inside-the-cluster*.

### 3. Exposição de Borda (Edge & Traffic)
*   **Ingress Controller (ALB):** Substituição do tradicional NGINX pelo AWS Load Balancer Controller para garantir integração total com a nuvem AWS e redirecionamento HTTP para HTTPS direto na borda.
*   **DNS Dinâmico (ExternalDNS):** Sincronização em tempo real entre o Kubernetes Ingress e a zona de domínio no Route 53.

---

## ⚙️ CI/CD: O Motor de Automação

O coração do projeto é a esteira de Continuous Deployment (CD), que leva a aplicação do código para a produção em menos de 2 minutos.

*   **Autenticação Zero-Trust (OIDC):** O GitHub Actions se comunica com a AWS sem chaves estáticas (`AWS_ACCESS_KEY_ID`), assumindo uma Role temporária baseada em confiança OIDC.
*   **Fluxo de Deploy:**
    1.  Checkout do código.
    2.  Autenticação OIDC.
    3.  Login no Amazon ECR.
    4.  Build, Tagging (SHA) e Push da imagem Docker.
    5.  Atualização transparente (Zero Downtime) via `helm upgrade`.

---

## 🧪 Stack Tecnológica

| Camada | Tecnologia Principal | Papel no Projeto |
| :--- | :--- | :--- |
| **Backend** | Python 3.14 / Flask / MongoEngine | API REST e regras de negócio. |
| **Database** | MongoDB (Helm) / EBS | Persistência de dados in-cluster. |
| **Infra/Cloud** | AWS (EKS, VPC, ECR, Route 53, ACM, IAM) | Provedor de Cloud Pública. |
| **Provisionamento** | Terraform v5.x | Gerenciamento de estado da infra. |
| **Automação** | GitHub Actions / OIDC | CI/CD Pipeline. |
| **Segurança** | Bitnami Sealed Secrets | Gerenciamento GitOps de credenciais. |

---

## 🚀 Como Explorar este Repositório

### Execução Local (Ambiente de Dev)
O projeto conta com um Makefile para simular a nuvem localmente usando o **Kind**:
```bash
# Provisiona Kind, Helm, Sealed Secrets, Ingress Nginx, MongoDB e a App
make dev
```

### Endpoints da API
A API recebe e valida um JSON contendo informações de um usuário (incluindo validação matemática de CPF).

**Criar Usuário (`POST /users`)**
```json
{
  "first_name": "Patrick",
  "last_name": "Alves",
  "cpf": "123.456.789-00",
  "email": "patrick.devops@outlook.com",
  "birth_date": "1990-01-01"
}
```

---

## 🤝 Contato

Projeto idealizado e desenvolvido para demonstrar excelência em SRE e Cloud Computing.

<div align="left">
  <a href="https://www.linkedin.com/in/patrickalvesdev/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
  <a href="mailto:patrick.devops@outlook.com">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email"/>
  </a>
</div>
