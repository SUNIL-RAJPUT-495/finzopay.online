import Cart from '../../models/cartModel.js';
import Product from '../../models/productModel.js';

// ✅ Get cart for logged-in user
export const getCart = async (req, res) => {
    try {
        const userId = req.user.id;

        let cart = await Cart.findOne({ userId: userId }).populate({
            path: 'items.product',
            select: 'name images slug price in_stock'
        });

        if (!cart) {
            return res.status(200).json({
                success: true,
                message: 'Cart is empty.',
                cart: { items: [], totalAmount: 0 }
            });
        }

        res.status(200).json({ success: true, cart });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// ✅ Add item to logged-in user's cart
export const addItemToCart = async (req, res) => {
    const { productId, quantity } = req.body;
    if (!productId || !quantity || quantity < 1) {
        return res.status(400).json({ success: false, message: 'Invalid product ID or quantity.' });
    }

    try {
        const userId = req.user.id;

        const product = await Product.findById(productId);
        if (!product || !product.isActive || product.isDeleted) {
            return res.status(404).json({ success: false, message: 'Product not found or unavailable.' });
        }

        let cart = await Cart.findOne({ userId: userId });
        if (!cart) {
            cart = new Cart({ userId: userId, items: [] });
        }

        const existingItemIndex = cart.items.findIndex(item => item.product.equals(productId));

        if (existingItemIndex > -1) {
            cart.items[existingItemIndex].quantity = quantity;
        } else {
            cart.items.push({
                product: productId,
                quantity,
                price: product.price
            });
        }

        const updatedCart = await cart.save();
        await updatedCart.populate({
            path: 'items.product',
            select: 'name slug price images in_stock'
        });

        res.status(200).json({ success: true, message: 'Cart updated successfully.', cart: updatedCart });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// ✅ Remove item from cart
export const removeItemFromCart = async (req, res) => {
    const { productId } = req.params;

    try {
        const userId = req.user.id;
        let cart = await Cart.findOne({ userId: userId });

        if (!cart) {
            return res.status(404).json({ success: false, message: 'Cart not found.' });
        }

        cart.items = cart.items.filter(item => !item.product.equals(productId));

        const updatedCart = await cart.save();
        await updatedCart.populate({
            path: 'items.product',
            select: 'name slug price images in_stock'
        });

        res.status(200).json({ success: true, message: 'Item removed.', cart: updatedCart });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error', error: error.message });
    }
};

// ✅ Merge localStorage cart into user cart on login
export const mergeCart = async (req, res) => {
    const { items } = req.body; // array of { product, quantity }
    const userId = req.user.id;

    if (!Array.isArray(items)) {
        return res.status(400).json({ success: false, message: 'Items array is required.' });
    }

    try {
        let userCart = await Cart.findOne({ userId: userId });
        if (!userCart) {
            userCart = new Cart({ userId: userId, items: [] });
        }

        for (const newItem of items) {
            const userItemIndex = userCart.items.findIndex(item =>
                item.product.equals(newItem.product)
            );

            if (userItemIndex > -1) {
                userCart.items[userItemIndex].quantity += newItem.quantity;
            } else {
                const product = await Product.findById(newItem.product);
                if (product && product.isActive && !product.isDeleted) {
                    userCart.items.push({
                        product: newItem.product,
                        quantity: newItem.quantity,
                        price: product.price
                    });
                }
            }
        }

        const mergedCart = await userCart.save();
        await mergedCart.populate({
            path: 'items.product',
            select: 'name slug price images in_stock'
        });

        res.status(200).json({ success: true, message: 'Cart merged successfully.', cart: mergedCart });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error during merge.', error: error.message });
    }
};
