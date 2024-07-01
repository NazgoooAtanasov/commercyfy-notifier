defmodule CommercyfyNotifier.Utils.Requests do
  @type header :: {String.t(), String.t()}

  @type post_opts ::
          {:body, String.t()}
          | {:content_type, String.t()}
          | {:headers, [header()]}

  @spec request(:post, String.t(), [post_opts()]) :: {:ok, term()} | {:error, term()}
  def request(:post, url, opts \\ []) do
    options = Enum.into(opts, %{})

    headers =
      Map.get(options, :headers, [])
      |> Enum.map(fn {key, value} -> {String.to_charlist(key), String.to_charlist(value)} end)

    :httpc.request(
      :post,
      {String.to_charlist(url), headers,
       String.to_charlist(Map.get(options, :content_type, "application/json")),
       Map.get(options, :body, "")},
      [],
      []
    )
  end
end
