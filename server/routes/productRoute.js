const express = require('express');
const router = express.Router();
const protect = require('../middleware/auth_middleware');
const { createProduct, getProducts, getProductById, updateProduct, deleteProduct, getProductsByStore, getMyProducts } = require('../controllers/productController');

router.post('/createproduct', protect, createProduct);
router.get('/products', getProducts);
router.get('/products/mine', protect, getMyProducts);
router.get('/products/store/:storeId', getProductsByStore);
router.get('/products/:id', getProductById);
router.put('/products/:id', protect, updateProduct);
router.delete('/products/:id', protect, deleteProduct);

module.exports = router;