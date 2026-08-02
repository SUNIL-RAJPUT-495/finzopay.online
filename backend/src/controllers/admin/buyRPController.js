import BuyTransaction from "../../models/buyTransactionModel.js";
import Commission from "../../models/commissionModel.js";
import RPPlan from "../../models/rpPlanModel.js";
import Wallet from "../../models/walletModel.js";
import Ledger from "../../models/ledgerModel.js";



// ADD RP PLAN
export const addRPPlan = async (req, res) => {
    try {
        const { title, rp_amount, price, commission_percent } = req.body;

        const plan = await RPPlan.create({
            title,
            rp_amount,
            price,
            commission_percent
        });

        res.status(201).json({
            success: true,
            message: "RP Plan added successfully",
            data: plan
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// UPDATE RP PLAN
export const updateRPPlan = async (req, res) => {
    try {
        const plan = await RPPlan.findByIdAndUpdate(
            req.params.id,
            req.body,
            { new: true }
        );

        res.json({
            success: true,
            message: "RP Plan updated",
            data: plan
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// GET ALL PLANS
export const getAllRPPlans = async (req, res) => {
    try {
        const plans = await RPPlan.find();

        res.json({
            success: true,
            data: plans
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// GET ALL BUYED RP PLANS
export const getAllBuyedRPPlans = async (req, res) => {
    try {
        const { status } = req.query;

        const query = {};
        if (status) query.status = status;

        const allTransaction = await BuyTransaction.find(query).populate("userId", "name email phone").sort({ createdAt: -1 });

        res.json({
            success: true,
            data: allTransaction
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// ADMIN APPROVE / REJECT
export const verifyBuyRP = async (req, res) => {
    try {

        let rpBuyId = req.params.id
        const { payment_id, status } = req.body;

        if (!rpBuyId || !status) {
            return res.status(400).json({
                success: false,
                message: "Rp Buy Id and status required"
            });
        }

        const transaction = await BuyTransaction.findById({ _id: rpBuyId });

        if (!transaction) {
            return res.status(404).json({
                success: false,
                message: "Transaction not found"
            });
        }

        if (transaction.status !== "pending") {
            return res.status(400).json({
                success: false,
                message: "Already processed"
            });
        }

        // ❌ REJECT CASE
        if (status === "failed") {
            transaction.status = "failed";
            await transaction.save();

            return res.json({
                success: true,
                message: "Transaction failed"
            });
        }

        // ✅ APPROVE CASE
        const plan = await RPPlan.findById(transaction.planId);

        const commissionRP =
            (plan.rp_amount * plan.commission_percent) / 100;

        const totalRP = plan.rp_amount + commissionRP;

        // WALLET
        let wallet = await Wallet.findOne({ userId: transaction.userId });
        if (!wallet) {
            wallet = await Wallet.create({ userId: transaction.userId });
        }

        wallet.total_rp += totalRP;
        await wallet.save();

        // UPDATE TRANSACTION
        transaction.status = "success";
        transaction.rp_bought = plan.rp_amount;
        transaction.commission_percent = plan.commission_percent;
        transaction.commission_rp = commissionRP;
        transaction.total_rp_credit = totalRP;

        await transaction.save();

        // COMMISSION ENTRY
        await Commission.create({
            userId: transaction.userId,
            source: "buy_rp",
            rp_amount: commissionRP
        });

        // LEDGER ENTRY
        await Ledger.create({
            userId: transaction.userId,
            type: "credit",
            reason: "buy_rp",
            rp: totalRP,
            balance_after: wallet.total_rp,
            ref_id: transaction._id
        });

        res.json({
            success: true,
            message: "Transaction approved & RP credited"
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};