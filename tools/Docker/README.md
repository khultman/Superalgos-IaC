# Docker

I recommend using the [lima-vm](https://github.com/lima-vm/lima) runtime with `nerdctl` for docker compatability.

The [Makefile](Makefile) in this directory contains several shortcuts, to get this image up-and-running you'll only need to run `make`, which comprises the following targets:
* `make docker-build` 
* `make docker-run-interactive`

You SHOULD edit the `Makefile` before running it for the first time, as it makes some assumptions for docker user, the local docker command, and sets a maintainer flag in the generated image.

