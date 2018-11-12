use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
case :os.type() do
  {:win32, _} ->
    config :server, ServerWeb.Endpoint,
      http: [port: 4000],
      debug_errors: true,
      code_reloader: true,
      check_origin: false,
      env: Mix.env,
      watchers: [cmd: ["/c", "yarn", "run", "watch", cd: Path.expand("../assets", __DIR__)]]
  {:unix, _} ->
    config :server, ServerWeb.Endpoint,
      env: Mix.env,
      watchers: [cmd: ["/c", "yarn", "run", "watch", cd: Path.expand("../assets", __DIR__)]],
      https: [port: 8442,
      otp_app: :server,
        keyfile: "/etc/letsencrypt/live/[YOUR SERVER HERE].com/privkey.pem",
        certfile: "/etc/letsencrypt/live/[YOUR SERVER HERE].com/cert.pem"],
      url: [host: "[YOUR SERVER HERE].com", port: 8442],
        force_ssl: [rewrite_on: [:x_forwarded_proto]]

end

# ## SSL Support
#
# In order to use HTTPS in development, a self-signed
# certificate can be generated by running the following
# command from your terminal:
#
#     openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com" -keyout priv/server.key -out priv/server.pem
#
# The `http:` config above can be replaced with:
#
#     https: [port: 4000, keyfile: "priv/server.key", certfile: "priv/server.pem"],
#
# If desired, both `http:` and `https:` keys can be
# configured to run both http and https servers on
# different ports.

# Watch static and templates for browser reloading.
config :server, ServerWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/server_web/views/.*(ex)$},
      ~r{lib/server_web/templates/.*(eex)$}
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :server, Server.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "server_dev",
  hostname: "localhost",
  pool_size: 10