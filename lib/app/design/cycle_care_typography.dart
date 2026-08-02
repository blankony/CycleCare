import 'package:flutter/material.dart';

import 'cycle_care_colors.dart';

abstract final class CycleCareTypography {
  static TextTheme textTheme(TextTheme base) => base.copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontSize: 50,
          height: 1.04,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.4,
          color: CycleCareColors.textPrimary,
        ),
        displayMedium: base.displayMedium?.copyWith(
          fontSize: 38,
          height: 1.08,
          fontWeight: FontWeight.w800,
          letterSpacing: -1,
          color: CycleCareColors.textPrimary,
        ),
        headlineLarge: base.headlineLarge?.copyWith(
          fontSize: 30,
          height: 1.15,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: CycleCareColors.textPrimary,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          fontSize: 26,
          height: 1.18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.4,
          color: CycleCareColors.textPrimary,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontSize: 22,
          height: 1.22,
          fontWeight: FontWeight.w700,
          color: CycleCareColors.textPrimary,
        ),
        titleLarge: base.titleLarge?.copyWith(
          fontSize: 21,
          height: 1.25,
          fontWeight: FontWeight.w700,
          color: CycleCareColors.textPrimary,
        ),
        titleMedium: base.titleMedium?.copyWith(
          fontSize: 17,
          height: 1.35,
          fontWeight: FontWeight.w700,
          color: CycleCareColors.textPrimary,
        ),
        bodyLarge: base.bodyLarge?.copyWith(
          fontSize: 16,
          height: 1.55,
          color: CycleCareColors.textPrimary,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontSize: 14,
          height: 1.5,
          color: CycleCareColors.textSecondary,
        ),
        bodySmall: base.bodySmall?.copyWith(
          fontSize: 12.5,
          height: 1.45,
          color: CycleCareColors.textSecondary,
        ),
        labelLarge: base.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.1,
        ),
        labelMedium: base.labelMedium?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
        ),
      );
}
