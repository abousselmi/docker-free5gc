FROM golang:1.12.9-stretch AS builder

# Free5GC version
ENV F5GC_VERSION=v2.0.2

# Disable Go 1.11 Modules
ENV GO111MODULE=off

# Install dependencies
RUN DEBIAND_FRONTEND=noninteractive apt-get -y update \
    && apt-get install -y \
	git \
	gcc \
	cmake \
	autoconf \
	libtool \
	pkg-config \
	libmnl-dev \
	libyaml-dev

# Get Free5GC
RUN cd $GOPATH/src \
    && git clone https://bitbucket.org/free5GC/free5gc-stage-2.git free5gc \
    && cd $GOPATH/src/free5gc \
    && git checkout $F5GC_VERSION \
    && chmod +x ./install_env.sh \
    && ./install_env.sh \
    && tar -C $GOPATH -zxvf free5gc_libs.tar.gz

# Build Control Plane entities (AMF,AUSF,NRF,NSSF,PCF,SMF,UDM,UDR)
RUN cd $GOPATH/src/free5gc/src \
    && for d in * ; do if [ -f "$d/$d.go" ] ; then go build -o ../bin/"$d" -x "$d/$d.go" ; fi ; done ;

# Build User Plane Function (UPF) entity
RUN cd $GOPATH/src/free5gc/src/upf \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make -j `nproc`

FROM alpine

WORKDIR /free5gc
RUN mkdir -p config/ support/tls/

# Copy executables
COPY --from=builder /go/src/free5gc/bin/* ./
COPY --from=builder /go/src/free5gc/src/upf/build/bin/* ./

# Copy configuration files (not used for now)
COPY --from=builder /go/src/free5gc/config/* ./config/
COPY --from=builder /go/src/free5gc/src/upf/build/config/* ./config/

# Copy default certificates (not used for now)
COPY --from=builder /go/src/free5gc/support/TLS/* ./support/tls/

# Update upf executable name & harmonize config files extensions
RUN mv free5gc-upfd upf \
    && cd config \
    && for f in *.conf ; do mv -- "$f" "${f%.conf}.yaml"; done ;
