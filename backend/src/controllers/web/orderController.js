import Order from '../../models/orderModel.js';
import Cart from '../../models/cartModel.js';
import Address from '../../models/addressModel.js';

export const createCODOrder = async (req, res) => {
    try {
        const userId = req.user.id;
        const { shippingAddressId } = req.body;

        const cart = await Cart.findOne({ user: userId }).populate("items.product");
        if (!cart || cart.items.length === 0) {
            return res.status(400).json({ success: false, message: "Cart is empty." });
        }

        const address = await Address.findOne({ _id: shippingAddressId, userId });
        if (!address) {
            return res.status(404).json({ success: false, message: "Shipping address not found." });
        }

        const orderItems = cart.items.map((item) => ({
            productId: item.product._id,
            name: item.product.name,
            image: item.product.images?.[0],
            price: item.price,
            quantity: item.quantity,
        }));

        // Generate orderId
        const orderCount = await Order.countDocuments();
        const nextNumber = orderCount + 1;
        const orderId = `Ord_${nextNumber.toString().padStart(5, "0")}`;

        const orderDoc = await Order.create({
            userId,
            orderId,
            items: orderItems,
            shippingAddress: {
                name: address.name,
                phone: address.phone,
                streetAddress: address.streetAddress,
                city: address.city,
                state: address.state,
                zipCode: address.zipCode,
            },
            totalAmount: cart.totalAmount,
            orderStatus: "Pending",
            paymentInfo: {
                paymentId: null,
                status: "Pending",
                method: "COD",
            },
        });

        await Cart.findOneAndDelete({ user: userId });

        return res.status(201).json({ success: true, order: orderDoc });
    } catch (err) {
        return res.status(500).json({ success: false, message: err.message });
    }
};


// get orders fro logged-in user
export const getMyOrders = async (req, res) => {
    try {
        const orders = await Order.find({ userId: req.user.id }).sort({ createdAt: -1 });

        res.status(200).json({
            success: true,
            count: orders.length,
            orders,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error.', error: error.message });
    }
};

// get order by id for logged-in user
export const getOrderById = async (req, res) => {
    try {
        // Find the order and ensure it belongs to the logged-in user
        const order = await Order.findOne({ _id: req.params.id, userId: req.user.id });

        if (!order) {
            return res.status(404).json({ success: false, message: 'Order not found.' });
        }

        res.status(200).json({
            success: true,
            order,
        });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Server Error.', error: error.message });
    }
};