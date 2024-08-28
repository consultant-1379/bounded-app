#!/bin/bash

## source common functions ##
source ../../ISO/lib/utils.sh

## only create dockerfile ##
function create_dockerfile {
sed -e "s/TAG/$BASE_JAVA_CONTAINER_VERSION/g" Dockerfile.in > Dockerfile
}

main "$@"

