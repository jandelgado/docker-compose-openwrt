.PHONY: clean


DOCKER_COMPOSE_VER = 1.25.4
PYINSTALLER_VER = v3.6

BASE_TAG=jandelgado/docker-compose-openwrt

image.arm64v8: BASE = arm64v8/python:3.7-alpine3.11
image.arm64v8: TAG = arm64v8
image.arm64v8: dist/docker-compose-$(DOCKER_COMPOSE_VER)-arm64v8

image.arm32v7: BASE = arm32v7/python:3.7-alpine3.11
image.arm32v7: TAG = arm32v7
image.arm32v7: dist/docker-compose-$(DOCKER_COMPOSE_VER)-arm32v7

dist/docker-compose-%: Dockerfile
	docker run --rm --privileged multiarch/qemu-user-static:register --reset
	docker build --build-arg BASE="$(BASE)" \
				 --build-arg DOCKER_COMPOSE_VER="$(DOCKER_COMPOSE_VER)"\
				 --build-arg PYINSTALLER_VER="$(PYINSTALLER_VER)"\
				 -t "$(BASE_TAG)-linux-$(TAG)"  .
	docker run --rm -i $(BASE_TAG)-linux-$(TAG) tar cf - dist/  | tar xvf - 
	mv dist/docker-compose dist/docker-compose-$(DOCKER_COMPOSE_VER)-$(TAG)

clean:
	rm -f dist/*
