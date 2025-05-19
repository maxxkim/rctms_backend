# lib/rctms_web/controllers/fallback_controller.ex
defmodule RCTMSWeb.FallbackController do
  use RCTMSWeb, :controller

  # Called for all Ecto.Changeset errors
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: RCTMSWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # Called when a resource is not found
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: RCTMSWeb.ErrorJSON)
    |> render(:"404")
  end

  # Called for unauthorized access
  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(json: RCTMSWeb.ErrorJSON)
    |> render(:"401")
  end
end
