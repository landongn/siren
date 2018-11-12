defmodule ServerWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  # channel "game:*", TrinityWeb.GameChannel

  transport :websocket, Phoenix.Transports.WebSocket

  # def connect(params, socket) do
  #   token_valid? = Phoenix.Token.verify(TrinityWeb.Endpoint, "token", params["token"], max_age: :infinity)
  #   case token_valid? do
  #     {:ok, valid_id} ->
  #       {:ok, pid} = Trinity.Game.World.connect(socket, valid_id, params["token"])

  #       socket =
  #         socket
  #         |> assign(:user_id, valid_id)
  #         |> assign(:session_pid, pid)
  #       {:ok, socket}
  #     {:error, :invalid} -> :error
  #     {:error, :missing} -> :error
  #   end
  # end

  # def id(socket), do: "user_socket:#{socket.assigns.user_id}"


end
