#!/bin/bash

## source common functions ##
source ../../ISO/lib/utils.sh

## overload sourced function create_dockerfile to do bellow ##
function create_dockerfile {
cp -f Dockerfile.in Dockerfile
}

main "$@"
