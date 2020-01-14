# Usage
>`>` docker image build --tag veni-vidi-vici/rabbitmq-subscriber-1.0.0:2.2-runtime-nanoserver-1903 ./RabbitMQ.Subscriber

>`>` docker container run --rm --detach --name rabbitmq-subscriber veni-vidi-vici/rabbitmq-subscriber-1.0.0:2.2-runtime-nanoserver-1903

>`>` docker container run --rm -it --name rabbitmq-subscriber veni-vidi-vici/rabbitmq-subscriber-1.0.0:2.2-runtime-nanoserver-1903 cmd
