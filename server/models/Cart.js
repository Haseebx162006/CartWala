const mongoose = require('mongoose');

const cartSchema = mongoose.Schema({
    userId: { type: String, required: true },
    items: [
        {
            productId: { type: String, required: true },
            quantity: { type: Number, required: true, default: 1 }
        }
    ],
    created_at: { type: Date, default: Date.now },
    updated_at: { type: Date, default: Date.now }
});

module.exports = mongoose.model('cart', cartSchema);