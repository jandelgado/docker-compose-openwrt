# docker-compose for OpenWrt (Rasperry Pi)

The other day, when I was experimenting with my new Raspberry Pi 4 and Docker,
running on OpenWrt, it turned out that
[docker-compose](https://docs.docker.com/compose/) would ease things a little. 

This project provides binaries for `docker-compose` targeted to run on
OpenWrt running on Raspberry Pi's (musl).

## Manual build 

```shell
$ make image.arm64v8    # for Raspi 4
$ make image.arm32v7    
```

Binaries will be copied to `/dist` folder.

## Download

Binary downloads are available on the
[Releases](https://github.com/jandelgado/docker-compose-openwrt/releases) page.

## License & Credits

License: MIT, Author: Jan Delgado, inspired by: 

* https://github.com/ubiquiti/docker-compose-aarch64
* https://github.com/docker/compose/blob/master/Dockerfile

