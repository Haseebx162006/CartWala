const Store = require('../models/Store');
const User = require('../models/User');

// Create store (seller only)
exports.createStore = async (req, res) => {
    try {
        const firebaseUid = req.user.uid;
        const user = await User.findOne({ firebaseUid });

        if (!user || user.role !== 'seller') {
            return res.status(403).json({ message: 'Only sellers can create stores' });
        }

        const existing = await Store.findOne({ sellerFirebaseUid: firebaseUid });
        if (existing) {
            return res.status(400).json({ message: 'You already have a store' });
        }

        const { storeName, description, logoUrl } = req.body;
        if (!storeName || storeName.trim().length < 2) {
            return res.status(400).json({ message: 'Store name is required (min 2 chars)' });
        }

        const store = await Store.create({
            sellerId: user._id,
            sellerFirebaseUid: firebaseUid,
            storeName: storeName.trim(),
            description: (description || '').trim(),
            logoUrl: (logoUrl || '').trim(),
            jazzcashNumber: user.jazzcashNumber
        });

        res.status(201).json(store);
    } catch (error) {
        console.error('createStore:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

// Get my store (seller)
exports.getMyStore = async (req, res) => {
    try {
        const firebaseUid = req.user.uid;
        const store = await Store.findOne({ sellerFirebaseUid: firebaseUid });
        if (!store) {
            return res.status(404).json({ message: 'No store found' });
        }
        res.status(200).json(store);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// Update store
exports.updateStore = async (req, res) => {
    try {
        const firebaseUid = req.user.uid;
        const { storeName, description, logoUrl } = req.body;

        const store = await Store.findOne({ sellerFirebaseUid: firebaseUid });
        if (!store) {
            return res.status(404).json({ message: 'Store not found' });
        }

        if (storeName) store.storeName = storeName.trim();
        if (description !== undefined) store.description = description.trim();
        if (logoUrl !== undefined) store.logoUrl = logoUrl.trim();
        store.updated_at = Date.now();

        await store.save();
        res.status(200).json(store);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// Get store by ID (public — for buyers to see store info)
exports.getStoreById = async (req, res) => {
    try {
        const store = await Store.findById(req.params.id);
        if (!store || !store.isActive) {
            return res.status(404).json({ message: 'Store not found' });
        }
        res.status(200).json(store);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// Get all active stores (public)
exports.getAllStores = async (req, res) => {
    try {
        const stores = await Store.find({ isActive: true }).select('storeName description logoUrl jazzcashNumber');
        res.status(200).json(stores);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};
