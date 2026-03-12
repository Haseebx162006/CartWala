const express = require('express');
const router = express.Router();
const { syncUser, getProfile, updateProfile, getAllUsers } = require('../controllers/authController');
const protect = require('../middleware/auth_middleware');

router.post('/sync', protect, syncUser);
router.get('/profile', protect, getProfile);
router.put('/profile', protect, updateProfile);
router.get('/users', protect, getAllUsers);

module.exports = router;
