defmodule CommercyfyNotifier.Log do
  @derive Jason.Encoder
  defstruct [:level, :message, :file, :category]

  @type log_level :: :info | :warn | :error

  @type t :: %__MODULE__{
    level: log_level(),
    message: String.t(),
    file: String.t(),
    category: String.t() | nil
  }
end

defmodule CommercyfyNotifier.Models.Log do
  alias CommercyfyNotifier.Log

  @type log_level :: Log.log_level()

  @spec create(log_level(), String.t(), String.t()) :: term()
  def create(level, message, file) do
    %Log{
      level: level,
      message: message,
      file: file
    }
  end
end
