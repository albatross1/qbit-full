#!/bin/sh -e

# Default configuration file
if [ ! -f /config/qBittorrent.conf ]
then
	cp /default/qBittorrent.conf /config/qBittorrent.conf && \
	chown -R qbittorrent:qbittorrent /config /torrents /qbit-downloads && \
	chmod -R 0775 /config /torrents /qbit-downloads
fi

# Allow groups to change files.
umask 000

exec "$@"
