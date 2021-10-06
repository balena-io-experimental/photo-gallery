#!/bin/bash
set -e

function build_and_push_image () {
  local BALENA_ARCH=$1
  local DOCKER_ARCH=$2
  local TAG=$3

  echo "Building for arch name $BALENA_ARCH, platform $DOCKER_ARCH pushing to $DOCKER_REPO/$REPO_NAME"

  sed "s/%%BALENA_ARCH%%/$BALENA_ARCH/g" ./Dockerfile.template > ./Dockerfile.$BALENA_ARCH
  docker buildx build -t $DOCKER_REPO/$REPO_NAME:$TAG --platform $DOCKER_ARCH --file Dockerfile.$BALENA_ARCH .

  echo "Publishing..."
  docker push $DOCKER_REPO/$REPO_NAME:$TAG

  echo "Cleaning up..."
  rm Dockerfile.$BALENA_ARCH
}

# You can pass in a repo (such as a test docker repo) or accept the default
DOCKER_REPO=${1:-balenablocks}
REPO_NAME="photo-gallery"

if [ -z ${GITHUB_REF+x} ]; then
  TAG=latest
else
  TAG=$(echo "${GITHUB_REF}" | sed 's@^refs/\(.*\)/@\1@')
fi

build_and_push_image "aarch64" "linux/arm64" "$TAG"
# build_and_push_image "armv7hf" "linux/arm/v7"
# build_and_push_image "amd64" "linux/amd64"
# build_and_push_image "rpi" "linux/arm/v6"
