#!/usr/bin/env bash
source ./configs/deployment.env

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
docker run --name $CONTAINER_NAME \
    -p 8000:80 \
    -it $IMAGE_NAME:$VERSION bash
