ARG F5GC_VERSION=v2.0.2
FROM free5gc-base-v2:${F5GC_VERSION} as builder

# FIXME: a base image e.g. ubuntu-debug:18.04 should be used
#+ instead of installing debug tools for each created image.
#+ this slows down very much the build phase.
FROM ubuntu:18.04
ARG F5GC_VERSION=v2.0.2
ARG F5GC_MODULE

LABEL project="free5gc" \
    description="Free5GC open source 5G Core Network" \
    version="${F5GC_VERSION}" \
    module="${F5GC_MODULE}"

ENV F5GC_VERSION ${F5GC_VERSION}
ENV F5GC_MODULE ${F5GC_MODULE}

# Debug tools (to be removed)
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y vim strace net-tools curl

WORKDIR /free5gc
RUN mkdir -p config/ log/ support/TLS/ ${F5GC_MODULE}/

# Copy executable and default configuration 
COPY --from=builder /free5gc/${F5GC_MODULE} ./${F5GC_MODULE}/

# FIXME: config: since default config files can't be used as is,
#+ it's useless to include them in the final base image.
# FIXME: tls: not all modules use tls, which breaks the generic image
#+ generation loop.
# A quick fix is to include those files in the docker compose file.

# Config files volume
VOLUME [ "/free5gc/config" ]

# Logging volume
VOLUME [ "/free5gc/log" ]

# Certificates (if present) volume
VOLUME [ "/free5gc/support/TLS" ]

# FIXME: find a way to add exposed ports

# Move to the executable location
WORKDIR /free5gc/${F5GC_MODULE}

ENTRYPOINT [ "/bin/bash" ]
