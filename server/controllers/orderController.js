const Order = require('../models/Order');
const Store = require('../models/Store');
const User = require('../models/User');
const Product = require('../models/Product');

// ─── Buyer: place an order ────────────────────────────────────────────────────
exports.placeOrder = async (req, res) => {
    try {
        const buyerUid = req.user.uid;
        const { storeId, items, shippingAddress } = req.body;

        if (!storeId || !items || !items.length || !shippingAddress) {
            return res.status(400).json({ message: 'storeId, items, and shippingAddress are required' });
        }

        const buyer = await User.findOne({ firebaseUid: buyerUid });
        if (!buyer) return res.status(404).json({ message: 'Buyer profile not found. Sync first.' });

        const store = await Store.findById(storeId);
        if (!store || !store.isActive) return res.status(404).json({ message: 'Store not found' });

        // Validate items and calculate total
        let totalAmount = 0;
        const orderItems = [];
        for (const item of items) {
            const product = await Product.findById(item.productId);
            if (!product || !product.isActive) continue;
            const qty = Math.max(1, parseInt(item.quantity) || 1);
            totalAmount += product.price * qty;
            orderItems.push({
                productId: product._id,
                name: product.name,
                price: product.price,
                quantity: qty,
                imageUrl: product.imageUrl || '',
            });
        }

        if (!orderItems.length) return res.status(400).json({ message: 'No valid products in order' });

        const order = await Order.create({
            buyerFirebaseUid: buyerUid,
            buyerName: buyer.name,
            buyerEmail: buyer.email,
            buyerPhone: buyer.phone || '',
            sellerFirebaseUid: store.sellerFirebaseUid,
            storeId: store._id,
            items: orderItems,
            totalAmount,
            shippingAddress: shippingAddress.trim(),
            sellerJazzcashNumber: store.jazzcashNumber,
            status: 'pending',
        });

        res.status(201).json(order);
    } catch (error) {
        console.error('placeOrder:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Buyer: upload payment screenshot ─────────────────────────────────────────
exports.uploadPaymentProof = async (req, res) => {
    try {
        const buyerUid = req.user.uid;
        const { orderId, paymentScreenshotUrl } = req.body;

        if (!orderId || !paymentScreenshotUrl) {
            return res.status(400).json({ message: 'orderId and paymentScreenshotUrl are required' });
        }

        const order = await Order.findById(orderId);
        if (!order) return res.status(404).json({ message: 'Order not found' });
        if (order.buyerFirebaseUid !== buyerUid) {
            return res.status(403).json({ message: 'Not your order' });
        }
        if (order.status !== 'pending') {
            return res.status(400).json({ message: 'Payment proof can only be uploaded for pending orders' });
        }

        order.paymentScreenshotUrl = paymentScreenshotUrl.trim();
        order.status = 'paid';
        order.updated_at = Date.now();
        await order.save();

        res.status(200).json(order);
    } catch (error) {
        console.error('uploadPaymentProof:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Buyer: get my orders ─────────────────────────────────────────────────────
exports.getMyOrders = async (req, res) => {
    try {
        const orders = await Order.find({ buyerFirebaseUid: req.user.uid }).sort({ created_at: -1 });
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Seller: get orders for my store ──────────────────────────────────────────
exports.getSellerOrders = async (req, res) => {
    try {
        const orders = await Order.find({ sellerFirebaseUid: req.user.uid }).sort({ created_at: -1 });
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Seller: verify payment → confirm order ───────────────────────────────────
exports.confirmOrder = async (req, res) => {
    try {
        const sellerUid = req.user.uid;
        const { orderId } = req.body;

        const order = await Order.findById(orderId);
        if (!order) return res.status(404).json({ message: 'Order not found' });
        if (order.sellerFirebaseUid !== sellerUid) {
            return res.status(403).json({ message: 'Not your store order' });
        }
        if (order.status !== 'paid') {
            return res.status(400).json({ message: 'Only paid orders can be confirmed' });
        }

        order.status = 'confirmed';
        order.updated_at = Date.now();
        await order.save();

        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Seller: update order status (shipped / delivered) ────────────────────────
exports.updateOrderStatus = async (req, res) => {
    try {
        const sellerUid = req.user.uid;
        const { orderId, status } = req.body;

        const allowed = ['shipped', 'delivered'];
        if (!allowed.includes(status)) {
            return res.status(400).json({ message: 'Status must be shipped or delivered' });
        }

        const order = await Order.findById(orderId);
        if (!order) return res.status(404).json({ message: 'Order not found' });
        if (order.sellerFirebaseUid !== sellerUid) {
            return res.status(403).json({ message: 'Not your store order' });
        }

        order.status = status;
        order.updated_at = Date.now();
        await order.save();

        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Cancel order (buyer or seller) ───────────────────────────────────────────
exports.cancelOrder = async (req, res) => {
    try {
        const uid = req.user.uid;
        const { orderId } = req.body;

        const order = await Order.findById(orderId);
        if (!order) return res.status(404).json({ message: 'Order not found' });

        const isBuyer = order.buyerFirebaseUid === uid;
        const isSeller = order.sellerFirebaseUid === uid;
        if (!isBuyer && !isSeller) {
            return res.status(403).json({ message: 'Unauthorized' });
        }

        if (['delivered', 'cancelled'].includes(order.status)) {
            return res.status(400).json({ message: 'Cannot cancel this order' });
        }

        order.status = 'cancelled';
        order.updated_at = Date.now();
        await order.save();

        res.status(200).json(order);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Admin: get all orders ────────────────────────────────────────────────────
exports.getAllOrders = async (req, res) => {
    try {
        const admin = await User.findOne({ firebaseUid: req.user.uid });
        if (!admin || admin.role !== 'admin') {
            return res.status(403).json({ message: 'Admin access required' });
        }
        const orders = await Order.find().sort({ created_at: -1 });
        res.status(200).json(orders);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};
