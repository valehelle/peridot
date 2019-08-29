defmodule Peridot.Repo do
  use Ecto.Repo,
    otp_app: :peridot,
    adapter: Ecto.Adapters.Postgres
end
