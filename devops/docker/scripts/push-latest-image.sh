#!/usr/bin/env bash

BLUE='\033[0;34m'
LBLUE='\033[1;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

source ./configs/deployment.env
source ./devops/ci/scripts/get-latest-version.sh

printf "${LBLUE}Check version and push if latest${NC}\n"

res=$(./devops/ci/scripts/pipeline-dependency.sh require build-and-push)

if ! $res; then
    printf "${RED}$res${NC}\n"
    printf "${LBLUE}Aborting${NC}\n"
    exit 0
fi

echo 'Checking versions...'

if [[ -r "./devops/version/latest" ]] ; then
    source "./devops/version/latest"

    compareRes=$(./devops/ci/scripts/semver.sh compare ${LATEST_VERSION} ${VERSION})

    if [[ $compareRes -lt 0 ]] ; then
        echo "LATEST_VERSION=${VERSION}" > ./devops/version/latest
        echo "LATEST_VERSION=${VERSION}"
        echo "Pushing latest image ..."
        docker tag ${IMAGE_NAME_BUILD}:${VERSION} ${IMAGE_NAME_BUILD}:latest
        docker push ${IMAGE_NAME_BUILD}:latest
        docker tag ${IMAGE_NAME_PROD}:${VERSION} ${IMAGE_NAME_PROD}:latest
        docker push ${IMAGE_NAME_PROD}:latest
    else
        echo "current VERSION=${VERSION}"
        echo "LATEST_VERSION=${LATEST_VERSION}"
        echo "LATEST_VERSION=${VERSION}" > ./devops/version/latest
        echo "no push needed"
    fi
else
    echo "saving latest version first time..."
    mkdir -p ./devops/version
    echo "LATEST_VERSION=${VERSION}"
    echo "LATEST_VERSION=${VERSION}" > ./devops/version/latest
    echo "Pushing latest image ..."
    docker tag ${IMAGE_NAME_BUILD}:${VERSION} ${IMAGE_NAME_BUILD}:latest
    docker push ${IMAGE_NAME_BUILD}:latest
    docker tag ${IMAGE_NAME_PROD}:${VERSION} ${IMAGE_NAME_PROD}:latest
    docker push ${IMAGE_NAME_PROD}:latest
fi

printf "${LBLUE}Done${NC}\n"
