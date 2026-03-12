require('dotenv').config();
const mongoose = require('mongoose');
const db = require('./config/db');
const Product = require('./models/Product');

const products = [
  {
    name: 'Wireless Bluetooth Earbuds',
    description: 'True wireless earbuds with active noise cancellation, 30-hour battery life, and premium sound quality.',
    price: 1499,
    category: 'Electronics',
    imageUrl: 'https://picsum.photos/seed/earbuds/400/300',
    stock: 50,
  },
  {
    name: 'Men\'s Running Sneakers',
    description: 'Lightweight and breathable running shoes with cushioned sole, ideal for jogging and gym workouts.',
    price: 2199,
    category: 'Footwear',
    imageUrl: 'https://picsum.photos/seed/sneakers/400/300',
    stock: 30,
  },
  {
    name: 'Stainless Steel Water Bottle',
    description: 'Double-wall insulated 750ml bottle. Keeps drinks cold for 24 hrs and hot for 12 hrs.',
    price: 599,
    category: 'Kitchen',
    imageUrl: 'https://picsum.photos/seed/waterbottle/400/300',
    stock: 100,
  },
  {
    name: 'Yoga Mat Premium',
    description: 'Non-slip, eco-friendly 6mm thick yoga mat suitable for yoga, pilates, and floor exercises.',
    price: 899,
    category: 'Sports',
    imageUrl: 'https://picsum.photos/seed/yogamat/400/300',
    stock: 40,
  },
  {
    name: 'Portable Laptop Stand',
    description: 'Foldable aluminum laptop stand compatible with 10–17 inch laptops. Ergonomic and lightweight.',
    price: 1299,
    category: 'Accessories',
    imageUrl: 'https://picsum.photos/seed/laptopstand/400/300',
    stock: 25,
  },
];

async function seed() {
  await db();
  await Product.deleteMany({});
  console.log('🗑  Cleared existing products.');
  await Product.insertMany(products);
  console.log('5 products seeded successfully!');
  mongoose.connection.close();
}

seed().catch((err) => {
  console.error('Seed failed:', err);
  mongoose.connection.close();
});
