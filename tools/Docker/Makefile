DOCKER_USER=khultman
DOCKER_NAME=terraform
DOCKER_IMAGE=$(DOCKER_USER)/$(DOCKER_NAME)

BUILD_DATE=$(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

ENV_VARS=.env

APP_SRC_DIR=$(PWD)/../..
APP_WRK_DIR=/opt

APP_HOST_PORT=8080
APP_CTNR_PORT=8080

ARCH=$(shell uname -m)

MAINTAINER=khultman@gmail.com

TERRAFORM_LATEST_RELEASE=$(shell curl -s "https://api.github.com/repos/hashicorp/terraform/releases/latest" |  grep tag_name | cut -d: -f2 | tr -d \"\,\v | sed 's/ //')
TERRAFORM_RELEASE=$(TERRAFORM_LATEST_RELEASE)

HOST_DOCKER_SOCK=/var/run/docker.sock
CTNR_DOCKER_SOCK=/var/run/docker.sock

HOST_SSH_KEYS=~/.ssh
CTNR_SSH_KEYS=/root/.ssh


.PHONY: all docker-build docker-run-interactive

all: docker-build docker-run-interactive

docker-build:
	@docker build --no-cache=true \
	              --build-arg APP_DIR=$(APP_WRK_DIR) \
				  --build-arg ARCH=$(ARCH) \
	              --build-arg BUILD_DATE=$(BUILD_DATE) \
	              --build-arg IMAGE_NAME=$(DOCKER_IMAGE) \
				  --build-arg MAINTAINER=$(MAINTAINER) \
	              --build-arg SRC_DIR=$(APP_SRC_DIR) \
				  --build-arg TERRAFORM_RELEASE=$(TERRAFORM_RELEASE) \
	              -t $(DOCKER_IMAGE):latest \
	              .


docker-push:
	@docker push $(DOCKER_IMAGE):latest


docker-run:
	@docker run --rm \
		-v ~/.ssh/:/root/.ssh \
		-p $(APP_HOST_PORT):$(APP_CTNR_PORT) \
		--name $(DOCKER_NAME) $(DOCKER_IMAGE):latest /bin/ash


docker-run-interactive:
	@if ! test -f $(ENV_VARS); then touch $(ENV_VARS); fi
	@docker \
		run \
		-it \
		--rm \
		--env-file=$(ENV_VARS) \
		-v $(HOST_SSH_KEYS):$(CTNR_SSH_KEYS) \
		-v $(HOST_DOCKER_SOCK):$(CTNR_DOCKER_SOCK) \
		-v $(APP_SRC_DIR):$(APP_WRK_DIR) \
		-p $(APP_HOST_PORT):$(APP_CTNR_PORT) \
		--name $(DOCKER_NAME) $(DOCKER_IMAGE):latest /bin/ash

