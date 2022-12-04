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

Start with creating a [private fork](https://docs.github.com/en/repositories/creating-and-managing-repositories/duplicating-a-repository) of this repository. You will need to make several modifications to the terraform files contained, such as defining the appropriate region for deployment and other configuration-specific elements that will be unique for your circumstances. I have tried to make this as easy as possible for you.

### Edit these files

#### Makefile
There are a few key variables that you will want to define for your unique circumstanes

#### scripts/superalgos.setup.sh
You will need update some keys variables in this file to match your unique
circumstances, such as github username.



