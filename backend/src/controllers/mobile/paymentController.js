import RPPlan from "../../models/rpPlanModel.js";
import Payment from "../../models/paymentModel.js";
import Wallet from "../../models/walletModel.js";
import BuyTransaction from "../../models/buyTransactionModel.js";
import Commission from "../../models/commissionModel.js";
import Ledger from "../../models/ledgerModel.js";
import axios from "axios";

/**
 * CREATE PAYMENT (UPI)
 */

export const createPayment = async (req, res) => {
    try {
        const userId = req.user.id;
        const { planId } = req.body;

        if (!userId) {
            return res.status(401).json({ success: false, message: "Unauthorized" });
        }

        const plan = await RPPlan.findById(planId);
        if (!plan) {
            return res.status(404).json({ success: false, message: "Plan not found" });
        }

        const orderId = `ORD_${Date.now()}`;

        const response = await axios.post(
            "https://api.ekqr.in/api/create_order",
            {
                key: process.env.UPI_GATEWAY_API_KEY,   // 🔥 MUST be in body

                client_txn_id: orderId,
                amount: plan.price.toString(),         // EKQR expects string

                p_info: "Buy RP",

                customer_name: req.user?.name || "Finzo User",
                customer_email: req.user?.email || "support@finzopay.online",
                customer_mobile: req.user.phone,
                redirect_url: "https://finzopay.online/payment-return",
                udf1: req.user._id.toString(),
                udf2: "RP Purchase",
                udf3: "FinzoPay"
            },
            {
                headers: {
                    "Content-Type": "application/json"
                }
            }
        );

        // console.log(response)

        await Payment.create({
            userId,
            planId: plan._id,                  // ✅ CRITICAL
            order_id: orderId,
            amount: plan.price,
            status: "created",
            raw_response: response.data
        });

        if (!response.data.status) {
            return res.status(400).json({
                success: false,
                message: response.data.msg
            });
        }

        return res.json({
            success: true,
            upiIntentUrl: response.data.data.payment_url,
            order_id: response.data.data.order_id
        });

        // return res.json({
        //     success: true,
        //     data: {
        //         order_id: orderId,
        //         intent_url: response.data.data.intent_url,
        //         qr_url: response.data.qr_url
        //     }
        // });

    } catch (err) {
        console.error("CREATE PAYMENT ERROR:", err);
        return res.status(500).json({
            success: false,
            message: "Unable to create payment"
        });
    }
};


// GET /payment/status/:orderId
export const getPaymentStatus = async (req, res) => {
    const payment = await Payment.findOne({
        order_id: req.params.orderId
    });

    if (!payment) {
        return res.json({ success: false, status: "not_found" });
    }

    return res.json({
        success: true,
        status: payment.status // created | success | failed
    });
};



// Verify Payment
export const verifyPayment = async (req, res) => {
    try {
        const userId = req.user.id;
        const { order_id, gateway_txn_id, status } = req.body;

        if (!order_id) {
            return res.status(400).json({ success: false, message: "order_id required" });
        }

        // 🔎 Find payment
        const payment = await Payment.findOne({ order_id, userId });
        if (!payment) {
            return res.status(404).json({ success: false, message: "Payment not found" });
        }

        // 🔁 Already processed (IDEMPOTENT)
        if (payment.status === "success") {
            return res.json({
                success: true,
                message: "Already verified",
                data: {
                    order_id,
                    payment_status: "success"
                }
            });
        }

        // ❌ Failed payment
        if (status !== "success") {
            payment.status = "failed";
            await payment.save();

            return res.status(400).json({
                success: false,
                message: "Payment failed"
            });
        }

        // ======================
        // ✅ MARK PAYMENT SUCCESS
        // ======================
        payment.status = "success";
        payment.gateway_txn_id = gateway_txn_id || null;
        await payment.save();

        // ======================
        // 🔎 FETCH PLAN
        // ======================
        const plan = await RPPlan.findById(payment.planId);
        if (!plan) {
            return res.status(500).json({ success: false, message: "Plan missing" });
        }

        // ======================
        // 💰 CALCULATE RP
        // ======================
        const commissionRP =
            (plan.rp_amount * plan.commission_percent) / 100;

        const totalRP = plan.rp_amount + commissionRP;

        // ======================
        // 🔎 WALLET
        // ======================
        let wallet = await Wallet.findOne({ userId });
        if (!wallet) {
            wallet = await Wallet.create({
                userId,
                total_rp: 0,
                locked_rp: 0
            });
        }

        wallet.total_rp += totalRP;
        await wallet.save();

        // ======================
        // 🧾 BUY TRANSACTION
        // ======================
        const transaction = await BuyTransaction.create({
            userId,
            planId: plan._id,
            amount_paid: plan.price,
            rp_bought: plan.rp_amount,
            commission_percent: plan.commission_percent,
            commission_rp: commissionRP,
            total_rp_credit: totalRP,
            payment_id: gateway_txn_id || order_id,
            status: "success"
        });

        // ======================
        // 📊 COMMISSION
        // ======================
        await Commission.create({
            userId,
            source: "buy_rp",
            rp_amount: commissionRP
        });

        // ======================
        // 📒 LEDGER
        // ======================
        await Ledger.create({
            userId,
            type: "credit",
            reason: "buy_rp",
            rp: totalRP,
            balance_after: wallet.total_rp,
            ref_id: transaction._id
        });

        // ======================
        // ✅ FINAL RESPONSE
        // ======================
        return res.json({
            success: true,
            message: "Payment verified & RP credited",
            data: {
                order_id,
                payment_status: "success",
                wallet_balance: wallet.total_rp
            }
        });

    } catch (err) {
        console.error("VERIFY PAYMENT ERROR:", err);
        return res.status(500).json({
            success: false,
            message: err.message
        });
    }
};


/**
 * VERIFY PAYMENT (UPI)
 */
// export const verifyPayment = async (req, res) => {
//     try {
//         const userId = req.user.id;
//         const { order_id, gateway_txn_id, status } = req.body;

//         const payment = await Payment.findOne({ order_id, userId });
//         if (!payment) {
//             return res.status(404).json({
//                 success: false,
//                 message: "Payment not found"
//             });
//         }

//         /* =====================
//            VERIFY WITH GATEWAY
//            (Pseudo code)
//         ===================== */

//         /*
//         const verifyResponse = await upiGateway.verify({
//           order_id,
//           gateway_txn_id
//         });
//         */

//         // TEMP: assume success
//         if (status !== "success") {
//             payment.status = "failed";
//             await payment.save();

//             return res.status(400).json({
//                 success: false,
//                 message: "Payment failed"
//             });
//         }

//         payment.status = "success";
//         payment.gateway_txn_id = gateway_txn_id;
//         await payment.save();

//         res.json({
//             success: true,
//             message: "Payment verified successfully",
//             data: {
//                 order_id,
//                 payment_status: "success"
//             }
//         });

//     } catch (err) {
//         res.status(500).json({
//             success: false,
//             message: err.message
//         });
//     }
// };
