import mongoose from "mongoose";

const bannerSchema = new mongoose.Schema(
    {
        imageUrl: { type: String, required: true }, // Cloud/Local path
        status: { type: Boolean, default: true },   // Active / Inactive
    },
    { timestamps: true }
);

export default mongoose.model("Banner", bannerSchema);