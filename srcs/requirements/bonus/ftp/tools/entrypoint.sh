#!/bin/bash
set -e

FTP_USER="${FTPS_USER:-$FTP_USER}"
FTP_PASSWORD=$(cat /run/secrets/ftp_password)

# Create FTP user if not exists
if ! id "$FTP_USER" &>/dev/null; then
    useradd -d /var/www/wordpress -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
fi

exec vsftpd /etc/vsftpd.conf