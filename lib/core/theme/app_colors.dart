import 'package:flutter/material.dart';

/// Brand palette for the habit tracker.
///
/// The look is a warm, minimal, editorial monochrome: a soft warm-white
/// canvas, pure white surfaces and near-black ink for text.
abstract final class AppColors {
  static const Color seed = Color(0xFF141414);
  static const Color primary = Color(0xFF141414);
  static const Color primaryDark = Color(0xFF000000);
  static const Color accent = Color(0xFF8A8377);
  static const Color points = Color(0xFF141414);
  static const Color background = Color(0xFFFAF7F2);
  static const Color surface = Colors.white;
  static const Color surfaceMuted = Color(0xFFF3EEE6);
  static const Color success = Color(0xFF141414);
  static const Color danger = Color(0xFFB3261E);

  /// Text colours, from strongest to faintest.
  static const Color ink = Color(0xFF141414);
  static const Color inkSoft = Color(0xFF6E6960);
  static const Color inkFaint = Color(0xFFA39C91);

  /// Hairline borders and dividers.
  static const Color line = Color(0xFFECE5DB);
}

/// Spacing scale used across the app for consistent rhythm.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Corner radii used across the app.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double pill = 999;
}

/// Maximum content width so layouts stay readable on tablets and desktop.
const double kMaxContentWidth = 640;
