const User = require('../models/User');
const crypto = require('crypto');

// ─── Sync Firebase user → MongoDB (called after every Firebase signup/login) ──
exports.syncUser = async (req, res) => {
    try {
        const firebaseUid = req.user.uid;
        const { name, email, phone, role, jazzcashNumber } = req.body;

        // Already synced?
        let user = await User.findOne({ firebaseUid });
        if (user) {
            return res.status(200).json({
                id: user._id, name: user.name, email: user.email,
                phone: user.phone, role: user.role, jazzcashNumber: user.jazzcashNumber,
            });
        }

        // Link existing email-only account
        const emailUser = await User.findOne({ email });
        if (emailUser) {
            emailUser.firebaseUid = firebaseUid;
            await emailUser.save();
            return res.status(200).json({
                id: emailUser._id, name: emailUser.name, email: emailUser.email,
                phone: emailUser.phone, role: emailUser.role, jazzcashNumber: emailUser.jazzcashNumber,
            });
        }

        // New user
        const allowedRoles = ['buyer', 'seller'];
        const userRole = allowedRoles.includes(role) ? role : 'buyer';

        if (userRole === 'seller' && (!jazzcashNumber || jazzcashNumber.trim().length < 11)) {
            return res.status(400).json({ message: 'JazzCash number required for sellers (min 11 digits)' });
        }

        user = await User.create({
            name: name || 'User',
            email,
            password: crypto.randomBytes(16).toString('hex'),
            phone: phone || '',
            firebaseUid,
            role: userRole,
            jazzcashNumber: userRole === 'seller' ? (jazzcashNumber || '').trim() : '',
        });

        return res.status(201).json({
            id: user._id, name: user.name, email: user.email,
            phone: user.phone, role: user.role, jazzcashNumber: user.jazzcashNumber,
        });
    } catch (error) {
        console.error('syncUser error:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Get current user profile ─────────────────────────────────────────────────
exports.getProfile = async (req, res) => {
    try {
        const user = await User.findOne({ firebaseUid: req.user.uid });
        if (!user) return res.status(404).json({ message: 'Profile not found' });

        return res.status(200).json({
            id: user._id, name: user.name, email: user.email,
            phone: user.phone, role: user.role, jazzcashNumber: user.jazzcashNumber,
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Update profile ───────────────────────────────────────────────────────────
exports.updateProfile = async (req, res) => {
    try {
        const user = await User.findOne({ firebaseUid: req.user.uid });
        if (!user) return res.status(404).json({ message: 'User not found' });

        const { name, phone, jazzcashNumber } = req.body;
        if (name) user.name = name.trim();
        if (phone) user.phone = phone.trim();
        if (jazzcashNumber !== undefined && user.role === 'seller') {
            user.jazzcashNumber = jazzcashNumber.trim();
        }
        user.updated_at = Date.now();
        await user.save();

        return res.status(200).json({
            id: user._id, name: user.name, email: user.email,
            phone: user.phone, role: user.role, jazzcashNumber: user.jazzcashNumber,
        });
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// ─── Admin: list all users ────────────────────────────────────────────────────
exports.getAllUsers = async (req, res) => {
    try {
        const admin = await User.findOne({ firebaseUid: req.user.uid });
        if (!admin || admin.role !== 'admin') {
            return res.status(403).json({ message: 'Admin access required' });
        }
        const users = await User.find().select('-password');
        return res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};