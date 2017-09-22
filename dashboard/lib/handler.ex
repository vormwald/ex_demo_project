defmodule Dashboard.Handler do
  use GenServer

  def start_link(state) do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], [])
  end

  def init(state) do
    Consumer.Server.subscribe(self())
    {:ok, state}
  end


  def handle_info({:received, msg}, state) do
    # send over a channel
    IO.puts msg

    {:noreply, state}
  end
end
