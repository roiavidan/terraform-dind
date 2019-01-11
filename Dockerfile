FROM hashicorp/terraform:0.11.10

ENV DOCKER_VERSION=18.06.1-ce

# Install aws cli
RUN apk -v --update add \
    python \
    py-pip \
    groff \
    less \
    mailcap \
    && \
    pip install --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic && \
    apk -v --purge del py-pip && \
    rm /var/cache/apk/*

# Add a static version of Docker CLI to the image
RUN wget -O /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
    tar zvxf /tmp/docker.tgz -C /tmp && \
    mv /tmp/docker/docker /usr/local/bin/docker && \
    rm -rf /tmp/*
