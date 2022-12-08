## START: AWS Settings

# Set the AWS DEFAULT REGION for use in the Makefile if it doesn't exist
AWS_DEFAULT_REGION               ?= us-east-1

# This is the AWS region that will be used throughout the makefile
# Each specific use of region will be extended from here to allow you to
# independantly modify the region for different elements of this deployment.
AWS_REGION                        = $(AWS_DEFAULT_REGION)

## END: AWS Settings


## START: Project Directory Variables
## These directory variables are specific to the project.
## If you change any project structures these variables will need to be updated.
## All directory variables should be suffixed by `_DIR` for clarity.

# The base terraform directory
TERRAFORM_BASE_DIR                = tf
# The base directory where the environments can be found
ENVIRONMENTS_BASE_DIR             = $(TERRAFORM_BASE_DIR)/environments
# The directory of the Global Envionrmnet
GLOBAL_ENVIRONMENT_DIR            = $(ENVIRONMENTS_BASE_DIR)/global
# template envrionment path to extend any paper/live/etc... environments from
TEMPLATE_ENVIRONMENT_DIR          = $(ENVIRONMENTS_BASE_DIR)/template
# This is the project relative path of the global dns "bootstrap" layer
TERRAFORM_GLOBAL_DNS_LAYER_DIR    = $(GLOBAL_ENVIRONMENT_DIR)/050-DNS
# This is the project relative path of the gobal state "bootstrap" layer
TERRAFORM_GLOBAL_STATE_LAYER_DIR  = $(GLOBAL_ENVIRONMENT_DIR)/000-Terraform-State

## END: Project Directory Variables


## START: Bootstrap Layers Config
TERRAFORM_BOOTSTRAP_LAYER_DIRS    = $(TERRAFORM_GLOBAL_STATE_LAYER_DIR) $(TERRAFORM_GLOBAL_DNS_LAYER_DIR)
## END: Bootstrap Layers Config


## START: Environment & Layers Configurations

# Add each environment you wish to create and deploy, e.g paper & live
# ENVIRONMENTS                      = paper live
ENVIRONMENTS                      = paper
# For each identical environment,
# add each layer in order that needs to get applied.
ENVIRONMENT_LAYERS                = 050-DNS 100-Network 150-VPN
# These are the names of the terraform files in any given layer or module
TERRAFORM_CONFIG_FILE             = terraform.tf
TERRAFORM_MAIN_FILE               = main.tf
TERRAFORM_OUTPUTS_FILE            = outputs.tf
TERRAFORM_PROVIDER_FILE           = provider.tf
TERRAFORM_USER_VARIABLES_FILE     = terraform.tfvars
TERRAFORM_VARIABLES_FILE          = variables.tf
# These are the files that will be automatically edited based on unique configuration
TERRAFORM_EDITABLE_FILES          = $(TERRAFORM_CONFIG_FILE) $(TERRAFORM_MAIN_FILE) $(TERRAFORM_PROVIDER_FILE)

## END: Environment & Layers Configurations


## START: DNS Configuration

# This is the DNS name that will be used when creating sub-zones and delegation
# records required by the VPN, TLS Certificates, and Load Balancers.
# The bootstrap DNS layer will create a zone for this domain name, and you will
# need to create a delegation record for this zone in your root domain.
ROOT_DOMAIN_NAME                   = superalgos.mydomain.tld

## END: DNS Configuration


## START: Remote State Configuration

# Change this to the name of your terraform lock table
STATE_DYNAMO_TABLE_NAME           = superalgos-terraform-locks

# Change this to your terraform state region if different than your default region
STATE_REGION                      = $(AWS_REGION)

# Change this to your globally unique terraform s3 state bucket name
STATE_S3_BUCKET_NAME              = superalgos-terraform-state

# This is a version identifier that will be used for state layer checks.
# This is intended to be a simple integer, incremented only when a major change
# is introduced to the state layer which necessitates modifications to the
# underlying infrastructure, and such that state file needs to be removed from
# the remote state infrastructure and re-copied from local instances.
# In essence, this should be updated *very rarely, if ever at all*
STATE_VERSION                     = 1

## END: Remote State Configuration


## START: Terraform Configuration Substitutions

# This is the replacement key in the terraform files for the root domain name
ROOT_DOMAIN_NAME_PLACEHOLDER      = CHANGE-THE-ROOT-DOMAIN-NAME

