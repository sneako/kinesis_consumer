defmodule KinesisConsumer do
  @moduledoc """
  Just configure the kinesis streams and start the application!
  """

  alias KinesisConsumer.Stream

  def start_link(stream_name, record_handler) do
    stream = String.to_atom(stream_name)
    Stream.start_link(stream)
    children = [record_handler]
    opts = [strategy: :one_for_one, subscribe_to: [{stream, max_demand: 1000}]]
    ConsumerSupervisor.start_link(children, opts)
  end
end
