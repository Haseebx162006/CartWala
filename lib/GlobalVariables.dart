import 'package:flutter/material.dart';

// Server base URL
const String kBaseUrl = 'http://localhost:3000';

// ---------------------------------------------------------------------------
// AppColors — single source of truth for every colour in the app
// ---------------------------------------------------------------------------
class AppColors {
  AppColors._(); // prevent instantiation

  // ── Brand accent (lime / chartreuse) ──────────────────────────────────────
  /// Bright lime — use as chip/badge background, category icon bg tint
  static const Color lime = Color(0xFFC5E41A);

  /// Darker lime — use for price text, active-nav, "See All" text (readable on white)
  static const Color limeDark = Color(0xFF8FA80D);

  // ── Header / dark surfaces ────────────────────────────────────────────────
  static const Color headerDark = Color(0xFF1A1A2E); // deep navy
  static const Color headerMid = Color(0xFF16213E); // midnight blue

  // ── Backgrounds & surfaces ────────────────────────────────────────────────
  static const Color background = Color(0xFFF8F9FA); // clean off-white
  static const Color surface = Colors.white;

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFFADB5BD);

  // ── Semantic ──────────────────────────────────────────────────────────────
  static const Color error = Color(0xFFE53935);
  static const Color starColor = Color(0xFFFFC107);
  static const Color divider = Color(0xFFE9ECEF);

  // ── Header gradient (dark navy) ───────────────────────────────────────────
  static const LinearGradient headerGradient = LinearGradient(
    colors: [headerDark, headerMid],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Rich product-card accent colours (dark, look great with white icons) ──
  static const Color indigo = Color(0xFF283593);
  static const Color indigoMid = Color(0xFF3949AB);
  static const Color crimson = Color(0xFFC62828);
  static const Color crimsonMid = Color(0xFFE53935);
  static const Color emerald = Color(0xFF1B5E20);
  static const Color emeraldMid = Color(0xFF2E7D32);
  static const Color violet = Color(0xFF4A148C);
  static const Color violetMid = Color(0xFF6A1B9A);
  static const Color teal = Color(0xFF00695C);
  static const Color tealMid = Color(0xFF00796B);
  static const Color amber = Color(0xFFE65100);
  static const Color amberMid = Color(0xFFEF6C00);
}

// ---------------------------------------------------------------------------
// GlobalVariables — kept for backward compatibility with the rest of the app
// ---------------------------------------------------------------------------
class GlobalVariables {
  GlobalVariables._(); // prevent instantiation

  static const LinearGradient appBarGradient = AppColors.headerGradient;
  static const Color secondaryColor = AppColors.lime;
  static const Color backgroundColor = AppColors.surface;
  static const Color greyBackgroundColor = Color(0xFFEBECEE);
  static Color selectedNavBarColor = AppColors.lime;
  static const Color unselectedNavBarColor = AppColors.textSecondary;

  // Remote carousel images
  static const List<String> carouselImages = [
    'https://images-eu.ssl-images-amazon.com/images/G/31/img21/Wireless/WLA/TS/D37847648_Accessories_savingdays_Jan22_Cat_PC_1500.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img2021/Vday/bwl/English.jpg',
    'https://images-eu.ssl-images-amazon.com/images/G/31/img22/Wireless/AdvantagePrime/BAU/14thJan/D37196025_IN_WL_AdvantageJustforPrime_Jan_Mob_ingress-banner_1242x450.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/Symbol/2020/00NEW/1242_450Banners/PL31_copy._CB432483346_.jpg',
    'https://images-na.ssl-images-amazon.com/images/G/31/img21/shoes/September/SSW/pc-header._CB641971330_.jpg',
  ];

  // Local category images
  static const List<Map<String, String>> categoryImages = [
    {'title': 'Mobiles', 'image': 'assets/images/mobiles.jpeg'},
    {'title': 'Essentials', 'image': 'assets/images/essentials.jpeg'},
    {'title': 'Appliances', 'image': 'assets/images/appliances.jpeg'},
    {'title': 'Books', 'image': 'assets/images/books.jpeg'},
    {'title': 'Fashion', 'image': 'assets/images/fashion.jpeg'},
  ];
}
