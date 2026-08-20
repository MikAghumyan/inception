#!/bin/bash
set -e

DATA_DIR="/var/lib/mysql"

ROOT_PASSWORD=$(cat /run/secrets/mariadb_root_password | tr -d '\r\n')
USER_PASSWORD=$(cat /run/secrets/mariadb_user_password | tr -d '\r\n')

mkdir -p /run/mysqld "$DATA_DIR"
chown mysql:mysql /run/mysqld
chown -R mysql:mysql "$DATA_DIR"

# Initialize MariaDB system tables on first run
if [ ! -d "$DATA_DIR/mysql" ]; then
    mysql_install_db --user=mysql --datadir="$DATA_DIR"

    mysqld --user=mysql --bootstrap <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${ROOT_PASSWORD}';
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1');
FLUSH PRIVILEGES;
EOF
fi

# Start MariaDB temporarily
mysqld --user=mysql --skip-networking &
pid=$!

until mariadb-admin ping --silent >/dev/null 2>&1; do
    sleep 1
done

# Create database and application user
mariadb -uroot -p"$ROOT_PASSWORD" <<EOF
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;

CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${USER_PASSWORD}';

ALTER USER '${DB_USER}'@'%' IDENTIFIED BY '${USER_PASSWORD}';

GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';

FLUSH PRIVILEGES;
EOF

# Stop temporary MariaDB
mysqladmin -uroot -p"$ROOT_PASSWORD" shutdown
wait "$pid" || true

# Start MariaDB normally
exec mysqld --user=mysql