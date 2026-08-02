import 'package:flutter/material.dart';

abstract final class CycleCareRadius {
  static const double small = 12;
  static const double medium = 18;
  static const double large = 24;
  static const double card = 26;
  static const double sheet = 30;
  static const double pill = 999;

  static const cardBorder = BorderRadius.all(Radius.circular(card));
  static const mediumBorder = BorderRadius.all(Radius.circular(medium));
}
