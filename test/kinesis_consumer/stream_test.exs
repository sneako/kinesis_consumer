defmodule Test.KinesisConsumer.StreamTest do
  use ExUnit.Case, async: true

  alias KinesisConsumer.Stream
  alias Test.KinesisHelper

  setup do
    stream_name = :rand.uniform(999_999_999) |> to_string()
    :ok = KinesisHelper.create_stream(stream_name)
    :timer.sleep(50)

    on_exit(fn ->
      KinesisHelper.delete_stream(stream_name)
    end)

    %{stream_name: stream_name}
  end

  test "Pulls single record", %{stream_name: stream_name} do
    data = "StringOfData"
    :ok = KinesisHelper.write(data, stream_name)
    {:ok, producer} = GenStage.start_link(Stream, stream_name)
    records = GenStage.stream([producer]) |> Enum.take(1)
    assert data in records
  end

  test "Pulls one hundred records", %{stream_name: stream_name} do
    data = KinesisHelper.write_n_values(100, stream_name)
    {:ok, producer} = GenStage.start_link(Stream, stream_name)
    assert data == GenStage.stream([producer]) |> Enum.take(100)
  end
end
