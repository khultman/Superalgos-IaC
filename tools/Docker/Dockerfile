FROM alpine:latest

# Runtime arguments
ARG APP_DIR=/app
ARG ARCH
ARG BUILD_DATE
ARG IMAGE_NAME
ARG MAINTAINER
ARG SRC_DIR=.
ARG TERRAFORM_RELEASE

# Container Labels
LABEL maintainer=$MAINTAINER
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.name=$IMAGE_NAME
LABEL org.label-schema.version=$BUILD_VERSION

# Install basic requirements: curl, git, golang, make
RUN apk add --update --no-cache curl git gcc go make

# Install Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_RELEASE}/terraform_${TERRAFORM_RELEASE}_linux_${ARCH}.zip
RUN unzip terraform_${TERRAFORM_RELEASE}_linux_${ARCH}.zip
RUN mv terraform /usr/bin/terraform
