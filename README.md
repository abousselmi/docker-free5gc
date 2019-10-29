# Docker-free5gc
A docker image for the Free5GC (stage 2) open source 5G Core Network.

## Introduction

The `Dockerfile` provides a multi-stage build. The build image
is based on the `Golang` docker image `golang:1.12.9-stretch`.

The final image is an `ubuntu:18.04` docker image and contains
the Control and User Plane executables. You can find them in
`/root/free5gc`.

Ths directory should look like:

```shell
root@be8d807c8fe5:~/free5gc# tree    
.
|-- amf
|-- ausf
|-- config
|   |-- amfcfg.conf
|   |-- ausfcfg.conf
|   |-- free5GC.conf
|   |-- nrfcfg.conf
|   |-- nssfcfg.conf
|   |-- pcfcfg.conf
|   |-- smfcfg.conf
|   |-- udmcfg.conf
|   |-- udrcfg.conf
|   `-- upfcfg.yaml
|-- free5gc-upfd
|-- nrf
|-- nssf
|-- pcf
|-- smf
|-- testgtpv1
|-- udm
`-- udr
```

## Build docker image

To build the image, you can simply use:

```shell
docker build -t free5gc-s2:latest .
```