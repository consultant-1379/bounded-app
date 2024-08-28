#!/bin/bash

source ../../ISO/lib/utils.sh

## only build image ##
function build_image {
docker build --rm --no-cache -t $DOCKER_REPO/$(basename "$PWD"):$BASE_JAVA_CONTAINER_VERSION .
}

## only push image ##
function push_image {
docker push $DOCKER_REPO/$(basename "$PWD"):$BASE_JAVA_CONTAINER_VERSION
}

## overload sourced function create_dockerfile to do bellow ##
function create_dockerfile {
cp -f Dockerfile.in Dockerfile
}

main "$@"
