import 'package:flutter/material.dart';
import 'color_schemes.dart';
import 'text_themes.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: surfaceLightColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        side: const BorderSide(width: 1),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: const CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Color(0xFFEEEEEE), width: 1),
      ),
      color: Colors.white,
      shadowColor: Colors.transparent,
    ),
    dividerTheme: const DividerThemeData(
      space: 1,
      thickness: 1,
      color: Color(0xFFEEEEEE),
    ),
    iconTheme: const IconThemeData(
      color: primaryColor,
      size: 24,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: surfaceDarkColor,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.transparent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        side: BorderSide(width: 1, color: Colors.white.withOpacity(0.3)),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      color: const Color(0xFF1E1E1E),
      shadowColor: Colors.transparent,
    ),
    dividerTheme: DividerThemeData(
      space: 1,
      thickness: 1,
      color: Colors.white.withOpacity(0.1),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
  );
}
 