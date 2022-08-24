import React, { useEffect } from "react";
import { callApi } from "../../helpers";

import "./LatestPaymentDetails.css";

const LatestPaymentDetails = ({
  to,
  blockNumber,
  value,
  gasPrice,
  gas,
  latestPaymentStatus,
  setLatestPaymentStatus,
  setError,
}) => {
  const handleConfirm = () => {
    const callBack = (data) => {
      if (data["error"]) {
        setLatestPaymentStatus("none");
        setError(data["error"]);
      } else {
        setLatestPaymentStatus(data.status);
      }
    };
    const body = JSON.stringify({ block_number: blockNumber });

    callApi("http://localhost:4000/confirm_payment", callBack, body);
  };

  useEffect(() => {
    if (latestPaymentStatus === "none") {
      setLatestPaymentStatus("pending");
    }
  }, []);

  // simulates the payment confirmation process by keep calling confirm_payment endpoint until the confirmation is provided or the request fails
  useEffect(() => {
    if (latestPaymentStatus === "pending") {
      const interval = setInterval(() => {
        handleConfirm();
      }, 3000);
      return () => clearInterval(interval);
    }
  }, [latestPaymentStatus]);

  return latestPaymentStatus === "pending" ? (
    <div className="paymentDetailsWrapper unprocessedPaymentWrapper">
      <div className="loader" />
      <span>Waiting for confirmations...</span>
    </div>
  ) : (
    <div className="paymentDetailsWrapper">
      <div className="row">
        <h3>Latest payment details</h3>
        <div>
          Status: <span className="status">{latestPaymentStatus}</span>
        </div>
      </div>

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
};

export default LatestPaymentDetails;
