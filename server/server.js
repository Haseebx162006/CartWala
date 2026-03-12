require('dotenv').config();
const express  = require('express');
const cors     = require('cors');
const db = require('./config/db');

const app = express();

// Routes
const authRoutes = require('./routes/auth_routes');
const productRoutes = require('./routes/productRoute');

// Middleware
app.use(cors());
app.use(express.json());


db();

// Routes
app.use('/api/auth', authRoutes);
app.use('/api', productRoutes);

// Health check
app.get('/', (req, res) => res.json({ status: 'Cartwala API running' }));

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

