defmodule Dashboard.Handler do
  alias DashboardWeb.Endpoint
  use GenServer

  def start_link() do
    {:ok, pid} = GenServer.start_link(__MODULE__, [], [])
  end

  def init(state) do
    Consumer.Server.subscribe(self())
    {:ok, state}
  end


  def handle_info({:received, msg}, state) do
    # send over a channel
    [data | sender]  = String.split(msg)
    data = %{body: data, from: sender}

    Endpoint.broadcast!("chart:main", "new_msg", data)

    {:noreply, state}
  end
end
