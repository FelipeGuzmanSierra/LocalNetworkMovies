defmodule LocalnetworkMoviesWeb.MovieView do
  use LocalnetworkMoviesWeb, :view

  @type movie_name :: String.t()

  @spec format_name(movie_name :: movie_name()) :: movie_name()
  def format_name(name) do
    name
    |> String.split("_")
    |> Enum.map(fn word -> String.capitalize(word) end)
    |> Enum.join(" ")
  end
end
