import mongoose from "mongoose";

const paymentSchema = new mongoose.Schema({
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User"
    },
    planId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Plan"
    },
    order_id: String,
    gateway_txn_id: String,

    amount: Number,
    currency: {
        type: String,
        default: "INR"
    },

    status: {
        type: String,
        enum: ["created", "success", "failed"],
        default: "created"
    },

    raw_response: Object

}, { timestamps: true });

//
// 🧠 AUTO-NORMALIZE BEFORE SAVE
//
paymentSchema.pre("save", function () {
    this.amount = Math.trunc(this.amount);
});

//
// 🔒 SAFE API OUTPUT (NO DECIMAL EVER)
//
paymentSchema.methods.toJSON = function () {
    const obj = this.toObject();
    obj.amount = Math.trunc(obj.amount);
    return obj;
};

//
// 🔁 USEFUL INDEX (OPTIONAL BUT GOOD)
//
paymentSchema.index({ userId: 1, createdAt: -1 });

export default mongoose.model("Payment", paymentSchema);
