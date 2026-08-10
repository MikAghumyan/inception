# User Documentation

## Services
This stack provides:
- NGINX as the HTTPS reverse proxy on port 443.
- WordPress with php-fpm for the website and administration panel.
- MariaDB for the WordPress database.

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

Port 80 is not used for public access.

## Credentials
Credentials are generated locally on the first `make` run and stored in `srcs/.env`.

That file contains:
- MariaDB root and application credentials.
- WordPress administrator credentials.
- The WordPress editor account used for comments.

## Basic Checks
To confirm the stack is healthy:
```bash
make ps
docker compose -f srcs/docker-compose.yml --env-file srcs/.env ps
```

You can also verify the site in a browser and confirm that WordPress opens directly instead of the installation page.