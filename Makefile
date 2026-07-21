COMPOSE = docker compose -f srcs/docker-compose.yml --env-file srcs/.env

all:
	@mkdir -p /home/maghumya/data/mariadb
	@mkdir -p /home/maghumya/data/wordpress
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

clean:
	$(COMPOSE) down -v -rmi all

re: clean all

.PHONY: all down clean re