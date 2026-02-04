import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static TextStyle useGoogleFont(
    Color color,
    double size,
    FontWeight fontWeight,
  ) {
    return GoogleFonts.inter(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }

  static TextStyle useNeoSans(Color color, double size, FontWeight fontWeight) {
    return TextStyle(
      fontFamily: 'Neo Sans Std',
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }
}

class AppStyle2 {
  static TextStyle useGoogleFont(
    Color color,
    double size,
    FontWeight fontWeight, {
    TextDecoration decoration = TextDecoration.none,
    Color? decorationColor,
  }) {
    return GoogleFonts.inter(
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
      decoration: decoration,
      decorationColor: decorationColor,
    );
  }

  static TextStyle useNeoSans(Color color, double size, FontWeight fontWeight) {
    return TextStyle(
      fontFamily: 'Neo Sans Std',
      color: color,
      fontSize: size,
      fontWeight: fontWeight,
    );
  }
}
