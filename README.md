# Superalgos Infrastructure-as-Code

This project is [designed](docs/design.md) to deploy the Superalgos project securely to AWS. See the [Project Structure](docs/project-structure.md) for an overview.

***It is very much a prototype, not fully functional, and a work in progress.***

***It is very much a prototype, not fully functional, and a work in progress.***


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
# This *does not* need to be a root domain, but it *does* need to correlate to a
# Route53 hosted zone in the AWS account you are deploying into.
DOMAIN_NAME

# Add each environment you wish to create and deploy, e.g paper & live
ENVIRONMENTS

# Change this to your globally unique terraform s3 state bucket name
STATE_S3_BUCKET_NAME
```

#### scripts/superalgos.setup.sh
You will need update some keys variables in this file to match your unique
circumstances, such as github username.

### First Deployment
If this is the first deployment into an AWS account, you will want to manually
run the bootstrap process. You can run the included [Docker Image](tools/Docker/README.md)
or you install [Terraform](https://www.terraform.io/) locally on your machine.

Once you've edited the Makefile variables per above, and you've established a 
suitable runtime environment, run the following:

`make bootstrap`

This will do a few things:
* Edit terraform configuration files to apply the settings you've defined the `Makefile`.
* Create the S3 bucket and DynamoDB table used for `Terraform State` tracking.
* Move the `Terraform State` created from create procedure to its proper destination.

