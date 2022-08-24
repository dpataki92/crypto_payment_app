defmodule CryptoPaymentAppWeb.EtherscanClientTest do
  use ExUnit.Case, async: true
  import Mox

  alias CryptoPaymentApp.{EtherscanClient, Helper}

  @http_client CryptoPaymentApp.HTTPClientMock

  @get_transaction_url "https://api.etherscan.io/api?module=proxy&action=eth_getTransactionByHash&txhash="
  @get_latest_block_number_url "https://api.etherscan.io/api?module=proxy&action=eth_blockNumber&apikey="
  @success_resp %{
    blockNumber: 4_954_885,
    gas: 21000,
    gasPrice: 2.0e-8,
    to: "0x4848535892c8008b912d99aaf88772745a11c809",
    value: 0.371237
  }
  @api_key Application.fetch_env!(:crypto_payment_app, :etherscan_api_key)

  describe "get_transaction" do
    test "returns map with converted values if response is successful" do
      tx_hash = "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
      url = @get_transaction_url <> tx_hash <> "&apikey=" <> @api_key

      expect(@http_client, :get, fn ^url ->
        {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
      end)

      assert {:ok, @success_resp} == EtherscanClient.get_transaction(tx_hash, @api_key)
    end

    test "returns error with reason if request fails with message" do
      tx_hash = "0x7b6d0e8d812873260291"
      url = @get_transaction_url <> tx_hash <> "&apikey=" <> @api_key

      expect(@http_client, :get, fn ^url ->
        {:error, %HTTPoison.Response{body: "", status_code: 200}}
      end)

      assert {:error,
              %{reason: "invalid argument 0: hex string has length 20, want 64 for common.Hash"}} ==
               EtherscanClient.get_transaction(tx_hash, @api_key)
    end
  end

  describe "get_latest_block_number" do
    test "returns latest block number if request is successful" do
      tx_hash = "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
      url = @get_latest_block_number_url <> tx_hash <> "&apikey=" <> @api_key

      expect(@http_client, :get, fn ^url ->
        {:ok, %HTTPoison.Response{body: @success_resp |> Jason.encode!(), status_code: 200}}
      end)

      assert {:ok, latest_block_number} = EtherscanClient.get_latest_block_number(@api_key)
      assert String.match?(latest_block_number, ~r/^0x[0-9a-fA-F]+$/)
    end

    test "returs error with default reason if request fails" do
      tx_hash = "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"
      url = @get_latest_block_number_url <> tx_hash <> "&apikey=" <> "123"

      expect(@http_client, :get, fn ^url ->
        {:error, %HTTPoison.Response{body: "", status_code: 500}}
      end)

      assert {:error, %{reason: "Sorry, something went wrong"}} ==
               EtherscanClient.get_latest_block_number("1234")
    end
  end
end
