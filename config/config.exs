import Config

config :commercyfy_notifier,
  log_url: System.get_env("LOG_URL"),
  auth_url: System.get_env("AUTH_URL"),
  auth_email: System.get_env("AUTH_EMAIL"),
  auth_passwd: System.get_env("AUTH_PASSWD"),
  db_hostname: System.get_env("DB_HOSTNAME"),
  db_port: System.get_env("DB_PORT"),
  db_username: System.get_env("DB_USERNAME"),
  db_passwd: System.get_env("DB_PASSWORD"),
  db_database: System.get_env("DB_DATABASE")
