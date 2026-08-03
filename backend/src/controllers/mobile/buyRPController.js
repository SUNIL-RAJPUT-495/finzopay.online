import RPPlan from "../../models/rpPlanModel.js";
import Wallet from "../../models/walletModel.js";
import BuyTransaction from "../../models/buyTransactionModel.js";
import Commission from "../../models/commissionModel.js";
import Ledger from "../../models/ledgerModel.js";

// GET RP PLANS (USER) + CURRENT BALANCE
export const getRPPlans = async (req, res) => {
    try {
        const userId = req.user.id;

        if (!userId) {
            res.status(500).json({ success: false, message: "User not found" });
        }

        const plans = await RPPlan.find({ status: true }).sort({ rp_amount: 1 });

        let wallet = await Wallet.findOne({ userId });
        if (!wallet) {
            wallet = await Wallet.create({
                userId,
                total_rp: 0,
                locked_rp: 0
            });
        }

        res.json({
            success: true,
            data: {
                plans,
                wallet: {
                    total_rp: wallet.total_rp,
                    locked_rp: wallet.locked_rp,
                    available_rp: wallet.total_rp
                }
            }
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

// GET ALL PLANS
export const getAllRPPlans = async (req, res) => {
    try {
        const plans = await RPPlan.find({ status: true });

        res.json({
            success: true,
            data: plans
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// BUY RP (AFTER PAYMENT SUCCESS)
// export const buyRP = async (req, res) => {
//     try {
//         console.log("buy rp api hit");
//         const userId = req.user.id; // auth middleware se
//         const { planId, payment_id } = req.body;

//         if (!userId) {
//             res.status(500).json({ success: false, message: "User not found" });
//         }

//         const plan = await RPPlan.findById(planId);
//         if (!plan) {
//             return res.status(404).json({ success: false, message: "Plan not found" });
//         }

//         const commissionRP =
//             (plan.rp_amount * plan.commission_percent) / 100;

//         const totalRP = plan.rp_amount + commissionRP;

//         // WALLET
//         let wallet = await Wallet.findOne({ userId });
//         if (!wallet) {
//             wallet = await Wallet.create({ userId });
//         }

//         wallet.total_rp += totalRP;
//         await wallet.save();

//         // BUY TRANSACTION
//         const transaction = await BuyTransaction.create({
//             userId,
//             planId,
//             amount_paid: plan.price,
//             rp_bought: plan.rp_amount,
//             commission_percent: plan.commission_percent,
//             commission_rp: commissionRP,
//             total_rp_credit: totalRP,
//             payment_id,
//             status: "pending"
//         });

//         // COMMISSION ENTRY
//         await Commission.create({
//             userId,
//             source: "buy_rp",
//             rp_amount: commissionRP
//         });

//         // LEDGER ENTRY
//         await Ledger.create({
//             userId,
//             type: "credit",
//             reason: "buy_rp",
//             rp: totalRP,
//             balance_after: wallet.total_rp,
//             ref_id: transaction._id
//         });

//         res.status(201).json({
//             success: true,
//             message: "RP purchased successfully",
//             wallet_balance: wallet.total_rp
//         });

//     } catch (err) {
//         console.log("error is here, buy rp");
//         console.log(err)
//         res.status(500).json({ success: false, message: err });
//     }
// };

// CREATE BUY REQUEST (PENDING)
export const createBuyRPRequest = async (req, res) => {
    try {
        const userId = req.user.id;
        const { planId, payment_id, amount } = req.body;

        if (!userId || !planId || !payment_id || !amount) {
            return res.status(400).json({
                success: false,
                message: "All fields are required"
            });
        }

        const plan = await RPPlan.findById(planId);
        if (!plan) {
            return res.status(404).json({
                success: false,
                message: "Plan not found"
            });
        }

        const transaction = await BuyTransaction.create({
            userId,
            planId,
            amount_paid: amount,
            payment_id,
            status: "pending"
        });

        res.status(201).json({
            success: true,
            message: "Request submitted. Waiting for admin approval.",
            data: transaction
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

// Buy RP History
export const getBuyRPHistory = async (req, res) => {
    try {
        const userId = req.user.id;

        if (!userId) {
            res.status(500).json({ success: false, message: "User not found" });
        }

        const history = await BuyTransaction.find({ userId })
            .populate("planId", "rp_amount commission_percent")
            .sort({ createdAt: -1 });

        const formatted = history.map(txn => {
            const base_rp = txn.rp_bought !== undefined && txn.rp_bought !== null
                ? txn.rp_bought
                : (txn.planId ? txn.planId.rp_amount : 0);

            const commission_percent = txn.commission_percent !== undefined && txn.commission_percent !== null
                ? txn.commission_percent
                : (txn.planId ? txn.planId.commission_percent : 0);

            const commission_rp = txn.commission_rp !== undefined && txn.commission_rp !== null
                ? txn.commission_rp
                : Math.trunc((base_rp * commission_percent) / 100);

            const total_rp = txn.total_rp_credit !== undefined && txn.total_rp_credit !== null
                ? txn.total_rp_credit
                : (base_rp + commission_rp);

            return {
                id: txn._id,
                payment_id: txn.payment_id,
                payment_amount: txn.amount_paid,
                status: txn.status === "success" ? "received" : txn.status,

                rp_received: {
                    base_rp,
                    commission_rp,
                    total_rp
                },

                createdAt: txn.createdAt
            };
        });

        res.json({
            success: true,
            data: formatted
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
