#!/usr/bin/env bash
set -e

if [[ -n "${IS_CI_RUNNER-}" ]] ; then
    echo 'skip loading project.env'
else
    source ./devops/local/scripts/load-env.sh
fi

source ./configs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh
source ./devops/docker/scripts/login-to-registry.sh
docker push $IMAGE_NAME_BUILD:$VERSION
docker push $IMAGE_NAME_PROD:$VERSION
