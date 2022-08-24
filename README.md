# Crypto payment app

This application simulates a simple crypto payment transaction by implementing the following user flow:

- The user can enter a `tx_hash` in the input field and initiate a payment by clicking on the "Make payment" button or pressing "Enter"
- Once the payment is made and the app validated that it was made by a valid tx_hash, it goes through the confirmation process
- If the confirmation was successful, the transaction details (e.g. value, transaction fee, etc.) are displayed in the UI enabling the user to review the payment
- The user can also click on the "Check payments" button to review all the payments that were made in the same "session"
- Once the first payment is successfully made, the total ETH value spent (including transaction value + transaction fee) is constantly displayed to the user

You can check behavior in this [demo video](https://drive.google.com/file/d/1GOfQ3sxf2_TBk2eh70kt55IKBvtNhYs8/view?usp=sharing).

The project was built with Elixir/Phoenix and React and utilizes the Etherscan API. 

# Usage

- `git clone` repo
- create `dev.secret.exs` file in `/config` folder and place the following code there:

  ```elixir
  import Config
  config :crypto_payment_app, etherscan_api_key: "<YOUR ETHERSCAN API KEY HERE>"
  ```
- run `npm i react react-dom` and `mix deps.get`
- run `mix phx.server`
- go to `/localhost:4000`

# File structure

Strucure of the main files to review:

```
crypto_payment_app
│   README.md   
│
└───assets
│   │
│   └───js
│       │   app.jsx
│       │   main.jsx
│       │   helpers.js
|       │
|       └───components
|            │   /PaymentForm (.jsx + .css)
|            │   /LatestPaymentDetails (.jsx + .css)
|            │   /PaymentsDetails (.jsx + .css)
|            │   /TotalSpending (.jsx + .css)
...
│   
└───lib
|    │   crypto_payment_app_web
|    │   │
|    │   └───controllers
|    │       │   payment_controller.ex
|    │       │   page_controller.ex
|    ...        
|    │   etherscan_client.ex
|    │   payment_helpers.ex
...
└───test
    │   crypto_payment_app_web
    │   │
    │   └───controllers
    │       │   payment_controller_test.ex
    │       │   page_controller_test.ex
    │   etherscan_client_test.ex
    │   payment_helpers_test.ex
```

# Explanation of changes
