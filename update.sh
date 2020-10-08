#!/bin/bash
set -e

DOCKERFILE="Dockerfile"
CONSUL_CONNECT_URL="https://github.com/haproxytech/haproxy-consul-connect/releases/download"

if ! test -f "$DOCKERFILE"; then
	echo "Cannot find $DOCKERFILE"
	exit 1
fi

CONSUL_CONNECT_SRC_URL="https://api.github.com/repos/haproxytech/haproxy-consul-connect/releases/latest"
CONSUL_CONNECT_MINOR=$(curl -sfSL "$CONSUL_CONNECT_SRC_URL" | \
    grep '"tag_name":' | \
    sed -E 's/.*"v?([^"]+)".*/\1/')

if [ -z "${CONSUL_CONNECT_MINOR}" ]; then
    echo "Could not identify latest HAProxy Consul Connect release"
    exit 1
fi

sed -r -i -e "s!^(ARG CONSUL_CONNECT_URL=).*!\1${CONSUL_CONNECT_URL}!;
            s!^(ARG CONSUL_CONNECT_MINOR=).*!\1${CONSUL_CONNECT_MINOR}!;" \
            "$DOCKERFILE"
