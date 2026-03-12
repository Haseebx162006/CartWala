const mongoose = require('mongoose');

const storeSchema = mongoose.Schema({
    sellerId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
        unique: true
    },
    sellerFirebaseUid: {
        type: String,
        required: true
    },
    storeName: {
        type: String,
        required: true,
        trim: true
    },
    description: {
        type: String,
        default: ''
    },
    logoUrl: {
        type: String,
        default: ''
    },
    jazzcashNumber: {
        type: String,
        required: true
    },
    isActive: {
        type: Boolean,
        default: true
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

module.exports = mongoose.model('store', storeSchema);
