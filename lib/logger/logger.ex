defmodule CommercyfyNotifier.Logger do
  alias CommercyfyNotifier.Utils.Requests
  alias CommercyfyNotifier.Models.Log

  use GenServer

  def start_link(_),
    do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_opts) do
    Kernel.send(self(), :logger_auth)
    {:ok, %{jwt: nil}}
  end

  @spec log({:info, String.t()} | {:warn, String.t()} | {:error, String.t()}) :: :ok
  def log(log), do: GenServer.cast(__MODULE__, {:log, log})

  def handle_cast({:log, {:info, message}}, state) do
    Requests.request(:post, Application.get_env(:commercyfy_notifier, :log_url),
      body: Jason.encode!(Log.create(:info, message, "commercyfy-notifier")),
      headers: [{"Authorization", "Bearer #{Map.get(state, :jwt)}"}]
    )

    {:noreply, state}
  end

  def handle_cast({:log, {:warn, message}}, state) do
    Requests.request(:post, Application.get_env(:commercyfy_notifier, :log_url),
      body: Jason.encode!(Log.create(:warn, message, "commercyfy-notifier")),
      headers: [{"Authorization", "Bearer #{Map.get(state, :jwt)}"}]
    )

    {:noreply, state}
  end

  def handle_cast({:log, {:error, message}}, state) do
    Requests.request(:post, Application.get_env(:commercyfy_notifier, :log_url),
      body: Jason.encode!(Log.create(:error, message, "commercyfy-notifier")),
      headers: [{"Authorization", "Bearer #{Map.get(state, :jwt)}"}]
    )

    {:noreply, state}
  end

  def handle_info(:logger_auth, state) do
    case Requests.request(:post, Application.get_env(:commercyfy_notifier, :auth_url),
           body:
             Jason.encode!(%{
               email: Application.get_env(:commercyfy_notifier, :auth_email),
               password: Application.get_env(:commercyfy_notifier, :auth_passwd)
             })
         ) do
      {:ok, {_, _, response}} ->
        response = Jason.decode!(response)
        {:noreply, state |> Map.put(:jwt, response["jwt"])}

      {:error, reason} ->
        GenServer.stop(__MODULE__, {:log_authentication_failed, reason})
    end
  end
end
