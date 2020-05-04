## Base docker image

This image is used to compile Free5GC and generate binaries for:

  - `AMF`
  - `SMF`
  - `NRF`
  - `AUSF`
  - `NSSF`
  - `PCF`
  - `UDM`
  - `UDR`
  - `N3IWF`
  - `UPF`
  - `WebUI`

The final image only contains:

  - Binaries
  - Default configuration files
  - Default tls certificates and keys

### Build Environment

  - OS: Ubunut buster
  - Golang: 1.12.9
  - gcc: 7