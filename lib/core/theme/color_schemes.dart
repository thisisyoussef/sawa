import 'package:flutter/material.dart';

// Minimalist, modern brand colors
const primaryColor = Color(0xFF212121); // Almost black for primary
const secondaryColor = Color(0xFFE0E0E0); // Light gray as accent
const accentColor = Color(0xFF757575); // Medium gray

// Surface colors
const surfaceLightColor = Color(0xFFFAFAFA);
const surfaceDarkColor = Color(0xFF121212);

const ColorScheme lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: Colors.white,
  secondary: secondaryColor,
  onSecondary: primaryColor,
  error: Color(0xFFE53935),
  onError: Colors.white,
  background: surfaceLightColor,
  onBackground: primaryColor,
  surface: Colors.white,
  onSurface: primaryColor,
);

const ColorScheme darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.white,
  onPrimary: primaryColor,
  secondary: secondaryColor,
  onSecondary: primaryColor,
  error: Color(0xFFEF5350),
  onError: Colors.white,
  background: surfaceDarkColor,
  onBackground: Colors.white,
  surface: Color(0xFF1E1E1E),
  onSurface: Colors.white,
);
