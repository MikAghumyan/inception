# User Documentation

## Services
This stack provides:
- NGINX as the HTTPS reverse proxy on port 443.
- WordPress with php-fpm for the website and administration panel.
- MariaDB for the WordPress database.
- Redis for WordPress object caching.
- FTP access to the WordPress files.
- Adminer for database administration on port 8081.
- cAdvisor for container monitoring on port 8082.
- A static website on port 8080.

## Start and Stop
Start the project with:
```bash
make
```

Stop the containers with:
```bash
make down
```

Remove the stack, volumes, and images with:
```bash
make clean
```

## Access
Open the website at:
- https://maghumya.42.fr

The WordPress admin panel is available at:
- https://maghumya.42.fr/wp-admin

Adminer is available at:
- http://localhost:8081/adminer.php

cAdvisor is available at:
- http://localhost:8082

The static website is available at:
- http://localhost:8080

Port 80 is not used for public access. Adminer, cAdvisor, and the static website are local HTTP services.

## Credentials
Credentials are generated locally on the first `make` run. Passwords are stored in the ignored files under `srcs/secrets/` and mounted into the relevant containers as Docker secrets. The non-sensitive usernames, domain, and email settings are stored in `srcs/.env`.

For Adminer, use the MariaDB service name `mariadb` as the server, then use the database username, password, and database name from the corresponding files in `srcs/secrets/`.

## Basic Checks
To confirm the stack is healthy:
```bash
make ps
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
```

You can also verify the site in a browser and confirm that WordPress opens directly instead of the installation page.

For cAdvisor, confirm that the dashboard loads and that the metrics endpoint responds:
```bash
curl http://localhost:8082/metrics
```