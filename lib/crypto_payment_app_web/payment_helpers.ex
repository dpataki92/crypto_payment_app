defmodule CryptoPaymentApp.Helper do
  # validates if the input is a 64 character long tx_hash containing only hexadecimal characters
  def validate_tx_hash(tx_hash) do
    if String.match?(tx_hash, ~r/^0x([A-Fa-f0-9]{64})$/) do
      :ok
    else
      {:error, %{reason: :not_valid_hash}}
    end
  end

  # converts the listed original transaction values from hexadecimal to values usable by the frontend in a recursive way
  # :value and :gasPrice values are converted to ETH, other values are converted to integer
  # :to is always included and left as hexadecimal
  def convert_transaction_values(transaction_values, values_to_convert, result \\ %{}) do
    if length(values_to_convert) == 0 do
      Map.put(result, :to, transaction_values[:to])
    else
      [value_to_convert | remaining_values] = values_to_convert

      converted_value =
        if value_to_convert in [:value, :gasPrice] do
          transaction_values[value_to_convert]
          |> convert_hex_to_integer()
          |> convert_wei_to_eth()
        else
          convert_hex_to_integer(transaction_values[value_to_convert])
        end

      result = Map.put(result, value_to_convert, converted_value)
      convert_transaction_values(transaction_values, remaining_values, result)
    end
  end

  # confirms if there are at least 2 block confirmations by checking the difference between the latest block number and the payment's block number
  def confirm_payment(latest_block_number, payment_block_number) do
    confirmations = convert_hex_to_integer(latest_block_number) - payment_block_number

    if confirmations > 1 do
      %{status: :confirmed}
    else
      %{status: :not_confirmed}
    end
  end

  # converts hexadecimal value to integer
  def convert_hex_to_integer(input) do
    "0x" <> hex = input
    {number, _remainder} = Integer.parse(hex, 16)

    number
  end

  # converts wei value to eth value
  def convert_wei_to_eth(value) do
    value / :math.pow(10, 18)
  end
end
