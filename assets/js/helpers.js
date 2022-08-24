export const callApi = (url, callback, body) => {
  const csrfToken = document.head.querySelector(
    "[name~=csrf-token][content]"
  ).content;

  fetch(url, {
    method: "POST",
    body,
    headers: {
      "Content-Type": "application/json",
      "X-CSRF-Token": csrfToken,
    },
  })
    .then((response) => response.json())
    .then((data) => callback(data));
};

export const calculateTotalETHSpent = (payments) => {
  return payments
    .map((payment) => payment.gasPrice * payment.gas + payment.value)
    .reduce((a, b) => a + b, 0)
    .toFixed(4);
};
