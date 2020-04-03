
.PHONY=image.arm32v7 image.arm64v8 image rall

BASE_TAG=jandelgado/docker-compose-openwrt

all: image.arm32v7 image.arm64v8

image.arm64v8: DOCKER_COMPOSE_VER = 1.25.4
image.arm64v8: BASE = arm64v8/python:3.7-alpine3.11
image.arm64v8: TAG = arm64v8
image.arm64v8: image

image.arm32v7: BASE = arm32v7/python:3.7-alpine
image.arm32v7: TAG= arm32v7
image.arm32v7: image

image: PYINSTALLER_VER = v3.6
image:
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker build --build-arg BASE="$(BASE)" \
		         --build-arg DOCKER_COMPOSE_VER="$(DOCKER_COMPOSE_VER)"\
		         --build-arg SIX_VER="$(SIX_VER)"\
		         --build-arg PYINSTALLER_VER="$(PYINSTALLER_VER)"\
		         -t "$(BASE_TAG)-linux-$(TAG)"  .
	mkdir -p dist
	docker run --rm -i $(BASE_TAG)-linux-$(TAG) tar cf - dist/  | tar xvf - 
