# Docker-free5gc
A docker image for the [Free5GC](https://www.free5gc.org) (stage 2) open source 5G Core Network.

## Introduction

The `Dockerfile` provides a multi-stage build. The build image
is based on the `Golang` docker image `golang:1.12.9-stretch`.

The final image is an `alpine` docker image and contains
the Control and User Plane executables. You can find them under
`/free5gc`.

This directory should look like:

```shell
/free5gc # apk add -U tree
/free5gc # tree 
.
├── amf
├── ausf
├── config
│   ├── amfcfg.yaml
│   ├── ausfcfg.yaml
│   ├── free5GC.yaml
│   ├── n3iwfcfg.yaml
│   ├── nrfcfg.yaml
│   ├── nssfcfg.yaml
│   ├── pcfcfg.yaml
│   ├── smfcfg.test.yaml
│   ├── smfcfg.yaml
│   ├── udmcfg.yaml
│   ├── udrcfg.yaml
│   ├── upfcfg.test.yaml
│   └── upfcfg.yaml
├── n3iwf
├── nrf
├── nssf
├── pcf
├── smf
├── support
│   └── tls
│       ├── _debug.key
│       ├── _debug.pem
│       ├── amf.key
│       ├── amf.pem
│       ├── ausf.key
│       ├── ausf.pem
│       ├── nrf.key
│       ├── nrf.pem
│       ├── nssf.key
│       ├── nssf.pem
│       ├── pcf.key
│       ├── pcf.pem
│       ├── smf.key
│       ├── smf.pem
│       ├── udm.key
│       ├── udm.pem
│       ├── udr.key
│       └── udr.pem
├── testgtpv1
├── udm
├── udr
└── upf

3 directories, 42 files
```

## Build docker images

### Base image
We start by building the `base` image. This image is used to build different executables from source.

```shell
export F5GC_VERSION=v2.0.2
docker build -t free5gc-base-v2:$F5GC_VERSION ./base
```

### Control and User plane functions

Then you can build all the modules by simply running the `build.sh` script:

```shell
export F5GC_VERSION=v2.0.2
./build.sh
```

## Next steps

 - Create a CI/CD chain using docker hub or Travis
 - Create kubernetes resource descriptors
 - Create a chart to deploy on k8s using helm
 - Use weave.works router for networking

 ## Appendix A: Functions Matrix

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
