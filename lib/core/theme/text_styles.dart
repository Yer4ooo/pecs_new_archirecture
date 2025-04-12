// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:pecs_new_arch/core/constants/app_colors.dart';

class TextStyles {
  static const TextStyle main = TextStyle(
    fontSize: 24.0,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 600),
    ],
    fontFamily: 'Montserrat',
  );

  static const TextStyle highlight = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Montserrat',
    height: 1.5,
  );

  static TextStyle hintStyle = TextStyle(
    fontSize: 14.0,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 400),
    ],
    fontFamily: 'Montserrat',
    color: Colors.black.withOpacity(0.5),
  );

  static const TextStyle montserattText28 = TextStyle(
      fontSize: 28.0,
      fontVariations: [
        FontVariation('ital', 0),
        FontVariation('wght', 600),
      ],
      fontFamily: 'Montserrat',
      color: AppColors.white);

  static const TextStyle montserattText18 = TextStyle(
      fontSize: 18.0,
      fontVariations: [
        FontVariation('ital', 0),
        FontVariation('wght', 400),
      ],
      fontFamily: 'Montserrat',
      color: AppColors.white);

  static const TextStyle montserattText16 = TextStyle(
    fontSize: 16.0,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 600),
    ],
    fontFamily: 'Montserrat',
    color: AppColors.black,
  );

  static const TextStyle montserattText14 = TextStyle(
    fontSize: 14.0,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 400),
    ],
    fontFamily: 'Montserrat',
  );

  static const TextStyle montserattText12 = TextStyle(
    fontSize: 12.0,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 400),
    ],
    fontFamily: 'Montserrat',
  );

  static TextStyle montserattText10 = TextStyle(
    fontSize: 10,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 400),
    ],
    fontFamily: 'Montserrat',
  );

  static const TextStyle montserattText8 = TextStyle(
    fontSize: 8.0,
    fontVariations: [
      FontVariation('ital', 0),
      FontVariation('wght', 400),
    ],
    fontFamily: 'Montserrat',
  );
}
