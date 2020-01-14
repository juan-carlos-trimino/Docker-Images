# Usage
>`>` docker image build --tag veni-vidi-vici/rabbitmq-3.6.15:windowsserver-1903 ./RabbitMQ.Server

>`>` docker container run --rm -d --name rabbitmq -p 15672:15672 -p 5672:5672 -t veni-vidi-vici/rabbitmq-3.6.15:windowsserver-1903

>`>` docker container run --rm -it --name rabbitmq -p 15672:15672 -p 5672:5672 -t veni-vidi-vici/rabbitmq-3.6.15:windowsserver-1903 cmd

