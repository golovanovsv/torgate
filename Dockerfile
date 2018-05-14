FROM debian:stretch-slim
MAINTAINER GolovanovSV <golovanovsv@gmail.com>

ENV VERSION 0.3.2.10

RUN set -ex \
    && buildDeps='libwww-perl build-essential libevent-dev libssl-dev zlib1g-dev wget python' \
    && additionalPkgs='zlib1g net-tools iptraf iproute2' \
    && apt-get update \
    && apt-get install -y $buildDeps \
    && apt-get install -y $additionalPkgs \
    && wget -qO - https://www.torproject.org/dist/tor-${VERSION}.tar.gz | tar xvz -C /tmp \
    && ( cd /tmp/${VERSION} \
        && ./configure \
        && make \
        && make install ) \
    && rm -rf /tmp/${VERSION} \
    && apt-get purge -y $buildDeps \
    && apt-get clean

RUN    echo ">> Common settings" \
    && echo "Log notice stdout" >> /etc/torrc \
    && echo "HeartbeatPeriod 30 minutes" >> /etc/torrc \
    && echo ">> Clients settings" \
    && echo "SocksPort 0.0.0.0:9150" >> /etc/torrc \
    && echo ">> Relay settings"
    && echo "ORPort 0.0.0.0:9100" >> /etc/torrc \
    && echo "ExitRelay 0" >> /etc/torrc

EXPOSE 9150 9100

CMD /usr/local/bin/tor -f /etc/torrc