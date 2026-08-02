import Wallet from "../../models/walletModel.js";
import SellRequest from "../../models/sellRequestModel.js";
import BankAccount from "../../models/bankAccountModel.js";
import Ledger from "../../models/ledgerModel.js";



// GET SELL PAGE DATA (BALANCE + BANKS)
export const getSellPageData = async (req, res) => {
    try {
        const userId = req.user.id;

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
           BANK ACCOUNTS
        ===================== */
        const banks = await BankAccount.find({ userId }).sort({
            is_default: -1,
            createdAt: -1
        });

        const bankData =
            banks.length > 0
                ? {
                    hasBank: true,
                    list: banks
                }
                : {
                    hasBank: false,
                    message: "No bank account added yet",
                    list: []
                };

        /* =====================
           RESPONSE
        ===================== */
        res.status(200).json({
            success: true,
            message: "Sell page data fetched successfully",
            data: {
                balance: {
                    total_rp: wallet.total_rp,
                    locked_rp: wallet.locked_rp,
                    available_rp: wallet.total_rp
                },
                bank: bankData
            }
        });

    } catch (err) {
        res.status(500).json({
            success: false,
            message: err.message
        });
    }
};

// Create Sell Request
export const createSellRequest = async (req, res) => {
    try {
        const userId = req.user.id;
        let { rp_amount, bankAccountId } = req.body;
        rp_amount = Number(rp_amount)

        if (!userId) {
            return res.status(500).json({ success: false, message: "User not found" });
        }

        const phone = req.user?.phone;
        if (!phone || phone.trim() === "") {
            return res.status(400).json({
                success: false,
                message: "Mobile number is compulsory to request a withdrawal. Please update your profile."
            });
        }

        if (!rp_amount || isNaN(rp_amount) || rp_amount <= 0 || !isFinite(rp_amount)) {
            return res.status(400).json({ success: false, message: "Invalid RP amount" });
        }

        // Check bank account
        const bank = await BankAccount.findOne({
            _id: bankAccountId,
            userId
        });

        if (!bank) {
            return res.status(404).json({ success: false, message: "Bank account not found" });
        }

        // Wallet
        const wallet = await Wallet.findOne({ userId });
        if (!wallet || wallet.total_rp < rp_amount) {
            return res.status(400).json({ success: false, message: "Insufficient RP balance" });
        }

        // LOCK RP
        wallet.total_rp -= rp_amount;
        wallet.locked_rp += rp_amount;
        await wallet.save();

        // CREATE SELL REQUEST
        const sellRequest = await SellRequest.create({
            userId,
            bankAccountId,
            rp_amount,
            money_amount: rp_amount, // 1 RP = ₹1 (change later if needed)
            status: "pending"
        });

        // LEDGER (DEBIT)
        await Ledger.create({
            userId,
            type: "debit",
            reason: "sell_rp",
            rp: rp_amount,
            balance_after: wallet.total_rp,
            ref_id: sellRequest._id
        });

        res.status(201).json({
            success: true,
            message: "Sell request submitted successfully",
            sellRequestId: sellRequest._id
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};


// Sell RP History
export const getSellRPHistory = async (req, res) => {
    try {
        const userId = req.user.id;

        if (!userId) {
            res.status(500).json({ success: false, message: "User not found" });
        }

        const history = await SellRequest.find({ userId })
            .populate("bankAccountId", "bank_name account_number")
            .sort({ createdAt: -1 });

        const formatted = history.map(reqItem => ({
            id: reqItem._id,
            rp_sold: reqItem.rp_amount,
            amount: reqItem.money_amount,
            status: reqItem.status,

            bank: reqItem.bankAccountId
                ? {
                    bank_name: reqItem.bankAccountId.bank_name,
                    account_last4: reqItem.bankAccountId.account_number.slice(-4)
                }
                : null,

            requestedAt: reqItem.createdAt
        }));

        res.json({
            success: true,
            data: formatted
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
