import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // --- COLOR PALETTE ---
  static const Color _primaryColor = Color(0xFF2563EB); // A professional, muted blue
  static const Color _backgroundColor = Color(0xFFF9FAFB); // Light gray for backgrounds
  static const Color _surfaceColor = Colors.white;
  static const Color _textColor = Color(0xFF111827); // Dark gray for primary text
  static const Color _secondaryTextColor = Color(0xFF4B5563); // Muted gray for subtitles

  // --- TEXT THEME ---
  static final TextTheme _textTheme = TextTheme(
    displayLarge: GoogleFonts.inter(fontSize: 57, fontWeight: FontWeight.bold, color: _textColor),
    headlineMedium: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: _textColor),
    headlineSmall: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w600, color: _textColor),
    titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: _textColor),
    titleMedium: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500, color: _textColor),
    titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: _textColor),
    bodyLarge: GoogleFonts.inter(fontSize: 16, color: _textColor),
    bodyMedium: GoogleFonts.inter(fontSize: 14, color: _secondaryTextColor),
    labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
  );

  // --- MAIN THEME DATA ---
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: _primaryColor,
    scaffoldBackgroundColor: _backgroundColor,
    textTheme: _textTheme,
    colorScheme: const ColorScheme.light(
      primary: _primaryColor,
      secondary: _primaryColor,
      surface: _surfaceColor,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: _textColor,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: _backgroundColor,
      foregroundColor: _textColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: _textTheme.titleLarge?.copyWith(fontSize: 18),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: _primaryColor, width: 2),
      ),
      labelStyle: _textTheme.bodyMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: _textTheme.labelLarge,
      ),
    ),
  );
}
