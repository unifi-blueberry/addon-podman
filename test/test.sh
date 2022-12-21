#!/usr/bin/env bash

set -e

clean_up () {
    ARG=$?
    echo "cleaning up..."
    docker rm -f podman-test

    exit $ARG
}
trap clean_up EXIT

# start test container
echo "staring test container"
docker run -d --name podman-test --tty debian

# copy and install podman package
echo "installing podman package"
docker cp "$1" podman-test:/tmp/podman.deb
docker exec podman-test dpkg -i /tmp/podman.deb

# run a container
docker exec podman-test podman run --rm
