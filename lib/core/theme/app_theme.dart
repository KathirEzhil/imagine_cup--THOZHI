import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Soft, empathetic palette
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryPurple = Color(0xFF9B59B6);
  static const Color lightPink = Color(0xFFFFF0F5);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color softGreen = Color(0xFFC8E6C9);
  static const Color darkGreen = Color(0xFF66BB6A);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF424242);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color accentOrange = Color(0xFFFFB74D);
  static const Color accentYellow = Color(0xFFFFEB3B);
  static const Color accentRed = Color(0xFFE57373);
  
  // Burnout Level Colors
  static const Color burnoutLowColor = Color(0xFF4CAF50);
  static const Color burnoutMediumColor = Color(0xFFFF9800);
  static const Color burnoutHighColor = Color(0xFFE57373);
  
  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, primaryPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: lightPink,
      colorScheme: const ColorScheme.light(
        primary: primaryBlue,
        secondary: primaryPurple,
        surface: Colors.white,
        error: accentRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textDark),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textDark),
          titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textDark),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textDark),
          titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textDark),
          bodyLarge: TextStyle(fontSize: 16, color: textDark),
          bodyMedium: TextStyle(fontSize: 14, color: textDark),
          bodySmall: TextStyle(fontSize: 12, color: textLight),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textDark),
          labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textDark),
          labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textLight),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: textDark),
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryPurple,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: primaryPurple, width: 2),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPurple,
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mediumGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mediumGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryPurple, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentRed),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.inter(color: textLight),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
