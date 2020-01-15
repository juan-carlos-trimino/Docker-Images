# Usage
>`>` docker image build --tag veni-vidi-vici/nats-2.0.2:nanoserver-1903 ./NATS

>`>` docker container run --rm --detach --publish 8222:8222 --name nats veni-vidi-vici/nats-2.0.2:nanoserver-1903

>`>` docker container run --rm -it --name nats veni-vidi-vici/nats-2.0.2:nanoserver-1903 cmd

# NATS
NATS is an open-source, high-performance, lightweight and secure cloud native messaging system.

https://nats.io/
