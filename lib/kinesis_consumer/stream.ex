defmodule KinesisConsumer.Stream do
  @moduledoc """
  GenStage Kinesis stream producer
  """

  use GenStage

  alias KinesisConsumer.Kinesis

  require Logger

  def start_link(stream_name) do
    GenStage.start_link(__MODULE__, stream_name, name: stream_name)
  end

  def init(stream_name) do
    shards = Kinesis.get_shards(stream_name)
    {:producer, %{stream_name: stream_name, demand: 0, shards: shards}}
  end

  def handle_demand(demand, %{demand: 0} = state) do
    Process.send(self(), :pull_records, [])
    {:noreply, [], %{state | demand: demand}}
  end

  def handle_demand(demand, state) do
    {:noreply, [], %{state | demand: demand + state.demand}}
  end

  def handle_info(:pull_records, state) do
    [next_shard | rest] = state.shards
    {shard, records} = Kinesis.latest_records(next_shard, state.demand)
    new_demand = max(state.demand - Enum.count(records), 0)
    {:noreply, records, %{state | shards: rest ++ [shard], demand: new_demand}}
  end
end
