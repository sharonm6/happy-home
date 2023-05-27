import 'package:flutter/material.dart';

Color hexToColor(String hex) {
  assert(RegExp(r'^#([0-9a-fA-F]{6})|([0-9a-fA-F]{8})$').hasMatch(hex),
      'hex color must be #rrggbb or #rrggbbaa');

  return Color(
    int.parse(hex.substring(1), radix: 16) +
        (hex.length == 7 ? 0xff000000 : 0x00000000),
  );
}

class ColorConstants {
  static Color happyhomeBrownLight = hexToColor('#edc798');
  static Color happyhomeBrown = hexToColor('#8a624a');
  static Color happyhomeBrownDark = hexToColor('#634836');

  static Color happyhomeBlueLight = hexToColor('#7FDFFF');
  static Color happyhomeBlueLighter = hexToColor('#e6f6f7');
  static Color happyhomeBlue = hexToColor('#2C5975');
  static Color happyhomeBlueDark = hexToColor('#c9ebc6');    //946d51);   //173753

  static Color happyhomeGreenLight = hexToColor('#C9EBC6');

  static Color happyhomePurpleLight = hexToColor('#B0B7F7');

  static Color happyhomeOffWhite = hexToColor('#f0f0f0');

  static Color happyhomeGreyLight = hexToColor('#f0f5f5');
}
