FROM binhex/arch-openvpn:latest
MAINTAINER binhex

# additional files
##################

# add supervisor conf file for app
ADD build/*.conf /etc/supervisor/conf.d/

# add bash scripts to install app
ADD build/root/*.sh /root/

# add bash script to setup iptables
ADD run/root/*.sh /root/

RUN chmod +x /root/*.sh RUN chmod +x /root/*.sh /home/nobody/*.sh /home/nobody/*.py

CMD ["/bin/bash", "/root/init.sh"]
