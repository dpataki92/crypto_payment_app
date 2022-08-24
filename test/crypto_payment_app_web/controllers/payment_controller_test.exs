defmodule CryptoPaymentAppWeb.PaymentControllerTest do
  use CryptoPaymentAppWeb.ConnCase
  use CryptoPaymentAppWeb, :controller

  @success_resp %{
    blockNumber: 4_954_885,
    gas: 21000,
    gasPrice: 2.0e-8,
    to: "0x4848535892c8008b912d99aaf88772745a11c809",
    value: 0.371237
  }

  describe "make_payment" do
    test "returns not_valid_hash error if tx_hash is invalid", %{
      conn: conn
    } do
      params = %{
        "tx_hash" => "12345abc"
      }

      assert json(conn, %{error: "Hash is invalid - please provide 64 hexadecimal characters"}) ==
               CryptoPaymentAppWeb.PaymentController.make_payment(conn, params)
    end

    test "returns transaction details if tx_hash is valid", %{
      conn: conn
    } do
      tx_hash = "0x7b6d0e8d812873260291c3f8a9fa99a61721a033a01e5c5af3ceb5e1dc9e7bd0"

      params = %{
        "tx_hash" => tx_hash
      }

      assert json(conn, @success_resp) ==
               CryptoPaymentAppWeb.PaymentController.make_payment(conn, params)
    end
  end

  describe "confirm_payment" do
    test "returns :confirmed status if there are more than 2 block confirmations", %{
      conn: conn
    } do
      params = %{
        "block_number" => 30
      }

      assert json(conn, %{status: :confirmed}) ==
               CryptoPaymentAppWeb.PaymentController.confirm_payment(conn, params)
    end

    test "returns :not_confirmed status if there are less than 2 block confirmations", %{
      conn: conn
    } do
      params = %{
        "block_number" => 1_000_000_000
      }

      assert json(conn, %{status: :not_confirmed}) ==
               CryptoPaymentAppWeb.PaymentController.confirm_payment(conn, params)
    end
  end
end
