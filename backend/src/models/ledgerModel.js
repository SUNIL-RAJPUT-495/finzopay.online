import mongoose from "mongoose";

const ledgerSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    type: {
        type: String,
        enum: ["credit", "debit"]
    },

    reason: {
        type: String,
        enum: ["buy_rp", "commission", "sell_rp", "admin_adjust"]
    },

    rp: Number,
    balance_after: Number,

    ref_id: String

}, { timestamps: true });

//
// 🧠 AUTO NORMALIZE BEFORE SAVE
//
ledgerSchema.pre("save", function () {
    this.rp = Math.trunc(this.rp);
    this.balance_after = Math.trunc(this.balance_after);
});

//
// 🔒 API / RESPONSE SAFETY
//
ledgerSchema.methods.toJSON = function () {
    const obj = this.toObject();
    obj.rp = Math.trunc(obj.rp);
    obj.balance_after = Math.trunc(obj.balance_after);
    return obj;
};

const Leader = mongoose.model("Ledger", ledgerSchema);
export default Leader