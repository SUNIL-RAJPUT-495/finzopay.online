import mongoose from "mongoose";

const rpPlanSchema = new mongoose.Schema({
    title: String, // e.g. "Basic Plan"

    rp_amount: Number, // 100 RP
    price: Number,     // ₹100

    commission_percent: Number, // 5%

    status: {
        type: Boolean,
        default: true
    }

}, { timestamps: true });

const RPPlan = mongoose.model("RPPlan", rpPlanSchema);
export default RPPlan