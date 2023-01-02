FROM postgres:14

ENV TZ="America/Bogota"

RUN echo "deb http://deb.debian.org/debian bullseye-backports main" > /etc/apt/sources.list.d/backports.list \
    && apt-get update \
    && apt install -y cron rclone \
    && apt-get clean \
    && rm -rf /var/cache/apt/* \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /dump

ADD *.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["dump-cron"]