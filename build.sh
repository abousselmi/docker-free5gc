#!/usr/bin/env bash

F5GC_GIT="https://bitbucket.org/free5GC/free5gc-stage-2.git"

RED='\e[0;31m'
GREEN='\e[0;32m'
MAGENTA='\e[0;35m'
NC='\e[0m'

function banner_echo {
    echo -e "${MAGENTA}$1${NC}"
}

function print_banner {
    banner_echo " ____             _               _____              ____   ____  ____ "
    banner_echo "|  _ \  ___   ___| | _____ _ __  |  ___| __ ___  ___| ___| / ___|/ ___|"
    banner_echo "| | | |/ _ \ / __| |/ / _ \ '__| | |_ | '__/ _ \/ _ \___ \| |  _| |    "
    banner_echo "| |_| | (_) | (__|   <  __/ |    |  _|| | |  __/  __/___) | |_| | |___ "
    banner_echo "|____/ \___/ \___|_|\_\___|_|    |_|  |_|  \___|\___|____/ \____|\____|"
    echo ""
}

function log {
    echo -e "🔥${GREEN} $(date +"%F %r")[INFO] $0 $1 ${NC}"
}

function logerr {
    echo -e "🔥${RED} $(date +"%F %r")[ERRO] $0 $1 ${NC}"
}

[[ -z "$F5GC_VERSION" ]] \
    && {
        logerr "F5GC_VERSION env var is not set";
        versions=$(git ls-remote --tags $F5GC_GIT | awk -F/ '{ print $3 }' | grep -v '{}' | tr '\n' ' ')
        logerr "available versions are: $versions"
        logerr "try: export F5GC_VERSION=v2.0.2"
        exit 1;
    }

function build_base {
    DOCKER_IMAGE="free5gc-base-v2:$F5GC_VERSION"
    IMG_CHECK=$(docker images -q $DOCKER_IMAGE)
    if [ "$IMG_CHECK" != "" ] ; then
        log "docker image '$DOCKER_IMAGE' is found locally, skipping build"
    else
        log "build 'base' image"
        docker build \
            --build-arg F5GC_VERSION=$F5GC_VERSION \
            -t $DOCKER_IMAGE \
            ./base > /dev/null
    fi
}

function build_nfs {
    # Build: amf ausf nrf nssf pcf smf udm udr n3iwf
    for module in amf ausf nrf nssf pcf smf udm udr n3iwf; do
        export F5GC_MODULE=$module

        DOCKER_IMAGE="free5gc-$F5GC_MODULE-v2:$F5GC_VERSION"
        IMG_CHECK=$(docker images -q $DOCKER_IMAGE)

        if [ "$IMG_CHECK" != "" ] ; then
            log "docker image '$DOCKER_IMAGE' is found locally, skipping build"
        else
            log "build image for function '$module'"
            docker build \
                --build-arg F5GC_VERSION=$F5GC_VERSION \
                --build-arg F5GC_MODULE=$F5GC_MODULE \
                -t $DOCKER_IMAGE \
                ./free5gc-nfs > /dev/null
        fi
    done
}

function build_upf {
    # Build upf
    export F5GC_MODULE="upf"

    DOCKER_IMAGE="free5gc-$F5GC_MODULE-v2:$F5GC_VERSION"
    IMG_CHECK=$(docker images -q $DOCKER_IMAGE)

    if [ "$IMG_CHECK" != "" ] ; then
        log "docker image '$DOCKER_IMAGE' is found locally, skipping build"
    else
        log "build image for module 'upf'"
        docker build \
            --build-arg F5GC_VERSION=$F5GC_VERSION \
            --build-arg F5GC_MODULE=$F5GC_MODULE \
            -t $DOCKER_IMAGE \
            ./upf > /dev/null
    fi
}

function build_webui {
    # Build webui
    export F5GC_MODULE="webui"

    DOCKER_IMAGE="free5gc-$F5GC_MODULE-v2:$F5GC_VERSION"
    IMG_CHECK=$(docker images -q $DOCKER_IMAGE)

    if [ "$IMG_CHECK" != "" ] ; then
        log "docker image '$DOCKER_IMAGE' is found locally, skipping build"
    else
        log "build image for module 'webui'"
        docker build \
            --build-arg F5GC_VERSION=$F5GC_VERSION \
            --build-arg F5GC_MODULE=$F5GC_MODULE \
            -t $DOCKER_IMAGE \
            ./webui > /dev/null
    fi
}

clear
print_banner

echo -e "Grab a coffee, this might take some time.."
start=`date +%s`

build_base
build_nfs
build_upf
build_webui

end=`date +%s`
duration=$((end-start))
log "completed in $duration seconds"
