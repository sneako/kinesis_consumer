# KinesisConsumer

Pull Kinesis records in to a GenStage producer, allowing you to configure your own consumers.

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

## Running Tests
#### Tests rely on [kinesalite](https://github.com/mhart/kinesalite)
Start kinesalite like so: `kinesalite --deleteStreamMs 0 --createStreamMs 0 --updateStreamMs 0`
