FROM hashicorp/terraform:0.12.9

ENV DOCKER_VERSION=19.03.2

# Add a static version of Docker CLI to the image
RUN wget -O /tmp/docker.tgz https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz && \
  tar zvxf /tmp/docker.tgz -C /tmp && \
  mv /tmp/docker/docker /usr/local/bin/docker && \
  rm -rf /tmp/*

VOLUME [ "/root/.ssh" ]

ADD entrypoint.sh /

ENTRYPOINT [ "/entrypoint.sh" ]