FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

WORKDIR /qbittorrent

RUN useradd -m -d /qbittorrent qbittorrent && \
    apt-get update && \
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
    mkdir -p .config/qBittorrent && \
    mkdir -p .local/share/data/qBittorrent && \
    ln -s .config/qBittorrent /config && \
    ln -s .local/share/data/qBittorrent /torrents && \
    mkdir /Downloads && \
    mkdir /Downloads/temp && \
    ln -s /Downloads /qbittorrent/Downloads && \
    ln -s /Downloads/temp /qbittorrent/Downloads/temp && \
    chown -R 1000:1000 /qbittorrent && \
    chmod -R 4777 /qbittorrent

COPY qBittorrent.conf .config/qBittorrent/

USER qbittorrent

VOLUME ["/config", "/torrents", "/qbittorrent/Downloads"]

EXPOSE 8080
EXPOSE 6881

CMD ["qbittorrent-nox"]
