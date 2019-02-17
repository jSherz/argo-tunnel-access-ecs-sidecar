FROM debian:stretch-slim

RUN apt-get update && \
    apt-get dist-upgrade --yes && \
    apt-get install wget --yes && \
    wget https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb && \
    dpkg -i cloudflared-stable-linux-amd64.deb && \
    rm cloudflared-stable-linux-amd64.deb

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
ADD config.yml /etc/cloudflared/config.yml

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
