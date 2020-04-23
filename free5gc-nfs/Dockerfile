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

WORKDIR /free5gc/${F5GC_MODULE}
RUN mkdir -p config/ log/ support/tls/

# Copy executable and default configuration 
COPY --from=builder /free5gc/${F5GC_MODULE} ./

# FIXME: config: since default config files can't be used as is,
#+ it's useless to include them in the final base image.
# FIXME: tls: not all modules use tls, which breaks the generic image
#+ generation loop.
# A quick fix is to include those files in the docker compose file.
#COPY --from=builder /free5gc/config/${F5GC_MODULE}cfg.conf ./config
#COPY --from=builder /free5gc/config/free5GC.conf ./config
#COPY --from=builder /free5gc/support/tls/${F5GC_MODULE}.pem ./support/tls/
#COPY --from=builder /free5gc/support/tls/${F5GC_MODULE}.key ./support/tls/

# The following volumes could be used for custom configuration
VOLUME [ "/free5gc/${F5GC_MODULE}/config" ]
VOLUME [ "/free5gc/${F5GC_MODULE}/log" ]
VOLUME [ "/free5gc/${F5GC_MODULE}/support/tls" ]

# FIXME: find a way to add exposed ports

ENTRYPOINT [ "/bin/bash" ]
