import React, { useState } from "react";
import { callApi } from "../../helpers";

import "./PaymentForm.css";

const PaymentForm = ({
  setLatestPayment,
  setPayments,
  setShowPayments,
  paymentsCounter,
  latestPaymentStatus,
  setLatestPaymentStatus,
  setError,
}) => {
  const [txHash, setTxHash] = useState("");

  const handleSubmit = (event) => {
    event.preventDefault();

    const callBack = (data) => {
      if (data["error"]) {
        setLatestPaymentStatus("none");
        setError(data["error"]);
      } else {
        setError(null);
        setLatestPayment(data);
        setPayments((payments) => [...payments, data]);
      }
    };
    const body = JSON.stringify({ tx_hash: txHash });
    setLatestPaymentStatus("pending");

    callApi("http://localhost:4000/make_payment", callBack, body);
  };

  const handleCheckPayments = (event) => {
    event.preventDefault();
    setShowPayments(true);
  };

  return (
    <div className="paymentFormWrapper">
      <h2 className="title">Insert your hash below</h2>
      <form className="form" onSubmit={handleSubmit}>
        <input
          name="txHash"
          className="input"
          onChange={(event) => setTxHash(event.target.value)}
        ></input>
        <div className="buttonWrapper">
          <button
            className="button"
            disabled={latestPaymentStatus === "pending" || txHash.length === 0}
            onClick={handleSubmit}
          >
            MAKE PAYMENT
          </button>
          <button
            disabled={
              latestPaymentStatus === "pending" || paymentsCounter === 0
            }
            className="button"
            onClick={handleCheckPayments}
          >
            CHECK PAYMENTS
          </button>
        </div>
      </form>
    </div>
  );
};

export default PaymentForm;
