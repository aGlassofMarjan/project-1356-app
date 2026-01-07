import 'package:flutter/material.dart';

class AppConstants {
  // Total number of days in the project
  static const int totalDays = 1356;

  // The "Purist" start date
  static final DateTime puristStartDate = DateTime(2026, 1, 7);

  // Grid colors
  static const Color backgroundColor = Color(0xFF121212);
  static const Color gridEmptyColor = Color(0xFF333333);
  static const Color gridSuccessColor = Color(0xFF10B981);
  static const Color gridFailColor = Color(0xFFEF4444);
  static const Color gridPendingColor = Color(0xFFFF8C00); // Orange
  static const Color gridFutureColor = Color(0xFF555555);

  // Text colors
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFB0B0B0);
  static const Color textAccentColor = Color(0xFF10B981);

  // Notification times
  static const int morningNotificationHour = 10;
  static const int morningNotificationMinute = 0;
  static const int eveningNotificationHour = 21;
  static const int eveningNotificationMinute = 0;

  // Grid settings
  static const int gridCrossAxisCount = 26; // Number of columns
  static const double gridSpacing = 2.0;
  static const double gridItemSize = 12.0;

  // Typography
  static const String fontFamily = 'monospace';

  // Padding and spacing
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  // Border radius
  static const double defaultBorderRadius = 8.0;
  static const double smallBorderRadius = 4.0;

  // Animation durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
