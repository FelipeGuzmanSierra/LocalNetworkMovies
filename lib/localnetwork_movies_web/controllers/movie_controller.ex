defmodule LocalnetworkMoviesWeb.MovieController do
  use LocalnetworkMoviesWeb, :controller

  alias LocalnetworkMovies.{Movies, Subtitles}

  @type conn :: Plug.Conn.t()

  @spec index(conn(), any()) :: conn()
  def index(%{params: %{"movie_name" => movie_name}} = conn, _params) do
    movie_path = Movies.get_movie_path(movie_name)
    subtitles_path = Subtitles.get_subtitles_path(movie_name)

    render(conn, "index.html",
      movie_name: movie_name,
      movie_path: movie_path,
      subtitles_path: subtitles_path
    )
  end
end
