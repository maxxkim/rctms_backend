defmodule RCTMS.Repo do
  use Ecto.Repo,
    otp_app: :rctms,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 10  # Добавление поддержки Scrivener
end
