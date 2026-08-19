_This project has been created as part of the 42 curriculum by maghumya._

# Inception

## Description
Inception is a small Docker-based infrastructure made of NGINX, WordPress with php-fpm, MariaDB, Redis, FTP, Adminer, a static website, and cAdvisor. The stack is built from custom Dockerfiles, uses a dedicated network, and persists data through named volumes.

The main design choices are:
- One service per container.
- Docker Volumes vs Bind Mounts: the WordPress and MariaDB data use named Docker volumes backed by host directories under `$(HOME)/data`, while configuration is kept in the repository's local `.env` and secrets files.
- NGINX is the only public entrypoint on port 443 with TLSv1.2/TLSv1.3.
- WordPress and MariaDB keep their data on persistent volumes.
- Adminer provides database administration on port 8081.
- cAdvisor provides container metrics on port 8082.
- Secrets are generated locally at setup time, supplied to containers through Docker secrets, and ignored by Git.

Comparison notes:
- Virtual Machines vs Docker: VMs virtualize a full OS, while Docker shares the host kernel and starts faster with less overhead.
- Secrets vs Environment Variables: secrets are better for confidential data; environment variables are convenient for non-sensitive configuration.
- Docker Network vs Host Network: a Docker network isolates service-to-service traffic; host networking removes that isolation and was not used here.


## Instructions
1. Run `make` from the repository root.
2. The first run generates `srcs/.env` and local Docker secret files, then starts the stack. Use `make LOGIN=your_login` when your system username differs from your 42 login.
3. Open `https://maghumya.42.fr` in a browser.
4. Open `http://localhost:8081/adminer.php` for Adminer or `http://localhost:8082` for cAdvisor.
5. Use `make down` to stop the stack, `make re` to rebuild it, and `make ps` to inspect the containers.

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- WordPress CLI documentation: https://developer.wordpress.org/cli/commands/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- Adminer: https://www.adminer.org/
- cAdvisor: https://github.com/google/cadvisor

AI was used to help review the repository against the subject requirements, identify missing documentation, and suggest implementation details for the Docker entrypoint and startup checks. The final file contents and configuration changes were validated manually against the project rules.
