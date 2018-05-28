FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN apt-get update -y && \
    apt-get install -y build-essential && \
    apt-get install -y pkg-config && \
    apt-get install -y automake && \
    apt-get install -y libtool && \
    apt-get install -y git && \
    apt-get install -y libboost-dev && \
    apt-get install -y libboost-system-dev && \
    apt-get install -y libboost-chrono-dev && \
    apt-get install -y libboost-random-dev && \
    apt-get install -y libssl-dev && \
    apt-get install -y libgeoip-dev && \
    apt-get install -y qtbase5-dev && \
    apt-get install -y qttools5-dev-tools && \
    apt-get install -y libqt5svg5-dev && \
    apt-get install -y python3 && \
    apt-get install -y libtorrent-rasterbar-dev && \
    apt-get install -y unrar && \
    git clone https://github.com/arvidn/libtorrent.git && cd libtorrent && \
    git checkout $(git tag | grep libtorrent-1_0_ | sort -t _ -n -k 3 | tail -n 1) && \
    ./autotool.sh && \
    ./configure --disable-debug --enable-encryption --with-libgeoip=system CXXFLAGS=-std=c++11 && \
    make clean && make -j$(nproc) && make install && \
    git clone https://github.com/qbittorrent/qBittorrent && cd qBittorrent && \
    ./configure --disable-gui && \
    make && make install && \
    useradd -m -d /qbittorrent qbittorrent && \
    chown -R qbittorrent /qbittorrent && \
    mkdir -p /qbittorrent/.config/qBittorrent && \
    mkdir -p /qbittorrent/.local/share/data/qBittorrent && \
    mkdir -p /qbittorrent/Downloads/temp && \
    ln -s /qbittorrent/.config/qBittorrent /config && \
    ln -s /qbittorrent/.local/share/data/qBittorrent /torrents && \
    chown -R qbittorrent:qbittorrent /qbittorrent && \
    chmod -R 0775 /qbittorrent && \
    chmod -R 2775 /qbittorrent/Downloads /qbittorrent/Downloads/temp && \
    su qbittorrent -s /bin/sh -c 'qbittorrent-nox -v'

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chown -R qbittorrent:qbittorrent /entrypoint.sh && \
    chmod -R 0775 /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbittorrent/Downloads"]

WORKDIR /qbittorrent

USER qbittorrent

EXPOSE 8080 6881

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qbittorrent-nox"]
