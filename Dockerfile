FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN groupadd -g 1000 qbittorrent && \
    useradd -g 1000 -u 1000 -d /qbittorrent qbittorrent && \
    apt-get update -y && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable && \
    apt-get update -y && \
    apt-get install -y qbittorrent-nox && \
    apt-get install -y unrar && \
    chown -R qbittorrent:qbittorrent /qbittorrent && \
    mkdir -p /qbittorrent/.config/qBittorrent && \
    mkdir -p /qbittorrent/.local/share/data/qBittorrent && \
    ln -s /qbittorrent/.config/qBittorrent /config && \
    ln -s /qbittorrent/.local/share/data/qBittorrent /torrents && \
    mkdir -p /Downloads/temp && \
    ln -s /Downloads /qbit-downloads && \
    ln -s /Downloads/temp /qbit-downloads && \
    chown -R qbittorrent:qbittorrent /Downloads /Downloads/temp && \
    chmod -R 0775 /qbittorrent /Downloads /Downloads/temp

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chown -R qbittorrent:qbittorrent /entrypoint.sh && \
    chmod -R 0775 /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbit-downloads" "/qbit-downloads/temp"]

EXPOSE 8080 6881

USER qbittorrent

WORKDIR /qbittorrent

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qbittorrent-nox"]
