FROM jmalloc/echo-server AS echo-server
FROM haproxytech/haproxy-consul-connect

COPY --from=echo-server /bin/echo-server /bin/echo-server
COPY /init.sh /

RUN apk add --no-cache curl && mkdir -p /consul/data /consul/myconfig && chmod +x /init.sh

ENTRYPOINT ["/init.sh", "echo-server"]
