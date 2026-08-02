import mongoose from "mongoose";

const socialSchema = new mongoose.Schema({

    supportTelegram: String,
    supportWhatsapp: String,

    officialTelegram: String,
    officialWhatsapp: String,

}, { timestamps: true });

export default mongoose.model("SocialLink", socialSchema);
