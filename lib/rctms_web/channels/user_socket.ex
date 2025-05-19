# lib/rctms_web/channels/user_socket.ex
defmodule RCTMSWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: RCTMSWeb.Schema

  # Fix the unused parameter warning by adding underscore
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
