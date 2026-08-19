COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env
DATA_DIR = $(HOME)/data
LOGIN ?= $(shell whoami)

all:
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --rmi all

fclean:
	$(COMPOSE) down -v --rmi all --remove-orphans
	@rm -rf $(DATA_DIR)/mariadb/* $(DATA_DIR)/wordpress/*

re:
	$(COMPOSE) down -v --rmi all
	$(COMPOSE) up -d --build

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

.PHONY: all down clean fclean re logs ps