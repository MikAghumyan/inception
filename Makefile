COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env
DATA_DIR = $(HOME)/data

all:
	@mkdir -p $(DATA_DIR)/mariadb
	@mkdir -p $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --rmi all

re: clean all

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

.PHONY: all down clean re logs ps