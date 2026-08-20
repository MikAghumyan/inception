COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env
DATA_DIR = $(HOME)/data
LOGIN ?= $(shell whoami)

all: prepare
	@mkdir -p $(DATA_DIR)/mariadb $(DATA_DIR)/wordpress
	$(COMPOSE) up -d --build

prepare:
	@test -f srcs/.env || { cp srcs/.env.example srcs/.env; sed -i 's/YOUR_LOGIN/$(LOGIN)/g' srcs/.env; }
	@mkdir -p srcs/secrets
	@test -f srcs/secrets/db_root_password.txt || openssl rand -base64 32 > srcs/secrets/db_root_password.txt
	@test -f srcs/secrets/db_password.txt || openssl rand -base64 32 > srcs/secrets/db_password.txt
	@test -f srcs/secrets/wp_admin_password.txt || openssl rand -base64 32 > srcs/secrets/wp_admin_password.txt
	@test -f srcs/secrets/wp_user_password.txt || openssl rand -base64 32 > srcs/secrets/wp_user_password.txt
	@test -f srcs/secrets/ftp_password.txt || openssl rand -base64 32 > srcs/secrets/ftp_password.txt

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v --rmi all

fclean:
	$(COMPOSE) down -v --rmi all --remove-orphans
	@sudo rm -rf $(DATA_DIR)/mariadb/* $(DATA_DIR)/wordpress/*

re: fclean all

logs:
	$(COMPOSE) logs -f

ps:
	$(COMPOSE) ps

.PHONY: all prepare down clean fclean re logs ps