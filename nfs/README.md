## Free5GC NFs

This is a generic Dockerfile to build images for multiple functions of the control plane.

CP functions are: 

 - `AMF`
 - `AUSF`
 - `NRF`
 - `NSSF`
 - `PCF`
 - `SMF`
 - `UDM`
 - `UDR`
 - `N3IWF`

### Utilities

Quick clean up of all free5gc docker images

```console
docker image ls | grep free | awk '{ print $3 }' | xargs docker rmi -f
```

### Manual run examples

#### UDR

```console
docker run -it --rm \
    --name udr \
    -v $PWD/config/:/free5gc/config \
    -v $PWD/tls:/free5gc/support/TLS \
    free5gc-udr-v2:v2.0.2
```

#### WebUI

```console
docker run -it --rm \
    --name webui \
    -v $PWD/config/:/free5gc/config \
    -p 5000:5000 \
    free5gc-webui-v2:v2.0.2 -c ./webui --webuicfg ./config/webuicfg.conf
```

The webui uses the UDR configuration file to extract mongodb host:port info. To make it use the new webuicfg.conf, the code is patched when building the binary (see base/Dockerfile).

#### NRF

```console
docker run -it --rm \
    --name nrf \
    -v $PWD/config/:/free5gc/config \
    -v $PWD/tls:/free5gc/support/TLS \
    free5gc-nrf-v2:v2.0.2 -c ./nrf
```

#### AMF

```console
docker run -it --rm \
    --name amf \
    -v $PWD/config/:/free5gc/config \
    -v $PWD/tls:/free5gc/support/TLS \
    free5gc-amf-v2:v2.0.2 -c ./amf
```
