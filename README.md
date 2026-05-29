# 🚀 Cloud Native & Hybrid Infrastructure: Flask REST API

Este projeto é um laboratório avançado de engenharia de software e infraestrutura moderna. Ele simula um ciclo de vida real de uma aplicação Cloud Native, focando em segurança, automação e práticas de mercado (GitOps e IaC).

---

## 🏗️ Arquitetura Híbrida e Flexível

O grande diferencial deste projeto é a paridade entre desenvolvimento e produção. Através de um **Makefile inteligente**, é possível alternar entre ambientes com um único comando:

| Ambiente | Orquestração | Exposição (Ingress) | Segurança |
| :--- | :--- | :--- | :--- |
| **Local** | Kubernetes (Kind) | Nginx Ingress | Secrets Manuais |
| **Cloud** | AWS EKS | AWS ALB + External DNS | Sealed Secrets (GitOps) |

---

## 🛠️ Stack Tecnológica

- **Backend:** Python 3.14+, Flask, Flask-RESTful
- **Banco de Dados:** MongoDB (Implantado via Helm)
- **Containerização:** Docker (Alpine base)
- **Orquestração:** Kubernetes, Helm v3
- **Infra-as-Code (IaC):** Terraform (Módulos Locais)
- **Segurança e Borda:** Bitnami Sealed Secrets, AWS ACM (TLS/SSL)
- **CI/CD:** GitHub Actions (OIDC)

---

## ✨ Destaques Profissionais (O que os recrutadores buscam)

1. **Gestão de Tráfego e DNS Dinâmico:**
   - Integração do **AWS Load Balancer Controller** para provisionamento automático de ALBs.
   - Uso de **External DNS** sincronizado com o AWS Route 53. Ao realizar um deploy, o domínio (`restapi-flask.xyz`) é atualizado automaticamente sem intervenção manual.

2. **Segurança de Borda (Edge Security):**
   - Tráfego 100% encriptado via HTTPS com certificados gerados automaticamente pelo **AWS ACM** e validados por DNS. Redirecionamento forçado de HTTP para HTTPS diretamente no ALB.

3. **Segurança GitOps (Zero Trust):**
   - Credenciais de banco de dados criptografadas usando **Sealed Secrets**. Nenhum dado sensível em plain-text no repositório, garantindo um fluxo GitOps seguro.

4. **Infraestrutura Otimizada e Modular:**
   - Terraform estruturado em módulos (Network, Cluster, Add-ons).
   - Cluster EKS otimizado com instâncias `t3.small` e NAT Gateway único, demonstrando consciência de **FinOps** e limites arquiteturais (ENIs).

5. **Deploy Dinâmico com Helm:**
   - Refatoração da aplicação para Helm Charts customizados, permitindo deploys em diferentes ambientes apenas alterando os arquivos `values.yaml`.

---

## 🚀 Como Testar a API (via Insomnia/Postman)

A API está disponível publicamente com certificado SSL válido.
**Base URL:** `https://api.restapi-flask.xyz`

**Exemplo de Requisição (Criar Usuário):**
```http
POST /users
Content-Type: application/json

{
  "name": "Patrick Alves",
  "cpf": "123.456.789-00",
  "email": "patrick@example.com"
}
```

---

## ⚙️ Operação e CI/CD

### Deploy Automatizado via CI/CD (Em breve)
O pipeline está sendo evoluído para utilizar **GitHub Actions com AWS OIDC**. Isso garante que o runner do GitHub acesse a AWS sem a necessidade de chaves fixas de IAM (Access Keys), seguindo as melhores práticas de segurança de CI/CD.

### Operação Manual Rápida (Makefile)
```bash
# Sobe ambiente local completo (Kind + Helm + App)
make dev

# Deploy na AWS (Build -> Push ECR -> Helm Upgrade)
make aws-deploy
```

---

## 🤝 Contato

Desenvolvido por **Patrick Alves**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/patrickalvesdev/)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:patrick.devops@outlook.com)

*Focado em soluções Cloud Native, Automação e DevOps.*
