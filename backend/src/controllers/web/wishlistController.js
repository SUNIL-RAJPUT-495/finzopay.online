import User from '../../models/userModel.js';
import Product from '../../models/productModel.js';



// get wishlist
export const getWishlist = async (req, res) => {
    try {
        const userId = req.user.id;

        const user = await User.findById(userId).populate({
            path: 'wishlist',
            select: 'name slug price images categoryId rating',
        });

        if (!user) {
            return res.status(404).json({ success: false, message: 'User not found.' });
        }

        res.status(200).json({
            success: true,
            wishlist: user.wishlist,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server error.', error: error.message });
    }
};

// add to wishlist
export const addToWishlist = async (req, res) => {
    try {
        const { productId } = req.body;
        const userId = req.user.id;

        const product = await Product.findById(productId);
        if (!product || product.isDeleted || !product.isActive) {
            return res.status(404).json({ success: false, message: 'Product not found or unavailable.' });
        }

        await User.findByIdAndUpdate(
            userId,
            { $addToSet: { wishlist: productId } },
            { new: true }
        );

        res.status(200).json({
            success: true,
            message: 'Product added to wishlist successfully.',
        });
    } catch (error) {
        res.status(400).json({ success: false, message: 'Failed to add to wishlist.', error: error.message });
    }
};

// remove from wishlist
export const removeFromWishlist = async (req, res) => {
    try {
        const { productId } = req.params;
        const userId = req.user.id;

        await User.findByIdAndUpdate(
            userId,
            { $pull: { wishlist: productId } },
            { new: true }
        );

        res.status(200).json({
            success: true,
            message: 'Product removed from wishlist successfully.',
        });
    } catch (error) {
        res.status(400).json({ success: false, message: 'Failed to remove from wishlist.', error: error.message });
    }
};