# This is the replacement key in the terraform files for the terraform lock table
STATE_DYNAMO_TABLE_PLACEHOLDER    = CHANGE-THE-TABLE-NAME

# This is the replacement key in the terraform files for the region
STATE_REGION_PLACEHOLDER          = CHANGE-THE-REGION

# This is the replacement key in the terraform files for the S3 state bucket
STATE_S3_BUCKET_PLACEHOLDER       = CHANGE-THE-BUCKET-NAME

# This is the regex used to update the bootstrap config files
CONFIG_SUBSTITUTION               = 's/$(STATE_S3_BUCKET_PLACEHOLDER)/$(STATE_S3_BUCKET_NAME)/;s/$(STATE_DYNAMO_TABLE_PLACEHOLDER)/$(STATE_DYNAMO_TABLE_NAME)/;s/$(STATE_REGION_PLACEHOLDER)/$(STATE_REGION)/;s/$(ROOT_DOMAIN_NAME_PLACEHOLDER)/$(ROOT_DOMAIN_NAME)/'
INVERSE_CONFIG_SUBSTITUTION       = 's/$(STATE_S3_BUCKET_NAME)/$(STATE_S3_BUCKET_PLACEHOLDER)/;s/$(STATE_DYNAMO_TABLE_NAME)/$(STATE_DYNAMO_TABLE_PLACEHOLDER)/;s/$(STATE_REGION)/$(STATE_REGION_PLACEHOLDER)/;s/$(ROOT_DOMAIN_NAME)/$(ROOT_DOMAIN_NAME_PLACEHOLDER)/'

## END: Terraform Configuration Substitutions


# Commands, override these as-needed
AWK                              := awk
CP                               := cp
EGREP                            := egrep
LN                               := ln
LNDIR                            := lndir
MKDIR                            := mkdir -p
MV                               := mv
PYTHON                           := python3
RM                               := rm -f
SED                              := sed
SHELL                            := bash
SORT                             := sort
# This is the path of the terraform executable
TERRAFORM                        := /usr/bin/terraform
TOUCH                            := touch

TIMESTAMP                        := $(shell date +%Y%m%d%H%M%S)


# $(call file-exists, file-name)
#   Return non-null if a file exists.
file-exists = $(wildcard $1)

# $(call plan-successful, plan-dir)
#   Moves the plan file to a unique name indicating success.
plan-successful = $(MV) $1/tf.plan $1/tf.$(TIMESTAMP).applied.plan

# $(call plan-failed, plan-dir)
#   Moves the plan file to a unique name indicating failure.
plan-failed = $(MV) $1/tf.plan $1/tf.$(TIMESTAMP).failed.plan


.PHONY: add-upstream
add-upstream:
	git remote add upstream git@github.com:khultman/Superalgos-IaC.git


.PHONY: fetch-upstream
fetch-upstream:
	git fetch upstream


.PHONY: update-repo
update-repo: fetch-upstream
	git pull upstream main --no-rebase
# The above should, in most cases, allow the user to allow for divergent
# changes in the key configuration files __most__ of the time. There
# could be unique circumstances where this git behavior might be undesired.
# More testing required.


# The following ~200 lines are the global environment instantiation.
# The global envrionment consists of two layers:
# * A remote state management layer
# * A Core DNS layer
#
# In order to bootstrap terraform, a remote state storage location must be made.
# Then the state files related to making the remote state storage must be copied
# to the remote state.
#
# To minimize any unintented issues, this bootstrapping is overly verbose.

.PHONY: bootstrap
bootstrap: bootstrap-update-layer-config bootstrap-comment-tfconfig bootstrap-init bootstrap-state-apply bootstrap-migrate-state bootstrap-dns-apply

.PHONY: bootstrap-init
bootstrap-init: bootstrap-update-layer-config
	@for layer in $(TERRAFORM_BOOTSTRAP_LAYER_DIRS); do \
		$(TERRAFORM) -chdir=$${layer} init; \
	done


.PHONY: bootstrap-comment-tfconfig
bootstrap-comment-tfconfig:
	@if ! test -f $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bct.completed || test $(STATE_VERSION) -gt `head -1 $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/bct.completed`; then \
		echo "Commenting out configuration in $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/$(TERRAFORM_CONFIG_FILE)"; \
		cd $(TERRAFORM_GLOBAL_STATE_LAYER_DIR); sed -i '/^terraform {/,/^}/s/^/#/'  $(TERRAFORM_CONFIG_FILE) && \
		echo $(STATE_VERSION) > bct.completed; \
	fi


