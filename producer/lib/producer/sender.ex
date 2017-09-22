defmodule Producer.Sender do
  use GenServer

  def start_link(message_bus) do
    GenServer.start_link(__MODULE__, message_bus, [])
  end

  def init(message_bus) do
    schedule_send()
    {:ok, message_bus}
  end

  def handle_info(:send, message_bus) do
    message = "#{Enum.random(1..5)} #{node()}"
    IO.puts "Sending " <> message
    Producer.publish(message_bus, message)

    schedule_send() # Reschedule once more
    {:noreply, message_bus}
  end

  defp schedule_send() do
    Process.send_after(self(), :send, 1 * 1000) # In 2 seconds
  end
end
