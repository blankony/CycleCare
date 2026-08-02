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
