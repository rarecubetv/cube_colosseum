import 'package:flutter/material.dart';

/// Application color palette matching the web app design
/// Primary color: #22c55e (Green)
/// Background: #000000 (Black)
class AppColors {
  // Primary Color Palette (Green)
  static const Color primary = Color(0xFF22C55E);
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primaryDark = Color(0xFF10B981);
  static const Color primaryAccent = Color(0xFF059669);

  // Background Colors
  static const Color background = Color(0xFF000000); // Pure black
  static const Color surface = Color(0xFF0A0A0A); // Slightly lighter black
  static const Color surfaceVariant = Color(0xFF0E182C); // Secondary gradient color

  // Secondary Colors
  static const Color secondary = Color(0xFF0B1221);
  static const Color secondaryLight = Color(0xFF1E293B);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF); // White
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% opacity
  static const Color textTertiary = Color(0x80FFFFFF); // 50% opacity
  static const Color textDisabled = Color(0x4DFFFFFF); // 30% opacity

  // Border Colors
  static Color borderPrimary = Colors.white.withOpacity(0.1);
  static Color borderSecondary = Colors.white.withOpacity(0.05);
  static Color borderAccent = primary.withOpacity(0.3);

  // Overlay Colors
  static Color overlayLight = Colors.white.withOpacity(0.08);
  static Color overlayMedium = Colors.white.withOpacity(0.12);
  static Color overlayDark = Colors.black.withOpacity(0.85);

  // Shimmer/Loading Colors
  static Color shimmerBase = Colors.white.withOpacity(0.03);
  static Color shimmerHighlight = Colors.white.withOpacity(0.06);

  // Social Colors
  static const Color twitter = Color(0xFF1DA1F2);
  static const Color discord = Color(0xFF5865F2);
  static const Color telegram = Color(0xFF0088CC);

  // Chain Colors (for wallet badges)
  static const Color ethereum = Color(0xFF627EEA);
  static const Color solana = Color(0xFF14F195);
  static const Color polygon = Color(0xFF8247E5);
  static const Color bitcoin = Color(0xFFF7931A);

  // Notification Badge
  static const Color notificationBadge = Color(0xFFFF3B30);

  // iOS Green (for bottom nav active state)
  static const Color iosGreen = Color(0xFF34C759);
  static const Color iosGray = Color(0xFFA7A7A7);
}
