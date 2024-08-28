#!/bin/bash

## source common code ##
source ../../ISO/lib/utils.sh

function prepare_image_build {
create_dockerfile $1
clean target
cp -f $ISO_DIR/target/models target/container_content
}

main "$@"
