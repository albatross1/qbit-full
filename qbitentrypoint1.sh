FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN useradd -m -d /qbittorrent qbittorrent && \
    apt-get update -y && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable && \
    apt-get update -y && \
    apt-get install -y qbittorrent-nox && \
    apt-get install -y unrar && \
    chown -R qbittorrent /qbittorrent && \
    mkdir -p /qbittorrent/.config/qBittorrent && \
    mkdir -p /qbittorrent/.local/share/data/qBittorrent && \
    ln -s /qbittorrent/.config/qBittorrent /config && \
    ln -s /qbittorrent/.local/share/data/qBittorrent /torrents && \
    mkdir -p /Downloads/temp && \
    ln -s /Downloads /qbit-downloads && \
    chown -R qbittorrent /Downloads /Downloads/temp && \
    chmod -R 2777 /qbittorrent /Downloads /Downloads/temp

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chown -R qbittorrent /entrypoint.sh && \
    chmod -R 0777 /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbit-downloads"]

EXPOSE 8080 6881

USER qbittorrent

WORKDIR /qbittorrent

ENTRYPOINT ["/qbitentrypoint2.sh"]

CMD ["qbittorrent-nox"]

exec "$@"
