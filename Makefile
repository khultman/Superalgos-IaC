# Set the AWS DEFAULT REGION for use in the Makefile if it doesn't exist
ifeq ($(AWS_DEFAULT_REGION), )
  $(info Setting AWS_DEFAULT_REGION)
  AWS_DEFAULT_REGION              = us-east-1
endif

# This is the AWS region that will be used throughout the makefile
# Each specific use of region will be extended from here to allow you to
# independantly modify the region for different elements of this deployment.
AWS_REGION                        = $(AWS_DEFAULT_REGION)

# For each identical environment,
# add each layer in order that needs to get applied.
ENVIRONMENT_LAYERS                = 100-Network 150-VPN

# Add each identical environment, e.g paper & live
ENVIRONMENTS                      = paper

# The base directory where the environments can be found
ENVIRONMENTS_BASE_DIR             = tf/environments

# Change this to the name of your terraform lock table
STATE_DYNAMO_TABLE_NAME           = superalgos-terraform-locks

# This is the replacement key in the terraform files for the terraform lock table
STATE_DYNAMO_TABLE_PLACEHOLDER    = CHANGE-THE-TABLE-NAME

# Change this to your terraform state region if different than your default region
STATE_REGION                      = $(AWS_REGION)

# This is the replacement key in the terraform files for the region
STATE_REGION_PLACEHOLDER          = CHANGE-THE-REGION

# Change this to your globally unique terraform s3 state bucket name
STATE_S3_BUCKET_NAME              = superalgos-terraform-state

# This is the replacement key in the terraform files for the S3 state bucket
STATE_S3_BUCKET_PLACEHOLDER       = CHANGE-THE-BUCKET-NAME

# This is the path of the terraform executable
TERRAFORM                         = /usr/bin/terraform

# These are the names of the terraform files in any given layer or module
TERRAFORM_CONFIG_FILE             = terraform.tf
TERRAFORM_MAIN_FILE               = main.tf
TERRAFORM_OUTPUTS_FILE            = outputs.tf
TERRAFORM_PROVIDER_FILE           = provider.tf
TERRAFORM_VARIABLES_FILE          = variables.tf

# These are the files that will be automatically edited based on unique configuration
TERRAFORM_EDITABLE_FILES          = $(TERRAFORM_CONFIG_FILE) $(TERRAFORM_MAIN_FILE) $(TERRAFORM_PROVIDER_FILE)

# This is the project relative path of the gobal state "bootstrap" layer
TERRAFORM_GLOBAL_STATE_LAYER_DIR  = $(ENVIRONMENTS_BASE_DIR)/global/000-Terraform-State



.PHONY: bootstrap
bootstrap: bootstrap-update-layer-config bootstrap-comment-tfconfig bootstrap-init bootstrap-apply bootstrap-uncomment-tfconfig bootstrap-migrate-state

.PHONY: bootstrap-init
bootstrap-init:
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) init


.PHONY: bootstrap-comment-tfconfig
bootstrap-comment-tfconfig:
	@echo "Commenting out configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); sed -i '/^terraform {/,/^}/s/^/#/'  $(TERRAFORM_CONFIG_FILE)


.PHONY: bootstrap-plan-apply
bootstrap-plan-apply:
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) plan -out=tf.plan -input=false -lock=true


.PHONY: bootstrap-plan-destroy
bootstrap-plan-destroy:
	@echo "You must manually edit $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/main.tf to remove the bucket lifecycle."
	@echo "You must ALSO empty the S3 bucket before bucket destruction will work."
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) plan -destroy -out=tf.plan -input=false -lock=true


.PHONY: bootstrap-apply
bootstrap-apply: bootstrap-plan-apply
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) apply -input=false -auto-approve -lock=true tf.plan


.PHONY: bootstrap-destroy
bootstrap-destroy: bootstrap-plan-destroy
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) apply -input=false -auto-approve -lock=true tf.plan


.PHONY: bootstrap-migrate-state
bootstrap-migrate-state:
	@$(TERRAFORM) init -force-copy


.PHONY: bootstrap-uncomment-tfconfig
bootstrap-uncomment-tfconfig:
	@echo "Uncommenting configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); sed -i '/^#terraform {/,/^#}/s/^#//' $(TERRAFORM_CONFIG_FILE)


.PHONY: bootstrap-update-layer-config
bootstrap-update-layer-config:
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); for file in $(TERRAFORM_EDITABLE_FILES); do \
	sed -i 's/$(STATE_S3_BUCKET_PLACEHOLDER)/$(STATE_S3_BUCKET_NAME)/;s/$(STATE_DYNAMO_TABLE_PLACEHOLDER)/$(STATE_DYNAMO_TABLE_NAME)/;s/$(STATE_REGION_PLACEHOLDER)/$(STATE_REGION)/' $${file}; done


.PHONY: bootstrap-update-layer-config-undo
bootstrap-update-layer-config-undo:
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); for file in $(TERRAFORM_EDITABLE_FILES); do \
	sed -i 's/$(STATE_S3_BUCKET_NAME)/$(STATE_S3_BUCKET_PLACEHOLDER)/;s/$(STATE_DYNAMO_TABLE_NAME)/$(STATE_DYNAMO_TABLE_PLACEHOLDER)/;s/$(STATE_REGION)/$(STATE_REGION_PLACEHOLDER)/' $${file}; done


.PHONY: diagrams
diagrams:
	@python3 scripts/diagram.py -o design


.PHONY: test
test:
	@echo $(AWS_DEFAULT_REGION)


