defmodule LocalnetworkMovies.Subtitles do
  alias LocalnetworkMovies.ProcessFiles

  @type movie_name :: String.t()
  @type subtitles :: binary()
  @type subtitles_file_path :: String.t()
  @type file_name :: nil | String.t()
  @type format :: String.t()

  @spec get_subtitles_path(movie_name()) :: subtitles_file_path()
  def get_subtitles_path(movie_name) do
    case validate_subtitles_file_exist(movie_name) do
      :ok -> "/videos/" <> movie_name <> "/" <> movie_name <> ".vtt"
      {:error, error} -> error
    end
  end

  @spec validate_subtitles_file_exist(movie_name :: movie_name()) :: :ok | {:error, any()}
  defp validate_subtitles_file_exist(movie_name) do
    subtitles_path = get_local_path() <> movie_name <> "/" <> movie_name <> ".vtt"

    subtitles_path
    |> File.exists?()
    |> process_file(movie_name)
  end

  @spec process_file(file_exist :: boolean(), movie_name :: movie_name()) :: :ok | {:error, any()}
  defp process_file(true, _movie_name), do: :ok

  defp process_file(false, movie_name) do
    subtitles_folder = get_local_path() <> movie_name

    subtitles_folder
    |> ProcessFiles.get_file_name(".vtt")
    |> format_vtt_subtitles(subtitles_folder, movie_name, ".vtt")
  end

  @spec format_vtt_subtitles(
          file_name :: file_name(),
          subtitles_file_path :: subtitles_file_path(),
          movie_name :: movie_name(),
          format :: format()
        ) :: :ok | {:error, any()}
  defp format_vtt_subtitles(nil, subtitles_folder, movie_name, _format) do
    subtitles_folder
    |> ProcessFiles.get_file_name(".srt")
    |> format_srt_subtitles(subtitles_folder, movie_name, ".srt")
  end

  defp format_vtt_subtitles(old_file_name, subtitles_folder, movie_name, ".vtt"),
    do: ProcessFiles.rename_file(old_file_name, subtitles_folder, movie_name, ".vtt")

  @spec format_srt_subtitles(
          file_name :: file_name(),
          subtitles_file_path :: subtitles_file_path(),
          movie_name :: movie_name(),
          format :: format()
        ) :: :ok | {:error, any()}
  defp format_srt_subtitles(nil, _subtitles_folder, _movie_name, _format),
    do: {:error, :no_subtitles_found}

  defp format_srt_subtitles(old_file_name, subtitles_folder, _movie_name, _format) do
    subtitle_path = subtitles_folder <> "/" <> old_file_name

    subtitle_path
    |> File.read()
    |> format_srt_file(subtitle_path)
  end

  @spec format_srt_file(subtitles :: tuple(), subtitles_file_path :: subtitles_file_path()) ::
          :ok | tuple()
  defp format_srt_file({:ok, subtitles}, subtitles_path) do
    vtt_subtitles = subtitles |> Subtitles.guess_format() |> format_subtitles_to_vtt(subtitles)
    File.write(subtitles_path <> ".vtt", vtt_subtitles)
  end

  defp format_srt_file({:error, _error}, _subtitles_path), do: {:error, :could_not_read_file}

  @spec format_subtitles_to_vtt(subtitles_format :: atom(), subtitles :: subtitles()) ::
          subtitles()
  defp format_subtitles_to_vtt(:Vtt, subtitles), do: subtitles

  defp format_subtitles_to_vtt(:Srt, subtitles) do
    {:ok, vtt_subtitles} = Subtitles.parse(subtitles, :Vtt)
    Subtitles.Vtt.Formatter.format(vtt_subtitles)
  end

  @spec get_local_path() :: subtitles_file_path()
  defp get_local_path, do: Application.get_env(:localnetwork_movies, :movies_local_path, nil)
end
