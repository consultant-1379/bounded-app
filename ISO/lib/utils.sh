#!/bin/bash

USAGE_STRING="{init|create-dockerfile|build-image|build-and-push|push-image DROP VERSION}"
DOCKER_REPO="armdocker.rnd.ericsson.se/proj_enm"
BASE_JAVA_CONTAINER_VERSION="1.0.0"
BASE_DIR="../../"
ISO_DIR="$BASE_DIR/ISO"


## Calculate tag based on first two arguments
## example calculate_tag 16.13 1.28.29 returns 16.13-1.28.29
function calculate_tag {
echo "$1-$2"
}


function clean {
rm -rf $1 && mkdir $1
}


function download_iso_description {
local PACKAGE_URL="https://cifwk-oss.lmera.ericsson.se/ENM/$1/mediaContentJson/ERICenm_CXP9027091/$2/False/?_=1476176056480"
curl $PACKAGE_URL >> $ISO_DIR/target/media.json
}

function create_list_of_models_from_iso {
if [ ! -f $ISO_DIR/target/media.json ]; then
	echo "Unable to find information about ISO content, please run init goal first (you need to run it only once)."
	exit -1;
fi
$ISO_DIR/lib/create_model_list.py $1 >> $ISO_DIR/target/models
}

function init {
local DROP=$1
local VERSION=$2
download_iso_description $DROP $VERSION
create_list_of_models_from_iso $ISO_DIR/target/media.json
}

function create_sg_content {
if [ ! -f $ISO_DIR/target/media.json ]; then
	echo "Unable to find information about ISO content, please run init goal first (you need to run it only once)."
	exit -1;
fi
$ISO_DIR/lib/create_download_urls.py $ISO_DIR/target/media.json | grep "$(cat config/rpm_list)" >> target/container_content
}

## only create dockerfile ##
function create_dockerfile {
local DOCKER_TAG=$1
sed -e "s/TAG/$DOCKER_TAG/g" Dockerfile.in > Dockerfile
}

## only build image if sha has not changed ##
function build_image {
docker build --rm --no-cache -t $DOCKER_REPO/$(basename "$PWD"):$1 .
}

function prepare_image_build {
create_dockerfile $1
clean target
create_sg_content
}


## only push image ##
function push_image {
docker push $DOCKER_REPO/$(basename "$PWD"):$1
}

function validate_cmd_line_args {
if [[ -z "$1" ]] || [[ -z "$2" ]]; then
	echo "Please specify values for DROP and VERSION to be used in this build."
	echo $"Usage: $0 $USAGE_STRING"
	exit -1;
fi
}

function main {
## main starts here
case "$1" in
	init)
		local DROP=$2
		local VERSION=$3
		validate_cmd_line_args $DROP $VERSION
		clean  $ISO_DIR/target/
		init $DROP $VERSION
		RETVAL=$?
		;;
	create-dockerfile)
		local DROP=$2
		local VERSION=$3
		validate_cmd_line_args $DROP $VERSION
		DOCKER_TAG="$(calculate_tag $DROP $VERSION)"
		create_dockerfile $DOCKER_TAG
		RETVAL=$?
		;;
	build-image)
		local DROP=$2
		local VERSION=$3
		DOCKER_TAG=$(calculate_tag $DROP $VERSION)
		prepare_image_build $DOCKER_TAG
		build_image $DOCKER_TAG
		RETVAL=$?
		;;
	build-and-push)
		local DROP=$2
		local VERSION=$3
		DOCKER_TAG="$(calculate_tag $DROP $VERSION)"
		create_dockerfile $DOCKER_TAG
		clean target
		create_sg_content
		build_image $DOCKER_TAG
		RETVAL=$?
		;;
	push-image)
		local DROP=$2
		local VERSION=$3
		DOCKER_TAG="$(calculate_tag $DROP $VERSION)"
		push_image $DOCKER_TAG
		RETVAL=$?
		;;
	*)
		echo $"Usage: $0 $USAGE_STRING"
		RETVAL=2
		;;
esac
}
