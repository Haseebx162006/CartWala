const admin = require('firebase-admin');
const path = require('path');
const fs = require('fs');

const serviceAccountPath = path.join(__dirname, 'serviceAccountKey.json');

function loadServiceAccount() {
  if (process.env.FIREBASE_SERVICE_ACCOUNT) {
    try {
      return JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);
    } catch (error) {
      throw new Error('FIREBASE_SERVICE_ACCOUNT is not valid JSON.');
    }
  }

  if (process.env.FIREBASE_SERVICE_ACCOUNT_BASE64) {
    try {
      const decoded = Buffer.from(process.env.FIREBASE_SERVICE_ACCOUNT_BASE64, 'base64').toString('utf8');
      return JSON.parse(decoded);
    } catch (error) {
      throw new Error('FIREBASE_SERVICE_ACCOUNT_BASE64 is not valid base64-encoded JSON.');
    }
  }

  if (
    process.env.FIREBASE_PROJECT_ID &&
    process.env.FIREBASE_CLIENT_EMAIL &&
    process.env.FIREBASE_PRIVATE_KEY
  ) {
    return {
      project_id: process.env.FIREBASE_PROJECT_ID,
      client_email: process.env.FIREBASE_CLIENT_EMAIL,
      private_key: process.env.FIREBASE_PRIVATE_KEY.replace(/\\n/g, '\n')
    };
  }

  if (fs.existsSync(serviceAccountPath)) {
    return JSON.parse(fs.readFileSync(serviceAccountPath, 'utf8'));
  }

  throw new Error(
    'Firebase Admin credentials missing. Set FIREBASE_SERVICE_ACCOUNT (JSON), ' +
      'or FIREBASE_SERVICE_ACCOUNT_BASE64, or FIREBASE_PROJECT_ID/FIREBASE_CLIENT_EMAIL/FIREBASE_PRIVATE_KEY. ' +
      'For local dev, add server/config/serviceAccountKey.json.'
  );
}

if (!admin.apps.length) {
  const credential = admin.credential.cert(loadServiceAccount());
  admin.initializeApp({ credential });
}

module.exports = admin;