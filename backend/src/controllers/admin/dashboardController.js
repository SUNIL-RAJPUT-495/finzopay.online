import User from "../../models/userModel.js";
import BuyTransaction from "../../models/buyTransactionModel.js";
import SellRequest from "../../models/sellRequestModel.js";
import Commission from "../../models/commissionModel.js";

export const getDashboardStats = async (req, res) => {
    try {
        /* =====================
           DATE RANGE (TODAY)
        ===================== */
        const startOfDay = new Date();
        startOfDay.setHours(0, 0, 0, 0);

        const endOfDay = new Date();
        endOfDay.setHours(23, 59, 59, 999);

        /* =====================
           TODAY TRANSACTIONS
        ===================== */
        const todayTxnAgg = await BuyTransaction.aggregate([
            {
                $match: {
                    status: "success",
                    createdAt: { $gte: startOfDay, $lte: endOfDay },
                },
            },
            {
                $group: {
                    _id: null,
                    totalAmount: { $sum: "$amount_paid" },
                },
            },
        ]);

        const todayTransactions =
            todayTxnAgg.length > 0 ? todayTxnAgg[0].totalAmount : 0;

        /* =====================
           TODAY COMMISSION
        ===================== */
        const todayCommissionAgg = await BuyTransaction.aggregate([
            {
                $match: {
                    status: "success",
                    createdAt: { $gte: startOfDay, $lte: endOfDay },
                },
            },
            {
                $group: {
                    _id: null,
                    totalCommission: { $sum: "$commission_rp" },
                },
            },
        ]);

        const todayCommission =
            todayCommissionAgg.length > 0
                ? todayCommissionAgg[0].totalCommission
                : 0;

        /* =====================
           NEW USERS TODAY
        ===================== */
        const newUsersToday = await User.countDocuments({
            role: "user",
            createdAt: { $gte: startOfDay, $lte: endOfDay },
        });

        /* =====================
           TOTAL USERS
        ===================== */
        const totalUsers = await User.countDocuments({ role: "user" });

        /* =====================
           TOTAL TRANSACTIONS
        ===================== */
        const totalTxnAgg = await BuyTransaction.aggregate([
            {
                $match: { status: "success" },
            },
            {
                $group: {
                    _id: null,
                    totalAmount: { $sum: "$amount_paid" },
                },
            },
        ]);

        const totalTransactions =
            totalTxnAgg.length > 0 ? totalTxnAgg[0].totalAmount : 0;

        /* =====================
           TOTAL RP SOLD
        ===================== */
        const totalSoldAgg = await SellRequest.aggregate([
            {
                $match: { status: "paid" },
            },
            {
                $group: {
                    _id: null,
                    totalRpSold: { $sum: "$rp_amount" },
                },
            },
        ]);

        const totalRpSold =
            totalSoldAgg.length > 0 ? totalSoldAgg[0].totalRpSold : 0;

        /* =====================
           TOTAL COMMISSION
        ===================== */
        const totalCommissionAgg = await BuyTransaction.aggregate([
            {
                $match: { status: "success" },
            },
            {
                $group: {
                    _id: null,
                    totalCommission: { $sum: "$commission_rp" },
                },
            },
        ]);

        const totalCommission =
            totalCommissionAgg.length > 0
                ? totalCommissionAgg[0].totalCommission
                : 0;

        /* =====================
           RESPONSE
        ===================== */
        res.status(200).json({
            success: true,
            data: {
                today: {
                    transactions: todayTransactions,
                    commission: todayCommission,
                    newUsers: newUsersToday,
                },
                overall: {
                    totalUsers,
                    totalTransactions,
                    totalRpSold,
                    totalCommission,
                },
            },
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: "Server Error",
            error: error.message,
        });
    }
};
