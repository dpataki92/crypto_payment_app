import React from "react";

import "./TotalSpending.css";

const TotalSpending = ({ totalValue }) => {
  return (
    <div className="totalSpendingWrapper">
      <div className="title">Total ETH spent: </div>
      <span className="totalValue">{totalValue}</span>
    </div>
  );
};

export default TotalSpending;
