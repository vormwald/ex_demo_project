defmodule Producer.Bus do
  use GenServer
  use AMQP

  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  @exchange    "test_exchange"
  @queue       "test_queue"
  @queue_error "#{@queue}_error"

  def init(_opts) do
    {:ok, conn} = AMQP.Connection.open("amqp://guest:guest@0.0.0.0")
    {:ok, chan} = AMQP.Channel.open(conn)

    {:ok, chan}
  end

  def handle_cast({:publish, payload}, chan) do
    AMQP.Basic.publish chan, @exchange, "", payload

    {:noreply, chan}
  end
end
