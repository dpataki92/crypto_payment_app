defmodule CryptoPaymentApp.EtherscanClient do
  alias CryptoPaymentApp.Helper

  @get_transaction_url "https://api.etherscan.io/api?module=proxy&action=eth_getTransactionByHash&txhash="
  @get_latest_block_number_url "https://api.etherscan.io/api?module=proxy&action=eth_blockNumber&apikey="

  def get_transaction(tx_hash, api_key, headers \\ []) do
    url = @get_transaction_url <> tx_hash <> "&apikey=" <> api_key

    result =
      url
      |> call(headers)
      |> decode()

    case result do
      {:ok, %{result: result}} ->
        {:ok, Helper.convert_transaction_values(result, [:blockNumber, :value, :gasPrice, :gas])}

      {:ok, %{error: %{message: message}}} ->
        {:error, %{reason: message}}

      _ ->
        {:error, %{reason: "Sorry, something went wrong"}}
    end
  end

  def get_latest_block_number(api_key, headers \\ []) do
    url = @get_latest_block_number_url <> api_key

    response =
      url
      |> call(headers)
      |> decode()

    case response do
      {:ok, %{id: _id, result: block_number}} -> {:ok, block_number}
      _ -> {:error, %{reason: "Sorry, something went wrong"}}
    end
  end

  defp call(url, headers \\ []) do
    url
    |> HTTPoison.get(headers)
    |> case do
      {:ok, %{body: body, status_code: code, headers: headers}} -> {code, body, headers}
      {:error, %{reason: reason}} -> {:error, reason}
    end
  end

  defp decode({_code, body, _headers}) do
    body
    |> Jason.decode(keys: :atoms)
    |> case do
      {:ok, parsed} -> {:ok, parsed}
      _ -> {:error, body}
    end
  end

  defp decode({error, reason}) do
    {error, reason}
  end
end
