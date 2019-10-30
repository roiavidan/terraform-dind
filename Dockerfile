FROM hashicorp/terraform:0.12.12 AS TERRAFORM

FROM alpine:3.10 AS DOCKER
ADD https://download.docker.com/linux/static/stable/x86_64/docker-19.03.4.tgz /tmp/docker.tgz
RUN tar zxf /tmp/docker.tgz -C /tmp

FROM alpine:3.10
ENTRYPOINT [ "/entrypoint.sh" ]
VOLUME [ "/root/.ssh" ]
ENV TF_RELEASE=true

RUN apk --no-cache add git openssh-client ca-certificates && \
  update-ca-certificates

COPY entrypoint.sh /
COPY utils/* /usr/local/bin/

COPY --from=TERRAFORM /bin/terraform /usr/bin/
COPY --from=DOCKER /tmp/docker/docker /usr/bin/
