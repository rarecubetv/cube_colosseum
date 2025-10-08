import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Application theme matching the web app's dark design
/// Uses SF Pro for body text and Poppins for headings
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      // Material 3 with dark brightness
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
        onError: Colors.white,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: AppColors.background,

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.textPrimary,
        ),
      ),

      // Typography (SF Pro Display + Poppins)
      textTheme: const TextTheme(
        // Display styles (Poppins - for branding)
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 48,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.03,
          color: AppColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 36,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.02,
          color: AppColors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.02,
          color: AppColors.textPrimary,
        ),

        // Headline styles (Poppins)
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.02,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.01,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.01,
          color: AppColors.textPrimary,
        ),

        // Title styles (SF Pro)
        titleLarge: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.01,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.textPrimary,
        ),

        // Body styles (SF Pro)
        bodyLarge: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.01,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.01,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.01,
          color: AppColors.textTertiary,
        ),

        // Label styles (SF Pro)
        labelLarge: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.01,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.01,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 11,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.02,
          color: AppColors.textTertiary,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary.withOpacity(0.2),
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppColors.primary.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          minimumSize: const Size(double.infinity, 60),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.02,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          textStyle: const TextStyle(
            fontFamily: 'SF Pro',
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.overlayLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: AppColors.primary.withOpacity(0.5),
            width: 1,
          ),
        ),
        hintStyle: TextStyle(
          color: AppColors.textPrimary.withOpacity(0.3),
          fontSize: 13,
        ),
        contentPadding: const EdgeInsets.all(12),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.overlayDark,
        selectedItemColor: AppColors.iosGreen,
        unselectedItemColor: AppColors.iosGray,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppColors.overlayLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.borderPrimary,
            width: 0.5,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: AppColors.borderPrimary,
        thickness: 0.5,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.primary.withOpacity(0.95),
        contentTextStyle: const TextStyle(
          fontFamily: 'SF Pro',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.borderPrimary,
            width: 1,
          ),
        ),
      ),
    );
  }
}
