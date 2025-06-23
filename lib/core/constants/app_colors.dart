import 'dart:math';

import 'package:flutter/material.dart';

class AppColors {
  /// Primary Color - 0xFF3A7D44
  static Color primary(BuildContext context) => Theme.of(context).primaryColor;

  /// Primary Light Color - 0xFF1F8EC
  static Color primaryLight(BuildContext context) =>
      Theme.of(context).primaryColorLight;

  static const Color backgroundColor = Color(0xffF6F6F6);

  /// Gray Color - 0xFF878882
  static const Color gray = Color(0xFF686868);

  /// Error Color - 0xFFD41900
  static const Color error = Color(0xFFD41900);

  /// Black Color - 0xFF1C1C1C
  static const Color black = Color(0xFF1C1C1C);

  /// White Color - 0xFF1C1C1C
  static const Color white = Color(0xFFFFFFFF);

  /// Blue Color - 0xFF9ABEED
  static const Color openBlue = Color(0xFF9ABEED);

  // Dark Green Color - 0xFF006400
  static const Color darkGreen = Color(0xFF619451);

  static const Color senderMessageColor = Color(0xFFF1F1F1);

  static const Color baseColorShimmer = Color(0xFFE0E0E0);
  static const Color highlightColorShimmer = Color(0xFFF5F5F5);
    static const Color green = Color(0xFF0A8601);
  static const Color red = Color(0xFF860101);
  static const Color beige = Color(0xFF865101);





}
List<Color> opcColors = [AppColors.green, AppColors.red, AppColors.beige];
int? lastIndex;

Color getRandomColor() {
  Random random = Random();
  int newIndex;

  do {
    newIndex = random.nextInt(opcColors.length);
  } while (newIndex == lastIndex); // Ensure it is not the same as the last one

  lastIndex = newIndex;
  return opcColors[newIndex];
}