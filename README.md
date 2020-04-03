# docker-compose for OpenWrt (raspi)

The other day when I was experimenting with my new Raspberry Pi 4 and docker
running on OpenWrt it turned out that
[docker-compose](https://docs.docker.com/compose/) would easy things a little. 

This project provides binaries for docker-compose targeted to run on
OpenWrt running on Raspberry Pi's (musl).

## Manual build 

```shell
$ make image.arm64v8    # for Raspi 4
$ make image.arm32v7    
```

Binaries will be copied to `/dist` folder.

## License & Credits

License: MIT
Author: Jan Delgado, inspired by: 

* https://github.com/ubiquiti/docker-compose-aarch64
* https://github.com/docker/compose/blob/master/Dockerfile


