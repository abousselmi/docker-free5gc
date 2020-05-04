# Docker-free5gc

A docker image for the [Free5GC](https://www.free5gc.org) ([stage 2](https://bitbucket.org/free5GC/free5gc-stage-2)) open source 5G Core Network.

> Note: This is yet a WIP

## Build

We start by building the `base` image which will be used to build `Free5GC` network functions for the control and the user planes by simply running the `build.sh` script.

```console
git clone https://github.com/abousselmi/docker-free5gc.git
cd docker-free5gc
export F5GC_VERSION=v2.0.2
./build.sh
```

> Note: this script was only tested for the version **v2.0.2**

> Note: the `build.sh` script could be removed in the future in favor of docker-compose build.

## Run

To run it, we use the docker compose file:

```console
docker-compose up
```

## Next steps

 - Create a CI/CD chain using docker hub or Travis
 - Create kubernetes resource descriptors
 - Create a chart to deploy on k8s using helm
 - Use weave.works router for networking

## Appendix A: Base image

The `base/Dockerfile` provides a multi-stage build. The build image
is based on the `Golang` docker image `golang:1.12.9-buster`.

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
│   ├── amfcfg.conf
│   ├── ausfcfg.conf
│   ├── free5GC.conf
│   ├── n3iwfcfg.conf
│   ├── nrfcfg.conf
│   ├── nssfcfg.conf
│   ├── pcfcfg.conf
│   ├── smfcfg.conf
│   ├── smfcfg.test.conf
│   ├── udmcfg.conf
│   ├── udrcfg.conf
│   ├── upfcfg.test.yaml
│   └── upfcfg.yaml
├── libgtpnl.so.0
├── liblogger.so
├── n3iwf
├── nrf
├── nssf
├── pcf
├── smf
├── support
│   └── TLS
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
├── upf
└── webui

3 directories, 45 files
```

## Appendix B: Functions Matrix

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
