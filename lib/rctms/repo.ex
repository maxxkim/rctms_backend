defmodule RCTMS.Repo do
  use Ecto.Repo,
    otp_app: :rctms,
    adapter: Ecto.Adapters.Postgres
end
