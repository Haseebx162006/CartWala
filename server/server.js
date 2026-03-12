require('dotenv').config();
const express  = require('express');
const cors     = require('cors');
const db = require('./config/db');

const app = express();

// Routes
const authRoutes = require('./routes/auth_routes');
const productRoutes = require('./routes/productRoute');
const cartRoutes = require('./routes/cartRoutes');
const storeRoutes = require('./routes/storeRoutes');
const orderRoutes = require('./routes/orderRoutes');
const uploadRoutes = require('./routes/uploadRoutes');

// Middleware
app.use(cors());
app.use(express.json({ limit: '10mb' }));
db();

// Mount routes
app.use('/api/auth', authRoutes);
app.use('/api', productRoutes);
app.use('/api/cart', cartRoutes);
app.use('/api/stores', storeRoutes);
app.use('/api/orders', orderRoutes);
app.use('/api/uploads', uploadRoutes);

// Health check
app.get('/', (req, res) => res.json({ status: 'Cartwala API running' }));

// Start server (local dev)
if (process.env.NODE_ENV !== 'production') {
  const PORT = process.env.PORT || 5000;
  app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
}

// Export for Vercel serverless
module.exports = app;

