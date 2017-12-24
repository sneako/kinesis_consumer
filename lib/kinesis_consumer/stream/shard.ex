defmodule KinesisConsumer.Stream.Shard do
  @type t :: %__MODULE__{
          stream_name: String.t(),
          id: String.t(),
          iterator: String.t()
        }
  defstruct [:stream_name, :id, :iterator]
end
