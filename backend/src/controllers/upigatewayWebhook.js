import Payment from "../models/paymentModel.js";
import RPPlan from "../models/rpPlanModel.js";
import Wallet from "../models/walletModel.js";
import BuyTransaction from "../models/buyTransactionModel.js";
import Commission from "../models/commissionModel.js";
import Ledger from "../models/ledgerModel.js";

export const upiGatewayWebhook = async (req, res) => {
    try {
        console.log("🔔 UPI WEBHOOK:", req.body);

        const {
            client_txn_id,
            status,
            upi_txn_id,
        } = req.body;

        const payment = await Payment.findOne({ order_id: client_txn_id });

        if (!payment) return res.status(200).send("PAYMENT_NOT_FOUND");

        // Idempotent
        if (payment.status === "success") {
            return res.status(200).send("ALREADY_DONE");
        }

        if (status !== "success") {
            payment.status = "failed";
            await payment.save();
            return res.status(200).send("FAILED");
        }

        // ======================
        // MARK PAYMENT SUCCESS
        // ======================
        payment.status = "success";
        payment.gateway_txn_id = upi_txn_id;
        await payment.save();

        // ======================
        // PLAN
        // ======================
        const plan = await RPPlan.findById(payment.planId);
        if (!plan) return res.status(200).send("PLAN_NOT_FOUND");

        const commissionRP =
            (plan.rp_amount * plan.commission_percent) / 100;

        const totalRP = plan.rp_amount + commissionRP;

        // ======================
        // WALLET
        // ======================
        let wallet = await Wallet.findOne({ userId: payment.userId });

        if (!wallet) {
            wallet = await Wallet.create({
                userId: payment.userId,
                total_rp: 0,
                locked_rp: 0
            });
        }

        wallet.total_rp += totalRP;
        await wallet.save();

        // ======================
        // BUY TRANSACTION
        // ======================
        const txn = await BuyTransaction.create({
            userId: payment.userId,
            planId: plan._id,
            amount_paid: payment.amount,
            rp_bought: plan.rp_amount,
            commission_percent: plan.commission_percent,
            commission_rp: commissionRP,
            total_rp_credit: totalRP,
            payment_id: upi_txn_id,
            status: "success"
        });

        // ======================
        // COMMISSION
        // ======================
        await Commission.create({
            userId: payment.userId,
            source: "buy_rp",
            rp_amount: commissionRP
        });

        // ======================
        // LEDGER
        // ======================
        await Ledger.create({
            userId: payment.userId,
            type: "credit",
            reason: "buy_rp",
            rp: totalRP,
            balance_after: wallet.total_rp,
            ref_id: txn._id
        });

        return res.status(200).send("OK");

    } catch (err) {
        console.error("❌ WEBHOOK ERROR:", err);
        return res.status(200).send("ERROR");
    }
};
