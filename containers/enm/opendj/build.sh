#!/bin/bash

## source common code ##
source ../../ISO/lib/utils.sh

## overload sourced functon create_dockerfile ##
function create_dockerfile {
sed -e "s/TAG/$BASE_JAVA_CONTAINER_VERSION/g" Dockerfile.in > Dockerfile
}

main "$@"

