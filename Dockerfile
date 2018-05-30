FROM ubuntu:xenial
MAINTAINER TheCreatorzOne

RUN mkdir -p /home/qbittorrent/.config/qBittorrent && \
    mkdir -p /home/qbittorrent/.local/share/data/qBittorrent && \
    mkdir -p /home/qbittorrent/Downloads && \
    mkdir -p /home/qbittorrent/Downloads-temp && \
    chown -R qbittorrent /home/qbittorrent && \
    ln -s /home/qbittorrent/.config/qBittorrent /config && \
    ln -s /home/qbittorrent/.local/share/data/qBittorrent /torrents && \
    ln -s /home/qbittorrent/Downloads /qbit-downloads && \
    ln -s /home/qbittorrent/Downloads-temp /qbit-downloads-temp && \
    chmod 0777 -R /home/qbittorrent /home/qbittorrent/Downloads /home/qbittorrent/Downloads-temp && \
    apt-get update -y && \
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
    su qbittorrent -s /bin/sh -c 'qbittorrent-nox -v'

ADD qBittorrent.conf /default/qBittorrent.conf
ADD entrypoint.sh /entrypoint.sh

RUN chmod -R 0777 /entrypoint.sh

VOLUME ["/config", "/torrents", "/qbit-downloads", "qbit-downloads-temp"]

EXPOSE 8080 6881

ENTRYPOINT ["/entrypoint.sh"]

CMD ["qbittorrent-nox"]
