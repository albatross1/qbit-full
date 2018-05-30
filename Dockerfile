FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN mkdir -p /home/qbittorrent && \
    groupadd -g 1000 qbittorrent && \
    useradd -g 1000 -u 1000 -d /home/qbittorrent qbittorrent && \
    su qbittorrent && \
    apt-get update -y && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable && \
    apt-get update -y && \
    apt-get install -y qbittorrent-nox && \
    apt-get install -y unrar && \
    mkdir -p /Downloads/temp && \
    ln -s /home/qbittorrent/.config/qBittorrent /config && \
    ln -s /home/qbittorrent/.local/share/data/qBittorrent /torrents && \
    ln -s /Downloads /qbit-downloads && \
    chown -R 1000:1000 /Downloads /home/qbittorrent && \
    chmod -R 2775 /Downloads /home/qbittorrent && \
    su qbittorrent -s /bin/sh -c 'qbittorrent-nox -v'

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chown -R 1000:1000 /entrypoint.sh && \
    chmod -R 0775 /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbit-downloads"]

USER 1000:1000

EXPOSE 8080 6881

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qbittorrent-nox"]
