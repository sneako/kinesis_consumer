defmodule Test.KinesisHelper do
  @moduledoc """
  Helper functions for setting up Kinesis streams and seeding data
  """

  alias ExAws.Kinesis
  require Logger

  @event_buffer_length 10

  @doc """
  Create a kinesis stream
  """
  @spec create_stream(String.t()) :: :ok | :error
  def create_stream(name) do
    name
    |> Kinesis.create_stream()
    |> ExAws.request()
    |> case do
         {:ok, _} ->
           :ok

         error ->
           Logger.error(error)
           :error
       end
  end

  @doc """
  Delete kinesis stream by name
  """
  @spec delete_stream(String.t()) :: :ok
  def delete_stream(name) do
    result =
      ExAws.Kinesis.delete_stream(name)
      |> ExAws.request()

    case result do
      {:ok, _} -> :ok
      {:error, {_, _, %{"__type" => "ResourceNotFoundException"}}} -> :ok
    end

    # Streams are not deleted immediately, delete timeout should be set
    # via `--deleteStreamMs 10` for Kinesalite
    :timer.sleep(50)
  end

  @doc """
  Writes a string or list of strings to kinesis. Strings get chunked in to records.
  Strings within a record are separated by newlines. @TODO Configurable separator
  """
  @spec write(String.t(), String.t()) :: :ok | :error
  def write(data, stream_name) when is_bitstring(data), do: write([data], stream_name)

  @spec write(List.t(), String.t()) :: :ok | :error
  def write(data, stream_name) do
    Kinesis.put_records(stream_name, to_records(data))
    |> ExAws.request()
    |> case do
         {:ok, _} ->
           :ok

         {:error, error} ->
           Logger.error(fn -> "Kinesis error: #{inspect(error)}" end)
           :error

         other ->
           Logger.warn(fn -> "Kinesis, unexpected response: #{inspect(other)}" end)
           :error
       end
  end

  defp to_records(events) do
    events
    |> Enum.chunk_every(@event_buffer_length)
    |> Enum.map(&kinesis_record(&1))
  end

  defp kinesis_record(data) do
    %{
      data: Enum.join(data, "\n"),
      partition_key: :rand.uniform(999_999_999) |> to_string |> Base.encode64()
    }
  end
end
