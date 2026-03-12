const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

let credential;

if (process.env.FIREBASE_SERVICE_ACCOUNT) {
  // Vercel / production: parse from environment variable
  const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
  credential = admin.credential.cert(serviceAccount);
} else {
  // Local dev: read from file
  const serviceAccount = require('./serviceAccountKey.json');
  credential = admin.credential.cert(serviceAccount);
}

admin.initializeApp({ credential });

module.exports = admin;