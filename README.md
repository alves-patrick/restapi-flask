<div align="center">
  <img src="https://raw.githubusercontent.com/kubernetes/kubernetes/master/logo/logo.png" alt="Kubernetes Logo" width="100"/>
  <img src="https://upload.wikimedia.org/wikipedia/commons/9/93/Amazon_Web_Services_Logo.svg" alt="AWS Logo" width="100"/>
  <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/public/img/logo-terraform-main.svg" alt="Terraform Logo" width="100"/>
  
  # 🚀 Enterprise Cloud-Native Infrastructure
  **Flask REST API on AWS EKS with GitOps, CI/CD, and Makefile Automation**
  
  [![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub_Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/alves-patrick/restapi-flask/actions)
  [![Terraform](https://img.shields.io/badge/IaC-Terraform_v5.x-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](#)
  [![Kubernetes](https://img.shields.io/badge/Orchestration-EKS_v1.35-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](#)
  [![Security](https://img.shields.io/badge/Security-OIDC_%7C_SealedSecrets-success?style=for-the-badge)](#)
</div>

---

## 🎯 Visão Geral do Projeto

Este repositório é um **Laboratório de Engenharia de Plataforma**. Ele foca em **Developer Experience (DX)**, permitindo que o desenvolvedor teste todo o ciclo de vida da aplicação localmente antes de realizar o deploy na nuvem AWS.

A arquitetura utiliza **AWS EKS**, roteamento via **AWS ALB**, certificados **ACM (HTTPS)** e **Route 53** para DNS automático.

🌐 **Live Demo:** [https://api.restapi-flask.xyz/users](https://api.restapi-flask.xyz/users)

---

## 🛠️ Automação e Developer Experience (DX)

O diferencial deste projeto é o uso do **Makefile** como orquestrador de tarefas. Ele garante que o ambiente local seja uma cópia fiel da produção, reduzindo o erro de "funciona na minha máquina".

### Fluxo de Trabalho Ideal:
1.  **Local-First:** O dev roda `make dev` para subir um cluster Kind com MongoDB e Ingress.
2.  **Testes:** Valida as alterações localmente.
3.  **Cloud:** Após o push, o GitHub Actions assume o deploy na AWS.

| Comando | Descrição |
| :--- | :--- |
| `make dev` | **Mágica em um passo:** Cria cluster Kind, instala Helm, Ingress, MongoDB e faz o deploy da App localmente. |
| `make test` | Executa a suíte de testes com **Pytest** e análise estática com **Flake8**. |
| `make aws-push` | Realiza o login no Amazon ECR, faz o build da imagem e o push para a nuvem. |
| `make aws-deploy` | Sincroniza os manifestos e atualiza a aplicação no cluster EKS. |

---

## 🏗️ Arquitetura e Decisões de Mestre

*   **FinOps & Escalabilidade:** Cluster configurado com 2 nós `t3.small` para equilibrar custo e capacidade de pods (superando o limite de ENIs da AWS).
*   **Storage Nativo:** Implementação do **Amazon EBS CSI Driver** para persistência real do MongoDB.
*   **Segurança Moderna:** Autenticação via **OIDC** no CI/CD e **EKS Access Entries** para gestão de permissões.
*   **GitOps:** Uso de **Sealed Secrets** para versionar credenciais criptografadas.

---

## 🔌 Documentação da API (REST Endpoints)

A API gerencia um cadastro de usuários com persistência em MongoDB.

### **Listar Usuários**
*   **GET** `/users`
*   *Retorna a lista completa de usuários em JSON.*

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
*   *Atualiza dados baseado no CPF enviado no corpo da requisição.*

### **Remover Usuário**
*   **DELETE** `/user/<string:cpf>`
*   *Remove permanentemente o registro do banco de dados.*

---

## ⚙️ Pipeline CI/CD

Este projeto utiliza uma esteira única de **CI/CD** no GitHub Actions:
1.  **Lint & Unit Tests:** Garante a qualidade do código antes de qualquer ação.
2.  **Build & Push:** Gera a imagem Docker e envia para o ECR.
3.  **Zero Downtime Deploy:** Atualiza o Helm Chart no EKS de forma transparente.

---

## 🤝 Contato

Desenvolvido por **Patrick Alves** - *Especialista em Cloud & Automação.*

<div align="left">
  <a href="https://www.linkedin.com/in/patrickalvesdev/" target="_blank">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"/>
  </a>
  <a href="mailto:patrick.devops@outlook.com">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email"/>
  </a>
</div>
