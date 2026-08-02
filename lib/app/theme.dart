import 'package:flutter/material.dart';

import 'design/cycle_care_design.dart';

class CycleCareTheme {
  const CycleCareTheme._();

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: CycleCareColors.period,
      onPrimary: Colors.white,
      primaryContainer: CycleCareColors.periodSoft,
      onPrimaryContainer: CycleCareColors.periodStrong,
      secondary: Color(0xFF6A5ACD),
      onSecondary: Colors.white,
      secondaryContainer: CycleCareColors.fertileSoft,
      onSecondaryContainer: Color(0xFF28356F),
      tertiary: CycleCareColors.warning,
      onTertiary: Colors.white,
      tertiaryContainer: CycleCareColors.ovulationSoft,
      onTertiaryContainer: Color(0xFF3A3000),
      error: CycleCareColors.error,
      onError: Colors.white,
      surface: CycleCareColors.surface,
      onSurface: CycleCareColors.textPrimary,
      outline: CycleCareColors.divider,
      outlineVariant: Color(0xFFF6EDF1),
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: CycleCareColors.background,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
    );
    final textTheme = CycleCareTypography.textTheme(base.textTheme);
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: CycleCareColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.92),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: const BorderSide(color: CycleCareColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: const BorderSide(color: CycleCareColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: const BorderSide(color: CycleCareColors.period, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: const BorderSide(color: CycleCareColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: const BorderSide(color: CycleCareColors.error, width: 2),
        ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: CycleCareColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: CycleCareRadius.cardBorder),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        indicatorColor: CycleCareColors.periodSoft,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith((states) => IconThemeData(
              size: 24,
              color: states.contains(WidgetState.selected)
                  ? CycleCareColors.periodStrong
                  : CycleCareColors.textSecondary,
            )),
        labelTextStyle: WidgetStateProperty.resolveWith((states) => TextStyle(
              fontSize: 12,
              fontWeight: states.contains(WidgetState.selected)
                  ? FontWeight.w700
                  : FontWeight.w600,
              color: states.contains(WidgetState.selected)
                  ? CycleCareColors.periodStrong
                  : CycleCareColors.textSecondary,
            )),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: CycleCareColors.periodSoft,
        selectedIconTheme: const IconThemeData(color: CycleCareColors.periodStrong),
        unselectedIconTheme: const IconThemeData(color: CycleCareColors.textSecondary),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: CycleCareColors.periodStrong,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: CycleCareColors.textSecondary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: CycleCareRadius.mediumBorder),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          side: const BorderSide(color: CycleCareColors.divider),
          shape: RoundedRectangleBorder(borderRadius: CycleCareRadius.mediumBorder),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(44, 44),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(CycleCareRadius.small),
            ),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size.square(48),
          backgroundColor: Colors.white.withValues(alpha: 0.76),
          foregroundColor: CycleCareColors.textPrimary,
          shape: const CircleBorder(),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: CycleCareColors.surfaceMuted,
        selectedColor: CycleCareColors.periodSoft,
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        labelStyle: textTheme.labelMedium,
      ),
      dialogTheme: const DialogThemeData(
        elevation: 0,
        backgroundColor: CycleCareColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: CycleCareRadius.cardBorder),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        modalElevation: 0,
        backgroundColor: CycleCareColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(CycleCareRadius.sheet)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: CycleCareColors.textPrimary,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: CycleCareRadius.mediumBorder),
      ),
      dividerTheme: const DividerThemeData(
        color: CycleCareColors.divider,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: CycleCareColors.period,
        linearTrackColor: CycleCareColors.periodSoft,
        circularTrackColor: CycleCareColors.periodSoft,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: CycleCareColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: CycleCareRadius.cardBorder),
        headerBackgroundColor: CycleCareColors.periodSoft,
        headerForegroundColor: CycleCareColors.periodStrong,
        dayOverlayColor: WidgetStatePropertyAll(
          CycleCareColors.period.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}
