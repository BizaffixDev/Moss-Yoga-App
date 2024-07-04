import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color gray700 = fromHex('#686d43');

  static Color gray400 = fromHex('#c4c4bc');

  static Color gray20075 = fromHex('#75efefef');

  static Color gray800 = fromHex('#51563f');

  static Color gray900 = fromHex('#202526');

  static Color blueGray700 = fromHex('#525252');

  static Color gray80001 = fromHex('#474e30');

  static Color black9003f = fromHex('#3f000000');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray300 = fromHex('#e5e5e5');

  static Color whiteA70070 = fromHex('#70ffffff');

  static Color gray70001 = fromHex('#5b5b5b');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
