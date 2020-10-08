#!/bin/sh
set -e

service_name="$1"

echo "Starting Consul Agent"
consul agent -bind=0.0.0.0 -data-dir=/consul/data -config-dir=/consul/myconfig -join consul-server &
sleep 5

echo "Waiting to connect to Consul http://127.0.0.1:8500/v1/catalog/service/${service_name}-sidecar-proxy"
while [ "$(curl --silent http://127.0.0.1:8500/v1/catalog/service/${service_name}-sidecar-proxy)" = "[]" ]; do
  sleep 2
done
echo "Connected."

echo "Starting HAProxy Consul Connect"
haproxy-connect -sidecar-for "$service_name" -dataplane /usr/local/bin/dataplaneapi -haproxy /usr/local/sbin/haproxy
