import 'dart:ui';
import 'dart:math' as math;

/// WCAG contrast ratio calculator
/// Used for validating color accessibility in card customization
class ContrastCalculator {
  /// Calculate WCAG contrast ratio between two colors
  /// Returns ratio between 1:1 (no contrast) and 21:1 (maximum contrast)
  static double getContrastRatio(Color color1, Color color2) {
    final luminance1 = _getLuminance(color1);
    final luminance2 = _getLuminance(color2);

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Get relative luminance of a color
  static double _getLuminance(Color color) {
    final r = _normalizeChannel(color.red / 255.0);
    final g = _normalizeChannel(color.green / 255.0);
    final b = _normalizeChannel(color.blue / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Normalize color channel for luminance calculation
  static double _normalizeChannel(double channel) {
    if (channel <= 0.03928) {
      return channel / 12.92;
    } else {
      return ((channel + 0.055) / 1.055).pow(2.4);
    }
  }

  /// Get WCAG compliance level for contrast ratio
  /// Returns 'AAA', 'AA', or 'Fail'
  static String getWCAGLevel(double ratio) {
    if (ratio >= 7.0) {
      return 'AAA';
    } else if (ratio >= 4.5) {
      return 'AA';
    } else {
      return 'Fail';
    }
  }

  /// Check if contrast ratio meets WCAG AA standard
  static bool meetsWCAGAA(double ratio) {
    return ratio >= 4.5;
  }

  /// Check if contrast ratio meets WCAG AAA standard
  static bool meetsWCAGAAA(double ratio) {
    return ratio >= 7.0;
  }
}

extension on double {
  double pow(double exponent) {
    return math.pow(this, exponent).toDouble();
  }
}
