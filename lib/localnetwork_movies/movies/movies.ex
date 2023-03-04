defmodule LocalnetworkMovies.Movies do
  alias LocalnetworkMovies.ProcessFiles

  @type movie_name :: String.t()
  @type movie_file_path :: String.t()
  @type process_return :: :ok | {:error, any()}

  @spec get_movie_path(movie_name :: movie_name()) :: movie_file_path()
  def get_movie_path(movie_name) do
    case validate_movie_file_exist(movie_name) do
      :ok -> "/videos/" <> movie_name <> "/" <> movie_name <> ".mp4"
      {:error, error} -> error
    end
  end

  @spec validate_movie_file_exist(movie_name :: movie_name()) :: process_return()
  defp validate_movie_file_exist(movie_name) do
    movie_path = get_local_path() <> movie_name <> "/" <> movie_name <> ".mp4"

    movie_path
    |> File.exists?()
    |> process_file(movie_name)
  end

  @spec process_file(file_exist :: boolean(), movie_name :: movie_name()) :: process_return()
  defp process_file(true, _movie_name), do: :ok

  defp process_file(false, movie_name) do
    movie_folder = get_local_path() <> movie_name

    movie_folder
    |> ProcessFiles.get_file_name(".mp4")
    |> ProcessFiles.rename_file(movie_folder, movie_name, ".mp4")
  end

  @spec get_local_path() :: movie_file_path()
  defp get_local_path, do: Application.get_env(:localnetwork_movies, :movies_local_path, nil)
end
