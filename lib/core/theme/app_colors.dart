import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primary = Color(0xFF4A90E2);
  static const primaryDark = Color(0xFF357ABD);
  static const primaryLight = Color(0xFF68A5E8);

  // Secondary Colors
  static const secondary = Color(0xFF2ECC71);
  static const secondaryDark = Color(0xFF27AE60);
  static const secondaryLight = Color(0xFF82E3AD);

  // Background Colors
  static const background = Color(0xFFF5F6FA);
  static const backgroundDark = Color(0xFF1A1B1E);
  static const cardBackground = Colors.white;
  static const cardBackgroundDark = Color(0xFF2D2E32);

  // Text Colors
  static const textPrimary = Color(0xFF2C3E50);
  static const textSecondary = Color(0xFF7F8C8D);
  static const textLight = Color(0xFFBDC3C7);
  static const textDark = Colors.white;

  // Status Colors
  static const success = Color(0xFF2ECC71);
  static const warning = Color(0xFFF1C40F);
  static const error = Color(0xFFE74C3C);
  static const info = Color(0xFF3498DB);

  // Achievement Colors
  static const bronze = Color(0xFFCD7F32);
  static const silver = Color(0xFFC0C0C0);
  static const gold = Color(0xFFFFD700);

  // Gradient Colors
  static const gradientStart = Color(0xFF4A90E2);
  static const gradientEnd = Color(0xFF357ABD);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [gradientStart, gradientEnd],
  );

  // Social Colors
  static const google = Color(0xFFDB4437);
  static const apple = Color(0xFF000000);

  // Running Status Colors
  static const running = Color(0xFF2ECC71);
  static const paused = Color(0xFFF1C40F);
  static const stopped = Color(0xFFE74C3C);
}
