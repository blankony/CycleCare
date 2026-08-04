import 'package:flutter/material.dart';

abstract final class CycleCareColors {
  static const period = Color(0xFFBE185D);
  static const periodStrong = Color(0xFF9D174D);
  static const periodSoft = Color(0xFFFCE7F3);
  static const fertile = Color(0xFFB9C9FA);
  static const fertileStrong = Color(0xFF4C5FA8);
  static const fertileSoft = Color(0xFFEEF2FF);
  static const ovulation = Color(0xFFE6CE00);
  static const ovulationSoft = Color(0xFFFFF8CC);
  static const prediction = Color(0xFFF5A9D3);
  static const predictionSoft = Color(0xFFFFE8F4);
  static const peach = Color(0xFFFFD8BD);

  static const background = Color(0xFFFFF7FA);
  static const backgroundBlue = Color(0xFFF4F7FF);
  static const surface = Color(0xFFFFFCFD);
  static const surfaceMuted = Color(0xFFFBF1F5);
  static const textPrimary = Color(0xFF171318);
  static const textSecondary = Color(0xFF625B64);
  static const divider = Color(0xFFF0E4EA);
  static const success = Color(0xFF2E7D5B);
  static const warning = Color(0xFF8A5A00);
  static const error = Color(0xFFBA1A1A);
  static const disabled = Color(0xFF9A929B);

  static const darkBackground = Color(0xFF1B1519);
  static const darkBackgroundMiddle = Color(0xFF21181D);
  static const darkBackgroundBlue = Color(0xFF171B27);
  static const darkSurface = Color(0xFF261E23);
  static const darkSurfaceMuted = Color(0xFF30242B);
  static const darkTextPrimary = Color(0xFFFFF7FA);
  static const darkTextSecondary = Color(0xFFD7C8D0);
  static const darkDivider = Color(0xFF4A3942);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF7FA),
      Color(0xFFFFF9F4),
      Color(0xFFF4F7FF),
    ],
    stops: [0, 0.48, 1],
  );
}

@immutable
class CycleCareSemanticColors extends ThemeExtension<CycleCareSemanticColors> {
  const CycleCareSemanticColors({
    required this.background,
    required this.backgroundMiddle,
    required this.backgroundBlue,
    required this.surface,
    required this.surfaceMuted,
    required this.surfaceTranslucent,
    required this.textPrimary,
    required this.textSecondary,
    required this.divider,
  });

  static const light = CycleCareSemanticColors(
    background: CycleCareColors.background,
    backgroundMiddle: Color(0xFFFFF9F4),
    backgroundBlue: CycleCareColors.backgroundBlue,
    surface: CycleCareColors.surface,
    surfaceMuted: CycleCareColors.surfaceMuted,
    surfaceTranslucent: Color(0xF2FFFFFF),
    textPrimary: CycleCareColors.textPrimary,
    textSecondary: CycleCareColors.textSecondary,
    divider: CycleCareColors.divider,
  );

  static const dark = CycleCareSemanticColors(
    background: CycleCareColors.darkBackground,
    backgroundMiddle: CycleCareColors.darkBackgroundMiddle,
    backgroundBlue: CycleCareColors.darkBackgroundBlue,
    surface: CycleCareColors.darkSurface,
    surfaceMuted: CycleCareColors.darkSurfaceMuted,
    surfaceTranslucent: Color(0xF2261E23),
    textPrimary: CycleCareColors.darkTextPrimary,
    textSecondary: CycleCareColors.darkTextSecondary,
    divider: CycleCareColors.darkDivider,
  );

  final Color background;
  final Color backgroundMiddle;
  final Color backgroundBlue;
  final Color surface;
  final Color surfaceMuted;
  final Color surfaceTranslucent;
  final Color textPrimary;
  final Color textSecondary;
  final Color divider;

  LinearGradient get backgroundGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [background, backgroundMiddle, backgroundBlue],
        stops: const [0, 0.48, 1],
      );

  @override
  CycleCareSemanticColors copyWith({
    Color? background,
    Color? backgroundMiddle,
    Color? backgroundBlue,
    Color? surface,
    Color? surfaceMuted,
    Color? surfaceTranslucent,
    Color? textPrimary,
    Color? textSecondary,
    Color? divider,
  }) =>
      CycleCareSemanticColors(
        background: background ?? this.background,
        backgroundMiddle: backgroundMiddle ?? this.backgroundMiddle,
        backgroundBlue: backgroundBlue ?? this.backgroundBlue,
        surface: surface ?? this.surface,
        surfaceMuted: surfaceMuted ?? this.surfaceMuted,
        surfaceTranslucent: surfaceTranslucent ?? this.surfaceTranslucent,
        textPrimary: textPrimary ?? this.textPrimary,
        textSecondary: textSecondary ?? this.textSecondary,
        divider: divider ?? this.divider,
      );

  @override
  CycleCareSemanticColors lerp(
    covariant CycleCareSemanticColors? other,
    double t,
  ) {
    if (other == null) return this;
    return CycleCareSemanticColors(
      background: Color.lerp(background, other.background, t)!,
      backgroundMiddle:
          Color.lerp(backgroundMiddle, other.backgroundMiddle, t)!,
      backgroundBlue: Color.lerp(backgroundBlue, other.backgroundBlue, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
      surfaceTranslucent:
          Color.lerp(surfaceTranslucent, other.surfaceTranslucent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}

extension CycleCareThemeColors on BuildContext {
  CycleCareSemanticColors get cycleCareColors =>
      Theme.of(this).extension<CycleCareSemanticColors>() ??
      CycleCareSemanticColors.light;
}
