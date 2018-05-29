FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN groupadd -g 1000 qbittorrent && \
    useradd -g 1000 -u 1000 -d /home/qbittorrent qbittorrent && \
    su qbittorrent && \
    apt-get update -y && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable && \
    apt-get update -y && \
    apt-get install -y qbittorrent && \
    apt-get install -y unrar && \
    mkdir -p /home/qbittorrent/Downloads && \
    mkdir -p /home/qbittorrent/Downloads-temp && \
    ln -s /home/qbittorrent/.config/qBittorrent /config && \
    ln -s /home/qbittorrent/.local/share/data/qBittorrent /torrents && \
    ln -s /home/qbittorrent/Downloads /qbit-downloads && \
    ln -s /home/qbittorrent/Downloads-temp /qbit-downloads-temp

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chown -R 1000:1000 /entrypoint.sh && \
    chmod -R 0775 /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbit-downloads", "qbit-downloads-temp"]

USER 1000:1000

EXPOSE 8080 6881

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qbittorrent"]
