ARG CONSUL_MINOR=1.5.3

FROM consul:${CONSUL_MINOR} AS consul
FROM haproxytech/haproxy-alpine:2.1

MAINTAINER Dinko Korunic <dkorunic@haproxy.com>

ARG CONSUL_CONNECT_MINOR=0.9.0
ARG CONSUL_CONNECT_URL=https://github.com/haproxytech/haproxy-consul-connect/releases/download

ARG DATAPLANE_MINOR_CC=2.1.0
ARG DATAPLANE_SHA256_CC=15624a2e41f326b65ca977b1b6b840b14a265a8347f4a77775cf5d9a29b9fd06
ARG DATAPLANE_URL_CC=https://github.com/haproxytech/dataplaneapi/releases/download

ENV CONSUL_CONNECT_MINOR=${CONSUL_CONNECT_MINOR}
ENV CONSUL_CONNECT_URL=${CONSUL_CONNECT_URL}
ENV DATAPLANE_MINOR=${DATAPLANE_MINOR_CC}
ENV DATAPLANE_SHA256=${DATAPLANE_SHA256_CC}
ENV DATAPLANE_URL=${DATAPLANE_URL_CC}

COPY --from=consul /bin/consul /bin/consul

RUN apk add --no-cache --virtual build-deps curl && \
    curl -sfSL "${CONSUL_CONNECT_URL}/v${CONSUL_CONNECT_MINOR}/haproxy-consul-connect_${CONSUL_CONNECT_MINOR}_Linux_x86_64.tar.gz" -o haproxy-connect.tar.gz && \
    mkdir /tmp/consul_connect && \
    tar -xzf haproxy-connect.tar.gz -C /tmp/consul_connect && \
    rm -f haproxy-connect.tar.gz && \
    mv /tmp/consul_connect/haproxy-consul-connect /usr/local/bin/haproxy-connect && \
    chmod +x /usr/local/bin/haproxy-connect && \
    ln -s /usr/local/bin/haproxy-connect /usr/bin/haproxy-connect && \
    rm -rf /tmp/consul_connect && \
    curl -sfSL "${DATAPLANE_URL}/v${DATAPLANE_MINOR}/dataplaneapi_${DATAPLANE_MINOR}_Linux_x86_64.tar.gz" -o dataplane.tar.gz && \
    echo "$DATAPLANE_SHA256 *dataplane.tar.gz" | sha256sum -c - && \
    mkdir /tmp/dataplane && \
    tar -xzf dataplane.tar.gz -C /tmp/dataplane --strip-components=1 && \
    rm -f dataplane.tar.gz && \
    mv /tmp/dataplane/dataplaneapi /usr/local/bin/dataplaneapi && \
    chmod +x /usr/local/bin/dataplaneapi && \
    ln -sf /usr/local/bin/dataplaneapi /usr/bin/dataplaneapi && \
    rm -rf /tmp/dataplane && \
    apk del build-deps && \
    apk add --no-cache libc6-compat && \
    rm -f /var/cache/apk/*

COPY /docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy-connect"]
