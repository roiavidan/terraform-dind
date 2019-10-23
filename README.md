# Terraform w/ Docker-in-Docker

This repository provides a minimal [Terraform]() _Docker_ image that can be used by your deployment scripts. It is ~120MB unpacked.

> **IMPORTANT**: This image DOES NOT change the user! The container will run as `root` and it is expected that your _Docker_ configuration will be [isolating containers with a user namespace](https://docs.docker.com/engine/security/userns-remap/).

## What's inside?

The image comes with the following utilities:

- [Terramform](https://www.terraform.io/) v0.12.12
- [Docker](https://www.docker.com/) _CLI_ v19.03.4
- [Busybox](https://busybox.net/) v1.31.0 MUSL
- [Git](https://git-scm.com/) v2.22.0
- [AWS CLI](https://aws.amazon.com/cli/) v1.16.262 (running as D-in-D)
- Root CA certificates (for SSL/TLS)

#### Native commands

The _Busybox_ binary provides the following command symlinks as part of the image:

- sh
- ls
- cp
- mv
- rm
- mkdir
- cat
- pwd
- tar

Everything else can be used by prefixing `busybox` to it.

#### Docker-in-Docker commands

Since the _AWS CLI_ is usually a very useful command that is used inside local provisioners, a handy D-in-D script is included which provides it.

Just execute your commands as if the actual binary was installed. For example:

```bash
$ aws servicediscovery list-services
```

> **NOTE**: This requires you to map the _Docker_ daemon's socket into the container. See below for more details.

## Usage

In order for you to run other docker from within a _Terraform_ "local-exec" provisioner, this image must be run with a volume mount for binding the _Docker_ daemon socket into the container:

```bash
$ docker run --rm \
    -v "/var/run/docker.sock:/var/run/docker.sock" \
    ... \
    roiavidan/terraform-dind:latest \
    apply ...
```

#### Is it safe?

Well, yes and no.

This image is designed to be run in a controlled CI/CD environment and not in your production systems, so you should already have limited network access to begin with and the _Docker_ daemon run with `userns-remap` and I would say it **is safe enough**.

But ultimately the answer depends on your security profile and risk assessment.
