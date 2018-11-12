defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  # channel "game:*", ServerWeb.MyChannel

  transport :websocket, Phoenix.Transports.WebSocket

  def connect(_params, socket) do
    {:ok, socket}

  end

  def id(_socket), do: "id"

end
