import React, { useState } from "react";
import LatestPaymentDetails from "./components/LatestPaymentDetails/LatestPaymentDetails";
import PaymentsDetails from "./components/PaymentsDetails/PaymentsDetails";
import PaymentForm from "./components/PaymentForm/PaymentForm";
import TotalSpending from "./components/TotalSpending/TotalSpending";
import { calculateTotalETHSpent } from "./helpers";

const Main = () => {
  const [showPayments, setShowPayments] = useState(false);
  const [latestPayment, setLatestPayment] = useState({});
  const [payments, setPayments] = useState([]);
  const [latestPaymentStatus, setLatestPaymentStatus] = useState("none");
  const [error, setError] = useState(null);

  const { to, value, blockNumber, gasPrice, gas } = latestPayment;

  const totalValue = calculateTotalETHSpent(payments);

  return (
    <>
      {showPayments ? (
        <PaymentsDetails
          payments={payments}
          setShowPayments={setShowPayments}
        />
      ) : (
        <PaymentForm
          setLatestPayment={setLatestPayment}
          latestPaymentStatus={latestPaymentStatus}
          setLatestPaymentStatus={setLatestPaymentStatus}
          setPayments={setPayments}
          setShowPayments={setShowPayments}
          paymentsCounter={payments.length}
          setError={setError}
        />
      )}
      {Object.keys(latestPayment).length !== 0 && !error && (
        <>
          {!showPayments && (
            <LatestPaymentDetails
              to={to}
              value={value}
              blockNumber={blockNumber}
              gasPrice={gasPrice}
              gas={gas}
              latestPaymentStatus={latestPaymentStatus}
              setLatestPaymentStatus={setLatestPaymentStatus}
              setError={setError}
              error={error}
            />
          )}
          {latestPaymentStatus === "confirmed" && (
            <TotalSpending totalValue={totalValue} />
          )}
        </>
      )}
      {error && (
        <div className="paymentDetailsWrapper unprocessedPaymentWrapper">
          <span className="failedPayment">Payment failed</span>
          <span>{error}</span>
        </div>
      )}
    </>
  );
};

export default Main;
