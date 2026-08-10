#!/bin/bash

# fail on unset variables and non-zero exit codes
set -eu

# fail fast if DOMAIN_NAME is not provided (use parameter expansion to avoid set -u error)
if [ -z "${DOMAIN_NAME:-}" ]; then
    echo "ERROR: DOMAIN_NAME is not set or is empty" >&2
    exit 1
fi

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=FR/ST=France/L=Paris/O=42/OU=mika/CN=${DOMAIN_NAME}" \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt

# substitute DOMAIN_NAME into the main nginx config (not conf.d fragments)
NGINX_CONF=${NGINX_CONF:-/etc/nginx/nginx.conf}
if [ -f "$NGINX_CONF" ]; then
    sed -i "s|DOMAIN_NAME|${DOMAIN_NAME}|g" "$NGINX_CONF"
else
    echo "ERROR: nginx config $NGINX_CONF not found" >&2
    exit 1
fi

exec "$@"