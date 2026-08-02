// utils/sendSMS.js

// --------------------------------------------------------------------------------------------------
// BLACK SMS SENDING FUNCTION
// --------------------------------------------------------------------------------------------------
import axios from "axios";

const sendSMS = async ({ to, otp }) => {
    try {
        const response = await axios.post(
            "https://blacksms.in/sms",
            {
                sender_id: "183",          // provided sender id
                variables_values: otp,     // OTP value
                numbers: to,               // mobile number (without +91)
            },
            {
                headers: {
                    Authorization: process.env.BLACKSMS_API_KEY,
                    "Content-Type": "application/json",
                },
            }
        );

        console.log("SMS sent successfully:", response.data);
        return response.data;
    } catch (error) {
        console.error(
            "SMS sending failed:",
            error.response?.data || error.message
        );
        throw new Error("SMS could not be sent");
    }
};

export default sendSMS;




// --------------------------------------------------------------------------------------------------
// TWILIO SMS SENDING FUNCTION
// --------------------------------------------------------------------------------------------------
// import twilio from "twilio";

// const client = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

// const sendSMS = async ({ to, body }) => {
//     try {
//         const message = await client.messages.create({
//             body,
//             to, // Recipient phone number (+91... etc.)
//             from: process.env.TWILIO_PHONE_NUMBER, // Your Twilio number
//         });
//         console.log("SMS sent:", message.sid);
//     } catch (error) {
//         console.error("SMS sending error:", error);
//         throw new Error("SMS could not be sent");
//     }
// };

// export default sendSMS;
