FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-stable && apt-get update && \
    apt-get install -y unrar && \
    apt-get install -y qbittorrent && \
    useradd -m -d /qbittorrent-full qbittorrent && \
    chown -R qbittorrent /qbittorrent-full && \
    mkdir -p /qbittorrent-full/.config/qBittorrent && \
    mkdir -p /qbittorrent-full/.local/share/data/qBittorrent && \
    ln -s /qbittorrent-full/.config/qBittorrent /config && \
    ln -s /qbittorrent-full/.local/share/data/qBittorrent /torrents && \
    mkdir /downloads && \
    mkdir /downloads/temp && \
    ln -s /downloads /qbittorrent-full/Downloads && \
    ln -s /downloads/temp /qbittorrent-full/Downloads/temp && \
    chown -R qbittorrent /downloads /downloads/temp && \
    chmod 2777 -R /qbittorrent-full /downloads /downloads/temp

ENV XDG_CONFIG_HOME="/config"
ENV XDG_DATA_HOME="/downloads"

ADD qBittorrent.conf /config/qBittorrent.conf

VOLUME ["/config", "/torrents", "/qbittorrent-full/downloads"]

EXPOSE 8080
EXPOSE 6881

WORKDIR /qbittorrent-full

USER qbittorrent

CMD ["qbittorrent"]
