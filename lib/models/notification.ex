defmodule CommercyfyNotifier.UpdatedNotification do
  @derive Jason.Encoder
  defstruct [
    :action,
    :entity,
    :id,
    :changes
  ]

  @type t :: %__MODULE__{
          action: String.t(),
          entity: String.t(),
          id: String.t(),
          changes: term()
        }
end

defmodule CommercyfyNotifier.CreatedOrDeletedNotification do
  @derive Jason.Encoder
  defstruct [
    :action,
    :entity,
    :id
  ]

  @type t :: %__MODULE__{
          action: String.t(),
          entity: String.t(),
          id: String.t() | nil
        }
end

defmodule CommercyfyNotifier.Models.Notification do
  alias CommercyfyNotifier.CreatedOrDeletedNotification
  alias CommercyfyNotifier.UpdatedNotification

  defp get_action("DELETE"), do: "REMOVED"
  defp get_action("INSERT"), do: "CREATED"
  defp get_action("UPDATE"), do: "UPDATED"

  @spec create_model(term()) :: UpdatedNotification.t()
  defp create_model(%{"action" => "UPDATE", "id" => id, "changes" => changes, "entity" => entity}),
    do: %UpdatedNotification{
      action: get_action("UPDATE"),
      entity: entity,
      id: id,
      changes: changes
    }

  @spec create_model(term()) :: CreatedOrDeletedNotification.t()
  defp create_model(%{"action" => action, "id" => id, "entity" => entity})
       when action in ["INSERT", "DELETE"],
       do: %CreatedOrDeletedNotification{
         action: get_action(action),
         entity: entity,
         id: id
       }

  @doc """
  Parses a string message and creates a
  notification model out of the message 
  """
  @spec create(String.t()) :: CreatedOrDeletedNotification.t() | UpdatedNotification.t()
  def create(message), do: Jason.decode!(message) |> create_model
end
