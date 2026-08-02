import User from "../../models/userModel.js";
import BuyTransaction from "../../models/buyTransactionModel.js";
import SellRequest from "../../models/sellRequestModel.js";
import Wallet from "../../models/walletModel.js";


export const getUsersList = async (req, res) => {
    try {
        const { search } = req.query;

        const matchStage = { role: "user" };

        if (search && search.trim() !== "") {
            matchStage.$or = [
                { name: { $regex: search, $options: "i" } },
                { phone: { $regex: search, $options: "i" } },
                { email: { $regex: search, $options: "i" } },
            ];
        }

        const users = await User.aggregate([
            { $match: matchStage },

            /* ================= BUY ================= */
            {
                $lookup: {
                    from: "buytransactions",
                    localField: "_id",
                    foreignField: "userId",
                    as: "buys",
                },
            },

            /* ================= SELL ================= */
            {
                $lookup: {
                    from: "sellrequests",
                    localField: "_id",
                    foreignField: "userId",
                    as: "sells",
                },
            },

            /* ================= CALCULATIONS ================= */
            {
                $addFields: {
                    // Total RP credited (including commission)
                    totalRpEarned: {
                        $sum: "$buys.total_rp_credit",
                    },

                    // Only commission RP
                    totalCommission: {
                        $sum: "$buys.commission_rp",
                    },

                    // Completed sells only
                    totalSoldRp: {
                        $sum: {
                            $map: {
                                input: {
                                    $filter: {
                                        input: "$sells",
                                        as: "s",
                                        cond: { $eq: ["$$s.status", "paid"] },
                                    },
                                },
                                as: "x",
                                in: "$$x.rp_amount",
                            },
                        },
                    },

                    // Pending sells only (locked)
                    lockedRp: {
                        $sum: {
                            $map: {
                                input: {
                                    $filter: {
                                        input: "$sells",
                                        as: "s",
                                        cond: { $eq: ["$$s.status", "pending"] },
                                    },
                                },
                                as: "x",
                                in: "$$x.rp_amount",
                            },
                        },
                    },
                },
            },

            /* ================= FINAL BALANCE ================= */
            {
                $addFields: {
                    availableBalance: {
                        $subtract: [
                            "$totalRpEarned",
                            { $add: ["$totalSoldRp", "$lockedRp"] },
                        ],
                    },
                },
            },

            /* ================= RESPONSE ================= */
            {
                $project: {
                    name: 1,
                    phone: 1,
                    email: 1,
                    isBlocked: 1,
                    createdAt: 1,

                    totalBalance: "$totalRpEarned",
                    lockedBalance: "$lockedRp",
                    availableBalance: 1,
                    commission: "$totalCommission",
                },
            },

            { $sort: { createdAt: -1 } },
        ]);

        res.status(200).json({
            success: true,
            data: users,
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message,
        });
    }
};


export const getUserDetails = async (req, res) => {
    try {
        const { userId } = req.params;

        const user = await User.findById(userId).select("-password -__v");
        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found"
            });
        }

        const wallet = await Wallet.findOne({ userId });

        const buyHistory = await BuyTransaction.find({ userId })
            .sort({ createdAt: -1 });

        const sellHistory = await SellRequest.find({ userId })
            .populate("bankAccountId", "bank_name account_number")
            .sort({ createdAt: -1 });

        res.status(200).json({
            success: true,
            data: {
                user,
                wallet: {
                    totalBalance: wallet?.total_rp || 0,
                    lockedBalance: wallet?.locked_rp || 0,
                    availableBalance:
                        (wallet?.total_rp || 0) - (wallet?.locked_rp || 0)
                },

                buyHistory: buyHistory.map(txn => ({
                    id: txn._id,
                    payment_id: txn.payment_id,
                    amount_paid: txn.amount_paid,
                    base_rp: txn.rp_bought,
                    commission_rp: txn.commission_rp,
                    total_rp: txn.total_rp_credit,
                    status: txn.status,
                    createdAt: txn.createdAt
                })),

                sellHistory: sellHistory.map(req => ({
                    id: req._id,
                    rp_sold: req.rp_amount,
                    amount: req.money_amount,
                    status: req.status,
                    bank: req.bankAccountId
                        ? {
                            bank_name: req.bankAccountId.bank_name,
                            account_last4:
                                req.bankAccountId.account_number.slice(-4)
                        }
                        : null,
                    createdAt: req.createdAt
                }))
            }
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};


export const toggleUserBlock = async (req, res) => {
    try {
        const { userId } = req.params;

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({
                success: false,
                message: "User not found",
            });
        }

        user.isBlocked = !user.isBlocked;
        await user.save();

        res.status(200).json({
            success: true,
            message: user.isBlocked
                ? "User blocked successfully"
                : "User unblocked successfully",
            isBlocked: user.isBlocked,
        });
    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message,
        });
    }
};


// get all users
// export const getAllUsers = async (req, res) => {
//     try {
//         const users = await User.find({ role: "user" });
//         res.status(200).json(users);
//     } catch (error) {
//         res.status(500).json({ message: 'Server Error', error: error.message });
//     }
// };
