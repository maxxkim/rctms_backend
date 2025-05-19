defmodule RCTMSWeb.UserJSON do
  @doc """
  Renders a list of users or a single user with token.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  def user(%{user: user, token: token}) do
    %{
      data: data(user),
      token: token
    }
  end

  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username
    }
  end
end
