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
Prepare the local configuration and credentials once from the committed examples:
```bash
make prepare LOGIN=your_login
```

The expected secret filenames are listed in `srcs/secrets.example/`. Edit `srcs/.env` if the default domain, database name, or usernames do not match your environment. These commands should only be run when the local files do not already exist.

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
Open the website at the `DOMAIN_NAME` configured in `srcs/.env`:
- https://YOUR_LOGIN.42.fr

The WordPress admin panel is available at:
- https://YOUR_LOGIN.42.fr/wp-admin

Adminer is available at:
- http://localhost:8081/adminer.php

cAdvisor is available at:
- http://localhost:8082

The static website is available at:
- http://localhost:8080

Port 80 is not used for public access. Adminer, cAdvisor, and the static website are local HTTP services.

## Credentials
Passwords are generated locally during setup, stored in the ignored files under `srcs/secrets/`, and mounted into the relevant containers as Docker secrets. The non-sensitive usernames, domain, and email settings are stored in `srcs/.env`.

For Adminer, use the MariaDB service name `mariadb` as the server, then use `DB_NAME` and `DB_USER` from `srcs/.env` and the database password from `srcs/secrets/db_password.txt`.

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