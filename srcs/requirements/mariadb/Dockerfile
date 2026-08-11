FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

COPY conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT [ "/init.sh" ]