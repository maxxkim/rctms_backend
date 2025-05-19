# lib/rctms_web/controllers/user_controller.ex
defmodule RCTMSWeb.UserController do
  use RCTMSWeb, :controller

  alias RCTMS.Accounts
  alias RCTMS.Accounts.User
  alias RCTMS.Accounts.Guardian

  action_fallback RCTMSWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render(:user, user: user, token: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render(:user, user: user, token: token)
    end
  end
end
