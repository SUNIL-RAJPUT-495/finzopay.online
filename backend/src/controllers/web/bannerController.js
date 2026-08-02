import { uploadToCloudinary } from "../../config/cloudinary.js";
import Banner from "../../models/banner.js";

// Get all Banners
export const getWebBanner = async (req, res) => {
    try {
        const banners = await Banner.find().sort({ createdAt: -1 });
        res.json(banners);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
