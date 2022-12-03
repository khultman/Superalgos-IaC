
S3_BUCKET_NAME=superalgos-terraform-state
S3_BUCKET_PLACEHOLDER=CHANGE-THE-BUCKET-NAME
TERRAFORM_CONFIG_FILE=terraform.tf


.PHONEY: init, comment-tfconfig, bootstrap, uncomment-tfconfig


init:
	@terraform init


comment-tfconfig:
	@sed '/^terraform {/,/^}/s/^/#/' ${TERRAFORM_CONFIG_FILE}


uncomment-tfconfig:
	@sed -i '/^#terraform {/,/^#}/s/^#//' ${TERRAFORM_CONFIG_FILE}
