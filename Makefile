APP = rest-apii web

test:
	flake8 . --exclude .venv --max-line-length=88
	.venv/bin/pytest -v

compose:
	@docker compose build
	@docker compose up

heroku:
  @heroku container:login
  @heroku container:push -a $(APP) web
  @heroku container:release -a $(APP) web