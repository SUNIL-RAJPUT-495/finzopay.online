import Razorpay from "razorpay";

// const key_id = process.env.RAZORPAY_KEY_ID;
// const key_secre = process.env.RAZORPAY_KEY_SECRET;
export const razorpay = new Razorpay({
    // key_id: "rzp_test_RFkPslhRyO30ml",
    // key_secret: "dFpydg3JmYCsIUxrivA7X8UB",
    key_id: process.env.RAZORPAY_KEY_ID,
    key_secret: process.env.RAZORPAY_KEY_SECRET,
});
