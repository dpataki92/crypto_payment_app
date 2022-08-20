defmodule CryptoPaymentAppWeb.PageController do
  use CryptoPaymentAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
