const express = require('express');
const router = express.Router();
const protect = require('../middleware/auth_middleware');
const {
    placeOrder, uploadPaymentProof, getMyOrders,
    getSellerOrders, confirmOrder, updateOrderStatus,
    cancelOrder, getAllOrders,
} = require('../controllers/orderController');

// Buyer
router.post('/', protect, placeOrder);
router.post('/pay', protect, uploadPaymentProof);
router.get('/mine', protect, getMyOrders);
router.post('/cancel', protect, cancelOrder);

// Seller
router.get('/seller', protect, getSellerOrders);
router.post('/confirm', protect, confirmOrder);
router.post('/status', protect, updateOrderStatus);

// Admin
router.get('/all', protect, getAllOrders);

module.exports = router;
