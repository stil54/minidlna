FROM debian:latest

MAINTAINER stil

RUN set -x \
        && apt-get update \
        && apt-get install -y --no-install-recommends minidlna \
        && echo "fs.inotify.max_user_watches = 100000" >> /etc/sysctl.conf \
        && apt-get clean \
        && rm -rf \
        && /tmp/* \
        && /var/lib/apt/lists/* \
        && /var/tmp/*

ADD minidlna.conf /etc/minidlna.conf

EXPOSE 1900/udp
EXPOSE 8200

ENTRYPOINT [ "/usr/sbin/minidlnad", "-S" ]
