# Terraform w/ Docker-in-Docker

This repository contains a `Dockerfile` for provisioning a *Docker* image for Terraform light (v0.11.14) **WITH** a staticly-linked `docker` executable included.

This allows running *Docker* commands (i.e. using auxiliary images) with Terraform's `local-exec` provisioner as part of deployment.

It requires that the container be run with the *Docker* socket file mapped like:

```bash
$ docker run --rm \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    ... \
    roiavidan/terraform-dind:latest \
    apply ...
```
