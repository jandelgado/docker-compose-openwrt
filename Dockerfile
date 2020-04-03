# cross-compile docker-compose on x86_64 for aarch64
ARG BASE=arm64v8/python:3.6.5-alpine

# stage just used to provide qemu-*-static binaries.
FROM alpine:latest AS qemu-helper

ARG QEMU_ARCHS="aarch64 arm"
ARG QEMU_VERSION="3.0.0"

RUN apk update && apk add curl \
    && for i in ${QEMU_ARCHS}; do \
         curl -L https://github.com/multiarch/qemu-user-static/releases/download/v${QEMU_VERSION}/qemu-${i}-static.tar.gz \
            | tar zxvf - -C /usr/bin; \
       done \
    && chmod +x /usr/bin/qemu-*

#---------------------------------------------------------------------
FROM $BASE

#ARG DOCKER_COMPOSE_VER=1.25.4
ARG DOCKER_COMPOSE_VER=1.22.0
ARG PYINSTALLER_VER=v3.4
MAINTAINER "Jan Delgado <jdelgado@gmx.net>"

ENV LANG C.UTF-8

# needed for cross-building raspi images 
COPY --from=qemu-helper /usr/bin/qemu-aarch64-static /usr/bin/
COPY --from=qemu-helper /usr/bin/qemu-arm-static /usr/bin/

RUN apk --update --no-cache add \
    bash\
    openssl-dev\
    zlib-dev \
    musl-dev \
    libc-dev \
    libffi-dev \
    gcc \
    g++ \
    git \
    pwgen \
    make \
    && pip install --upgrade pip

# Build PyInstaller bootloader for alpine
RUN git clone --depth 1 --single-branch --branch ${PYINSTALLER_VER} \
        https://github.com/pyinstaller/pyinstaller.git /tmp/pyinstaller \
    && cd /tmp/pyinstaller/bootloader \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" python ./waf configure --no-lsb all \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" pip install .. \
    && rm -Rf /tmp/pyinstaller

WORKDIR /build/dockercompose
RUN git clone https://github.com/docker/compose.git . \
    && git checkout $DOCKER_COMPOSE_VER

# build docker-compose (taken from github.com/docker/compose/script/build/linux-entrypoint)
RUN mkdir -p ./dist \
    && CFLAGS="-Wno-stringop-overflow -Wno-stringop-truncation" pip install -q -r requirements.txt -r requirements-build.txt \
    && ./script/build/write-git-sha  > compose/GITSHA\
    && pyinstaller docker-compose.spec

