defmodule CryptoPaymentAppWeb.PaymentController do
  use CryptoPaymentAppWeb, :controller
  alias CryptoPaymentApp.{Helper, EtherscanClient}

  @api_key Application.fetch_env!(:crypto_payment_app, :etherscan_api_key)

  def make_payment(conn, params) do
    with :ok <- Helper.validate_tx_hash(params["tx_hash"]),
         {:ok, result} <- EtherscanClient.get_transaction(params["tx_hash"], @api_key) do
      json(conn, result)
    else
      {:error, %{reason: :not_valid_hash}} ->
        json(conn, %{error: "Hash is invalid - please provide 64 hexadecimal characters"})

      {:error, %{reason: reason}} ->
        json(conn, %{error: reason})
    end
  end

  def confirm_payment(conn, params) do
    with {:ok, latest_block_number} <- EtherscanClient.get_latest_block_number(@api_key),
         %{status: status} <- Helper.confirm_payment(latest_block_number, params["block_number"]) do
      json(conn, %{status: status})
    else
      {:error, %{reason: reason}} -> json(conn, %{error: reason})
    end
  end
end
