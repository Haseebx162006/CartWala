const Cart = require('../models/Cart');
const Product = require('../models/Product');


exports.addToCart = async (req, res) => {
  try {
    const userId = req.user.uid;
    const { productId, quantity } = req.body;

    if (!productId) {
      return res.status(400).json({ message: 'productId is required' });
    }

    // Validate product exists
    const product = await Product.findById(productId);
    if (!product || !product.isActive) {
      return res.status(404).json({ message: 'Product not found' });
    }

    let cart = await Cart.findOne({ userId });
    const qty = Math.max(1, parseInt(quantity) || 1);

    if (!cart) {
      cart = new Cart({
        userId,
        items: [{ productId: product._id.toString(), quantity: qty }]
      });
    } else {
      const existingItem = cart.items.find(i => i.productId === product._id.toString());
      if (existingItem) {
        existingItem.quantity += qty;
      } else {
        cart.items.push({ productId: product._id.toString(), quantity: qty });
      }
    }

    await cart.save();

    // Populate product details for response
    const populated = await _populateCart(cart);
    res.status(200).json({ message: 'Product added to cart', items: populated });

  } catch (error) {
    console.error('addToCart:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


exports.removeFromCart = async (req, res) => {
  try {
    const userId = req.user.uid;
    const { productId } = req.body;

    const cart = await Cart.findOne({ userId });
    if (!cart) return res.status(404).json({ message: 'Cart not found' });

    cart.items = cart.items.filter(item => item.productId !== productId);
    await cart.save();

    const populated = await _populateCart(cart);
    res.status(200).json({ message: 'Item removed from cart', items: populated });

  } catch (error) {
    console.error('removeFromCart:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


exports.updateQuantity = async (req, res) => {
  try {
    const userId = req.user.uid;
    const { productId, quantity } = req.body;

    if (quantity < 1) {
      return res.status(400).json({ message: "Quantity must be at least 1" });
    }

    const cart = await Cart.findOne({ userId });
    if (!cart) return res.status(404).json({ message: "Cart not found" });

    const item = cart.items.find(i => i.productId === productId);
    if (!item) return res.status(404).json({ message: "Product not found in cart" });

    item.quantity = quantity;
    await cart.save();

    const populated = await _populateCart(cart);
    res.status(200).json({ message: "Quantity updated", items: populated });

  } catch (error) {
    console.error('updateQuantity:', error);
    res.status(500).json({ message: "Server error" });
  }
};


exports.getCart = async (req, res) => {
  try {
    const userId = req.user.uid;

    const cart = await Cart.findOne({ userId });
    if (!cart) return res.status(200).json({ items: [] });

    const populated = await _populateCart(cart);
    res.status(200).json({ items: populated });

  } catch (error) {
    console.error('getCart:', error);
    res.status(500).json({ message: 'Server error' });
  }
};


// Helper: populate cart items with full product details
// Returns array in Product schema format so Flutter can use Product.fromJson()
async function _populateCart(cart) {
  const populated = [];
  for (const item of cart.items) {
    const product = await Product.findById(item.productId);
    if (product && product.isActive) {
      populated.push({
        _id: product._id,
        name: product.name,
        description: product.description,
        price: product.price,
        category: product.category,
        imageUrl: product.imageUrl || '',
        stock: product.stock,
        isActive: product.isActive,
        quantity: item.quantity,
      });
    }
  }
  return populated;
}