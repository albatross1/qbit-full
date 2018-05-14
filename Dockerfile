FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN useradd -m -d /qbittorrent-full qbittorrent && \
    chown -R qbittorrent /qbittorrent-full && \
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
    apt-get install -y python 3 && \
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
    mkdir -p /qbittorrent-full/.config/qBittorrent && \
    mkdir -p /qbittorrent-full/.local/share/data/qBittorrent && \
    ln -s /qbittorrent-full/.config/qBittorrent /config && \
    ln -s /qbittorrent-full/.local/share/data/qBittorrent /torrents && \
    mkdir /Downloads && \
    mkdir /Downloads/temp && \
    ln -s /Downloads /qbittorrent-full/Downloads && \
    ln -s /Downloads/temp /qbittorrent-full/Downloads/temp && \
    chown -R qbittorrent /Downloads /Downloads/temp && \
    chmod 2777 -R /qbittorrent-full /Downloads /Downloads/temp

ADD qBittorrent.conf /qbittorrent-full/.config/qBittorrent/qBittorrent.conf

VOLUME ["/config", "/torrents", "/qbittorrent-full/downloads"]

EXPOSE 8080
EXPOSE 6881

WORKDIR /qbittorrent-full

USER qbittorrent

CMD ["qbittorrent-nox"]
