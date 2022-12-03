
S3_STATE_BUCKET_NAME=superalgos-terraform-state
S3_STATE_BUCKET_PLACEHOLDER=CHANGE-THE-BUCKET-NAME
STATE_TERRAFORM_CONFIG_FILE=terraform.tf


.PHONY: bootstrap comment-state-tfconfig diagrams test  uncomment-state-tfconfig


bootstrap:
	echo "bootstrap"


comment-state-tfconfig:
	@sed -i '/^terraform {/,/^}/s/^/#/' ${STATE_TERRAFORM_CONFIG_FILE}


diagrams:
	@python3 scripts/diagram.py -o design


init:
	@terraform init


test:
	$(MAKE) -C tests


uncomment-state-tfconfig:
	@sed -i '/^#terraform {/,/^#}/s/^#//' ${STATE_TERRAFORM_CONFIG_FILE}
