import Config

config :management, Management.Repo,
  database: "management",
  username: "user",
  password: "password",
  hostname: "127.0.0.1"

config :management, ecto_repos: [Management.Repo]
