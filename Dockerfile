
# syntax=docker/dockerfile:1
FROM ubuntu:22.04
LABEL maintainer="GolovanovSV <golovanovsv@gmail.com>"

ENV VERSION 0.4.7.13

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN set -ex \
    && buildDeps="curl gcc make" \
    && libsDeps="libevent-dev libssl-dev zlib1g-dev obfs4proxy ca-certificates" \
    && apt-get update \
    && apt-get install --no-install-recommends -y $libsDeps \
    && apt-get install --no-install-recommends -y $buildDeps \
    && curl -s https://dist.torproject.org/tor-${VERSION}.tar.gz | tar -zx -C /tmp \
    && cd /tmp/tor-${VERSION} \
    && ./configure && make && make install \
    && cd / && rm -rf /tmp/tor-${VERSION} \
    && apt-get remove -y $buildDeps \
    && apt-get purge -y $buildDeps \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/local/bin/tor", "-f", "/etc/torrc"]
