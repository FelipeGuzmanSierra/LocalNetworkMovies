defmodule LocalnetworkMovies.ProcessFiles do
  @type file_folder :: String.t()
  @type file_name :: nil | String.t()
  @type file_format :: String.t()
  @type file_path :: String.t()
  @type process_return :: :ok | {:error, any()}

  @spec get_file_name(file_folder :: file_folder(), format :: file_format()) :: file_name()
  def get_file_name(file_folder, format) do
    file_folder
    |> File.ls()
    |> filter_file(format)
    |> handle_response()
  end

  @spec rename_file(
          file_name :: file_name(),
          file_folder :: file_path(),
          file_name :: file_name(),
          format :: file_format()
        ) :: process_return()
  def rename_file(file_old_name, file_folder, file_name, format) do
    File.rename(
      file_folder <> "/" <> file_old_name,
      file_folder <> "/" <> file_name <> format
    )
  end

  @spec filter_file(files :: tuple(), type :: file_format()) :: list()
  defp filter_file({:ok, files}, format),
    do: Enum.filter(files, fn file -> String.ends_with?(file, format) end)

  @spec handle_response(files :: list()) :: file_name() | nil
  defp handle_response([]), do: nil
  defp handle_response([file | _tail]), do: file
end
