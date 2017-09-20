defmodule Producer do
  alias Producer.Bus

  def connect do
    {:ok, pid} = Bus.start_link
    pid
  end

  def publish(bus_pid, message) do
    GenServer.cast(bus_pid, {:publish, message})
  end
end
