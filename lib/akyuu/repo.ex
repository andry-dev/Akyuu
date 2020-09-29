defmodule Akyuu.Repo do
  use Ecto.Repo,
    otp_app: :akyuu,
    adapter: Ecto.Adapters.Postgres
end
