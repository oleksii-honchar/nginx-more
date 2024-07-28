SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

PROJECT_VERSION := $(shell yq -r '.version' project.yaml)
NGINX_VERSION := $(shell yq -r '.nginxVersion' project.yaml)
IMAGE_NAME := $(shell yq -r '.name' project.yaml)
IMAGE_VERSION := $(NGINX_VERSION)-$(PROJECT_VERSION)

ifneq (,$(wildcard ./.env))
	include ./.env
endif

.PHONY: help

help:
	@echo "nginx-reverse-proxy" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.ONESHELL:
check-project-env-vars:
	@bash ./.devops/local/scripts/check-project-env-vars.sh

logs: dockerComposeFile = ./docker-compose.yaml
logs: ## docker logs
	@docker compose -f $(dockerComposeFile) logs --follow

log: dockerComposeFile = ./docker-compose.yaml
log: ## docker log for svc=<docker service name>
	@docker compose -f $(dockerComposeFile) logs --follow ${svc}

up: dockerComposeFile = ./docker-compose.yaml
up:  ## docker up, or svc=<svc-name>
	@docker compose -f $(dockerComposeFile) up --build --remove-orphans -d ${svc}

down: dockerComposeFile = ./docker-compose.yaml
down:  ## docker down, or svc=<svc-name>
	@docker compose -f $(dockerComposeFile) down ${svc}

.ONESHELL:
restart: dockerComposeFile = ./docker-compose.yaml
restart:  ## restart all
	@docker compose -f $(dockerComposeFile) down
	@docker compose -f $(dockerComposeFile) up --build --remove-orphans -d
	@docker compose -f $(dockerComposeFile) logs --follow

exec-bash: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

# used for multi-platform builds
create-docker-container-builder:
	@docker buildx create --use --name docker-container --driver docker-container
	@docker buildx inspect docker-container --bootstrap

docker-build-n-push: dockerFile = ./Dockerfile
docker-build-n-push: ## build docker image for linux/amd64,linux/arm64
	@docker buildx build --builder docker-container \
		--platform linux/amd64,linux/arm64 \
		--force-rm=true --push \
		-f $(dockerFile) -t ${IMAGE_NAME}:$(IMAGE_VERSION) \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		.

docker-build: dockerFile = ./Dockerfile
docker-build: ## build docker image
	@docker build --force-rm=true --load \
		-f $(dockerFile) -t ${IMAGE_NAME}:$(IMAGE_VERSION) \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		--platform linux/arm64 .

docker-build-amd64-no-load: ## build docker amd64 image
	@docker build --force-rm=true \
		-f ./Dockerfile -t ${IMAGE_NAME}:$(IMAGE_VERSION) \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		--platform linux/amd64 .

docker-tag-latest: ## tag latest
	@docker tag ${IMAGE_NAME}:$(IMAGE_VERSION) ${IMAGE_NAME}:latest

docker-push: ## push images to registry
	@docker push docker.io/${IMAGE_NAME}:$(IMAGE_VERSION)
	@docker push docker.io/${IMAGE_NAME}:latest

release-please-debug: ## debug release-please config
	@release-please release-pr \
		--token=${GITHUB_TOKEN} \
		--repo-url=oleksii-honchar/nginx-more \
		--debug \
		--dry-run

release-please-snapshot: ## debug release-please config
	@release-please release-pr \
		--repo-url=oleksii-honchar/nginx-more \
		--token=${GITHUB_TOKEN} \
		--snapshot --dry-run