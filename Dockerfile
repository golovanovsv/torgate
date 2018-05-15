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
    && ( cd /tmp/tor-${VERSION} \
        && ./configure \
        && make \
        && make install ) \
    && rm -rf /tmp/${VERSION} \
    && apt-get purge -y $buildDeps \
    && apt-get clean

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/tor", "-f", "/etc/torrc"]