APP = restapi

test: 
	@flake8 . --exclude .venv

compose:
	@docker compose build
	@docker compose up

heroku:
  @heroku container:login
  @heroku container:push -a rest-apii web
  @heroku container:release -a rest-apii web