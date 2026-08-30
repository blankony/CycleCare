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
      primary: CycleCareColors.classicBlue,
      onPrimary: Colors.white,
      primaryContainer: CycleCareColors.iceBlue,
      onPrimaryContainer: CycleCareColors.deepNavy,
      secondary: CycleCareColors.oceanBlue,
      onSecondary: Colors.white,
      secondaryContainer:
          isDark ? const Color(0xFF0F3A5A) : const Color(0xFFE0F7FD),
      onSecondaryContainer:
          isDark ? const Color(0xFFCAF0F8) : CycleCareColors.deepNavy,
      tertiary: CycleCareColors.warning,
      onTertiary: Colors.white,
      tertiaryContainer:
          isDark ? const Color(0xFF4A3F00) : const Color(0xFFFFF8CC),
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
          isDark ? Colors.white : CycleCareColors.deepNavy,
      onInverseSurface:
          isDark ? CycleCareColors.deepNavy : Colors.white,
      inversePrimary: CycleCareColors.skyBlue,
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
        backgroundColor: semanticColors.background,
        foregroundColor: semanticColors.textPrimary,
        surfaceTintColor: semanticColors.background,
        shadowColor: Colors.transparent,
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
          borderSide:
              const BorderSide(color: CycleCareColors.classicBlue, width: 2),
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
            isDark ? const Color(0xFF123A5A) : CycleCareColors.iceBlue,
        indicatorShape: const StadiumBorder(),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            size: 24,
            color: states.contains(WidgetState.selected)
                ? CycleCareColors.classicBlue
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
                ? CycleCareColors.deepNavy
                : semanticColors.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: semanticColors.surface,
        indicatorColor:
            isDark ? const Color(0xFF123A5A) : CycleCareColors.iceBlue,
        selectedIconTheme: const IconThemeData(
          color: CycleCareColors.classicBlue,
        ),
        unselectedIconTheme: IconThemeData(color: semanticColors.textSecondary),
        selectedLabelTextStyle: textTheme.labelLarge?.copyWith(
          color: CycleCareColors.deepNavy,
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
                    ? CycleCareColors.deepNavy
                    : CycleCareColors.classicBlue,
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
          foregroundColor: CycleCareColors.classicBlue,
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
          foregroundColor: CycleCareColors.classicBlue,
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
        selectedColor: CycleCareColors.iceBlue,
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
        color: CycleCareColors.oceanBlue,
        linearTrackColor: CycleCareColors.iceBlue,
        circularTrackColor: CycleCareColors.iceBlue,
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: semanticColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: CycleCareRadius.cardBorder,
          side: BorderSide(color: semanticColors.divider),
        ),
        headerBackgroundColor: CycleCareColors.iceBlue,
        headerForegroundColor: CycleCareColors.deepNavy,
        dayOverlayColor: WidgetStatePropertyAll(
          CycleCareColors.oceanBlue.withValues(alpha: 0.12),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return Colors.white;
          return null;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return CycleCareColors.classicBlue;
          }
          return null;
        }),
        trackOutlineColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent;
          }
          return semanticColors.divider;
        }),
      ),
    );
  }
}
