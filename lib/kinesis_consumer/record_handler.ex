defmodule KinesisConsumer.RecordHandler do
  use Task

  def start_link(opts, event) do
    Task.start_link(fn ->
      IO.inspect {self(), event}
    end)
  end
end
