defmodule RCTMSWeb.Resolvers.UserResolver do
  alias RCTMS.Accounts
  alias RCTMS.Accounts.Guardian

  @doc """
  Get the current authenticated user
  """
  def me(_args, %{context: %{current_user: current_user}}) do
    {:ok, current_user}
  end

  def me(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  @doc """
  Get a user by ID
  """
  def get_user(%{id: id}, _resolution) do
    case Accounts.get_user(id) do
      nil -> {:error, "User not found"}
      user -> {:ok, user}
    end
  end

  @doc """
  List all users
  """
  def list_users(_args, _resolution) do
    {:ok, Accounts.list_users()}
  end

  @doc """
  Register a new user
  """
  def register(%{input: user_params}, _resolution) do
    with {:ok, user} <- Accounts.create_user(user_params),
        {:ok, token, _claims} <- Guardian.encode_and_sign(user) do

      # Convert NaiveDateTime to DateTime for proper GraphQL serialization
      user = %{user |
        inserted_at: naive_to_utc(user.inserted_at),
        updated_at: naive_to_utc(user.updated_at)
      }

      {:ok, %{user: user, token: token}}
    else
      {:error, changeset} ->
        {:error, extract_error_msg(changeset)}
    end
  end

  # Helper to convert NaiveDateTime to UTC DateTime
defp naive_to_utc(naive_dt) do
  DateTime.from_naive!(naive_dt, "Etc/UTC")
end

@doc """
Authenticates a user with email and password.
Returns a token and user data on success, or an error message on failure.
"""
def login(%{input: %{email: email, password: password}}, _resolution) do
with {:ok, user} <- Accounts.authenticate_user(email, password),
      {:ok, token, _claims} <- Guardian.encode_and_sign(user) do

  # Match the same user transformation you do in register
  user = %{user |
    inserted_at: naive_to_utc(user.inserted_at),
    updated_at: naive_to_utc(user.updated_at)
  }

  {:ok, %{
    token: token,
    user: user
  }}
else
  {:error, :not_found} ->
    {:error, "Invalid email or password"}

  {:error, :invalid_password} ->
    {:error, "Invalid email or password"}

  {:error, %Ecto.Changeset{} = changeset} ->
    errors = format_changeset_errors(changeset)
    {:error, "Validation failed: #{errors}"}

  {:error, reason} when is_atom(reason) ->
    {:error, "Login failed: #{reason}"}

  {:error, reason} ->
    {:error, "Authentication failed: #{inspect(reason)}"}
end
end

  # Helper function to format changeset errors
  defp format_changeset_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {key, value} -> "#{key}: #{value}" end)
    |> Enum.join(", ")
  end
  @doc """
  Update a user
  """
  def update_user(%{id: id, input: user_params}, %{context: %{current_user: current_user}}) do
    # Only allow users to update their own profile
    if current_user.id == String.to_integer(id) do
      user = Accounts.get_user(id)

      case Accounts.update_user(user, user_params) do
        {:ok, updated_user} ->
          {:ok, updated_user}

        {:error, changeset} ->
          {:error, extract_error_msg(changeset)}
      end
    else
      {:error, "Not authorized"}
    end
  end

  def update_user(_args, _resolution) do
    {:error, "Not authenticated"}
  end

  # Helper function to extract error messages from changesets
  defp extract_error_msg(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join(", ")
  end
end
