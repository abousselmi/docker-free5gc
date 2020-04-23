## Free5GC NFS

This is a generic Dockerfile to build images for multiple functions of the control and user planes.

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

UP function is:

 - `UPF`

### Utilities

Quick clean up of all free5gc docker images

```console
docker image ls | grep free | awk '{ print $3 }' | xargs docker rmi -f
```