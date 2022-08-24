# Crypto payment app

This application simulates a simple crypto payment flow by implementing the following steps:

- The user can enter a `tx_hash` in the input field and initiate a payment by clicking on the `Make payment` button or pressing `Enter`
- Once the payment is made and the `tx_hash` was validated, the payment goes through the confirmation process
- If the confirmation was successful (i.e. there are at least 2 block confirmations), the transaction details (value, transaction fee, gas, gas price, recipient address) get displayed in the UI enabling the user to review the payment
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

The project was created with the `mix phx.new` command with the `--no-ecto` flag. To follow a simple approach with React configuration, the frontend code was set up in the `assets` folder, a root element was added to the template and configuration code was added in `.babelrc` to handle `React` and `JSX`. 

The frontend only utilizes `React` and `ReactDOM`. The backend uses `httpoison` dependecy to issue HTTP requests and `mox` for mocking requests in tests. 

The goal was to implement the required flow in the form of a simple but user-friendly payment application which enables the user to make and review payments via a clean UI, implements a basic validation / error handling logic, and interacts with an external API. 

**Payment flow**

- When the user inputs and sends a `tx_hash` to the backend, the app calls the `/make_payment` endpoint. The controller function in `payment_controller.ex` takes the `tx_hash` and validates it. If it's invalid, it gives instant feedback to the client and treats it as a failed payment.

- Once the `tx_hash` is validated, the controller reaches out to the `EtherscanClient` module which containes all the functions that are responsible for communicating with the Etherscan API. It calls the `get_transaction` function which requests transaction details from the external API by calling the `eth_getTransactionByHash` action. If the request is successful, the app treats it as a sign that the payment was received.

- In order to let the user know about the successful transaction and provide info on the payment, the `make_payment` endpoint returns certain transaction details. It calls the `convert_transaction_values` function from `payment_helpers.ex` which grabs all the returned transaction details, picks the ones we want to return (value, transaction fee, gas, gasPrice, to), and converts them to usable values (e.g. integer or ETH).

**Confirmation flow**

- Once the transaction details are returned, the frontend initiates the confirmation phase. This is mocked by using `setInterval` and calling the `confirm_payment` in every 3rd second until the confirmation is provided or the request fails. Of course, this should be implemented differently in a production environment, the goal here was just to simply demonstrate that the confirmation is not immediate and it takes an unknown amount of time and also, that the confirmation phase is logically separated from the receiving of the payment.

- The `confirm_payment` funcion mocks the confirmaton process in a way that it grabs the block number of the transaction which was sent by the frontend with the request and calls the `eth_blockNumber` action of the Etherscan API. This action returns the latest block's number. The app converts this value to integer, checks the difference between the block numbers and if there are at least 2 blocks after the payment's block, it marks the transaction confirmed. 

- Until the `confirm_payment` returns `:confirmed` status, the frontend displays a pending state with a loader. During this payment, no more transaction can be initiated. Once the confirmation is provided, the details of the transaction are displayed by rendering the `LatestPaymentDetails` component. 

- Every successful payment is added to the `payments` array. This allows the user to review all the payments made in the same session by clicking the `Check payments` button. This displays the `PaymentsDetails` component which maps through the previous transactions and displays their most important information. 

- By rendering the `TotalSpending` component, the app also displays the current amount of the ETH spend by the user including the values and transaction fees of all transaction made. 
