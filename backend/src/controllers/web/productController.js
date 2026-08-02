import Product from '../../models/productModel.js';
import Category from '../../models/categoryModel.js';


export const getAllProducts = async (req, res) => {
    try {
        // --- 1. PAGINATION ---
        const page = Number(req.query.page) || 1;
        const limit = Number(req.query.limit) || 12;
        const skip = (page - 1) * limit;

        // --- 2. BUILD FILTER OBJECT ---
        const filter = { isActive: true, isDeleted: false };

        // Filter by search query (q)
        if (req.query.q == "all" || !req.query.q || req.query.q.trim() === "" || req.query.q.toLowerCase() === "null") {
            filter.name = { $exists: true };
        } else {
            filter.name = { $regex: req.query.q || '', $options: 'i' };
        }

        // Filter by category slug
        if (req.query.category) {
            const slugs = req.query.category.split(',');
            const categories = await Category.find({ slug: { $in: slugs } });
            if (categories.length > 0) {
                filter.categoryId = { $in: categories.map(c => c._id) };
            } else {
                return res.status(200).json({ products: [], page: 1, totalPages: 0, totalProducts: 0 });
            }
        }

        // Filter by tag
        if (req.query.tag) {
            filter.tags = { $regex: req.query.tag, $options: 'i' };
        }

        // Filter by price range
        if (req.query.minPrice || req.query.maxPrice) {
            filter.price = {};
            if (req.query.minPrice) {
                filter.price.$gte = Number(req.query.minPrice);
            }
            if (req.query.maxPrice) {
                filter.price.$lte = Number(req.query.maxPrice);
            }
        }

        // --- 3. BUILD SORT OBJECT ---
        let sort = { createdAt: -1 }; // Default sort: newest first
        if (req.query.sort === 'price-asc') {
            sort = { price: 1 };
        } else if (req.query.sort === 'price-desc') {
            sort = { price: -1 };
        }

        // --- 4. EXECUTE QUERY ---
        const products = await Product.find(filter)
            .populate('categoryId', 'name slug') // Correct field name is 'category'
            .sort(sort)
            .skip(skip)
            .limit(limit);

        const totalProducts = await Product.countDocuments(filter);
        const totalPages = Math.ceil(totalProducts / limit);

        // --- 5. SEND RESPONSE ---
        res.status(200).json({
            products,
            page,
            totalPages,
            totalProducts,
        });

    } catch (error) {
        res.status(500).json({ message: 'Server Error', error: error.message });
    }
};



export const getProductBySlug = async (req, res) => {
    try {
        const product = await Product.findOne({ slug: req.params.slug, isDeleted: false })
            .populate('categoryId', 'name slug'); // Also populate category here

        if (!product) {
            return res.status(404).json({ message: 'Product not found' });
        }
        res.status(200).json(product);
    } catch (error) {
        res.status(500).json({ message: 'Server Error', error: error.message });
    }
};