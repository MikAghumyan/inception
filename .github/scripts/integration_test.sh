#!/bin/bash

set -euo pipefail

# Run integration tests for the Inception project
# Test if nginx is serving the expected content
if ! curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 \
    --retry 5 --retry-delay 3 --fail \
    | grep -q "200"; then
  echo "Nginx not responding"
  exit 1
fi
# Test if WordPress is accessible
if ! curl -s http://localhost:8080 --retry 5 --retry-delay 3 --fail \
    | grep -q "WordPress"; then
  echo "WordPress test failed"
  exit 1
fi
# Test if Redis is running
if ! docker exec redis redis-cli ping | grep -q "PONG"; then
  echo "Redis test failed"
  exit 1
fi
# Test if FTP is accessible
if ! (echo QUIT | nc -w 2 localhost 21 | grep -q "220"); then
  echo "FTP test failed"
  exit 1
fi
# Test if Adminer is accessible
if ! curl -s http://localhost:8081 --retry 5 --retry-delay 3 --fail \
    | grep -q "Adminer"; then
  echo "Adminer test failed"
  exit 1
fi
# Test if cAdvisor is accessible
if ! curl -s http://localhost:8082 --retry 5 --retry-delay 3 --fail \
    | grep -q "cAdvisor"; then
  echo "cAdvisor test failed"
  exit 1
fi
# Test if MariaDB is running
if ! docker exec mariadb mysqladmin ping -h localhost -u root \
     --password="$(cat secrets/db_root_password.txt)" | grep -q "mysqld is alive"; then
  echo "MariaDB test failed"
  exit 1
fi