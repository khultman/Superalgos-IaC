# Docker

I recommend using the [lima-vm](https://github.com/lima-vm/lima) runtime with `nerdctl` for docker compatability.

The [Makefile](Makefile) in this directory contains several shortcuts, to get this image up-and-running you'll only need to run `make`, which comprises the following targets:
* `make docker-build` 
* `make docker-run-interactive`

You SHOULD edit the `Makefile` before running it for the first time, as it makes some assumptions for docker user, the local docker command, and sets a maintainer flag in the generated image.

### .env file
Running the provided image interactively using the `make docker-run-interactive` shortcut will create a `.env` file if one is not found. Populate this file with key=value pairs of environment variables you wish to be available in the session.

Example `.env` file contents:
```
AWS_ACCESS_KEY_ID=secureAccessId
AWS_SECRET_ACCESS_KEY=mySecret
AWS_DEFAULT_REGION=us-east-2
```