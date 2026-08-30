import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class CycleCareTypography {
  static TextTheme _withFamily(TextTheme base) =>
      GoogleFonts.plusJakartaSansTextTheme(base);

  static TextTheme textTheme(
    TextTheme base, {
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final sourced = _withFamily(base);
    return sourced.copyWith(
      displayLarge: sourced.displayLarge?.copyWith(
        fontSize: 50,
        height: 1.04,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.4,
        color: textPrimary,
      ),
      displayMedium: sourced.displayMedium?.copyWith(
        fontSize: 38,
        height: 1.08,
        fontWeight: FontWeight.w700,
        letterSpacing: -1,
        color: textPrimary,
      ),
      headlineLarge: sourced.headlineLarge?.copyWith(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: textPrimary,
      ),
      headlineMedium: sourced.headlineMedium?.copyWith(
        fontSize: 26,
        height: 1.18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
        color: textPrimary,
      ),
      headlineSmall: sourced.headlineSmall?.copyWith(
        fontSize: 22,
        height: 1.22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: textPrimary,
      ),
      titleLarge: sourced.titleLarge?.copyWith(
        fontSize: 21,
        height: 1.25,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
        color: textPrimary,
      ),
      titleMedium: sourced.titleMedium?.copyWith(
        fontSize: 17,
        height: 1.35,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: sourced.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
      bodyLarge: sourced.bodyLarge?.copyWith(
        fontSize: 16,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      bodyMedium: sourced.bodyMedium?.copyWith(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      bodySmall: sourced.bodySmall?.copyWith(
        fontSize: 12.5,
        height: 1.45,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      ),
      labelLarge: sourced.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: textPrimary,
      ),
      labelMedium: sourced.labelMedium?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: textSecondary,
      ),
      labelSmall: sourced.labelSmall?.copyWith(
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        color: textSecondary,
      ),
    );
  }
}
