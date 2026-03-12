# Cartwala — E-Commerce App Documentation

> **Stack:** Flutter (Mobile) · Firebase Authentication · Node.js + Express (Backend) · MongoDB (Database)  
> **Version:** 1.0.0 | **Flutter SDK:** ^3.11.0

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture & MVC Structure](#2-architecture--mvc-structure)
3. [Project Structure](#3-project-structure)
4. [Module 1 — App Entry & Configuration](#4-module-1--app-entry--configuration)
5. [Module 2 — Authentication (Flutter + Firebase)](#5-module-2--authentication-flutter--firebase)
6. [Module 3 — Home Screen](#6-module-3--home-screen)
7. [Module 4 — Shared UI Components (Widgets)](#7-module-4--shared-ui-components-widgets)
8. [Module 5 — Global Constants & Theme](#8-module-5--global-constants--theme)
9. [Module 6 — Navigation & Routing](#9-module-6--navigation--routing)
10. [Module 7 — Backend Server (Node.js)](#10-module-7--backend-server-nodejs)
11. [Module 8 — Database Models](#11-module-8--database-models)
12. [Module 9 — API Routes & Middleware](#12-module-9--api-routes--middleware)
13. [Dependencies](#13-dependencies)
14. [Known Issues & TODOs](#14-known-issues--todos)
15. [Planned Features](#15-planned-features)

---

## 1. Project Overview

**Cartwala** is a cross-platform e-commerce mobile application built with Flutter. It allows users to:

- Sign up / Sign in via Email & Password or Google Sign-In (Firebase)
- Browse products by category
- View promotional sale banners and flash deals
- (Planned) Browse, search, and purchase products via a Node.js REST API backend

The app follows a feature-first folder structure on the Flutter side and an MVC pattern on the Node.js backend.

---

## 2. Architecture & MVC Structure

```
┌──────────────────────────────────────────────┐
│                  Flutter App                 │
│                                              │
│   VIEW              SERVICE / CONTROLLER     │
│  (Screens)  ◄────►  (AuthService.dart)       │
│  (Widgets)          │                        │
│                     ▼                        │
│              Firebase Auth SDK               │
│              Google Sign-In SDK              │
└──────────────────────────────────────────────┘
                       │  HTTP (REST API)
                       ▼
┌──────────────────────────────────────────────┐
│            Node.js Backend (server/)         │
│                                              │
│   ROUTE  ──►  CONTROLLER  ──►  MODEL         │
│  (routes/)   (controllers/)   (models/)      │
│                                              │
│  Middleware: JWT Auth (protect)              │
│  Database:   MongoDB via Mongoose            │
└──────────────────────────────────────────────┘
```

### MVC Mapping

| Layer       | Flutter (Client)                                   | Node.js (Server)                        |
|-------------|----------------------------------------------------|-----------------------------------------|
| **Model**   | Firebase `User` object, local data classes         | `server/models/User.js`                 |
| **View**    | `screens/`, `widgets/`, `myHomePage.dart`          | —                                       |
| **Controller** | `services/FIrebase_Auth/AuthService.dart`       | `server/controllers/authController.js`  |
| **Router**  | `lib/Route.dart` (named routes)                    | `server/routes/auth_routes.js`          |

---

## 3. Project Structure

```
cartwala/
├── lib/                          # Flutter source code
│   ├── main.dart                 # App entry point
│   ├── firebase_options.dart     # FlutterFire generated config
│   ├── GlobalVariables.dart      # App-wide colours & constants
│   ├── myHomePage.dart           # Main home screen
│   ├── Route.dart                # Named route generator
│   ├── constants/                # (Reserved for future constants)
│   └── features/
│       └── auth/
│           ├── screens/
│           │   ├── LoginScreen.dart
│           │   └── SignUp.dart
│           ├── services/
│           │   └── FIrebase_Auth/
│           │       └── AuthService.dart
│           └── widgets/
│               ├── auth_button.dart
│               ├── auth_container.dart
│               ├── FlashCard.dart
│               └── ProductCard.dart   (empty — placeholder)
│
├── server/                       # Node.js backend
│   ├── package.json
│   ├── config/
│   │   └── db.js                 # MongoDB connection
│   ├── controllers/
│   │   └── authController.js     # Signup / Login logic
│   ├── models/
│   │   └── User.js               # Mongoose User schema
│   ├── routes/
│   │   ├── auth_routes.js        # (empty — needs wiring)
│   │   └── middleware/
│   │       └── auth_middleware.js # JWT protect middleware
│   └── util/
│       └── token.js              # JWT token generator
│
├── assets/
│   ├── images/
│   │   ├── sale.jpg              # Promo banner image
│   │   └── google.png            # Google sign-in icon
│   └── fonts/
│       ├── Poppins/              # Full Poppins family (100–900)
│       └── Inter/                # Inter variable font
│
├── android/                      # Android platform code
├── ios/                          # iOS platform code
├── pubspec.yaml                  # Flutter dependencies & assets
└── firebase.json                 # Firebase project config
```

---

## 4. Module 1 — App Entry & Configuration

### `lib/main.dart`

**Responsibility:** Bootstraps the app — initialises Firebase, sets up the theme, and decides whether to show Home or Login based on the Firebase auth state.

**Key Logic:**

```
main()
 ├── WidgetsFlutterBinding.ensureInitialized()
 ├── Firebase.initializeApp()
 ├── GoogleSignIn.instance.initialize()
 └── runApp(MyApp)

MyApp.build()
 └── MaterialApp
      ├── theme → AppColors (lime accent, white background)
      ├── onGenerateRoute → generateRoute()
      └── home → StreamBuilder(FirebaseAuth.authStateChanges)
               ├── loading → CircularProgressIndicator
               ├── user logged in → myHomePage()
               └── user not logged in → LoginScreen()
```

**Auth State Management:**  
Uses `FirebaseAuth.instance.authStateChanges()` stream — automatically navigates the user when they log in or out, without any manual navigation calls.

---

### `lib/firebase_options.dart`

**Responsibility:** Auto-generated by FlutterFire CLI. Contains per-platform Firebase project configuration (API keys, App IDs, project ID).

| Platform | App ID |
|----------|--------|
| Android  | `1:53076913016:android:977c9754c254395b64f68d` |
| iOS      | `1:53076913016:ios:425260f91ce4859a64f68d` |
| Web      | `1:53076913016:web:5530f9b8bd1f2f8364f68d` |
| Project  | `cartwala-202c2` |

> ⚠️ **Note:** Windows and Linux platforms are unsupported and will throw `UnsupportedError`.

---

## 5. Module 2 — Authentication (Flutter + Firebase)

### Overview

Authentication is handled entirely by Firebase on the client side. The Node.js backend has its own independent auth (email/password + bcrypt + JWT) which is meant for product/order APIs.

```
User Action
    │
    ▼
Screen (LoginScreen / Signup)
    │  calls
    ▼
AuthService (controller)
    │  calls
    ▼
Firebase Auth SDK / Google Sign-In SDK
    │  result
    ▼
FirebaseAuth.authStateChanges stream
    │  triggers
    ▼
main.dart StreamBuilder → navigates to myHomePage
```

---

### `lib/features/auth/screens/LoginScreen.dart`

**Route constant:** `LoginScreen.login_screen = 'login-auth'`

**State:**
| Field | Type | Purpose |
|-------|------|---------|
| `emailController` | `TextEditingController` | Email input |
| `passwordController` | `TextEditingController` | Password input |
| `ischeck` | `bool` | (Declared but unused) |

**UI Elements:**
- "Sign In" heading
- Email field (`AuthContainer`)
- Password field (`AuthContainer`, obscured)
- "Sign In" button (`AuthButton`) → calls `Authservice().signInWithEmailAndPassword()`
- Google sign-in button → calls `Authservice().signUpWithGoogle()`
- Navigation link to `Signup` screen

---

### `lib/features/auth/screens/SignUp.dart`

**Route constant:** `Signup.SignupScreen = 'signup-auth'`

**State:**
| Field | Type | Purpose |
|-------|------|---------|
| `nameController` | `TextEditingController` | Name input |
| `emailController` | `TextEditingController` | Email input |
| `passwordController` | `TextEditingController` | Password input |
| `ischeck` | `bool` | Terms & Conditions checkbox |

**UI Elements:**
- "Sign Up" heading
- Name, Email, Password fields (`AuthContainer`)
- Terms & Conditions checkbox
- "Sign Up" button → calls `Authservice().createUserwithEmailandPassword()`
- Google sign-in button → calls `Authservice().signUpWithGoogle()`
- Navigation link back to `LoginScreen`

---

### `lib/features/auth/services/FIrebase_Auth/AuthService.dart`

**Class:** `Authservice`

This is the **Controller** layer for authentication. All Firebase calls go through here.

| Method | Parameters | Description |
|--------|-----------|-------------|
| `createUserwithEmailandPassword` | `context, name, email, password` | Creates a new Firebase user. Displays error via `SnackBar` on failure. |
| `signInWithEmailAndPassword` | `context, email, password` | Signs in existing Firebase user. Displays error via `SnackBar` on failure. |
| `signout` | — | Signs out the current Firebase user. Triggers `authStateChanges` stream. |
| `signUpWithGoogle` | `context` | Initiates Google OAuth flow using `GoogleSignIn.instance.authenticate()`. Returns `User?`. |

**Error Handling:** All methods use try-catch with `FirebaseAuthException` and display user-friendly messages via `ScaffoldMessenger`.

> ⚠️ **Note:** `createUserwithEmailandPassword` does not currently save the user's `name` to Firebase or the backend. This should be added (e.g. `user.updateDisplayName(name)` or a backend API call).

---

## 6. Module 3 — Home Screen

### `lib/myHomePage.dart`

**Class:** `myHomePage` (StatefulWidget)

The main screen shown after successful login.

**State:**
| Field | Type | Purpose |
|-------|------|---------|
| `searchController` | `TextEditingController` | Search bar input |
| `discounts` | `List<String>` | Flash deal percentage labels |
| `subtitles` | `List<String>` | Flash deal category subtitles |

**UI Structure:**

```
Scaffold
└── Padding (horizontal: 20, vertical: 50)
    └── Column
        ├── Text — "Hello"
        ├── Text — "Welcome to Cartwala"
        ├── SearchBar (search for products)
        ├── Text — "Categories"
        ├── Row — 5 × CircleAvatar category icons
        │    (Mobiles, Fashion, Food, Sports, Toys)
        ├── SizedBox (height: 160)
        │   └── ListView.builder (horizontal)
        │        └── FlashCard × 3 (discount + subtitle)
        ├── Text — "Products"
        └── Expanded
            └── ListView.builder
                 └── Container() × 3  ← PLACEHOLDER (backend TODO)
```

**Category Icons (hardcoded):**
| Icon | Label |
|------|-------|
| `Icons.phone_android` | Mobiles |
| `Icons.checkroom` | Fashion |
| `Icons.dining` | Food |
| `Icons.sports_cricket` | Sports |
| `Icons.toys` | Toys |

**Sale Banner:**  
A full-width `Container` (height: 160) with dark navy background (`#1A1A2E`), decorative lime glowing circles, a "🔥 SALE" badge, discount headline, subtitle text, and a "Shop Now →" CTA button — all using `AppColors`.

> 🔧 **TODO:** The Products `ListView` is currently empty (`Container()`). Replace with actual product cards fetched from the Node.js backend.

---

## 7. Module 4 — Shared UI Components (Widgets)

### `lib/features/auth/widgets/auth_button.dart`

**Class:** `AuthButton` (StatelessWidget)

Reusable full-width elevated button used across auth screens.

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `text` | `String` | ✅ | Button label |
| `onPressed` | `VoidCallback` | ✅ | Tap handler |

**Style:** Lime background (`AppColors.lime`), rounded corners (16px), Poppins font, black text.

---

### `lib/features/auth/widgets/auth_container.dart`

**Class:** `AuthContainer` (StatelessWidget)

Reusable styled `TextField` used for all auth form inputs.

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `hinttext` | `String` | ✅ | Placeholder text |
| `controller` | `TextEditingController` | ✅ | Text controller |
| `obsecuretext` | `bool` | ✅ | Whether to hide text (for passwords) |
| `iconData` | `IconData?` | ❌ | Optional leading icon |

**Style:** White fill, black border (1.5px), lime focused border, 16px corner radius.

---

### `lib/features/auth/widgets/FlashCard.dart`

**Class:** `FlashCard` (StatefulWidget)

A horizontally scrollable promotional deal card.

| Prop | Type | Required | Description |
|------|------|----------|-------------|
| `discount` | `String` | ✅ | Discount % (e.g. `"50%"`) |
| `subTitle` | `String` | ✅ | Deal description (e.g. `"On electronics"`) |

**Visual Design:**
- Dark navy background (`#1A1A2E`), width: 320, height: 160
- Three decorative lime glowing `Stack` circles for depth
- "🔥 SALE" filled lime badge + "Limited Time" outlined lime badge
- Large discount text + subtitle
- "Shop Now →" lime CTA button

---

### `lib/features/auth/widgets/ProductCard.dart`

**Status:** ⚠️ Empty file — placeholder for future product card widget.

**Planned usage:** Grid/list product card showing product image, name, price, rating, and add-to-cart button.

---

## 8. Module 5 — Global Constants & Theme

### `lib/GlobalVariables.dart`

Contains two classes:

---

#### `AppColors` (primary — use this)

Single source of truth for all app colours.

| Constant | Value | Usage |
|----------|-------|-------|
| `lime` | `#C5E41A` | Buttons, badges, active nav, category bg |
| `limeDark` | `#8FA80D` | Price text, "See All" links |
| `headerDark` | `#1A1A2E` | Dark navbar, card backgrounds |
| `headerMid` | `#16213E` | Gradient end colour |
| `background` | `#F8F9FA` | Scaffold background |
| `surface` | `white` | Card surfaces |
| `textPrimary` | `#1A1A2E` | Main text |
| `textSecondary` | `#6B7280` | Subtitles, hints |
| `textHint` | `#ADB5BD` | Placeholder text |
| `error` | `#E53935` | Error states |
| `starColor` | `#FFC107` | Star ratings |
| `divider` | `#E9ECEF` | Separator lines |
| `headerGradient` | `#1A1A2E → #16213E` | App bar, dark containers |

**Product card accent colours (for category cards):**

| Name | Dark | Mid |
|------|------|-----|
| Indigo | `#283593` | `#3949AB` |
| Crimson | `#C62828` | `#E53935` |
| Emerald | `#1B5E20` | `#2E7D32` |
| Violet | `#4A148C` | `#6A1B9A` |
| Teal | `#00695C` | `#00796B` |
| Amber | `#E65100` | `#EF6C00` |

---

#### `GlobalVariables` (backward compatibility wrapper)

| Constant | Maps To |
|----------|---------|
| `appBarGradient` | `AppColors.headerGradient` |
| `secondaryColor` | `AppColors.lime` |
| `backgroundColor` | `AppColors.surface` |
| `selectedNavBarColor` | `AppColors.lime` |
| `unselectedNavBarColor` | `AppColors.textSecondary` |
| `carouselImages` | List of remote Amazon CDN image URLs |
| `categoryImages` | List of local asset paths (not yet used) |

---

## 9. Module 6 — Navigation & Routing

### `lib/Route.dart`

**Function:** `generateRoute(RouteSettings settings) → Route<dynamic>`

Named route generator passed to `MaterialApp.onGenerateRoute`.

| Route Name | Screen | Constant |
|------------|--------|----------|
| `'signup-auth'` | `Signup` | `Signup.SignupScreen` |
| `'login-auth'` | `LoginScreen` | `LoginScreen.login_screen` |
| (any other) | Error scaffold | — |

**Usage:**
```dart
Navigator.pushNamed(context, Signup.SignupScreen);
Navigator.pushNamed(context, LoginScreen.login_screen);
```

---

## 10. Module 7 — Backend Server (Node.js)

### Overview

The Node.js server is an Express REST API using MongoDB (Mongoose) for persistence and JWT for stateless auth. It is separate from Firebase — intended for product catalogue, orders, cart, and user profile data.

### `server/config/db.js`

MongoDB connection using Mongoose.

```javascript
mongoose.connect(process.env.DB_URL)
```

**Environment variable required:** `DB_URL` (MongoDB connection string)

> ⚠️ **Bug:** `db` function is defined but never exported (`module.exports = db` is missing) and never called.

---

### `server/controllers/authController.js`

**Exports:** `signUp`, `login`

#### `signUp(req, res)`

| Field | Validation |
|-------|-----------|
| `name` | Required, string, min 3 chars |
| `email` | Required, string, must contain `@` |
| `password` | Required, string, min 6 chars |
| `phone` | Required, string |

Flow:
1. Validate all fields
2. Check if user already exists (`User.findOne({ email })`)
3. Create user (`User.create(...)`) — password is hashed in pre-save hook
4. Generate JWT token
5. Return `{ success: true, result: token }`

> ⚠️ **Bug:** `login()` is missing `await` on `User.findOne()` — it will always return a Mongoose Query object (truthy), never 404. Fix: `const existingUser = await User.findOne({ email })`.

---

#### `login(req, res)`

| Field | Validation |
|-------|-----------|
| `email` | Required, valid format |
| `password` | Required, min 6 chars |

Flow:
1. Validate fields
2. Find user by email ← **needs `await`**
3. Compare password using `matchPassword()`
4. Return JWT token on success

---

### `server/util/token.js`

**Function:** `generate_token(id) → string`

Generates a JWT signed with `process.env.SECRET_KEY`.

> ⚠️ **Issues:**
> 1. Missing `return` — the generated token is never returned to the caller.
> 2. Missing token expiry (`expiresIn` option) — tokens never expire.
> 
> **Fix:**
> ```javascript
> const generate_token = (id) => {
>   return jwt.sign({ id }, process.env.SECRET_KEY, { expiresIn: '7d' });
> };
> ```

---

## 11. Module 8 — Database Models

### `server/models/User.js`

**Model name:** `user`  
**Collection:** `users` (Mongoose default pluralisation)

#### Schema

| Field | Type | Constraints | Default |
|-------|------|-------------|---------|
| `name` | String | Required | — |
| `email` | String | Required, Unique | — |
| `password` | String | Required | — |
| `phone` | String | Unique | — |
| `role` | String | Enum: `['Admin', 'User']` | `'User'` |
| `created_at` | Date | — | `Date.now()` |
| `updated_at` | Date | — | `Date.now()` |

#### Hooks & Methods

**Pre-save hook:** Hashes `password` using `bcrypt` (salt rounds: 10) before saving. Skips if password is not modified.

**Instance method:** `matchPassword(enteredPassword)` — compares a plain password against the stored hash using `bcrypt.compare()`.

---

## 12. Module 9 — API Routes & Middleware

### `server/routes/auth_routes.js`

**Status:** ⚠️ Empty — routes are not yet wired up.

**Planned routes:**
```
POST /api/auth/signup   → authController.signUp
POST /api/auth/login    → authController.login
```

---

### `server/routes/middleware/auth_middleware.js`

**Function:** `protect(req, res, next)`

Reads the `Authorization: Bearer <token>` header and validates it.

> ⚠️ **Incomplete:** The token is extracted from the header but `jwt.verify()` is never called, and `next()` is never called on success. The middleware does not attach the decoded user to `req.user`.
>
> **Fix:**
> ```javascript
> const jwt = require('jsonwebtoken');
> const protect = (req, res, next) => {
>   const authHeader = req.headers.authorization;
>   if (!authHeader || !authHeader.startsWith('Bearer ')) {
>     return res.status(401).json({ message: 'Unauthorized' });
>   }
>   try {
>     const token = authHeader.split(' ')[1];
>     const decoded = jwt.verify(token, process.env.SECRET_KEY);
>     req.user = decoded;
>     next();
>   } catch (error) {
>     return res.status(401).json({ message: 'Invalid token' });
>   }
> };
> module.exports = protect;
> ```

---

## 13. Dependencies

### Flutter (`pubspec.yaml`)

| Package | Version | Purpose |
|---------|---------|---------|
| `firebase_core` | ^4.5.0 | Firebase SDK initialisation |
| `firebase_auth` | ^6.2.0 | Email/Password + OAuth authentication |
| `google_sign_in` | ^7.2.0 | Google OAuth sign-in |
| `flutter_riverpod` | ^3.3.1 | State management (installed, not yet used) |
| `cupertino_icons` | ^1.0.8 | iOS icons |

### Node.js (`server/package.json`)

| Package | Version | Purpose |
|---------|---------|---------|
| `express` | ^5.2.1 | HTTP server & routing |
| `mongoose` | ^9.2.4 | MongoDB ODM |
| `jsonwebtoken` | ^9.0.3 | JWT generation & verification |
| `bcryptjs` | ^3.0.3 | Password hashing (root package.json) |
| `bcrypt` | ^6.0.0 | Password hashing (server package.json) |
| `cors` | ^2.8.6 | Cross-origin resource sharing |

> ⚠️ Both `bcrypt` and `bcryptjs` are listed in different `package.json` files. Consolidate to one: `bcrypt` (native, faster) or `bcryptjs` (pure JS, no build step).

---

## 14. Known Issues & TODOs

### Flutter

| # | File | Issue | Priority |
|---|------|-------|----------|
| 1 | `AuthService.dart` | `createUserwithEmailandPassword` doesn't save user `name` to Firebase profile or backend | High |
| 2 | `myHomePage.dart` | Products `ListView` is empty (`Container()`) — needs backend integration | High |
| 3 | `ProductCard.dart` | Empty file — widget not implemented | High |
| 4 | `auth_routes.js` | Empty — routes not wired | High |
| 5 | `LoginScreen.dart` | Second social button (Apple/other) shows Google icon/text — placeholder | Medium |
| 6 | `myHomePage.dart` | No pull-to-refresh, no loading states | Medium |
| 7 | `SignUp.dart` | `ischeck` (terms checkbox) is not validated before submit | Medium |

### Backend (Node.js)

| # | File | Issue | Priority |
|---|------|-------|----------|
| 1 | `authController.js` | `login()` missing `await` on `User.findOne()` — always returns truthy | Critical |
| 2 | `token.js` | Token is generated but never returned; no expiry set | Critical |
| 3 | `auth_middleware.js` | `jwt.verify()` never called; `next()` never called; `req.user` never set | Critical |
| 4 | `db.js` | `db` function never exported or called — DB never connects | Critical |
| 5 | `auth_routes.js` | Empty file — no routes registered | High |
| 6 | `server/` | No `index.js` entry point — server cannot start | High |
| 7 | General | Both `bcrypt` and `bcryptjs` in dependencies — consolidate | Low |

---

## 15. Planned Features

### Authentication
- [ ] Save user name to Firebase `displayName` on signup
- [ ] Apple Sign-In
- [ ] Forgot password / password reset screen
- [ ] Persist user session via Riverpod provider

### Home
- [ ] Fetch products from Node.js backend API
- [ ] Implement `ProductCard` widget (image, name, price, rating, add-to-cart)
- [ ] Add all category icons (Electronics, Home, Books)
- [ ] Pull-to-refresh
- [ ] Search functionality (debounced, calls backend)

### Backend
- [ ] Create `server/index.js` entry point (Express app, routes, db connection)
- [ ] Fix `login()` — add `await` to `User.findOne()`
- [ ] Fix `token.js` — return token, add `expiresIn: '7d'`
- [ ] Complete `auth_middleware.js` — verify JWT, attach `req.user`
- [ ] Wire `auth_routes.js` with signup and login endpoints
- [ ] Add Product model & controller (CRUD)
- [ ] Add Order model & controller
- [ ] Add Cart routes
- [ ] Deploy to cloud (Railway / Render / AWS)

### App-wide
- [ ] Activate Riverpod providers (already installed)
- [ ] Add bottom navigation bar (Cart, Wishlist, Profile, Orders)
- [ ] Add loading skeletons
- [ ] Add dark mode support using `AppColors`

---

> *Documentation generated on March 11, 2026. Reflects current codebase state.*
