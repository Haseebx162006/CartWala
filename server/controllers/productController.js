const product = require('../models/Product');
const Store = require('../models/Store');
const User = require('../models/User');

// Create product (seller — linked to their store)
exports.createProduct = async (req, res) => {
    try {
        const { name, description, price, category, imageUrl, stock } = req.body;

        if (!name || !description || !price || !category) {
            return res.status(400).json({ message: 'All fields are required' });
        }

        let storeId = null;
        let sellerFirebaseUid = '';

        // If authenticated seller, attach to store
        if (req.user) {
            const user = await User.findOne({ firebaseUid: req.user.uid });
            if (user && user.role === 'seller') {
                const store = await Store.findOne({ sellerFirebaseUid: req.user.uid });
                if (!store) return res.status(400).json({ message: 'Create a store first' });
                storeId = store._id;
                sellerFirebaseUid = req.user.uid;
            }
        }

        const newProduct = await product.create({
            name, description, price, category,
            imageUrl: imageUrl || '',
            stock: stock || 0,
            storeId,
            sellerFirebaseUid,
        });
        res.status(201).json(newProduct);
    } catch (error) {
        console.error('createProduct:', error);
        res.status(500).json({ message: 'Server error' });
    }
};

// Get all active products
exports.getProducts = async (req, res) => {
    try {
        const products = await product.find({ isActive: true });
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// Get products by store
exports.getProductsByStore = async (req, res) => {
    try {
        const products = await product.find({ storeId: req.params.storeId, isActive: true });
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

// Get my products (seller)
exports.getMyProducts = async (req, res) => {
    try {
        const products = await product.find({ sellerFirebaseUid: req.user.uid });
        res.status(200).json(products);
    } catch (error) {
        res.status(500).json({ message: 'Server error' });
    }
};

exports.getProductById = async(req, res)=>{
    const { id } = req.params
    try {
        const productById = await product.findById(id)
        if(!productById){
            return res.status(404).json({message:"Product not found"})
        }
        res.status(200).json(productById)
    } catch (error) {
        res.status(500).json({message:"Server error"})
    }
}

exports.updateProduct = async(req, res)=>{
    const { id } = req.params
    const { name, description, price, category } = req.body;
    try {
        const updatedProduct = await product.findByIdAndUpdate(id, { name, description, price, category }, { new:true})
        if(!updatedProduct){
            return res.status(404).json({message:"Product not found"})
        }
        res.status(200).json(updatedProduct)
    } catch (error) {
        res.status(500).json({message:"Server error"})
    }
}

exports.deleteProduct = async (req, res) => {

  const { id } = req.params

  try {

    const productUpdated = await product.findByIdAndUpdate(
      id,
      { isActive: false },
      { new: true }
    )

    if(!productUpdated){
      return res.status(404).json({message:"Product not found"})
    }

    res.status(200).json({message:"Product deactivated"})

  } catch (error) {
    res.status(500).json({message:"Server error"})
  }
}

