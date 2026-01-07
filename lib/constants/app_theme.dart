import 'package:flutter/material.dart';
import 'app_constants.dart';

class AppTheme {
  // Light Theme Colors
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightSurfaceColor = Color(0xFFE0E0E0);
  static const Color lightTextPrimaryColor = Color(0xFF212121);
  static const Color lightTextSecondaryColor = Color(0xFF757575);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackgroundColor,
      primaryColor: AppConstants.gridSuccessColor,
      fontFamily: 'Courier',

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBackgroundColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: lightTextPrimaryColor,
        titleTextStyle: TextStyle(
          color: lightTextPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        iconTheme: IconThemeData(
          color: lightTextPrimaryColor,
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: lightTextPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        displayMedium: TextStyle(
          color: lightTextPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        displaySmall: TextStyle(
          color: lightTextPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        headlineMedium: TextStyle(
          color: lightTextPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Courier',
        ),
        bodyLarge: TextStyle(
          color: lightTextPrimaryColor,
          fontSize: 16,
          fontFamily: 'Courier',
        ),
        bodyMedium: TextStyle(
          color: lightTextSecondaryColor,
          fontSize: 14,
          fontFamily: 'Courier',
        ),
        bodySmall: TextStyle(
          color: lightTextSecondaryColor,
          fontSize: 12,
          fontFamily: 'Courier',
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.gridSuccessColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(
            color: AppConstants.gridSuccessColor,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: lightTextSecondaryColor,
          fontFamily: 'Courier',
        ),
        hintStyle: const TextStyle(
          color: lightTextSecondaryColor,
          fontFamily: 'Courier',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: lightSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightTextPrimaryColor,
        contentTextStyle: const TextStyle(
          color: Colors.white,
          fontFamily: 'Courier',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: lightBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),

      colorScheme: const ColorScheme.light(
        primary: AppConstants.gridSuccessColor,
        secondary: AppConstants.gridPendingColor,
        surface: lightSurfaceColor,
        error: AppConstants.gridFailColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppConstants.backgroundColor,
      primaryColor: AppConstants.gridSuccessColor,
      fontFamily: 'Courier',

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        displayMedium: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        displaySmall: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Courier',
        ),
        headlineMedium: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Courier',
        ),
        bodyLarge: TextStyle(
          color: AppConstants.textPrimaryColor,
          fontSize: 16,
          fontFamily: 'Courier',
        ),
        bodyMedium: TextStyle(
          color: AppConstants.textSecondaryColor,
          fontSize: 14,
          fontFamily: 'Courier',
        ),
        bodySmall: TextStyle(
          color: AppConstants.textSecondaryColor,
          fontSize: 12,
          fontFamily: 'Courier',
        ),
      ),

      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppConstants.gridSuccessColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.largePadding,
            vertical: AppConstants.defaultPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Courier',
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppConstants.gridEmptyColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          borderSide: const BorderSide(
            color: AppConstants.gridSuccessColor,
            width: 2,
          ),
        ),
        labelStyle: const TextStyle(
          color: AppConstants.textSecondaryColor,
          fontFamily: 'Courier',
        ),
        hintStyle: const TextStyle(
          color: AppConstants.textSecondaryColor,
          fontFamily: 'Courier',
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: AppConstants.gridEmptyColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),

      // Snackbar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppConstants.gridEmptyColor,
        contentTextStyle: const TextStyle(
          color: AppConstants.textPrimaryColor,
          fontFamily: 'Courier',
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppConstants.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: AppConstants.gridSuccessColor,
        secondary: AppConstants.gridPendingColor,
        surface: AppConstants.gridEmptyColor,
        error: AppConstants.gridFailColor,
      ),
    );
  }
}
