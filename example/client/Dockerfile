FROM haproxytech/haproxy-consul-connect

COPY /init.sh /

RUN apk add --no-cache curl && mkdir -p /consul/data /consul/myconfig && chmod +x /init.sh

ENTRYPOINT ["/init.sh", "client"]
