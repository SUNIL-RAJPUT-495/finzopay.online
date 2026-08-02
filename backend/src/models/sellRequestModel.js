import mongoose from "mongoose";

const sellRequestSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    bankAccountId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "BankAccount"
    },

    rp_amount: Number,
    money_amount: Number,

    status: {
        type: String,
        enum: ["pending", "approved", "paid", "rejected"],
        default: "pending"
    },

    admin_note: String

}, { timestamps: true });

const SellRequest = mongoose.model("SellRequest", sellRequestSchema);
export default SellRequest;