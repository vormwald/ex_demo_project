# cribbed from https://github.com/pma/amqp
defmodule Consumer.Server do
  use GenServer
  use AMQP

  @me          __MODULE__
  @exchange    "test_exchange"
  @queue       "test_queue"
  @queue_error "#{@queue}_error"

  def start_link() do
    GenServer.start_link(@me, [], name: :consumer_server)
  end

  def subscribe(subscriber) do
    GenServer.cast(:consumer_server, {:subscribe, subscriber})
  end

  ## Server
  #
  def init(_args) do
    subscribers = []
    {:ok, conn} = Connection.open("amqp://guest:guest@0.0.0.0")
    {:ok, chan} = Channel.open(conn)
    setup_queue(chan)

    # Limit unacknowledged messages to 10
    Basic.qos(chan, prefetch_count: 10)
    # Register the GenServer process as a consumer
    {:ok, _consumer_tag} = Basic.consume(chan, @queue)
    {:ok, {chan, subscribers}}
  end

  def handle_cast({:subscribe, pid}, {chan, subscribers}) do
    {:noreply, {chan, [pid | subscribers]}}
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: consumer_tag}}, state) do
    {:noreply, state}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: consumer_tag}}, state) do
    {:stop, :normal, state}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: consumer_tag}}, state) do
    {:noreply, state}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, {chan, subscribers}) do
    spawn fn -> consume(chan, tag, redelivered, payload, subscribers) end
    {:noreply, {chan, subscribers}}
  end

  defp setup_queue(chan) do
    Queue.declare(chan, @queue_error, durable: true)
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    Queue.declare(chan, @queue, durable: true,
                                arguments: [{"x-dead-letter-exchange", :longstr, ""},
                                            {"x-dead-letter-routing-key", :longstr, @queue_error}])
    Exchange.fanout(chan, @exchange, durable: true)
    Queue.bind(chan, @queue, @exchange)
  end

  defp consume(channel, tag, redelivered, payload, subscribers) do
    Basic.ack channel, tag
    IO.puts "Consumed #{payload}."
    broadcast(subscribers, payload)

  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise comsumer will stop
    # receiving messages.
    exception ->
      Basic.reject channel, tag, requeue: not redelivered
      IO.puts "Error converting #{payload} to integer"
  end

  defp broadcast(subscribers, msg) do
    Enum.each(subscribers, fn(pid) -> send(pid, {:received, msg}) end)
  end

end

