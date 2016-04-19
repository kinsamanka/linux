#!/bin/bash -ex

DOCKER_IMAGE=machinekit/mk-builder:raspbian-armhf

# fetch the latest image
docker pull ${DOCKER_IMAGE}

# make sure we are in the root dir
cd "$(dirname "$(readlink -f $0)")/../"

# start build
docker run -v "$(pwd)":/opt/rootfs/work ${DOCKER_IMAGE} \
	proot-helper /work/.jenkins/build.sh

