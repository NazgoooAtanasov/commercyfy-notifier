defmodule CommercyfyNotifier.Notifier do
  use GenServer
  alias CommercyfyNotifier.Emitter

  def start_link(_) do
    start = GenServer.start_link(__MODULE__, [], name: __MODULE__)

    config = [
      hostname: Application.get_env(:commercyfy_notifier, :db_hostname),
      port: Application.get_env(:commercyfy_notifier, :db_port),
      username: Application.get_env(:commercyfy_notifier, :db_username),
      password: Application.get_env(:commercyfy_notifier, :db_passwd),
      database: Application.get_env(:commercyfy_notifier, :db_database)
    ]

    {:ok, _pid} =
      Postgrex.start_link(config ++ [name: :psql])

    {:ok, _pid} =
      Postgrex.Notifications.start_link(config ++ [name: :notifier])

    start_listening()

    start
  end

  def init(_opts), do: {:ok, []}

  def start_listening, do: GenServer.call(__MODULE__, {:listen})

  def handle_call({:listen}, _from, state) do
    {:ok, ref} =
      Postgrex.Notifications.listen(:notifier, "table_changes")

    {:reply, ref, state}
  end

  def handle_info({:notification, _pid, _ref, _channel, message}, state) do
    Emitter.emit(message)
    {:noreply, state}
  end
end
