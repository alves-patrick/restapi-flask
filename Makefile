APP = restapi-flask
AWS_ACCOUNT_ID ?= $(shell aws sts get-caller-identity --query 'Account' --output text 2>/dev/null || echo "142517507342")
ECR_IMAGE = $(AWS_ACCOUNT_ID).dkr.ecr.us-east-1.amazonaws.com/restapi-ecr:latest

help:
	@echo "Comandos disponíveis:"
	@echo "  --- LOCAL (Kind/Docker) ---"
	@echo "  make test          - Executa testes e linter"
	@echo "  make compose       - Sobe a infraestrutura com Docker Compose"
	@echo "  make setup-dev     - Configura cluster local (Kind)"
	@echo "  make deploy-dev    - Faz o build e deploy no cluster local (Kind)"
	@echo "  make dev           - Atalho para setup-dev + deploy-dev"
	@echo "  --- CLOUD (AWS EKS) ---"
	@echo "  make aws-push      - Build e Push da imagem para o ECR"
	@echo "  make aws-up        - Sobe TODA a infra (Terraform) e faz o Deploy (Helm)"
	@echo "  make aws-down      - Destrói apenas o que é caro (EKS/Nodes/ALB) para economizar"

test:
	flake8 . --exclude .venv --max-line-length=88
	pytest -v --disable-warnings

compose:
	@docker compose build
	@docker compose up

setup-dev:
	@kind create cluster --config kubernetes/config/config.yaml
	@kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
	@kubectl wait --namespace ingress-nginx \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=controller \
		--timeout=270s
	@helm repo add sealed-secrets https://bitnami-labs.github.io/sealed-secrets || true
	@helm repo update
	@helm upgrade --install sealed-secrets sealed-secrets/sealed-secrets --namespace kube-system
	@helm upgrade --install mongodb kubernetes/charts/mongodb --set auth.rootPassword="root"
	@kubectl wait \
		--for=condition=ready pod \
		--selector=app.kubernetes.io/component=mongodb \
		--timeout=270s

teardown-dev: 
	@kind delete clusters kind

deploy-dev:
	@docker build -t $(APP):latest .
	@kind load docker-image $(APP):latest
	@kubectl create secret generic mongodb-credentials \
		--from-literal=MONGODB_DB=users \
		--from-literal=MONGODB_HOST=mongodb \
		--from-literal=MONGODB_USERNAME=root \
		--from-literal=MONGODB_PASSWORD=root \
		--dry-run=client -o yaml | kubectl apply -f -
	@sed -i 's|image:.*|image: $(APP):latest|' kubernetes/manifests/20-deployment.yaml
	@kubectl apply -f kubernetes/manifests
	@kubectl rollout restart deploy restapi-flask

dev: setup-dev deploy-dev

aws-push:
	@aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(AWS_ACCOUNT_ID).dkr.ecr.us-east-1.amazonaws.com
	@docker build -t $(ECR_IMAGE) .
	@docker push $(ECR_IMAGE)

aws-up:
	@echo "🚀 Iniciando provisionamento da Infraestrutura..."
	@cd terraform && terraform apply -auto-approve
	@echo "✅ Infraestrutura pronta. Sincronizando credenciais..."
	@aws eks update-kubeconfig --region us-east-1 --name restapi-cluster
	@echo "📦 Fazendo push da imagem..."
	@make aws-push
	@echo "🚢 Fazendo deploy via Helm..."
	@helm upgrade --install mongodb kubernetes/charts/mongodb --set auth.rootPassword="root" --set persistence.storageClass="gp2"
	@helm upgrade --install restapi kubernetes/charts/restapi-flask
	@echo "✨ TUDO PRONTO! Acesse: https://api.restapi-flask.xyz/users"

aws-down:
	@echo "🛑 Destruindo recursos caros (EKS, Nodes, ALB)..."
	@cd terraform && terraform destroy -auto-approve \
		-target=module.kubernetes.module.eks_managed_node_group \
		-target=module.kubernetes.module.eks_cluster \
		-target=module.kubernetes.module.eks_add_ons.helm_release.eks_helm_controller
	@echo "📉 Economia ativada! VPC e DNS mantidos."
