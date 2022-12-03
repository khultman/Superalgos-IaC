
S3_BUCKET_NAME=superalgos-terraform-state
S3_BUCKET_PLACEHOLDER=CHANGE-THE-BUCKET-NAME
TERRAFORM_CONFIG_FILE=terraform.tf


.PHONEY: init, bootstrap


init:
	@terraform init


bootstrap:
	@sed '/^terraform {/,/^}/s/^/#/'  ${TERRAFORM_CONFIG_FILE}


