import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors - Updated from reference images
  static const Color softRose = Color(0xFFD38E9D); // Auth/Profile background
  static const Color dashboardGreen = Color(0xFF99C59B); // Dashboard background
  static const Color darkDashboardGreen = Color(0xFF536958); // Check-in result background
  static const Color accentBlue = Color(0xFF6E85C1); // Primary buttons
  static const Color deepBlue = Color(0xFF485891); // Titles and dark accents
  static const Color logoBlue = Color(0xFF2C3E50);
  static const Color softGrey = Color(0xFFE0E0E0);
  
  static const Color lightPink = Color(0xFFFFF0F5);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);
  static const Color accentRed = Color(0xFFE57373);
  static const Color accentYellow = Color(0xFFFFEB3B);
  
  // Legacy Colors (for backward compatibility)
  static const Color mediumGray = Color(0xFF9E9E9E);
  static const Color primaryPurple = Color(0xFF673AB7);
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkGray = Color(0xFF333333);
  static const Color lightPink_legacy = Color(0xFFFCE4EC);
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF673AB7), Color(0xFF512DA8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Burnout Level Colors
  static const Color burnoutLowColor = Color(0xFF81C784);
  static const Color burnoutMediumColor = Color(0xFFFFB74D);
  static const Color burnoutHighColor = Color(0xFFE57373);
  
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: accentBlue,
      scaffoldBackgroundColor: softRose, // Default to registration color
      colorScheme: const ColorScheme.light(
        primary: accentBlue,
        secondary: deepBlue,
        surface: Colors.white,
        error: accentRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textDark,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.outfitTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
          displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
          displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textDark),
          headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: textDark),
          headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: textDark),
          headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: textDark),
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: deepBlue),
          titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textDark),
          bodyLarge: TextStyle(fontSize: 16, color: textDark),
          bodyMedium: TextStyle(fontSize: 14, color: textDark),
          bodySmall: TextStyle(fontSize: 12, color: textLight),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentBlue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: deepBlue.withOpacity(0.8),
          minimumSize: const Size(double.infinity, 44),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide.none,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: softGrey.withOpacity(0.8),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
