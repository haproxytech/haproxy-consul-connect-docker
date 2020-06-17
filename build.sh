#!/bin/bash

DOCKER_TAG="haproxytech/haproxy-consul-connect"
CONSUL_CONNECT_GITHUB_URL="https://github.com/haproxytech/haproxy-consul-connect-docker/blob/master"
PUSH="no"
CONSUL_CONNECT_UPDATED=""

echo "Building HAProxy $i + Consul Connect"

DOCKERFILE="Dockerfile"
CONSUL_CONNECT_MINOR_OLD=$(awk '/^ENV CONSUL_CONNECT_MINOR/ {print $NF}' "$DOCKERFILE")

./update.sh

CONSUL_CONNECT_MINOR=$(awk '/^ENV CONSUL_CONNECT_MINOR/ {print $NF}' "$DOCKERFILE")

if [ "x$1" != "xforce" ]; then
    if [ "$CONSUL_CONNECT_MINOR_OLD" = "$CONSUL_CONNECT_MINOR" ]; then
        echo "No new releases, not building"
	exit 0
    fi
fi

PUSH="yes"

if [ \( "x$1" = "xtest" \) -o \( "x$2" = "xtest" \) ]; then
    docker pull $(awk '/^FROM/ {print $2}' "$DOCKERFILE")

    docker build -t "$DOCKER_TAG:$CONSUL_CONNECT_MINOR" . || \
        (echo "Failure building $DOCKER_TAG:$CONSUL_CONNECT_MINOR"; exit 1)
    docker tag "$DOCKER_TAG:$CONSUL_CONNECT_MINOR" "$DOCKER_TAG:latest"

    exit 0
fi

if git tag --list | egrep -q "^$CONSUL_CONNECT_MINOR$" >/dev/null 2>&1; then
    git tag -d "$CONSUL_CONNECT_MINOR" || true
    git push origin ":$CONSUL_CONNECT_MINOR" || true
fi
git commit -a -m "Automated commit triggered by $CONSUL_CONNECT_MINOR release(s)" || true
git tag "$CONSUL_CONNECT_MINOR"
git push origin "$CONSUL_CONNECT_MINOR"

if [ "$PUSH" = "no" ]; then
        exit 0
fi

echo -e "# Supported tags and respective \`Dockerfile\` links\n" > README.md
i=$(awk '/^ENV CONSUL_CONNECT_MINOR/ {print $NF}' Dockerfile| sort -n -r)
final="-\t[\`$i\`, \`latest\`]($CONSUL_CONNECT_GITHUB_URL/$short/Dockerfile)"
echo -e "$final" >> README.md
echo >> README.md
cat README_short.md >> README.md

git commit -a -m "README regen triggered by $CONSUL_CONNECT_MINOR release" || true
git push
