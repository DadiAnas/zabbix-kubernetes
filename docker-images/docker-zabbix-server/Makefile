app_name = zabbix_server

build:
	@docker build --pull --rm -f "Dockerfile" -t $(app_name):latest "." --build-arg DBHost=10.242.148.80

run:
	@docker run -p 10050:10050 $(app_name)

kill:
	@echo 'Killing container...'
	@docker ps | grep $(app_name) | awk '{print $$1}' | xargs docker