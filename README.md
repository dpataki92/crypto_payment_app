# Crypto payment app

This application simulates a simple crypto payment transaction by implementing the following user flow:

- The user can enter a `tx_hash` in the input field and initiate a payment by clicking on the `Make payment` button or pressing `Enter`
- Once the payment is made and the `tx_hash` was validated, the payment goes through the confirmation process
- If the confirmation was successful (i.e. there are at least 2 block confirmations), the transaction details (e.g. value, transaction fee, etc.) get displayed in the UI enabling the user to review the payment
- The user can also click on the `Check payments` button to review all the payments that were made in the same "session"
- Once the first payment is successfully made, the total ETH value spent (including transaction value + transaction fee) is constantly updated and displayed to the user

You can check the behavior in this [demo video](https://drive.google.com/file/d/1GOfQ3sxf2_TBk2eh70kt55IKBvtNhYs8/view?usp=sharing).

The project was built with `Elixir/Phoenix` and `JavaScript/React` and utilizes the `Etherscan API`. 

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
|
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

# Explanation of implementation

**General**

The project was created with the `mix phx.new` command with the `no-ecto` flag. To follow a simple approach with React configuration, the frontend code was set up in the `assets` folder, a root element was added to the template and configuration code was added in `.babelrc` to handle `React` and `JSX`. 

The frontend only utilizes `React` and `ReactDOM`. The backend uses `httpoison` dependecy to issue HTTP requests and `mox` for mocking requests. 

**Payment flow**



**Confirmation flow**


