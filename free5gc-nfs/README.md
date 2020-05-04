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