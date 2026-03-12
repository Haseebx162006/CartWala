const express = require('express');
const router = express.Router();
const { addToCart, removeFromCart, updateQuantity, getCart } = require('../controllers/cartController');
const protect = require('../middleware/auth_middleware');

router.get('/', protect, getCart);
router.post('/add', protect, addToCart);
router.delete('/remove', protect, removeFromCart);
router.put('/update', protect, updateQuantity);

module.exports = router;
