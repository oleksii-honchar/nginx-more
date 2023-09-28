SHELL=/bin/bash
RED=\033[0;31m
GREEN=\033[0;32m
BG_GREY=\033[48;5;237m
YELLOW=\033[38;5;202m
NC=\033[0m # No Color
BOLD_ON=\033[1m
BOLD_OFF=\033[21m
CLEAR=\033[2J

include ../../.devops/envs/deployment.env
include ../../project.env
export $(shell sed 's/=.*//' ../../project.env)
export $(shell sed 's/=.*//' ../../.devops/envs/deployment.env)
LATEST_VERSION := $(shell cat ../latest-version.txt)
export LATEST_VERSION=$(LATEST_VERSION)

.PHONY: help

help:
	@echo "nginx-reverse-proxy" automation commands:
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.ONESHELL:

logs: ## docker logs
	@docker compose -f ./docker-compose.yaml logs --follow

up:
	@docker compose -f ./docker-compose.yaml up --build --remove-orphans -d ${svc}

down:
	@docker compose -f ./docker-compose.yaml down ${svc}

.ONESHELL:
restart:
	@docker compose -f ./docker-compose.yaml down
	@docker compose -f ./docker-compose.yaml up --build --remove-orphans -d
	@docker compose -f ./docker-compose.yaml logs --follow

exec-sh: ## get shell for svc=<svc-name> container
	@docker exec -it ${svc} sh

test-nginx-config: ## get shell for svc=<svc-name> container
	@docker run -it ${IMAGE_NAME}:$(LATEST_VERSION) nginx -t