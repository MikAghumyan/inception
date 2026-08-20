FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php php-mysqli wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN wget -O /var/www/html/adminer.php \
    https://www.adminer.org/latest.php

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/var/www/html"]