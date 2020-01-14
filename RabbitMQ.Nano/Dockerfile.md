# Usage
>`>` docker image build --tag veni-vidi-vici/rabbitmq-3.6.15:nanoserver-1903 ./RabbitMQ.Nano

>`>` docker container run --rm -d --name rabbitmq -p 15672:15672 -p 5672:5672 -t veni-vidi-vici/rabbitmq-3.6.15:nanoserver-1903

>`>` docker container run --rm -it --name rabbitmq -p 15672:15672 -p 5672:5672 -t veni-vidi-vici/rabbitmq-3.6.15:nanoserver-1903 cmd

# RabbitMQ
Messages are sent to Queues. A Queue is a First-In-First-Out (FIFO) data structure. When using RabbitMQ, messages aren't actually published to a queue, but rather are published to an exchange which then routes messages to queues. To receive messages, a queue must first have an exchange binding established. Part of establishing the binding includes specifying which messages should be routed to the queue. In most cases, this is achieved by specifying a routing key which serves as a filter for which messages are delivered to which queues.

## Fanout Exchanges
The Fanout exchange type routes messages to all bound queues indiscriminately. If a routing key is provided, it will simply be ignored. The Fanout exchange type is useful for facilitating the publish-subscribe pattern. When using the fanout exchange type, different queues can be declared to handle messages in different ways.

## Headers Exchanges
The Headers exchange type routes messages based upon a matching of message headers to the expected headers specified by the binding queue. The headers exchange type is similar to the topic exchange type in that more than one criteria can be specified as a filter, but the headers exchange differs in that its criteria is expressed in the message headers as opposed to the routing key, may occur in any order, and may be specified as matching any or all of the specified headers. The Headers exchange type is useful for directing messages which may contain a subset of known criteria where the order is not established and provides a more convenient way of matching based upon the use of complex types as the matching criteria (i.e. a serialized object).
