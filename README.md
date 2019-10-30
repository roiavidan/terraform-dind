# Terraform w/ Docker-in-Docker

This repository provides a minimal [Terraform]() _Docker_ image that can be used by your deployment scripts. It is based on Alpine 3.10.

> **UPDATE**: After reading [this article](https://www.lvh.io/posts/dont-expose-the-docker-socket-not-even-to-a-container.html) I no longer recommend using this image unless you know what you're doing.

## Security considerations

This image is designed to be run in a controlled CI/CD environment and not in your production systems. It DOES NOT change the user! The container will run as `root` and in order to take advantage of `docker-in-docker` you must bind-mount the _Docker socket_ onto this container.

This is not a recommended practice and if you choose to use it, you should at least guarantee to have limited network access to your environment and run the _Docker_ daemon with [userns-remap](https://docs.docker.com/engine/security/userns-remap/).

## What's inside?

The image comes with the following utilities:

- [Terramform](https://www.terraform.io/) v0.12.12
- [Docker](https://www.docker.com/) _CLI_ v19.03.4
- [AWS CLI](https://aws.amazon.com/cli/) v1.16.266 (running as D-in-D)

## Usage

In order for you to run other docker from within a _Terraform_ "local-exec" provisioner, this image must be run with a volume mount for binding the _Docker_ daemon socket into the container:

```bash
$ docker run --rm -t --init \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    -v "$(pwd):$(pwd)" -w "$(pwd)" \
    roiavidan/terraform-dind:latest \
    ...
```
