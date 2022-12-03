
S3_STATE_BUCKET_NAME              = superalgos-terraform-state
S3_STATE_BUCKET_PLACEHOLDER       = CHANGE-THE-BUCKET-NAME
TERRAFORM_CONFIG_FILE             = terraform.tf
TERRAFORM_GLOBAL_STATE_LAYER_DIR  = tf/environments/global/000-Terraform-State



.PHONY: bootstrap
bootstrap:
	echo "bootstrap"


.PHONY: comment-state-tfconfi
comment-state-tfconfig:
	@echo "Commenting out configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); sed -i '/^terraform {/,/^}/s/^/#/'  $(TERRAFORM_CONFIG_FILE)


.PHONY: diagrams
diagrams:
	@python3 scripts/diagram.py -o design


.PHONY: terraform-global-state-init
terraform-global-state-init:
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); terraform init


.PHONY: test
test:
	$(MAKE) -C tests


.PHONY: uncomment-state-tfconfig
uncomment-state-tfconfig:
	@echo "Uncommenting configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); sed -i '/^#terraform {/,/^#}/s/^#//' $(TERRAFORM_CONFIG_FILE)
