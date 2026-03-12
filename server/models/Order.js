const mongoose = require('mongoose');

const orderItemSchema = mongoose.Schema({
    productId: { type: mongoose.Schema.Types.ObjectId, ref: 'product', required: true },
    name: { type: String, required: true },
    price: { type: Number, required: true },
    quantity: { type: Number, required: true, min: 1 },
    imageUrl: { type: String, default: '' }
});

const orderSchema = mongoose.Schema({
    buyerFirebaseUid: {
        type: String,
        required: true
    },
    buyerName: {
        type: String,
        required: true
    },
    buyerEmail: {
        type: String,
        required: true
    },
    buyerPhone: {
        type: String,
        default: ''
    },
    sellerFirebaseUid: {
        type: String,
        required: true
    },
    storeId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'store',
        required: true
    },
    items: [orderItemSchema],
    totalAmount: {
        type: Number,
        required: true
    },
    shippingAddress: {
        type: String,
        required: true
    },
    // Payment
    sellerJazzcashNumber: {
        type: String,
        required: true
    },
    paymentScreenshotUrl: {
        type: String,
        default: ''
    },
    // Status flow: pending → paid → confirmed → shipped → delivered  OR  cancelled
    status: {
        type: String,
        enum: ['pending', 'paid', 'confirmed', 'shipped', 'delivered', 'cancelled'],
        default: 'pending'
    },
    created_at: {
        type: Date,
        default: Date.now
    },
    updated_at: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('order', orderSchema);
