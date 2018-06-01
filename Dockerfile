FROM binhex/arch-openvpn:latest
MAINTAINER binhex

# additional files
##################

# add supervisor conf file for app
ADD build/*.conf /etc/supervisor/conf.d/

# add bash scripts to install app
ADD root/build/root/*.sh /root/

# add bash script to setup iptables
ADD root/run/root/*.sh root/run/root/

RUN chmod +x root/run/root/*.sh RUN chmod +x root/run/root/*.sh root/run/home/nobody/*.sh root/run/home/nobody/*.py

VOLUME ["/config", "/data"]

ENTRYPOINT ["/qbitentrypoint1.sh"]

ENTRYPOINT ["/qbitentrypoint2.sh"]

EXPOSE 8080 6881 8118 58846 58946 58946/udp

CMD ["/bin/bash", "/root/init.sh"]
