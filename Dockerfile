FROM alpine:3.15

RUN apk update && apk add \
    bash \
    ncurses \
    curl \
    jq \
    openssl \
    iptables \
    ip6tables \
    openvpn \
    wireguard-tools

# Install wireguard-go as a fallback if wireguard is not supported by the host OS or Linux kernel
#RUN apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing wireguard-go

# Modify wg-quick so it doesn't die without --privileged
# Set net.ipv4.conf.all.src_valid_mark=1 on container creation using --sysctl if required instead
# To avoid confusion, also suppress the error message that displays even when pre-set to 1 on container creation
#RUN sed -i 's/cmd sysctl.*/set +e \&\& sysctl -q net.ipv4.conf.all.src_valid_mark=1 \&> \/dev\/null \&\& set -e/' /usr/bin/wg-quick

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s CMD ping -I wg0 -c 1 www.google.com || exit 1

WORKDIR /pia
COPY . .

STOPSIGNAL SIGKILL

ENTRYPOINT echo -n "Waiting for network..."; until curl -s http://google.com >/dev/null; do echo -n "*"; sleep 5; done; echo "ready!"; ./run_setup.sh
#ENTRYPOINT while (true) do echo -n "*"; sleep 1; done;
