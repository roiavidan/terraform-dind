FROM hashicorp/terraform:0.12.12 AS TERRAFORM
FROM busybox:1.31.0-musl AS BUSYBOX

FROM alpine:3.10 AS ALPINE
RUN apk --no-cache add git ca-certificates
RUN update-ca-certificates

FROM scratch
VOLUME [ "/root/.ssh" ]
ENTRYPOINT [ "/usr/local/bin/terraform" ]

# Add local files
COPY entrypoint.sh /usr/local/bin/
COPY utils/* /usr/local/bin/
COPY etc/* /etc/

# Add minimal Busybox commands
COPY --from=BUSYBOX /bin/busybox /bin/busybox
COPY --from=BUSYBOX /bin/busybox /bin/sh
RUN busybox ln -s /bin/busybox /bin/ls && \
  busybox ln -s /bin/busybox /bin/cat && \
  busybox ln -s /bin/busybox /bin/rm && \
  busybox ln -s /bin/busybox /bin/mv && \
  busybox ln -s /bin/busybox /bin/cp && \
  busybox ln -s /bin/busybox /bin/mkdir && \
  busybox ln -s /bin/busybox /bin/pwd && \
  busybox ln -s /bin/busybox /bin/tar

# Add Terraform
COPY --from=TERRAFORM /bin/terraform /usr/local/bin/

# Add Git & Root CA Certs
COPY --from=ALPINE /usr/bin/git /usr/bin/
COPY --from=ALPINE /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=ALPINE /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=ALPINE /lib/libz.so.1 /lib/
COPY --from=ALPINE /usr/lib/libpcre2-8.so.0 /usr/lib/
COPY --from=ALPINE /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

# Add Docker
ADD https://download.docker.com/linux/static/stable/x86_64/docker-19.03.4.tgz /tmp/docker.tgz
RUN tar zvxf /tmp/docker.tgz -C /tmp && \
  mv /tmp/docker/docker /usr/local/bin/docker && \
  busybox chown root:root /usr/local/bin/docker && \
  rm -rf /tmp/*
