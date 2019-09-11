#!/usr/bin/env bash

source ./configs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
docker run --name $CONTAINER_NAME \
           -p 80:80 \
           -v ${PWD}:/usr/src/web-app \
           -it $IMAGE_NAME:$VERSION bash
