import { uploadToCloudinary } from "../../config/cloudinary.js";
import Offer from "../../models/offer.js";


// Get all Offers
export const getWebOffer = async (req, res) => {
    try {
        const offers = await Offer.find().sort({ createdAt: -1 });
        res.json(offers);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
