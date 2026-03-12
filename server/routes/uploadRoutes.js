const express = require('express');
const router = express.Router();
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const { uploadImage } = require('../controllers/uploadController');
const protect = require('../middleware/auth_middleware');

// POST /api/uploads/image
router.post('/image', protect, upload.single('image'), uploadImage);

module.exports = router;
