_This project has been created as part of the 42 curriculum by maghumya._

# Inception

## Description
Inception is a small Docker-based infrastructure made of NGINX, WordPress with php-fpm, and MariaDB. The stack is built from custom Dockerfiles, uses a dedicated network, and persists data through named volumes.

The main design choices are:
- One service per container.- Docker Volumes vs Bind Mounts: volumes are managed by Docker and are preferred here for persistence; bind mounts are avoided for the project data.
- NGINX is the only public entrypoint on port 443 with TLSv1.2/TLSv1.3.
- WordPress and MariaDB keep their data on persistent volumes.
- Secrets are generated locally at setup time instead of being stored in the repository.

Comparison notes:
- Virtual Machines vs Docker: VMs virtualize a full OS, while Docker shares the host kernel and starts faster with less overhead.
- Secrets vs Environment Variables: secrets are better for confidential data; environment variables are convenient for non-sensitive configuration.
- Docker Network vs Host Network: a Docker network isolates service-to-service traffic; host networking removes that isolation and was not used here.


## Instructions
1. Run `make` from the repository root.
2. The first run generates `srcs/.env` locally with passwords and starts the stack.
3. Open `https://maghumya.42.fr` in a browser.
4. Use `make down` to stop the stack, `make re` to rebuild it, and `make ps` to inspect the containers.

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- NGINX documentation: https://nginx.org/en/docs/
- WordPress CLI documentation: https://developer.wordpress.org/cli/commands/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/

AI was used to help review the repository against the subject requirements, identify missing documentation, and suggest implementation details for the Docker entrypoint and startup checks. The final file contents and configuration changes were validated manually against the project rules.
