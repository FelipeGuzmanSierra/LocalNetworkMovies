defmodule LocalnetworkMoviesWeb.MovieController do
  use LocalnetworkMoviesWeb, :controller

  @type conn :: Plug.Conn.t()
  @type subtitles :: String.t()
  @type movie_name :: String.t()
  @type movie_file_path :: String.t()
  @type subtitles_file_path :: String.t()
  @type error :: String.t()
  @type vtt_file_status :: {:ok, subtitles()} | {:error, error()}
  @type srt_file_status :: {:ok, subtitles()} | {:error, error()}
  @type format_subtitles_status :: :ok | {:error, error()}

  @spec index(conn(), any()) :: conn()
  def index(%{params: %{"movie_name" => movie_name}} = conn, _params) do
    movie_path = get_movie_path(movie_name)
    subtitles_path = get_subtitles_path(movie_name)

    render(conn, "index.html",
      movie_name: movie_name,
      movie_path: movie_path,
      subtitles_path: subtitles_path
    )
  end

  @spec get_movie_path(movie_name()) :: movie_file_path()
  def get_movie_path(movie_name) do
    "/videos/" <> movie_name <> "/movie/" <> movie_name <> ".mp4"
  end

  @spec get_subtitles_path(movie_name()) :: subtitles_file_path()
  def get_subtitles_path(movie_name) do
    case validate_subtitles_file_exist(movie_name) do
      :ok -> "/videos/" <> movie_name <> "/subtitles/" <> movie_name <> ".vtt"
      {:error, _error} -> ""
    end
  end

  defp validate_subtitles_file_exist(movie_name) do
    subtitles_path = get_local_path() <> movie_name <> "/subtitles/" <> movie_name

    subtitles_path
    |> validate_vtt_file_exist()
    |> format_subtitles(subtitles_path)
  end

  @spec validate_vtt_file_exist(subtitles_file_path()) :: vtt_file_status()
  defp validate_vtt_file_exist(subtitles_path), do: File.read(subtitles_path <> ".vtt")

  @spec validate_srt_file_exist(subtitles_file_path()) :: srt_file_status()
  defp validate_srt_file_exist(subtitles_path), do: File.read(subtitles_path <> ".srt")

  @spec format_subtitles(vtt_file_status(), subtitles_file_path) :: format_subtitles_status()
  defp format_subtitles({:error, _error}, subtitles_path) do
    subtitles_path
    |> validate_srt_file_exist()
    |> format_srt_file(subtitles_path)
  end

  defp format_subtitles({:ok, _subtitles}, _subtitles_path), do: :ok

  @spec format_srt_file(tuple(), subtitles_file_path) :: :ok | tuple()
  defp format_srt_file({:ok, subtitles}, subtitles_path) do
    vtt_subtitles = subtitles |> Subtitles.guess_format() |> format_subtitles_to_vtt(subtitles)
    File.write(subtitles_path <> ".vtt", vtt_subtitles)
  end

  defp format_srt_file({:error, _error}, _subtitles_path), do: {:error, :no_subtitles_found}

  @spec format_subtitles_to_vtt(atom(), subtitles()) :: subtitles()
  defp format_subtitles_to_vtt(:Vtt, subtitles), do: subtitles

  defp format_subtitles_to_vtt(:Srt, subtitles) do
    {:ok, vtt_subtitles} = Subtitles.parse(subtitles, :Vtt)
    Subtitles.Vtt.Formatter.format(vtt_subtitles)
  end

  @spec get_local_path() :: movie_file_path()
  defp get_local_path, do: Application.get_env(:localnetwork_movies, :movies_local_path, nil)
end
