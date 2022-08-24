import React from "react";

import "./PaymentsDetails.css";

const PaymentsDetails = ({ payments, setShowPayments }) => {
  return (
    <div className="paymentsWrapper">
      <span className="closeButton" onClick={() => setShowPayments(false)}>
        ← Go back
      </span>

      {payments.map((payment, i) => {
        const { to, value, blockNumber, gasPrice, gas } = payment;
        return (
          <div key={i} className="paymentDetailsWrapper paymentsRow">
            <div className="row">
              <div>
                To: <span className="field">{to}</span>
              </div>
              <div>
                Block number: <span className="field">{blockNumber}</span>
              </div>
            </div>
            <div className="row">
              <div>
                Value: <span className="field">{value}</span>
              </div>
              <div>
                Transaction fee: <span className="field">{(gasPrice * gas).toFixed(4)}</span>
              </div>
            </div>
          </div>
        );
      })}
    </div>
  );
};

export default PaymentsDetails;
