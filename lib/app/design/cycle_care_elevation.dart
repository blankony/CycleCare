import 'package:flutter/material.dart';

abstract final class CycleCareElevation {
  static const List<BoxShadow> none = [];

  static List<BoxShadow> overlay(Brightness brightness) => [
        BoxShadow(
          color: brightness == Brightness.dark
              ? const Color(0x3D000000)
              : const Color(0x120F172A),
          blurRadius: 18,
          offset: const Offset(0, 6),
        ),
      ];
}
