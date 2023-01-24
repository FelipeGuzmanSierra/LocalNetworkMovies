defmodule LocalnetworkMovies.Repo do
  use Ecto.Repo,
    otp_app: :localnetwork_movies,
    adapter: Ecto.Adapters.Postgres
end
