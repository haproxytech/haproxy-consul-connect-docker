FROM consul:latest AS consul
FROM haproxytech/haproxy-alpine:2.1

MAINTAINER Dinko Korunic <dkorunic@haproxy.com>

ENV CONSUL_CONNECT_MINOR 0.1.9
ENV CONSUL_CONNECT_URL https://github.com/haproxytech/haproxy-consul-connect/releases/download

ENV DATAPLANE_MINOR v1.2.5
ENV DATAPLANE_SHA256 0359966747490b55e6ea8c75a9b4969c707ce644dd8041ad8afb49882b97f3a1
ENV DATAPLANE_URL https://github.com/haproxytech/dataplaneapi/releases/download

COPY --from=consul /bin/consul /bin/consul

RUN apk add --no-cache --virtual build-deps curl && \
    curl -sfSL "${CONSUL_CONNECT_URL}/v${CONSUL_CONNECT_MINOR}/haproxy-connect.tar.gz" -o haproxy-connect.tar.gz && \
    mkdir /tmp/consul_connect && \
    tar -xzf haproxy-connect.tar.gz -C /tmp/consul_connect && \
    rm -f haproxy-connect.tar.gz && \
    mv /tmp/consul_connect/haproxy-connect /usr/local/bin/haproxy-connect && \
    chmod +x /usr/local/bin/haproxy-connect && \
    ln -s /usr/local/bin/haproxy-connect /usr/bin/haproxy-connect && \
    rm -rf /tmp/consul_connect && \
    curl -sfSL "$DATAPLANE_URL/$DATAPLANE_MINOR/dataplaneapi" -o dataplaneapi && \
    echo "$DATAPLANE_SHA256 *dataplaneapi" | sha256sum -c - && \
    mv dataplaneapi /usr/local/bin/dataplaneapi && \
    chmod +x /usr/local/bin/dataplaneapi && \
    ln -sf /usr/local/bin/dataplaneapi /usr/bin/dataplaneapi && \
    ln -sf /usr/local/bin/dataplaneapi /usr/local/bin/dataplane-api && \
    apk del build-deps && \
    apk add --no-cache libc6-compat && \
    rm -f /var/cache/apk/*

COPY /docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["haproxy-connect"]
