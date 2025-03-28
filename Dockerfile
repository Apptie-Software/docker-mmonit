FROM alpine:3.21

# Environment
ENV \
  MMONIT_PORT=8080 \
  MMONIT_DOMAIN= \
  MMONIT_URL="https://${MMONIT_DOMAIN}" \
  MMONIT_VERSION="4.3.4" \
  MMONIT_OS="alpine" \
  MMONIT_ARCH="x64" \
  MMONIT_DATABASE_URL="sqlite:///db/mmonit.db?synchronous=normal&foreign_keys=on&journal_mode=wal&temp_store=memory&cache_size=-20000&mmap_size=20971520" \
  MMONIT_LICENSE_OWNER="you" \
  MMONIT_LICENSE_KEY="yours" \
  TZ=UTC

# copy config files
COPY ./conf/* /opt/mmonit-${MMONIT_VERSION}/conf/

# install M/Monit
RUN set -x\
  && apk add --no-cache --virtual mybuild \
  build-base \
  && apk add --no-cache \
  openssl-dev \
  lm-sensors \
  libltdl \
  zlib-dev \
  ca-certificates \
  tzdata \
  findmnt \
  && cd /tmp \
  && wget "https://mmonit.com/dist/mmonit-${MMONIT_VERSION}-${MMONIT_OS}-${MMONIT_ARCH}.tar.gz" \
  && tar -zxvf "mmonit-${MMONIT_VERSION}-${MMONIT_OS}-${MMONIT_ARCH}.tar.gz" \
  && cp -r "mmonit-${MMONIT_VERSION}" "/opt/" \
  && cd \
  && rm -rf /tmp/* \
  && apk del mybuild

EXPOSE ${MMONIT_PORT}

VOLUME /opt/mmonit-${MMONIT_VERSION}/conf

HEALTHCHECK --start-period=300s --interval=30s --timeout=30s --retries=3 CMD ["ping", "localhost:8080"] || exit 1

CMD ["/opt/mmonit-${MMONIT_VERSION}/bin/mmonit", "-i"]
