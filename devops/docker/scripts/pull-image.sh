#!/usr/bin/env bash
./devops/docker/scripts/login-to-registry.sh
source ./configs/deployment.env

docker pull $IMAGE_NAME
