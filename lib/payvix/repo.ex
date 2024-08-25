defmodule Payvix.Repo do
  use Ecto.Repo,
    otp_app: :payvix,
    adapter: Ecto.Adapters.Postgres
end
