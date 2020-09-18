defmodule Akyuu.Repo do
  use Ecto.Repo,
    otp_app: :akyuu,
    adapter: Ecto.Adapters.MyXQL
end
