defmodule Producer.Sender do
  use GenServer

  def start_link(message_bus) do
    GenServer.start_link(__MODULE__, message_bus)
  end

  def init(state) do
    schedule_send()
    {:ok, state}
  end

  def handle_info(:send, message_bus) do
    IO.puts "sending.."
    Producer.publish(message_bus, "1")

    schedule_send() # Reschedule once more
    {:noreply, message_bus}
  end

  defp schedule_send() do
    Process.send_after(self(), :send, 1 * 1000) # In 2 seconds
  end
end
