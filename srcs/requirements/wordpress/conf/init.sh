#!/bin/bash
set -e

WP_PATH=/var/www/html

DB_PASSWORD=$(cat /run/secrets/mariadb_user_password | tr -d '\n\r')
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password | tr -d '\n\r')
WP_ADMIN_PASSWORD=$(cat /run/secrets/wordpress_admin_password | tr -d '\n\r')
WP_USER_PASSWORD=$(cat /run/secrets/wordpress_user_password | tr -d '\n\r')

mkdir -p "$WP_PATH"
mkdir -p /run/php

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    wp core download --path="$WP_PATH" --allow-root --force

    wp config create \
        --path="$WP_PATH" \
        --dbname=$DB_NAME \
        --dbuser=$DB_USER \
        --dbpass=$DB_PASSWORD \
        --dbhost="mariadb" \
        --allow-root
fi

echo "Waiting for MariaDB..."
for attempt in $(seq 1 30); do
    if wp db check --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
        break
    fi
    if [ "$attempt" -eq 30 ]; then
        echo "MariaDB did not become ready in time" >&2
        exit 1
    fi
    sleep 5
done

if ! wp core is-installed --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    wp core install \
        --path="$WP_PATH" \
        --url="$DOMAIN_NAME" \
        --title=inception \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root
fi

if ! wp user get "$WP_USER" --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    wp user create "$WP_USER" "$WP_USER_EMAIL" \
        --role=editor \
        --user_pass="$WP_USER_PASSWORD" \
        --path="$WP_PATH" \
        --allow-root
fi

wp config set WP_CACHE true --raw --path="$WP_PATH" --allow-root
wp config set WP_REDIS_HOST redis --path="$WP_PATH" --allow-root
wp config set WP_REDIS_PORT 6379 --raw --path="$WP_PATH" --allow-root

if ! wp plugin is-installed redis-cache --path="$WP_PATH" --allow-root >/dev/null 2>&1; then
    wp plugin install redis-cache --activate --path="$WP_PATH" --allow-root
else
    wp plugin activate redis-cache --path="$WP_PATH" --allow-root >/dev/null 2>&1 || true
fi

wp redis enable --path="$WP_PATH" --allow-root >/dev/null 2>&1 || true

chown -R www-data:www-data "$WP_PATH"

exec php-fpm8.2 -F