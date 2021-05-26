app_name = postgres

build:
	@docker build --pull --rm -f "Dockerfile" -t $(app_name):latest "."

run:
	@docker run -p 5432:5432 $(app_name)

kill:
	@echo 'Killing container...'
	@docker ps | grep $(app_name) | awk '{print $$1}' | xargs docker