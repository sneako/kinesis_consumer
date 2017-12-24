use Mix.Config

config :ex_aws,
  access_key_id: "test",
  secret_access_key: "test",
  retries: [
    max_attempts: 5,
    base_backoff_in_ms: 50,
    max_backoff_in_ms: 5_000
  ]

config :ex_aws, :kinesis,
  scheme: "http://",
  host: "localhost",
  port: 4567,
  stream: "test_stream"
