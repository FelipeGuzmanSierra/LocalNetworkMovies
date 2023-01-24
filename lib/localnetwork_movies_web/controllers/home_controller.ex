defmodule LocalnetworkMoviesWeb.HomeController do
  use LocalnetworkMoviesWeb, :controller

  def index(conn, _params) do
    {:ok, movies} = get_movies_names()

    render(conn, "index.html", movies: movies)
  end

  def get_movies_path(path \\ "")
  def get_movies_path(path), do: "priv/static/videos" <> path

  defp get_movies_names do
    File.ls(get_movies_path())
  end
end
