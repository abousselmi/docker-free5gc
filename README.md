# Docker-free5gc
A docker image for the [Free5GC](https://www.free5gc.org) (stage 2) open source 5G Core Network.

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

## Functions Matrix

This table is created based on the default configuration files of Free5GC.

| Function | Exposed Ports | Dependencies | Dependencies URI (from default config files)           |
|----------|---------------|--------------|--------------------------------------------------------|
| AMF      | 29518         | NRF          | NRF: https://localhost:29510                           |
| AUSF     | 29509         | NRF          | NRF: https://localhost:29510                           |
| NRF      | 29510         | MONGODB      | MONGODB: mongodb://127.0.0.1:27017                     |
| NSSF     | 29531         | NRF          | NRF: http://free5gc-nrf:29510/nnrf-nfm/v1/nf-instances |
|          |               |              | NRF: http://free5gc-nrf:8081/nnrf-nfm/v1/nf-instances  |
| PCF      | 29507         | N/A          | N/A                                                    |
| SMF      | 29502         | PFCP         | PFCP: 10.200.200.1                                     |
|          |               | UPF          | UPF: 10.200.200.101                                    |
|          |               | NRF          | NRF: https://localhost:29510                           |
| UDM      | 29503         | UDR          | UDR client: 127.0.0.1:29504                            |
|          |               | NRF          | NRF client: 127.0.0.1:29510                            |
| UDR      | 29504         | MONGODB      | MONGODB: mongodb://localhost:27017                     |
|          |               | NRF          | NRF: https://localhost:29510                           |
| UPF      | N/A           | PFCP         | PFCP: 10.200.200.101                                   |
|          |               | GTPU         | GTPU: 10.200.200.102                                   |
|          |               | APN_LIST     | APN_LIST: 60.60.0.0/24                                 |
|          |               | APN          | APN: internet                                          |