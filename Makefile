SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

include ./configs/envs/deployment.env
include project.env
export $(shell sed 's/=.*//' project.env)
export $(shell sed 's/=.*//' ./configs/envs/deployment.env)

.PHONY: help

help:
	@echo "nginx-reverse-proxy" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.ONESHELL:
check-project-env-vars:
	@bash ./devops/local/scripts/check-project-env-vars.sh

logs: dockerComposeFile = ./docker-compose.yaml
logs: ## docker logs
	@docker compose -f $(dockerComposeFile) logs --follow

log: dockerComposeFile = ./docker-compose.yaml
log: ## docker log for svc=<docker service name>
	@docker compose -f $(dockerComposeFile) logs --follow ${svc}

up: dockerComposeFile = ./docker-compose.yaml
up: check-project-env-vars ## docker up, or svc=<svc-name>
	@docker compose -f $(dockerComposeFile) up --build --remove-orphans -d ${svc}

down: dockerComposeFile = ./docker-compose.yaml
down: check-project-env-vars ## docker down, or svc=<svc-name>
	@docker compose -f $(dockerComposeFile) down ${svc}

.ONESHELL:
restart: dockerComposeFile = ./docker-compose.yaml
restart: check-project-env-vars ## restart all
	@docker compose -f $(dockerComposeFile) down
	@docker compose -f $(dockerComposeFile) up --build --remove-orphans -d
	@docker compose -f $(dockerComposeFile) logs --follow

exec-bash: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} bash

exec-sh: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

build: dockerFile = ./Dockerfile
build: check-project-env-vars
	@docker build --force-rm=true --load \
		-f $(dockerFile) -t ${IMAGE_NAME}:${IMAGE_TAG} \
		--build-arg NGINX_VERSION=${NGINX_VERSION} \
		--platform linux/arm64 .

tag-latest: check-project-env-vars
	@docker tag ${IMAGE_NAME}:${IMAGE_TAG} tuiteraz/squid:latest

push: check-project-env-vars
	@docker push docker.io/${IMAGE_NAME}:${IMAGE_TAG}
	@docker push docker.io/${IMAGE_NAME}:latest