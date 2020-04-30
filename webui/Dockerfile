ARG F5GC_VERSION=v2.0.2
FROM free5gc-base-v2:${F5GC_VERSION} as builder

FROM ubuntu:18.04
ARG F5GC_VERSION=v2.0.2
ARG F5GC_MODULE

LABEL project="free5gc" \
    description="Free5GC open source 5G Core Network" \
    version="${F5GC_VERSION}" \
    module="${F5GC_MODULE}"

ENV F5GC_VERSION ${F5GC_VERSION}
ENV F5GC_MODULE ${F5GC_MODULE}

# Debug tools ~ 100MB (to be removed)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y vim strace net-tools iputils-ping curl

WORKDIR /free5gc
RUN mkdir -p ${F5GC_MODULE}/

# Copy executable and default configuration 
COPY --from=builder /free5gc/${F5GC_MODULE} ./${F5GC_MODULE}/

# Move to the executable location
WORKDIR /free5gc/${F5GC_MODULE}

# Config files volume
VOLUME [ "/free5gc/config" ]

# WebUI uses the port 5000
EXPOSE 5000

ENTRYPOINT [ "/bin/bash" ]
