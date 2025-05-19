defmodule RCTMS.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :password_hash, :string
    field :password, :string, virtual: true

    has_many :owned_projects, RCTMS.Projects.Project, foreign_key: :owner_id
    has_many :assigned_tasks, RCTMS.Tasks.Task, foreign_key: :assignee_id
    has_many :created_tasks, RCTMS.Tasks.Task, foreign_key: :creator_id
    has_many :comments, RCTMS.Collaboration.Comment

    timestamps(type: :utc_datetime)  # Changed from default type
  end


  @spec changeset(
          {map(),
           %{
             optional(atom()) =>
               atom()
               | {:array | :assoc | :embed | :in | :map | :parameterized | :supertype | :try,
                  any()}
           }}
          | %{
              :__struct__ => atom() | %{:__changeset__ => any(), optional(any()) => any()},
              optional(atom()) => any()
            },
          :invalid | %{optional(:__struct__) => none(), optional(atom() | binary()) => any()}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password])
    |> validate_required([:email, :username, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> validate_length(:username, min: 3, max: 20)
    |> validate_length(:password, min: 6, max: 100)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    # We'll use Bcrypt for password hashing
    # We'll need to add the :bcrypt_elixir dependency
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
