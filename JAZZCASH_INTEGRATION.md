# JazzCash Payment Integration Guide — Cartwala

## Overview

Cartwala uses a **manual JazzCash payment verification** flow. Sellers provide their JazzCash mobile account number at signup. Buyers send payment via the JazzCash app and upload a screenshot as proof. Sellers verify the screenshot in their panel and confirm the order.

---

## Flow Diagram

```
Buyer places order
        ↓
JazzCash card appears with seller's number + amount
        ↓
Buyer sends money via JazzCash app
        ↓
Buyer uploads payment screenshot URL
        ↓
Order status changes to "paid"
        ↓
Seller sees order in panel with the screenshot
        ↓
Seller clicks "Confirm Payment"
        ↓
Order status changes to "confirmed"
        ↓
Seller updates: shipped → delivered
```

---

## Seller Setup

1. During **signup**, the seller selects the **Seller** role.
2. A **JazzCash Number** field appears — the seller enters their JazzCash mobile account number.
3. This number is saved to the user profile in MongoDB and also attached to the seller's **Store** record.
4. When any buyer orders from this store, the seller's JazzCash number is displayed on the payment screen.

### Relevant Code

| File | Purpose |
|------|---------|
| `lib/features/auth/screens/Signup.dart` | Role selection + JazzCash number input for sellers |
| `server/controllers/authController.js` → `syncUser` | Saves `jazzcashNumber` to User document |
| `server/controllers/storeController.js` → `createStore` | Copies `jazzcashNumber` from User to Store |

---

## Buyer Payment Flow

### Step 1: Checkout
The buyer navigates to `CheckoutScreen` with the cart items, store ID, store name, and the seller's JazzCash number.

### Step 2: Place Order
The buyer enters a shipping address → taps **Place Order & Pay**.  
This calls `POST /api/orders` which creates a new Order with status `pending`.

### Step 3: JazzCash Payment Card
After order creation, the buyer is redirected to `PaymentScreen`.  
A styled JazzCash card displays:
- The seller's JazzCash number (with copy-to-clipboard)
- The exact amount to send

### Step 4: Upload Screenshot
The buyer sends money via the JazzCash mobile app, then pastes the screenshot URL into the input field and taps **Submit Payment Proof**.  
This calls `POST /api/orders/pay` which updates the order's `paymentScreenshotUrl` and sets status to `paid`.

### Relevant Code

| File | Purpose |
|------|---------|
| `lib/features/order/screens/checkout_screen.dart` | Checkout UI + place order |
| `lib/features/order/screens/payment_screen.dart` | JazzCash card + screenshot upload |
| `lib/features/order/services/order_service.dart` | API calls: `placeOrder`, `uploadPaymentProof` |
| `server/controllers/orderController.js` | `placeOrder`, `uploadPaymentProof` handlers |

---

## Seller Verification Flow

### Step 1: View Orders
The seller opens the **Orders** tab in their Seller Panel.  
This calls `GET /api/orders/seller` which returns all orders for the seller's store.

### Step 2: View Screenshot
For orders with status `paid`, a "View Payment Screenshot" button appears.  
Tapping it opens a dialog showing the uploaded screenshot image.

### Step 3: Confirm Payment
The seller taps **Confirm Payment** → calls `POST /api/orders/confirm`.  
Order status changes to `confirmed`.

### Step 4: Update Shipping
The seller can then update status: `confirmed → shipped → delivered`.

### Relevant Code

| File | Purpose |
|------|---------|
| `lib/features/seller/screens/seller_orders_screen.dart` | Seller order list, screenshot viewer, action buttons |
| `server/controllers/orderController.js` | `confirmOrder`, `updateOrderStatus` |

---

## Order Status Lifecycle

| Status | Meaning |
|--------|---------|
| `pending` | Order placed, awaiting payment |
| `paid` | Buyer uploaded payment screenshot |
| `confirmed` | Seller verified the payment |
| `shipped` | Seller shipped the products |
| `delivered` | Buyer received the products |
| `cancelled` | Order was cancelled |

---

## API Endpoints

### Buyer Endpoints (require Firebase Auth token)

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/orders` | Place a new order |
| POST | `/api/orders/pay` | Upload payment screenshot URL |
| GET | `/api/orders/mine` | Get buyer's orders |
| POST | `/api/orders/cancel` | Cancel an order |

### Seller Endpoints (require Firebase Auth token)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/orders/seller` | Get orders for seller's store |
| POST | `/api/orders/confirm` | Confirm a paid order |
| POST | `/api/orders/status` | Update order status |

### Admin Endpoints (require Firebase Auth token)

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/orders/all` | Get all platform orders |

---

## Future Improvements

To upgrade to a full JazzCash API integration:

1. **Register as a JazzCash merchant** at [JazzCash Business Portal](https://sandbox.jazzcash.com.pk/Sandbox/Home/Index)
2. **Get API credentials**: Merchant ID, Password, Integrity Salt, Return URL
3. **Implement server-side payment initiation**: 
   - Create a `POST /api/payments/initiate` endpoint
   - Generate the `pp_SecureHash` using HMAC-SHA256 with Integrity Salt
   - Send payment request to JazzCash HTTP API
4. **Add WebView in Flutter**: 
   - Use `webview_flutter` package
   - Load JazzCash payment page URL returned from your server
   - Listen for redirect to your Return URL to capture payment status
5. **Implement webhook/callback**: 
   - JazzCash sends payment status to your server callback URL
   - Automatically update order status to `paid` on success
6. **Remove manual screenshot flow**: Replace `PaymentScreen` with the WebView-based flow

### JazzCash Sandbox Test Credentials
- Sandbox URL: `https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction`
- Use test MPIN: `1234` in sandbox mode

---

## Environment Variables (for future API integration)

Add to `server/.env`:
```
JAZZCASH_MERCHANT_ID=your_merchant_id
JAZZCASH_PASSWORD=your_password
JAZZCASH_INTEGRITY_SALT=your_integrity_salt
JAZZCASH_RETURN_URL=http://your-server.com/api/payments/callback
JAZZCASH_API_URL=https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction
```
