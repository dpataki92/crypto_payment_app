defmodule CryptoPaymentAppWeb.HelpersTest do
  use CryptoPaymentAppWeb.ConnCase
  alias CryptoPaymentApp.Helper

  describe "validate_tx_hash" do
    test "only accepts a hash with 64 hexadecimal characters" do
      assert Helper.validate_tx_hash("12345") == {:error, %{reason: :not_valid_hash}}

      assert Helper.validate_tx_hash(
               # hash with special characters
               "0xe73525d9e19a7c240f28364dec890aec66701d7434988c3f3d504aadb8#/?@!"
             ) == {:error, %{reason: :not_valid_hash}}

      assert Helper.validate_tx_hash(
               # hash less than 64 characters
               "0xe73525d9e19a7c240f28364dec890aec66701d7434988c3f3d504aadb8b5e07"
             ) == {:error, %{reason: :not_valid_hash}}

      assert Helper.validate_tx_hash(
               "0xe73525d9e19a7c240f28364dec890aec66701d7434988c3f3d504aadb8b5e078"
             ) == :ok
    end
  end

  describe "convert_transaction_values" do
    test "always includes :to value in the result without converting it" do
      transaction_values = %{
        to: "12345"
      }

      result = Helper.convert_transaction_values(transaction_values, [])

      assert result == %{
               to: "12345"
             }
    end

    test "converts hexadecimal values of a map to integer values" do
      transaction_values = %{
        blockNumber: "0x4b9b05",
        gas: "0x5208",
        to: "12345"
      }

      result = Helper.convert_transaction_values(transaction_values, [:blockNumber, :gas])

      assert result == %{
               blockNumber: 4_954_885,
               gas: 21000,
               to: "12345"
             }
    end

    test "converts :value and :gasPrice values to ETH" do
      transaction_values = %{
        blockNumber: "0x4b9b05",
        gas: "0x5208",
        to: "12345",
        value: "0x526e615a87b5000",
        gasPrice: "0x4a817c800"
      }

      result =
        Helper.convert_transaction_values(transaction_values, [
          :blockNumber,
          :gas,
          :value,
          :gasPrice
        ])

      assert result == %{
               blockNumber: 4_954_885,
               gas: 21000,
               to: "12345",
               value: 0.371237,
               gasPrice: 0.00000002
             }
    end

    test "does not convert values that are not included in the values_to_convert list" do
      transaction_values = %{
        blockNumber: "0x4b9b05",
        gas: "0x5208",
        to: "12345",
        value: "0x526e615a87b5000",
        gasPrice: "0x4a817c800"
      }

      result = Helper.convert_transaction_values(transaction_values, [:blockNumber, :gas])

      assert result == %{
               blockNumber: 4_954_885,
               gas: 21000,
               to: "12345"
             }
    end
  end

  describe "confirm_payment" do
    test "returns :confirmed status when there are at least two confirmations and :not_confirmed otherwise" do
      # 2 confirmations
      assert Helper.confirm_payment("0x526", 1316) == %{status: :confirmed}

      # only 1 confirmation
      assert Helper.confirm_payment("0x526", 1317) == %{status: :not_confirmed}

      # same values
      assert Helper.confirm_payment("0x526", 1318) == %{status: :not_confirmed}
    end
  end

  describe "convert_hex_to_integer" do
    test "converts hexadecimal values to integers" do
      assert Helper.convert_hex_to_integer("0x526") == 1318

      assert Helper.convert_hex_to_integer("0x526e615a87b5000") == 371_237_000_000_000_000

      assert Helper.convert_hex_to_integer("0x0fe426d8f95510f4f0bac19be5e1252c4127ee00") ==
               90_722_815_566_898_696_859_994_983_191_040_266_851_353_882_112
    end
  end

  describe "convert_wei_to_eth" do
    test "converts hexadecimal values to integers" do
      assert Helper.convert_wei_to_eth(371_237_000_000_000_000) == 0.371237
      assert Helper.convert_wei_to_eth(1_000_000_000_000_000) == 0.001
      assert Helper.convert_wei_to_eth(1) == 1.0e-18
    end
  end
end
