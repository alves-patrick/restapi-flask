<div align="center">
  <img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" alt="Kubernetes Logo" width="100"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="100"/>
  <img src="https://www.vectorlogo.zone/logos/terraformio/terraformio-ar21.svg" alt="Terraform Logo" width="150"/>
  <img src="https://github.githubassets.com/images/modules/logos_page/GitHub-Mark.png" alt="GitHub Actions Logo" width="100"/>
  
  # 🚀 Enterprise Cloud-Native Infrastructure
  **Flask REST API | AWS EKS | GitOps | FinOps | CI/CD | IaC**
  
  [![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/alves-patrick/restapi-flask/actions)
  [![Terraform](https://img.shields.io/badge/IaC-Terraform_v5.x-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](#)
  [![Kubernetes](https://img.shields.io/badge/Orchestration-EKS_v1.35-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](#)
  [![Security](https://img.shields.io/badge/Security-OIDC_%7C_SealedSecrets-success?style=for-the-badge)](#)
</div>

---

## 🎯 Visão Geral do Projeto

Este repositório é um **Laboratório Completo de SRE e Engenharia de Plataforma**. Muito além de uma simples aplicação, este projeto simula um ecossistema corporativo real com foco em quatro pilares fundamentais: **Segurança (Zero-Trust)**, **Eficiência de Custos (FinOps)**, **Developer Experience (DX)** e **Automação (Self-Service)**.

A aplicação (API RESTful) roda em um cluster **AWS EKS** multi-node, roteada via **AWS ALB**, com criptografia ponta-a-ponta via **ACM (HTTPS)** e resolução dinâmica via **Route 53**.

🌐 **Live Demo:** [https://api.restapi-flask.xyz/users](https://api.restapi-flask.xyz/users)

---

## 🏗️ Arquitetura e Trade-offs (Por que fiz assim?)

Como engenheiro, cada decisão técnica teve um propósito claro de negócio:

### 1. Segurança e Redução de Custos: Sealed Secrets vs. AWS KMS
*   **A Decisão:** Utilizar o **Bitnami Sealed Secrets** no lugar do serviço gerenciado AWS KMS.
*   **O Motivo (FinOps):** O AWS KMS possui custos recorrentes de chamadas de API e gera *Vendor Lock-in*. O Sealed Secrets oferece criptografia assimétrica open-source, permitindo um fluxo **100% GitOps** (segredos no Git sem exposição) a custo zero, ideal para arquiteturas enxutas e startups.

### 2. Persistência In-Cluster: MongoDB via Helm
*   **A Decisão:** Instalar o MongoDB diretamente no EKS com volumes EBS (via AWS EBS CSI Driver) em vez de usar AWS DocumentDB.
*   **O Motivo (FinOps):** Serviços de banco de dados gerenciados exigem alto investimento inicial (mínimo de ~$50/mês). Esta abordagem utiliza os recursos excedentes dos nós `t3.small`, cortando drasticamente o custo de licenciamento, mantendo baixa latência (rede interna).

### 3. Autenticação Zero-Trust (OIDC + Access Entries)
*   **A Decisão:** Abandonar chaves fixas (Access Keys) e o frágil `aws-auth`.
*   **O Motivo (Segurança):** O CI/CD utiliza **OIDC** para assumir permissões temporárias, integradas diretamente às modernas **EKS Access Entries** do Terraform v5.x. Segurança de nível bancário, sem gambiarras.

---

## 💻 Developer Experience (DX): O Poder do Makefile

Tempo é o recurso mais caro de um desenvolvedor. O projeto foi projetado com a filosofia **"Local-First"**, garantindo que a nuvem seja apenas um espelho do seu laptop.

O `Makefile` abstrai a complexidade operacional, transformando horas de digitação em comandos de uma linha:

| Comando DX | O que ele faz (A Mágica) | Por que economiza tempo? |
| :--- | :--- | :--- |
| `make dev` | Sobe um cluster Kind local completo (Ingress + Mongo + App). | Validação imediata de código sem depender ou esperar pela infra da AWS. |
| `make test` | Executa Linter (`flake8`) e Unit Tests (`pytest`). | Feedback loop rápido na máquina antes do commit. |
| `make aws-up` | **Botão Vermelho:** Roda o Terraform completo e faz o deploy do Helm na AWS. | Um comando para transformar o repositório em um site público HTTPS. |
| `make aws-down` | **FinOps (Modo Econômico):** Destrói apenas os nós e o EKS. | Evita gastos desnecessários enquanto mantém DNS, IPs e ECR intactos. |

---

## ⚙️ O Painel "Self-Service" (GitHub Actions)

A automação atingiu o nível **SRE Self-Service**. O repositório possui dois robôs principais na aba *Actions*:

### 1. CI/CD Unificado (Continuous Deployment)
*   **Strict Quality Gate:** A cada `git push`, o robô executa os testes unitários. O deploy na AWS **só ocorre se (e somente se)** os testes passarem.
*   **Zero Downtime:** Faz o build, envia para o ECR e atualiza o Kubernetes via Helm sem que o site saia do ar.

### 2. Controle Remoto de Infraestrutura (FinOps)
Graças ao uso de **Remote State (S3 + DynamoDB Lock)**, o Terraform tem memória compartilhada. 
*   **Workflow "Infra Control":** Através de botões manuais na UI do GitHub (`workflow_dispatch`), qualquer pessoa autorizada pode clicar em **`apply`** (ligar toda a infra) ou **`destroy`** (desligar apenas os recursos caros, mantendo o DNS ativo), diretamente pelo celular.

---

## 🔌 Documentação da API (REST Endpoints)

A API gerencia usuários com validação rigorosa (incluindo algoritmo de validação de CPF).

### **Listar Usuários**
*   **GET** `/users`
*   *Retorna a lista completa de usuários (JSON).*

### **Criar Usuário**
*   **POST** `/user`
*   **Payload:**
    ```json
    {
      "first_name": "Patrick",
      "last_name": "Alves",
      "cpf": "123.456.789-00",
      "email": "patrick.devops@outlook.com",
      "birth_date": "1990-01-01"
    }
    ```

### **Atualizar Usuário**
*   **PATCH** `/user`
*   *Atualiza dados baseado no CPF fornecido.*

### **Remover Usuário**
*   **DELETE** `/user/<string:cpf>`
*   *Exclusão real do registro persistido no MongoDB.*

---

## 🤝 Contato

Este laboratório é a prova viva de que entendo não apenas os comandos, mas o *impacto comercial* da infraestrutura em nuvem.

<div align="left">
  <a href="https://www.linkedin.com/in/patrickalvesdev/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
  <a href="mailto:patrick.devops@outlook.com">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email"/>
  </a>
</div>
