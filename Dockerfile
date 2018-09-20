FROM debian:stretch-slim
MAINTAINER GolovanovSV <golovanovsv@gmail.com>

ENV VERSION 0.3.3.9

RUN set -ex \
    && buildDeps='curl gcc make' \
    && libsDeps='libevent-dev libssl-dev zlib1g-dev' \
    && apt-get update \
    && apt-get install -y $libsDeps \
    && apt-get install -y $buildDeps \
    && curl -s https://dist.torproject.org/tor-${VERSION}.tar.gz | tar -zx -C /tmp \
    && ( cd /tmp/tor-${VERSION} \
        && ./configure \
        && make \
        && make install ) \
    && rm -rf /tmp/tor-${VERSION} \
    && apt-get remove -y $buildDeps \
    && apt-get purge -y $buildDeps \
    && apt-get autoremove -y \
    && apt-get clean

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/tor", "-f", "/etc/torrc"]
