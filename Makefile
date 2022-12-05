# Set the AWS DEFAULT REGION for use in the Makefile if it doesn't exist
ifeq ($(AWS_DEFAULT_REGION), )
  $(info AWS_DEFAULT_REGION is unset, setting AWS_DEFAULT_REGION)
  AWS_DEFAULT_REGION              = us-east-1
endif

# This is the AWS region that will be used throughout the makefile
# Each specific use of region will be extended from here to allow you to
# independantly modify the region for different elements of this deployment.
AWS_REGION                        = $(AWS_DEFAULT_REGION)

# For each identical environment,
# add each layer in order that needs to get applied.
ENVIRONMENT_LAYERS                = 100-Network 150-VPN

# Add each environment you wish to create and deploy, e.g paper & live
ENVIRONMENTS                      = paper

# The base directory where the environments can be found
ENVIRONMENTS_BASE_DIR             = tf/environments

# This is the DNS name that will be used when creating sub-zones and delegation
# records required by the VPN, TLS Certificates, and Load Balancers.
# This *does not* need to be a root domain, but it *does* need to correlate to a
# Route53 hosted zone in the AWS account you are deploying into.
DOMAIN_NAME                       = mydomain.tld

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

# This is a version identifier that will be used for state layer checks.
# This is intended to be a simple integer, incremented only when a major change
# is introduced to the state layer which necessitates modifications to the
# underlying infrastructure, and such that state file needs to be removed from
# the remote state infrastructure and re-copied from local instances.
# In essence, this should be updated *very rarely, if ever at all*
STATE_VERSION                     = 1

# template envrionment path to extend any paper/live/etc... environments from
TEMPLATE_ENVIRONMENT              = $(ENVIRONMENTS_BASE_DIR)/template

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


# Commands, override these as-needed
AWK                              := awk
CP                               := cp
EGREP                            := egrep
LNDIR                            := lndir
MKDIR                            := mkdir -p
MV                               := mv
PYTHON                           := python3
RM                               := rm -f
SED                              := sed
SHELL                            := bash
SORT                             := sort
# This is the path of the terraform executable
TERRAFORM                         = /usr/bin/terraform
TOUCH                            := touch


# $(call file-exists, file-name)
#   Return non-null if a file exists.
file-exists = $(wildcard $1)


.PHONY: bootstrap
bootstrap: bootstrap-update-layer-config bootstrap-comment-tfconfig bootstrap-init bootstrap-apply bootstrap-uncomment-tfconfig bootstrap-migrate-state

.PHONY: bootstrap-init
bootstrap-init:
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) init


.PHONY: bootstrap-comment-tfconfig
bootstrap-comment-tfconfig:
	@if ! test -f $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bct.completed || test $(STATE_VERSION) -gt `head -1 $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bct.completed`; then \
		echo "Commenting out configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"; \
		cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); sed -i '/^terraform {/,/^}/s/^/#/'  $(TERRAFORM_CONFIG_FILE) && \
		echo $(STATE_VERSION) > bct.complete; \
	fi


.PHONY: bootstrap-plan-apply
bootstrap-plan-apply:
	$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) plan -out=tf.plan -input=false -lock=true


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
	@if ! test -f $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bms.completed || test $(STATE_VERSION) -gt `head -1 $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bms.completed`; then \
		$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) init -force-copy && \
		echo $(STATE_VERSION) > $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bms.completed; \
	fi


.PHONY: bootstrap-uncomment-tfconfig
bootstrap-uncomment-tfconfig:
	@if ! test -f $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/but.completed || test $(STATE_VERSION) -gt `head -1 $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/but.completed`; then \
		echo "Uncommenting configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"; \
		cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); $(SED) -i '/^#terraform {/,/^#}/s/^#//' $(TERRAFORM_CONFIG_FILE) && \
		echo $(STATE_VERSION) > but.completed; \
	fi


.PHONY: bootstrap-update-layer-config
bootstrap-update-layer-config:
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); for file in $(TERRAFORM_EDITABLE_FILES); do \
	$(SED) -i 's/$(STATE_S3_BUCKET_PLACEHOLDER)/$(STATE_S3_BUCKET_NAME)/;s/$(STATE_DYNAMO_TABLE_PLACEHOLDER)/$(STATE_DYNAMO_TABLE_NAME)/;s/$(STATE_REGION_PLACEHOLDER)/$(STATE_REGION)/' $${file}; done


.PHONY: bootstrap-update-layer-config-undo
bootstrap-update-layer-config-undo:
	@cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); for file in $(TERRAFORM_EDITABLE_FILES); do \
	$(SED) -i 's/$(STATE_S3_BUCKET_NAME)/$(STATE_S3_BUCKET_PLACEHOLDER)/;s/$(STATE_DYNAMO_TABLE_NAME)/$(STATE_DYNAMO_TABLE_PLACEHOLDER)/;s/$(STATE_REGION)/$(STATE_REGION_PLACEHOLDER)/' $${file}; done


.PHONY: diagrams
diagrams:
	@$(PYTHON) scripts/diagram.py -o design


.PHONY: tf-environments
tf-envrionments:
	@for environment_name in $(ENVIRONMENTS); do \
		$(CP) -r $(TEMPLATE_ENVIRONMENT) $(ENVIRONMENTS_BASE_DIR)/$$environment_name; \
	done


.PHONY: test
test:
	@echo "Test"


