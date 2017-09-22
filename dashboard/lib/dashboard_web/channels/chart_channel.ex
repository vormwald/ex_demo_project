defmodule DashboardWeb.ChartChannel do
  use DashboardWeb, :channel


  # use Phoenix.Channel

  def join("chart:main", _message, socket) do
    {:ok, socket}
  end
  def join("chart:" <> _private_room_id, _params, _socket) do
    {:error, %{reason: "unauthorized"}}
  end

  def handle_in("new_msg", %{"body" => body}, socket) do
    broadcast! socket, "new_msg", %{body: body}
    {:noreply, socket}
  end
end
