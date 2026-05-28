APP = restapi-flask

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
	@kubectl apply -f kubernetes/manifests
	@kubectl rollout restart deploy restapi-flask

dev: setup-dev deploy-dev