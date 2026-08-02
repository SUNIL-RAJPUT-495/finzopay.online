import Category from '../../models/categoryModel.js';

// @desc    Get all active categories for the website
// @route   GET /api/v1/web/categories
export const getWebCategories = async (req, res) => {
    try {
        const categories = await Category.find({ isActive: true, isDeleted: false });
        res.status(200).json(categories);
    } catch (error) {
        res.status(500).json({ message: 'Server Error', error: error.message });
    }
};