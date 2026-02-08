defmodule Investment.Repo do
  use Ecto.Repo,
    otp_app: :investment,
    adapter: Ecto.Adapters.Postgres
end
