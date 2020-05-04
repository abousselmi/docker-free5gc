## Free5GC UPF

This Dockerfile builds images for the user plane function `UPF`.

### Manual run example

```console
docker run -it --rm \
    --name upf \
    --privileged
    -v $PWD/config/:/free5gc/config \
    free5gc-upf-v2:v2.0.2
```