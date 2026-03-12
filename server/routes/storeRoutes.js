const express = require('express');
const router = express.Router();
const protect = require('../middleware/auth_middleware');
const {
    createStore, getMyStore, updateStore,
    getStoreById, getAllStores,
} = require('../controllers/storeController');

router.post('/', protect, createStore);
router.get('/mine', protect, getMyStore);
router.put('/mine', protect, updateStore);
router.get('/', getAllStores);
router.get('/:id', getStoreById);

module.exports = router;
