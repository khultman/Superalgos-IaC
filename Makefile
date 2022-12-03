
S3_STATE_BUCKET_NAME=superalgos-terraform-state
S3_STATE_BUCKET_PLACEHOLDER=CHANGE-THE-BUCKET-NAME
STATE_TERRAFORM_CONFIG_FILE = tf/environments/global/000-Terraform-State/terraform.tf


.PHONY: bootstrap comment-state-tfconfig diagrams test  uncomment-state-tfconfig


bootstrap:
	echo "bootstrap"


comment-state-tfconfig:
	@echo "Commenting out configuration in $(STATE_TERRAFORM_CONFIG_FILE)"
	@sed -i '/^terraform {/,/^}/s/^/#/'  $(STATE_TERRAFORM_CONFIG_FILE)


diagrams:
	@python3 scripts/diagram.py -o design


state-init:
	@terraform init


test:
	$(MAKE) -C tests


uncomment-state-tfconfig:
	@echo "Uncommenting configuration in $(STATE_TERRAFORM_CONFIG_FILE)"
	@sed -i '/^#terraform {/,/^#}/s/^#//'  $(STATE_TERRAFORM_CONFIG_FILE)
