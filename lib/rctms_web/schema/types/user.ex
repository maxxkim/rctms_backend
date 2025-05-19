# lib/rctms_web/schema/types/user.ex
defmodule RCTMSWeb.Schema.Types.User do
  use Absinthe.Schema.Notation

  @desc "User information"
  object :user do
    field :id, :id
    field :email, :string
    field :username, :string
    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  @desc "User authentication result"
  object :auth_result do
    field :user, :user
    field :token, :string
  end

  # Input objects for mutations
  input_object :user_registration_input do
    field :email, non_null(:string)
    field :username, non_null(:string)
    field :password, non_null(:string)
  end

  input_object :user_login_input do
    field :email, non_null(:string)
    field :password, non_null(:string)
  end

  # User Mutations
  object :user_mutations do
    @desc "Register a new user"
    field :register, :auth_result do
      arg :input, non_null(:user_registration_input)
      resolve &RCTMSWeb.Resolvers.UserResolver.register/2
    end

    @desc "Login a user"
    field :login, :auth_result do
      arg :input, non_null(:user_login_input)
      resolve &RCTMSWeb.Resolvers.UserResolver.login/2
    end
  end

  # User Queries
  object :user_queries do
    @desc "Get the currently authenticated user"
    field :me, :user do
      resolve &RCTMSWeb.Resolvers.UserResolver.me/2
    end
  end
end
