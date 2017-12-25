defmodule KinesisConsumer.Kinesis do
  @moduledoc """
  Wrapper around ExAws Kinesis lib to simplify interactions
  """

  alias KinesisConsumer.Stream.Shard

  require Logger

  @spec get_shards(String.t()) :: [Shard.t()]
  def get_shards(stream_name) do
    {:ok, %{"StreamDescription" => %{"Shards" => shards}}} =
      stream_name
      |> ExAws.Kinesis.describe_stream()
      |> ExAws.request()

    Enum.map(shards, fn %{"ShardId" => shard_id} ->
      %Shard{id: shard_id, stream_name: stream_name}
    end)
  end

  @spec latest_records(Shard.t(), integer) :: {Shard.t(), List.t()}
  def latest_records(%Shard{iterator: nil} = shard, demand) do
    latest_records(%{shard | iterator: shard_iterator(shard)}, demand)
  end

  def latest_records(shard, demand) do
    ExAws.Kinesis.get_records(shard.iterator, %{"Limit" => demand})
    |> ExAws.request()
    |> case do
         {:ok, %{"Records" => records, "NextShardIterator" => next_shard_iterator}} ->
           {%{shard | iterator: next_shard_iterator}, extract_record_data(records)}

         other ->
           Logger.error("Unexpected kinesis response: #{inspect(other)}")
           {shard, []}
       end
  end

  @spec shard_iterator(Shard.t()) :: String.t()
  def shard_iterator(shard) do
    {:ok, %{"ShardIterator" => shard_iterator}} =
      shard.stream_name
      |> ExAws.Kinesis.get_shard_iterator(shard.id, "trim_horizon")
      |> ExAws.request()

    shard_iterator
  end

  defp extract_record_data(records) do
    records
    |> Enum.map(fn %{"Data" => data} -> Base.decode64!(data) end)
  end
end
