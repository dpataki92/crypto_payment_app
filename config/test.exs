import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :crypto_payment_app, CryptoPaymentAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "zLtsOM0Uk3Q9Ob/hb0rxMxTTxZBQhmD6ZkxvD/WUDdoMYYA5grJlbsunXEorHlSw",
  server: false

# In test we don't send emails.
config :crypto_payment_app, CryptoPaymentApp.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

config :crypto_payment_app, :etherscan_client,
  http_client: CryptoPaymentApp.HTTPClientMock,
  url: "https://api.etherscan.io"

import_config "dev.secret.exs"
