import Wallet from "../../models/walletModel.js";
import Commission from "../../models/commissionModel.js";
import BuyTransaction from "../../models/buyTransactionModel.js";
import SellRequest from "../../models/sellRequestModel.js";
import BankAccount from "../../models/bankAccountModel.js";
import Banner from "../../models/banner.js";
import banner from "../../models/banner.js";


// Get Home Data
export const getHome = async (req, res) => {
    try {
        const userId = req.user.id;

        if (!userId) {
            res.status(500).json({ success: false, message: "User not found" });
        }

        /* =====================
           WALLET
        ===================== */
        let wallet = await Wallet.findOne({ userId });
        if (!wallet) {
            wallet = await Wallet.create({
                userId,
                total_rp: 0,
                locked_rp: 0
            });
        }

        /* =====================
           TODAY RANGE
        ===================== */
        const startOfDay = new Date();
        startOfDay.setHours(0, 0, 0, 0);

        const endOfDay = new Date();
        endOfDay.setHours(23, 59, 59, 999);

        /* =====================
           TODAY COMMISSION
        ===================== */
        const todayCommissionAgg = await Commission.aggregate([
            {
                $match: {
                    userId: wallet.userId,
                    createdAt: { $gte: startOfDay, $lte: endOfDay }
                }
            },
            {
                $group: {
                    _id: null,
                    total: { $sum: "$rp_amount" }
                }
            }
        ]);

        const todayCommission =
            todayCommissionAgg.length > 0 ? todayCommissionAgg[0].total : 0;

        /* =====================
           TODAY BUY STATS
        ===================== */
        const todayBuyAgg = await BuyTransaction.aggregate([
            {
                $match: {
                    userId: wallet.userId,
                    status: "success",
                    createdAt: { $gte: startOfDay, $lte: endOfDay }
                }
            },
            {
                $group: {
                    _id: null,
                    totalAmount: { $sum: "$amount_paid" },
                    count: { $sum: 1 }
                }
            }
        ]);

        /* =====================
           TODAY SELL STATS
        ===================== */
        const todaySellAgg = await SellRequest.aggregate([
            {
                $match: {
                    userId: wallet.userId,
                    status: "paid",
                    createdAt: { $gte: startOfDay, $lte: endOfDay }
                }
            },
            {
                $group: {
                    _id: null,
                    totalAmount: { $sum: "$money_amount" }
                }
            }
        ]);

        /* =====================
           BANK ACCOUNT
        ===================== */
        const bankAccounts = await BankAccount.find({ userId }).sort({
            is_default: -1,
            createdAt: -1
        });

        const bankData =
            bankAccounts.length > 0
                ? {
                    hasBank: true,
                    accounts: bankAccounts
                }
                : {
                    hasBank: false,
                    message: "No bank account added yet"
                };

        /* =====================
           BANNERS (STATIC / ADMIN LATER)
        ===================== */

        let bannersData = await banner.find().select("imageUrl");
        const banners = bannersData.map((item, index) => ({
            id: index + 1,
            image: item.imageUrl
        }));
        // const banners = [
        //     { id: 1, image: "https://images.pexels.com/photos/4386373/pexels-photo-4386373.jpeg?auto=compress&cs=tinysrgb&w=1200" },
        //     { id: 2, image: "https://images.pexels.com/photos/259027/pexels-photo-259027.jpeg?auto=compress&cs=tinysrgb&w=1200" },
        //     { id: 3, image: "https://images.pexels.com/photos/4968631/pexels-photo-4968631.jpeg?auto=compress&cs=tinysrgb&w=1200" }
        // ];

        /* =====================
           RESPONSE
        ===================== */
        res.status(200).json({
            success: true,
            message: "Home data fetched successfully",
            data: {
                wallet: {
                    totalBalance: wallet.total_rp,
                    lockedBalance: wallet.locked_rp,
                    availableBalance: wallet.total_rp
                },

                todayCommission,

                todayStats: {
                    buyQuantity:
                        todayBuyAgg.length > 0 ? todayBuyAgg[0].count : 0,
                    buyAmount:
                        todayBuyAgg.length > 0 ? todayBuyAgg[0].totalAmount : 0,
                    sellToday:
                        todaySellAgg.length > 0 ? todaySellAgg[0].totalAmount : 0
                },

                bank: bankData,
                banners
            }
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};



// Get all Banners
export const getHomeBanner = async (req, res) => {
    try {
        const banners = await Banner.find().sort({ createdAt: -1 });
        res.json(banners);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
