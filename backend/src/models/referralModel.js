import mongoose from "mongoose";

const referralSchema = new mongoose.Schema({
    code: {
        type: String,
        unique: true,
        required: true,
        uppercase: true
    },

    validFrom: Date,
    validTill: Date,

    usageLimit: Number,
    usedCount: {
        type: Number,
        default: 0
    },

    status: {
        type: String,
        enum: ["ACTIVE", "DISABLED"],
        default: "ACTIVE"
    }

}, { timestamps: true });

export default mongoose.model("Referral", referralSchema);
