import 'package:flutter/material.dart';

class AppColors {
  // Brand Primary & Gradient (Extracted from Aayup Technologies Logo)
  static const Color primary = Color(0xFF0066D6);
  static const Color primaryDark = Color(0xFF004BA8);
  static const Color primaryLight = Color(0xFFE8F1FD);
  static const Color primaryGradientStart = Color(0xFF0072EC);
  static const Color primaryGradientEnd = Color(0xFF0050B3);

  // Accent Colors
  static const Color accentCyan = Color(0xFF00B4D8);
  static const Color accentIndigo = Color(0xFF4F46E5);

  // Neutral Colors (Modern AayupOnes Palette)
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Status & Utility Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color danger = Color(0xFFEF4444);
  static const Color dangerLight = Color(0xFFFEF2F2);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  // Borders & Dividers
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);

  // Primary Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGradientStart, primaryGradientEnd],
  );

  static const LinearGradient heroCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0066D6), Color(0xFF004396)],
  );
}
