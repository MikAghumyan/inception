# Developer Documentation

## Prerequisites
- Docker and Docker Compose.
- OpenSSL, used by the Makefile to generate local secrets.
- A Linux environment or virtual machine.
- Access to the repository root.

## Setup
The project keeps its configuration in `srcs/.env`.

Copy the configuration and secret examples before the first build. Replace `your_login` with the 42 login used in your domain:
```bash
make prepare LOGIN=your_login
```

Review `srcs/.env` before starting the stack. A plain `make` builds and starts the stack.

The expected secret filenames are shown in `srcs/secrets.example/`. The database name and username are configured through `DB_NAME` and `DB_USER` in `srcs/.env`. Do not commit the generated files in `srcs/secrets/`.

Data is persisted through the Docker named volumes mapped to:
- `$(HOME)/data/mariadb`
- `$(HOME)/data/wordpress`

The database and WordPress files are stored in the named Docker volumes `mariadb_data` and `wordpress_data`, backed by those host directories.

## Build and Launch
Build and start everything with:
```bash
make
```

Rebuild from a clean Docker state with:
```bash
make re
```

Stop the stack with:
```bash
make down
```

Remove containers, images, and volumes with:
```bash
make clean
```

Remove all data and containers with:
```bash
make fclean
```

## Useful Docker Commands
Inspect running services:
```bash
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
```

View logs:
```bash
docker compose -f srcs/docker-compose.yml --env-file srcs/.env logs -f
```

Check the service status:
```bash
make ps
```

Test Adminer:
```bash
curl -I http://localhost:8081/adminer.php
```

Test cAdvisor and its metrics endpoint:
```bash
curl -I http://localhost:8082
curl http://localhost:8082/metrics
```

List volumes:
```bash
docker volume ls
```

Inspect the persistent data location:
```bash
docker volume inspect srcs_wordpress_data
docker volume inspect srcs_mariadb_data
```

## Persistence
WordPress content and the MariaDB database survive container restarts because they are stored in named volumes. Re-running `make` should preserve the website content and database state as long as the volumes are kept.