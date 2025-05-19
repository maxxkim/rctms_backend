defmodule RCTMSWeb.Schema.Types.Comment do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  @desc "Comment information"
  object :comment do
    field :id, :id
    field :content, :string

    # Relationships
    field :task, :task do
      resolve dataloader(RCTMS.Tasks)
    end

    field :user, :user do
      resolve dataloader(RCTMS.Accounts)
    end

    field :inserted_at, :datetime
    field :updated_at, :datetime
  end

  # Input objects for mutations
  input_object :comment_input do
    field :content, non_null(:string)
    field :task_id, non_null(:id)
  end

  # Comment Queries
  object :comment_queries do
    @desc "Get a specific comment"
    field :comment, :comment do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.CommentResolver.get_comment/2
    end

    @desc "List comments for a task"
    field :task_comments, list_of(:comment) do
      arg :task_id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.CommentResolver.list_task_comments/2
    end
  end

  # Comment Mutations
  object :comment_mutations do
    @desc "Create a new comment"
    field :create_comment, :comment do
      arg :input, non_null(:comment_input)
      resolve &RCTMSWeb.Resolvers.CommentResolver.create_comment/2
    end

    @desc "Update a comment"
    field :update_comment, :comment do
      arg :id, non_null(:id)
      arg :content, non_null(:string)
      resolve &RCTMSWeb.Resolvers.CommentResolver.update_comment/2
    end

    @desc "Delete a comment"
    field :delete_comment, :comment do
      arg :id, non_null(:id)
      resolve &RCTMSWeb.Resolvers.CommentResolver.delete_comment/2
    end
  end

  # Comment Subscriptions
  object :comment_subscriptions do
    @desc "Subscribe to new comments on a task"
    field :comment_added, :comment do
      arg :task_id, non_null(:id)

      config fn args, _info ->
        {:ok, topic: args.task_id}
      end

      trigger [:create_comment], topic: fn
        %{task_id: task_id} -> [task_id]
        _ -> []
      end

      resolve fn comment, _, _ ->
        {:ok, comment}
      end
    end
  end
end
