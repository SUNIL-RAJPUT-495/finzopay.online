import SellRequest from "../../models/sellRequestModel.js";
import Wallet from "../../models/walletModel.js";

// GET ALL PENDING SELL REQUESTS
export const getPendingSellRequests = async (req, res) => {
    try {
        const requests = await SellRequest.find({ status: "pending" })
            .populate("userId", "name email phone")
            .populate("bankAccountId");

        res.json({ success: true, data: requests });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// MARK AS PAID
export const markSellAsPaid = async (req, res) => {
    try {
        const { id } = req.params;

        const sellRequest = await SellRequest.findById(id);
        if (!sellRequest) {
            return res.status(404).json({ success: false, message: "Sell request not found" });
        }

        if (sellRequest.status !== "pending") {
            return res.status(400).json({ success: false, message: "Invalid request state" });
        }

        const wallet = await Wallet.findOne({ userId: sellRequest.userId });

        // UNLOCK RP (FINAL)
        wallet.locked_rp -= sellRequest.rp_amount;
        await wallet.save();

        sellRequest.status = "paid";
        await sellRequest.save();

        res.json({
            success: true,
            message: "Sell request marked as paid"
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};

// REJECT SELL REQUEST
export const rejectSellRequest = async (req, res) => {
    try {
        const { id } = req.params;
        const { admin_note } = req.body;

        const sellRequest = await SellRequest.findById(id);
        if (!sellRequest) {
            return res.status(404).json({ success: false, message: "Sell request not found" });
        }

        if (sellRequest.status !== "pending") {
            return res.status(400).json({ success: false, message: "Invalid request state" });
        }

        const wallet = await Wallet.findOne({ userId: sellRequest.userId });

        // REFUND RP
        wallet.locked_rp -= sellRequest.rp_amount;
        wallet.total_rp += sellRequest.rp_amount;
        await wallet.save();

        sellRequest.status = "rejected";
        sellRequest.admin_note = admin_note;
        await sellRequest.save();

        res.json({
            success: true,
            message: "Sell request rejected and RP refunded"
        });

    } catch (err) {
        res.status(500).json({ success: false, message: err.message });
    }
};
