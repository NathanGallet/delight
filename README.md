# Delight

Technical test for delight company.

## Installation/Configuration.

Run `mix deps.get`.

You need to create the file `config/config.secret.exs` and add (with your own keys):

```elixir
use Mix.Config

config :extwitter, :oauth, [
  consumer_key: "6dB5IVeBSvTZx3SC8xTcHoDbO",
  consumer_secret: "dnosZkvsW8oei56UyCl1uxMqVrR8b3bp5vJdGZRAaA3ga40O0N",
  access_token: "166818158-x5QXTEunwhemUa1k8hcFTDrdaCWL00sQNxkMzglt",
  access_token_secret: "ODJDmlQWvmlGpmaxY22wGBxBiikWzNh0NZqBdMFs39TQb"
]
```

Then run `iex -S mix` in order to launch the webserver.

You can visit `localhost:4000/ranks` to see kpi for keywords `["microsoft", "apple", "amazon", "netflix", "google", "sony", "nintendo", "blizzard"]`.
If you want a specific keyword, go to `localhost:4000/ranks/linux"` to see kpi for linux in this example.
