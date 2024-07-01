defmodule CommercyfyNotifier.Emitter do
  alias CommercyfyNotifier.Logger
  alias CommercyfyNotifier.Utils.Requests
  alias CommercyfyNotifier.Webhooks
  alias CommercyfyNotifier.Webhook
  alias CommercyfyNotifier.Models.Notification

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_opts), do: {:ok, []}

  def emit(message), do: GenServer.cast(__MODULE__, {:emit, message})

  def handle_cast({:emit, message}, state) do
    model = Notification.create(message)

    Webhooks.get_webhooks()
    |> Enum.each(fn %Webhook{:url => url} ->
      case Requests.request(:post, url, body: Jason.encode!(model)) do
        {:ok, _} -> Logger.log({:info, "Successfull notification to #{url}"})
        {:error, reason} -> Logger.log({:error, reason})
      end
    end)

    {:noreply, state}
  end
end
