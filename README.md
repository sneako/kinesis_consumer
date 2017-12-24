# KinesisConsumer

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `kinesis_consumer` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:kinesis_consumer, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/kinesis_consumer](https://hexdocs.pm/kinesis_consumer).


## Planning

1. Consume kinesis stream
  - Start application, which starts a 'producer' for each configured stream
    1. Get all shard ids
    1. Start one process for each shard, that pulls records when it receives a message and sends them back to producer
1. Parse json to ecto model
1. Insert ecto models
