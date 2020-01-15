# nats
ARG BASE_OS_LAYER
ARG BASE_OS_LAYER_VERSION
FROM ${BASE_OS_LAYER}:${BASE_OS_LAYER_VERSION}

# Add metadata to the image.
LABEL copyright="Copyright (C) 2020 Juan Carlos Trimiño. All rights reserved." \
      version="1.0.0" \
      maintainer="juancarlos@trimino.com"

ARG NATS_DOCKERIZED
ENV NATS_DOCKERIZED=${NATS_DOCKERIZED}

WORKDIR c:/nats-server

COPY --from=nats:2.0.2-nanoserver ./nats-server/nats-server.exe ./
COPY --from=nats:2.0.2-nanoserver ./nats-server/nats-server.conf ./

# Client.
EXPOSE "4222/tcp"
# Management.
EXPOSE "8222/tcp"
# Cluster.
EXPOSE "6222/tcp"

# [-c, --config] FILE --> File path to server configuration.
# gnatsd -c gnatsd.conf
ENTRYPOINT ["nats-server"]
CMD ["-c", "nats-server.conf"]
