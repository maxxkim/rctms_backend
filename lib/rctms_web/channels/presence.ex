defmodule RCTMSWeb.Presence do
  use Phoenix.Presence,
    otp_app: :rctms,
    pubsub_server: RCTMS.PubSub

  @doc """
  Tracks a user's presence in a project.
  """
  def track_user(project_id, user_id, user_info) do
    # Generate a unique key for this connection
    key = "user:#{user_id}"
    meta = %{
      user_id: user_id,
      username: user_info.username,
      online_at: DateTime.utc_now(),
      status: "online"
    }

    __MODULE__.track(self(), "project:#{project_id}", key, meta)
  end

  @doc """
  Lists users present in a specific project
  """
  def list_users(project_id) do
    __MODULE__.list("project:#{project_id}")
    |> Enum.map(fn {_, data} ->
      data[:metas]
      |> List.first()
    end)
  end

  @doc """
  Updates a user's presence status
  """
  def update_user_status(project_id, user_id, status) do
    key = "user:#{user_id}"
    current_presence = __MODULE__.get_by_key("project:#{project_id}", key)

    if current_presence do
      meta = current_presence[:metas] |> List.first() |> Map.put(:status, status)
      __MODULE__.update(self(), "project:#{project_id}", key, meta)
    end
  end
end
