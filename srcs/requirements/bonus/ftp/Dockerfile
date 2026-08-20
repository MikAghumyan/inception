FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    vsftpd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty \
    && chown root:root /var/run/vsftpd/empty \
    && chmod 755 /var/run/vsftpd/empty

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21

ENTRYPOINT [ "/entrypoint.sh" ]