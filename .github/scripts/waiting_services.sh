#!/bin/bash

set -euo pipefail

# Run integration tests for the Inception project
for i in $(seq 1 30); do
  if [ "$(docker inspect -f '{{.State.Running}}' nginx 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' wordpress 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' redis 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' ftp 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' static_website 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' adminer 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' cadvisor 2>/dev/null)" = "true" ] && \
     [ "$(docker inspect -f '{{.State.Running}}' mariadb 2>/dev/null)" = "true" ]; then
    echo "All containers running"
    exit 0
  fi
  sleep 2
done
echo "Containers did not come up in time"
docker compose -f srcs/docker-compose.yml logs
exit 1