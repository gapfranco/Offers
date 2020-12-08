defmodule Offers.Repo do
  use Ecto.Repo,
    otp_app: :offers,
    adapter: Ecto.Adapters.Postgres
end
