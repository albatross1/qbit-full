
#Clone of stockmind/docker-openvpn-arm
FROM ubuntu:xenial

#Clone and Building the image
docker build -f Dockerfile.arm -t stockmind/docker-openvpn-arm:latest . && \

#Name for the $OVPN_DATA data volume container. It's recommended to use the ovpn-data- prefix to operate seamlessly with the reference systemd service.
OVPN_DATA="ovpn-data-example" && \

#Initialize the $OVPN_DATA container that will hold the configuration files and certificates. The container will prompt for a passphrase to protect the private key used by the newly generated certificate authority.
docker volume create --name $OVPN_DATA && \
docker run -v $OVPN_DATA:/etc/openvpn --rm stockmind/docker-openvpn-arm ovpn_genconfig -u udp://VPN.SERVERNAME.COM && \
docker run -v $OVPN_DATA:/etc/openvpn --rm -it stockmind/docker-openvpn-arm ovpn_initpki && \

#Start OpenVPN server process
docker run -v $OVPN_DATA:/etc/openvpn -d -p 1194:1194/udp --cap-add=NET_ADMIN stockmind/docker-openvpn-arm && \

#Generate a client certificate without a passphrase
docker run -v $OVPN_DATA:/etc/openvpn --rm -it stockmind/docker-openvpn-arm easyrsa build-client-full CLIENTNAME nopass && \

#Retrieve the client configuration with embedded certificates
docker run -v $OVPN_DATA:/etc/openvpn --rm stockmind/docker-openvpn-arm ovpn_getclient CLIENTNAME > CLIENTNAME.ovpn && \
