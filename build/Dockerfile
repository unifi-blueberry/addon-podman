ARG PACKAGE_VERSION

ARG PODMAN_VERSION="v4.3.1"
ARG CONMON_VERSION="v2.1.5"
ARG RUNC_VERSION="v1.1.4"

## podman build
##
FROM golang:1.18-stretch as builder-podman

ARG PODMAN_VERSION

RUN apt-get update && apt-get install -y \
      libglib2.0-dev \
      libgpg-error-dev \
      libprotobuf-dev \
      libprotobuf-c-dev \
      libseccomp-dev \
      libsystemd-dev \
      uidmap \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --branch ${PODMAN_VERSION} --depth 1 https://github.com/containers/podman.git

WORKDIR /build/podman

RUN make binaries \
     BUILDTAGS="exclude_graphdriver_devicemapper exclude_graphdriver_btrfs systemd seccomp containers_image_openpgp"

## conmon build
##
FROM debian:stretch as builder-conmon

ARG CONMON_VERSION

RUN apt-get update && apt-get install -y \
      git \
      gcc \
      make \
      pkg-config \
      libc6-dev \
      libglib2.0-dev \
      libseccomp-dev \
      libsystemd-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --branch ${CONMON_VERSION} --depth 1 https://github.com/containers/conmon.git

WORKDIR /build/conmon

RUN make bin/conmon

## runc build
##
FROM golang:1.18-stretch as builder-runc

ARG RUNC_VERSION

RUN apt-get update && apt-get install -y \
      libseccomp-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

RUN git clone --branch ${RUNC_VERSION} --depth 1 https://github.com/opencontainers/runc.git

WORKDIR /build/runc

RUN make

## package
##
FROM debian:bullseye as package

ARG PACKAGE_VERSION

RUN apt-get update && apt-get install -y \
      gettext \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY build/package.sh .
COPY build/packageroot packageroot/

COPY --from=builder-podman /build/podman/bin/* bin/
COPY --from=builder-conmon /build/conmon/bin/* bin/
COPY --from=builder-runc /build/runc/runc bin/

RUN sh package.sh

## artifact for export
##
FROM scratch as artifact

COPY --from=package /build/out/ /
