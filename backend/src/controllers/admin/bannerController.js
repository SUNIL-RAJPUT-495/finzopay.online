import { uploadToCloudinary } from "../../config/cloudinary.js";
import Banner from "../../models/banner.js";

// Create Banner
export const createBanner = async (req, res) => {
    try {
        let imageUrl = '';
        if (req.file) {
            const result = await uploadToCloudinary(req.file.buffer,
                { folder: 'finzopay/banners', quality: "auto", fetch_format: "auto" });
            imageUrl = result.secure_url;
        }

        const banner = await Banner.create({ imageUrl });
        res.status(201).json(banner);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Get all Banners
export const getBanners = async (req, res) => {
    try {
        const banners = await Banner.find().sort({ createdAt: -1 });
        res.json(banners);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Update Banner
export const updateBanner = async (req, res) => {
    try {
        const { id } = req.params;
        const banner = await Banner.findByIdAndUpdate(id, req.body, { new: true });
        res.json(banner);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Delete Banner
export const deleteBanner = async (req, res) => {
    try {
        const { id } = req.params;
        await Banner.findByIdAndDelete(id);
        res.json({ message: "Banner deleted" });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
