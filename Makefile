
S3_STATE_BUCKET_NAME=superalgos-terraform-state
S3_STATE_BUCKET_PLACEHOLDER=CHANGE-THE-BUCKET-NAME
TERRAFORM_CONFIG_FILE=terraform.tf


.PHONY: bootstrap comment-tfconfig uncomment-tfconfig diagrams test 


bootstrap:
	echo "bootstrap"


comment-tfconfig:
	@sed -i '/^terraform {/,/^}/s/^/#/' ${TERRAFORM_CONFIG_FILE}


uncomment-tfconfig:
	@sed -i '/^#terraform {/,/^#}/s/^#//' ${TERRAFORM_CONFIG_FILE}


diagrams:
	@python3 scripts/diagram.py -o design


init:
	@terraform init


test:
	$(MAKE) -C tests

