import 'package:flutter/material.dart';

/// SAWA Design System
/// This file contains the design vision, values, and constants for the SAWA brand

// Design Vision
// "Craftsmanship Meets Innovation: SAWA embodies the perfect balance between
// traditional textile expertise and cutting-edge manufacturing technology,
// delivering premium quality garments with sustainability at our core."

// Brand Values
// 1. Quality Excellence - Uncompromising standards in every stitch
// 2. Sustainable Innovation - Eco-friendly practices that don't sacrifice performance
// 3. Transparency - Clear communication and processes from design to delivery
// 4. Customization - Bespoke solutions tailored to each client's unique needs
// 5. Craftsmanship - Honoring traditional techniques while embracing modern methods

/// Spacing constants
class Spacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
}

/// Border radius constants
class Borders {
  static const double sm = 4.0;
  static const double md = 8.0;
  static const double lg = 12.0;
  static const double xl = 16.0;
  static const double xxl = 24.0;
  static const BorderRadius buttonRadius =
      BorderRadius.all(Radius.circular(md));
  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(lg));
}

/// Animation durations
class Durations {
  static const Duration short = Duration(milliseconds: 150);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration long = Duration(milliseconds: 500);
}

/// Shadows for elevation
class Shadows {
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get medium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get strong => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}

/// Responsive breakpoints
class Breakpoints {
  static const double mobile = 650;
  static const double tablet = 1100;
  static const double desktop = 1500;
}