.PHONY: bootstrap-dns-plan-apply
bootstrap-dns-plan-apply: bootstrap-dns-config
	$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_DNS_LAYER_DIR) plan -out=tf.plan -input=false -lock=true


.PHONY: bootstrap-state-plan-apply
bootstrap-state-plan-apply:
	$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) plan -out=tf.plan -input=false -lock=true


.PHONY: bootstrap-plan-destroy
bootstrap-plan-destroy:
	@echo "You must manually edit $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)/main.tf to remove the bucket lifecycle."
	@echo "You must ALSO empty the S3 bucket before bucket destruction will work."
	@for layer in $(TERRAFORM_BOOTSTRAP_LAYER_DIRS); do \
		$(TERRAFORM) -chdir=$${layer} plan -destroy -out=tf.plan -input=false -lock=true


.PHONY: bootstrap-plan-apply
bootstrap-dns-apply: bootstrap-dns-plan-apply
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_DNS_LAYER_DIR) apply -input=false -auto-approve -lock=true tf.plan && \
	$(call plan-successful, $(TERRAFORM_GLOBAL_DNS_LAYER_DIR)) || \
	$(call plan-failed, $(TERRAFORM_GLOBAL_DNS_LAYER_DIR))


.PHONY: bootstrap-dns-config
bootstrap-dns-config:
	@cd $(TERRAFORM_GLOBAL_DNS_LAYER_DIR); \
	$(SED) -i $(CONFIG_SUBSTITUTION) $(TERRAFORM_USER_VARIABLES_FILE)

.PHONY: bootstrap-state-apply
bootstrap-state-apply: bootstrap-plan-apply
	@$(TERRAFORM) -chdir=$(TERRAFORM_GLOBAL_STATE_LAYER_DIR) apply -input=false -auto-approve -lock=true tf.plan && \
	$(call plan-successful, $(TERRAFORM_GLOBAL_STATE_LAYER_DIR)) || \
	$(call plan-failed, $(TERRAFORM_GLOBAL_STATE_LAYER_DIR))


.PHONY: bootstrap-destroy
bootstrap-destroy: bootstrap-plan-destroy
	@for layer in $(TERRAFORM_BOOTSTRAP_LAYER_DIRS); do \
		@$(TERRAFORM) -chdir=$${layer} apply -input=false -auto-approve -lock=true tf.plan


.PHONY: bootstrap-migrate-state
bootstrap-migrate-state: bootstrap-uncomment-tfconfig
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
	@for layer in $(TERRAFORM_BOOTSTRAP_LAYER_DIRS); do \
		for file in $(TERRAFORM_EDITABLE_FILES); do \
			$(SED) -i $(CONFIG_SUBSTITUTION) $${layer}/$${file}; \
		done; \
	done


.PHONY: bootstrap-update-layer-config-undo
bootstrap-update-layer-config-undo:
	@for layer in $(TERRAFORM_BOOTSTRAP_LAYER_DIRS); do \
		for file in $(TERRAFORM_EDITABLE_FILES); do \
			$(SED) -i $(INVERSE_CONFIG_SUBSTITUTION) $${layer}/$${file}; \
		done; \
	done

# End of global environment bootstrap



# This will generate the diagrams and store/overwrite them in design folder
.PHONY: diagrams
diagrams:
	@$(PYTHON) scripts/diagram.py -o design


# This will copy the 
.PHONY: tf-environments
tf-envrionments:
	@for environment_name in $(ENVIRONMENTS); do \
		$(CP) -r $(TEMPLATE_ENVIRONMENT) $(ENVIRONMENTS_BASE_DIR)/$$environment_name; \
		@for layer in $(ENVIRONMENT_LAYERS); do \
			for file in $(TERRAFORM_EDITABLE_FILES); do \
				$(SED) -i $(CONFIG_SUBSTITUTION) $(ENVIRONMENTS_BASE_DIR)/$$environment_name/$${layer}/$${file}; \
			done; \
		done; \
	done


.PHONY: test
test:
	@aws sts get-caller-identity


