import React, { useEffect, useState } from "react";

function PaymentReturn() {
    const [status, setStatus] = useState("processing");

    useEffect(() => {
        const params = new URLSearchParams(window.location.search);
        const paymentStatus = params.get("status");

        if (paymentStatus === "success") {
            setStatus("success");
        } else if (paymentStatus === "failure") {
            setStatus("failure");
        } else {
            setStatus("pending");
        }

        // 🔔 Flutter / WebView signal
        window.postMessage("PAYMENT_RETURN", "*");
    }, []);

    return (
        <div style={styles.container}>
            {status === "processing" && (
                <>
                    <h2>Processing Payment...</h2>
                    <p>Please wait</p>
                </>
            )}

            {status === "success" && (
                <>
                    <h2 style={{ color: "green" }}>✅ Payment Successful</h2>
                    <p>Your RP will be credited shortly.</p>
                </>
            )}

            {status === "failure" && (
                <>
                    <h2 style={{ color: "red" }}>❌ Payment Failed</h2>
                    <p>If amount deducted, it will be refunded.</p>
                </>
            )}

            {status === "pending" && (
                <>
                    <h2>⏳ Payment Pending</h2>
                    <p>Please wait or check after some time.</p>
                </>
            )}

            <p style={styles.note}>
                You can safely close this page and return to the app.
            </p>
        </div>
    );
}

const styles = {
    container: {
        height: "100vh",
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        fontFamily: "Arial",
        background: "#f6f8ff",
        textAlign: "center",
        padding: 20,
    },
    note: {
        marginTop: 20,
        fontSize: 13,
        color: "#555",
    },
};

export default PaymentReturn;
