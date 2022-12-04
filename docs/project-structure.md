# Project Structure

* design
* docs
* scripts
* tests
* tf
* tools
    * Docker


## design
Contains the generated diagram images.

## docs
Contains the centralized documentation.

## scripts
Contains script resources related to the deployment of the architure and maintenance of the repository.

## tests
Deployment tests for the terraform IaC modules, based on [terratest](https://terratest.gruntwork.io/).

## tf
Contains the terraform IaC resources.

## tools
Deployment and Developer tooling

### tools/Docker
A self-contained docker environment for manual execution and testing. See the [README](../tools/Docker/README.md) in that directory for more information.
