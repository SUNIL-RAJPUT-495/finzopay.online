import mongoose from "mongoose";

const buyTransactionSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },

    planId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "RPPlan"
    },

    amount_paid: Number,
    rp_bought: Number,

    commission_percent: Number,
    commission_rp: Number,
    total_rp_credit: Number,

    payment_id: String,

    status: {
        type: String,
        enum: ["pending", "success", "failed"],
        default: "pending"
    }

}, { timestamps: true });

//
// 🔥🔥 AUTO INTEGER NORMALIZATION (MOST IMPORTANT PART)
//
buyTransactionSchema.pre("save", function () {
    this.amount_paid = Math.trunc(this.amount_paid);
    this.rp_bought = Math.trunc(this.rp_bought);
    this.commission_rp = Math.trunc(this.commission_rp);
    this.total_rp_credit = Math.trunc(this.total_rp_credit);
});

//
// 🔒 EXTRA SAFETY: RESPONSE LEVEL (API OUTPUT)
//
buyTransactionSchema.methods.toJSON = function () {
    const obj = this.toObject();

    obj.amount_paid = Math.trunc(obj.amount_paid);
    obj.rp_bought = Math.trunc(obj.rp_bought);
    obj.commission_rp = Math.trunc(obj.commission_rp);
    obj.total_rp_credit = Math.trunc(obj.total_rp_credit);

    return obj;
};

const BuyTransaction = mongoose.model("BuyTransaction", buyTransactionSchema);
export default BuyTransaction;