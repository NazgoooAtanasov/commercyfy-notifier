defmodule CommercyfyNotifier do
  use Application

  def start(_, _) do
    children = [
      CommercyfyNotifier.Notifier,
      CommercyfyNotifier.Emitter,
      CommercyfyNotifier.Logger,
      CommercyfyNotifier.Webhooks,
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
