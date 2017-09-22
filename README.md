
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

#### Install

```
# in each of producer / consumer / dashboard
mix deps.get
```

#### Run it

```
# terminal 1

# start web server & message consumer
iex -S mix phx.server 


# terminal 2

# start the message producer
iex -S mix

iex(1)> pid = Producer.connect
#PID<0.160.0>
iex(2)> Producer.publish pid, "5"
```

