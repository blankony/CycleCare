import 'package:flutter/material.dart';

abstract final class CycleCareColors {
  static const deepNavy = Color(0xFF03045E);
  static const classicBlue = Color(0xFF0077B6);
  static const oceanBlue = Color(0xFF00B4D8);
  static const skyBlue = Color(0xFF90E0EF);
  static const iceBlue = Color(0xFFCAF0F8);

  static const period = classicBlue;
  static const periodStrong = deepNavy;
  static const periodSoft = iceBlue;
  static const fertile = skyBlue;
  static const fertileStrong = classicBlue;
  static const fertileSoft = iceBlue;
  static const ovulation = oceanBlue;
  static const ovulationSoft = Color(0xFFE0F7FD);
  static const prediction = oceanBlue;
  static const predictionSoft = iceBlue;
  static const peach = Color(0xFFFFD8BD);

  static const background = Color(0xFFF8FDFF);
  static const backgroundBlue = iceBlue;
  static const surface = Colors.white;
  static const surfaceMuted = iceBlue;
  static const textPrimary = deepNavy;
  static const textSecondary = Color(0xFF3A5A7A);
  static const divider = skyBlue;
  static const success = Color(0xFF2E7D5B);
  static const warning = Color(0xFF8A5A00);
  static const error = Color(0xFFBA1A1A);
  static const disabled = Color(0xFF8AA0B5);

  static const darkBackground = Color(0xFF0A1030);
  static const darkBackgroundMiddle = Color(0xFF12204A);
  static const darkBackgroundBlue = Color(0xFF0F2A3F);
  static const darkSurface = Color(0xFF162040);
  static const darkSurfaceMuted = Color(0xFF1C2E55);
  static const darkTextPrimary = Color(0xFFEFF8FF);
  static const darkTextSecondary = Color(0xFFB8D4EA);
  static const darkDivider = Color(0xFF2A4A6A);

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8FDFF),
      Colors.white,
      Color(0xFFCAF0F8),
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
    backgroundMiddle: Colors.white,
    backgroundBlue: CycleCareColors.iceBlue,
    surface: Colors.white,
    surfaceMuted: CycleCareColors.iceBlue,
    surfaceTranslucent: Color(0xF2FFFFFF),
    textPrimary: CycleCareColors.deepNavy,
    textSecondary: CycleCareColors.textSecondary,
    divider: CycleCareColors.skyBlue,
  );

  static const dark = CycleCareSemanticColors(
    background: CycleCareColors.darkBackground,
    backgroundMiddle: CycleCareColors.darkBackgroundMiddle,
    backgroundBlue: CycleCareColors.darkBackgroundBlue,
    surface: CycleCareColors.darkSurface,
    surfaceMuted: CycleCareColors.darkSurfaceMuted,
    surfaceTranslucent: Color(0xF2162040),
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
