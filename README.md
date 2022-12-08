# Superalgos Infrastructure-as-Code

This project is [designed](docs/design.md) to deploy the Superalgos project securely to AWS. See the [Project Structure](docs/project-structure.md) for an overview.

***It is very much a prototype, not fully functional, and a work in progress.***

***It is very much a prototype, not fully functional, and a work in progress.***

## Current Status
* Bootstrap Layer: Functional
* Core Network Layer: In-Progress
* Application Layer: Not Started


## Prerequisites
* Forked repository of [superalgos](https://superalgos.org/) per [documentation](https://github.com/Superalgos/Superalgos#superalgos-platform-client-installation)
* An AWS account.
* The ability to delegate a DNS domain for the AWS account to be used.
* AWS API keys for deployment

### Helpful to have
* Some knowledge of terraform
* Some knowledge of AWS infrastructure
* Some knowledge of CI pipelines, specifically Github Actions


## Usage

### Pre-Steps

#### Create an AWS account
If you don't already have an AWS account, you will need to create one. You can
also use an existing AWS account if you already have one, or you can create a
sub account. I would suggest that for best practices when it comes to security,
you isolate this application into a its own dedicated account.

#### Create a Route53 Hosted Zone
As this deployment will create several hosted zones, both public and private,
being able to delegate from an existing Route53 zone in the AWS account will
crucial. See the [Route53 Documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/Welcome.html)
for how to create the first hosted zone.

#### Create a private fork
You will be modifying files in this repository and adding confidential
configuration details. This is a byproduct of using [Terraform](https://www.terraform.io/).
See the Github documentation [creating a private fork](https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository)
for details if you are unfamiliar with creating private forks.

### Edit these files
Once you've created the private fork of this repository, you will need to make
a few customizations to the following files:

#### Makefile
There are a few key variables that you will want to define for your unique circumstanes.

At a minimum, you should set these variables to appropriate values:
```
# This is the DNS name that will be used when creating sub-zones and delegation
# records required by the VPN, TLS Certificates, and Load Balancers.
# The bootstrap DNS layer will create a zone for this domain name, and you will
# need to create a delegation record for this zone in your root domain.
ROOT_DOMAIN_NAME

# Add each environment you wish to create and deploy, e.g paper & live
ENVIRONMENTS

# Change this to your globally unique terraform s3 state bucket name
STATE_S3_BUCKET_NAME
```

#### scripts/superalgos.setup.sh
You will need update some keys variables in this file to match your unique
circumstances, such as github username.

### First Deployment
#### Pre-Steps & Bootstrap

##### Create a suitable runtime environment
If this is the first deployment into an AWS account, you will want to manually
run the bootstrap process. You can run the included [Docker Image](tools/Docker/README.md)
or you install [Terraform](https://www.terraform.io/) locally on your machine.

##### Edit the Makefile
***Note: This is a one-time process.***
Once you've established a suitable run-time environment, you will need to adjust
several key variables in the Makefile [per above](#makefile). We suggest taking
a few moments now to fully understand the variables and their purpose, as future
steps will utilize these variables to create the various environments and
generate the required configuration files.

##### Run the bootstrap process
***Note: This is a one-time process.***

After you've edited the Makefile, you can run the bootstrap process by executing

`make bootstrap`

This will do a few things:
* Edit terraform configuration files to apply the settings you've defined the `Makefile`.
* Create the S3 bucket and DynamoDB table used for `Terraform State` tracking.
* Move the `Terraform State` created from create procedure to its proper destination.

The console output will contain the DNS zone nameservers that you will need to
add to your root domain as a delegation record for the newly created subdomain.
If you are unfamiliar with this process, see the [Route53 Documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingNewSubdomain.html).
This blog post also contains a good overview of the process: [How to Create a Subdomain in Amazon Route 53](https://medium.com/@deep_blue_day/how-to-create-a-subdomain-in-amazon-route-53-81918654f5bf).



#### Inflate the Environment Configurations
***Note: This is a one-time process.***

One of the key variables you will have set in the `Makefile` is the `ENVIRONMENTS`
variable. This variable is a space separated list of environments you wish to
deploy. For example, if you set `ENVIRONMENTS=paper live`, then the following
environment configurations will be created:
* `tf/`
  * `environments/`
    * `live/`
    * `paper/`

And the complete directory structure will look like this:
* `tf/`
  * `environments/`
    * `global/`
    * `live/`
    * `paper/`
    * `template/`

To do this, you can run the following command:

`make tf-environments`

Other variables you set in the `Makefile` will be used to populate the user
configuration in `tf/environments/<environment-name>/terraform.tfvars` files.

At this point you will want to run the following commands:

`git add * && git commit -m "Inflated environment configurations"`

This will commit the environment configurations to your private fork.

Once completed, you will now be responsible for maintaining the environment
configuration files. You will need to update these files as you make changes to
the infrastructure, such as adding new nodes, or changing the number of nodes.
This is intentional as it allows you alter the configuration on a per-environment
basis, and also allows you to maintain a history of changes.

***Best Practice:*** While you can track multiple environments in a single
repository, you might also consider creating a separate private fork for each
environment. This will allow you to isolate each environment into its own AWS
account, maintain a separate history of changes for each environment, and also 
allow you to maintain a separate set of secrets for each environment. 
This does require a bit more work to setup and maintain, and the trade-off is
that you have some duplication of common resources, such as the bootstrap layer.

#### Deploying the Core Network
Once the bootstrap process is complete, you can deploy the core network.


