import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design/cycle_care_design.dart';

class CycleCareTheme {
  const CycleCareTheme._();

  static ThemeData light() => _build(
        brightness: Brightness.light,
        semanticColors: CycleCareSemanticColors.light,
      );

  static ThemeData dark() => _build(
        brightness: Brightness.dark,
        semanticColors: CycleCareSemanticColors.dark,
      );

  static ThemeData _build({
    required Brightness brightness,
    required CycleCareSemanticColors semanticColors,
  }) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme(
      brightness: brightness,
      primary: CycleCareColors.period,
      onPrimary: Colors.white,
      primaryContainer:
          isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
      onPrimaryContainer:
          isDark ? const Color(0xFFFFD8E8) : CycleCareColors.periodStrong,
      secondary: CycleCareColors.fertileStrong,
      onSecondary: Colors.white,
      secondaryContainer:
          isDark ? const Color(0xFF2D3867) : CycleCareColors.fertileSoft,
      onSecondaryContainer:
          isDark ? const Color(0xFFDDE4FF) : const Color(0xFF28356F),
      tertiary: CycleCareColors.warning,
      onTertiary: Colors.white,
      tertiaryContainer:
          isDark ? const Color(0xFF4A3F00) : CycleCareColors.ovulationSoft,
      onTertiaryContainer:
          isDark ? const Color(0xFFFFF1A8) : const Color(0xFF3A3000),
      error: CycleCareColors.error,
      onError: Colors.white,
      errorContainer:
          isDark ? const Color(0xFF5F2020) : const Color(0xFFFFDAD6),
      onErrorContainer:
          isDark ? const Color(0xFFFFDAD6) : const Color(0xFF410002),
      surface: semanticColors.surface,
      onSurface: semanticColors.textPrimary,
      surfaceContainerHighest: semanticColors.surfaceMuted,
      onSurfaceVariant: semanticColors.textSecondary,
      outline: semanticColors.divider,
      outlineVariant: semanticColors.divider,
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface:
          isDark ? CycleCareColors.surface : CycleCareColors.textPrimary,
      onInverseSurface:
          isDark ? CycleCareColors.textPrimary : CycleCareColors.surface,
      inversePrimary:
          isDark ? CycleCareColors.periodStrong : CycleCareColors.prediction,
      surfaceTint: Colors.transparent,
    );
    final base = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: semanticColors.background,
      splashFactory: InkSparkle.splashFactory,
      visualDensity: VisualDensity.standard,
      extensions: [semanticColors],
    );
    final textTheme = CycleCareTypography.textTheme(
      base.textTheme,
      textPrimary: semanticColors.textPrimary,
      textSecondary: semanticColors.textSecondary,
    );
    final overlayStyle = isDark
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: semanticColors.background,
            systemNavigationBarDividerColor: Colors.transparent,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            systemNavigationBarColor: semanticColors.background,
            systemNavigationBarDividerColor: Colors.transparent,
          );

    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: semanticColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: overlayStyle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: semanticColors.surfaceTranslucent,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: BorderSide(color: semanticColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: CycleCareRadius.mediumBorder,
          borderSide: BorderSide(color: semanticColors.divider),
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
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: semanticColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: CycleCareRadius.cardBorder,
          side: BorderSide(color: semanticColors.divider),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: semanticColors.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor:
            isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? (isDark
                    ? const Color(0xFFFFB2D0)
                    : CycleCareColors.periodStrong)
                : semanticColors.textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w700
                : FontWeight.w600,
            color: states.contains(WidgetState.selected)
                ? (isDark
                    ? const Color(0xFFFFB2D0)
                    : CycleCareColors.periodStrong)
                : semanticColors.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: semanticColors.surface,
        indicatorColor:
            isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
        selectedIconTheme: IconThemeData(
          color:
              isDark ? const Color(0xFFFFB2D0) : CycleCareColors.periodStrong,
        ),
        unselectedIconTheme: IconThemeData(color: semanticColors.textSecondary),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color:
              isDark ? const Color(0xFFFFB2D0) : CycleCareColors.periodStrong,
        ),
        unselectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: semanticColors.textSecondary,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          minimumSize: const WidgetStatePropertyAll(Size(48, 52)),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? semanticColors.surfaceMuted
                : states.contains(WidgetState.pressed)
                    ? CycleCareColors.periodStrong
                    : CycleCareColors.period,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.disabled)
                ? semanticColors.textSecondary
                : Colors.white,
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: CycleCareRadius.mediumBorder,
            ),
          ),
          textStyle: WidgetStatePropertyAll(textTheme.labelLarge),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          foregroundColor:
              isDark ? const Color(0xFFFFB2D0) : CycleCareColors.periodStrong,
          side: BorderSide(color: semanticColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: CycleCareRadius.mediumBorder,
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(48, 48),
          foregroundColor:
              isDark ? const Color(0xFFFFB2D0) : CycleCareColors.periodStrong,
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
          backgroundColor: semanticColors.surfaceTranslucent,
          foregroundColor: semanticColors.textPrimary,
          shape: const CircleBorder(),
        ),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: semanticColors.surfaceMuted,
        selectedColor:
            isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
        side: BorderSide(color: semanticColors.divider),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        labelStyle: textTheme.labelMedium,
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: semanticColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: CycleCareRadius.cardBorder,
          side: BorderSide(color: semanticColors.divider),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        modalElevation: 0,
        backgroundColor: semanticColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(CycleCareRadius.sheet),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.onInverseSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: CycleCareRadius.mediumBorder,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: semanticColors.divider,
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: CycleCareColors.period,
        linearTrackColor:
            isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
        circularTrackColor:
            isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: semanticColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: CycleCareRadius.cardBorder,
          side: BorderSide(color: semanticColors.divider),
        ),
        headerBackgroundColor:
            isDark ? const Color(0xFF5B233C) : CycleCareColors.periodSoft,
        headerForegroundColor:
            isDark ? const Color(0xFFFFD8E8) : CycleCareColors.periodStrong,
        dayOverlayColor: WidgetStatePropertyAll(
          CycleCareColors.period.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}
