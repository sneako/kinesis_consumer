defmodule Test.KinesisHelper do
  @moduledoc """
  Helper functions for setting up Kinesis streams and seeding data
  """

  def create_stream(name) do
    name
    |> ExAws.Kinesis.create_stream()
    |> ExAws.request()
    |> case do
         {:ok, _} -> :ok
         error -> IO.inspect(error)
       end
  end
end
