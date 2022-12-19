#!/usr/bin/env bash

set -e

export PACKAGE_NAME="unifi-blueberry-podman"
export VERSION="0.1.0"
export REVISION="1"
export ARCH="arm64"

DIR="${PACKAGE_NAME}_${VERSION}-${REVISION}_${ARCH}"

# create staging fir
mkdir $DIR

# copy package files
cp -r package/* $DIR/

# render control
envsubst < package/DEBIAN/control > $DIR/DEBIAN/control

# copy binaries
mkdir -p $DIR/usr/bin
mkdir -p $DIR/usr/libexec/podman

cp bin/podman* $DIR/usr/bin/
cp bin/rootlessport $DIR/usr/bin/
cp bin/runc $DIR/usr/bin/
cp bin/conmon $DIR/usr/libexec/podman/

# build
dpkg-deb --build --root-owner-group $DIR
