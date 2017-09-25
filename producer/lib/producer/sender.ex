defmodule Producer.Sender do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [], [name: {:global, __MODULE__}])
  end

  def init(state) do
    schedule_send()
    {:ok, state}
  end

  def handle_info(:send, state) do
    message = "#{Enum.random(1..5)} #{node()}"
    Producer.Bus.publish(message)

    schedule_send() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_send() do
    Process.send_after(self(), :send, 1 * 1000) # In 2 seconds
  end
end
