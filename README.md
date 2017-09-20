
# Quick Elixir Demo for SF Offsite

This app is broken up into 3 components:

- A phoenix app that displays a dashboard containing rabbit messages over
  time
- A rabbit MQ server that receives messages
- A fault-tolerant process that generates messages on a set interval. 


#### Pre-reqs

- RabbitMQ - message bus for inter-application message passing
  `brew install rabbitmq`
  Recommend you follow post-install instructions to have it start up automatically. 
  If you miss it, just type brew info rabbitmq to get the post-install instructions again.
