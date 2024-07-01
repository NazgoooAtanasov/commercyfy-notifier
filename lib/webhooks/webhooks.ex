defmodule CommercyfyNotifier.Webhook do
  defstruct [:url]

  @type t :: %__MODULE__{
          url: String.t()
        }
end

defmodule CommercyfyNotifier.Webhooks do
  use GenServer

  def start_link(_), do: GenServer.start_link(__MODULE__, [], name: __MODULE__)

  def init(_opts), do: {:ok, []}

  @doc """
    Gets the registered webhooks for notifications
  """
  @spec get_webhooks() :: list(CommercyfyNotifier.Webhook.t())
  def get_webhooks(), do: GenServer.call(__MODULE__, {:get_webhooks})

  def handle_call({:get_webhooks}, _from, state) do
    result =
      Postgrex.query!(:psql, "SELECT url FROM _metadata_webhooks", [],
        decode_mapper: fn x -> %CommercyfyNotifier.Webhook{url: Enum.at(x, 0)} end
      )

    {:reply, result.rows, state}
  end
end
