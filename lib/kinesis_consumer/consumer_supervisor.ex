defmodule KinesisConsumer.ConsumerSupervisor do

  alias KinesisConsumer.{RecordHandler, Stream}

  def start_link() do
    children = [RecordHandler]
    opts = [strategy: :one_for_one, subscribe_to: [{Stream, max_demand: 1000}]]
    ConsumerSupervisor.start_link(children, opts)
  end
end
