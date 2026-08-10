#!/bin/bash
set -e

WP_PATH=/var/www/html

mkdir -p "$WP_PATH"
mkdir -p /run/php

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    wp core download --path="$WP_PATH" --allow-root --force

    wp config create \
        --path="$WP_PATH" \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost="mariadb" \
        --allow-root
fi

echo "Waiting for MariaDB..."
until wp db check --path="$WP_PATH" --allow-root >/dev/null 2>&1; do
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

chown -R www-data:www-data "$WP_PATH"

exec php-fpm7.4 -F