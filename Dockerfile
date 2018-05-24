FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:qbittorrent-team/qbittorrent-unstable && \
    apt-get update -y && \
    apt-get install -y unrar && \
    apt-get install -y qbittorrent && \
    addgroup --gid 1000 qbittorrent && \
    adduser --uid 1000 --gid 1000 qbittorrent && \
    mkdir -p /home/qbittorrent/Downloads/temp && \
    mkdir -p /qbittorrent/Downloads/temp && \
    chown 1000:1000 -R /home/qbittorrent /home/qbittorrent/Downloads && \
    chmod a+rwx -R /home/qbittorrent /home/qbittorrent/Downloads && \
    ln -s /home/qbittorrent/.config/qBittorrent /config && \
    ln -s /home/qbittorrent/.local/share/data/qBittorrent /torrents && \
    ln -s /home/qbittorrent/Downloads /qbittorrent/Downloads && \
    ln -s /home/qbittorrent/Downloads/temp /qbittorrent/Downloads/temp

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chown 1000:1000 -R /entrypoint.sh && \
    chmod a+rwx -R /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbittorrent/Downloads"]

ENV HOME=/home/qbittorrent

USER qbittorrent

EXPOSE 8080 6881

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qbittorrent"]
